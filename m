Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728354AbeIGOMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 10:12:48 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5781DAFC8
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 09:32:42 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/5] btrfs: qgroup: Introduce trace event to analyse the number of dirty extents accounted
Date: Fri,  7 Sep 2018 17:32:31 +0800
Message-Id: <20180907093235.28254-2-wqu@suse.com>
In-Reply-To: <20180907093235.28254-1-wqu@suse.com>
References: <20180907093235.28254-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Number of qgroup dirty extents is directly linked to the performance
overhead, so add a new trace event, trace_qgroup_num_dirty_extents(), to
record how many dirty extents is processed in
btrfs_qgroup_account_extents().

This will be pretty handy to analyse later balance performance
improvement.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c            |  4 ++++
 include/trace/events/btrfs.h | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4353bb69bb86..5977eedc00d8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2133,6 +2133,7 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct ulist *new_roots = NULL;
 	struct rb_node *node;
+	u64 num_dirty_extents = 0;
 	u64 qgroup_to_skip;
 	int ret = 0;
 
@@ -2142,6 +2143,7 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 		record = rb_entry(node, struct btrfs_qgroup_extent_record,
 				  node);
 
+		num_dirty_extents++;
 		trace_btrfs_qgroup_account_extents(fs_info, record);
 
 		if (!ret) {
@@ -2187,6 +2189,8 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 		kfree(record);
 
 	}
+	trace_qgroup_num_dirty_extents(fs_info, trans->transid,
+				       num_dirty_extents);
 	return ret;
 }
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index b401c4e36394..79253666d1d0 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1575,6 +1575,27 @@ DEFINE_EVENT(btrfs_qgroup_extent, btrfs_qgroup_trace_extent,
 	TP_ARGS(fs_info, rec)
 );
 
+TRACE_EVENT(qgroup_num_dirty_extents,
+
+	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 transid,
+		 u64 num_dirty_extents),
+
+	TP_ARGS(fs_info, transid, num_dirty_extents),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64, transid			)
+		__field(	u64, num_dirty_extents		)
+	),
+
+	TP_fast_assign_btrfs(fs_info,
+		__entry->transid	   = transid;
+		__entry->num_dirty_extents = num_dirty_extents;
+	),
+
+	TP_printk_btrfs("transid=%llu num_dirty_extents=%llu",
+		__entry->transid, __entry->num_dirty_extents)
+);
+
 TRACE_EVENT(btrfs_qgroup_account_extent,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 transid, u64 bytenr,
-- 
2.18.0
