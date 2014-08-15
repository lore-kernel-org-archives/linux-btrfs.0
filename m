Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32165 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaHOPhE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Aug 2014 11:37:04 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7FFb3xY030593
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Aug 2014 15:37:03 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s7FFb28D004402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Aug 2014 15:37:02 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7FFb2Dm016366
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Aug 2014 15:37:02 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3] Btrfs: fix task hang under heavy compressed write
Date: Fri, 15 Aug 2014 23:36:53 +0800
Message-Id: <1408117013-305-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been reported and discussed for a long time, and this hang occurs in
both 3.15 and 3.16.

Btrfs now migrates to use kernel workqueue, but it introduces this hang problem.

Btrfs has a kind of work queued as an ordered way, which means that its
ordered_func() must be processed in the way of FIFO, so it usually looks like --

normal_work_helper(arg)
    work = container_of(arg, struct btrfs_work, normal_work);

    work->func() <---- (we name it work X)
    for ordered_work in wq->ordered_list
            ordered_work->ordered_func()
            ordered_work->ordered_free()

The hang is a rare case, first when we find free space, we get an uncached block
group, then we go to read its free space cache inode for free space information,
so it will

file a readahead request
    btrfs_readpages()
         for page that is not in page cache
                __do_readpage()
                     submit_extent_page()
                           btrfs_submit_bio_hook()
                                 btrfs_bio_wq_end_io()
                                 submit_bio()
                                 end_workqueue_bio() <--(ret by the 1st endio)
                                      queue a work(named work Y) for the 2nd
                                      also the real endio()

So the hang occurs when work Y's work_struct and work X's work_struct happens
to share the same address.

A bit more explanation,

A,B,C -- struct btrfs_work
arg   -- struct work_struct

kthread:
worker_thread()
    pick up a work_struct from @worklist
    process_one_work(arg)
	worker->current_work = arg;  <-- arg is A->normal_work
	worker->current_func(arg)
		normal_work_helper(arg)
		     A = container_of(arg, struct btrfs_work, normal_work);

		     A->func()
		     A->ordered_func()
		     A->ordered_free()  <-- A gets freed

		     B->ordered_func()
			  submit_compressed_extents()
			      find_free_extent()
				  load_free_space_inode()
				      ...   <-- (the above readhead stack)
				      end_workqueue_bio()
					   btrfs_queue_work(work C)
		     B->ordered_free()

As if work A has a high priority in wq->ordered_list and there are more ordered
works queued after it, such as B->ordered_func(), its memory could have been
freed before normal_work_helper() returns, which means that kernel workqueue
code worker_thread() still has worker->current_work pointer to be work
A->normal_work's, ie. arg's address.

Meanwhile, work C is allocated after work A is freed, work C->normal_work
and work A->normal_work are likely to share the same address(I confirmed this
with ftrace output, so I'm not just guessing, it's rare though).

When another kthread picks up work C->normal_work to process, and finds our
kthread is processing it(see find_worker_executing_work()), it'll think
work C as a collision and skip then, which ends up nobody processing work C.

So the situation is that our kthread is waiting forever on work C.

Besides, there're other cases that can lead to deadlock, but the real problem
is that all btrfs workqueue shares one work->func, -- normal_work_helper,
so this makes each workqueue to have its own helper function, but only a
wraper pf normal_work_helper.

With this patch, I no long hit the above hang.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v3:
  - Adopting Chris's advice, this has each workqueue provide its own helper
    function.
  - This is rebased on the latest Chris's for-linus branch.

v2:
  - This changes a bit to not defer all ->ordered_free(), but only defer the
    work that triggers this run_ordered_work().  Actually we don't need to
    defer other ->ordered_free() because their work cannot be this kthread
    worker's @current_work.  We can benefit from it since this can pin less
    memory during the period.

 fs/btrfs/async-thread.c  | 44 +++++++++++++++++++++++++++------
 fs/btrfs/async-thread.h  | 28 ++++++++++++++++++++-
 fs/btrfs/delayed-inode.c |  4 +--
 fs/btrfs/disk-io.c       | 63 ++++++++++++++++++++++++++----------------------
 fs/btrfs/extent-tree.c   |  7 +++---
 fs/btrfs/inode.c         | 35 ++++++++++++++++++---------
 fs/btrfs/ordered-data.c  |  1 +
 fs/btrfs/qgroup.c        |  1 +
 fs/btrfs/raid56.c        |  9 ++++---
 fs/btrfs/reada.c         |  3 ++-
 fs/btrfs/scrub.c         | 14 ++++++-----
 fs/btrfs/volumes.c       |  3 ++-
 12 files changed, 146 insertions(+), 66 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 5a201d8..fbd76de 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -22,7 +22,6 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
