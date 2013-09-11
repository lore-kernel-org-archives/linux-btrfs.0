Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8360 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3IKIv6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 04:51:58 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8B8ppWk019950
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 16:51:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 3/9] btrfs: Added btrfs_workqueue_struct implemented ordered execution based on kernel workqueue
Date: Wed, 11 Sep 2013 16:52:32 +0800
Message-Id: <1378889558-21514-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use kernel workqueue to implement a new btrfs_workqueue_struct, which
has the ordering execution feature like the btrfs_worker.

The func is executed in a concurrency way, and the
ordred_func/ordered_free is executed in the sequence them are queued
after the corresponding func is done.
The new btrfs_workqueue use 2 workqueues to implement the original
btrfs_worker, one for the normal work and one for ordered work.

At this patch, high priority work queue is not added yet.
The high priority feature will be added in the following patches.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/Makefile |   3 +-
 fs/btrfs/bwq.c    | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/bwq.h    |  59 +++++++++++++++++++++++++++++
 3 files changed, 170 insertions(+), 1 deletion(-)
 create mode 100644 fs/btrfs/bwq.c
 create mode 100644 fs/btrfs/bwq.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 3932224..d7439df 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -8,7 +8,8 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
-	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o
+	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
+	   bwq.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/bwq.c b/fs/btrfs/bwq.c
new file mode 100644
index 0000000..feccf21
--- /dev/null
+++ b/fs/btrfs/bwq.c
@@ -0,0 +1,109 @@
+/*
+ * Copyright (C) 2013 Fujitsu.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/freezer.h>
+#include <linux/workqueue.h>
+#include <linux/completion.h>
+#include <linux/spinlock.h>
+#include "bwq.h"
+
+struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
+						     char *ordered_name,
+						     int max_active)
+{
+	int wq_flags = WQ_UNBOUND | WQ_MEM_RECLAIM;
+	struct btrfs_workqueue_struct *ret = kzalloc(sizeof(*ret), GFP_NOFS);
+	if (unlikely(!ret))
+		return NULL;
+	ret->normal_wq = alloc_workqueue(name, wq_flags, max_active);
+	if (unlikely(!ret->normal_wq)) {
+		kfree(ret);
+		return NULL;
+	}
+
+	ret->ordered_wq = alloc_ordered_workqueue(ordered_name,
+						  WQ_MEM_RECLAIM);
+	if (unlikely(!ret->ordered_wq)) {
+		destroy_workqueue(ret->normal_wq);
+		kfree(ret);
+		return NULL;
+	}
+
+	spin_lock_init(&ret->insert_lock);
+	return ret;
+}
+
+/*
+ * When in out-of-order mode(SSD), high concurrency is OK, so no need
+ * to do the completion things, just call the ordered_func after the
+ * normal work is done
+ */
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
+			    void (*func)(struct btrfs_work_struct *),
+			    void (*ordered_func)(struct btrfs_work_struct *),
+			    void (*ordered_free)(struct btrfs_work_struct *))
+{
+	work->func = func;
+	work->ordered_func = ordered_func;
+	work->ordered_free = ordered_free;
+	init_completion(&work->normal_completion);
+}
+
+void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
+		      struct btrfs_work_struct *work)
+{
+	INIT_WORK(&work->normal_work, normal_work_helper);
+	INIT_WORK(&work->ordered_work, ordered_work_helper);
+	spin_lock(&wq->insert_lock);
+	queue_work(wq->normal_wq, &work->normal_work);
+	queue_work(wq->ordered_wq, &work->ordered_work);
+	spin_unlock(&wq->insert_lock);
+}
+
+void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq)
+{
+	destroy_workqueue(wq->ordered_wq);
+	destroy_workqueue(wq->normal_wq);
+}
+
+void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max)
+{
+	workqueue_set_max_active(wq->normal_wq, max);
+}
diff --git a/fs/btrfs/bwq.h b/fs/btrfs/bwq.h
new file mode 100644
index 0000000..bf12c90
--- /dev/null
+++ b/fs/btrfs/bwq.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2013 Fujitsu.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef __BTRFS_WORK_QUEUE_
+#define __BTRFS_WORK_QUEUE_
+
+struct btrfs_workqueue_struct {
+	struct workqueue_struct *normal_wq;
+	struct workqueue_struct *ordered_wq;
+
+	/*
+	 * Spinlock to ensure that both ordered and normal work can
+	 * be inserted to each workqueue at the same sequance,
+	 * which will reduce the ordered_work waiting time and disk head moves.
+	 *
+	 * For HDD, without the lock seqence read/write performance
+	 * will regress about 40% due to the extra waiting and seeking.
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
+struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
+						     char *ordered_name,
+						     int max_active);
+void btrfs_init_work(struct btrfs_work_struct *work,
+		     void (*func)(struct btrfs_work_struct *),
+		     void (*ordered_func)(struct btrfs_work_struct *),
+		     void (*ordered_free)(struct btrfs_work_struct *));
+void btrfs_queue_work(struct btrfs_workqueue_struct *wq,
+		      struct btrfs_work_struct *work);
+void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq);
+void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max);
+#endif
-- 
1.8.4

