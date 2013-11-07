Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26709 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab3KGFvU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:20 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pFI4008344
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 02/17] btrfs: Added btrfs_workqueue_struct implemented ordered execution based on kernel workqueue
Date: Thu, 7 Nov 2013 13:51:52 +0800
Message-Id: <1383803527-23736-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use kernel workqueue to implement a new btrfs_workqueue_struct, which
has the ordering execution feature like the btrfs_worker.

The func is executed in a concurrency way, and the
ordred_func/ordered_free is executed in the sequence them are queued
after the corresponding func is done.
The new btrfs_workqueue use 2 workqueues to implement the original
btrfs_worker, one for the normal work and one for ordered work.

At this patch, high priority work queue or thresholding is not added yet.
The high priority feature and thresholding will be added in the following patches.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None.
v2->v3:
  - Fix the potential deadline discovered by kernel lockdep.
  - Reuse the async-thread.[ch] files.
  - Make the ordered_func optional, which makes it adaptable to
    all btrfS_workers.
---
 fs/btrfs/async-thread.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/async-thread.h | 44 +++++++++++++++++++++++++
 2 files changed, 130 insertions(+)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 08cc08f..00b4913 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
+ * Copyright (C) 2013 Fujitsu.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -21,6 +22,8 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/workqueue.h>
+#include <linux/completion.h>
 #include "async-thread.h"
 
 #define WORK_QUEUED_BIT 0
@@ -725,3 +728,86 @@ void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
 		wake_up_process(worker->task);
 	spin_unlock_irqrestore(&worker->lock, flags);
 }
+
+struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
+						     char *ordered_name,
+						     int flags,
+						     int max_active)
+{
+	struct btrfs_workqueue_struct *ret = kzalloc(sizeof(*ret), GFP_NOFS);
+	flags |= WQ_UNBOUND;
+	if (unlikely(!ret))
+		return NULL;
+	ret->normal_wq = alloc_workqueue(name, flags, max_active);
+	if (unlikely(!ret->normal_wq)) {
+		kfree(ret);
+		return NULL;
+	}
+
+	if (ordered_name) {
+		ret->ordered_wq = alloc_ordered_workqueue(ordered_name, flags);
+		if (unlikely(!ret->ordered_wq)) {
+			destroy_workqueue(ret->normal_wq);
+			kfree(ret);
+			return NULL;
+		}
+	}
+
+	spin_lock_init(&ret->insert_lock);
+	return ret;
+}
+
+static void normal_work_helper(struct work_struct *arg)
+{
+	struct btrfs_work_struct *work;
+	work = container_of(arg, struct btrfs_work_struct, normal_work);
+	work->func(work);
+	complete(&work->normal_completion);
+}
+
+static void ordered_work_helper(struct work_struct *arg)
+{
+	struct btrfs_work_struct *work;
+	work = container_of(arg, struct btrfs_work_struct, ordered_work);
+	wait_for_completion(&work->normal_completion);
+	work->ordered_func(work);
+	if (work->ordered_free)
+		work->ordered_free(work);
+}
+
+void btrfs_init_work(struct btrfs_work_struct *work,
+		     void (*func)(struct btrfs_work_struct *),
+		     void (*ordered_func)(struct btrfs_work_struct *),
+		     void (*ordered_free)(struct btrfs_work_struct *))
+{
+	work->func = func;
+	work->ordered_func = ordered_func;
+	work->ordered_free = ordered_free;
+	INIT_WORK(&work->normal_work, normal_work_helper);
+	if (work->ordered_func)
+		INIT_WORK(&work->ordered_work, ordered_work_helper);
+	init_completion(&work->normal_completion);
+}
+
+void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
+		      struct btrfs_work_struct *work)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&wq->insert_lock, flags);
+	queue_work(wq->normal_wq, &work->normal_work);
+	if (wq->ordered_wq && work->ordered_func)
+		queue_work(wq->ordered_wq, &work->ordered_work);
+	spin_unlock_irqrestore(&wq->insert_lock, flags);
+}
+
+void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq)
+{
+	if (wq->ordered_wq)
+		destroy_workqueue(wq->ordered_wq);
+	destroy_workqueue(wq->normal_wq);
+}
+
+void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max)
+{
+	workqueue_set_max_active(wq->normal_wq, max);
+}
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 1f26792..eee6709 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
+ * Copyright (C) 2013 Fujitsu.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -118,4 +119,47 @@ void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
 			struct btrfs_workers *async_starter);
 void btrfs_requeue_work(struct btrfs_work *work);
 void btrfs_set_work_high_prio(struct btrfs_work *work);
+
+struct btrfs_workqueue_struct {
+	struct workqueue_struct *normal_wq;
+	struct workqueue_struct *ordered_wq;
+
+	/*
+	 * Spinlock to ensure that both ordered and normal work can
+	 * be inserted to each workqueue at the same sequance,
+	 * which will reduce the ordered_work waiting time and disk head moves.
+	 */
+	spinlock_t insert_lock;
+};
+
+struct btrfs_work_struct {
+	void (*func)(struct btrfs_work_struct *arg);
+	void (*ordered_func)(struct btrfs_work_struct *arg);
+	void (*ordered_free)(struct btrfs_work_struct *arg);
+
+	/* Don't touch things below */
+	struct work_struct normal_work;
+	struct work_struct ordered_work;
+	struct completion normal_completion;
+};
+
+/*
+ * ordered_name is optional. If not given(NULL), the ordered
+ * workqueue will not be allocated and the ordered excution will not
+ * be available. The behavior will not be changed after init.
+ *
+ * flags will use the WQ_ flags, ORed with WQ_UNBOUND.
+ * */
+struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
+						     char *ordered_name,
+						     int flags,
+						     int max_active);
+void btrfs_init_work(struct btrfs_work_struct *work,
+		     void (*func)(struct btrfs_work_struct *),
+		     void (*ordered_func)(struct btrfs_work_struct *),
+		     void (*ordered_free)(struct btrfs_work_struct *));
+void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
+		      struct btrfs_work_struct *work);
+void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq);
+void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max);
 #endif
-- 
1.8.4.2