-#include <linux/workqueue.h>
 #include "async-thread.h"
 #include "ctree.h"
 
@@ -55,8 +54,39 @@ struct btrfs_workqueue {
 	struct __btrfs_workqueue *high;
 };
 
-static inline struct __btrfs_workqueue
-*__btrfs_alloc_workqueue(const char *name, int flags, int max_active,
+static void normal_work_helper(struct btrfs_work *work);
+
+#define BTRFS_WORK_HELPER(name)					\
+void btrfs_##name(struct work_struct *arg)				\
+{									\
+	struct btrfs_work *work = container_of(arg, struct btrfs_work,	\
+					       normal_work);		\
+	normal_work_helper(work);					\
+}
+
+BTRFS_WORK_HELPER(worker_helper);
+BTRFS_WORK_HELPER(delalloc_helper);
+BTRFS_WORK_HELPER(flush_delalloc_helper);
+BTRFS_WORK_HELPER(cache_helper);
+BTRFS_WORK_HELPER(submit_helper);
+BTRFS_WORK_HELPER(fixup_helper);
+BTRFS_WORK_HELPER(endio_helper);
+BTRFS_WORK_HELPER(endio_meta_helper);
+BTRFS_WORK_HELPER(endio_meta_write_helper);
+BTRFS_WORK_HELPER(endio_raid56_helper);
+BTRFS_WORK_HELPER(rmw_helper);
+BTRFS_WORK_HELPER(endio_write_helper);
+BTRFS_WORK_HELPER(freespace_write_helper);
+BTRFS_WORK_HELPER(delayed_meta_helper);
+BTRFS_WORK_HELPER(readahead_helper);
+BTRFS_WORK_HELPER(qgroup_rescan_helper);
+BTRFS_WORK_HELPER(extent_refs_helper);
+BTRFS_WORK_HELPER(scrub_helper);
+BTRFS_WORK_HELPER(scrubwrc_helper);
+BTRFS_WORK_HELPER(scrubnc_helper);
+
+static struct __btrfs_workqueue *
+__btrfs_alloc_workqueue(const char *name, int flags, int max_active,
 			 int thresh)
 {
 	struct __btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_NOFS);
@@ -232,13 +262,11 @@ static void run_ordered_work(struct __btrfs_workqueue *wq)
 	spin_unlock_irqrestore(lock, flags);
 }
 
