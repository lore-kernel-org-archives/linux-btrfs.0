Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65155 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab3IKIv4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 04:51:56 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8B8pqda019953
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 16:51:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 4/9] btrfs: Add high priority workqueue support for btrfs_workqueue_struct
Date: Wed, 11 Sep 2013 16:52:33 +0800
Message-Id: <1378889558-21514-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add high priority workqueue, which added a new workqueue to
btrfs_workqueue_struct.

Whether using the high priority workqueue must be decided at
initialization.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/bwq.c | 29 ++++++++++++++++++++++++++++-
 fs/btrfs/bwq.h |  8 ++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bwq.c b/fs/btrfs/bwq.c
index feccf21..c2a089c 100644
--- a/fs/btrfs/bwq.c
+++ b/fs/btrfs/bwq.c
@@ -27,6 +27,7 @@
 
 struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 						     char *ordered_name,
+						     char *high_name,
 						     int max_active)
 {
 	int wq_flags = WQ_UNBOUND | WQ_MEM_RECLAIM;
@@ -46,6 +47,17 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 		kfree(ret);
 		return NULL;
 	}
+	if (high_name) {
+		ret->high_wq = alloc_workqueue(high_name, wq_flags | WQ_HIGHPRI,
+					       max_active);
+		if (unlikely(!ret->high_wq)) {
+			destroy_workqueue(ret->normal_wq);
+			destroy_workqueue(ret->ordered_wq);
+			kfree(ret);
+			return NULL;
+		}
+	}
+
 
 	spin_lock_init(&ret->insert_lock);
 	return ret;
@@ -89,10 +101,16 @@ void btrfs_init_work(struct btrfs_work_struct *work,
 void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
 		      struct btrfs_work_struct *work)
 {
+	struct workqueue_struct *dest_wq;
+	if (work->high && wq->high_wq)
+		dest_wq = wq->high_wq;
+	else
+		dest_wq = wq->normal_wq;
+
 	INIT_WORK(&work->normal_work, normal_work_helper);
 	INIT_WORK(&work->ordered_work, ordered_work_helper);
 	spin_lock(&wq->insert_lock);
-	queue_work(wq->normal_wq, &work->normal_work);
+	queue_work(dest_wq, &work->normal_work);
 	queue_work(wq->ordered_wq, &work->ordered_work);
 	spin_unlock(&wq->insert_lock);
 }
@@ -100,10 +118,19 @@ void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
 void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq)
 {
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
+}
+
+void btrfs_set_work_high_priority(struct btrfs_work_struct *work)
+{
+	work->high = 1;
 }
diff --git a/fs/btrfs/bwq.h b/fs/btrfs/bwq.h
index bf12c90..d9a7ded 100644
--- a/fs/btrfs/bwq.h
+++ b/fs/btrfs/bwq.h
@@ -22,6 +22,7 @@
 struct btrfs_workqueue_struct {
 	struct workqueue_struct *normal_wq;
 	struct workqueue_struct *ordered_wq;
+	struct workqueue_struct *high_wq;
 
 	/*
 	 * Spinlock to ensure that both ordered and normal work can
@@ -43,10 +44,16 @@ struct btrfs_work_struct {
 	struct work_struct normal_work;
 	struct work_struct ordered_work;
 	struct completion normal_completion;
+	int high;
 };
 
+/*
+ * name and ordered_name is mandamental, if high_name not given(NULL),
+ * high priority workqueue feature will not be available
+ */
 struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
 						     char *ordered_name,
+						     char *high_name,
 						     int max_active);
 void btrfs_init_work(struct btrfs_work_struct *work,
 		     void (*func)(struct btrfs_work_struct *),
@@ -56,4 +63,5 @@ void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
 		      struct btrfs_work_struct *work);
 void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq);
 void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max);
+void btrfs_set_work_high_priority(struct btrfs_work_struct *work);
 #endif
-- 
1.8.4

