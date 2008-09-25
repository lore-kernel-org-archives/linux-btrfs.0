From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH 1/4] update the allocator
Date: Thu, 25 Sep 2008 16:50:29 +0800
Message-ID: <48DB50D5.90102@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch updates the allocator for the new space balancing
code. It adds reserved extents accounting, changes a few ENOSPC
check, and makes btrfs_find_block_group not return NULL for
volumes that have been ebalanced.

Regards
Yan Zheng

---
diff -r 4b327f4fcee0 ctree.h
--- a/ctree.h	Tue Sep 23 13:14:14 2008 -0400
+++ b/ctree.h	Thu Sep 25 16:00:18 2008 +0800
@@ -498,6 +498,7 @@
 	u64 total_bytes;
 	u64 bytes_used;
 	u64 bytes_pinned;
+	u64 bytes_reserved;
 	int full;
 	int force_alloc;
 	struct list_head list;
@@ -519,6 +520,7 @@
 	struct btrfs_block_group_item item;
 	spinlock_t lock;
 	u64 pinned;
+	u64 reserved;
 	u64 flags;
 	int cached;
 	int ro;
diff -r 4b327f4fcee0 extent-tree.c
--- a/extent-tree.c	Tue Sep 23 13:14:14 2008 -0400
+++ b/extent-tree.c	Thu Sep 25 16:00:18 2008 +0800
@@ -325,12 +325,9 @@
 	struct btrfs_block_group_cache *cache = *cache_ret;
 	struct btrfs_free_space *info = NULL;
 	u64 last;
-	u64 total_fs_bytes;
 	u64 search_start = *start_ret;
 
 	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
-	total_fs_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
-
 	if (!cache)
 		goto out;
 
@@ -354,7 +351,7 @@
 	last = cache->key.objectid + cache->key.offset;
 
 	cache = btrfs_lookup_first_block_group(root->fs_info, last);
-	if (!cache || cache->key.objectid >= total_fs_bytes)
+	if (!cache)
 		goto out;
 
 	*cache_ret = cache;
@@ -385,7 +382,6 @@
 			return found;
 	}
 	return NULL;
-
 }
 
 static struct btrfs_block_group_cache *
@@ -396,7 +392,6 @@
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_block_group_cache *found_group = NULL;
 	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_space_info *sinfo;
 	u64 used;
 	u64 last = 0;
 	u64 free_check;