-static void normal_work_helper(struct work_struct *arg)
+static void normal_work_helper(struct btrfs_work *work)
 {
-	struct btrfs_work *work;
 	struct __btrfs_workqueue *wq;
 	int need_order = 0;
 
-	work = container_of(arg, struct btrfs_work, normal_work);
 	/*
 	 * We should not touch things inside work in the following cases:
 	 * 1) after work->func() if it has no ordered_free
@@ -262,7 +290,7 @@ static void normal_work_helper(struct work_struct *arg)
 		trace_btrfs_all_work_done(work);
 }
 
-void btrfs_init_work(struct btrfs_work *work,
+void btrfs_init_work(struct btrfs_work *work, btrfs_work_func_t uniq_func,
 		     btrfs_func_t func,
 		     btrfs_func_t ordered_func,
 		     btrfs_func_t ordered_free)
@@ -270,7 +298,7 @@ void btrfs_init_work(struct btrfs_work *work,
 	work->func = func;
 	work->ordered_func = ordered_func;
 	work->ordered_free = ordered_free;
-	INIT_WORK(&work->normal_work, normal_work_helper);
+	INIT_WORK(&work->normal_work, uniq_func);
 	INIT_LIST_HEAD(&work->ordered_list);
 	work->flags = 0;
 }
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 9c6b66d..e9e31c9 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -19,12 +19,14 @@
 
 #ifndef __BTRFS_ASYNC_THREAD_
 #define __BTRFS_ASYNC_THREAD_
+#include <linux/workqueue.h>
 
 struct btrfs_workqueue;
 /* Internal use only */
 struct __btrfs_workqueue;
 struct btrfs_work;
 typedef void (*btrfs_func_t)(struct btrfs_work *arg);
+typedef void (*btrfs_work_func_t)(struct work_struct *arg);
 
 struct btrfs_work {
 	btrfs_func_t func;
@@ -38,11 +40,35 @@ struct btrfs_work {
 	unsigned long flags;
 };
 
+#define BTRFS_WORK_HELPER_PROTO(name)					\
+void btrfs_##name(struct work_struct *arg)
+
+BTRFS_WORK_HELPER_PROTO(worker_helper);
+BTRFS_WORK_HELPER_PROTO(delalloc_helper);
+BTRFS_WORK_HELPER_PROTO(flush_delalloc_helper);
+BTRFS_WORK_HELPER_PROTO(cache_helper);
+BTRFS_WORK_HELPER_PROTO(submit_helper);
+BTRFS_WORK_HELPER_PROTO(fixup_helper);
+BTRFS_WORK_HELPER_PROTO(endio_helper);
+BTRFS_WORK_HELPER_PROTO(endio_meta_helper);
+BTRFS_WORK_HELPER_PROTO(endio_meta_write_helper);
+BTRFS_WORK_HELPER_PROTO(endio_raid56_helper);
+BTRFS_WORK_HELPER_PROTO(rmw_helper);
+BTRFS_WORK_HELPER_PROTO(endio_write_helper);
+BTRFS_WORK_HELPER_PROTO(freespace_write_helper);
+BTRFS_WORK_HELPER_PROTO(delayed_meta_helper);
+BTRFS_WORK_HELPER_PROTO(readahead_helper);
+BTRFS_WORK_HELPER_PROTO(qgroup_rescan_helper);
+BTRFS_WORK_HELPER_PROTO(extent_refs_helper);
+BTRFS_WORK_HELPER_PROTO(scrub_helper);
+BTRFS_WORK_HELPER_PROTO(scrubwrc_helper);
+BTRFS_WORK_HELPER_PROTO(scrubnc_helper);
+
 struct btrfs_workqueue *btrfs_alloc_workqueue(const char *name,
 					      int flags,
 					      int max_active,
 					      int thresh);
-void btrfs_init_work(struct btrfs_work *work,
+void btrfs_init_work(struct btrfs_work *work, btrfs_work_func_t helper,
 		     btrfs_func_t func,
 		     btrfs_func_t ordered_func,
 		     btrfs_func_t ordered_free);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 0816814..054577b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1395,8 +1395,8 @@ static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
 		return -ENOMEM;
 
 	async_work->delayed_root = delayed_root;
-	btrfs_init_work(&async_work->work, btrfs_async_run_delayed_root,
-			NULL, NULL);
+	btrfs_init_work(&async_work->work, btrfs_delayed_meta_helper,
+			btrfs_async_run_delayed_root, NULL, NULL);
 	async_work->nr = nr;
 
 	btrfs_queue_work(root->fs_info->delayed_workers, &async_work->work);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fd9be2d..28098ba 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -39,7 +39,6 @@
 #include "btrfs_inode.h"
 #include "volumes.h"
 #include "print-tree.h"
-#include "async-thread.h"
 #include "locking.h"
 #include "tree-log.h"
 #include "free-space-cache.h"
@@ -714,42 +713,48 @@ static void end_workqueue_bio(struct bio *bio, int err)
 {
 	struct end_io_wq *end_io_wq = bio->bi_private;
 	struct btrfs_fs_info *fs_info;
+	struct btrfs_workqueue *wq;
+	btrfs_work_func_t func;
 
 	fs_info = end_io_wq->info;
 	end_io_wq->error = err;
 
-	if (likely(end_io_wq->metadata != BTRFS_WQ_ENDIO_DIO_REPAIR))
-		btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL,
-				NULL);
-	else
+	if (unlikely(end_io_wq->metadata == BTRFS_WQ_ENDIO_DIO_REPAIR &&
+		     !(bio->bi_rw & REQ_WRITE))) {
 		INIT_WORK(&end_io_wq->work.normal_work, dio_end_workqueue_fn);
+		queue_work(system_wq, &end_io_wq->work.normal_work);
+		return;
+	}
 
 	if (bio->bi_rw & REQ_WRITE) {
-		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA)
-			btrfs_queue_work(fs_info->endio_meta_write_workers,
-					 &end_io_wq->work);
-		else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_FREE_SPACE)
-			btrfs_queue_work(fs_info->endio_freespace_worker,
-					 &end_io_wq->work);
-		else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56)
-			btrfs_queue_work(fs_info->endio_raid56_workers,
-					 &end_io_wq->work);
-		else
-			btrfs_queue_work(fs_info->endio_write_workers,
-					 &end_io_wq->work);
+		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA) {
+			wq = fs_info->endio_meta_write_workers;
+			func = btrfs_endio_meta_write_helper;
+		} else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_FREE_SPACE) {
+			wq = fs_info->endio_freespace_worker;
+			func = btrfs_freespace_write_helper;
+		} else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56) {
+			wq = fs_info->endio_raid56_workers;
+			func = btrfs_endio_raid56_helper;
+		} else {
+			wq = fs_info->endio_write_workers;
+			func = btrfs_endio_write_helper;
+		}
 	} else {
-		if (unlikely(end_io_wq->metadata == BTRFS_WQ_ENDIO_DIO_REPAIR))
-			queue_work(system_wq, &end_io_wq->work.normal_work);
-		else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56)
-			btrfs_queue_work(fs_info->endio_raid56_workers,
-					 &end_io_wq->work);
-		else if (end_io_wq->metadata)
-			btrfs_queue_work(fs_info->endio_meta_workers,
-					 &end_io_wq->work);
-		else
-			btrfs_queue_work(fs_info->endio_workers,
-					 &end_io_wq->work);
+		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56) {
+			wq = fs_info->endio_raid56_workers;
+			func = btrfs_endio_raid56_helper;
+		} else if (end_io_wq->metadata) {
+			wq = fs_info->endio_meta_workers;
+			func = btrfs_endio_meta_helper;
+		} else {
+			wq = fs_info->endio_workers;
+			func = btrfs_endio_helper;
+		}
 	}
