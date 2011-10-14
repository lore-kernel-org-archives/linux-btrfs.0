Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45947 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752056Ab1K1UEQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 15:04:16 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJxX3J024269
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 18:03:09 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWbo0012432
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:38 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWb9N020382
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:37 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWahX020379
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:36 -0200
Message-Id: <dd11fc795399f235ce43b4a4069a13f08461fbb3.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Fri, 14 Oct 2011 12:10:36 -0300
Subject: [PATCH 13/20] Btrfs: revamp clustered allocation logic
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Parameterize clusters on minimum total size, minimum chunk size and
minimum contiguous size for at least one chunk, without limits on
cluster, window or gap sizes.  Don't tolerate any fragmentation for
SSD_SPREAD; accept it for metadata, but try to keep data dense.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |  112 +++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index dd7fe43..3aa56e4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2284,23 +2284,23 @@ out:
 static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 				struct btrfs_free_space *entry,
 				struct btrfs_free_cluster *cluster,
-				u64 offset, u64 bytes, u64 min_bytes)
+				u64 offset, u64 bytes,
+				u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	unsigned long next_zero;
 	unsigned long i;
-	unsigned long search_bits;
-	unsigned long total_bits;
+	unsigned long want_bits;
+	unsigned long min_bits;
 	unsigned long found_bits;
 	unsigned long start = 0;
 	unsigned long total_found = 0;
 	int ret;
-	bool found = false;
 
 	i = offset_to_bit(entry->offset, block_group->sectorsize,
 			  max_t(u64, offset, entry->offset));
-	search_bits = bytes_to_bits(bytes, block_group->sectorsize);
-	total_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
+	want_bits = bytes_to_bits(bytes, block_group->sectorsize);
+	min_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
 
 again:
 	found_bits = 0;
