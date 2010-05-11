From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 4/5] btrfs: don't cache empty block groups during mount
Date: Tue, 11 May 2010 16:25:46 +0800
Message-ID: <4BE9148A.9090709@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

the tree log recover code expects no free space cached before it executes.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 4/fs/btrfs/extent-tree.c 8/fs/btrfs/extent-tree.c
--- 4/fs/btrfs/extent-tree.c	2010-05-11 14:15:29.174108554 +0800
+++ 8/fs/btrfs/extent-tree.c	2010-05-11 13:26:38.036107000 +0800
@@ -316,11 +329,6 @@ static int caching_kthread(void *data)
 	if (!path)
 		return -ENOMEM;
 
-	exclude_super_stripes(extent_root, block_group);
-	spin_lock(&block_group->space_info->lock);
-	block_group->space_info->bytes_super += block_group->bytes_super;
-	spin_unlock(&block_group->space_info->lock);
-
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 
 	/*
@@ -7499,6 +7541,7 @@ int btrfs_free_block_groups(struct btrfs
 		if (block_group->cached == BTRFS_CACHE_STARTED)
 			wait_block_group_cache_done(block_group);
 
+		free_excluded_extents(info->extent_root, block_group);
 		btrfs_remove_free_space_cache(block_group);
 		btrfs_put_block_group(block_group);
 
@@ -7586,26 +7629,12 @@ int btrfs_read_block_groups(struct btrfs
 		cache->flags = btrfs_block_group_flags(&cache->item);
 		cache->sectorsize = root->sectorsize;
 
-		/*
-		 * check for two cases, either we are full, and therefore
-		 * don't need to bother with the caching work since we won't
-		 * find any space, or we are empty, and we can just add all
-		 * the space in and be done with it.  This saves us _alot_ of
-		 * time, particularly in the full case.
-		 */
-		if (found_key.offset == btrfs_block_group_used(&cache->item)) {
-			exclude_super_stripes(root, cache);
-			cache->last_byte_to_unpin = (u64)-1;
-			cache->cached = BTRFS_CACHE_FINISHED;
-			free_excluded_extents(root, cache);
-		} else if (btrfs_block_group_used(&cache->item) == 0) {
-			exclude_super_stripes(root, cache);
+		exclude_super_stripes(root, cache);
+		/* check for the case that block group is full */
+		if (found_key.offset == cache->bytes_super +
+		    btrfs_block_group_used(&cache->item)) {
 			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
-			add_new_free_space(cache, root->fs_info,
-					   found_key.objectid,
-					   found_key.objectid +
-					   found_key.offset);
 			free_excluded_extents(root, cache);
 		}
 
