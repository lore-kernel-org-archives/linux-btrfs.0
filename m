Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3IIFSw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 01:18:52 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r895IkvQ002252
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Sep 2013 13:18:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] Btrfs: allocate the free space by the existed max extent size when ENOSPC
Date: Mon, 9 Sep 2013 13:19:42 +0800
Message-Id: <1378703982-14046-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1377858934-17187-1-git-send-email-miaox@cn.fujitsu.com>
References: <1377858934-17187-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By the current code, if the requested size is very large, and all the extents
in the free space cache are small, we will waste lots of the cpu time to cut
the requested size in half and search the cache again and again until it gets
down to the size the allocator can return. In fact, we can know the max extent
size in the cache after the first search, so we needn't cut the size in half
repeatedly, and just use the max extent size directly. This way can save
lots of cpu time and make the performance grow up when there are only fragments
in the free space cache.

According to my test, if there are only 4KB free space extents in the fs,
and the total size of those extents are 256MB, we can reduce the execute
time of the following test from 5.4s to 1.4s.
  dd if=/dev/zero of=<testfile> bs=1MB count=1 oflag=sync

Changelog v2 -> v3:
- fix the problem that we skip the block group with the space which is
  less than we need.

Changelog v1 -> v2:
- address the problem that we return a wrong start position when searching
  the free space in a bitmap.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c      | 33 ++++++++++++++++------
 fs/btrfs/free-space-cache.c | 67 +++++++++++++++++++++++++++++++--------------
 fs/btrfs/free-space-cache.h |  5 ++--
 3 files changed, 74 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cfb3cf7..2f03181 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6117,10 +6117,13 @@ enum btrfs_loop_type {
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
- * ins->objectid == block start
+ * ins->objectid == start position
  * ins->flags = BTRFS_EXTENT_ITEM_KEY
- * ins->offset == number of blocks
+ * ins->offset == the size of the hole.
  * Any available blocks before search_start are skipped.
+ *
+ * If there is no suitable free space, we will record the max size of
+ * the free space extent currently.
  */
 static noinline int find_free_extent(struct btrfs_root *orig_root,
 				     u64 num_bytes, u64 empty_size,
@@ -6133,6 +6136,7 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 	struct btrfs_block_group_cache *block_group = NULL;
 	struct btrfs_block_group_cache *used_block_group;
 	u64 search_start = 0;
+	u64 max_extent_size = 0;
 	int empty_cluster = 2 * 1024 * 1024;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
@@ -6292,7 +6296,10 @@ have_block_group:
 				btrfs_get_block_group(used_block_group);
 
 			offset = btrfs_alloc_from_cluster(used_block_group,
-			  last_ptr, num_bytes, used_block_group->key.objectid);
+						last_ptr,
+						num_bytes,
+						used_block_group->key.objectid,
+						&max_extent_size);
 			if (offset) {
 				/* we have a block, we're done */
 				spin_unlock(&last_ptr->refill_lock);
@@ -6355,8 +6362,10 @@ refill_cluster:
 				 * cluster
 				 */
 				offset = btrfs_alloc_from_cluster(block_group,
-						  last_ptr, num_bytes,
-						  search_start);
+							last_ptr,
+							num_bytes,
+							search_start,
+							&max_extent_size);
 				if (offset) {
 					/* we found one, proceed */
 					spin_unlock(&last_ptr->refill_lock);
@@ -6391,13 +6400,18 @@ unclustered_alloc:
 		if (cached &&
 		    block_group->free_space_ctl->free_space <
 		    num_bytes + empty_cluster + empty_size) {
+			if (block_group->free_space_ctl->free_space >
+			    max_extent_size)
+				max_extent_size =
+					block_group->free_space_ctl->free_space;
 			spin_unlock(&block_group->free_space_ctl->tree_lock);
 			goto loop;
 		}
 		spin_unlock(&block_group->free_space_ctl->tree_lock);
 
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
-						    num_bytes, empty_size);
+						    num_bytes, empty_size,
+						    &max_extent_size);
 		/*
 		 * If we didn't find a chunk, and we haven't failed on this
 		 * block group before, and this block group is in the middle of
@@ -6515,7 +6529,8 @@ loop:
 		ret = 0;
 	}
 out:
-
+	if (ret == -ENOSPC)
+		ins->offset = max_extent_size;
 	return ret;
 }
 
@@ -6573,8 +6588,8 @@ again:
 			       flags);
 
 	if (ret == -ENOSPC) {
-		if (!final_tried) {
-			num_bytes = num_bytes >> 1;
+		if (!final_tried && ins->offset) {
+			num_bytes = min(num_bytes >> 1, ins->offset);
 			num_bytes = round_down(num_bytes, root->sectorsize);
 			num_bytes = max(num_bytes, min_alloc_size);
 			if (num_bytes == min_alloc_size)
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ef3bea7..4f419ba 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1433,13 +1433,19 @@ static void bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
 	ctl->free_space += bytes;
 }
 
+/*
+ * If we can not find suitable extent, we will use bytes to record
+ * the size of the max extent.
+ */
 static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 			 struct btrfs_free_space *bitmap_info, u64 *offset,
 			 u64 *bytes)
 {
 	unsigned long found_bits = 0;
+	unsigned long max_bits = 0;
 	unsigned long bits, i;
 	unsigned long next_zero;
+	unsigned long extent_bits;
 
 	i = offset_to_bit(bitmap_info->offset, ctl->unit,
 			  max_t(u64, *offset, bitmap_info->offset));
@@ -1448,9 +1454,12 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 	for_each_set_bit_from(i, bitmap_info->bitmap, BITS_PER_BITMAP) {
 		next_zero = find_next_zero_bit(bitmap_info->bitmap,
 					       BITS_PER_BITMAP, i);
-		if ((next_zero - i) >= bits) {
-			found_bits = next_zero - i;
+		extent_bits = next_zero - i;
+		if (extent_bits >= bits) {
+			found_bits = extent_bits;
 			break;
+		} else if (extent_bits > max_bits) {
+			max_bits = extent_bits;
 		}
 		i = next_zero;
 	}
@@ -1461,38 +1470,41 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 		return 0;
 	}
 
+	*bytes = (u64)(max_bits) * ctl->unit;
 	return -1;
 }
 
