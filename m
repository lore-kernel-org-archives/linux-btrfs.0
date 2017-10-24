Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:34926 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbdJXIkK (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 04:40:10 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 5/6] btrfs: qgroup: Update trace events to use new separate rsv types
Date: Tue, 24 Oct 2017 16:39:40 +0800
Message-Id: <20171024083941.21428-6-wqu@suse.com>
In-Reply-To: <20171024083941.21428-1-wqu@suse.com>
References: <20171024083941.21428-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To make the trace point cleaner, remove the @fs_info parameter, and
integrate @fs_info to struct qgroup.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c            | 32 ++++++++++++++++++--------------
 include/trace/events/btrfs.h | 17 ++++++++++++-----
 2 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ba6f60fd0e96..2b587056b797 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -73,15 +73,19 @@ static const char *qgroup_rsv_type_str(enum btrfs_qgroup_rsv_type type)
 	return NULL;
 }
 
-static void qgroup_rsv_increase(struct btrfs_qgroup *qgroup, u64 num_bytes,
+static void qgroup_rsv_increase(struct btrfs_fs_info *fs_info,
+				struct btrfs_qgroup *qgroup, u64 num_bytes,
 				enum btrfs_qgroup_rsv_type type)
 {
+	trace_qgroup_update_reserve(fs_info, qgroup, num_bytes, type);
 	qgroup->rsv.values[type] += num_bytes;
 }
 
-static void qgroup_rsv_decrease(struct btrfs_qgroup *qgroup, u64 num_bytes,
+static void qgroup_rsv_decrease(struct btrfs_fs_info *fs_info,
+				struct btrfs_qgroup *qgroup, u64 num_bytes,
 				enum btrfs_qgroup_rsv_type type)
 {
+	trace_qgroup_update_reserve(fs_info, qgroup, -(s64)num_bytes, type);
 	if (qgroup->rsv.values[type] >= num_bytes) {
 		qgroup->rsv.values[type] -= num_bytes;
 		return;
@@ -95,22 +99,24 @@ static void qgroup_rsv_decrease(struct btrfs_qgroup *qgroup, u64 num_bytes,
 	qgroup->rsv.values[type] = 0;
 }
 
-static void qgroup_rsv_increase_by_qgroup(struct btrfs_qgroup *dest,
+static void qgroup_rsv_increase_by_qgroup(struct btrfs_fs_info *fs_info,
+					  struct btrfs_qgroup *dest,
 					  struct btrfs_qgroup *src)
 {
 	int i;
 
 	for (i = 0; i <= BTRFS_QGROUP_RSV_TYPES; i++)
-		qgroup_rsv_increase(dest, src->rsv.values[i], i);
+		qgroup_rsv_increase(fs_info, dest, src->rsv.values[i], i);
 }
 
-static void qgroup_rsv_decrease_by_qgroup(struct btrfs_qgroup *dest,
+static void qgroup_rsv_decrease_by_qgroup(struct btrfs_fs_info *fs_info,
+					  struct btrfs_qgroup *dest,
 					  struct btrfs_qgroup *src)
 {
 	int i;
 
 	for (i = 0; i <= BTRFS_QGROUP_RSV_TYPES; i++)
-		qgroup_rsv_decrease(dest, src->rsv.values[i], i);
+		qgroup_rsv_decrease(fs_info, dest, src->rsv.values[i], i);
 }
 
 static void btrfs_qgroup_update_old_refcnt(struct btrfs_qgroup *qg, u64 seq,
@@ -1102,9 +1108,9 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 
 	/* *Inherit* qgroup rsv info from @src */
 	if (sign > 0)
-		qgroup_rsv_increase_by_qgroup(qgroup, src);
+		qgroup_rsv_increase_by_qgroup(fs_info, qgroup, src);
 	else
-		qgroup_rsv_decrease_by_qgroup(qgroup, src);
+		qgroup_rsv_decrease_by_qgroup(fs_info, qgroup, src);
 
 	qgroup_dirty(fs_info, qgroup);
 
@@ -1125,9 +1131,9 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
 		qgroup->excl += sign * num_bytes;
 		if (sign > 0)
-			qgroup_rsv_increase_by_qgroup(qgroup, src);
+			qgroup_rsv_increase_by_qgroup(fs_info, qgroup, src);
 		else
-			qgroup_rsv_decrease_by_qgroup(qgroup, src);
+			qgroup_rsv_decrease_by_qgroup(fs_info, qgroup, src);
 		qgroup->excl_cmpr += sign * num_bytes;
 		qgroup_dirty(fs_info, qgroup);
 
@@ -2498,8 +2504,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
 
 		qg = unode_aux_to_qgroup(unode);
 
-		trace_qgroup_update_reserve(fs_info, qg, num_bytes);
-		qgroup_rsv_increase(qg, num_bytes, type);
+		qgroup_rsv_increase(fs_info, qg, num_bytes, type);
 	}
 
 out:
@@ -2545,8 +2550,7 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 
 		qg = unode_aux_to_qgroup(unode);
 
-		trace_qgroup_update_reserve(fs_info, qg, -(s64)num_bytes);
-		qgroup_rsv_decrease(qg, num_bytes, type);
+		qgroup_rsv_decrease(fs_info, qg, num_bytes, type);
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index dc1d0df91e0b..68c4d11f55fa 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -63,6 +63,11 @@ struct prelim_ref;
 		 { BTRFS_FILE_EXTENT_REG,	"REG"	 },		\
 		 { BTRFS_FILE_EXTENT_PREALLOC,	"PREALLOC"})
 
+#define show_qgroup_rsv_type(type)					\
+	__print_symbolic(type,						\
+		{ BTRFS_QGROUP_RSV_DATA,	"DATA"	},		\
+		{ BTRFS_QGROUP_RSV_META,	"META"	})
+
 #define BTRFS_GROUP_FLAGS	\
 	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
 	{ BTRFS_BLOCK_GROUP_SYSTEM,	"SYSTEM"},	\
@@ -1594,24 +1599,26 @@ TRACE_EVENT(qgroup_update_counters,
 TRACE_EVENT(qgroup_update_reserve,
 
 	TP_PROTO(struct btrfs_fs_info *fs_info, struct btrfs_qgroup *qgroup,
-		 s64 diff),
+		 s64 diff, int type),
 
-	TP_ARGS(fs_info, qgroup, diff),
+	TP_ARGS(fs_info, qgroup, diff, type),
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,	qgid			)
 		__field(	u64,	cur_reserved		)
 		__field(	s64,	diff			)
+		__field(	int,	type			)
 	),
 
 	TP_fast_assign_btrfs(fs_info,
 		__entry->qgid		= qgroup->qgroupid;
-		__entry->cur_reserved	= qgroup->reserved;
+		__entry->cur_reserved	= qgroup->rsv.values[type];
 		__entry->diff		= diff;
 	),
 
-	TP_printk_btrfs("qgid=%llu cur_reserved=%llu diff=%lld",
-		__entry->qgid, __entry->cur_reserved, __entry->diff)
+	TP_printk_btrfs("qgid=%llu type=%s cur_reserved=%llu diff=%lld",
+		__entry->qgid, show_qgroup_rsv_type(__entry->type),
+		__entry->cur_reserved, __entry->diff)
 );
 
 TRACE_EVENT(qgroup_meta_reserve,
-- 
2.14.2

