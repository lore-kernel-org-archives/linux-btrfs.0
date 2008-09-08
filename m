From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH 3/4] add reserved extents accounting
Date: Tue, 09 Sep 2008 02:47:56 +0800
Message-ID: <48C5735C.3040400@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	yanzheng@21cn.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch adds reserved extents accounting. This helps the allocator
choose block group that free extents are allocated from.

Regards
Yan Zheng

---
diff -r b5babeda93fa ctree.h
--- a/ctree.h	Tue Sep 09 02:16:12 2008 +0800
+++ b/ctree.h	Tue Sep 09 02:16:20 2008 +0800
@@ -499,6 +499,7 @@
 	u64 total_bytes;
 	u64 bytes_used;
 	u64 bytes_pinned;
+	u64 bytes_reserved;
 	int full;
 	int force_alloc;
 	struct list_head list;
@@ -510,6 +511,7 @@
 	struct btrfs_space_info *space_info;
 	spinlock_t lock;
 	u64 pinned;
+	u64 reserved;
 	u64 flags;
 	int cached;
 	int ro;
diff -r b5babeda93fa extent-tree.c
--- a/extent-tree.c	Tue Sep 09 02:16:12 2008 +0800
+++ b/extent-tree.c	Tue Sep 09 02:16:20 2008 +0800
@@ -374,7 +374,6 @@
 	u64 last = 0;
 	u64 start;
 	u64 end;
-	u64 free_check;
 	u64 ptr;
 	int bit;
 	int ret;
@@ -385,7 +384,7 @@
 	block_group_cache = &info->block_group_cache;
 
 	if (data & BTRFS_BLOCK_GROUP_METADATA)
-		factor = 9;
+		factor = 8;
 
 	bit = block_group_state_bits(data);
 
