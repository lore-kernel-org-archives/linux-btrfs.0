Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41233 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdKBJWd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 05:22:33 -0400
Subject: Re: [PATCH RFC] Btrfs: remove max_active and thresh
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171030171440.27044-3-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <44152d4a-9dee-c183-58a1-2ba3812f78fe@suse.com>
Date: Thu, 2 Nov 2017 11:22:30 +0200
MIME-Version: 1.0
In-Reply-To: <20171030171440.27044-3-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.10.2017 19:14, Liu Bo wrote:
> First and foremost, here are the problems we have right now,
> 
> a) %thread_pool is configurable via mount option, however for those
>    'workers' who really needs concurrency, there are at most
>    "min(num_cpus+2, 8)" threads running to process works, and the
>    value can't be tuned after mount because they're tagged with
>    NO_THRESHOLD.
> 
> b) For THRESHOLD workers, btrfs is adjusting how concurrency will
>    happen by starting with the minimum max_active and calling
>    btrfs_workqueue_set_max() to grow it on demand, but it also has a
>    upper limit, "min(num_cpus+2, 8)", which means at most we can have
>    such many threads running at the same time.
> 
> In fact, kernel workqueue can be created on demand and destroyed once
> no work needs to be processed.  The small max_active limitation (8)
> from btrfs has prevented us from utilizing all available cpus, and
> that is against why we choose workqueue.
> 
> What this patch does:
> 
> - resizing %thread_pool is totally removed as they are no long needed,
>   while keeping its mount option for compatibility.
> 
> - The default "0" is passed when allocating workqueue, so the maximum
>   number of running works is typically 256.  And all fields for
>   limiting max_active are removed, including current_active,
>   limit_active, thresh etc.

The code looks good and I also like the direction, but as Qu mentioned
it would be best if we can get some perf numbers.


> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/async-thread.c  | 155 +++--------------------------------------------
>  fs/btrfs/async-thread.h  |  27 +++++++--
>  fs/btrfs/delayed-inode.c |   7 ++-
>  fs/btrfs/disk-io.c       |  61 ++++++-------------
>  fs/btrfs/scrub.c         |  11 ++--
>  fs/btrfs/super.c         |  32 ----------
>  6 files changed, 58 insertions(+), 235 deletions(-)
> 
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index e00c8a9..dd627ad 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -29,41 +29,6 @@
>  #define WORK_ORDER_DONE_BIT 1
>  #define WORK_HIGH_PRIO_BIT 2
>  
> -#define NO_THRESHOLD (-1)
> -#define DFT_THRESHOLD (32)
> -
> -struct __btrfs_workqueue {
> -	struct workqueue_struct *normal_wq;
> -
> -	/* File system this workqueue services */
> -	struct btrfs_fs_info *fs_info;
> -
> -	/* List head pointing to ordered work list */
> -	struct list_head ordered_list;
> -
> -	/* Spinlock for ordered_list */
> -	spinlock_t list_lock;
> -
> -	/* Thresholding related variants */
> -	atomic_t pending;
> -
> -	/* Up limit of concurrency workers */
> -	int limit_active;
> -
> -	/* Current number of concurrency workers */
> -	int current_active;
> -
> -	/* Threshold to change current_active */
> -	int thresh;
> -	unsigned int count;
> -	spinlock_t thres_lock;
> -};
> -
> -struct btrfs_workqueue {
> -	struct __btrfs_workqueue *normal;
> -	struct __btrfs_workqueue *high;
> -};
> -
>  static void normal_work_helper(struct btrfs_work *work);
>  
>  #define BTRFS_WORK_HELPER(name)					\
> @@ -86,20 +51,6 @@ btrfs_work_owner(const struct btrfs_work *work)
>  	return work->wq->fs_info;
>  }
>  
> -bool btrfs_workqueue_normal_congested(const struct btrfs_workqueue *wq)
> -{
> -	/*
> -	 * We could compare wq->normal->pending with num_online_cpus()
> -	 * to support "thresh == NO_THRESHOLD" case, but it requires
> -	 * moving up atomic_inc/dec in thresh_queue/exec_hook. Let's
> -	 * postpone it until someone needs the support of that case.
> -	 */
> -	if (wq->normal->thresh == NO_THRESHOLD)
> -		return false;
> -
> -	return atomic_read(&wq->normal->pending) > wq->normal->thresh * 2;
> -}
> -
>  BTRFS_WORK_HELPER(worker_helper);
>  BTRFS_WORK_HELPER(delalloc_helper);
>  BTRFS_WORK_HELPER(flush_delalloc_helper);
> @@ -125,7 +76,7 @@ BTRFS_WORK_HELPER(scrubparity_helper);
>  
>  static struct __btrfs_workqueue *
>  __btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info, const char *name,
> -			unsigned int flags, int limit_active, int thresh)
> +			unsigned int flags)
>  {
>  	struct __btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_KERNEL);
>  
> @@ -133,31 +84,15 @@ __btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info, const char *name,
>  		return NULL;
>  
>  	ret->fs_info = fs_info;
> -	ret->limit_active = limit_active;
>  	atomic_set(&ret->pending, 0);
> -	if (thresh == 0)
> -		thresh = DFT_THRESHOLD;
> -	/* For low threshold, disabling threshold is a better choice */
> -	if (thresh < DFT_THRESHOLD) {
> -		ret->current_active = limit_active;
> -		ret->thresh = NO_THRESHOLD;
> -	} else {
> -		/*
> -		 * For threshold-able wq, let its concurrency grow on demand.
> -		 * Use minimal max_active at alloc time to reduce resource
> -		 * usage.
> -		 */
> -		ret->current_active = 1;
> -		ret->thresh = thresh;
> -	}
>  
>  	if (flags & WQ_HIGHPRI)
>  		ret->normal_wq = alloc_workqueue("%s-%s-high", flags,
> -						 ret->current_active, "btrfs",
> +						 0, "btrfs",
>  						 name);
>  	else
>  		ret->normal_wq = alloc_workqueue("%s-%s", flags,
> -						 ret->current_active, "btrfs",
> +						 0, "btrfs",
>  						 name);
>  	if (!ret->normal_wq) {
>  		kfree(ret);
> @@ -166,7 +101,6 @@ __btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info, const char *name,
>  
>  	INIT_LIST_HEAD(&ret->ordered_list);
>  	spin_lock_init(&ret->list_lock);
> -	spin_lock_init(&ret->thres_lock);
>  	trace_btrfs_workqueue_alloc(ret, name, flags & WQ_HIGHPRI);
>  	return ret;
>  }
> @@ -176,9 +110,7 @@ __btrfs_destroy_workqueue(struct __btrfs_workqueue *wq);
>  
>  struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info,
>  					      const char *name,
> -					      unsigned int flags,
> -					      int limit_active,
> -					      int thresh)
> +					      unsigned int flags)
>  {
>  	struct btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_KERNEL);
>  
> @@ -186,16 +118,14 @@ struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info,
>  		return NULL;
>  
>  	ret->normal = __btrfs_alloc_workqueue(fs_info, name,
> -					      flags & ~WQ_HIGHPRI,
> -					      limit_active, thresh);
> +					      flags & ~WQ_HIGHPRI);
>  	if (!ret->normal) {
>  		kfree(ret);
>  		return NULL;
>  	}
>  
>  	if (flags & WQ_HIGHPRI) {
> -		ret->high = __btrfs_alloc_workqueue(fs_info, name, flags,
> -						    limit_active, thresh);
> +		ret->high = __btrfs_alloc_workqueue(fs_info, name, flags);
>  		if (!ret->high) {
>  			__btrfs_destroy_workqueue(ret->normal);
>  			kfree(ret);
> @@ -205,66 +135,6 @@ struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> -/*
> - * Hook for threshold which will be called in btrfs_queue_work.
> - * This hook WILL be called in IRQ handler context,
> - * so workqueue_set_max_active MUST NOT be called in this hook
> - */
> -static inline void thresh_queue_hook(struct __btrfs_workqueue *wq)
> -{
> -	if (wq->thresh == NO_THRESHOLD)
> -		return;
> -	atomic_inc(&wq->pending);
> -}
> -
> -/*
> - * Hook for threshold which will be called before executing the work,
> - * This hook is called in kthread content.
> - * So workqueue_set_max_active is called here.
> - */
> -static inline void thresh_exec_hook(struct __btrfs_workqueue *wq)
> -{
> -	int new_current_active;
> -	long pending;
> -	int need_change = 0;
> -
> -	if (wq->thresh == NO_THRESHOLD)
> -		return;
> -
> -	atomic_dec(&wq->pending);
> -	spin_lock(&wq->thres_lock);
> -	/*
> -	 * Use wq->count to limit the calling frequency of
> -	 * workqueue_set_max_active.
> -	 */
> -	wq->count++;
> -	wq->count %= (wq->thresh / 4);
> -	if (!wq->count)
> -		goto  out;
> -	new_current_active = wq->current_active;
> -
> -	/*
> -	 * pending may be changed later, but it's OK since we really
> -	 * don't need it so accurate to calculate new_max_active.
> -	 */
> -	pending = atomic_read(&wq->pending);
> -	if (pending > wq->thresh)
> -		new_current_active++;
> -	if (pending < wq->thresh / 2)
> -		new_current_active--;
> -	new_current_active = clamp_val(new_current_active, 1, wq->limit_active);
> -	if (new_current_active != wq->current_active)  {
> -		need_change = 1;
> -		wq->current_active = new_current_active;
> -	}
> -out:
> -	spin_unlock(&wq->thres_lock);
> -
> -	if (need_change) {
> -		workqueue_set_max_active(wq->normal_wq, wq->current_active);
> -	}
> -}
> -
>  static void run_ordered_work(struct __btrfs_workqueue *wq)
>  {
>  	struct list_head *list = &wq->ordered_list;
> @@ -333,7 +203,7 @@ static void normal_work_helper(struct btrfs_work *work)
>  	wtag = work;
>  
>  	trace_btrfs_work_sched(work);
> -	thresh_exec_hook(wq);
> +	atomic_dec(&wq->pending);
>  	work->func(work);
>  	if (need_order) {
>  		set_bit(WORK_DONE_BIT, &work->flags);
> @@ -362,7 +232,7 @@ static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
>  	unsigned long flags;
>  
>  	work->wq = wq;
> -	thresh_queue_hook(wq);
> +	atomic_inc(&wq->pending);
>  	if (work->ordered_func) {
>  		spin_lock_irqsave(&wq->list_lock, flags);
>  		list_add_tail(&work->ordered_list, &wq->ordered_list);
> @@ -402,15 +272,6 @@ void btrfs_destroy_workqueue(struct btrfs_workqueue *wq)
>  	kfree(wq);
>  }
>  
> -void btrfs_workqueue_set_max(struct btrfs_workqueue *wq, int limit_active)
> -{
> -	if (!wq)
> -		return;
> -	wq->normal->limit_active = limit_active;
> -	if (wq->high)
> -		wq->high->limit_active = limit_active;
> -}
> -
>  void btrfs_set_work_high_priority(struct btrfs_work *work)
>  {
>  	set_bit(WORK_HIGH_PRIO_BIT, &work->flags);
> diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
> index fc957e0..957d92b 100644
> --- a/fs/btrfs/async-thread.h
> +++ b/fs/btrfs/async-thread.h
> @@ -41,6 +41,27 @@ struct btrfs_work {
>  	unsigned long flags;
>  };
>  
> +struct __btrfs_workqueue {
> +	struct workqueue_struct *normal_wq;
> +
> +	/* File system this workqueue services */
> +	struct btrfs_fs_info *fs_info;
> +
> +	/* List head pointing to ordered work list */
> +	struct list_head ordered_list;
> +
> +	/* Spinlock for ordered_list */
> +	spinlock_t list_lock;
> +
> +	/* Thresholding related variants */
> +	atomic_t pending;
> +};
> +
> +struct btrfs_workqueue {
> +	struct __btrfs_workqueue *normal;
> +	struct __btrfs_workqueue *high;
> +};
> +
>  #define BTRFS_WORK_HELPER_PROTO(name)					\
>  void btrfs_##name(struct work_struct *arg)
>  
> @@ -70,9 +91,7 @@ BTRFS_WORK_HELPER_PROTO(scrubparity_helper);
>  
>  struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info,
>  					      const char *name,
> -					      unsigned int flags,
> -					      int limit_active,
> -					      int thresh);
> +					      unsigned int flags);
>  void btrfs_init_work(struct btrfs_work *work, btrfs_work_func_t helper,
>  		     btrfs_func_t func,
>  		     btrfs_func_t ordered_func,
> @@ -80,9 +99,7 @@ void btrfs_init_work(struct btrfs_work *work, btrfs_work_func_t helper,
>  void btrfs_queue_work(struct btrfs_workqueue *wq,
>  		      struct btrfs_work *work);
>  void btrfs_destroy_workqueue(struct btrfs_workqueue *wq);
> -void btrfs_workqueue_set_max(struct btrfs_workqueue *wq, int max);
>  void btrfs_set_work_high_priority(struct btrfs_work *work);
>  struct btrfs_fs_info *btrfs_work_owner(const struct btrfs_work *work);
>  struct btrfs_fs_info *btrfs_workqueue_owner(const struct __btrfs_workqueue *wq);
> -bool btrfs_workqueue_normal_congested(const struct btrfs_workqueue *wq);
>  #endif
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 19e4ad2..8b371ab 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -22,6 +22,7 @@
>  #include "disk-io.h"
>  #include "transaction.h"
>  #include "ctree.h"
> +#include "async-thread.h"
>  
>  #define BTRFS_DELAYED_WRITEBACK		512
>  #define BTRFS_DELAYED_BACKGROUND	128
> @@ -1369,8 +1370,12 @@ static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
>  {
>  	struct btrfs_async_delayed_work *async_work;
>  
> +	/*
> +	 * Limit the number of concurrent works to 64 to keep low
> +	 * memory footprint.
> +	 */
>  	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND ||
> -	    btrfs_workqueue_normal_congested(fs_info->delayed_workers))
> +	    atomic_read(&fs_info->delayed_workers->normal->pending) > 64)
>  		return 0;
>  
>  	async_work = kmalloc(sizeof(*async_work), GFP_NOFS);
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 373d3f6f..25de5e7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2350,69 +2350,44 @@ static void btrfs_init_qgroup(struct btrfs_fs_info *fs_info)
>  static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info,
>  		struct btrfs_fs_devices *fs_devices)
>  {
> -	int max_active = fs_info->thread_pool_size;
>  	unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
>  
>  	fs_info->workers =
> -		btrfs_alloc_workqueue(fs_info, "worker",
> -				      flags | WQ_HIGHPRI, max_active, 16);
> -
> +		btrfs_alloc_workqueue(fs_info, "worker", flags | WQ_HIGHPRI);
>  	fs_info->delalloc_workers =
> -		btrfs_alloc_workqueue(fs_info, "delalloc",
> -				      flags, max_active, 2);
> -
> +		btrfs_alloc_workqueue(fs_info, "delalloc", flags);
>  	fs_info->flush_workers =
> -		btrfs_alloc_workqueue(fs_info, "flush_delalloc",
> -				      flags, max_active, 0);
> -
> +		btrfs_alloc_workqueue(fs_info, "flush_delalloc", flags);
>  	fs_info->caching_workers =
> -		btrfs_alloc_workqueue(fs_info, "cache", flags, max_active, 0);
> -
> +		btrfs_alloc_workqueue(fs_info, "cache", flags);
>  	fs_info->submit_workers =
> -		btrfs_alloc_workqueue(fs_info, "submit", flags,
> -				      min_t(u64, fs_devices->num_devices,
> -					    max_active), 1);
> -
> +		btrfs_alloc_workqueue(fs_info, "submit", flags);
>  	fs_info->fixup_workers =
> -		btrfs_alloc_workqueue(fs_info, "fixup", flags, 1, 0);
> -
> -	/*
> -	 * endios are largely parallel and should have a very
> -	 * low idle thresh
> -	 */
> +		btrfs_alloc_workqueue(fs_info, "fixup", flags);
>  	fs_info->endio_workers =
> -		btrfs_alloc_workqueue(fs_info, "endio", flags, max_active, 4);
> +		btrfs_alloc_workqueue(fs_info, "endio", flags);
>  	fs_info->endio_meta_workers =
> -		btrfs_alloc_workqueue(fs_info, "endio-meta", flags,
> -				      max_active, 4);
> +		btrfs_alloc_workqueue(fs_info, "endio-meta", flags);
>  	fs_info->endio_meta_write_workers =
> -		btrfs_alloc_workqueue(fs_info, "endio-meta-write", flags,
> -				      max_active, 2);
> +		btrfs_alloc_workqueue(fs_info, "endio-meta-write", flags);
>  	fs_info->endio_raid56_workers =
> -		btrfs_alloc_workqueue(fs_info, "endio-raid56", flags,
> -				      max_active, 4);
> +		btrfs_alloc_workqueue(fs_info, "endio-raid56", flags);
>  	fs_info->endio_repair_workers =
> -		btrfs_alloc_workqueue(fs_info, "endio-repair", flags, 1, 0);
> +		btrfs_alloc_workqueue(fs_info, "endio-repair", flags);
>  	fs_info->rmw_workers =
> -		btrfs_alloc_workqueue(fs_info, "rmw", flags, max_active, 2);
> +		btrfs_alloc_workqueue(fs_info, "rmw", flags);
>  	fs_info->endio_write_workers =
> -		btrfs_alloc_workqueue(fs_info, "endio-write", flags,
> -				      max_active, 2);
> +		btrfs_alloc_workqueue(fs_info, "endio-write", flags);
>  	fs_info->endio_freespace_worker =
> -		btrfs_alloc_workqueue(fs_info, "freespace-write", flags,
> -				      max_active, 0);
> +		btrfs_alloc_workqueue(fs_info, "freespace-write", flags);
>  	fs_info->delayed_workers =
> -		btrfs_alloc_workqueue(fs_info, "delayed-meta", flags,
> -				      max_active, 0);
> +		btrfs_alloc_workqueue(fs_info, "delayed-meta", flags);
>  	fs_info->readahead_workers =
> -		btrfs_alloc_workqueue(fs_info, "readahead", flags,
> -				      max_active, 2);
> +		btrfs_alloc_workqueue(fs_info, "readahead", flags);
>  	fs_info->qgroup_rescan_workers =
> -		btrfs_alloc_workqueue(fs_info, "qgroup-rescan", flags, 1, 0);
> +		btrfs_alloc_workqueue(fs_info, "qgroup-rescan", flags);
>  	fs_info->extent_workers =
> -		btrfs_alloc_workqueue(fs_info, "extent-refs", flags,
> -				      min_t(u64, fs_devices->num_devices,
> -					    max_active), 8);
> +		btrfs_alloc_workqueue(fs_info, "extent-refs", flags);
>  
>  	if (!(fs_info->workers && fs_info->delalloc_workers &&
>  	      fs_info->submit_workers && fs_info->flush_workers &&
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index e3f6c49..25ba47a 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -4012,27 +4012,24 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
>  						int is_dev_replace)
>  {
>  	unsigned int flags = WQ_FREEZABLE | WQ_UNBOUND;
> -	int max_active = fs_info->thread_pool_size;
>  
>  	if (fs_info->scrub_workers_refcnt == 0) {
>  		fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
> -				flags, is_dev_replace ? 1 : max_active, 4);
> +							       flags);
>  		if (!fs_info->scrub_workers)
>  			goto fail_scrub_workers;
>  
>  		fs_info->scrub_wr_completion_workers =
> -			btrfs_alloc_workqueue(fs_info, "scrubwrc", flags,
> -					      max_active, 2);
> +			btrfs_alloc_workqueue(fs_info, "scrubwrc", flags);
>  		if (!fs_info->scrub_wr_completion_workers)
>  			goto fail_scrub_wr_completion_workers;
>  
>  		fs_info->scrub_nocow_workers =
> -			btrfs_alloc_workqueue(fs_info, "scrubnc", flags, 1, 0);
> +			btrfs_alloc_workqueue(fs_info, "scrubnc", flags);
>  		if (!fs_info->scrub_nocow_workers)
>  			goto fail_scrub_nocow_workers;
>  		fs_info->scrub_parity_workers =
> -			btrfs_alloc_workqueue(fs_info, "scrubparity", flags,
> -					      max_active, 2);
> +			btrfs_alloc_workqueue(fs_info, "scrubparity", flags);
>  		if (!fs_info->scrub_parity_workers)
>  			goto fail_scrub_parity_workers;
>  	}
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 161694b..2e3d315 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1647,33 +1647,6 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  	return ERR_PTR(error);
>  }
>  
> -static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
> -				     int new_pool_size, int old_pool_size)
> -{
> -	if (new_pool_size == old_pool_size)
> -		return;
> -
> -	fs_info->thread_pool_size = new_pool_size;
> -
> -	btrfs_info(fs_info, "resize thread pool %d -> %d",
> -	       old_pool_size, new_pool_size);
> -
> -	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->submit_workers, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->endio_workers, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->endio_meta_workers, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->endio_meta_write_workers,
> -				new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->endio_write_workers, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->endio_freespace_worker, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->delayed_workers, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->readahead_workers, new_pool_size);
> -	btrfs_workqueue_set_max(fs_info->scrub_wr_completion_workers,
> -				new_pool_size);
> -}
> -
>  static inline void btrfs_remount_prepare(struct btrfs_fs_info *fs_info)
>  {
>  	set_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
> @@ -1716,7 +1689,6 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  	unsigned long old_opts = fs_info->mount_opt;
>  	unsigned long old_compress_type = fs_info->compress_type;
>  	u64 old_max_inline = fs_info->max_inline;
> -	int old_thread_pool_size = fs_info->thread_pool_size;
>  	unsigned int old_metadata_ratio = fs_info->metadata_ratio;
>  	int ret;
>  
> @@ -1745,8 +1717,6 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  	}
>  
>  	btrfs_remount_begin(fs_info, old_opts, *flags);
> -	btrfs_resize_thread_pool(fs_info,
> -		fs_info->thread_pool_size, old_thread_pool_size);
>  
>  	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
>  		goto out;
> @@ -1855,8 +1825,6 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  	fs_info->mount_opt = old_opts;
>  	fs_info->compress_type = old_compress_type;
>  	fs_info->max_inline = old_max_inline;
> -	btrfs_resize_thread_pool(fs_info,
> -		old_thread_pool_size, fs_info->thread_pool_size);
>  	fs_info->metadata_ratio = old_metadata_ratio;
>  	btrfs_remount_cleanup(fs_info, old_opts);
>  	return ret;
> 
