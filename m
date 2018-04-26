Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48091 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbeDZGYj (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 26 Apr 2018 02:24:39 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: trace: Remove unnecessary fs_info parameter for btrfs__reserve_extent event class
Date: Thu, 26 Apr 2018 14:24:25 +0800
Message-Id: <20180426062425.8574-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info can be extracted from btrfs_block_group_cache, and all
btrfs_block_group_cache is created by btrfs_create_block_group_cache()
with fs_info initialized, no need to worry about NULL pointer
dereference.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c       |  8 ++++----
 include/trace/events/btrfs.h | 18 ++++++++----------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 09d6e4544d6e..bf30be868f7a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7664,7 +7664,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			if (offset) {
 				/* we have a block, we're done */
 				spin_unlock(&last_ptr->refill_lock);
-				trace_btrfs_reserve_extent_cluster(fs_info,
+				trace_btrfs_reserve_extent_cluster(
 						used_block_group,
 						search_start, num_bytes);
 				if (used_block_group != block_group) {
@@ -7737,7 +7737,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				if (offset) {
 					/* we found one, proceed */
 					spin_unlock(&last_ptr->refill_lock);
-					trace_btrfs_reserve_extent_cluster(fs_info,
+					trace_btrfs_reserve_extent_cluster(
 						block_group, search_start,
 						num_bytes);
 					goto checks;
@@ -7837,8 +7837,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		ins->objectid = search_start;
 		ins->offset = num_bytes;
 
-		trace_btrfs_reserve_extent(fs_info, block_group,
-					   search_start, num_bytes);
+		trace_btrfs_reserve_extent(block_group, search_start,
+					   num_bytes);
 		btrfs_release_block_group(block_group, delalloc);
 		break;
 loop:
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d78d8ab4bc86..5af2479e9b16 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1146,11 +1146,10 @@ TRACE_EVENT(find_free_extent,
 
 DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 
-	TP_PROTO(const struct btrfs_fs_info *fs_info,
-		 const struct btrfs_block_group_cache *block_group, u64 start,
+	TP_PROTO(const struct btrfs_block_group_cache *block_group, u64 start,
 		 u64 len),
 
-	TP_ARGS(fs_info, block_group, start, len),
+	TP_ARGS(block_group, start, len),
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64,	bg_objectid		)
@@ -1159,7 +1158,7 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 		__field(	u64,	len			)
 	),
 
-	TP_fast_assign_btrfs(fs_info,
+	TP_fast_assign_btrfs(block_group->fs_info,
 		__entry->bg_objectid	= block_group->key.objectid;
 		__entry->flags		= block_group->flags;
 		__entry->start		= start;
@@ -1177,20 +1176,18 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 
 DEFINE_EVENT(btrfs__reserve_extent, btrfs_reserve_extent,
 
-	TP_PROTO(const struct btrfs_fs_info *fs_info,
-		 const struct btrfs_block_group_cache *block_group, u64 start,
+	TP_PROTO(const struct btrfs_block_group_cache *block_group, u64 start,
 		 u64 len),
 
-	TP_ARGS(fs_info, block_group, start, len)
+	TP_ARGS(block_group, start, len)
 );
 
 DEFINE_EVENT(btrfs__reserve_extent, btrfs_reserve_extent_cluster,
 
-	TP_PROTO(const struct btrfs_fs_info *fs_info,
-		 const struct btrfs_block_group_cache *block_group, u64 start,
+	TP_PROTO(const struct btrfs_block_group_cache *block_group, u64 start,
 		 u64 len),
 
-	TP_ARGS(fs_info, block_group, start, len)
+	TP_ARGS(block_group, start, len)
 );
 
 TRACE_EVENT(btrfs_find_cluster,
@@ -1807,6 +1804,7 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
 			show_root_type(__entry->root_objectid),
 			__entry->ino, __entry->mod)
 );
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.17.0

