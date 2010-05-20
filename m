From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 03/10] btrfs: Remove variable wake for cleanup
Date: Thu, 20 May 2010 15:16:17 +0800
Message-ID: <4BF4E1C1.5070900@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liubo2009@cn.fujitsu.com>

- Put "worker->working" inside "if" to make code clearly.

- If "wake" is 1, "wake_up_process" will be called,
  meanwhile, "wake" is set to 1 if !worker->working,
  so remove "wake" and directly call "wake_up_process"
  if !worker->working.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/async-thread.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index c0861e7..fec412e 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -620,7 +620,6 @@ int btrfs_requeue_work(struct btrfs_work *work)
 {
 	struct btrfs_worker_thread *worker = work->worker;
 	unsigned long flags;
-	int wake = 0;
 
 	if (test_and_set_bit(WORK_QUEUED_BIT, &work->flags))
 		goto out;
@@ -643,12 +642,10 @@ int btrfs_requeue_work(struct btrfs_work *work)
 		spin_unlock(&worker->workers->lock);
 	}
 	if (!worker->working) {
-		wake = 1;
 		worker->working = 1;
+		wake_up_process(worker->task);
 	}
 
-	if (wake)
-		wake_up_process(worker->task);
 	spin_unlock_irqrestore(&worker->lock, flags);
 out:
 
@@ -667,7 +664,6 @@ int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
 {
 	struct btrfs_worker_thread *worker;
 	unsigned long flags;
-	int wake = 0;
 
 	/* don't requeue something already on a list */
 	if (test_and_set_bit(WORK_QUEUED_BIT, &work->flags))
@@ -703,12 +699,11 @@ int btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
 	 * avoid calling into wake_up_process if this thread has already
 	 * been kicked
 	 */
-	if (!worker->working)
-		wake = 1;
-	worker->working = 1;
-
-	if (wake)
+	if (!worker->working) {
+		worker->working = 1;
 		wake_up_process(worker->task);
+	}
+
 	spin_unlock_irqrestore(&worker->lock, flags);
 
 out:
-- 
1.6.5.2