+
+	btrfs_init_work(&end_io_wq->work, func, end_workqueue_fn, NULL, NULL);
+	btrfs_queue_work(wq, &end_io_wq->work);
 }
 
 /*
@@ -857,7 +862,7 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 	async->submit_bio_start = submit_bio_start;
 	async->submit_bio_done = submit_bio_done;
 
-	btrfs_init_work(&async->work, run_one_async_start,
+	btrfs_init_work(&async->work, btrfs_worker_helper, run_one_async_start,
 			run_one_async_done, run_one_async_free);
 
 	async->bio_flags = bio_flags;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ef0845d..e105558 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -552,7 +552,8 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	caching_ctl->block_group = cache;
 	caching_ctl->progress = cache->key.objectid;
 	atomic_set(&caching_ctl->count, 1);
-	btrfs_init_work(&caching_ctl->work, caching_thread, NULL, NULL);
+	btrfs_init_work(&caching_ctl->work, btrfs_cache_helper,
+			caching_thread, NULL, NULL);
 
 	spin_lock(&cache->lock);
 	/*
@@ -2749,8 +2750,8 @@ int btrfs_async_run_delayed_refs(struct btrfs_root *root,
 		async->sync = 0;
 	init_completion(&async->wait);
 
-	btrfs_init_work(&async->work, delayed_ref_async_start,
-			NULL, NULL);
+	btrfs_init_work(&async->work, btrfs_extent_refs_helper,
+			delayed_ref_async_start, NULL, NULL);
 
 	btrfs_queue_work(root->fs_info->extent_workers, &async->work);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index de1df3a..c591af5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1111,8 +1111,10 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->end = cur_end;
 		INIT_LIST_HEAD(&async_cow->extents);
 
-		btrfs_init_work(&async_cow->work, async_cow_start,
-				async_cow_submit, async_cow_free);
+		btrfs_init_work(&async_cow->work,
+				btrfs_delalloc_helper,
+				async_cow_start, async_cow_submit,
+				async_cow_free);
 
 		nr_pages = (cur_end - start + PAGE_CACHE_SIZE) >>
 			PAGE_CACHE_SHIFT;
@@ -1924,7 +1926,8 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
 
 	SetPageChecked(page);
 	page_cache_get(page);
-	btrfs_init_work(&fixup->work, btrfs_writepage_fixup_worker, NULL, NULL);
+	btrfs_init_work(&fixup->work, btrfs_fixup_helper,
+			btrfs_writepage_fixup_worker, NULL, NULL);
 	fixup->page = page;
 	btrfs_queue_work(root->fs_info->fixup_workers, &fixup->work);
 	return -EBUSY;
@@ -2869,7 +2872,8 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	struct inode *inode = page->mapping->host;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_extent *ordered_extent = NULL;
-	struct btrfs_workqueue *workers;
+	struct btrfs_workqueue *wq;
+	btrfs_work_func_t func;
 
 	trace_btrfs_writepage_end_io_hook(page, start, end, uptodate);
 
@@ -2878,13 +2882,17 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 					    end - start + 1, uptodate))
 		return 0;
 
-	btrfs_init_work(&ordered_extent->work, finish_ordered_fn, NULL, NULL);
+	if (btrfs_is_free_space_inode(inode)) {
+		wq = root->fs_info->endio_freespace_worker;
+		func = btrfs_freespace_write_helper;
+	} else {
+		wq = root->fs_info->endio_write_workers;
+		func = btrfs_endio_write_helper;
+	}
 
-	if (btrfs_is_free_space_inode(inode))
-		workers = root->fs_info->endio_freespace_worker;
-	else
-		workers = root->fs_info->endio_write_workers;
-	btrfs_queue_work(workers, &ordered_extent->work);
+	btrfs_init_work(&ordered_extent->work, func, finish_ordered_fn, NULL,
+			NULL);
+	btrfs_queue_work(wq, &ordered_extent->work);
 
 	return 0;
 }
@@ -7503,7 +7511,8 @@ again:
 	if (!ret)
 		goto out_test;
 
-	btrfs_init_work(&ordered->work, finish_ordered_fn, NULL, NULL);
+	btrfs_init_work(&ordered->work, btrfs_endio_write_helper,
+			finish_ordered_fn, NULL, NULL);
 	btrfs_queue_work(root->fs_info->endio_write_workers,
 			 &ordered->work);
 out_test:
@@ -8866,7 +8875,9 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 	work->inode = inode;
 	work->wait = wait;
 	work->delay_iput = delay_iput;
-	btrfs_init_work(&work->work, btrfs_run_delalloc_work, NULL, NULL);
+	WARN_ON_ONCE(!inode);
+	btrfs_init_work(&work->work, btrfs_flush_delalloc_helper,
+			btrfs_run_delalloc_work, NULL, NULL);
 
 	return work;
 }
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 963895c..ac734ec 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -615,6 +615,7 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
 		spin_unlock(&root->ordered_extent_lock);
 
 		btrfs_init_work(&ordered->flush_work,
+				btrfs_flush_delalloc_helper,
 				btrfs_run_ordered_extent_work, NULL, NULL);
 		list_add_tail(&ordered->work_list, &works);
 		btrfs_queue_work(root->fs_info->flush_workers,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c11acca..b4a27bf 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2722,6 +2722,7 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 	memset(&fs_info->qgroup_rescan_work, 0,
 	       sizeof(fs_info->qgroup_rescan_work));
 	btrfs_init_work(&fs_info->qgroup_rescan_work,
+			btrfs_qgroup_rescan_helper,
 			btrfs_qgroup_rescan_worker, NULL, NULL);
 
 	if (ret) {
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 6c5c5ae..6a41631 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1416,7 +1416,8 @@ cleanup:
 
 static void async_rmw_stripe(struct btrfs_raid_bio *rbio)
 {
-	btrfs_init_work(&rbio->work, rmw_work, NULL, NULL);
+	btrfs_init_work(&rbio->work, btrfs_rmw_helper,
+			rmw_work, NULL, NULL);
 
 	btrfs_queue_work(rbio->fs_info->rmw_workers,
 			 &rbio->work);
@@ -1424,7 +1425,8 @@ static void async_rmw_stripe(struct btrfs_raid_bio *rbio)
 
 static void async_read_rebuild(struct btrfs_raid_bio *rbio)
 {
-	btrfs_init_work(&rbio->work, read_rebuild_work, NULL, NULL);
+	btrfs_init_work(&rbio->work, btrfs_rmw_helper,
+			read_rebuild_work, NULL, NULL);
 
 	btrfs_queue_work(rbio->fs_info->rmw_workers,
 			 &rbio->work);
@@ -1665,7 +1667,8 @@ static void btrfs_raid_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	plug = container_of(cb, struct btrfs_plug_cb, cb);
 
 	if (from_schedule) {
-		btrfs_init_work(&plug->work, unplug_work, NULL, NULL);
+		btrfs_init_work(&plug->work, btrfs_rmw_helper,
+				unplug_work, NULL, NULL);
 		btrfs_queue_work(plug->info->rmw_workers,
 				 &plug->work);
 		return;
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 85eb55d..b63ae20 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -798,7 +798,8 @@ static void reada_start_machine(struct btrfs_fs_info *fs_info)
 		/* FIXME we cannot handle this properly right now */
 		BUG();
 	}
