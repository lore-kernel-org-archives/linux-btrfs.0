From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 28/65] btrfs: btrfs_queue_worker should return void
Date: Mon, 03 Oct 2011 23:22:58 -0400
Message-ID: <20111004032303.130863029@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_queue_worker has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/async-thread.c |   14 ++++----------
 fs/btrfs/async-thread.h |    2 +-
 2 files changed, 5 insertions(+), 11 deletions(-)

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
@@ -665,7 +662,7 @@ void btrfs_set_work_high_prio(struct btr
 /*
  * places a struct btrfs_work into the pending queue of one of the kthreads
  */
-int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
+void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
 {
 	struct btrfs_worker_thread *worker;
 	unsigned long flags;
@@ -673,7 +670,7 @@ int btrfs_queue_worker(struct btrfs_work
 
 	/* don't requeue something already on a list */
 	if (test_and_set_bit(WORK_QUEUED_BIT, &work->flags))
-		goto out;
+		return;
 
 	worker = find_worker(workers);
 	if (workers->ordered) {
@@ -712,7 +709,4 @@ int btrfs_queue_worker(struct btrfs_work
 	if (wake)
 		wake_up_process(worker->task);
 	spin_unlock_irqrestore(&worker->lock, flags);
-
-out:
-	return 0;
 }
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -109,7 +109,7 @@ struct btrfs_workers {
 	char *name;
 };
 
-int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work);
+void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work);
 int btrfs_start_workers(struct btrfs_workers *workers, int num_workers);
 int btrfs_stop_workers(struct btrfs_workers *workers);
 void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,


