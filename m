Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39212 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753256AbeDZJR1 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 26 Apr 2018 05:17:27 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: trace: Add trace points for unused block groups
Date: Thu, 26 Apr 2018 17:17:20 +0800
Message-Id: <20180426091720.24185-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch will add the following trace events:
1) btrfs_remove_block_group
   For btrfs_remove_block_group() function.
   Triggered when a block group is really removed.

2) btrfs_add_unused_block_group
   Triggered which block group is added to unused_bgs list.

3) btrfs_skip_unused_block_group
   Triggered which unused block group is not deleted.

These trace events is pretty handy to debug case related to block group
auto remove.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c       |  4 ++++
 fs/btrfs/scrub.c             |  1 +
 include/trace/events/btrfs.h | 41 ++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bf30be868f7a..5a0c7fcf01fb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6352,6 +6352,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			spin_lock(&info->unused_bgs_lock);
 			if (list_empty(&cache->bg_list)) {
 				btrfs_get_block_group(cache);
+				trace_btrfs_add_unused_block_group(cache);
 				list_add_tail(&cache->bg_list,
 					      &info->unused_bgs);
 			}
@@ -10206,6 +10207,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 			/* Should always be true but just in case. */
 			if (list_empty(&cache->bg_list)) {
 				btrfs_get_block_group(cache);
+				trace_btrfs_add_unused_block_group(cache);
 				list_add_tail(&cache->bg_list,
 					      &info->unused_bgs);
 			}
@@ -10393,6 +10395,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	BUG_ON(!block_group);
 	BUG_ON(!block_group->ro);
 
+	trace_btrfs_remove_block_group(block_group);
 	/*
 	 * Free the reserved super bytes from this block group before
 	 * remove it.
@@ -10757,6 +10760,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 			 * the ro check in case balance is currently acting on
 			 * this block group.
 			 */
+			trace_btrfs_skip_unused_block_group(block_group);
 			spin_unlock(&block_group->lock);
 			up_write(&space_info->groups_sem);
 			goto next;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 52b39a0924e9..a59005862010 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3984,6 +3984,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			spin_lock(&fs_info->unused_bgs_lock);
 			if (list_empty(&cache->bg_list)) {
 				btrfs_get_block_group(cache);
+				trace_btrfs_add_unused_block_group(cache);
 				list_add_tail(&cache->bg_list,
 					      &fs_info->unused_bgs);
 			}
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 5af2479e9b16..38f444bf55fe 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1805,6 +1805,47 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
 			__entry->ino, __entry->mod)
 );
 
+DECLARE_EVENT_CLASS(btrfs__block_group,
+	TP_PROTO(const struct btrfs_block_group_cache *bg_cache),
+
+	TP_ARGS(bg_cache),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	bytenr		)
+		__field(	u64,	flags		)
+		__field(	u64,	len		)
+		__field(	u64,	used		)
+	),
+
+	TP_fast_assign_btrfs(bg_cache->fs_info,
+		__entry->bytenr = bg_cache->key.objectid,
+		__entry->len	= bg_cache->key.offset,
+		__entry->flags	= bg_cache->flags;
+		__entry->used	= btrfs_block_group_used(&bg_cache->item);
+	),
+
+	TP_printk_btrfs("bg bytenr=%llu len=%llu used=%llu flags=%llu(%s)",
+		__entry->bytenr, __entry->len, __entry->used, __entry->flags,
+		__print_flags(__entry->flags, "|", BTRFS_GROUP_FLAGS))
+);
+
+DEFINE_EVENT(btrfs__block_group, btrfs_remove_block_group,
+	TP_PROTO(const struct btrfs_block_group_cache *bg_cache),
+
+	TP_ARGS(bg_cache)
+);
+
+DEFINE_EVENT(btrfs__block_group, btrfs_add_unused_block_group,
+	TP_PROTO(const struct btrfs_block_group_cache *bg_cache),
+
+	TP_ARGS(bg_cache)
+);
+
+DEFINE_EVENT(btrfs__block_group, btrfs_skip_unused_block_group,
+	TP_PROTO(const struct btrfs_block_group_cache *bg_cache),
+
+	TP_ARGS(bg_cache)
+);
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.17.0