-	btrfs_init_work(&rmw->work, reada_start_machine_worker, NULL, NULL);
+	btrfs_init_work(&rmw->work, btrfs_readahead_helper,
+			reada_start_machine_worker, NULL, NULL);
 	rmw->fs_info = fs_info;
 
 	btrfs_queue_work(fs_info->readahead_workers, &rmw->work);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 695623e..771f0ab 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -427,8 +427,8 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 		sbio->index = i;
 		sbio->sctx = sctx;
 		sbio->page_count = 0;
-		btrfs_init_work(&sbio->work, scrub_bio_end_io_worker,
-				NULL, NULL);
+		btrfs_init_work(&sbio->work, btrfs_scrub_helper,
+				scrub_bio_end_io_worker, NULL, NULL);
 
 		if (i != SCRUB_BIOS_PER_SCTX - 1)
 			sctx->bios[i]->next_free = i + 1;
@@ -997,8 +997,8 @@ nodatasum_case:
 		fixup_nodatasum->root = fs_info->extent_root;
 		fixup_nodatasum->mirror_num = failed_mirror_index + 1;
 		scrub_pending_trans_workers_inc(sctx);
-		btrfs_init_work(&fixup_nodatasum->work, scrub_fixup_nodatasum,
-				NULL, NULL);
+		btrfs_init_work(&fixup_nodatasum->work, btrfs_scrub_helper,
+				scrub_fixup_nodatasum, NULL, NULL);
 		btrfs_queue_work(fs_info->scrub_workers,
 				 &fixup_nodatasum->work);
 		goto out;
