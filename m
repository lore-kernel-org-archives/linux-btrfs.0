Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55189 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbdBSNay (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Feb 2017 08:30:54 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 99D97ABA2
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Feb 2017 13:30:52 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] qgroup: Add trace events for reserve and free_ref_root
Date: Sun, 19 Feb 2017 07:30:37 -0600
Message-Id: <20170219133037.20888-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

These commits show the current value of qg->reserved and
the amount modified. Though these are frequently called function,
we may require to monitor qg->reserved for some operations.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/qgroup.c            |  4 ++++
 include/trace/events/btrfs.h | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index dfd9986..4700cac 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2159,6 +2159,8 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
+		trace_btrfs_qgroup_reserve(fs_info, qg->qgroupid, qg->reserved, num_bytes);
+
 		qg->reserved += num_bytes;
 	}
 
@@ -2204,6 +2206,8 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 
 		qg = u64_to_ptr(unode->aux);
 
+		trace_btrfs_qgroup_free_refroot(fs_info, qg->qgroupid, qg->reserved, num_bytes);
+
 		qg->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 6d7fe11..f6a9f8c 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1472,6 +1472,46 @@ TRACE_EVENT(qgroup_update_counters,
 		  __entry->cur_new_count)
 );
 
+DECLARE_EVENT_CLASS(btrfs_qgroup_reserved,
+
+	TP_PROTO(struct btrfs_fs_info *fs_info, u64 qgid,
+		 u64 reserved, u64 num_bytes),
+
+	TP_ARGS(fs_info, qgid, reserved, num_bytes),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,  qgid			)
+		__field(	u64,  reserved		)
+		__field(	u64,  num_bytes		)
+	),
+
+	TP_fast_assign_btrfs(fs_info,
+		__entry->qgid		= qgid;
+		__entry->reserved	= reserved;
+		__entry->num_bytes	= num_bytes;
+	),
+
+	TP_printk_btrfs("qgid = %llu, reserved = %llu, num_bytes = %llu",
+		  __entry->qgid,
+		  __entry->reserved,
+		  __entry->num_bytes)
+);
+
+
+DEFINE_EVENT(btrfs_qgroup_reserved, btrfs_qgroup_reserve,
+
+	TP_PROTO(struct btrfs_fs_info *fs_info, u64 qgid, u64 reserved, u64 num_bytes),
+
+	TP_ARGS(fs_info, qgid, reserved, num_bytes)
+);
+
+DEFINE_EVENT(btrfs_qgroup_reserved, btrfs_qgroup_free_refroot,
+
+	TP_PROTO(struct btrfs_fs_info *fs_info, u64 qgid, u64 reserved, u64 num_bytes),
+
+	TP_ARGS(fs_info, qgid, reserved, num_bytes)
+);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.10.2

