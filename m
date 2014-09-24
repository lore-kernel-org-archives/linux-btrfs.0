Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2336 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751909AbaIXLOz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 07:14:55 -0400
Message-ID: <5422A800.9030308@cn.fujitsu.com>
Date: Wed, 24 Sep 2014 19:16:16 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 v5] Btrfs: be aware of btree inode write errors to
 avoid fs corruption
References: <1411404065-767-2-git-send-email-fdmanana@suse.com> <1411554506-4238-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1411554506-4238-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 24 Sep 2014 11:28:26 +0100, Filipe Manana wrote:
[SNIP]
>  int btrfs_wait_marked_extents(struct btrfs_root *root,
> +			      struct btrfs_trans_handle *trans,
>  			      struct extent_io_tree *dirty_pages, int mark)
>  {
>  	int err = 0;
> @@ -852,6 +855,7 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
>  	struct extent_state *cached_state = NULL;
>  	u64 start = 0;
>  	u64 end;
> +	int errors;
>  
>  	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
>  				      EXTENT_NEED_WAIT, &cached_state)) {
> @@ -865,6 +869,16 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
>  	}
>  	if (err)
>  		werr = err;
> +
> +	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
> +		errors = atomic_xchg(
> +		    &trans->transaction->log_eb_write_errors, 0);
> +	else
> +		errors = atomic_xchg(&trans->transaction->eb_write_errors, 0);

There is a bug in log tree commit case.
As we know, each fs/file tree has two log sub-transaction, when we are committing
a log sub-transaction, the other one may be started by the other file sync tasks.
It is very likely that there is no any error happens in the former, but some write
errors happen in the latter. The above code might clear the number of that errors.

So I think the variant for log write error should be created for each log sub-transaction.

Thanks
Miao

> +
> +	if (errors && !werr)
> +		werr = -EIO;
> +
>  	return werr;
>  }
>  
> @@ -874,6 +888,7 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
>   * those extents are on disk for transaction or log commit
>   */
>  static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
> +				struct btrfs_trans_handle *trans,
>  				struct extent_io_tree *dirty_pages, int mark)
>  {
>  	int ret;
> @@ -883,7 +898,7 @@ static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
>  	blk_start_plug(&plug);
>  	ret = btrfs_write_marked_extents(root, dirty_pages, mark);
>  	blk_finish_plug(&plug);
> -	ret2 = btrfs_wait_marked_extents(root, dirty_pages, mark);
> +	ret2 = btrfs_wait_marked_extents(root, trans, dirty_pages, mark);
>  
>  	if (ret)
>  		return ret;
> @@ -892,7 +907,7 @@ static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
>  	return 0;
>  }
>  
> -int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
> +static int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
>  				     struct btrfs_root *root)
>  {
>  	if (!trans || !trans->transaction) {
> @@ -900,7 +915,7 @@ int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
>  		btree_inode = root->fs_info->btree_inode;
>  		return filemap_write_and_wait(btree_inode->i_mapping);
>  	}
> -	return btrfs_write_and_wait_marked_extents(root,
> +	return btrfs_write_and_wait_marked_extents(root, trans,
>  					   &trans->transaction->dirty_pages,
>  					   EXTENT_DIRTY);
>  }
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 7dd558e..311f3e3 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -46,6 +46,8 @@ struct btrfs_transaction {
>  	 */
>  	atomic_t num_writers;
>  	atomic_t use_count;
> +	atomic_t eb_write_errors;
> +	atomic_t log_eb_write_errors;
>  
>  	/* Be protected by fs_info->trans_lock when we want to change it. */
>  	enum btrfs_trans_state state;
> @@ -146,8 +148,6 @@ struct btrfs_trans_handle *btrfs_attach_transaction_barrier(
>  					struct btrfs_root *root);
>  struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root);
>  int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
> -int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
> -				     struct btrfs_root *root);
>  
>  void btrfs_add_dead_root(struct btrfs_root *root);
>  int btrfs_defrag_root(struct btrfs_root *root);
> @@ -167,6 +167,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
>  int btrfs_write_marked_extents(struct btrfs_root *root,
>  				struct extent_io_tree *dirty_pages, int mark);
>  int btrfs_wait_marked_extents(struct btrfs_root *root,
> +			      struct btrfs_trans_handle *trans,
>  				struct extent_io_tree *dirty_pages, int mark);
>  int btrfs_transaction_blocked(struct btrfs_fs_info *info);
>  int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 2d0fa43..22ffd32 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2583,7 +2583,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  			mutex_unlock(&log_root_tree->log_mutex);
>  			goto out;
>  		}
> -		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
> +		btrfs_wait_marked_extents(log, trans, &log->dirty_log_pages,
> +					  mark);
>  		btrfs_free_logged_extents(log, log_transid);
>  		mutex_unlock(&log_root_tree->log_mutex);
>  		ret = -EAGAIN;
> @@ -2599,7 +2600,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  	index2 = root_log_ctx.log_transid % 2;
>  	if (atomic_read(&log_root_tree->log_commit[index2])) {
>  		blk_finish_plug(&plug);
> -		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
> +		btrfs_wait_marked_extents(log, trans, &log->dirty_log_pages,
> +					  mark);
>  		wait_log_commit(trans, log_root_tree,
>  				root_log_ctx.log_transid);
>  		btrfs_free_logged_extents(log, log_transid);
> @@ -2623,7 +2625,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  	 */
>  	if (btrfs_need_log_full_commit(root->fs_info, trans)) {
>  		blk_finish_plug(&plug);
> -		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
> +		btrfs_wait_marked_extents(log, trans, &log->dirty_log_pages,
> +					  mark);
>  		btrfs_free_logged_extents(log, log_transid);
>  		mutex_unlock(&log_root_tree->log_mutex);
>  		ret = -EAGAIN;
> @@ -2641,8 +2644,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  		mutex_unlock(&log_root_tree->log_mutex);
>  		goto out_wake_log_root;
>  	}
> -	btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
> -	btrfs_wait_marked_extents(log_root_tree,
> +	btrfs_wait_marked_extents(log, trans, &log->dirty_log_pages, mark);
> +	btrfs_wait_marked_extents(log_root_tree, trans,
>  				  &log_root_tree->dirty_log_pages,
>  				  EXTENT_NEW | EXTENT_DIRTY);
>  	btrfs_wait_logged_extents(log, log_transid);
> 

