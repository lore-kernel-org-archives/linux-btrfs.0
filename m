Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:60863 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbdLVGTQ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 22 Dec 2017 01:19:16 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 07/10] btrfs: qgroup: Update trace events for metadata reservation
Date: Fri, 22 Dec 2017 14:18:44 +0800
Message-Id: <20171222061847.13158-8-wqu@suse.com>
In-Reply-To: <20171222061847.13158-1-wqu@suse.com>
References: <20171222061847.13158-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now trace_qgroup_meta_reserve() will have extra type parameter.

And introduce two new trace events:
1) trace_qgroup_meta_free_all_pertrans()
   For btrfs_qgroup_free_meta_all_pertrans()

2) trace_qgroup_meta_convert()
   For btrfs_qgroup_convert_reserved_meta()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c            |  7 +++---
 include/trace/events/btrfs.h | 55 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 96ed678b3588..ee5b05dd10a9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3150,7 +3150,7 @@ int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 		return 0;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	trace_qgroup_meta_reserve(root, (s64)num_bytes);
+	trace_qgroup_meta_reserve(root, type, (s64)num_bytes);
 	ret = qgroup_reserve(root, num_bytes, enforce, type);
 	if (ret < 0)
 		return ret;
@@ -3175,7 +3175,7 @@ void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
 		return;
 
 	/* TODO: Update trace point to handle such free */
-	trace_qgroup_meta_reserve(root, 0);
+	trace_qgroup_meta_free_all_pertrans(root);
 	/* Special value -1 means to free all reserved space */
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, (u64)-1,
 				  BTRFS_QGROUP_RSV_META_PERTRANS);
@@ -3197,7 +3197,7 @@ void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
 	 */
 	num_bytes = sub_root_meta_rsv(root, num_bytes, type);
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	trace_qgroup_meta_reserve(root, -(s64)num_bytes);
+	trace_qgroup_meta_reserve(root, type, -(s64)num_bytes);
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes, type);
 }
 
@@ -3257,6 +3257,7 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes)
 	/* Same as btrfs_qgroup_free_meta_prealloc() */
 	num_bytes = sub_root_meta_rsv(root, num_bytes,
 				      BTRFS_QGROUP_RSV_META_PREALLOC);
+	trace_qgroup_meta_convert(root, num_bytes);
 	qgroup_convert_meta(fs_info, root->objectid, num_bytes);
 }
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e3218e673e1d..4460f1e84e45 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1629,6 +1629,28 @@ TRACE_EVENT(qgroup_update_reserve,
 
 TRACE_EVENT(qgroup_meta_reserve,
 
+	TP_PROTO(struct btrfs_root *root, s64 diff, int type),
+
+	TP_ARGS(root, diff, type),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	refroot			)
+		__field(	s64,	diff			)
+		__field(	int,	type			)
+	),
+
+	TP_fast_assign_btrfs(root->fs_info,
+		__entry->refroot	= root->objectid;
+		__entry->diff		= diff;
+	),
+
+	TP_printk_btrfs("refroot=%llu(%s) type=%s diff=%lld",
+		show_root_type(__entry->refroot),
+		show_qgroup_rsv_type(__entry->type), __entry->diff)
+);
+
+TRACE_EVENT(qgroup_meta_convert,
+
 	TP_PROTO(struct btrfs_root *root, s64 diff),
 
 	TP_ARGS(root, diff),
@@ -1636,6 +1658,7 @@ TRACE_EVENT(qgroup_meta_reserve,
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,	refroot			)
 		__field(	s64,	diff			)
+		__field(	int,	type			)
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
@@ -1643,8 +1666,36 @@ TRACE_EVENT(qgroup_meta_reserve,
 		__entry->diff		= diff;
 	),
 
-	TP_printk_btrfs("refroot=%llu(%s) diff=%lld",
-		show_root_type(__entry->refroot), __entry->diff)
+	TP_printk_btrfs("refroot=%llu(%s) type=%s->%s diff=%lld",
+		show_root_type(__entry->refroot),
+		show_qgroup_rsv_type(BTRFS_QGROUP_RSV_META_PREALLOC),
+		show_qgroup_rsv_type(BTRFS_QGROUP_RSV_META_PERTRANS),
+		__entry->diff)
+);
+
+TRACE_EVENT(qgroup_meta_free_all_pertrans,
+
+	TP_PROTO(struct btrfs_root *root),
+
+	TP_ARGS(root),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	refroot			)
+		__field(	s64,	diff			)
+		__field(	int,	type			)
+	),
+
+	TP_fast_assign_btrfs(root->fs_info,
+		__entry->refroot	= root->objectid;
+		spin_lock(&root->qgroup_meta_rsv_lock);
+		__entry->diff		= -(s64)root->qgroup_meta_rsv_pertrans;
+		spin_unlock(&root->qgroup_meta_rsv_lock);
+		__entry->type		= BTRFS_QGROUP_RSV_META_PERTRANS;
+	),
+
+	TP_printk_btrfs("refroot=%llu(%s) type=%s diff=%lld",
+		show_root_type(__entry->refroot),
+		show_qgroup_rsv_type(__entry->type), __entry->diff)
 );
 
 DECLARE_EVENT_CLASS(btrfs__prelim_ref,
-- 
2.15.1

