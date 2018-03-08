Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755009AbeCHMTb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 07:19:31 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BE886AB32
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 12:19:29 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs: replace waitqueue_actvie with cond_wake_up
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1520509627.git.dsterba@suse.com>
 <14c8d049b138f21bea1b378aae17b9a99d9dffe7.1520509627.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6ee068d8-1a69-3728-00d1-d86293d43c9f@suse.com>
Date: Thu, 8 Mar 2018 14:19:28 +0200
MIME-Version: 1.0
In-Reply-To: <14c8d049b138f21bea1b378aae17b9a99d9dffe7.1520509627.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.03.2018 13:49, David Sterba wrote:
> Use the wrappers and reduce the amount of low-level details about the
> waitqueue management.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/compression.c   |  7 +------
>  fs/btrfs/delayed-inode.c |  9 +++------
>  fs/btrfs/dev-replace.c   | 10 ++++------
>  fs/btrfs/extent-tree.c   |  7 +------
>  fs/btrfs/inode.c         |  9 +++------
>  fs/btrfs/locking.c       | 34 +++++++++++-----------------------
>  fs/btrfs/ordered-data.c  | 14 ++++----------
>  fs/btrfs/transaction.c   |  7 +------
>  fs/btrfs/tree-log.c      | 28 ++++++++--------------------
>  9 files changed, 36 insertions(+), 89 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 562c3e633403..2d2d7380d381 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1003,12 +1003,7 @@ static void __free_workspace(int type, struct list_head *workspace,
>  		btrfs_compress_op[idx]->free_workspace(workspace);
>  	atomic_dec(total_ws);
>  wake:
> -	/*
> -	 * Make sure counter is updated before we wake up waiters.
> -	 */
> -	smp_mb();
> -	if (waitqueue_active(ws_wait))
> -		wake_up(ws_wait);
> +	cond_wake_up(ws_wait);
>  }
>  
>  static void free_workspace(int type, struct list_head *ws)
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index d06bef16ebd5..3e7f5f26ff0f 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -472,13 +472,10 @@ static void finish_one_item(struct btrfs_delayed_root *delayed_root)
>  {
>  	int seq = atomic_inc_return(&delayed_root->items_seq);
>  
> -	/*
> -	 * atomic_dec_return implies a barrier for waitqueue_active
> -	 */
> +	/* atomic_dec_return implies a barrier for waitqueue_active */
>  	if ((atomic_dec_return(&delayed_root->items) <
> -	    BTRFS_DELAYED_BACKGROUND || seq % BTRFS_DELAYED_BATCH == 0) &&
> -	    waitqueue_active(&delayed_root->wait))
> -		wake_up(&delayed_root->wait);
> +	    BTRFS_DELAYED_BACKGROUND || seq % BTRFS_DELAYED_BATCH == 0))
> +		cond_wake_up_nomb(&delayed_root->wait);
>  }
>  
>  static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index e279f04b3388..f498572155f1 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -928,9 +928,9 @@ void btrfs_dev_replace_clear_lock_blocking(
>  	ASSERT(atomic_read(&dev_replace->read_locks) > 0);
>  	ASSERT(atomic_read(&dev_replace->blocking_readers) > 0);
>  	read_lock(&dev_replace->lock);
> -	if (atomic_dec_and_test(&dev_replace->blocking_readers) &&
> -	    waitqueue_active(&dev_replace->read_lock_wq))
> -		wake_up(&dev_replace->read_lock_wq);
> +	/* Barrier implied by atomic_dec_and_test */
> +	if (atomic_dec_and_test(&dev_replace->blocking_readers))
> +		cond_wake_up_nomb(&dev_replace->read_lock_wq);
>  }
>  
>  void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
> @@ -941,9 +941,7 @@ void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
>  void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
>  {
>  	percpu_counter_sub(&fs_info->bio_counter, amount);
> -
> -	if (waitqueue_active(&fs_info->replace_wait))
> -		wake_up(&fs_info->replace_wait);
> +	cond_wake_up_nomb(&fs_info->replace_wait);

nit/offtopic:

I think here the code requires comments since we have 2 types of waiters for fs_info->replace_wait. One is dependent on the percpu_counter_sum (i.e. the btrfs_rm_dev_replace_blocked). And then there is another condition on the same wait entry - the btrfs_bio_counter_inc_blocked i.e:

 wait_event(fs_info->replace_wait,                               
                           !test_bit(BTRFS_FS_STATE_DEV_REPLACING,              
                                     &fs_info->fs_state)); 

geez, who would come up with such synchronization ... 
>  }
>  
>  void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2760292e1175..d57801711884 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10999,12 +10999,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
>  void btrfs_end_write_no_snapshotting(struct btrfs_root *root)
>  {
>  	percpu_counter_dec(&root->subv_writers->counter);
> -	/*
> -	 * Make sure counter is updated before we wake up waiters.
> -	 */
> -	smp_mb();
> -	if (waitqueue_active(&root->subv_writers->wait))
> -		wake_up(&root->subv_writers->wait);
> +	cond_wake_up(&root->subv_writers->wait);
>  }
>  
>  int btrfs_start_write_no_snapshotting(struct btrfs_root *root)
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index fc5b7d82b842..b963b5b4734e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1168,13 +1168,10 @@ static noinline void async_cow_submit(struct btrfs_work *work)
>  	nr_pages = (async_cow->end - async_cow->start + PAGE_SIZE) >>
>  		PAGE_SHIFT;
>  
> -	/*
> -	 * atomic_sub_return implies a barrier for waitqueue_active
> -	 */
> +	/* atomic_sub_return implies a barrier */
>  	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
> -	    5 * SZ_1M &&
> -	    waitqueue_active(&fs_info->async_submit_wait))
> -		wake_up(&fs_info->async_submit_wait);
> +	    5 * SZ_1M)
> +		cond_wake_up_nomb(&fs_info->async_submit_wait);
>  
>  	if (async_cow->inode)
>  		submit_compressed_extents(async_cow->inode, async_cow);
> diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
> index 621083f8932c..cce666cd104e 100644
> --- a/fs/btrfs/locking.c
> +++ b/fs/btrfs/locking.c
> @@ -78,22 +78,16 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
>  		write_lock(&eb->lock);
>  		WARN_ON(atomic_read(&eb->spinning_writers));
>  		atomic_inc(&eb->spinning_writers);
> -		/*
> -		 * atomic_dec_and_test implies a barrier for waitqueue_active
> -		 */
> -		if (atomic_dec_and_test(&eb->blocking_writers) &&
> -		    waitqueue_active(&eb->write_lock_wq))
> -			wake_up(&eb->write_lock_wq);
> +		/* atomic_dec_and_test implies a barrier */
> +		if (atomic_dec_and_test(&eb->blocking_writers))
> +			cond_wake_up_nomb(&eb->write_lock_wq);
>  	} else if (rw == BTRFS_READ_LOCK_BLOCKING) {
>  		BUG_ON(atomic_read(&eb->blocking_readers) == 0);
>  		read_lock(&eb->lock);
>  		atomic_inc(&eb->spinning_readers);
> -		/*
> -		 * atomic_dec_and_test implies a barrier for waitqueue_active
> -		 */
> -		if (atomic_dec_and_test(&eb->blocking_readers) &&
> -		    waitqueue_active(&eb->read_lock_wq))
> -			wake_up(&eb->read_lock_wq);
> +		/* atomic_dec_and_test implies a barrier */
> +		if (atomic_dec_and_test(&eb->blocking_readers))
> +			cond_wake_up_nomb(&eb->read_lock_wq);
>  	}
>  }
>  
> @@ -233,12 +227,9 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
>  	}
>  	btrfs_assert_tree_read_locked(eb);
>  	WARN_ON(atomic_read(&eb->blocking_readers) == 0);
> -	/*
> -	 * atomic_dec_and_test implies a barrier for waitqueue_active
> -	 */
> -	if (atomic_dec_and_test(&eb->blocking_readers) &&
> -	    waitqueue_active(&eb->read_lock_wq))
> -		wake_up(&eb->read_lock_wq);
> +	/* atomic_dec_and_test implies a barrier */
> +	if (atomic_dec_and_test(&eb->blocking_readers))
> +		cond_wake_up_nomb(&eb->read_lock_wq);
>  	atomic_dec(&eb->read_locks);
>  }
>  
> @@ -287,12 +278,9 @@ void btrfs_tree_unlock(struct extent_buffer *eb)
>  	if (blockers) {
>  		WARN_ON(atomic_read(&eb->spinning_writers));
>  		atomic_dec(&eb->blocking_writers);
> -		/*
> -		 * Make sure counter is updated before we wake up waiters.
> -		 */
> +		/* Use the lighter barrier after atomic */
>  		smp_mb__after_atomic();
> -		if (waitqueue_active(&eb->write_lock_wq))
> -			wake_up(&eb->write_lock_wq);
> +		cond_wake_up_nomb(&eb->write_lock_wq);
>  	} else {
>  		WARN_ON(atomic_read(&eb->spinning_writers) != 1);
>  		atomic_dec(&eb->spinning_writers);
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 9be98e42cfb6..66ff1419e2e0 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -356,11 +356,8 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
>  
>  	if (entry->bytes_left == 0) {
>  		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
> -		/*
> -		 * Implicit memory barrier after test_and_set_bit
> -		 */
> -		if (waitqueue_active(&entry->wait))
> -			wake_up(&entry->wait);
> +		/* test_and_set_bit implies a barrier */
> +		cond_wake_up_nomb(&entry->wait);
>  	} else {
>  		ret = 1;
>  	}
> @@ -423,11 +420,8 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
>  
>  	if (entry->bytes_left == 0) {
>  		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
> -		/*
> -		 * Implicit memory barrier after test_and_set_bit
> -		 */
> -		if (waitqueue_active(&entry->wait))
> -			wake_up(&entry->wait);
> +		/* test_and_set_bit implies a barrier */
> +		cond_wake_up_nomb(&entry->wait);
>  	} else {
>  		ret = 1;
>  	}
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index eab15777ba88..f431223196a0 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -909,12 +909,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  	atomic_dec(&cur_trans->num_writers);
>  	extwriter_counter_dec(cur_trans, trans->type);
>  
> -	/*
> -	 * Make sure counter is updated before we wake up waiters.
> -	 */
> -	smp_mb();
> -	if (waitqueue_active(&cur_trans->writer_wait))
> -		wake_up(&cur_trans->writer_wait);
> +	cond_wake_up(&cur_trans->writer_wait);
>  	btrfs_put_transaction(cur_trans);
>  
>  	if (current->journal_info == trans)
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 7b8fee45b29e..979fc02214d4 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -235,11 +235,8 @@ int btrfs_pin_log_trans(struct btrfs_root *root)
>  void btrfs_end_log_trans(struct btrfs_root *root)
>  {
>  	if (atomic_dec_and_test(&root->log_writers)) {
> -		/*
> -		 * Implicit memory barrier after atomic_dec_and_test
> -		 */
> -		if (waitqueue_active(&root->log_writer_wait))
> -			wake_up(&root->log_writer_wait);
> +		/* atomic_dec_and_test implies a barrier */
> +		cond_wake_up_nomb(&root->log_writer_wait);
>  	}
>  }
>  
> @@ -2965,11 +2962,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  
>  	mutex_lock(&log_root_tree->log_mutex);
>  	if (atomic_dec_and_test(&log_root_tree->log_writers)) {
> -		/*
> -		 * Implicit memory barrier after atomic_dec_and_test
> -		 */
> -		if (waitqueue_active(&log_root_tree->log_writer_wait))
> -			wake_up(&log_root_tree->log_writer_wait);
> +		/* atomic_dec_and_test implies a barrier */
> +		cond_wake_up_nomb(&log_root_tree->log_writer_wait);
>  	}
>  
>  	if (ret) {
> @@ -3092,11 +3086,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  	atomic_set(&log_root_tree->log_commit[index2], 0);
>  	mutex_unlock(&log_root_tree->log_mutex);
>  
> -	/*
> -	 * The barrier before waitqueue_active is implied by mutex_unlock
> -	 */
> -	if (waitqueue_active(&log_root_tree->log_commit_wait[index2]))
> -		wake_up(&log_root_tree->log_commit_wait[index2]);
> +	/* The barrier is implied by mutex_unlock */
> +	cond_wake_up_nomb(&log_root_tree->log_commit_wait[index2]);

I think this is wrong (not your code) but the original assumption that 
the RELEASE semantics provided by mutex_unlock is sufficient. 
According to memory-barriers.txt: 

Section 'LOCK ACQUISITION FUNCTIONS' states: 


 (2) RELEASE operation implication:                                             
                                                                                
     Memory operations issued before the RELEASE will be completed before the   
     RELEASE operation has completed.                                           
                                                                                
     Memory operations issued after the RELEASE *may* be completed before the     
     RELEASE operation has completed.

(I've bolded the may portion)

The example given there: 

As an example, consider the following:                                          
                                                                                
    *A = a;                                                                     
    *B = b;                                                                     
    ACQUIRE                                                                     
    *C = c;                                                                     
    *D = d;                                                                     
    RELEASE                                                                     
    *E = e;                                                                     
    *F = f;                                                                     
                                                                                
The following sequence of events is acceptable:                                 
                                                                                
    ACQUIRE, {*F,*A}, *E, {*C,*D}, *B, RELEASE  

So if we assume that *C is modifying the flag which the waitqueue is checking, 
and *E is the actual wakeup, then those accesses can be re-ordered...

IMHO this code should be considered broken...         


>  out:
>  	mutex_lock(&root->log_mutex);
>  	btrfs_remove_all_log_ctxs(root, index1, ret);
> @@ -3104,11 +3095,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  	atomic_set(&root->log_commit[index1], 0);
>  	mutex_unlock(&root->log_mutex);
>  
> -	/*
> -	 * The barrier before waitqueue_active is implied by mutex_unlock
> -	 */
> -	if (waitqueue_active(&root->log_commit_wait[index1]))
> -		wake_up(&root->log_commit_wait[index1]);
> +	/* The barrier is implied by mutex_unlock */
> +	cond_wake_up_nomb(&root->log_commit_wait[index1]);

ditto.

>  	return ret;
>  }
>  
> 
