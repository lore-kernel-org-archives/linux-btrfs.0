Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50569 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752512AbeEKHBh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:01:37 -0400
Subject: Re: [PATCH v2 10/12] Btrfs: get rid of btrfs_orphan_commit_root() and
 root->orphan_inodes
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
References: <cover.1525997057.git.osandov@fb.com>
 <ee9f8f4941b459e525a9e88a11ca5a58bf8a095d.1525997057.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <946921a1-900f-cd2b-8f83-ad6ee853675a@suse.com>
Date: Fri, 11 May 2018 10:01:34 +0300
MIME-Version: 1.0
In-Reply-To: <ee9f8f4941b459e525a9e88a11ca5a58bf8a095d.1525997057.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.05.2018 03:11, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> btrfs_orphan_commit_root() tries to delete an orphan item for a
> subvolume in the tree root, but we don't actually insert that item in
> the first place. See commit 0a0d4415e338 ("Btrfs: delete dead code in
> btrfs_orphan_add()"). We can get rid of it.
> 
> root->orphan_inodes was used to as a refcount for root->orphan_block_rsv
> and for btrfs_orphan_commit_root(), but both are gone now, so we can get
> rid of it, as well.

So this really means that the logic for orphaned root item is completely
defunct. Perhaps:

a) This commit should be expanded to delete all the logic surrounding
orphaned roots: btrfs_find_orphan_roots, BTRFS_ROOT_ORPHAN_ITEM_INSERTED
flag define and any accompanying logic that utilizes this flag (end of
btrfs_orphan_cleanup, orphan root logic at the end of btrfs_get_fs_root
as well)

b) Have those changes in a separate patch



> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/ctree.h       |  3 ---
>  fs/btrfs/disk-io.c     |  1 -
>  fs/btrfs/inode.c       | 40 ++++------------------------------------
>  fs/btrfs/transaction.c |  1 -
>  4 files changed, 4 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index d66241a35fab..51408de11af2 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1219,7 +1219,6 @@ struct btrfs_root {
>  	spinlock_t log_extents_lock[2];
>  	struct list_head logged_list[2];
>  
> -	atomic_t orphan_inodes;
>  	int orphan_cleanup_state;
>  
>  	spinlock_t inode_lock;
> @@ -3233,8 +3232,6 @@ int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
>  int btrfs_orphan_add(struct btrfs_trans_handle *trans,
>  		struct btrfs_inode *inode);
>  int btrfs_orphan_cleanup(struct btrfs_root *root);
> -void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
> -			      struct btrfs_root *root);
>  int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
>  void btrfs_invalidate_inodes(struct btrfs_root *root);
>  void btrfs_add_delayed_iput(struct inode *inode);
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 24e15e2080f4..4a40bfdddabc 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1214,7 +1214,6 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
>  	atomic_set(&root->log_commit[1], 0);
>  	atomic_set(&root->log_writers, 0);
>  	atomic_set(&root->log_batch, 0);
> -	atomic_set(&root->orphan_inodes, 0);
>  	refcount_set(&root->refs, 1);
>  	atomic_set(&root->will_be_snapshotted, 0);
>  	root->log_transid = 0;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 50f10882a715..207e1d139b31 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3292,30 +3292,6 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
>  	spin_unlock(&fs_info->delayed_iput_lock);
>  }
>  
> -/*
> - * This is called in transaction commit time. If there are no orphan files in
> - * the subvolume, it removes the orphan item.
> - */
> -void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
> -			      struct btrfs_root *root)
> -{
> -	struct btrfs_fs_info *fs_info = root->fs_info;
> -	int ret;
> -
> -	if (atomic_read(&root->orphan_inodes) == 0 &&
> -	    root->orphan_cleanup_state == ORPHAN_CLEANUP_DONE &&
> -	    test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state) &&
> -	    btrfs_root_refs(&root->root_item) > 0) {
> -		ret = btrfs_del_orphan_item(trans, fs_info->tree_root,
> -					    root->root_key.objectid);
> -		if (ret)
> -			btrfs_abort_transaction(trans, ret);
> -		else
> -			clear_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED,
> -				  &root->state);
> -	}
> -}
> -
>  /*
>   * This creates an orphan entry for the given inode in case something goes wrong
>   * in the middle of an unlink.
> @@ -3330,11 +3306,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
>  			     &inode->runtime_flags))
>  		return 0;
>  
> -	atomic_inc(&root->orphan_inodes);
> -
>  	ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
>  	if (ret && ret != -EEXIST) {
> -		atomic_dec(&root->orphan_inodes);
>  		clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM, &inode->runtime_flags);
>  		btrfs_abort_transaction(trans, ret);
>  		return ret;
> @@ -3360,8 +3333,6 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
>  	if (trans)
>  		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
>  
> -	atomic_dec(&root->orphan_inodes);
> -
>  	return ret;
>  }
>  
> @@ -3519,12 +3490,11 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>  		}
>  
>  		/*
> -		 * add this inode to the orphan list so btrfs_orphan_del does
> -		 * the proper thing when we hit it
> +		 * Mark this inode as having an orphan item so
> +		 * btrfs_orphan_del() does the proper thing when we hit it.
>  		 */
>  		set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
>  			&BTRFS_I(inode)->runtime_flags);
> -		atomic_inc(&root->orphan_inodes);
>  
>  		nr_unlink++;
>  
> @@ -9146,11 +9116,9 @@ void btrfs_destroy_inode(struct inode *inode)
>  		goto free;
>  
>  	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> -		     &BTRFS_I(inode)->runtime_flags)) {
> -		btrfs_info(fs_info, "inode %llu still on the orphan list",
> +		     &BTRFS_I(inode)->runtime_flags))
> +		btrfs_info(fs_info, "inode %llu still has an orphan item",
>  			   btrfs_ino(BTRFS_I(inode)));
> -		atomic_dec(&root->orphan_inodes);
> -	}
>  
>  	while (1) {
>  		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c944b4769e3c..44af1edf15d1 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1250,7 +1250,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
>  
>  			btrfs_free_log(trans, root);
>  			btrfs_update_reloc_root(trans, root);
> -			btrfs_orphan_commit_root(trans, root);
>  
>  			btrfs_save_ino_cache(root, trans);
>  
> 
