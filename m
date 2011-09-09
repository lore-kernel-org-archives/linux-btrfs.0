From: jeffm@suse.com
Subject: [patch v3 14/23] btrfs: async-thread.c: Make functions with no error conditions return void
Date: Thu, 08 Sep 2011 20:22:54 -0400
Message-ID: <20110909002732.404871770@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 run_ordered_completions, btrfs_stop_workers, btrfs_requeue_work, and
 btrfs_queue_worker don't have any error conditions and should return
 void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/async-thread.c |   31 ++++++++++---------------------
 fs/btrfs/async-thread.h |    7 ++++---
 2 files changed, 14 insertions(+), 24 deletions(-)

--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -95,7 +95,6 @@ static void start_new_worker_func(struct
 static int start_new_worker(struct btrfs_workers *queue)
 {
 	struct worker_start *start;
-	int ret;
 
 	start = kzalloc(sizeof(*start), GFP_NOFS);
 	if (!start)
@@ -103,10 +102,8 @@ static int start_new_worker(struct btrfs
 
 	start->work.func = start_new_worker_func;
 	start->queue = queue;
-	ret = btrfs_queue_worker(queue->atomic_worker_start, &start->work);
-	if (ret)
-		kfree(start);
-	return ret;
+	btrfs_queue_worker(queue->atomic_worker_start, &start->work);
+	return 0;
 }
 
 /*
@@ -177,11 +174,11 @@ out:
 	spin_unlock_irqrestore(&workers->lock, flags);
 }
 
-static noinline int run_ordered_completions(struct btrfs_workers *workers,
-					    struct btrfs_work *work)
+static noinline void run_ordered_completions(struct btrfs_workers *workers,
+					     struct btrfs_work *work)
 {
 	if (!workers->ordered)
-		return 0;
+		return;
 
 	set_bit(WORK_DONE_BIT, &work->flags);
 
@@ -219,7 +216,6 @@ static noinline int run_ordered_completi
 	}
 
 	spin_unlock(&workers->order_lock);
-	return 0;
 }
 
 static void put_worker(struct btrfs_worker_thread *worker)
@@ -405,7 +401,7 @@ again:
 /*
  * this will wait for all the worker threads to shutdown
  */
-int btrfs_stop_workers(struct btrfs_workers *workers)
+void btrfs_stop_workers(struct btrfs_workers *workers)
 {
 	struct list_head *cur;
 	struct btrfs_worker_thread *worker;
@@ -433,7 +429,6 @@ int btrfs_stop_workers(struct btrfs_work
 		put_worker(worker);
 	}
 	spin_unlock_irq(&workers->lock);
-	return 0;
 }
 
 /*
@@ -618,14 +613,14 @@ found:
  * it was taken from.  It is intended for use with long running work functions
  * that make some progress and want to give the cpu up for others.
  */
-int btrfs_requeue_work(struct btrfs_work *work)
+void btrfs_requeue_work(struct btrfs_work *work)
 {
 	struct btrfs_worker_thread *worker = work->worker;
 	unsigned long flags;
 	int wake = 0;
 
 	if (test_and_set_bit(WORK_QUEUED_BIT, &work->flags))
-		goto out;
+		return;
 
 	spin_lock_irqsave(&worker->lock, flags);
 	if (test_bit(WORK_HIGH_PRIO_BIT, &work->flags))
@@ -652,9 +647,6 @@ int btrfs_requeue_work(struct btrfs_work
 	if (wake)
 		wake_up_process(worker->task);
 	spin_unlock_irqrestore(&worker->lock, flags);
-out:
-
-	return 0;
 }
 
 void btrfs_set_work_high_prio(struct btrfs_work *work)
@@ -665,7 +657,7 @@ void btrfs_set_work_high_prio(struct btr
 /*
  * places a struct btrfs_work into the pending queue of one of the kthreads
  */
-int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
+void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
 {
 	struct btrfs_worker_thread *worker;
 	unsigned long flags;
@@ -673,7 +665,7 @@ int btrfs_queue_worker(struct btrfs_work
 
 	/* don't requeue something already on a list */
 	if (test_and_set_bit(WORK_QUEUED_BIT, &work->flags))
-		goto out;
+		return;
 
 	worker = find_worker(workers);
 	if (workers->ordered) {
@@ -712,7 +704,4 @@ int btrfs_queue_worker(struct btrfs_work
 	if (wake)
 		wake_up_process(worker->task);
 	spin_unlock_irqrestore(&worker->lock, flags);
-
-out:
-	return 0;
 }
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -109,11 +109,12 @@ struct btrfs_workers {
 	char *name;
 };
 
-int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work);
+void btrfs_queue_worker(struct btrfs_workers *workers,
+			struct btrfs_work *work);
 int btrfs_start_workers(struct btrfs_workers *workers, int num_workers);
-int btrfs_stop_workers(struct btrfs_workers *workers);
+void btrfs_stop_workers(struct btrfs_workers *workers);
 void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
 			struct btrfs_workers *async_starter);
-int btrfs_requeue_work(struct btrfs_work *work);
+void btrfs_requeue_work(struct btrfs_work *work);
 void btrfs_set_work_high_prio(struct btrfs_work *work);
 #endif


