Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425269AbeE1PyS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:54:18 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE71AAE55
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 15:54:15 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: trace: Add trace points for unused block groups
Date: Mon, 28 May 2018 17:20:07 +0800
Message-Id: <20180528092009.32562-2-wqu@suse.com>
In-Reply-To: <20180528092009.32562-1-wqu@suse.com>
References: <20180528092009.32562-1-wqu@suse.com>
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
 include/trace/events/btrfs.h | 42 ++++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 51b5e2da708c..8241de81089a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6354,6 +6354,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			spin_lock(&info->unused_bgs_lock);
 			if (list_empty(&cache->bg_list)) {
 				btrfs_get_block_group(cache);
+				trace_btrfs_add_unused_block_group(cache);
 				list_add_tail(&cache->bg_list,
 					      &info->unused_bgs);
 			}
@@ -10204,6 +10205,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 			/* Should always be true but just in case. */
 			if (list_empty(&cache->bg_list)) {
 				btrfs_get_block_group(cache);
+				trace_btrfs_add_unused_block_group(cache);
 				list_add_tail(&cache->bg_list,
 					      &info->unused_bgs);
 			}
@@ -10391,6 +10393,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	BUG_ON(!block_group);
 	BUG_ON(!block_group->ro);
 
+	trace_btrfs_remove_block_group(block_group);
 	/*
 	 * Free the reserved super bytes from this block group before
 	 * remove it.
@@ -10755,6 +10758,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
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
index 965c650a5273..c226bc9a61db 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1810,6 +1810,48 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
 			show_root_type(__entry->root_objectid),
 			(unsigned long long)__entry->ino, __entry->mod)
 );
+
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

