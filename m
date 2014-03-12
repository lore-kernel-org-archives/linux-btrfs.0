Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50307 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754970AbaCLIF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 04:05:58 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2C85UBC012343
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 16:05:30 +0800
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Add trace for btrfs_workqueue alloc/destroy
Date: Wed, 12 Mar 2014 08:05:33 +0000
Message-ID: <1394611597-2804-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since most of the btrfs_workqueue is printed as pointer address,
for easier analysis, add trace for btrfs_workqueue alloc/destroy.
So it is possible to determine the workqueue that a given work belongs
to(by comparing the wq pointer address with alloc trace event).

Signed-off-by: Qu Wenruo <quenruo@cn.fujitsu.com>
---
 fs/btrfs/async-thread.c      |  7 ++++--
 fs/btrfs/async-thread.h      |  2 +-
 include/trace/events/btrfs.h | 55 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 00623dd..c74b910 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -56,7 +56,8 @@ struct btrfs_workqueue {
 };
 
 static inline struct __btrfs_workqueue
-*__btrfs_alloc_workqueue(char *name, int flags, int max_active, int thresh)
+*__btrfs_alloc_workqueue(const char *name, int flags, int max_active,
+			 int thresh)
 {
 	struct __btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_NOFS);
 
@@ -92,13 +93,14 @@ static inline struct __btrfs_workqueue
 	INIT_LIST_HEAD(&ret->ordered_list);
 	spin_lock_init(&ret->list_lock);
 	spin_lock_init(&ret->thres_lock);
+	trace_btrfs_workqueue_alloc(ret, name, flags & WQ_HIGHPRI);
 	return ret;
 }
 
 static inline void
 __btrfs_destroy_workqueue(struct __btrfs_workqueue *wq);
 
-struct btrfs_workqueue *btrfs_alloc_workqueue(char *name,
+struct btrfs_workqueue *btrfs_alloc_workqueue(const char *name,
 					      int flags,
 					      int max_active,
 					      int thresh)
@@ -305,6 +307,7 @@ static inline void
 __btrfs_destroy_workqueue(struct __btrfs_workqueue *wq)
 {
 	destroy_workqueue(wq->normal_wq);
+	trace_btrfs_workqueue_destroy(wq);
 	kfree(wq);
 }
 
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 0a891cd..9c6b66d 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -38,7 +38,7 @@ struct btrfs_work {
 	unsigned long flags;
 };
 
-struct btrfs_workqueue *btrfs_alloc_workqueue(char *name,
+struct btrfs_workqueue *btrfs_alloc_workqueue(const char *name,
 					      int flags,
 					      int max_active,
 					      int thresh);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index c346919..4ee4e30 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -22,6 +22,7 @@ struct btrfs_free_cluster;
 struct map_lookup;
 struct extent_buffer;
 struct btrfs_work;
+struct __btrfs_workqueue;
 
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
@@ -1063,6 +1064,60 @@ DEFINE_EVENT(btrfs__work, btrfs_ordered_sched,
 	TP_ARGS(work)
 );
 
+DECLARE_EVENT_CLASS(btrfs__workqueue,
+
+	TP_PROTO(struct __btrfs_workqueue *wq, const char *name, int high),
+
+	TP_ARGS(wq, name, high),
+
+	TP_STRUCT__entry(
+		__field(	void *,	wq			)
+		__string(	name,	name			)
+		__field(	int ,	high			)
+	),
+
+	TP_fast_assign(
+		__entry->wq		= wq;
+		__assign_str(name, name);
+		__entry->high		= high;
+	),
+
+	TP_printk("name=%s%s, wq=%p", __get_str(name),
+		  __print_flags(__entry->high, "",
+				{(WQ_HIGHPRI),	"-high"}),
+		  __entry->wq)
+);
+
+DEFINE_EVENT(btrfs__workqueue, btrfs_workqueue_alloc,
+
+	TP_PROTO(struct __btrfs_workqueue *wq, const char *name, int high),
+
+	TP_ARGS(wq, name, high)
+);
+
+DECLARE_EVENT_CLASS(btrfs__workqueue_done,
+
+	TP_PROTO(struct __btrfs_workqueue *wq),
+
+	TP_ARGS(wq),
+
+	TP_STRUCT__entry(
+		__field(	void *,	wq			)
+	),
+
+	TP_fast_assign(
+		__entry->wq		= wq;
+	),
+
+	TP_printk("wq=%p", __entry->wq)
+);
+
+DEFINE_EVENT(btrfs__workqueue_done, btrfs_workqueue_destroy,
+
+	TP_PROTO(struct __btrfs_workqueue *wq),
+
+	TP_ARGS(wq)
+);
 
 #endif /* _TRACE_BTRFS_H */
 
-- 
1.9.0
