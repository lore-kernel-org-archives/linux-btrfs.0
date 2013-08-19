Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48920 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab3HSCaN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Aug 2013 22:30:13 -0400
Message-ID: <52118373.7050800@cn.fujitsu.com>
Date: Mon, 19 Aug 2013 10:31:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix heavy delalloc related deadlock
References: <1376494860-8864-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1376494860-8864-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 14 Aug 2013 11:41:00 -0400, Josef Bacik wrote:
> I added a patch where we started taking the ordered operations mutex when we
> waited on ordered extents.  We need this because we splice the list and process
> it, so if a flusher came in during this scenario it would think the list was
> empty and we'd usually get an early ENOSPC.  The problem with this is that this
> lock is used in transaction committing.  So we end up with something like this
> 
> Transaction commit
> 	-> wait on writers
> 
> Delalloc flusher
> 	-> run_ordered_operations (holds mutex)
> 		->wait for filemap-flush to do its thing
> 
> flush task
> 	-> cow_file_range
> 		->wait on btrfs_join_transaction because we're commiting
> 
> some other task
> 	-> commit_transaction because we notice trans->transaction->flush is set
> 		-> run_ordered_operations (hang on mutex)

Sorry, I can not understand this explanation. As far as I know, if the flush task
waits on btrfs_join_transaction(), it means the transaction is under commit
(state = TRANS_STATE_COMMIT_DOING), and all the external writers(TRANS_START/TRANS_ATTACH/
TRANS_USERSPACE) have quitted the current transaction, so no one would try to call
run_ordered_operations().

Could you show us the reproduce steps?

Thanks
Miao

> 
> We need to disentangle the ordered operations flushing from the delalloc
> flushing, since they are separate things.  This solves the deadlock issue I was
> seeing.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/ctree.h        |    7 +++++++
>  fs/btrfs/disk-io.c      |    1 +
>  fs/btrfs/ordered-data.c |    4 ++--
>  3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index ea4cc16..d79e32c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1418,6 +1418,13 @@ struct btrfs_fs_info {
>  	 * before jumping into the main commit.
>  	 */
>  	struct mutex ordered_operations_mutex;
> +
> +	/*
> +	 * Same as ordered_operations_mutex except this is for ordered extents
> +	 * and not the operations.
> +	 */
> +	struct mutex ordered_extent_flush_mutex;
> +
>  	struct rw_semaphore extent_commit_sem;
>  
>  	struct rw_semaphore cleanup_work_sem;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c82025d..880dcde 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2288,6 +2288,7 @@ int open_ctree(struct super_block *sb,
>  
>  
>  	mutex_init(&fs_info->ordered_operations_mutex);
> +	mutex_init(&fs_info->ordered_extent_flush_mutex);
>  	mutex_init(&fs_info->tree_log_mutex);
>  	mutex_init(&fs_info->chunk_mutex);
>  	mutex_init(&fs_info->transaction_kthread_mutex);
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 8136982..b52b2c4 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -671,7 +671,7 @@ int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
>  	INIT_LIST_HEAD(&splice);
>  	INIT_LIST_HEAD(&works);
>  
> -	mutex_lock(&root->fs_info->ordered_operations_mutex);
> +	mutex_lock(&root->fs_info->ordered_extent_flush_mutex);
>  	spin_lock(&root->fs_info->ordered_root_lock);
>  	list_splice_init(&cur_trans->ordered_operations, &splice);
>  	while (!list_empty(&splice)) {
> @@ -718,7 +718,7 @@ out:
>  		list_del_init(&work->list);
>  		btrfs_wait_and_free_delalloc_work(work);
>  	}
> -	mutex_unlock(&root->fs_info->ordered_operations_mutex);
> +	mutex_unlock(&root->fs_info->ordered_extent_flush_mutex);
>  	return ret;
>  }
>  
> 

