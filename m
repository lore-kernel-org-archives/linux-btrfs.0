Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750917AbdAQPku (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 10:40:50 -0500
Date: Tue, 17 Jan 2017 16:40:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: cmds-check.c: supports inode nbytes fix
 in lowmem
Message-ID: <20170117154031.GT12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170109053808.1979-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170109053808.1979-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have some comments, see below.

On Mon, Jan 09, 2017 at 01:38:07PM +0800, Su Yue wrote:
> Added 'repair_inode_item' which dispatches functions such as
> 'repair_inode__nbytes_lowmem' to correct errors and
> 'struct inode_item_fix_info' to store correct values and errors.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 161 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 152 insertions(+), 9 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 1dba298..567ca80 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -371,6 +371,17 @@ struct root_item_info {
>  };
>  
>  /*
> + * Use inode_item_fix_info as function check_inode_item's arg.
> + */
> +struct inode_item_fix_info {
> +	u64 ino;
> +	u64 isize;
> +	u64 nbytes;
> +
> +	int err;
> +};
> +
> +/*
>   * Error bit for low memory mode check.
>   *
>   * Currently no caller cares about it yet.  Just internal use for error
> @@ -1866,13 +1877,16 @@ struct node_refs {
>  static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
>  			     struct node_refs *nrefs, u64 level);
>  static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
> -			    unsigned int ext_ref);
> -
> +			    unsigned int ext_ref,
> +			    struct inode_item_fix_info *info);
> +static int repair_inode_item(struct btrfs_root *root,
> +			     struct inode_item_fix_info *info);
>  static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
>  			       struct node_refs *nrefs, int *level, int ext_ref)
>  {
>  	struct extent_buffer *cur = path->nodes[0];
>  	struct btrfs_key key;
> +	struct inode_item_fix_info info;
>  	u64 cur_bytenr;
>  	u32 nritems;
>  	u64 first_ino = 0;
> @@ -1881,6 +1895,7 @@ static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
>  	int ret = 0; /* Final return value */
>  	int err = 0; /* Positive error bitmap */
>  
> +	memset(&info, 0, sizeof(info));
>  	cur_bytenr = cur->start;
>  
>  	/* skip to first inode item or the first inode number change */
> @@ -1900,8 +1915,26 @@ static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
>  	path->slots[0] = i;
>  
>  again:
> -	err |= check_inode_item(root, path, ext_ref);
> +	err |= check_inode_item(root, path, ext_ref, &info);
> +
> +	if (repair && (err & ~LAST_ITEM)) {
> +		ret = repair_inode_item(root, &info);
>  
> +		if (ret < 0)
> +			goto out;
> +		/*
> +		 * if some errors was repaired, path shall be searched
> +		 * again since path has been changed
> +		 */
> +		if (ret == 0) {
> +			btrfs_item_key_to_cpu(path->nodes[0], &key,
> +					      path->slots[0]);
> +			btrfs_release_path(path);
> +			btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +
> +			cur = path->nodes[0];
> +		}
> +	}
>  	if (err & LAST_ITEM)
>  		goto out;
>  
> @@ -2211,7 +2244,8 @@ out:
>  }
>  
>  static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
> -			    unsigned int ext_ref);
> +			    unsigned int ext_ref,
> +			    struct inode_item_fix_info *info);
>  
>  static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
>  			     int *level, struct node_refs *nrefs, int ext_ref)
> @@ -2293,7 +2327,7 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
>  		}
>  
>  		ret = check_child_node(root, cur, path->slots[*level], next);
> -		if (ret < 0) 
> +		if (ret < 0)
>  			break;
>  
>  		if (btrfs_is_leaf(next))
> @@ -2383,6 +2417,105 @@ out:
>  	return ret;
>  }
>  
> +/*
> + * Set inode's nbytes to correct value in @info
> + *
> + * Returns <0  means on error
> + * Returns  0  means successful repair
> + */
> +static int repair_inode_nbytes_lowmem(struct btrfs_trans_handle *trans,
> +				      struct btrfs_root *root,
> +				      struct inode_item_fix_info *info)
> +{
> +	struct btrfs_inode_item *ei;
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	int ret;
> +
> +	ASSERT(info);
> +	key.objectid = info->ino;
> +	key.type = BTRFS_INODE_ITEM_KEY;
> +	key.offset = 0;

The path init call is missing here.

> +
> +	ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
> +	if (ret < 0)
> +		goto out;
> +	if (ret > 0) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	ei = btrfs_item_ptr(path.nodes[0], path.slots[0],
> +			    struct btrfs_inode_item);
> +	btrfs_set_inode_nbytes(path.nodes[0], ei, info->nbytes);
> +	btrfs_mark_buffer_dirty(path.nodes[0]);
> +	printf("reset nbytes for inode %llu root %llu\n", info->ino,
> +	       root->root_key.objectid);
> +out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
> +/*
> + * repair_inode_item - repair inode item errors
> + *
> + * Repair the inode item if error can be repaired. Any caller should compare
> + * @info->err with the before, if err diffs, some contexts should be notified.
> + *
> + * @root:     subvolume_root
> + * @info:     contains correct values and error
> + *            when it returns, @info stores the unrepairable errors
> + *
> + * Returns < 0 represents repair function error
> + * Returns 0   represents have fixed some errors or no error at all
> + * Returns > 0 represents it can't fix any error
> + */
> +static int repair_inode_item(struct btrfs_root *root,
> +			     struct inode_item_fix_info *info)
> +{
> +	struct btrfs_trans_handle *trans;
> +	int ret = 0;
> +	int err;
> +
> +	ASSERT(info);
> +	err = info->err;
> +	if (!err) {
> +		/* nothing to repair */
> +		ret = 0;
> +		goto out;
> +	}
> +	if (!(err & NBYTES_ERROR)) {
> +		warning("root %llu INODE[%llu] have error(s) can't repair, error : %d",
> +			root->objectid,	info->ino, err);
> +		/* can't fix any errors, ret should be positive */
> +		ret = err;
> +		goto out;
> +	}
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out;
> +	}
> +
> +	if (err & NBYTES_ERROR) {
> +		ret = repair_inode_nbytes_lowmem(trans, root, info);
> +		if (ret == 0)
> +			err &= ~NBYTES_ERROR;
> +		else if (ret < 0)
> +			goto out;
> +	}
> +
> +	if (err != info->err) {
> +		info->err = err;
> +		ret = 0;
> +	}
> +
> +	btrfs_commit_transaction(trans, root);
> +out:
> +	return ret;
> +}
> +
>  static int repair_inode_isize(struct btrfs_trans_handle *trans,
>  			      struct btrfs_root *root, struct btrfs_path *path,
>  			      struct inode_record *rec)
> @@ -4781,7 +4914,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
>   * Return >0 for error or hit the traversal is done(by error bitmap)
>   */
>  static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
> -			    unsigned int ext_ref)
> +			    unsigned int ext_ref,
> +			    struct inode_item_fix_info *info)
>  {
>  	struct extent_buffer *node;
>  	struct btrfs_inode_item *ii;
> @@ -4821,6 +4955,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
>  	dir = imode_to_type(mode) == BTRFS_FT_DIR;
>  	nlink = btrfs_inode_nlink(node, ii);
>  	nodatasum = btrfs_inode_flags(node, ii) & BTRFS_INODE_NODATASUM;
> +	info->ino = inode_id;
>  
>  	while (1) {
>  		ret = btrfs_next_item(root, path);
> @@ -4924,11 +5059,13 @@ out:
>  
>  		if (nbytes != extent_size) {
>  			err |= NBYTES_ERROR;
> +			info->nbytes = extent_size;
>  			error("root %llu INODE[%llu] nbytes(%llu) not equal to extent_size(%llu)",
>  			      root->objectid, inode_id, nbytes, extent_size);

The error level does not seem appropriate here, as we're fixing
something here, or at least it appears to me as such.

>  		}
>  	}
>  
> +	info->err = err & ~LAST_ITEM;
>  	return err;
>  }
>  
> @@ -4936,9 +5073,11 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
>  {
>  	struct btrfs_path path;
>  	struct btrfs_key key;
> +	struct inode_item_fix_info info;
>  	int err = 0;
>  	int ret;
>  
> +	memset(&info, 0, sizeof(info));
>  	btrfs_init_path(&path);
>  	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
>  	key.type = BTRFS_INODE_ITEM_KEY;
> @@ -4952,12 +5091,17 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
>  		err |= INODE_ITEM_MISSING;
>  	}
>  
> -	err |= check_inode_item(root, &path, ext_ref);
> +	err |= check_inode_item(root, &path, ext_ref, &info);
>  	err &= ~LAST_ITEM;
>  	if (err && !ret)
>  		ret = -EIO;
>  out:
>  	btrfs_release_path(&path);
> +	if (repair) {
> +		ret = repair_inode_item(root, &info);
> +		if (!info.err)
> +			ret = 0;
> +	}
>  	return ret;
>  }
>  
> @@ -12722,8 +12866,7 @@ int cmd_check(int argc, char **argv)
>  	 * Not supported yet
>  	 */
>  	if (repair && check_mode == CHECK_MODE_LOWMEM) {
> -		error("low memory mode doesn't support repair yet");
> -		exit(1);
> +		error("low memory mode supports repair partailly");

This should change to a warning.

>  	}
>  
>  	radix_tree_init();

I'm a bit lost in the check code, the patch looks good in general, but I
could have missed some corner case. Is this code exercised by some
existing code? (The low-mem mode could be now tested by the local
override flags documented in tests/README).
