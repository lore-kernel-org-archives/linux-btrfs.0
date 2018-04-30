Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:34269 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbeD3HZG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 30 Apr 2018 03:25:06 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: trace: Allow trace_qgroup_update_counters() to record old rfer/excl value
Date: Mon, 30 Apr 2018 15:04:44 +0800
Message-Id: <20180430070444.23837-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Origin trace_qgroup_update_counters() only records qgroup id and its
reference count change.

It's good enough to debug qgroup accounting change, but when rescan race
is involved, it's pretty hard to distinguish which modification belongs
to which rescan.

So add old_rfer and old_excl trace output to help distinguishing
different rescan instance.
(Different rescan instance should reset its qgroup->rfer to 0)

For trace event parameter, it just changes from u64 qgroup_id to struct
btrfs_qgroup *qgroup, so number of parameters is not changed at all.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c            |  4 ++--
 include/trace/events/btrfs.h | 18 +++++++++++-------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9fb758d5077a..ec2339a49ec3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1882,8 +1882,8 @@ static int qgroup_update_counters(struct btrfs_fs_info *fs_info,
 		cur_old_count = btrfs_qgroup_get_old_refcnt(qg, seq);
 		cur_new_count = btrfs_qgroup_get_new_refcnt(qg, seq);
 
-		trace_qgroup_update_counters(fs_info, qg->qgroupid,
-					     cur_old_count, cur_new_count);
+		trace_qgroup_update_counters(fs_info, qg, cur_old_count,
+					     cur_new_count);
 
 		/* Rfer update part */
 		if (cur_old_count == 0 && cur_new_count > 0) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 38f444bf55fe..cfcbcd2eb338 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1607,27 +1607,31 @@ TRACE_EVENT(btrfs_qgroup_account_extent,
 
 TRACE_EVENT(qgroup_update_counters,
 
-	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 qgid,
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
+		 struct btrfs_qgroup *qgroup,
 		 u64 cur_old_count, u64 cur_new_count),
 
-	TP_ARGS(fs_info, qgid, cur_old_count, cur_new_count),
+	TP_ARGS(fs_info, qgroup, cur_old_count, cur_new_count),
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,  qgid			)
+		__field(	u64,  old_rfer			)
+		__field(	u64,  old_excl			)
 		__field(	u64,  cur_old_count		)
 		__field(	u64,  cur_new_count		)
 	),
 
 	TP_fast_assign_btrfs(fs_info,
-		__entry->qgid		= qgid;
+		__entry->qgid		= qgroup->qgroupid;
+		__entry->old_rfer	= qgroup->rfer;
+		__entry->old_excl	= qgroup->excl;
 		__entry->cur_old_count	= cur_old_count;
 		__entry->cur_new_count	= cur_new_count;
 	),
 
-	TP_printk_btrfs("qgid=%llu cur_old_count=%llu cur_new_count=%llu",
-		  __entry->qgid,
-		  __entry->cur_old_count,
-		  __entry->cur_new_count)
+	TP_printk_btrfs("qgid=%llu old_rfer=%llu old_excl=%llu cur_old_count=%llu cur_new_count=%llu",
+		  __entry->qgid, __entry->old_rfer, __entry->old_excl,
+		  __entry->cur_old_count, __entry->cur_new_count)
 );
 
 TRACE_EVENT(qgroup_update_reserve,
-- 
2.17.0

