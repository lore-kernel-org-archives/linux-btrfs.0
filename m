Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37604 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3JBQkU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Oct 2013 12:40:20 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so994398lbi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Oct 2013 09:40:19 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        idryomov@gmail.com
Subject: [PATCH] Btrfs: eliminate races in worker stopping code
Date: Wed,  2 Oct 2013 19:39:50 +0300
Message-Id: <1380731990-7533-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current implementation of worker threads in Btrfs has races in
worker stopping code, which cause all kinds of panics and lockups when
running btrfs/011 xfstest in a loop.  The problem is that
btrfs_stop_workers is unsynchronized with respect to check_idle_worker,
check_busy_worker and __btrfs_start_workers.

E.g., check_idle_worker race flow:

       btrfs_stop_workers():            check_idle_worker(aworker):
- grabs the lock
- splices the idle list into the
  working list
- removes the first worker from the
  working list
- releases the lock to wait for
  its kthread's completion
                                  - grabs the lock
                                  - if aworker is on the working list,
                                    moves aworker from the working list
                                    to the idle list
                                  - releases the lock
- grabs the lock
- puts the worker
- removes the second worker from the
  working list
                              ......
        btrfs_stop_workers returns, aworker is on the idle list
                 FS is umounted, memory is freed
                              ......
              aworker is waken up, fireworks ensue

With this applied, I wasn't able to trigger the problem in 48 hours,
whereas previously I could reliably reproduce at least one of these
races within an hour.

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/async-thread.c |   25 +++++++++++++++++++------
 fs/btrfs/async-thread.h |    2 ++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 58b7d14..08cc08f 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -107,7 +107,8 @@ static void check_idle_worker(struct btrfs_worker_thread *worker)
 		worker->idle = 1;
 
 		/* the list may be empty if the worker is just starting */
-		if (!list_empty(&worker->worker_list)) {
+		if (!list_empty(&worker->worker_list) &&
+		    !worker->workers->stopping) {
 			list_move(&worker->worker_list,
 				 &worker->workers->idle_list);
 		}
@@ -127,7 +128,8 @@ static void check_busy_worker(struct btrfs_worker_thread *worker)
 		spin_lock_irqsave(&worker->workers->lock, flags);
 		worker->idle = 0;
 
-		if (!list_empty(&worker->worker_list)) {
+		if (!list_empty(&worker->worker_list) &&
+		    !worker->workers->stopping) {
 			list_move_tail(&worker->worker_list,
 				      &worker->workers->worker_list);
 		}
@@ -412,6 +414,7 @@ void btrfs_stop_workers(struct btrfs_workers *workers)
 	int can_stop;
 
 	spin_lock_irq(&workers->lock);
+	workers->stopping = 1;
 	list_splice_init(&workers->idle_list, &workers->worker_list);
 	while (!list_empty(&workers->worker_list)) {
 		cur = workers->worker_list.next;
@@ -455,6 +458,7 @@ void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
 	workers->ordered = 0;
 	workers->atomic_start_pending = 0;
 	workers->atomic_worker_start = async_helper;
+	workers->stopping = 0;
 }
 
 /*
@@ -480,15 +484,19 @@ static int __btrfs_start_workers(struct btrfs_workers *workers)
 	atomic_set(&worker->num_pending, 0);
 	atomic_set(&worker->refs, 1);
 	worker->workers = workers;
-	worker->task = kthread_run(worker_loop, worker,
-				   "btrfs-%s-%d", workers->name,
-				   workers->num_workers + 1);
+	worker->task = kthread_create(worker_loop, worker,
+				      "btrfs-%s-%d", workers->name,
+				      workers->num_workers + 1);
 	if (IS_ERR(worker->task)) {
 		ret = PTR_ERR(worker->task);
-		kfree(worker);
 		goto fail;
 	}
+
 	spin_lock_irq(&workers->lock);
+	if (workers->stopping) {
+		spin_unlock_irq(&workers->lock);
+		goto fail_kthread;
+	}
 	list_add_tail(&worker->worker_list, &workers->idle_list);
 	worker->idle = 1;
 	workers->num_workers++;
@@ -496,8 +504,13 @@ static int __btrfs_start_workers(struct btrfs_workers *workers)
 	WARN_ON(workers->num_workers_starting < 0);
 	spin_unlock_irq(&workers->lock);
 
+	wake_up_process(worker->task);
 	return 0;
+
+fail_kthread:
+	kthread_stop(worker->task);
 fail:
+	kfree(worker);
 	spin_lock_irq(&workers->lock);
 	workers->num_workers_starting--;
 	spin_unlock_irq(&workers->lock);
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 063698b..1f26792 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -107,6 +107,8 @@ struct btrfs_workers {
 
 	/* extra name for this worker, used for current->name */
 	char *name;
+
+	int stopping;
 };
 
 void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work);
-- 
1.7.10.4

