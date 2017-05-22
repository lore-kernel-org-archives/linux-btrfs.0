Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43711 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751030AbdEVGfy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 02:35:54 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 126BEABF0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 06:35:53 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 2/2] btrfs: Refactor update_space_info
Date: Mon, 22 May 2017 09:35:50 +0300
Message-Id: <1495434950-20674-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1495434950-20674-1-git-send-email-nborisov@suse.com>
References: <1495434950-20674-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Following the factoring out of the creation code udpate_space_info can only
be called for already-existing space_info structs. As such it cannot fail.
Remove superfulous error handling and make the function return void.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Jeff Mahoney <jeffm@suse.com>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 58 ++++++++++++++++----------------------------------
 1 file changed, 18 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 362e83e280fa..c827c97f3058 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3960,7 +3960,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags,
 	return ret;
 }
 
-static int update_space_info(struct btrfs_fs_info *info, u64 flags,
+static void update_space_info(struct btrfs_fs_info *info, u64 flags,
 			     u64 total_bytes, u64 bytes_used,
 			     u64 bytes_readonly,
 			     struct btrfs_space_info **space_info)
@@ -3975,21 +3975,19 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
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
+	ASSERT(found);
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
@@ -10044,19 +10042,9 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		}
 
 		trace_btrfs_add_block_group(info, cache, 0);
-		ret = update_space_info(info, cache->flags, found_key.offset,
-					btrfs_block_group_used(&cache->item),
-					cache->bytes_super, &space_info);
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
+		update_space_info(info, cache->flags, found_key.offset,
+				  btrfs_block_group_used(&cache->item),
+				  cache->bytes_super, &space_info);
 
 		cache->space_info = space_info;
 
@@ -10215,18 +10203,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
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

