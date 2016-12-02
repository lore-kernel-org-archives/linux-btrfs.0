Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752400AbcLBFHw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:52 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92259ACE4
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:50 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 15/18] btrfs: convert extent-tree tracepoints to use fs_info
Date: Fri,  2 Dec 2016 00:07:35 -0500
Message-Id: <1480655258-15400-16-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The extent-tree tracepoints all operate on the extent root, regardless of
which root is passed in.  Let's just use the extent root objectid instead.
If it turns out that nobody is depending on the format of this tracepoint,
we can drop the root printing entirely.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c       | 17 ++++++++-------
 include/trace/events/btrfs.h | 49 ++++++++++++++++++++------------------------
 2 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 03512c6..a358aaa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7244,7 +7244,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_add_free_space(cache, buf->start, buf->len);
 		btrfs_free_reserved_bytes(cache, buf->len, 0);
 		btrfs_put_block_group(cache);
-		trace_btrfs_reserved_extent_free(root, buf->start, buf->len);
+		trace_btrfs_reserved_extent_free(fs_info, buf->start, buf->len);
 		pin = 0;
 	}
 out:
@@ -7493,7 +7493,7 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 	ins->objectid = 0;
 	ins->offset = 0;
 
-	trace_find_free_extent(orig_root, num_bytes, empty_size, flags);
+	trace_find_free_extent(fs_info, num_bytes, empty_size, flags);
 
 	space_info = __find_space_info(fs_info, flags);
 	if (!space_info) {
@@ -7652,7 +7652,7 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 			if (offset) {
 				/* we have a block, we're done */
 				spin_unlock(&last_ptr->refill_lock);
-				trace_btrfs_reserve_extent_cluster(root,
+				trace_btrfs_reserve_extent_cluster(fs_info,
 						used_block_group,
 						search_start, num_bytes);
 				if (used_block_group != block_group) {
@@ -7725,7 +7725,7 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 				if (offset) {
 					/* we found one, proceed */
 					spin_unlock(&last_ptr->refill_lock);
-					trace_btrfs_reserve_extent_cluster(root,
+					trace_btrfs_reserve_extent_cluster(fs_info,
 						block_group, search_start,
 						num_bytes);
 					goto checks;
@@ -7823,7 +7823,7 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 		ins->objectid = search_start;
 		ins->offset = num_bytes;
 
-		trace_btrfs_reserve_extent(orig_root, block_group,
+		trace_btrfs_reserve_extent(fs_info, block_group,
 					   search_start, num_bytes);
 		btrfs_release_block_group(block_group, delalloc);
 		break;
@@ -8048,7 +8048,7 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 			ret = btrfs_discard_extent(root, start, len, NULL);
 		btrfs_add_free_space(cache, start, len);
 		btrfs_free_reserved_bytes(cache, len, delalloc);
-		trace_btrfs_reserved_extent_free(root, start, len);
+		trace_btrfs_reserved_extent_free(fs_info, start, len);
 	}
 
 	btrfs_put_block_group(cache);
@@ -8139,8 +8139,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 			ins->objectid, ins->offset);
 		BUG();
 	}
-	trace_btrfs_reserved_extent_alloc(fs_info->extent_root,
-					  ins->objectid, ins->offset);
+	trace_btrfs_reserved_extent_alloc(fs_info, ins->objectid, ins->offset);
 	return ret;
 }
 
@@ -8226,7 +8225,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 		BUG();
 	}
 
-	trace_btrfs_reserved_extent_alloc(root, ins->objectid,
+	trace_btrfs_reserved_extent_alloc(fs_info, ins->objectid,
 					  fs_info->nodesize);
 	return ret;
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index ff5cd17..c14bed4 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -891,65 +891,61 @@ TRACE_EVENT(btrfs_flush_space,
 
 DECLARE_EVENT_CLASS(btrfs__reserved_extent,
 
-	TP_PROTO(struct btrfs_root *root, u64 start, u64 len),
+	TP_PROTO(struct btrfs_fs_info *fs_info, u64 start, u64 len),
 
-	TP_ARGS(root, start, len),
+	TP_ARGS(fs_info, start, len),
 
 	TP_STRUCT__entry_btrfs(
-		__field(	u64,  root_objectid		)
 		__field(	u64,  start			)
 		__field(	u64,  len			)
 	),
 
-	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->root_key.objectid;
+	TP_fast_assign_btrfs(fs_info,
 		__entry->start		= start;
 		__entry->len		= len;
 	),
 
 	TP_printk_btrfs("root = %llu(%s), start = %llu, len = %llu",
-		  show_root_type(__entry->root_objectid),
+		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
 		  (unsigned long long)__entry->start,
 		  (unsigned long long)__entry->len)
 );
 
 DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_alloc,
 
-	TP_PROTO(struct btrfs_root *root, u64 start, u64 len),
+	TP_PROTO(struct btrfs_fs_info *fs_info, u64 start, u64 len),
 
-	TP_ARGS(root, start, len)
+	TP_ARGS(fs_info, start, len)
 );
 
 DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_free,
 
-	TP_PROTO(struct btrfs_root *root, u64 start, u64 len),
+	TP_PROTO(struct btrfs_fs_info *fs_info, u64 start, u64 len),
 
-	TP_ARGS(root, start, len)
+	TP_ARGS(fs_info, start, len)
 );
 
 TRACE_EVENT(find_free_extent,
 
-	TP_PROTO(struct btrfs_root *root, u64 num_bytes, u64 empty_size,
+	TP_PROTO(struct btrfs_fs_info *fs_info, u64 num_bytes, u64 empty_size,
 		 u64 data),
 
-	TP_ARGS(root, num_bytes, empty_size, data),
+	TP_ARGS(fs_info, num_bytes, empty_size, data),
 
 	TP_STRUCT__entry_btrfs(
-		__field(	u64,	root_objectid		)
 		__field(	u64,	num_bytes		)
 		__field(	u64,	empty_size		)
 		__field(	u64,	data			)
 	),
 
-	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->root_key.objectid;
+	TP_fast_assign_btrfs(fs_info,
 		__entry->num_bytes	= num_bytes;
 		__entry->empty_size	= empty_size;
 		__entry->data		= data;
 	),
 
-	TP_printk_btrfs("root = %Lu(%s), len = %Lu, empty_size = %Lu, "
-		  "flags = %Lu(%s)", show_root_type(__entry->root_objectid),
+	TP_printk_btrfs("root = %Lu(%s), len = %Lu, empty_size = %Lu, flags = %Lu(%s)",
+		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
 		  __entry->num_bytes, __entry->empty_size, __entry->data,
 		  __print_flags((unsigned long)__entry->data, "|",
 				 BTRFS_GROUP_FLAGS))
@@ -957,22 +953,20 @@ TRACE_EVENT(find_free_extent,
 
 DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 
-	TP_PROTO(struct btrfs_root *root,
+	TP_PROTO(struct btrfs_fs_info *fs_info,
 		 struct btrfs_block_group_cache *block_group, u64 start,
 		 u64 len),
 
-	TP_ARGS(root, block_group, start, len),
+	TP_ARGS(fs_info, block_group, start, len),
 
 	TP_STRUCT__entry_btrfs(
-		__field(	u64,	root_objectid		)
 		__field(	u64,	bg_objectid		)
 		__field(	u64,	flags			)
 		__field(	u64,	start			)
 		__field(	u64,	len			)
 	),
 
-	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->root_key.objectid;
+	TP_fast_assign_btrfs(fs_info,
 		__entry->bg_objectid	= block_group->key.objectid;
 		__entry->flags		= block_group->flags;
 		__entry->start		= start;
@@ -981,7 +975,8 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 
 	TP_printk_btrfs("root = %Lu(%s), block_group = %Lu, flags = %Lu(%s), "
 		  "start = %Lu, len = %Lu",
-		  show_root_type(__entry->root_objectid), __entry->bg_objectid,
+		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
+		  __entry->bg_objectid,
 		  __entry->flags, __print_flags((unsigned long)__entry->flags,
 						"|", BTRFS_GROUP_FLAGS),
 		  __entry->start, __entry->len)
@@ -989,20 +984,20 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 
 DEFINE_EVENT(btrfs__reserve_extent, btrfs_reserve_extent,
 
-	TP_PROTO(struct btrfs_root *root,
+	TP_PROTO(struct btrfs_fs_info *fs_info,
 		 struct btrfs_block_group_cache *block_group, u64 start,
 		 u64 len),
 
-	TP_ARGS(root, block_group, start, len)
+	TP_ARGS(fs_info, block_group, start, len)
 );
 
 DEFINE_EVENT(btrfs__reserve_extent, btrfs_reserve_extent_cluster,
 
-	TP_PROTO(struct btrfs_root *root,
+	TP_PROTO(struct btrfs_fs_info *fs_info,
 		 struct btrfs_block_group_cache *block_group, u64 start,
 		 u64 len),
 
-	TP_ARGS(root, block_group, start, len)
+	TP_ARGS(fs_info, block_group, start, len)
 );
 
 TRACE_EVENT(btrfs_find_cluster,
-- 
2.7.1

