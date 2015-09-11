Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22573 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751234AbbIKBZb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 21:25:31 -0400
Subject: Re: [PATCH] Btrfs: keep dropped roots in cache until transaciton
 commit
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-team@fb.com>, <mfasheh@suse.de>
References: <1441916850-19021-1-git-send-email-jbacik@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55F22D85.8010004@cn.fujitsu.com>
Date: Fri, 11 Sep 2015 09:25:25 +0800
MIME-Version: 1.0
In-Reply-To: <1441916850-19021-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Josef Bacik wrote on 2015/09/10 16:27 -0400:
> When dropping a snapshot we need to account for the qgroup changes.  If we drop
> the snapshot in all one go then the backref code will fail to find blocks from
> the snapshot we dropped since it won't be able to find the root in the fs root
> cache.  This can lead to us failing to find refs from other roots that pointed
> at blocks in the now deleted root.  To handle this we need to not remove the fs
> roots from the cache until after we process the qgroup operations.  Do this by
> adding dropped roots to a list on the transaction, and letting the transaction
> remove the roots at the same time it drops the commit roots.  This will keep all
> of the backref searching code in sync properly, and fixes a problem Mark was
> seeing with snapshot delete and qgroups.  Thanks,Btrfs: keep dropped roots in
> cache until transaciton commit
>
> When dropping a snapshot we need to account for the qgroup changes.  If we drop
> the snapshot in all one go then the backref code will fail to find blocks from
> the snapshot we dropped since it won't be able to find the root in the fs root
> cache.  This can lead to us failing to find refs from other roots that pointed
> at blocks in the now deleted root.  To handle this we need to not remove the fs
> roots from the cache until after we process the qgroup operations.  Do this by
> adding dropped roots to a list on the transaction, and letting the transaction
> remove the roots at the same time it drops the commit roots.  This will keep all
> of the backref searching code in sync properly, and fixes a problem Mark was
> seeing with snapshot delete and qgroups.  Thanks,

Mark will definitely be happy with this patch, as quite a good basis for 
snapshot deletion.

BTW, the commit message seems to be repeating itself.

Thanks,
Qu
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>   fs/btrfs/extent-tree.c |  2 +-
>   fs/btrfs/transaction.c | 12 ++++++++++++
>   fs/btrfs/transaction.h | 10 ++++++++++
>   3 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index ab81135..2327d4c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8596,7 +8596,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>   	}
>
>   	if (test_bit(BTRFS_ROOT_IN_RADIX, &root->state)) {
> -		btrfs_drop_and_free_fs_root(tree_root->fs_info, root);
> +		btrfs_add_dropped_root(trans, root);
>   	} else {
>   		free_extent_buffer(root->node);
>   		free_extent_buffer(root->commit_root);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index f5021fc..df1e61e 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -117,6 +117,16 @@ static noinline void switch_commit_roots(struct btrfs_transaction *trans,
>   			btrfs_unpin_free_ino(root);
>   		clear_btree_io_tree(&root->dirty_log_pages);
>   	}
> +
> +	/* We can free old roots now. */
> +	spin_lock(&trans->dropped_roots_lock);
> +	while (!list_empty(&trans->dropped_roots)) {
> +		root = list_first_entry(&trans->dropped_roots,
> +					struct btrfs_root, root_list);
> +		list_del_init(&root->root_list);
> +		btrfs_drop_and_free_fs_root(fs_info, root);
> +	}
> +	spin_unlock(&trans->dropped_roots_lock);
>   	up_write(&fs_info->commit_root_sem);
>   }
>
> @@ -255,9 +265,11 @@ loop:
>   	INIT_LIST_HEAD(&cur_trans->pending_ordered);
>   	INIT_LIST_HEAD(&cur_trans->dirty_bgs);
>   	INIT_LIST_HEAD(&cur_trans->io_bgs);
> +	INIT_LIST_HEAD(&cur_trans->dropped_roots);
>   	mutex_init(&cur_trans->cache_write_mutex);
>   	cur_trans->num_dirty_bgs = 0;
>   	spin_lock_init(&cur_trans->dirty_bgs_lock);
> +	spin_lock_init(&cur_trans->dropped_roots_lock);
>   	list_add_tail(&cur_trans->list, &fs_info->trans_list);
>   	extent_io_tree_init(&cur_trans->dirty_pages,
>   			     fs_info->btree_inode->i_mapping);
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index eb09c20..f158ab4 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -65,6 +65,7 @@ struct btrfs_transaction {
>   	struct list_head switch_commits;
>   	struct list_head dirty_bgs;
>   	struct list_head io_bgs;
> +	struct list_head dropped_roots;
>   	u64 num_dirty_bgs;
>
>   	/*
> @@ -74,6 +75,7 @@ struct btrfs_transaction {
>   	 */
>   	struct mutex cache_write_mutex;
>   	spinlock_t dirty_bgs_lock;
> +	spinlock_t dropped_roots_lock;
>   	struct btrfs_delayed_ref_root delayed_refs;
>   	int aborted;
>   	int dirty_bg_run;
> @@ -215,4 +217,12 @@ int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
>   void btrfs_put_transaction(struct btrfs_transaction *transaction);
>   void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info);
>
> +static inline void btrfs_add_dropped_root(struct btrfs_trans_handle *trans,
> +					  struct btrfs_root *root)
> +{
> +	struct btrfs_transaction *cur_trans = trans->transaction;
> +	spin_lock(&cur_trans->dropped_roots_lock);
> +	list_add_tail(&root->root_list, &cur_trans->dropped_roots);
> +	spin_unlock(&cur_trans->dropped_roots_lock);
> +}
>   #endif
>
