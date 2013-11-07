Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65474 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab3KGFvU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:20 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pFSw008348
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 04/17] btrfs: Add threshold workqueue based on kernel workqueue
Date: Thu, 7 Nov 2013 13:51:54 +0800
Message-Id: <1383803527-23736-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original btrfs_workers has thresholding functions to dynamically
create or destroy kthreads.

Though there is no such function in kernel workqueue because the worker
is not created manually, we can still use the workqueue_set_max_active
to simulated the behavior, mainly to achieve a better HDD performance by
setting a high threshold on submit_workers.
(Sadly, no resource can be saved)

So in this patch, extra workqueue pending counters are introduced to
dynamically change the max active of each btrfs_workqueue_struct, hoping
to restore the behavior of the original thresholding function.

Also, workqueue_set_max_active use a mutex to protect workqueue_struct,
which is not meant to be called too frequently, so a new interval
mechanism is applied, that will only call workqueue_set_max_active after
a count of work is queued. Hoping to balance both the random and
sequence performance on HDD.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v2->v3:
  - Add thresholding mechanism to simulate the old thresholding mechanism.
  - Will not enable thresholding when thresh is set to small value.
---
 fs/btrfs/async-thread.c | 131 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/async-thread.h |  24 ++++++++-
 2 files changed, 144 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 925aa6d..1fde6a2 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -31,6 +31,9 @@
 #define WORK_ORDER_DONE_BIT 2
 #define WORK_HIGH_PRIO_BIT 3
 
+#define NO_THRESHOLD (-1)
+#define DFT_THRESHOLD (32)
+
 /*
  * container for the kthread task pointer and the list of pending work
  * One of these is allocated per thread.
@@ -733,13 +736,31 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 						     char *ordered_name,
 						     char *high_name,
 						     int flags,
-						     int max_active)
+						     int max_active,
+						     int thresh)
 {
 	struct btrfs_workqueue_struct *ret = kzalloc(sizeof(*ret), GFP_NOFS);
-	flags |= WQ_UNBOUND;
 	if (unlikely(!ret))
 		return NULL;
-	ret->normal_wq = alloc_workqueue(name, flags, max_active);
+
+	ret->max_active = max_active;
+	ret->pending = 0;
+	/* default threshold */
+	if (thresh == 0)
+		thresh = DFT_THRESHOLD;
+	/* for low threshold, no threshold is a better choice*/
+	if (thresh < DFT_THRESHOLD) {
+		ret->current_max = max_active;
+		ret->thresh = NO_THRESHOLD;
+	} else {
+		ret->current_max = 1;
+		ret->thresh = thresh;
+	}
+	flags |= WQ_UNBOUND;
+
+	/* The max_active of workqueue will change betwen [1,max_active],
+	 * or just normal workqueue if NO_THRESHOLD is set*/
+	ret->normal_wq = alloc_workqueue(name, flags, ret->current_max);
 	if (unlikely(!ret->normal_wq)) {
 		kfree(ret);
 		return NULL;
@@ -757,7 +778,7 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 	if (high_name) {
 		ret->high_wq = alloc_workqueue(high_name,
 					       flags | WQ_HIGHPRI,
-					       max_active);
+					       ret->current_max);
 		if (unlikely(!ret->high_wq)) {
 			destroy_workqueue(ret->normal_wq);
 			if (ret->ordered_wq)
@@ -767,16 +788,101 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 		}
 	}
 
+	spin_lock_init(&ret->thresh_lock);
 	spin_lock_init(&ret->insert_lock);
 	return ret;
 }
 