+/* Cache the size of the max extent in bytes */
 static struct btrfs_free_space *
 find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
-		unsigned long align)
+		unsigned long align, u64 *max_extent_size)
 {
 	struct btrfs_free_space *entry;
 	struct rb_node *node;
-	u64 ctl_off;
 	u64 tmp;
 	u64 align_off;
 	int ret;
 
 	if (!ctl->free_space_offset.rb_node)
-		return NULL;
+		goto out;
 
 	entry = tree_search_offset(ctl, offset_to_bitmap(ctl, *offset), 0, 1);
 	if (!entry)
-		return NULL;
+		goto out;
 
 	for (node = &entry->offset_index; node; node = rb_next(node)) {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
-		if (entry->bytes < *bytes)
+		if (entry->bytes < *bytes) {
+			if (entry->bytes > *max_extent_size)
+				*max_extent_size = entry->bytes;
 			continue;
+		}
 
 		/* make sure the space returned is big enough
 		 * to match our requested alignment
 		 */
 		if (*bytes >= align) {
-			ctl_off = entry->offset - ctl->start;
-			tmp = ctl_off + align - 1;;
+			tmp = entry->offset - ctl->start + align - 1;
 			do_div(tmp, align);
 			tmp = tmp * align + ctl->start;
 			align_off = tmp - entry->offset;
@@ -1501,14 +1513,22 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 			tmp = entry->offset;
 		}
 
-		if (entry->bytes < *bytes + align_off)
+		if (entry->bytes < *bytes + align_off) {
+			if (entry->bytes > *max_extent_size)
+				*max_extent_size = entry->bytes;
 			continue;
+		}
 
 		if (entry->bitmap) {
-			ret = search_bitmap(ctl, entry, &tmp, bytes);
+			u64 size = *bytes;
+
+			ret = search_bitmap(ctl, entry, &tmp, &size);
 			if (!ret) {
 				*offset = tmp;
+				*bytes = size;
 				return entry;
+			} else if (size > *max_extent_size) {
+				*max_extent_size = size;
 			}
 			continue;
 		}
@@ -1517,7 +1537,7 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 		*bytes = entry->bytes - align_off;
 		return entry;
 	}
-
+out:
 	return NULL;
 }
 
