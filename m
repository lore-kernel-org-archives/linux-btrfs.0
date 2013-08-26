Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48675 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3HZVOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 17:14:51 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 346B67C04E0
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 15:14:51 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id ybwAtQEmBFbDYFQm (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 15:14:50 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: convert all bug_ons in free-space-cache.c
Date: Mon, 26 Aug 2013 17:14:48 -0400
Message-ID: <1377551688-26027-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All of these are logic checks to make sure we're not breaking anything, so
convert them over to ASSERT().  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/free-space-cache.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2318264..ef3bea7 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -308,7 +308,7 @@ static void io_ctl_unmap_page(struct io_ctl *io_ctl)
 
 static void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
 {
-	BUG_ON(io_ctl->index >= io_ctl->num_pages);
+	ASSERT(io_ctl->index < io_ctl->num_pages);
 	io_ctl->page = io_ctl->pages[io_ctl->index++];
 	io_ctl->cur = kmap(io_ctl->page);
 	io_ctl->orig = io_ctl->cur;
@@ -728,7 +728,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				goto free_cache;
 			}
 		} else {
-			BUG_ON(!num_bitmaps);
+			ASSERT(num_bitmaps);
 			num_bitmaps--;
 			e->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
 			if (!e->bitmap) {
@@ -1028,7 +1028,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	leaf = path->nodes[0];
 	if (ret > 0) {
 		struct btrfs_key found_key;
-		BUG_ON(!path->slots[0]);
+		ASSERT(path->slots[0]);
 		path->slots[0]--;
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 		if (found_key.objectid != BTRFS_FREE_SPACE_OBJECTID ||
@@ -1116,7 +1116,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 static inline unsigned long offset_to_bit(u64 bitmap_start, u32 unit,
 					  u64 offset)
 {
-	BUG_ON(offset < bitmap_start);
+	ASSERT(offset >= bitmap_start);
 	offset -= bitmap_start;
 	return (unsigned long)(div_u64(offset, unit));
 }
@@ -1271,7 +1271,7 @@ tree_search_offset(struct btrfs_free_space_ctl *ctl,
 		if (n) {
 			entry = rb_entry(n, struct btrfs_free_space,
 					offset_index);
-			BUG_ON(entry->offset > offset);
+			ASSERT(entry->offset <= offset);
 		} else {
 			if (fuzzy)
 				return entry;
@@ -1335,7 +1335,7 @@ static int link_free_space(struct btrfs_free_space_ctl *ctl,
 {
 	int ret = 0;
 
-	BUG_ON(!info->bitmap && !info->bytes);
+	ASSERT(info->bytes || info->bitmap);
 	ret = tree_insert_offset(&ctl->free_space_offset, info->offset,
 				 &info->offset_index, (info->bitmap != NULL));
 	if (ret)
@@ -1358,7 +1358,7 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 
 	max_bitmaps = max(max_bitmaps, 1);
 
-	BUG_ON(ctl->total_bitmaps > max_bitmaps);
+	ASSERT(ctl->total_bitmaps <= max_bitmaps);
 
 	/*
 	 * The goal is to keep the total amount of memory used per 1gb of space
@@ -1402,7 +1402,7 @@ static inline void __bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 
 	start = offset_to_bit(info->offset, ctl->unit, offset);
 	count = bytes_to_bits(bytes, ctl->unit);
-	BUG_ON(start + count > BITS_PER_BITMAP);
+	ASSERT(start + count <= BITS_PER_BITMAP);
 
 	bitmap_clear(info->bitmap, start, count);
 
@@ -1425,7 +1425,7 @@ static void bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
 
 	start = offset_to_bit(info->offset, ctl->unit, offset);
 	count = bytes_to_bits(bytes, ctl->unit);
-	BUG_ON(start + count > BITS_PER_BITMAP);
+	ASSERT(start + count <= BITS_PER_BITMAP);
 
 	bitmap_set(info->bitmap, start, count);
 
@@ -1741,7 +1741,7 @@ no_cluster_bitmap:
 	bitmap_info = tree_search_offset(ctl, offset_to_bitmap(ctl, offset),
 					 1, 0);
 	if (!bitmap_info) {
-		BUG_ON(added);
+		ASSERT(added == 0);
 		goto new_bitmap;
 	}
 
@@ -1881,7 +1881,7 @@ out:
 
 	if (ret) {
 		printk(KERN_CRIT "btrfs: unable to add free space :%d\n", ret);
-		BUG_ON(ret == -EEXIST);
+		ASSERT(ret != -EEXIST);
 	}
 
 	return ret;
@@ -2369,7 +2369,7 @@ again:
 	rb_erase(&entry->offset_index, &ctl->free_space_offset);
 	ret = tree_insert_offset(&cluster->root, entry->offset,
 				 &entry->offset_index, 1);
-	BUG_ON(ret); /* -EEXIST; Logic error */
+	ASSERT(!ret); /* -EEXIST; Logic error */
 
 	trace_btrfs_setup_cluster(block_group, cluster,
 				  total_found * ctl->unit, 1);
@@ -2462,7 +2462,7 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 		ret = tree_insert_offset(&cluster->root, entry->offset,
 					 &entry->offset_index, 0);
 		total_size += entry->bytes;
-		BUG_ON(ret); /* -EEXIST; Logic error */
+		ASSERT(!ret); /* -EEXIST; Logic error */
 	} while (node && entry != last);
 
 	cluster->max_size = max_extent;
@@ -2853,7 +2853,7 @@ u64 btrfs_find_ino_for_alloc(struct btrfs_root *fs_root)
 
 		ret = search_bitmap(ctl, entry, &offset, &count);
 		/* Logic error; Should be empty if it can't find anything */
-		BUG_ON(ret);
+		ASSERT(!ret);
 
 		ino = offset;
 		bitmap_clear_bits(ctl, entry, offset, 1);
-- 
1.7.7.6

