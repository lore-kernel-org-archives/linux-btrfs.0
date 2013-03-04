Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49392 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab3CDK46 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 05:56:58 -0500
Date: Mon, 4 Mar 2013 18:54:02 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] Btrfs: fix wrong handle at error path of
 create_snapshot() when the commit fails
Message-ID: <20130304105401.GL11468@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <51346CFD.20608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51346CFD.20608@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 04, 2013 at 05:44:29PM +0800, Miao Xie wrote:
> There are several bugs at error path of create_snapshot() when the
> transaction commitment failed.
> - access the freed transaction handler. At the end of the
>   transaction commitment, the transaction handler was freed, so we
>   should not access it after the transaction commitment.
> - we were not aware of the error which happened during the snapshot
>   creation if we submitted a async transaction commitment.
> - pending snapshot access vs pending snapshot free. when something
>   wrong happened after we submitted a async transaction commitment,
>   the transaction committer would cleanup the pending snapshots and
>   free them. But the snapshot creators were not aware of it, they
>   would access the freed pending snapshots.
> 
> This patch fixes the above problems by:
> - remove the dangerous code that accessed the freed handler
> - assign ->error if the error happens during the snapshot creation
> - the transaction committer doesn't free the pending snapshots,
>   just assigns the error number and evicts them before we unblock
>   the transaction.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/disk-io.c     |   16 +++++-------
>  fs/btrfs/ioctl.c       |    6 +----
>  fs/btrfs/transaction.c |   58 +++++++++++++++++++++++++++--------------------
>  3 files changed, 41 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 02369a3..7d84651 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -62,7 +62,7 @@ static void btrfs_destroy_ordered_operations(struct btrfs_transaction *t,
>  static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
>  static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  				      struct btrfs_root *root);
> -static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
> +static void btrfs_evict_pending_snapshots(struct btrfs_transaction *t);
>  static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
>  static int btrfs_destroy_marked_extents(struct btrfs_root *root,
>  					struct extent_io_tree *dirty_pages,
> @@ -3687,7 +3687,7 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  	return ret;
>  }
>  
> -static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
> +static void btrfs_evict_pending_snapshots(struct btrfs_transaction *t)
>  {
>  	struct btrfs_pending_snapshot *snapshot;
>  	struct list_head splice;
> @@ -3700,10 +3700,8 @@ static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
>  		snapshot = list_entry(splice.next,
>  				      struct btrfs_pending_snapshot,
>  				      list);
> -
> +		snapshot->error = -ECANCELED;

ECANCELED or EROFS?  Now that EROFS is why we're here.

Others look good.

thanks,
liubo

>  		list_del_init(&snapshot->list);
> -
> -		kfree(snapshot);
>  	}
>  }
>  
> @@ -3840,6 +3838,8 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
>  	cur_trans->blocked = 1;
>  	wake_up(&root->fs_info->transaction_blocked_wait);
>  
> +	btrfs_evict_pending_snapshots(cur_trans);
> +
>  	cur_trans->blocked = 0;
>  	wake_up(&root->fs_info->transaction_wait);
>  
> @@ -3849,8 +3849,6 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
>  	btrfs_destroy_delayed_inodes(root);
>  	btrfs_assert_delayed_root_empty(root);
>  
> -	btrfs_destroy_pending_snapshots(cur_trans);
> -
>  	btrfs_destroy_marked_extents(root, &cur_trans->dirty_pages,
>  				     EXTENT_DIRTY);
>  	btrfs_destroy_pinned_extent(root,
> @@ -3894,6 +3892,8 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
>  		if (waitqueue_active(&root->fs_info->transaction_blocked_wait))
>  			wake_up(&root->fs_info->transaction_blocked_wait);
>  
> +		btrfs_evict_pending_snapshots(t);
> +
>  		t->blocked = 0;
>  		smp_mb();
>  		if (waitqueue_active(&root->fs_info->transaction_wait))
> @@ -3907,8 +3907,6 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
>  		btrfs_destroy_delayed_inodes(root);
>  		btrfs_assert_delayed_root_empty(root);
>  
> -		btrfs_destroy_pending_snapshots(t);
> -
>  		btrfs_destroy_delalloc_inodes(root);
>  
>  		spin_lock(&root->fs_info->trans_lock);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b908960..94c0e42 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -596,12 +596,8 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  		ret = btrfs_commit_transaction(trans,
>  					       root->fs_info->extent_root);
>  	}
> -	if (ret) {
> -		/* cleanup_transaction has freed this for us */
> -		if (trans->aborted)
> -			pending_snapshot = NULL;
> +	if (ret)
>  		goto fail;
> -	}
>  
>  	ret = pending_snapshot->error;
>  	if (ret)
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index f11c2e0..d8fce6f 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1053,7 +1053,12 @@ int btrfs_defrag_root(struct btrfs_root *root)
>  
>  /*
>   * new snapshots need to be created at a very specific time in the
> - * transaction commit.  This does the actual creation
> + * transaction commit.  This does the actual creation.
> + *
> + * Note:
> + * If the error which may affect the commitment of the current transaction
> + * happens, we should return the error number. If the error which just affect
> + * the creation of the pending snapshots, just return 0.
>   */
>  static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  				   struct btrfs_fs_info *fs_info,
> @@ -1072,7 +1077,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	struct extent_buffer *tmp;
>  	struct extent_buffer *old;
>  	struct timespec cur_time = CURRENT_TIME;
> -	int ret;
> +	int ret = 0;
>  	u64 to_reserve = 0;
>  	u64 index = 0;
>  	u64 objectid;
> @@ -1081,40 +1086,36 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  
>  	path = btrfs_alloc_path();
>  	if (!path) {
> -		ret = pending->error = -ENOMEM;
> -		return ret;
> +		pending->error = -ENOMEM;
> +		return 0;
>  	}
>  
>  	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
>  	if (!new_root_item) {
> -		ret = pending->error = -ENOMEM;
> +		pending->error = -ENOMEM;
>  		goto root_item_alloc_fail;
>  	}
>  
> -	ret = btrfs_find_free_objectid(tree_root, &objectid);
> -	if (ret) {
> -		pending->error = ret;
> +	pending->error = btrfs_find_free_objectid(tree_root, &objectid);
> +	if (pending->error)
>  		goto no_free_objectid;
> -	}
>  
>  	btrfs_reloc_pre_snapshot(trans, pending, &to_reserve);
>  
>  	if (to_reserve > 0) {
> -		ret = btrfs_block_rsv_add(root, &pending->block_rsv,
> -					  to_reserve,
> -					  BTRFS_RESERVE_NO_FLUSH);
> -		if (ret) {
> -			pending->error = ret;
> +		pending->error = btrfs_block_rsv_add(root,
> +						     &pending->block_rsv,
> +						     to_reserve,
> +						     BTRFS_RESERVE_NO_FLUSH);
> +		if (pending->error)
>  			goto no_free_objectid;
> -		}
>  	}
>  
> -	ret = btrfs_qgroup_inherit(trans, fs_info, root->root_key.objectid,
> -				   objectid, pending->inherit);
> -	if (ret) {
> -		pending->error = ret;
> +	pending->error = btrfs_qgroup_inherit(trans, fs_info,
> +					      root->root_key.objectid,
> +					      objectid, pending->inherit);
> +	if (pending->error)
>  		goto no_free_objectid;
> -	}
>  
>  	key.objectid = objectid;
>  	key.offset = (u64)-1;
> @@ -1142,7 +1143,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  					 dentry->d_name.len, 0);
>  	if (dir_item != NULL && !IS_ERR(dir_item)) {
>  		pending->error = -EEXIST;
> -		goto fail;
> +		goto dir_item_existed;
>  	} else if (IS_ERR(dir_item)) {
>  		ret = PTR_ERR(dir_item);
>  		btrfs_abort_transaction(trans, root, ret);
> @@ -1273,6 +1274,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	if (ret)
>  		btrfs_abort_transaction(trans, root, ret);
>  fail:
> +	pending->error = ret;
> +dir_item_existed:
>  	trans->block_rsv = rsv;
>  	trans->bytes_reserved = 0;
>  no_free_objectid:
> @@ -1288,12 +1291,17 @@ root_item_alloc_fail:
>  static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
>  					     struct btrfs_fs_info *fs_info)
>  {
> -	struct btrfs_pending_snapshot *pending;
> +	struct btrfs_pending_snapshot *pending, *next;
>  	struct list_head *head = &trans->transaction->pending_snapshots;
> +	int ret = 0;
>  
> -	list_for_each_entry(pending, head, list)
> -		create_pending_snapshot(trans, fs_info, pending);
> -	return 0;
> +	list_for_each_entry_safe(pending, next, head, list) {
> +		list_del(&pending->list);
> +		ret = create_pending_snapshot(trans, fs_info, pending);
> +		if (ret)
> +			break;
> +	}
> +	return ret;
>  }
>  
>  static void update_super_roots(struct btrfs_root *root)
> -- 
> 1.6.5.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
