From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: please review snapshot corruption path with delayed metadata
 insertion
Date: Thu, 30 Jun 2011 16:03:21 +0800
Message-ID: <4E0C2DC9.9040901@cn.fujitsu.com>
References: <1308345034-sup-1969@shiny>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308345034-sup-1969@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris

I think the snapshot should be the image of the fs tree before it was created,
so the metadata of the snapshot should not exist in the its tree. But now, we
found the directory item and directory name index is in both the snapshot tree
and the fs tree.

Besides that, it also makes the users feel strange. For example:
# mkfs.btrfs /dev/sda1
# mount /dev/sda1 /mnt
# mkdir /mnt/1
# cd /mnt/1
# btrfs subvolume snapshot /mnt snap0
# ll /mnt/1
total 0
drwxr-xr-x 1 root root 10 Jun 30 15:01 1
		       ^^^
# ll /mnt/1/snap0/
total 0
drwxr-xr-x 1 root root 10 Jun 30 15:01 1
		       ^^^
			It is also 10, but...
# ll /mnt/1/snap0/1
total 0
[None]

There is nothing in the directory 1 in snap0, but btrfs told the length of
this directory is 10, it is strange.

So I think we should insert directory item and directory name index and update
the parent inode as the last step of snapshot creation.

Thanks
Miao

On Fri, 17 Jun 2011 17:12:28 -0400, Chris Mason wrote:
> commit e999376f094162aa425ae749aa1df95ab928d010
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Fri Jun 17 16:14:09 2011 -0400
> 
>     Btrfs: avoid delayed metadata items during commits
>     
>     Snapshot creation has two phases.  One is the initial snapshot setup,
>     and the second is done during commit, while nobody is allowed to modify
>     the root we are snapshotting.
>     
>     The delayed metadata insertion code can break that rule, it does a
>     delayed inode update on the inode of the parent of the snapshot,
>     and delayed directory item insertion.
>     
>     This makes sure to run the pending delayed operations before we
>     record the snapshot root, which avoids corruptions.
>     
>     Signed-off-by: Chris Mason <chris.mason@oracle.com>
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index fc515b7..f1cbd02 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1237,6 +1237,13 @@ again:
>  	return 0;
>  }
>  
> +void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
> +{
> +	struct btrfs_delayed_root *delayed_root;
> +	delayed_root = btrfs_get_delayed_root(root);
> +	WARN_ON(btrfs_first_delayed_node(delayed_root));
> +}
> +
>  void btrfs_balance_delayed_items(struct btrfs_root *root)
>  {
>  	struct btrfs_delayed_root *delayed_root;
> diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
> index cb79b67..d1a6a29 100644
> --- a/fs/btrfs/delayed-inode.h
> +++ b/fs/btrfs/delayed-inode.h
> @@ -137,4 +137,8 @@ int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
>  /* for init */
>  int __init btrfs_delayed_inode_init(void);
>  void btrfs_delayed_inode_exit(void);
> +
> +/* for debugging */
> +void btrfs_assert_delayed_root_empty(struct btrfs_root *root);
> +
>  #endif
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c073d85..51dcec8 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -957,6 +957,15 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	ret = btrfs_update_inode(trans, parent_root, parent_inode);
>  	BUG_ON(ret);
>  
> +	/*
> +	 * pull in the delayed directory update
> +	 * and the delayed inode item
> +	 * otherwise we corrupt the FS during
> +	 * snapshot
> +	 */
> +	ret = btrfs_run_delayed_items(trans, root);
> +	BUG_ON(ret);
> +
>  	record_root_in_trans(trans, root);
>  	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
>  	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
> @@ -1018,14 +1027,6 @@ static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
>  	int ret;
>  
>  	list_for_each_entry(pending, head, list) {
> -		/*
> -		 * We must deal with the delayed items before creating
> -		 * snapshots, or we will create a snapthot with inconsistent
> -		 * information.
> -		*/
> -		ret = btrfs_run_delayed_items(trans, fs_info->fs_root);
> -		BUG_ON(ret);
> -
>  		ret = create_pending_snapshot(trans, fs_info, pending);
>  		BUG_ON(ret);
>  	}
> @@ -1319,15 +1320,21 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	 */
>  	mutex_lock(&root->fs_info->reloc_mutex);
>  
> -	ret = create_pending_snapshots(trans, root->fs_info);
> +	ret = btrfs_run_delayed_items(trans, root);
>  	BUG_ON(ret);
>  
> -	ret = btrfs_run_delayed_items(trans, root);
> +	ret = create_pending_snapshots(trans, root->fs_info);
>  	BUG_ON(ret);
>  
>  	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
>  	BUG_ON(ret);
>  
> +	/*
> +	 * make sure none of the code above managed to slip in a
> +	 * delayed item
> +	 */
> +	btrfs_assert_delayed_root_empty(root);
> +
>  	WARN_ON(cur_trans != trans->transaction);
>  
>  	btrfs_scrub_pause(root);
> 

