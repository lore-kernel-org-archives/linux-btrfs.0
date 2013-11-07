Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65474 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3KGFvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:18 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pE7k008340
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 03/17] btrfs: Add high priority workqueue support for btrfs_workqueue_struct
Date: Thu, 7 Nov 2013 13:51:53 +0800
Message-Id: <1383803527-23736-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add high priority workqueue, which added a new workqueue to
btrfs_workqueue_struct.

Whether using the high priority workqueue must be decided at
initialization.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  None
---
 fs/btrfs/async-thread.c | 25 ++++++++++++++++++++++++-
 fs/btrfs/async-thread.h |  8 ++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 00b4913..925aa6d 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -731,6 +731,7 @@ void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
 
 struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 						     char *ordered_name,
+						     char *high_name,
 						     int flags,
 						     int max_active)
 {
@@ -753,6 +754,19 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 		}
 	}
 
+	if (high_name) {
+		ret->high_wq = alloc_workqueue(high_name,
+					       flags | WQ_HIGHPRI,
+					       max_active);
+		if (unlikely(!ret->high_wq)) {
+			destroy_workqueue(ret->normal_wq);
+			if (ret->ordered_wq)
+				destroy_workqueue(ret->ordered_wq);
+			kfree(ret);
+			return NULL;
+		}
+	}
+
 	spin_lock_init(&ret->insert_lock);
 	return ret;
 }
@@ -793,8 +807,13 @@ void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
 		      struct btrfs_work_struct *work)
 {
 	unsigned long flags;
+	struct workqueue_struct *dest_wq;
+	if (work->high && wq->high_wq)
+		dest_wq = wq->high_wq;
+	else
+		dest_wq = wq->normal_wq;
 	spin_lock_irqsave(&wq->insert_lock, flags);
-	queue_work(wq->normal_wq, &work->normal_work);
+	queue_work(dest_wq, &work->normal_work);
 	if (wq->ordered_wq && work->ordered_func)
 		queue_work(wq->ordered_wq, &work->ordered_work);
 	spin_unlock_irqrestore(&wq->insert_lock, flags);
@@ -804,10 +823,14 @@ void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq)
 {
 	if (wq->ordered_wq)
 		destroy_workqueue(wq->ordered_wq);
+	if (wq->high_wq)
+		destroy_workqueue(wq->high_wq);
 	destroy_workqueue(wq->normal_wq);
 }
 
 void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max)
 {
 	workqueue_set_max_active(wq->normal_wq, max);
+	if (wq->high_wq)
+		workqueue_set_max_active(wq->high_wq, max);
 }
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index eee6709..4863c38 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -123,6 +123,7 @@ void btrfs_set_work_high_prio(struct btrfs_work *work);
 struct btrfs_workqueue_struct {
 	struct workqueue_struct *normal_wq;
 	struct workqueue_struct *ordered_wq;
+	struct workqueue_struct *high_wq;
 
 	/*
 	 * Spinlock to ensure that both ordered and normal work can
@@ -141,17 +142,20 @@ struct btrfs_work_struct {
 	struct work_struct normal_work;
 	struct work_struct ordered_work;
 	struct completion normal_completion;
+	int high;
 };
 
 /*
  * ordered_name is optional. If not given(NULL), the ordered
  * workqueue will not be allocated and the ordered excution will not
  * be available. The behavior will not be changed after init.
+ * The same rule is applied to high_name.
  *
  * flags will use the WQ_ flags, ORed with WQ_UNBOUND.
  * */
 struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 						     char *ordered_name,
+						     char *high_name,
 						     int flags,
 						     int max_active);
 void btrfs_init_work(struct btrfs_work_struct *work,
@@ -162,4 +166,8 @@ void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
 		      struct btrfs_work_struct *work);
 void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq);
 void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max);
+static inline void btrfs_set_work_high_priority(struct btrfs_work_struct *work)
+{
+	work->high = 1;
+}
 #endif
-- 
1.8.4.2

