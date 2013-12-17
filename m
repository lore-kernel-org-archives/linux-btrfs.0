Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:51415 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab3LQJcJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:32:09 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH v4 02/18] btrfs: Added btrfs_workqueue_struct implemented ordered execution based on kernel workqueue
Date: Tue, 17 Dec 2013 17:31:43 +0800
Message-Id: <1387272719-11889-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use kernel workqueue to implement a new btrfs_workqueue_struct, which
has the ordering execution feature like the btrfs_worker.

The func is executed in a concurrency way, and the
ordred_func/ordered_free is executed in the sequence them are queued
after the corresponding func is done.

The new btrfs_workqueue works much like the original one, one workqueue
for normal work and a list for ordered work.
When a work is queued, ordered work will be added to the list and helper
function will be queued into the workqueue.
The helper function will execute a normal work and then check and execute as many
ordered work as possible in the sequence they were queued.

At this patch, high priority work queue or thresholding is not added yet.
The high priority feature and thresholding will be added in the following patches.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fusionio.com>
---
Changelog:
v1->v2:
  None.
v2->v3:
  - Fix the potential deadline discovered by kernel lockdep.
  - Reuse the async-thread.[ch] files.
  - Make the ordered_func optional, which makes it adaptable to
    all btrfs_workers.
v3->v4:
  - Use the old list method to implement ordered workqueue.
    Previous 3 wq implement needs extra time waiting for scheduling,
    which caused up to 40% performance drop in compress tests.
    The old list method(after executing a normal work, check the order_list
    and executing) does not need the extra scheduling things.
  - Simplify the btrfs_alloc_workqueue parameters.
    Now only one name is needed, and ordered work mechanism is determined using
    work->ordered_func.
  - Fix memory leak in btrfs_destroy_workqueue.
---
 fs/btrfs/async-thread.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/async-thread.h |  27 ++++++++++
 2 files changed, 157 insertions(+)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index c1e0b0c..f05d57e 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
+ * Copyright (C) 2013 Fujitsu.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -21,6 +22,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/workqueue.h>
 #include "async-thread.h"
 
 #define WORK_QUEUED_BIT 0
@@ -726,3 +728,131 @@ void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
 		wake_up_process(worker->task);
 	spin_unlock_irqrestore(&worker->lock, flags);
 }
+
+struct btrfs_workqueue_struct {
+	struct workqueue_struct *normal_wq;
+	/* List head pointing to ordered work list */
+	struct list_head ordered_list;
+
+	/* Spinlock for ordered_list */
+	spinlock_t list_lock;
+};
+
+struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
+						     int flags,
+						     int max_active)
+{
+	struct btrfs_workqueue_struct *ret = kzalloc(sizeof(*ret), GFP_NOFS);
+
+	if (unlikely(!ret))
+		return NULL;
+
+	ret->normal_wq = alloc_workqueue("%s-%s", flags, max_active,
+					 "btrfs", name);
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
+static void run_ordered_work(struct btrfs_workqueue_struct *wq)
+{
+	struct list_head *list = &wq->ordered_list;
+	struct btrfs_work_struct *work;
+	spinlock_t *lock = &wq->list_lock;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(lock, flags);
+		if (list_empty(list))
+			break;
+		work = list_entry(list->next, struct btrfs_work_struct,
+				  ordered_list);
+		if (!test_bit(WORK_DONE_BIT, &work->flags))
+			break;
+
+		/*
+		 * we are going to call the ordered done function, but
+		 * we leave the work item on the list as a barrier so
+		 * that later work items that are done don't have their
+		 * functions called before this one returns
+		 */
+		if (test_and_set_bit(WORK_ORDER_DONE_BIT, &work->flags))
+			break;
+		spin_unlock_irqrestore(lock, flags);
+		work->ordered_func(work);
+
+		/* now take the lock again and drop our item from the list */
+		spin_lock_irqsave(lock, flags);
+		list_del(&work->ordered_list);
+		spin_unlock_irqrestore(lock, flags);
+
+		/*
+		 * we don't want to call the ordered free functions
+		 * with the lock held though
+		 */
+		work->ordered_free(work);
+	}
+	spin_unlock_irqrestore(lock, flags);
+}
+
+static void normal_work_helper(struct work_struct *arg)
+{
+	struct btrfs_work_struct *work;
+	int need_order = 0;
+
+	work = container_of(arg, struct btrfs_work_struct, normal_work);
+	/*
+	 * Some work may free the whole struct, we should check before
+	 * executing the func.
+	 */
+	if (work->ordered_func)
+		need_order = 1;
+	work->func(work);
+	if (need_order) {
+		set_bit(WORK_DONE_BIT, &work->flags);
+		run_ordered_work(work->wq);
+	}
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
+	INIT_LIST_HEAD(&work->ordered_list);
+	work->flags = 0;
+}
+
+void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
+		      struct btrfs_work_struct *work)
+{
+	unsigned long flags;
+
+	work->wq = wq;
+	if (work->ordered_func) {
+		spin_lock_irqsave(&wq->list_lock, flags);
+		list_add_tail(&work->ordered_list, &wq->ordered_list);
+		spin_unlock_irqrestore(&wq->list_lock, flags);
+	}
+	queue_work(wq->normal_wq, &work->normal_work);
+}
+
+void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq)
+{
+	destroy_workqueue(wq->normal_wq);
+	kfree(wq);
+}
+
+void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max)
+{
+	workqueue_set_max_active(wq->normal_wq, max);
+}
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 1f26792..1d16156 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
+ * Copyright (C) 2013 Fujitsu.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -118,4 +119,30 @@ void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
 			struct btrfs_workers *async_starter);
 void btrfs_requeue_work(struct btrfs_work *work);
 void btrfs_set_work_high_prio(struct btrfs_work *work);
+
+struct btrfs_workqueue_struct;
+
+struct btrfs_work_struct {
+	void (*func)(struct btrfs_work_struct *arg);
+	void (*ordered_func)(struct btrfs_work_struct *arg);
+	void (*ordered_free)(struct btrfs_work_struct *arg);
+
+	/* Don't touch things below */
+	struct work_struct normal_work;
+	struct list_head ordered_list;
+	struct btrfs_workqueue_struct *wq;
+	unsigned long flags;
+};
+
+struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
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
1.8.5.1

