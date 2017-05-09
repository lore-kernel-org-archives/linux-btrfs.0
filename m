Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52735 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751652AbdEIIe3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 04:34:29 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, jeffm@suse.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Refactor update_space_info
Date: Tue,  9 May 2017 11:34:19 +0300
Message-Id: <1494318859-7555-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1494318859-7555-1-git-send-email-nborisov@suse.com>
References: <1494318859-7555-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Following the factoring out of the creation code udpate_space_info can only
be called for already-existing space_info structs. As such it cannot fail.
Remove superfulous error handling and make the function return void.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 53 ++++++++++++++------------------------------------
 1 file changed, 15 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e71921d8c610..3ab1f88af038 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3958,7 +3958,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags,
 	return ret;
 }
 
-static int update_space_info(struct btrfs_fs_info *info, u64 flags,
+static void update_space_info(struct btrfs_fs_info *info, u64 flags,
 			     u64 total_bytes, u64 bytes_used,
 			     u64 bytes_readonly,
 			     struct btrfs_space_info **space_info)
@@ -3973,21 +3973,18 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 		factor = 1;
 
 	found = __find_space_info(info, flags);
-	if (found) {
-		spin_lock(&found->lock);
-		found->total_bytes += total_bytes;
-		found->disk_total += total_bytes * factor;
-		found->bytes_used += bytes_used;
-		found->disk_used += bytes_used * factor;
-		found->bytes_readonly += bytes_readonly;
-		if (total_bytes > 0)
-			found->full = 0;
-		space_info_add_new_bytes(info, found, total_bytes -
-					 bytes_used - bytes_readonly);
-		spin_unlock(&found->lock);
-		*space_info = found;
-		return 0;
-	}
+	spin_lock(&found->lock);
+	found->total_bytes += total_bytes;
+	found->disk_total += total_bytes * factor;
+	found->bytes_used += bytes_used;
+	found->disk_used += bytes_used * factor;
+	found->bytes_readonly += bytes_readonly;
+	if (total_bytes > 0)
+		found->full = 0;
+	space_info_add_new_bytes(info, found, total_bytes -
+				 bytes_used - bytes_readonly);
+	spin_unlock(&found->lock);
+	*space_info = found;
 }
 
 static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
@@ -10041,19 +10038,9 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		}
 
 		trace_btrfs_add_block_group(info, cache, 0);
-		ret = update_space_info(info, cache->flags, found_key.offset,
+		update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
 					cache->bytes_super, &space_info);
-		if (ret) {
-			btrfs_remove_free_space_cache(cache);
-			spin_lock(&info->block_group_cache_lock);
-			rb_erase(&cache->cache_node,
-				 &info->block_group_cache_tree);
-			RB_CLEAR_NODE(&cache->cache_node);
-			spin_unlock(&info->block_group_cache_lock);
-			btrfs_put_block_group(cache);
-			goto error;
-		}
 
 		cache->space_info = space_info;
 
@@ -10212,18 +10199,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	 * the rbtree, update the space info's counters.
 	 */
 	trace_btrfs_add_block_group(fs_info, cache, 1);
-	ret = update_space_info(fs_info, cache->flags, size, bytes_used,
+	update_space_info(fs_info, cache->flags, size, bytes_used,
 				cache->bytes_super, &cache->space_info);
-	if (ret) {
-		btrfs_remove_free_space_cache(cache);
-		spin_lock(&fs_info->block_group_cache_lock);
-		rb_erase(&cache->cache_node,
-			 &fs_info->block_group_cache_tree);
-		RB_CLEAR_NODE(&cache->cache_node);
-		spin_unlock(&fs_info->block_group_cache_lock);
-		btrfs_put_block_group(cache);
-		return ret;
-	}
 	update_global_block_rsv(fs_info);
 
 	__link_block_group(cache->space_info, cache);
-- 
2.7.4