+/*
+ * Hook for threshold which will be called in btrfs_queue_work.
+ * This hook WILL be called in IRQ context,
+ * so workqueue_set_max_active MUST NOT be called in this hook
+ */
+static inline void thresh_queue_hook(struct btrfs_workqueue_struct *wq)
+{
+	unsigned long flags;
+	/* Skip if no threshold is set */
+	if (wq->thresh == NO_THRESHOLD)
+		return;
+	/* Since the hook may be executed in IRQ handle, we need to
+	 * disable the IRQ */
+	spin_lock_irqsave(&wq->thresh_lock, flags);
+	wq->pending++;
+	spin_unlock_irqrestore(&wq->thresh_lock, flags);
+}
+
+/*
+ * Hook for threshold which will be called before executing the work,
+ * This hook is called in kthread content.
+ * So workqueue_set_max_active is called here.
+ */
+static inline void thresh_exec_hook(struct btrfs_workqueue_struct *wq)
+{
+	int new_max_active;
+	int need_change = 0;
+	unsigned long flags;
+
+	/* Skip if no threshold is set */
+	if (wq->thresh == NO_THRESHOLD)
+		return;
+
+	spin_lock_irqsave(&wq->thresh_lock, flags);
+	wq->pending--;
+	wq->count++;
+
+	/* Use 1/4 of the thresh as the interval to change the max active,
+	 * Too high value(like twice) will make the max active change too slow,
+	 * which will bring performance drop in random IO on HDD.
+	 * Too small value(like 1/8 or static value) will make
+	 * workqueue_set_max_active be called too frequently, where the mutex
+	 * can slowdown the whole work.*/
+	wq->count %= (wq->thresh / 4);
+	if (!wq->count)
+		goto  out;
+	/* Recaculate the current max */
+	new_max_active = wq->current_max;
+	if (wq->pending > wq->thresh)
+		new_max_active++;
+	if (wq->pending < wq->thresh / 2)
+		new_max_active--;
+	new_max_active = clamp_val(new_max_active, 1, wq->max_active);
+	if (new_max_active != wq->current_max)  {
+		need_change = 1;
+		wq->current_max = new_max_active;
+	}
+	/*
+	 * Workqueue is using mutex to set max active,
+	 * so we should not call it with a spinlock hold.
+	 *
+	 * Also workqueue_set_max_active is somewhat expensive,
+	 * we should not call it too frequently.
+	 */
+out:
+	spin_unlock_irqrestore(&wq->thresh_lock, flags);
+
+	if (need_change) {
+		workqueue_set_max_active(wq->normal_wq, wq->current_max);
+		if (wq->high_wq)
+			workqueue_set_max_active(wq->high_wq, wq->current_max);
+	}
+}
+
 static void normal_work_helper(struct work_struct *arg)
 {
 	struct btrfs_work_struct *work;
+	/*
+	 * Since some work may free the whole btrfs_work_struct in func,
+	 * we should not access the completion which may be freed.
+	 * But if it has ordered_func, that will be safe.
+	 */
+	int need_complete = 0;
 	work = container_of(arg, struct btrfs_work_struct, normal_work);
+	if (work->ordered_func)
+		need_complete = 1;
+	thresh_exec_hook(work->wq);
 	work->func(work);
-	complete(&work->normal_completion);
+	if (need_complete)
+		complete(&work->normal_completion);
 }
 
 static void ordered_work_helper(struct work_struct *arg)
@@ -798,9 +904,10 @@ void btrfs_init_work(struct btrfs_work_struct *work,
 	work->ordered_func = ordered_func;
 	work->ordered_free = ordered_free;
 	INIT_WORK(&work->normal_work, normal_work_helper);
-	if (work->ordered_func)
+	if (work->ordered_func) {
 		INIT_WORK(&work->ordered_work, ordered_work_helper);
-	init_completion(&work->normal_completion);
+		init_completion(&work->normal_completion);
+	}
 }
 
 void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
@@ -808,10 +915,13 @@ void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
 {
 	unsigned long flags;
 	struct workqueue_struct *dest_wq;
+	work->wq = wq;
 	if (work->high && wq->high_wq)
 		dest_wq = wq->high_wq;
 	else
 		dest_wq = wq->normal_wq;
+
+	thresh_queue_hook(wq);
 	spin_lock_irqsave(&wq->insert_lock, flags);
 	queue_work(dest_wq, &work->normal_work);
 	if (wq->ordered_wq && work->ordered_func)
@@ -830,7 +940,8 @@ void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq)
 
 void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max)
 {
-	workqueue_set_max_active(wq->normal_wq, max);
-	if (wq->high_wq)
-		workqueue_set_max_active(wq->high_wq, max);
+	unsigned long flags;
+	spin_lock_irqsave(&wq->thresh_lock, flags);
+	wq->max_active = max;
+	spin_unlock_irqrestore(&wq->thresh_lock, flags);
 }
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 4863c38..44942b1 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -131,6 +131,26 @@ struct btrfs_workqueue_struct {
 	 * which will reduce the ordered_work waiting time and disk head moves.
 	 */
 	spinlock_t insert_lock;
+
+	/*
+	 * extra variants to implement threshold workqueue
+	 */
+	int pending;		/* How many works are pending */
+	int max_active;		/* Up limit of max running actives */
+	int current_max;	/* Current allowed number of running works */
+	int thresh;		/* Threshold,
+				   when pending > threshold, add current_max
+				   when pending < threshold/2, decrease
+				   current max. When set to 0, default value
+				   will be 32.
+				   Also, if thresh < 8, threshold will be
+				   disabled*/
+	unsigned int count;	/* Counter for preventing changing max active
+				   too frequently. When reaching 1.5 * thresh,
+				   then try to change current_max*/
+	spinlock_t thresh_lock; /* Used to lock the above threshold related
+				   variants. Not reuse the insert_lock to
+				   reduce race on the same lock*/
 };
 
 struct btrfs_work_struct {
@@ -142,6 +162,7 @@ struct btrfs_work_struct {
 	struct work_struct normal_work;
 	struct work_struct ordered_work;
 	struct completion normal_completion;
+	struct btrfs_workqueue_struct *wq;
 	int high;
 };
 
@@ -157,7 +178,8 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 						     char *ordered_name,
 						     char *high_name,
 						     int flags,
-						     int max_active);
+						     int max_active,
+						     int thresh);
 void btrfs_init_work(struct btrfs_work_struct *work,
 		     void (*func)(struct btrfs_work_struct *),
 		     void (*ordered_func)(struct btrfs_work_struct *),
-- 
1.8.4.2

