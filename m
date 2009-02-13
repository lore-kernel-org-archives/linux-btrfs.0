From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 5/5] Btrfs: fix potential busy loop in find_worker
Date: Fri, 13 Feb 2009 17:17:43 -0500
Message-ID: <1234563463-7585-5-git-send-email-jeffm@suse.com>
References: <1234563463-7585-1-git-send-email-jeffm@suse.com>
 <1234563463-7585-2-git-send-email-jeffm@suse.com>
 <1234563463-7585-3-git-send-email-jeffm@suse.com>
 <1234563463-7585-4-git-send-email-jeffm@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234563463-7585-4-git-send-email-jeffm@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

When the system fails to allocate a new worker or create a new thread,
find_worker can loop indefinitely.  It goes into a busy loop trying
to create a new thread and won't return until it is successful.

This patch takes an error from btrfs_start_workers to mean that
there is a resource shortage and falls back to using the first
worker thread in order to make progress.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/async-thread.c |   44 ++++++++++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 66def6f..b1bfb28 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -344,6 +344,22 @@ static struct btrfs_worker_thread *next_worker(struct btrfs_workers *workers)
 	return worker;
 }
 
+static struct btrfs_worker_thread *first_worker(struct btrfs_workers *workers)
+{
+	struct list_head *list = NULL;
+
+	if (!list_empty(&workers->worker_list))
+		list = &workers->worker_list;
+
+	if (!list_empty(&workers->idle_list))
+		list = &workers->idle_list;
+
+	if (!list)
+		return NULL;
+
+	return list_first_entry(list, struct btrfs_worker_thread, worker_list);
+}
+
 /*
  * selects a worker thread to take the next job.  This will either find
  * an idle worker, start a new worker up to the max count, or just return
@@ -351,37 +367,25 @@ static struct btrfs_worker_thread *next_worker(struct btrfs_workers *workers)
  */
 static struct btrfs_worker_thread *find_worker(struct btrfs_workers *workers)
 {
-	struct btrfs_worker_thread *worker;
+	struct btrfs_worker_thread *worker = NULL;
 	unsigned long flags;
+	int ret = 0;
 
 again:
 	spin_lock_irqsave(&workers->lock, flags);
 	worker = next_worker(workers);
-	spin_unlock_irqrestore(&workers->lock, flags);
-
 	if (!worker) {
-		spin_lock_irqsave(&workers->lock, flags);
-		if (workers->num_workers >= workers->max_workers) {
-			struct list_head *fallback = NULL;
-			/*
-			 * we have failed to find any workers, just
-			 * return the force one
-			 */
-			if (!list_empty(&workers->worker_list))
-				fallback = workers->worker_list.next;
-			if (!list_empty(&workers->idle_list))
-				fallback = workers->idle_list.next;
-			BUG_ON(!fallback);
-			worker = list_entry(fallback,
-				  struct btrfs_worker_thread, worker_list);
-			spin_unlock_irqrestore(&workers->lock, flags);
-		} else {
+		if (workers->num_workers >= workers->max_workers || ret)
+			worker = first_worker(workers);
+		else {
 			spin_unlock_irqrestore(&workers->lock, flags);
 			/* we're below the limit, start another worker */
-			btrfs_start_workers(workers, 1);
+			ret = btrfs_start_workers(workers, 1);
 			goto again;
 		}
 	}
+	spin_unlock_irqrestore(&workers->lock, flags);
+	BUG_ON(!worker);
 	return worker;
 }
 
-- 
1.6.0.2

