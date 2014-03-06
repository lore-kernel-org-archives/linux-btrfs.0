Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31859 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752886AbaCFDyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Mar 2014 22:54:47 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s263fC3A011304
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 11:41:12 +0800
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs: Add ftrace for btrfs_workqueue
Date: Thu, 6 Mar 2014 03:41:11 +0000
Message-ID: <1394077339-5920-2-git-send-email-quwenruo@cn.fujitsu.com>
References: <1394077339-5920-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1394077339-5920-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add ftrace for btrfs_workqueue for further workqueue tunning.
This patch needs to applied after the workqueue replace patchset.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/async-thread.c      |  7 ++++
 include/trace/events/btrfs.h | 82 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index d8c07e5..00623dd 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -24,6 +24,7 @@
 #include <linux/freezer.h>
 #include <linux/workqueue.h>
 #include "async-thread.h"
+#include "ctree.h"
 
 #define WORK_DONE_BIT 0
 #define WORK_ORDER_DONE_BIT 1
@@ -210,6 +211,7 @@ static void run_ordered_work(struct __btrfs_workqueue *wq)
 		 */
 		if (test_and_set_bit(WORK_ORDER_DONE_BIT, &work->flags))
 			break;
+		trace_btrfs_ordered_sched(work);
 		spin_unlock_irqrestore(lock, flags);
 		work->ordered_func(work);
 
@@ -223,6 +225,7 @@ static void run_ordered_work(struct __btrfs_workqueue *wq)
 		 * with the lock held though
 		 */
 		work->ordered_free(work);
+		trace_btrfs_all_work_done(work);
 	}
 	spin_unlock_irqrestore(lock, flags);
 }
@@ -246,12 +249,15 @@ static void normal_work_helper(struct work_struct *arg)
 		need_order = 1;
 	wq = work->wq;
 
+	trace_btrfs_work_sched(work);
 	thresh_exec_hook(wq);
 	work->func(work);
 	if (need_order) {
 		set_bit(WORK_DONE_BIT, &work->flags);
 		run_ordered_work(wq);
 	}
+	if (!need_order)
+		trace_btrfs_all_work_done(work);
 }
 
 void btrfs_init_work(struct btrfs_work *work,
@@ -280,6 +286,7 @@ static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
 		spin_unlock_irqrestore(&wq->list_lock, flags);
 	}
 	queue_work(wq->normal_wq, &work->normal_work);
+	trace_btrfs_work_queued(work);
 }
 
 void btrfs_queue_work(struct btrfs_workqueue *wq,
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 3176cdc..c346919 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -21,6 +21,7 @@ struct btrfs_block_group_cache;
 struct btrfs_free_cluster;
 struct map_lookup;
 struct extent_buffer;
+struct btrfs_work;
 
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
@@ -982,6 +983,87 @@ TRACE_EVENT(free_extent_state,
 		  (void *)__entry->ip)
 );
 
+DECLARE_EVENT_CLASS(btrfs__work,
+
+	TP_PROTO(struct btrfs_work *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field(	void *,	work			)
+		__field(	void *, wq			)
+		__field(	void *,	func			)
+		__field(	void *,	ordered_func		)
+		__field(	void *,	ordered_free		)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->wq		= work->wq;
+		__entry->func		= work->func;
+		__entry->ordered_func	= work->ordered_func;
+		__entry->ordered_free	= work->ordered_free;
+	),
+
+	TP_printk("work=%p, wq=%p, func=%p, ordered_func=%p, ordered_free=%p",
+		  __entry->work, __entry->wq, __entry->func,
+		  __entry->ordered_func, __entry->ordered_free)
+);
+
+/* For situiations that the work is freed */
+DECLARE_EVENT_CLASS(btrfs__work__done,
+
+	TP_PROTO(struct btrfs_work *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field(	void *,	work			)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+	),
+
+	TP_printk("work->%p", __entry->work)
+);
+
+DEFINE_EVENT(btrfs__work, btrfs_work_queued,
+
+	TP_PROTO(struct btrfs_work *work),
+
+	TP_ARGS(work)
+);
+
+DEFINE_EVENT(btrfs__work, btrfs_work_sched,
+
+	TP_PROTO(struct btrfs_work *work),
+
+	TP_ARGS(work)
+);
+
+DEFINE_EVENT(btrfs__work, btrfs_normal_work_done,
+
+	TP_PROTO(struct btrfs_work *work),
+
+	TP_ARGS(work)
+);
+
+DEFINE_EVENT(btrfs__work__done, btrfs_all_work_done,
+
+	TP_PROTO(struct btrfs_work *work),
+
+	TP_ARGS(work)
+);
+
+DEFINE_EVENT(btrfs__work, btrfs_ordered_sched,
+
+	TP_PROTO(struct btrfs_work *work),
+
+	TP_ARGS(work)
+);
+
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
1.9.0
