Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20144 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932656AbcJLJKd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 05:10:33 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com
Subject: [PATCH 1/2] btrfs: introduce priority based delalloc shrink mechanism
Date: Wed, 12 Oct 2016 17:03:48 +0800
Message-Id: <1476263029-11879-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit b02441999efcc6152b87cd58e7970bb7843f76cf, we don't wait all
ordered extents, but I run into some enospc errors when doing large file
create and delete tests, it's because shrink_delalloc() does not write
enough delalloc bytes and wait them finished:
    From: Miao Xie <miaox@cn.fujitsu.com>
    Date: Mon, 4 Nov 2013 23:13:25 +0800
    Subject: [PATCH] Btrfs: don't wait for the completion of all the ordered extents

    It is very likely that there are lots of ordered extents in the filesytem,
    if we wait for the completion of all of them when we want to reclaim some
    space for the metadata space reservation, we would be blocked for a long
    time. The performance would drop down suddenly for a long time.

Here we introduce a simple reclaim_priority variable, the higher the
value, the higher the priority, 0 is the minimum priority. The core
idea is:
        if (reclaim_priority >= 3)
                to_reclaim = percpu_counter_sum_positive(&root->fs_info->delalloc_bytes);
        else
                to_reclaim = orig * (2 << (reclaim_priority + 1));
As the priority increases, we try wo write more delalloc bytes, here orig
is the number of metadata we want to reserve. Meanwhile if
"reclaim_priority >= 3" returns true, we'll also wait all current ordered
extents to finish.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c       | 49 ++++++++++++++++++++++++++++----------------
 include/trace/events/btrfs.h | 11 ++++------
 2 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 665da8f..661f039 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4690,12 +4690,13 @@ static inline int calc_reclaim_items_nr(struct btrfs_root *root, u64 to_reclaim)
 /*
  * shrink metadata reservation for delalloc
  */
