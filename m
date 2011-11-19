From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: Revamp cluster allocation logic
Date: Sat, 19 Nov 2011 08:12:21 -0200
Message-ID: <or62ig775m.fsf@livre.localdomain>
References: <oripmrpxrn.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: josef@redhat.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <oripmrpxrn.fsf@livre.localdomain> (Alexandre Oliva's message of
	"Thu, 10 Nov 2011 17:45:16 -0200")
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

On Nov 10, 2011, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:

> These are patches I posted before, except these are based on cmason's
> for-linus.  Reposting at josef's request.

Reposting again, at josef's request, this time consolidating the 3
patches into one.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0004-Btrfs-revamp-clustered-allocation-logic.patch

>From 349a2a26d97c6497f7e4df55b1bdb2f93a673376 Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Fri, 14 Oct 2011 12:10:36 -0300
Subject: [PATCH 4/8] Btrfs: revamp clustered allocation logic

Parameterize clusters on minimum total size, minimum chunk size and
minimum contiguous size for at least one chunk, without limits on
cluster, window or gap sizes.  Don't tolerate any fragmentation for
SSD_SPREAD; accept it for metadata, but try to keep data dense.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |  114 ++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 181760f..7fe88b5 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2271,23 +2271,23 @@ out:
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
@@ -2296,7 +2296,7 @@ again:
 	     i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, i + 1)) {
 		next_zero = find_next_zero_bit(entry->bitmap,
 					       BITS_PER_BITMAP, i);
-		if (next_zero - i >= search_bits) {
+		if (next_zero - i >= min_bits) {
 			found_bits = next_zero - i;
 			break;
 		}
@@ -2306,23 +2306,16 @@ again:
 	if (!found_bits)
 		return -ENOSPC;
 
-	if (!found) {
+	if (!total_found)
 		start = i;
-		found = true;
-	}
 
 	total_found += found_bits;
 
 	if (cluster->max_size < found_bits * block_group->sectorsize)
 		cluster->max_size = found_bits * block_group->sectorsize;
 
-	if (total_found < total_bits) {
+	if (total_found < want_bits || cluster->max_size < cont1_bytes) {
 		i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
-		if (i - start > total_bits * 2) {
-			total_found = 0;
-			cluster->max_size = 0;
-			found = false;
-		}
 		goto again;
 	}
 
@@ -2338,23 +2331,23 @@ again:
 
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
@@ -2364,8 +2357,8 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	 * We don't want bitmaps, so just move along until we find a normal
 	 * extent entry.
 	 */
-	while (entry->bitmap) {
-		if (list_empty(&entry->list))
+	while (entry->bitmap || entry->bytes < min_bytes) {
+		if (entry->bitmap && list_empty(&entry->list))
 			list_add_tail(&entry->list, bitmaps);
 		node = rb_next(&entry->offset_index);
 		if (!node)
@@ -2378,12 +2371,9 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
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
@@ -2392,26 +2382,18 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
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
@@ -2425,7 +2407,7 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 		node = rb_next(&entry->offset_index);
-		if (entry->bitmap)
+		if (entry->bitmap || entry->bytes < min_bytes)
 			continue;
 
 		rb_erase(&entry->offset_index, &ctl->free_space_offset);
@@ -2447,7 +2429,7 @@ static noinline int
 setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 		     struct btrfs_free_cluster *cluster,
 		     struct list_head *bitmaps, u64 offset, u64 bytes,
-		     u64 min_bytes)
+		     u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry;
@@ -2465,7 +2447,7 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 		if (entry->bytes < min_bytes)
 			continue;
 		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
+					   bytes, cont1_bytes, min_bytes);
 		if (!ret)
 			return 0;
 	}
@@ -2499,7 +2481,7 @@ search:
 		if (entry->bytes < min_bytes)
 			continue;
 		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
+					   bytes, cont1_bytes, min_bytes);
 	} while (ret && node);
 
 	return ret;
@@ -2507,7 +2489,7 @@ search:
 
 /*
  * here we try to find a cluster of blocks in a block group.  The goal
- * is to find at least bytes free and up to empty_size + bytes free.
+ * is to find at least bytes+empty_size.
  * We might not find them all in one contiguous area.
  *
  * returns zero and sets up cluster if things worked out, otherwise
@@ -2522,24 +2504,24 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct list_head bitmaps;
 	struct btrfs_free_space *entry, *tmp;
-	u64 min_bytes;
+	u64 min_bytes, cont1_bytes;
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
 
@@ -2547,7 +2529,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	 * If we know we don't have enough space to make a cluster don't even
 	 * bother doing all the work to try and find one.
 	 */
-	if (ctl->free_space < min_bytes) {
+	if (ctl->free_space < bytes) {
 		spin_unlock(&ctl->tree_lock);
 		return -ENOSPC;
 	}
@@ -2562,10 +2544,12 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&bitmaps);
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


--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
