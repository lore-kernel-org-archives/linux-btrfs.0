Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:49617 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbeECB7T (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 2 May 2018 21:59:19 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Allow trace_btrfs_qgroup_account_extent() to record its transid
Date: Thu,  3 May 2018 09:59:02 +0800
Message-Id: <20180503015902.26032-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When debugging quota rescan race, some times btrfs rescan could account
some old (committed) leaf and then re-account newly committed leaf
in next generation.

This race needs extra transid to locate, so add @transid for
trace_btrfs_qgroup_account_extent() for such debug.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c            |  4 ++--
 include/trace/events/btrfs.h | 20 ++++++++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a5742e9e9a14..4baa4ba2d630 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2014,8 +2014,8 @@ btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 
 	BUG_ON(!fs_info->quota_root);
 
-	trace_btrfs_qgroup_account_extent(fs_info, bytenr, num_bytes,
-					  nr_old_roots, nr_new_roots);
+	trace_btrfs_qgroup_account_extent(fs_info, trans->transid, bytenr,
+					num_bytes, nr_old_roots, nr_new_roots);
 
 	qgroups = ulist_alloc(GFP_NOFS);
 	if (!qgroups) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index cfcbcd2eb338..59bb885b557e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1578,12 +1578,14 @@ DEFINE_EVENT(btrfs_qgroup_extent, btrfs_qgroup_trace_extent,
 
 TRACE_EVENT(btrfs_qgroup_account_extent,
 
-	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 bytenr,
+	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 transid, u64 bytenr,
 		 u64 num_bytes, u64 nr_old_roots, u64 nr_new_roots),
 
-	TP_ARGS(fs_info, bytenr, num_bytes, nr_old_roots, nr_new_roots),
+	TP_ARGS(fs_info, transid, bytenr, num_bytes, nr_old_roots,
+		nr_new_roots),
 
 	TP_STRUCT__entry_btrfs(
+		__field(	u64,  transid			)
 		__field(	u64,  bytenr			)
 		__field(	u64,  num_bytes			)
 		__field(	u64,  nr_old_roots		)
@@ -1591,18 +1593,20 @@ TRACE_EVENT(btrfs_qgroup_account_extent,
 	),
 
 	TP_fast_assign_btrfs(fs_info,
+		__entry->transid	= transid;
 		__entry->bytenr		= bytenr;
 		__entry->num_bytes	= num_bytes;
 		__entry->nr_old_roots	= nr_old_roots;
 		__entry->nr_new_roots	= nr_new_roots;
 	),
 
-	TP_printk_btrfs("bytenr=%llu num_bytes=%llu nr_old_roots=%llu "
-		  "nr_new_roots=%llu",
-		  __entry->bytenr,
-		  __entry->num_bytes,
-		  __entry->nr_old_roots,
-		  __entry->nr_new_roots)
+	TP_printk_btrfs(
+"transid=%llu bytenr=%llu num_bytes=%llu nr_old_roots=%llu nr_new_roots=%llu",
+		__entry->transid,
+		__entry->bytenr,
+		__entry->num_bytes,
+		__entry->nr_old_roots,
+		__entry->nr_new_roots)
 );
 
 TRACE_EVENT(qgroup_update_counters,
-- 
2.17.0

