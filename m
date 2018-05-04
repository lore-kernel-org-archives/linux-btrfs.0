Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59175 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750820AbeEDHrc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 03:47:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DA9D5AC7D
        for <linux-btrfs@vger.kernel.org>; Fri,  4 May 2018 07:47:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs-progs: Remove devid parameter from btrfs_rmap_block
Date: Fri,  4 May 2018 10:47:25 +0300
Message-Id: <1525420047-17397-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1525420047-17397-1-git-send-email-nborisov@suse.com>
References: <1525420047-17397-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This parameter was introduced with the original implementation of the
function but has never really been used, so just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c  |  2 +-
 extent-tree.c | 10 +++++-----
 volumes.c     |  7 ++-----
 volumes.h     |  4 ++--
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/check/main.c b/check/main.c
index c4a1801fb0ef..a2b91df05569 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5147,7 +5147,7 @@ static int check_cache_range(struct btrfs_root *root,
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		ret = btrfs_rmap_block(root->fs_info,
-				       cache->key.objectid, bytenr, 0,
+				       cache->key.objectid, bytenr,
 				       &logical, &nr, &stripe_len);
 		if (ret)
 			return ret;
diff --git a/extent-tree.c b/extent-tree.c
index 391f0a784710..1b8a4f8cb1c3 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -75,7 +75,7 @@ static int remove_sb_from_cache(struct btrfs_root *root,
 	free_space_cache = &fs_info->free_space_cache;
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = btrfs_rmap_block(fs_info, cache->key.objectid, bytenr, 0,
+		ret = btrfs_rmap_block(fs_info, cache->key.objectid, bytenr,
 				       &logical, &nr, &stripe_len);
 		BUG_ON(ret);
 		while (nr--) {
@@ -699,7 +699,7 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 		if (key.objectid != bytenr ||
 		    key.type != BTRFS_EXTENT_DATA_REF_KEY)
 			goto fail;
-		
+
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_data_ref);
 
@@ -1403,7 +1403,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		err = ret;
 		goto out;
 	}
-	
+
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, item);
@@ -1666,7 +1666,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
 			if (bytenr == 0)
 				continue;
-			
+
 			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
 			key.offset -= btrfs_file_extent_offset(buf, fi);
 			ret = process_func(trans, root, bytenr, num_bytes,
@@ -4132,7 +4132,7 @@ int exclude_super_stripes(struct btrfs_root *root,
 		bytenr = btrfs_sb_offset(i);
 		ret = btrfs_rmap_block(root->fs_info,
 				       cache->key.objectid, bytenr,
-				       0, &logical, &nr, &stripe_len);
+				       &logical, &nr, &stripe_len);
 		if (ret)
 			return ret;
 
diff --git a/volumes.c b/volumes.c
index c6e34321ff24..ad3016dcdb20 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1364,9 +1364,8 @@ int btrfs_next_bg(struct btrfs_fs_info *fs_info, u64 *logical,
 	return -ENOENT;
 }
 
-int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
-		     u64 chunk_start, u64 physical, u64 devid,
-		     u64 **logical, int *naddrs, int *stripe_len)
+int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
+		     u64 physical, u64 **logical, int *naddrs, int *stripe_len)
 {
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct cache_extent *ce;
@@ -1397,8 +1396,6 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 	buf = kzalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
 
 	for (i = 0; i < map->num_stripes; i++) {
-		if (devid && map->stripes[i].dev->devid != devid)
-			continue;
 		if (map->stripes[i].physical > physical ||
 		    map->stripes[i].physical + length <= physical)
 			continue;
diff --git a/volumes.h b/volumes.h
index 5bcaae7f03d2..b4ea93f0bec3 100644
--- a/volumes.h
+++ b/volumes.h
@@ -254,8 +254,8 @@ static inline int btrfs_next_bg_system(struct btrfs_fs_info *fs_info,
 			BTRFS_BLOCK_GROUP_SYSTEM);
 }
 int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
-		     u64 chunk_start, u64 physical, u64 devid,
-		     u64 **logical, int *naddrs, int *stripe_len);
+		     u64 chunk_start, u64 physical, u64 **logical,
+		     int *naddrs, int *stripe_len);
 int btrfs_read_sys_array(struct btrfs_fs_info *fs_info);
 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-- 
2.7.4

