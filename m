From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 5/7] btrfs: fix bad exception handling of __btrfs_start_workers()
Date: Thu, 29 Jul 2010 16:30:25 +0800
Message-ID: <4C513C21.7040004@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we stop all of the kthread when creating a new kthread fails, the btrfs
will hangup because there is no kthread to deal with the requests submited
by the btrfs.

And the best way to handle kthread-creating failure is "don't do anything",
because there are other kthreads in the kthread pool to deal with the
requests.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/async-thread.c |   51 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index eb3ec2d..49d25e6 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -157,27 +157,45 @@ static void check_pending_worker_creates(struct btrfs_worker_thread *worker)
 {
 	struct btrfs_workers *workers = worker->workers;
 	unsigned long flags;
+	int ret;
 
 	rmb();
 	if (!workers->atomic_start_pending)
 		return;
 
-	spin_lock_irqsave(&workers->lock, flags);
+	spin_lock_irqsave(&worker->lock, flags);
+	spin_lock(&workers->lock);
 	if (!workers->atomic_start_pending)
 		goto out;
 
-	workers->atomic_start_pending = 0;
-	if (workers->num_workers + workers->num_workers_starting >=
-	    workers->max_workers)
+	/*
+	 * If the worker is going to be idle, or the number of the workers is
+	 * greater than the max number, we needn't create any worker.
+	 */
+	if (atomic_read(&worker->num_pending) < workers->idle_thresh / 2 ||
+	    workers->num_workers + workers->num_workers_starting >=
+	    workers->max_workers) {
+		workers->atomic_start_pending = 0;
 		goto out;
+	}
 
-	workers->num_workers_starting += 1;
-	spin_unlock_irqrestore(&workers->lock, flags);
-	start_new_worker(workers);
+	workers->atomic_start_pending = 0;
+	workers->num_workers_starting++;
+	spin_unlock(&workers->lock);
+	spin_unlock_irqrestore(&worker->lock, flags);
+
+	ret = start_new_worker(workers);
+	if (ret) {
+		spin_lock_irqsave(&workers->lock, flags);
+		workers->num_workers_starting--;
+		workers->atomic_start_pending = 1;
+		spin_unlock_irqrestore(&workers->lock, flags);
+	}
 	return;
 
 out:
-	spin_unlock_irqrestore(&workers->lock, flags);
+	spin_unlock(&workers->lock);
+	spin_unlock_irqrestore(&worker->lock, flags);
 }
 
 static noinline int run_ordered_completions(struct btrfs_workers *workers,
@@ -489,7 +507,7 @@ static int __btrfs_start_workers(struct btrfs_workers *workers,
 		worker->workers = workers;
 		worker->task = kthread_run(worker_loop, worker,
 					   "btrfs-%s-%d", workers->name,
-					   workers->num_workers + i);
+					   workers->num_workers);
 		if (IS_ERR(worker->task)) {
 			ret = PTR_ERR(worker->task);
 			kfree(worker);
@@ -505,7 +523,12 @@ static int __btrfs_start_workers(struct btrfs_workers *workers,
 	}
 	return 0;
 fail:
-	btrfs_stop_workers(workers);
+	spin_lock_irq(&workers->lock);
+	if (workers->atomic_worker_start && workers->num_workers)
+		workers->atomic_start_pending = 1;
+	workers->num_workers_starting -= num_workers - i;
+	WARN_ON(workers->num_workers_starting < 0);
+	spin_unlock_irq(&workers->lock);
 	return ret;
 }
 
@@ -571,6 +594,7 @@ static struct btrfs_worker_thread *find_worker(struct btrfs_workers *workers)
 	struct btrfs_worker_thread *worker;
 	unsigned long flags;
 	struct list_head *fallback;
+	int ret;
 
 again:
 	spin_lock_irqsave(&workers->lock, flags);
@@ -587,8 +611,11 @@ again:
 			workers->num_workers_starting++;
 			spin_unlock_irqrestore(&workers->lock, flags);
 			/* we're below the limit, start another worker */
-			__btrfs_start_workers(workers, 1);
-			goto again;
+			ret = __btrfs_start_workers(workers, 1);
+			if (ret)
+				goto fallback;
+			else
+				goto again;
 		}
 	}
 	goto found;
-- 
1.7.0.1
