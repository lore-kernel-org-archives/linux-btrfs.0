Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:25232 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab3LQJcK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:32:10 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBH9V6EJ027097
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 17:31:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v4 03/18] btrfs: Add high priority workqueue support for btrfs_workqueue_struct
Date: Tue, 17 Dec 2013 17:31:44 +0800
Message-Id: <1387272719-11889-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add high priority function to btrfs_workqueue.

This is implemented by embedding a btrfs_workqueue into a
btrfs_workqueue and use some helper functions to differ the normal
priority wq and high priority wq.
So the high priority wq is completely independent from the normal
workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  None
v3->v4:
  - Implement high priority workqueue independently.
    Now high priority wq is implemented as a normal btrfs_workqueue,
    with independent ordering/thresholding mechanism.
    This fixed the problem that high priority wq and normal wq shared one
    ordered wq.
---
 fs/btrfs/async-thread.c | 89 +++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/async-thread.h |  5 ++-
 2 files changed, 82 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index f05d57e..73b9f94 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -729,7 +729,7 @@ void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
 	spin_unlock_irqrestore(&worker->lock, flags);
 }
 
-struct btrfs_workqueue_struct {
+struct __btrfs_workqueue_struct {
 	struct workqueue_struct *normal_wq;
 	/* List head pointing to ordered work list */
 	struct list_head ordered_list;
@@ -738,6 +738,38 @@ struct btrfs_workqueue_struct {
 	spinlock_t list_lock;
 };
 
+struct btrfs_workqueue_struct {
+	struct __btrfs_workqueue_struct *normal;
+	struct __btrfs_workqueue_struct *high;
+};
+
+static inline struct __btrfs_workqueue_struct
+*__btrfs_alloc_workqueue(char *name, int flags, int max_active)
+{
+	struct __btrfs_workqueue_struct *ret = kzalloc(sizeof(*ret), GFP_NOFS);
+
+	if (unlikely(!ret))
+		return NULL;
+
+	if (flags & WQ_HIGHPRI)
+		ret->normal_wq = alloc_workqueue("%s-%s-high", flags,
+						 max_active, "btrfs", name);
+	else
+		ret->normal_wq = alloc_workqueue("%s-%s", flags,
+						 max_active, "btrfs", name);
+	if (unlikely(!ret->normal_wq)) {
+		kfree(ret);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&ret->ordered_list);
+	spin_lock_init(&ret->list_lock);
+	return ret;
+}
+
+static inline void
+__btrfs_destroy_workqueue(struct __btrfs_workqueue_struct *wq);
+
 struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 						     int flags,
 						     int max_active)
@@ -747,19 +779,25 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 	if (unlikely(!ret))
 		return NULL;
 
-	ret->normal_wq = alloc_workqueue("%s-%s", flags, max_active,
-					 "btrfs", name);
-	if (unlikely(!ret->normal_wq)) {
+	ret->normal = __btrfs_alloc_workqueue(name, flags & ~WQ_HIGHPRI,
+					      max_active);
+	if (unlikely(!ret->normal)) {
 		kfree(ret);
 		return NULL;
 	}
 
-	INIT_LIST_HEAD(&ret->ordered_list);
-	spin_lock_init(&ret->list_lock);
+	if (flags & WQ_HIGHPRI) {
+		ret->high = __btrfs_alloc_workqueue(name, flags, max_active);
+		if (unlikely(!ret->high)) {
+			__btrfs_destroy_workqueue(ret->normal);
+			kfree(ret);
+			return NULL;
+		}
+	}
 	return ret;
 }
 
-static void run_ordered_work(struct btrfs_workqueue_struct *wq)
+static void run_ordered_work(struct __btrfs_workqueue_struct *wq)
 {
 	struct list_head *list = &wq->ordered_list;
 	struct btrfs_work_struct *work;
@@ -832,8 +870,8 @@ void btrfs_init_work(struct btrfs_work_struct *work,
 	work->flags = 0;
 }
 
-void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
-		      struct btrfs_work_struct *work)
+static inline void __btrfs_queue_work(struct __btrfs_workqueue_struct *wq,
+				      struct btrfs_work_struct *work)
 {
 	unsigned long flags;
 
@@ -846,13 +884,42 @@ void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
 	queue_work(wq->normal_wq, &work->normal_work);
 }
 
-void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq)
+void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
+		      struct btrfs_work_struct *work)
+{
+	struct __btrfs_workqueue_struct *dest_wq;
+
+	if (test_bit(WORK_HIGH_PRIO_BIT, &work->flags) && wq->high)
+		dest_wq = wq->high;
+	else
+		dest_wq = wq->normal;
+	__btrfs_queue_work(dest_wq, work);
+}
+
+static inline void
+__btrfs_destroy_workqueue(struct __btrfs_workqueue_struct *wq)
 {
 	destroy_workqueue(wq->normal_wq);
 	kfree(wq);
 }
 
+void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq)
+{
+	if (!wq)
+		return;
+	if (wq->high)
+		__btrfs_destroy_workqueue(wq->high);
+	__btrfs_destroy_workqueue(wq->normal);
+}
+
 void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max)
 {
-	workqueue_set_max_active(wq->normal_wq, max);
+	workqueue_set_max_active(wq->normal->normal_wq, max);
+	if (wq->high)
+		workqueue_set_max_active(wq->high->normal_wq, max);
+}
+
+void btrfs_set_work_high_priority(struct btrfs_work_struct *work)
+{
+	set_bit(WORK_HIGH_PRIO_BIT, &work->flags);
 }
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 1d16156..62cd19d 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -121,6 +121,8 @@ void btrfs_requeue_work(struct btrfs_work *work);
 void btrfs_set_work_high_prio(struct btrfs_work *work);
 
 struct btrfs_workqueue_struct;
+/* Internal use only */
+struct __btrfs_workqueue_struct;
 
 struct btrfs_work_struct {
 	void (*func)(struct btrfs_work_struct *arg);
@@ -130,7 +132,7 @@ struct btrfs_work_struct {
 	/* Don't touch things below */
 	struct work_struct normal_work;
 	struct list_head ordered_list;
-	struct btrfs_workqueue_struct *wq;
+	struct __btrfs_workqueue_struct *wq;
 	unsigned long flags;
 };
 
@@ -145,4 +147,5 @@ void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
 		      struct btrfs_work_struct *work);
 void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq);
 void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max);
+void btrfs_set_work_high_priority(struct btrfs_work_struct *work);
 #endif
-- 
1.8.5.1