@@ -1624,7 +1624,8 @@ static void scrub_wr_bio_end_io(struct bio *bio, int err)
 	sbio->err = err;
 	sbio->bio = bio;
 
-	btrfs_init_work(&sbio->work, scrub_wr_bio_end_io_worker, NULL, NULL);
+	btrfs_init_work(&sbio->work, btrfs_scrubwrc_helper,
+			 scrub_wr_bio_end_io_worker, NULL, NULL);
 	btrfs_queue_work(fs_info->scrub_wr_completion_workers, &sbio->work);
 }
 
@@ -3232,7 +3233,8 @@ static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 	nocow_ctx->len = len;
 	nocow_ctx->mirror_num = mirror_num;
 	nocow_ctx->physical_for_dev_replace = physical_for_dev_replace;
-	btrfs_init_work(&nocow_ctx->work, copy_nocow_pages_worker, NULL, NULL);
+	btrfs_init_work(&nocow_ctx->work, btrfs_scrubnc_helper,
+			copy_nocow_pages_worker, NULL, NULL);
 	INIT_LIST_HEAD(&nocow_ctx->inodes);
 	btrfs_queue_work(fs_info->scrub_nocow_workers,
 			 &nocow_ctx->work);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index db67c8a..f20c288 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5887,7 +5887,8 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	else
 		generate_random_uuid(dev->uuid);
 
-	btrfs_init_work(&dev->work, pending_bios_fn, NULL, NULL);
+	btrfs_init_work(&dev->work, btrfs_submit_helper,
+			pending_bios_fn, NULL, NULL);
 
 	return dev;
 }
-- 
1.8.1.4