@@ -395,7 +394,7 @@
 		if (shint && block_group_bits(shint, data) && !shint->ro) {
 			spin_lock(&shint->lock);
 			used = btrfs_block_group_used(&shint->item);
-			if (used + shint->pinned <
+			if (used + shint->pinned + shint->reserved <
 			    div_factor(shint->key.offset, factor)) {
 				spin_unlock(&shint->lock);
 				return shint;
@@ -406,7 +405,7 @@
 	if (hint && !hint->ro && block_group_bits(hint, data)) {
 		spin_lock(&hint->lock);
 		used = btrfs_block_group_used(&hint->item);
-		if (used + hint->pinned <
+		if (used + hint->pinned + hint->reserved <
 		    div_factor(hint->key.offset, factor)) {
 			spin_unlock(&hint->lock);
 			return hint;
@@ -438,8 +437,8 @@
 		used = btrfs_block_group_used(&cache->item);
 
 		if (!cache->ro && block_group_bits(cache, data)) {
-			free_check = div_factor(cache->key.offset, factor);
-			if (used + cache->pinned < free_check) {
+			if (used + cache->pinned + cache->reserved <
+			    div_factor(cache->key.offset, factor)) {
 				found_group = cache;
 				spin_unlock(&cache->lock);
 				goto found;
@@ -1325,24 +1324,25 @@
 		if (ret)
 			break;
 
-		last = end + 1;
 		ret = get_state_private(block_group_cache, start, &ptr);
 		if (ret)
 			break;
 		cache = (struct btrfs_block_group_cache *)(unsigned long)ptr;
-		err = write_one_cache_group(trans, root,
-					    path, cache);
+
+		clear_extent_bits(block_group_cache, start, end,
+				  BLOCK_GROUP_DIRTY, GFP_NOFS);
+
+		err = write_one_cache_group(trans, root, path, cache);
 		/*
 		 * if we fail to write the cache group, we want
 		 * to keep it marked dirty in hopes that a later
 		 * write will work
 		 */
 		if (err) {
+			last = end + 1;
 			werr = err;
 			continue;
 		}
-		clear_extent_bits(block_group_cache, start, end,
-				  BLOCK_GROUP_DIRTY, GFP_NOFS);
 	}
 	btrfs_free_path(path);
 	mutex_unlock(&root->fs_info->alloc_mutex);
@@ -1387,6 +1387,7 @@
 	found->total_bytes = total_bytes;
 	found->bytes_used = bytes_used;
 	found->bytes_pinned = 0;
+	found->bytes_reserved = 0;
 	found->full = 0;
 	found->force_alloc = 0;
 	*space_info = found;
@@ -1784,30 +1785,51 @@
 	}
 	while (num > 0) {
 		cache = btrfs_lookup_block_group(fs_info, bytenr);
-		if (!cache) {
-			u64 first = first_logical_byte(root, bytenr);
-			WARN_ON(first < bytenr);
-			len = min(first - bytenr, num);
-		} else {
-			len = min(num, cache->key.offset -
-				  (bytenr - cache->key.objectid));
-		}
+		BUG_ON(!cache);
+		len = min(num, cache->key.offset -
+			  (bytenr - cache->key.objectid));
 		if (pin) {
-			if (cache) {
-				spin_lock(&cache->lock);
-				cache->pinned += len;
-				cache->space_info->bytes_pinned += len;
-				spin_unlock(&cache->lock);
-			}
+			spin_lock(&cache->lock);
+			cache->pinned += len;
+			cache->space_info->bytes_pinned += len;
+			spin_unlock(&cache->lock);
 			fs_info->total_pinned += len;
 		} else {
-			if (cache) {
-				spin_lock(&cache->lock);
-				cache->pinned -= len;
-				cache->space_info->bytes_pinned -= len;
-				spin_unlock(&cache->lock);
-			}
+			spin_lock(&cache->lock);
+			cache->pinned -= len;
+			cache->space_info->bytes_pinned -= len;
+			spin_unlock(&cache->lock);
 			fs_info->total_pinned -= len;
+		}
+		bytenr += len;
+		num -= len;
+	}
+	return 0;
+}
+
+static int update_reserved_extents(struct btrfs_root *root,
+				   u64 bytenr, u64 num, int reserve)
+{
+	u64 len;
+	struct btrfs_block_group_cache *cache;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
+	while (num > 0) {
+		cache = btrfs_lookup_block_group(fs_info, bytenr);
+		BUG_ON(!cache);
+		len = min(num, cache->key.offset -
+			  (bytenr - cache->key.objectid));
+		if (reserve) {
+			spin_lock(&cache->lock);
+			cache->reserved += len;
+			cache->space_info->bytes_reserved += len;
+			spin_unlock(&cache->lock);
+		} else {
+			spin_lock(&cache->lock);
+			cache->reserved -= len;
+			cache->space_info->bytes_reserved -= len;
+			spin_unlock(&cache->lock);
 		}
 		bytenr += len;
 		num -= len;
@@ -2518,6 +2540,7 @@
 	maybe_lock_mutex(root);
 	set_extent_dirty(&root->fs_info->free_space_cache,
 			 start, start + len - 1, GFP_NOFS);
+	update_reserved_extents(root, start, len, 0);
 	maybe_unlock_mutex(root);
 	return 0;
 }
@@ -2534,6 +2557,7 @@
 	ret = __btrfs_reserve_extent(trans, root, num_bytes, min_alloc_size,
 				     empty_size, hint_byte, search_end, ins,
 				     data);
+	update_reserved_extents(root, ins->objectid, ins->offset, 1);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -2642,6 +2666,7 @@
 	ret = __btrfs_alloc_reserved_extent(trans, root, parent,
 					    root_objectid, ref_generation,
 					    owner, owner_offset, ins);
+	update_reserved_extents(root, ins->objectid, ins->offset, 0);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -4260,6 +4285,7 @@
 
 	spin_lock(&block_group->lock);
 	WARN_ON(block_group->pinned > 0);
+	WARN_ON(block_group->reserved > 0);
 	WARN_ON(btrfs_block_group_used(&block_group->item) > 0);
 	spin_unlock(&block_group->lock);
 	ret = 0;