-static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
-			    bool wait_ordered)
+static void shrink_delalloc(struct btrfs_root *root, u64 orig,
+			    bool wait_ordered, int reclaim_priority)
 {
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_space_info *space_info;
 	struct btrfs_trans_handle *trans;
+	u64 to_reclaim;
 	u64 delalloc_bytes;
 	u64 max_reclaim;
 	long time_left;
@@ -4703,22 +4704,35 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	int loops;
 	int items;
 	enum btrfs_reserve_flush_enum flush;
+	int items_to_wait;
+
+	if (reclaim_priority < 0)
+		reclaim_priority = 0;
+
+	delalloc_bytes = percpu_counter_sum_positive(
+				&root->fs_info->delalloc_bytes);
+	if (reclaim_priority >= 3)
+		to_reclaim = delalloc_bytes;
+	else
+		to_reclaim = orig * (2 << (reclaim_priority + 1));
 
 	/* Calc the number of the pages we need flush for space reservation */
 	items = calc_reclaim_items_nr(root, to_reclaim);
 	to_reclaim = (u64)items * EXTENT_SIZE_PER_ITEM;
+	if (reclaim_priority >= 3)
+		items_to_wait = -1;
+	else
+		items_to_wait = items;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	block_rsv = &root->fs_info->delalloc_block_rsv;
 	space_info = block_rsv->space_info;
 
-	delalloc_bytes = percpu_counter_sum_positive(
-						&root->fs_info->delalloc_bytes);
 	if (delalloc_bytes == 0) {
 		if (trans)
 			return;
 		if (wait_ordered)
-			btrfs_wait_ordered_roots(root->fs_info, items,
+			btrfs_wait_ordered_roots(root->fs_info, items_to_wait,
 						 0, (u64)-1);
 		return;
 	}
@@ -4763,7 +4777,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 
 		loops++;
 		if (wait_ordered && !trans) {
-			btrfs_wait_ordered_roots(root->fs_info, items,
+			btrfs_wait_ordered_roots(root->fs_info, items_to_wait,
 						 0, (u64)-1);
 		} else {
 			time_left = schedule_timeout_killable(1);
@@ -4836,7 +4850,7 @@ struct reserve_ticket {
 
 static int flush_space(struct btrfs_root *root,
 		       struct btrfs_space_info *space_info, u64 num_bytes,
-		       u64 orig_bytes, int state)
+		       int state, int reclaim_priority)
 {
 	struct btrfs_trans_handle *trans;
 	int nr;
@@ -4860,8 +4874,8 @@ static int flush_space(struct btrfs_root *root,
 		break;
 	case FLUSH_DELALLOC:
 	case FLUSH_DELALLOC_WAIT:
-		shrink_delalloc(root, num_bytes * 2, orig_bytes,
-				state == FLUSH_DELALLOC_WAIT);
+		shrink_delalloc(root, num_bytes, state == FLUSH_DELALLOC_WAIT,
+				reclaim_priority);
 		break;
 	case ALLOC_CHUNK:
 		trans = btrfs_join_transaction(root);
@@ -4877,7 +4891,7 @@ static int flush_space(struct btrfs_root *root,
 			ret = 0;
 		break;
 	case COMMIT_TRANS:
-		ret = may_commit_transaction(root, space_info, orig_bytes, 0);
+		ret = may_commit_transaction(root, space_info, num_bytes, 0);
 		break;
 	default:
 		ret = -ENOSPC;
@@ -4885,7 +4899,7 @@ static int flush_space(struct btrfs_root *root,
 	}
 
 	trace_btrfs_flush_space(root->fs_info, space_info->flags, num_bytes,
-				orig_bytes, state, ret);
+				state, ret);
 	return ret;
 }
 
@@ -4967,7 +4981,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 	struct btrfs_space_info *space_info;
 	u64 to_reclaim;
 	int flush_state;
-	int commit_cycles = 0;
+	int reclaim_priority = 0;
 	u64 last_tickets_id;
 
 	fs_info = container_of(work, struct btrfs_fs_info, async_reclaim_work);
@@ -4990,7 +5004,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		int ret;
 
 		ret = flush_space(fs_info->fs_root, space_info, to_reclaim,
-			    to_reclaim, flush_state);
+				  flush_state, reclaim_priority);
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets)) {
 			space_info->flush = 0;
@@ -5006,13 +5020,12 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		} else {
 			last_tickets_id = space_info->tickets_id;
 			flush_state = FLUSH_DELAYED_ITEMS_NR;
-			if (commit_cycles)
-				commit_cycles--;
+			reclaim_priority = 0;
 		}
 
 		if (flush_state > COMMIT_TRANS) {
-			commit_cycles++;
-			if (commit_cycles > 2) {
+			reclaim_priority++;
+			if (reclaim_priority > 3) {
 				wake_all_tickets(&space_info->tickets);
 				space_info->flush = 0;
 			} else {
@@ -5046,7 +5059,7 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 
 	do {
 		flush_space(fs_info->fs_root, space_info, to_reclaim,
-			    to_reclaim, flush_state);
+			    flush_state, 1);
 		flush_state++;
 		spin_lock(&space_info->lock);
 		if (ticket->bytes == 0) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e030d6f..7d953a6 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -857,15 +857,14 @@ TRACE_EVENT(btrfs_trigger_flush,
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
@@ -874,19 +873,17 @@ TRACE_EVENT(btrfs_flush_space,
 		memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE);
 		__entry->flags		=	flags;
 		__entry->num_bytes	=	num_bytes;
-		__entry->orig_bytes	=	orig_bytes;
 		__entry->state		=	state;
 		__entry->ret		=	ret;
 	),
 
 	TP_printk("%pU: state = %d(%s), flags = %llu(%s), num_bytes = %llu, "
-		  "orig_bytes = %llu, ret = %d", __entry->fsid, __entry->state,
+		  "ret = %d", __entry->fsid, __entry->state,
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