@@ -2118,7 +2138,8 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 }
 
 u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
-			       u64 offset, u64 bytes, u64 empty_size)
+			       u64 offset, u64 bytes, u64 empty_size,
+			       u64 *max_extent_size)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry = NULL;
@@ -2129,7 +2150,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 
 	spin_lock(&ctl->tree_lock);
 	entry = find_free_space(ctl, &offset, &bytes_search,
-				block_group->full_stripe_len);
+				block_group->full_stripe_len, max_extent_size);
 	if (!entry)
 		goto out;
 
@@ -2139,7 +2160,6 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 		if (!entry->bytes)
 			free_bitmap(ctl, entry);
 	} else {
-
 		unlink_free_space(ctl, entry);
 		align_gap_len = offset - entry->offset;
 		align_gap = entry->offset;
@@ -2153,7 +2173,6 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 		else
 			link_free_space(ctl, entry);
 	}
-
 out:
 	spin_unlock(&ctl->tree_lock);
 
@@ -2208,7 +2227,8 @@ int btrfs_return_cluster_to_free_space(
 static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 				   struct btrfs_free_cluster *cluster,
 				   struct btrfs_free_space *entry,
-				   u64 bytes, u64 min_start)
+				   u64 bytes, u64 min_start,
+				   u64 *max_extent_size)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	int err;
@@ -2220,8 +2240,11 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 	search_bytes = bytes;
 
 	err = search_bitmap(ctl, entry, &search_start, &search_bytes);
-	if (err)
+	if (err) {
+		if (search_bytes > *max_extent_size)
+			*max_extent_size = search_bytes;
 		return 0;
+	}
 
 	ret = search_start;
 	__bitmap_clear_bits(ctl, entry, ret, bytes);
@@ -2236,7 +2259,7 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
  */
 u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 			     struct btrfs_free_cluster *cluster, u64 bytes,
-			     u64 min_start)
+			     u64 min_start, u64 *max_extent_size)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry = NULL;
@@ -2256,6 +2279,9 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 
 	entry = rb_entry(node, struct btrfs_free_space, offset_index);
 	while(1) {
+		if (entry->bytes < bytes && entry->bytes > *max_extent_size)
+			*max_extent_size = entry->bytes;
+
 		if (entry->bytes < bytes ||
 		    (!entry->bitmap && entry->offset < min_start)) {
 			node = rb_next(&entry->offset_index);
@@ -2269,7 +2295,8 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 		if (entry->bitmap) {
 			ret = btrfs_alloc_from_bitmap(block_group,
 						      cluster, entry, bytes,
-						      cluster->window_start);
+						      cluster->window_start,
+						      max_extent_size);
 			if (ret == 0) {
 				node = rb_next(&entry->offset_index);
 				if (!node)
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index c749041..e737f92 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -94,7 +94,8 @@ void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl);
 void btrfs_remove_free_space_cache(struct btrfs_block_group_cache
 				     *block_group);
 u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
-			       u64 offset, u64 bytes, u64 empty_size);
+			       u64 offset, u64 bytes, u64 empty_size,
+			       u64 *max_extent_size);
 u64 btrfs_find_ino_for_alloc(struct btrfs_root *fs_root);
 void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 			   u64 bytes);
@@ -105,7 +106,7 @@ int btrfs_find_space_cluster(struct btrfs_root *root,
 void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster);
 u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 			     struct btrfs_free_cluster *cluster, u64 bytes,
-			     u64 min_start);
+			     u64 min_start, u64 *max_extent_size);
 int btrfs_return_cluster_to_free_space(
 			       struct btrfs_block_group_cache *block_group,
 			       struct btrfs_free_cluster *cluster);
-- 
1.8.3.1

