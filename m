Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48955 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754134AbeFTMt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:29 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1C10CAF55
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:28 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 26/34] btrfs: Remove fs_info from free_excluded_extents
Date: Wed, 20 Jun 2018 15:49:08 +0300
Message-Id: <1529498956-4241-27-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed block group

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 57884cd72225..196fd467cfac 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -217,9 +217,9 @@ static int add_excluded_extent(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static void free_excluded_extents(struct btrfs_fs_info *fs_info,
-				  struct btrfs_block_group_cache *cache)
+static void free_excluded_extents(struct btrfs_block_group_cache *cache)
 {
+	struct btrfs_fs_info *fs_info = cache->fs_info;
 	u64 start, end;
 
 	start = cache->key.objectid;
@@ -555,7 +555,7 @@ static noinline void caching_thread(struct btrfs_work *work)
 	caching_ctl->progress = (u64)-1;
 
 	up_read(&fs_info->commit_root_sem);
-	free_excluded_extents(fs_info, block_group);
+	free_excluded_extents(block_group);
 	mutex_unlock(&caching_ctl->mutex);
 
 	wake_up(&caching_ctl->wait);
@@ -663,7 +663,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 		wake_up(&caching_ctl->wait);
 		if (ret == 1) {
 			put_caching_control(caching_ctl);
-			free_excluded_extents(fs_info, cache);
+			free_excluded_extents(cache);
 			return 0;
 		}
 	} else {
@@ -9826,7 +9826,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		 */
 		if (block_group->cached == BTRFS_CACHE_NO ||
 		    block_group->cached == BTRFS_CACHE_ERROR)
-			free_excluded_extents(info, block_group);
+			free_excluded_extents(block_group);
 
 		btrfs_remove_free_space_cache(block_group);
 		ASSERT(block_group->cached != BTRFS_CACHE_STARTED);
@@ -10074,7 +10074,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 			 * We may have excluded something, so call this just in
 			 * case.
 			 */
-			free_excluded_extents(info, cache);
+			free_excluded_extents(cache);
 			btrfs_put_block_group(cache);
 			goto error;
 		}
@@ -10089,14 +10089,14 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		if (found_key.offset == btrfs_block_group_used(&cache->item)) {
 			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
-			free_excluded_extents(info, cache);
+			free_excluded_extents(cache);
 		} else if (btrfs_block_group_used(&cache->item) == 0) {
 			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
 			add_new_free_space(cache, found_key.objectid,
 					   found_key.objectid +
 					   found_key.offset);
-			free_excluded_extents(info, cache);
+			free_excluded_extents(cache);
 		}
 
 		ret = btrfs_add_block_group_cache(info, cache);
@@ -10225,14 +10225,14 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 		 * We may have excluded something, so call this just in
 		 * case.
 		 */
-		free_excluded_extents(fs_info, cache);
+		free_excluded_extents(cache);
 		btrfs_put_block_group(cache);
 		return ret;
 	}
 
 	add_new_free_space(cache, chunk_offset, chunk_offset + size);
 
-	free_excluded_extents(fs_info, cache);
+	free_excluded_extents(cache);
 
 #ifdef CONFIG_BTRFS_DEBUG
 	if (btrfs_should_fragment_free_space(cache)) {
@@ -10316,7 +10316,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	 * Free the reserved super bytes from this block group before
 	 * remove it.
 	 */
-	free_excluded_extents(fs_info, block_group);
+	free_excluded_extents(block_group);
 	btrfs_free_ref_tree_range(fs_info, block_group->key.objectid,
 				  block_group->key.offset);
 
-- 
2.7.4

