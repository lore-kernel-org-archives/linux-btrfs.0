Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:59931 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754026AbbJIChK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:37:10 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992aV81023975
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:36:31 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 20/23] btrfs: qgroup: Add new trace point for qgroup data reserve
Date: Fri, 9 Oct 2015 10:34:52 +0800
Message-ID: <1444358095-3575-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now each qgroup reserve for data will has its ftrace event for better
debugging.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced
---
 fs/btrfs/qgroup.c            |  15 +++++-
 fs/btrfs/qgroup.h            |   8 +++
 include/trace/events/btrfs.h | 113 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6f397ce..54ba9fc 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2818,6 +2818,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
 	struct btrfs_qgroup_data_rsv_map *reserve_map;
 	struct data_rsv_range *tmp = NULL;
 	struct ulist *insert_list;
+	u64 reserved = 0;
 	int ret;
 
 	if (!root->fs_info->quota_enabled || !is_fstree(root->objectid) ||
@@ -2841,7 +2842,9 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
 
 	spin_lock(&reserve_map->lock);
 	ret = reserve_data_range(root, reserve_map, tmp, insert_list, start,
-				 len, NULL);
+				 len, &reserved);
+	trace_btrfs_qgroup_reserve_data(inode, start, len, reserved,
+					QGROUP_RESERVE);
 	/*
 	 * For error and already exists case, free tmp memory.
 	 * For tmp used case, set ret to 0, as some careless
@@ -2995,6 +2998,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
 	struct data_rsv_range *tmp;
 	struct btrfs_qgroup_data_rsv_map *map;
 	u64 reserved = 0;
+	int trace_op = QGROUP_RELEASE;
 	int ret;
 
 	spin_lock(&BTRFS_I(inode)->qgroup_init_lock);
@@ -3011,8 +3015,11 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
 	/* release_data_range() won't fail only check if memory is used */
 	if (ret == 0)
 		kfree(tmp);
-	if (free_reserved)
+	if (free_reserved) {
 		qgroup_free(BTRFS_I(inode)->root, reserved);
+		trace_op = QGROUP_FREE;
+	}
+	trace_btrfs_qgroup_release_data(inode, start, len, reserved, trace_op);
 	spin_unlock(&map->lock);
 	return 0;
 }
@@ -3084,6 +3091,7 @@ int btrfs_qgroup_init_data_rsv_map(struct inode *inode)
 	}
 	binode->qgroup_rsv_map = dirty_map;
 out:
+	trace_btrfs_qgroup_init_data_rsv_map(inode, 0);
 	spin_unlock(&binode->qgroup_init_lock);
 	return 0;
 }
@@ -3094,6 +3102,7 @@ void btrfs_qgroup_free_data_rsv_map(struct inode *inode)
 	struct btrfs_root *root = binode->root;
 	struct btrfs_qgroup_data_rsv_map *dirty_map = binode->qgroup_rsv_map;
 	struct rb_node *node;
+	u64 free_reserved = 0;
 
 	/*
 	 * this function is called at inode destroy routine, so no concurrency
@@ -3108,6 +3117,7 @@ void btrfs_qgroup_free_data_rsv_map(struct inode *inode)
 	/* Reserve map should be empty, or we are leaking */
 	WARN_ON(dirty_map->reserved);
 
+	free_reserved = dirty_map->reserved;
 	qgroup_free(root, dirty_map->reserved);
 	spin_lock(&dirty_map->lock);
 	while ((node = rb_first(&dirty_map->root)) != NULL) {
@@ -3121,6 +3131,7 @@ void btrfs_qgroup_free_data_rsv_map(struct inode *inode)
 		rb_erase(node, &dirty_map->root);
 		kfree(range);
 	}
+	trace_btrfs_qgroup_free_data_rsv_map(inode, free_reserved);
 	spin_unlock(&dirty_map->lock);
 	kfree(dirty_map);
 	binode->qgroup_rsv_map = NULL;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 3f6ad43..cd3e515 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -33,6 +33,13 @@ struct btrfs_qgroup_extent_record {
 	struct ulist *old_roots;
 };
 
+/*
+ * For qgroup event trace points only
+ */
+#define QGROUP_RESERVE		(1<<0)
+#define QGROUP_RELEASE		(1<<1)
+#define QGROUP_FREE		(1<<2)
+
 /* For per-inode dirty range reserve */
 struct btrfs_qgroup_data_rsv_map;
 
@@ -84,6 +91,7 @@ static inline void btrfs_qgroup_free_delayed_ref(struct btrfs_fs_info *fs_info,
 						 u64 ref_root, u64 num_bytes)
 {
 	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes);