@@ -2309,7 +2309,7 @@ again:
 	     i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, i + 1)) {
 		next_zero = find_next_zero_bit(entry->bitmap,
 					       BITS_PER_BITMAP, i);
-		if (next_zero - i >= search_bits) {
+		if (next_zero - i >= min_bits) {
 			found_bits = next_zero - i;
 			break;
 		}
@@ -2319,10 +2319,9 @@ again:
 	if (!found_bits)
 		return -ENOSPC;
 
-	if (!found) {
+	if (!total_found) {
 		start = i;
 		cluster->max_size = 0;
-		found = true;
 	}
 
 	total_found += found_bits;
@@ -2330,13 +2329,8 @@ again:
 	if (cluster->max_size < found_bits * block_group->sectorsize)
 		cluster->max_size = found_bits * block_group->sectorsize;
 
-	if (total_found < total_bits) {
-		i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
-		if (i - start > total_bits * 2) {
-			total_found = 0;
-			cluster->max_size = 0;
-			found = false;
-		}
+	if (total_found < want_bits || cluster->max_size < cont1_bytes) {
+		i = next_zero + 1;
 		goto again;
 	}
 
@@ -2352,23 +2346,23 @@ again:
 
 /*
  * This searches the block group for just extents to fill the cluster with.
+ * Try to find a cluster with at least bytes total bytes, at least one
+ * extent of cont1_bytes, and other clusters of at least min_bytes.
  */
 static noinline int
 setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			struct btrfs_free_cluster *cluster,
 			struct list_head *bitmaps, u64 offset, u64 bytes,
-			u64 min_bytes)
+			u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *first = NULL;
 	struct btrfs_free_space *entry = NULL;
-	struct btrfs_free_space *prev = NULL;
 	struct btrfs_free_space *last;
 	struct rb_node *node;
 	u64 window_start;
 	u64 window_free;
 	u64 max_extent;
-	u64 max_gap = 128 * 1024;
 
 	entry = tree_search_offset(ctl, offset, 0, 1);
 	if (!entry)
@@ -2378,8 +2372,8 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	 * We don't want bitmaps, so just move along until we find a normal
 	 * extent entry.
 	 */
-	while (entry->bitmap) {
-		if (list_empty(&entry->list))
+	while (entry->bitmap || entry->bytes < min_bytes) {
+		if (entry->bitmap && list_empty(&entry->list))
 			list_add_tail(&entry->list, bitmaps);
 		else if (entry->bitmap)
 			printk(KERN_ERR "btrfs: not using (busy?!?) bitmap %lli\n",
@@ -2395,12 +2389,9 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	max_extent = entry->bytes;
 	first = entry;
 	last = entry;
-	prev = entry;
 
-	while (window_free <= min_bytes) {
-		node = rb_next(&entry->offset_index);
-		if (!node)
-			return -ENOSPC;
+	for (node = rb_next(&entry->offset_index); node;
+	     node = rb_next(&entry->offset_index)) {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 
 		if (entry->bitmap) {
@@ -2412,26 +2403,18 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			continue;
 		}
 
-		/*
-		 * we haven't filled the empty size and the window is
-		 * very large.  reset and try again
-		 */
-		if (entry->offset - (prev->offset + prev->bytes) > max_gap ||
-		    entry->offset - window_start > (min_bytes * 2)) {
-			first = entry;
-			window_start = entry->offset;
-			window_free = entry->bytes;
-			last = entry;
+		if (entry->bytes < min_bytes)
+			continue;
+
+		last = entry;
+		window_free += entry->bytes;
+		if (entry->bytes > max_extent)
 			max_extent = entry->bytes;
-		} else {
-			last = entry;
-			window_free += entry->bytes;
-			if (entry->bytes > max_extent)
-				max_extent = entry->bytes;
-		}
-		prev = entry;
 	}
 
+	if (window_free < bytes || max_extent < cont1_bytes)
+		return -ENOSPC;
+
 	cluster->window_start = first->offset;
 
 	node = &first->offset_index;
@@ -2445,7 +2428,7 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 		node = rb_next(&entry->offset_index);
-		if (entry->bitmap)
+		if (entry->bitmap || entry->bytes < min_bytes)
 			continue;
 
 		rb_erase(&entry->offset_index, &ctl->free_space_offset);
@@ -2467,7 +2450,7 @@ static noinline int
 setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 		     struct btrfs_free_cluster *cluster,
 		     struct list_head *bitmaps, u64 offset, u64 bytes,
-		     u64 min_bytes)
+		     u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry;
@@ -2492,7 +2475,7 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 		if (entry->bytes < min_bytes)
 			continue;
 		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
+					   bytes, cont1_bytes, min_bytes);
 		if (!ret)
 			return 0;
 	}
@@ -2506,7 +2489,7 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 
 /*
  * here we try to find a cluster of blocks in a block group.  The goal
- * is to find at least bytes free and up to empty_size + bytes free.
+ * is to find at least bytes+empty_size.
  * We might not find them all in one contiguous area.
  *
  * returns zero and sets up cluster if things worked out, otherwise
@@ -2522,23 +2505,24 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	struct btrfs_free_space *entry, *tmp;
 	LIST_HEAD(bitmaps);
 	u64 min_bytes;
+	u64 cont1_bytes;
 	int ret;
 
-	/* for metadata, allow allocates with more holes */
+	/*
+	 * Choose the minimum extent size we'll require for this
+	 * cluster.  For SSD_SPREAD, don't allow any fragmentation.
+	 * For metadata, allow allocates with smaller extents.  For
+	 * data, keep it dense.
+	 */
 	if (btrfs_test_opt(root, SSD_SPREAD)) {
-		min_bytes = bytes + empty_size;
+		cont1_bytes = min_bytes = bytes + empty_size;
 	} else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
-		/*
-		 * we want to do larger allocations when we are
-		 * flushing out the delayed refs, it helps prevent
-		 * making more work as we go along.
-		 */
-		if (trans->transaction->delayed_refs.flushing)
-			min_bytes = max(bytes, (bytes + empty_size) >> 1);
-		else
-			min_bytes = max(bytes, (bytes + empty_size) >> 4);
-	} else
-		min_bytes = max(bytes, (bytes + empty_size) >> 2);
+		cont1_bytes = bytes;
+		min_bytes = block_group->sectorsize;
+	} else {
+		cont1_bytes = max(bytes, (bytes + empty_size) >> 2);
+		min_bytes = block_group->sectorsize;
+	}
 
 	spin_lock(&ctl->tree_lock);
 
@@ -2546,7 +2530,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	 * If we know we don't have enough space to make a cluster don't even
 	 * bother doing all the work to try and find one.
 	 */
-	if (ctl->free_space < min_bytes) {
+	if (ctl->free_space < bytes) {
 		spin_unlock(&ctl->tree_lock);
 		return -ENOSPC;
 	}
@@ -2560,10 +2544,12 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	}
 
 	ret = setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offset,
-				      bytes, min_bytes);
+				      bytes + empty_size,
+				      cont1_bytes, min_bytes);
 	if (ret)
 		ret = setup_cluster_bitmap(block_group, cluster, &bitmaps,
-					   offset, bytes, min_bytes);
+					   offset, bytes + empty_size,
+					   cont1_bytes, min_bytes);
 
 	/* Clear our temporary list */
 	list_for_each_entry_safe(entry, tmp, &bitmaps, list)
-- 
1.7.4.4

