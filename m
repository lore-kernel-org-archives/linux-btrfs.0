Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbeEVH3R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 03:29:17 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 444ACAC43
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 07:29:16 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Use btrfs_add_unused_bgs() to replace open code
Date: Tue, 22 May 2018 15:29:14 +0800
Message-Id: <20180522072914.27301-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a small helper, btrfs_add_unused_bgs(), to accquire needed
locks and add a block group to unused_bgs list.

No functional modification, and only 3 callers are involved.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
This patch should provide the basis for later block group auto-removal
to get more info (mostly transid) to determine should one block group
being removed in current trans.
---
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/extent-tree.c | 35 ++++++++++++++++-------------------
 fs/btrfs/scrub.c       |  9 +--------
 3 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bbb358143ded..701a52034ec6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2827,6 +2827,7 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, const u64 type);
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		       u64 start, u64 end);
+void btrfs_add_unused_bgs(struct btrfs_block_group_cache *bg);
 
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ccf2690f7ca1..484c9d11e5b6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6312,16 +6312,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		 * dirty list to avoid races between cleaner kthread and space
 		 * cache writeout.
 		 */
-		if (!alloc && old_val == 0) {
-			spin_lock(&info->unused_bgs_lock);
-			if (list_empty(&cache->bg_list)) {
-				btrfs_get_block_group(cache);
-				trace_btrfs_add_unused_block_group(cache);
-				list_add_tail(&cache->bg_list,
-					      &info->unused_bgs);
-			}
-			spin_unlock(&info->unused_bgs_lock);
-		}
+		if (!alloc && old_val == 0)
+			btrfs_add_unused_bgs(cache);
 
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
@@ -10144,15 +10136,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		if (btrfs_chunk_readonly(info, cache->key.objectid)) {
 			inc_block_group_ro(cache, 1);
 		} else if (btrfs_block_group_used(&cache->item) == 0) {
-			spin_lock(&info->unused_bgs_lock);
-			/* Should always be true but just in case. */
-			if (list_empty(&cache->bg_list)) {
-				btrfs_get_block_group(cache);
-				trace_btrfs_add_unused_block_group(cache);
-				list_add_tail(&cache->bg_list,
-					      &info->unused_bgs);
-			}
-			spin_unlock(&info->unused_bgs_lock);
+			btrfs_add_unused_bgs(cache);
 		}
 	}
 
@@ -11071,3 +11055,16 @@ void btrfs_wait_for_snapshot_creation(struct btrfs_root *root)
 			       !atomic_read(&root->will_be_snapshotted));
 	}
 }
+
+void btrfs_add_unused_bgs(struct btrfs_block_group_cache *bg)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+
+	spin_lock(&fs_info->unused_bgs_lock);
+	if (list_empty(&bg->bg_list)) {
+		btrfs_get_block_group(bg);
+		trace_btrfs_add_unused_block_group(bg);
+		list_add_tail(&bg->bg_list, &fs_info->unused_bgs);
+	}
+	spin_unlock(&fs_info->unused_bgs_lock);
+}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a59005862010..1044ab2fc71c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3981,14 +3981,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		if (!cache->removed && !cache->ro && cache->reserved == 0 &&
 		    btrfs_block_group_used(&cache->item) == 0) {
 			spin_unlock(&cache->lock);
-			spin_lock(&fs_info->unused_bgs_lock);
-			if (list_empty(&cache->bg_list)) {
-				btrfs_get_block_group(cache);
-				trace_btrfs_add_unused_block_group(cache);
-				list_add_tail(&cache->bg_list,
-					      &fs_info->unused_bgs);
-			}
-			spin_unlock(&fs_info->unused_bgs_lock);
+			btrfs_add_unused_bgs(cache);
 		} else {
 			spin_unlock(&cache->lock);
 		}
-- 
2.17.0

