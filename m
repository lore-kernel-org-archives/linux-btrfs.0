Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42388 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751427AbdCMHwv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:52:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0D48847D8B96
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 15:52:44 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/9] btrfs: qgroup: Add trace point for qgroup reserved space
Date: Mon, 13 Mar 2017 15:52:08 +0800
Message-ID: <20170313075216.5125-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce the following trace points:
qgroup_update_reserve
qgroup_meta_reserve

These trace points are handy to trace qgroup reserve space related
problems.

Also export btrfs_qgroup structure, as now we directly pass btrfs_qgroup
structure to trace points, so that structure needs to be exported.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c            | 52 +++++++-------------------------------------
 fs/btrfs/qgroup.h            | 44 +++++++++++++++++++++++++++++++++++++
 include/trace/events/btrfs.h | 44 +++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a5da750c1087..68a7305b0a46 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -47,50 +47,6 @@
  *  - check all ioctl parameters
  */
 
-/*
- * one struct for each qgroup, organized in fs_info->qgroup_tree.
- */
-struct btrfs_qgroup {
-	u64 qgroupid;
-
-	/*
-	 * state
-	 */
-	u64 rfer;	/* referenced */
-	u64 rfer_cmpr;	/* referenced compressed */
-	u64 excl;	/* exclusive */
-	u64 excl_cmpr;	/* exclusive compressed */
-
-	/*
-	 * limits
-	 */
-	u64 lim_flags;	/* which limits are set */
-	u64 max_rfer;
-	u64 max_excl;
-	u64 rsv_rfer;
-	u64 rsv_excl;
-
-	/*
-	 * reservation tracking
-	 */
-	u64 reserved;
-
-	/*
-	 * lists
-	 */
-	struct list_head groups;  /* groups this group is member of */
-	struct list_head members; /* groups that are members of this group */
-	struct list_head dirty;   /* dirty groups */
-	struct rb_node node;	  /* tree of qgroups */
-
-	/*
-	 * temp variables for accounting operations
-	 * Refer to qgroup_shared_accounting() for details.
-	 */
-	u64 old_refcnt;
-	u64 new_refcnt;
-};
-
 static void btrfs_qgroup_update_old_refcnt(struct btrfs_qgroup *qg, u64 seq,
 					   int mod)
 {
@@ -1075,6 +1031,7 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	qgroup->excl += sign * num_bytes;
 	qgroup->excl_cmpr += sign * num_bytes;
 	if (sign > 0) {
+		trace_qgroup_update_reserve(fs_info, qgroup, -(s64)num_bytes);
 		if (WARN_ON(qgroup->reserved < num_bytes))
 			report_reserved_underflow(fs_info, qgroup, num_bytes);
 		else
@@ -1100,6 +1057,8 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
 		qgroup->excl += sign * num_bytes;
 		if (sign > 0) {
+			trace_qgroup_update_reserve(fs_info, qgroup,
+						    -(s64)num_bytes);
 			if (WARN_ON(qgroup->reserved < num_bytes))
 				report_reserved_underflow(fs_info, qgroup,
 							  num_bytes);
@@ -2424,6 +2383,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 
 		qg = unode_aux_to_qgroup(unode);
 
+		trace_qgroup_update_reserve(fs_info, qg, num_bytes);
 		qg->reserved += num_bytes;
 	}
 
@@ -2469,6 +2429,7 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 
 		qg = unode_aux_to_qgroup(unode);
 
+		trace_qgroup_update_reserve(fs_info, qg, -(s64)num_bytes);
 		if (WARN_ON(qg->reserved < num_bytes))
 			report_reserved_underflow(fs_info, qg, num_bytes);
 		else
@@ -2945,6 +2906,7 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 		return 0;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
+	trace_qgroup_meta_reserve(root, (s64)num_bytes);
 	ret = qgroup_reserve(root, num_bytes, enforce);
 	if (ret < 0)
 		return ret;
@@ -2964,6 +2926,7 @@ void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
 	reserved = atomic_xchg(&root->qgroup_meta_rsv, 0);
 	if (reserved == 0)
 		return;
+	trace_qgroup_meta_reserve(root, -(s64)reserved);
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved);
 }
 
@@ -2978,6 +2941,7 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
 	WARN_ON(atomic_read(&root->qgroup_meta_rsv) < num_bytes);
 	atomic_sub(num_bytes, &root->qgroup_meta_rsv);
+	trace_qgroup_meta_reserve(root, -(s64)num_bytes);
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes);
 }
 
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 26932a8a1993..e5b42f1044fc 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -62,6 +62,50 @@ struct btrfs_qgroup_extent_record {
 };
 
 /*
+ * one struct for each qgroup, organized in fs_info->qgroup_tree.
+ */
+struct btrfs_qgroup {
+	u64 qgroupid;
+
+	/*
+	 * state
+	 */
+	u64 rfer;	/* referenced */
+	u64 rfer_cmpr;	/* referenced compressed */
+	u64 excl;	/* exclusive */
+	u64 excl_cmpr;	/* exclusive compressed */
+
+	/*
+	 * limits
+	 */
+	u64 lim_flags;	/* which limits are set */
+	u64 max_rfer;
+	u64 max_excl;
+	u64 rsv_rfer;
+	u64 rsv_excl;
+
+	/*
+	 * reservation tracking
+	 */
+	u64 reserved;
+
+	/*
+	 * lists
+	 */
+	struct list_head groups;  /* groups this group is member of */
+	struct list_head members; /* groups that are members of this group */
+	struct list_head dirty;   /* dirty groups */
+	struct rb_node node;	  /* tree of qgroups */
+
+	/*
+	 * temp variables for accounting operations
+	 * Refer to qgroup_shared_accounting() for details.
+	 */
+	u64 old_refcnt;
+	u64 new_refcnt;
+};
+
+/*
  * For qgroup event trace points only
  */
 #define QGROUP_RESERVE		(1<<0)
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index a3c3cab643a9..143dc304dfc1 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -24,6 +24,7 @@ struct extent_buffer;
 struct btrfs_work;
 struct __btrfs_workqueue;
 struct btrfs_qgroup_extent_record;
+struct btrfs_qgroup;
 
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
@@ -1475,6 +1476,49 @@ TRACE_EVENT(qgroup_update_counters,
 		  __entry->cur_new_count)
 );
 
+TRACE_EVENT(qgroup_update_reserve,
+
+	TP_PROTO(struct btrfs_fs_info *fs_info, struct btrfs_qgroup *qgroup,
+		 s64 diff),
+
+	TP_ARGS(fs_info, qgroup, diff),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	qgid			)
+		__field(	u64,	cur_reserved		)
+		__field(	s64,	diff			)
+	),
+
+	TP_fast_assign_btrfs(fs_info,
+		__entry->qgid		= qgroup->qgroupid;
+		__entry->cur_reserved	= qgroup->reserved;
+		__entry->diff		= diff;
+	),
+
+	TP_printk_btrfs("qgid=%llu cur_reserved=%llu diff=%lld",
+		__entry->qgid, __entry->cur_reserved, __entry->diff)
+);
+
+TRACE_EVENT(qgroup_meta_reserve,
+
+	TP_PROTO(struct btrfs_root *root, s64 diff),
+
+	TP_ARGS(root, diff),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	refroot			)
+		__field(	s64,	diff			)
+	),
+
+	TP_fast_assign_btrfs(root->fs_info,
+		__entry->refroot	= root->objectid;
+		__entry->diff		= diff;
+	),
+
+	TP_printk_btrfs("refroot=%llu(%s) diff=%lld",
+		show_root_type(__entry->refroot), __entry->diff)
+);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.12.0