+	trace_btrfs_qgroup_free_delayed_ref(ref_root, num_bytes);
 }
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 0b73af9..b4473da 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1117,6 +1117,119 @@ DEFINE_EVENT(btrfs__workqueue_done, btrfs_workqueue_destroy,
 	TP_ARGS(wq)
 );
 
+DECLARE_EVENT_CLASS(btrfs__qgroup_data_map,
+
+	TP_PROTO(struct inode *inode, u64 free_reserved),
+
+	TP_ARGS(inode, free_reserved),
+
+	TP_STRUCT__entry(
+		__field(	u64,		rootid		)
+		__field(	unsigned long,	ino		)
+		__field(	u64,		free_reserved	)
+	),
+
+	TP_fast_assign(
+		__entry->rootid		=	BTRFS_I(inode)->root->objectid;
+		__entry->ino		=	inode->i_ino;
+		__entry->free_reserved	=	free_reserved;
+	),
+
+	TP_printk("rootid=%llu, ino=%lu, free_reserved=%llu",
+		  __entry->rootid, __entry->ino, __entry->free_reserved)
+);
+
+DEFINE_EVENT(btrfs__qgroup_data_map, btrfs_qgroup_init_data_rsv_map,
+
+	TP_PROTO(struct inode *inode, u64 free_reserved),
+
+	TP_ARGS(inode, free_reserved)
+);
+
+DEFINE_EVENT(btrfs__qgroup_data_map, btrfs_qgroup_free_data_rsv_map,
+
+	TP_PROTO(struct inode *inode, u64 free_reserved),
+
+	TP_ARGS(inode, free_reserved)
+);
+
+#define BTRFS_QGROUP_OPERATIONS				\
+	{ QGROUP_RESERVE,	"reserve"	},	\
+	{ QGROUP_RELEASE,	"release"	},	\
+	{ QGROUP_FREE,		"free"		}
+
+DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
+
+	TP_PROTO(struct inode *inode, u64 start, u64 len, u64 reserved, int op),
+
+	TP_ARGS(inode, start, len, reserved, op),
+
+	TP_STRUCT__entry(
+		__field(	u64,		rootid		)
+		__field(	unsigned long,	ino		)
+		__field(	u64,		start		)
+		__field(	u64,		len		)
+		__field(	u64,		reserved	)
+		__field(	int,		op		)
+	),
+
+	TP_fast_assign(
+		__entry->rootid		= BTRFS_I(inode)->root->objectid;
+		__entry->ino		= inode->i_ino;
+		__entry->start		= start;
+		__entry->len		= len;
+		__entry->reserved	= reserved;
+		__entry->op		= op;
+	),
+
+	TP_printk("root=%llu, ino=%lu, start=%llu, len=%llu, reserved=%llu, op=%s",
+		  __entry->rootid, __entry->ino, __entry->start, __entry->len,
+		  __entry->reserved,
+		  __print_flags((unsigned long)__entry->op, "",
+				BTRFS_QGROUP_OPERATIONS)
+	)
+);
+
+DEFINE_EVENT(btrfs__qgroup_rsv_data, btrfs_qgroup_reserve_data,
+
+	TP_PROTO(struct inode *inode, u64 start, u64 len, u64 reserved, int op),
+
+	TP_ARGS(inode, start, len, reserved, op)
+);
+
+DEFINE_EVENT(btrfs__qgroup_rsv_data, btrfs_qgroup_release_data,
+
+	TP_PROTO(struct inode *inode, u64 start, u64 len, u64 reserved, int op),
+
+	TP_ARGS(inode, start, len, reserved, op)
+);
+
+DECLARE_EVENT_CLASS(btrfs__qgroup_delayed_ref,
+
+	TP_PROTO(u64 ref_root, u64 reserved),
+
+	TP_ARGS(ref_root, reserved),
+
+	TP_STRUCT__entry(
+		__field(	u64,		ref_root	)
+		__field(	u64,		reserved	)
+	),
+
+	TP_fast_assign(
+		__entry->ref_root	= ref_root;
+		__entry->reserved	= reserved;
+	),
+
+	TP_printk("root=%llu, reserved=%llu, op=free",
+		  __entry->ref_root, __entry->reserved)
+);
+
+DEFINE_EVENT(btrfs__qgroup_delayed_ref, btrfs_qgroup_free_delayed_ref,
+
+	TP_PROTO(u64 ref_root, u64 reserved),
+
+	TP_ARGS(ref_root, reserved)
+);
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.6.1

