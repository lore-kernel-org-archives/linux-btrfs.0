Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48181 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752361AbdGKKZZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 06:25:25 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.com, clm@fb.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove redundant argument of flush_space
Date: Tue, 11 Jul 2017 13:25:13 +0300
Message-Id: <1499768713-23471-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers of flush_space pass the same number for orig/num_bytes
arguments. Let's remove one of the numbers and also modify the trace point 
to show only a single number - bytes requested. 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c       | 18 ++++++++----------
 include/trace/events/btrfs.h | 13 +++++--------
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 98afc32aacb3..f4db6534e25e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4910,7 +4910,7 @@ struct reserve_ticket {
 
 static int flush_space(struct btrfs_fs_info *fs_info,
 		       struct btrfs_space_info *space_info, u64 num_bytes,
-		       u64 orig_bytes, int state)
+		       int state)
 {
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_trans_handle *trans;
@@ -4935,7 +4935,7 @@ static int flush_space(struct btrfs_fs_info *fs_info,
 		break;
 	case FLUSH_DELALLOC:
 	case FLUSH_DELALLOC_WAIT:
-		shrink_delalloc(fs_info, num_bytes * 2, orig_bytes,
+		shrink_delalloc(fs_info, num_bytes * 2, num_bytes,
 				state == FLUSH_DELALLOC_WAIT);
 		break;
 	case ALLOC_CHUNK:
@@ -4953,15 +4953,15 @@ static int flush_space(struct btrfs_fs_info *fs_info,
 		break;
 	case COMMIT_TRANS:
 		ret = may_commit_transaction(fs_info, space_info,
-					     orig_bytes, 0);
+					     num_bytes, 0);
 		break;
 	default:
 		ret = -ENOSPC;
 		break;
 	}
 
-	trace_btrfs_flush_space(fs_info, space_info->flags, num_bytes,
-				orig_bytes, state, ret);
+	trace_btrfs_flush_space(fs_info, space_info->flags, num_bytes, state,
+				ret);
 	return ret;
 }
 
@@ -5067,8 +5067,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		struct reserve_ticket *ticket;
 		int ret;
 
-		ret = flush_space(fs_info, space_info, to_reclaim, to_reclaim,
-				  flush_state);
+		ret = flush_space(fs_info, space_info, to_reclaim, flush_state);
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets)) {
 			space_info->flush = 0;
@@ -5124,8 +5123,7 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	spin_unlock(&space_info->lock);
 
 	do {
-		flush_space(fs_info, space_info, to_reclaim, to_reclaim,
-			    flush_state);
+		flush_space(fs_info, space_info, to_reclaim, flush_state);
 		flush_state++;
 		spin_lock(&space_info->lock);
 		if (ticket->bytes == 0) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index cd99a3658156..0118f265c776 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1005,15 +1005,14 @@ TRACE_EVENT(btrfs_trigger_flush,
 TRACE_EVENT(btrfs_flush_space,
 
 	TP_PROTO(struct btrfs_fs_info *fs_info, u64 flags, u64 num_bytes,
-		 u64 orig_bytes, int state, int ret),
+		 int state, int ret),
 
-	TP_ARGS(fs_info, flags, num_bytes, orig_bytes, state, ret),
+	TP_ARGS(fs_info, flags, num_bytes, state, ret),
 
 	TP_STRUCT__entry(
 		__array(	u8,	fsid,	BTRFS_UUID_SIZE	)
 		__field(	u64,	flags			)
 		__field(	u64,	num_bytes		)
-		__field(	u64,	orig_bytes		)
 		__field(	int,	state			)
 		__field(	int,	ret			)
 	),
@@ -1022,19 +1021,17 @@ TRACE_EVENT(btrfs_flush_space,
 		memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE);
 		__entry->flags		=	flags;
 		__entry->num_bytes	=	num_bytes;
-		__entry->orig_bytes	=	orig_bytes;
 		__entry->state		=	state;
 		__entry->ret		=	ret;
 	),
 
-	TP_printk("%pU: state=%d(%s) flags=%llu(%s) num_bytes=%llu "
-		  "orig_bytes=%llu ret=%d", __entry->fsid, __entry->state,
+	TP_printk("%pU: state=%d(%s) flags=%llu(%s) num_bytes=%llu ret=%d",
+		  __entry->fsid, __entry->state,
 		  show_flush_state(__entry->state),
 		  (unsigned long long)__entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
 				BTRFS_GROUP_FLAGS),
-		  (unsigned long long)__entry->num_bytes,
-		  (unsigned long long)__entry->orig_bytes, __entry->ret)
+		  (unsigned long long)__entry->num_bytes, __entry->ret)
 );
 
 DECLARE_EVENT_CLASS(btrfs__reserved_extent,
-- 
2.7.4