@@ -413,7 +408,7 @@
 		if (shint && block_group_bits(shint, data) && !shint->ro) {
 			spin_lock(&shint->lock);
 			used = btrfs_block_group_used(&shint->item);
-			if (used + shint->pinned <
+			if (used + shint->pinned + shint->reserved <
 			    div_factor(shint->key.offset, factor)) {
 				spin_unlock(&shint->lock);
 				return shint;
@@ -424,7 +419,7 @@
 	if (hint && !hint->ro && block_group_bits(hint, data)) {
 		spin_lock(&hint->lock);
 		used = btrfs_block_group_used(&hint->item);
-		if (used + hint->pinned <
+		if (used + hint->pinned + hint->reserved <
 		    div_factor(hint->key.offset, factor)) {
 			spin_unlock(&hint->lock);
 			return hint;
@@ -437,27 +432,9 @@
 		else
 			last = search_start;
 	}
-	sinfo = __find_space_info(root->fs_info, data);
-	if (!sinfo)
-		goto found;
-again:
-	while(1) {
-		struct list_head *l;
-
-		cache = NULL;
-
-		spin_lock(&sinfo->lock);
-		list_for_each(l, &sinfo->block_groups) {
-			struct btrfs_block_group_cache *entry;
-			entry = list_entry(l, struct btrfs_block_group_cache,
-					   list);
-			if ((entry->key.objectid >= last) &&
-			    (!cache || (entry->key.objectid <
-					cache->key.objectid)))
-				cache = entry;
-		}
-		spin_unlock(&sinfo->lock);
-
+again:
+	while (1) {
+		cache = btrfs_lookup_first_block_group(root->fs_info, last);
 		if (!cache)
 			break;
 
@@ -467,7 +444,8 @@
 
 		if (!cache->ro && block_group_bits(cache, data)) {
 			free_check = div_factor(cache->key.offset, factor);
-			if (used + cache->pinned < free_check) {
+			if (used + cache->pinned + cache->reserved <
+			    free_check) {
 				found_group = cache;
 				spin_unlock(&cache->lock);
 				goto found;
@@ -1414,6 +1392,7 @@
 		if (!cache)
 			break;
 
+		cache->dirty = 0;
 		last += cache->key.offset;
 
 		err = write_one_cache_group(trans, root,
@@ -1427,8 +1406,6 @@
 			werr = err;
 			continue;
 		}
-
-		cache->dirty = 0;
 	}
 	btrfs_free_path(path);
 	mutex_unlock(&root->fs_info->alloc_mutex);
@@ -1460,6 +1437,7 @@
 	found->total_bytes = total_bytes;
 	found->bytes_used = bytes_used;
 	found->bytes_pinned = 0;
+	found->bytes_reserved = 0;
 	found->full = 0;
 	found->force_alloc = 0;
 	*space_info = found;
@@ -1539,8 +1517,8 @@
 
 	thresh = div_factor(space_info->total_bytes, 6);
 	if (!force &&
-	   (space_info->bytes_used + space_info->bytes_pinned + alloc_bytes) <
-	    thresh)
+	   (space_info->bytes_used + space_info->bytes_pinned +
+	    space_info->bytes_reserved + alloc_bytes) < thresh)
 		goto out;
 
 	mutex_lock(&extent_root->fs_info->chunk_mutex);
@@ -1621,7 +1599,6 @@
 	return cache->key.objectid;
 }
 
-
 int btrfs_update_pinned_extents(struct btrfs_root *root,
 				u64 bytenr, u64 num, int pin)
 {
@@ -1639,30 +1616,51 @@
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
@@ -2126,6 +2124,7 @@
 			cache = btrfs_lookup_block_group(root->fs_info, bytenr);
 			BUG_ON(!cache);
 			btrfs_add_free_space(cache, bytenr, num_bytes);
+			update_reserved_extents(root, bytenr, num_bytes, 0);
 			return 0;
 		}
 		pin = 1;
@@ -2225,14 +2224,11 @@
 	search_start = max(search_start, first_logical_byte(root, 0));
 	orig_search_start = search_start;
 
-	if (search_end == (u64)-1)
-		search_end = btrfs_super_total_bytes(&info->super_copy);
-
 	search_start = max(search_start, hint_byte);
 	total_needed += empty_size;
 
 new_group:
-	block_group = btrfs_lookup_block_group(info, search_start);
+	block_group = btrfs_lookup_first_block_group(info, search_start);
 
 	/*
 	 * Ok this looks a little tricky, buts its really simple.  First if we
@@ -2257,12 +2253,8 @@
 			ret = do_chunk_alloc(trans, root,
 					     num_bytes + 2 * 1024 * 1024,
 					     data, 1);
-			if (ret < 0) {
-				struct btrfs_space_info *info;
-
-				info = __find_space_info(root->fs_info, data);
+			if (ret < 0)
 				goto error;
-			}
 			BUG_ON(ret);
 			chunk_alloc_done = 1;
 			search_start = orig_search_start;
@@ -2378,22 +2370,24 @@
 	struct list_head *l;
 
 	printk(KERN_INFO "space_info has %Lu free, is %sfull\n",
-	       info->total_bytes - info->bytes_used - info->bytes_pinned,
-	       (info->full) ? "" : "not ");
+	       info->total_bytes - info->bytes_used - info->bytes_pinned -
+	       info->bytes_reserved, (info->full) ? "" : "not ");
 
 	spin_lock(&info->lock);
 	list_for_each(l, &info->block_groups) {
 		cache = list_entry(l, struct btrfs_block_group_cache, list);
 		spin_lock(&cache->lock);
 		printk(KERN_INFO "block group %Lu has %Lu bytes, %Lu used "
-		       "%Lu pinned\n",
+		       "%Lu pinned %Lu reserved\n",
 		       cache->key.objectid, cache->key.offset,
-		       btrfs_block_group_used(&cache->item), cache->pinned);
+		       btrfs_block_group_used(&cache->item),
+		       cache->pinned, cache->reserved);
 		btrfs_dump_free_space(cache, bytes);
 		spin_unlock(&cache->lock);
 	}
 	spin_unlock(&info->lock);
 }
+
 static int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  u64 num_bytes, u64 min_alloc_size,
@@ -2500,6 +2494,7 @@
 	ret = __btrfs_reserve_extent(trans, root, num_bytes, min_alloc_size,
 				     empty_size, hint_byte, search_end, ins,
 				     data);
+	update_reserved_extents(root, ins->objectid, ins->offset, 1);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -2625,6 +2620,7 @@
 	ret = __btrfs_alloc_reserved_extent(trans, root, parent,
 					    root_objectid, ref_generation,
 					    owner, owner_offset, ins);
+	update_reserved_extents(root, ins->objectid, ins->offset, 0);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -2685,6 +2681,8 @@
 					owner_objectid, owner_offset, ins);
 		BUG_ON(ret);
 
+	} else {
+		update_reserved_extents(root, ins->objectid, ins->offset, 1);
 	}
 	maybe_unlock_mutex(root);
 	return ret;
@@ -3970,10 +3968,6 @@
 
 		ret = btrfs_add_block_group_cache(root->fs_info, cache);
 		BUG_ON(ret);
-
-		if (key.objectid >=
-		    btrfs_super_total_bytes(&info->super_copy))
-			break;
 	}
 	ret = 0;
 error:
