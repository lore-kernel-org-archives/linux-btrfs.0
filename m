From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Revamp cluster allocation logic
Date: Thu, 10 Nov 2011 17:45:16 -0200
Message-ID: <oripmrpxrn.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

These are patches I posted before, except these are based on cmason's
for-linus.  Reposting at josef's request.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Revamp-btrfs-cluster-creation-logic.patch

>From c8036334e5a033a6ca0963e8fb716d03b1945158 Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Fri, 14 Oct 2011 12:10:36 -0300
Subject: [PATCH 1/8] Revamp btrfs cluster creation logic.

Parameterized clusters on minimum total size and minimum chunk size,
without an upper bound.  Don't tolerate fragmentation for SSD_SPREAD;
accept some fragmentation for metadata but try to keep data dense.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |   64 +++++++++++++++++++++++-------------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7a15fcf..7572396 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2273,8 +2273,8 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
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
@@ -2283,8 +2283,8 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 
 	i = offset_to_bit(entry->offset, block_group->sectorsize,
 			  max_t(u64, offset, entry->offset));
-	search_bits = bytes_to_bits(bytes, block_group->sectorsize);
-	total_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
+	want_bits = bytes_to_bits(bytes, block_group->sectorsize);
+	min_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
 
 again:
 	found_bits = 0;
@@ -2293,7 +2293,7 @@ again:
 	     i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, i + 1)) {
 		next_zero = find_next_zero_bit(entry->bitmap,
 					       BITS_PER_BITMAP, i);
-		if (next_zero - i >= search_bits) {
+		if (next_zero - i >= min_bits) {
 			found_bits = next_zero - i;
 			break;
 		}
@@ -2313,9 +2313,9 @@ again:
 	if (cluster->max_size < found_bits * block_group->sectorsize)
 		cluster->max_size = found_bits * block_group->sectorsize;
 
-	if (total_found < total_bits) {
+	if (total_found < want_bits) {
 		i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
-		if (i - start > total_bits * 2) {
+		if (i - start > want_bits * 2) {
 			total_found = 0;
 			cluster->max_size = 0;
 			found = false;
@@ -2361,8 +2361,8 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
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
@@ -2377,10 +2377,8 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	last = entry;
 	prev = entry;
 
-	while (window_free <= min_bytes) {
-		node = rb_next(&entry->offset_index);
-		if (!node)
-			return -ENOSPC;
+	for (node = rb_next(&entry->offset_index); node;
+	     node = rb_next(&entry->offset_index)) {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 
 		if (entry->bitmap) {
@@ -2389,12 +2387,19 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			continue;
 		}
 
+		if (entry->bytes < min_bytes)
+			continue;
+
 		/*
 		 * we haven't filled the empty size and the window is
 		 * very large.  reset and try again
 		 */
 		if (entry->offset - (prev->offset + prev->bytes) > max_gap ||
-		    entry->offset - window_start > (min_bytes * 2)) {
+		    entry->offset - window_start > (window_free * 2)) {
+			/* We got a cluster of the requested size,
+			   we're done.  */
+			if (window_free >= bytes)
+				break;
 			first = entry;
 			window_start = entry->offset;
 			window_free = entry->bytes;
@@ -2409,6 +2414,9 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 		prev = entry;
 	}
 
+	if (window_free < bytes)
+		return -ENOSPC;
+
 	cluster->window_start = first->offset;
 
 	node = &first->offset_index;
@@ -2422,7 +2430,7 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 		node = rb_next(&entry->offset_index);
-		if (entry->bitmap)
+		if (entry->bitmap || entry->bytes < min_bytes)
 			continue;
 
 		rb_erase(&entry->offset_index, &ctl->free_space_offset);
@@ -2504,7 +2512,7 @@ search:
 
 /*
  * here we try to find a cluster of blocks in a block group.  The goal
- * is to find at least bytes free and up to empty_size + bytes free.
+ * is to find at least bytes+empty_size.
  * We might not find them all in one contiguous area.
  *
  * returns zero and sets up cluster if things worked out, otherwise
@@ -2522,19 +2530,16 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	u64 min_bytes;
 	int ret;
 
-	/* for metadata, allow allocates with more holes */
+	/*
+	 * Choose the minimum extent size we'll require for this
+	 * cluster.  For SSD_SPREAD, don't allow any fragmentation.
+	 * For metadata, allow allocates with smaller extents.  For
+	 * data, keep it dense.
+	 */
 	if (btrfs_test_opt(root, SSD_SPREAD)) {
 		min_bytes = bytes + empty_size;
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
+		min_bytes = bytes;
 	} else
 		min_bytes = max(bytes, (bytes + empty_size) >> 2);
 
@@ -2544,7 +2549,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	 * If we know we don't have enough space to make a cluster don't even
 	 * bother doing all the work to try and find one.
 	 */
-	if (ctl->free_space < min_bytes) {
+	if (ctl->free_space < bytes) {
 		spin_unlock(&ctl->tree_lock);
 		return -ENOSPC;
 	}
@@ -2559,10 +2564,11 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&bitmaps);
 	ret = setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offset,
-				      bytes, min_bytes);
+				      bytes + empty_size, min_bytes);
 	if (ret)
 		ret = setup_cluster_bitmap(block_group, cluster, &bitmaps,
-					   offset, bytes, min_bytes);
+					   offset, bytes + empty_size,
+					   min_bytes);
 
 	/* Clear our temporary list */
 	list_for_each_entry_safe(entry, tmp, &bitmaps, list)
-- 
1.7.4.4


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0002-Drop-gap-detection-from-btrfs.patch

>From 1714139889d95e0c4c7962daaea684dfe679490f Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Sun, 16 Oct 2011 02:01:15 -0200
Subject: [PATCH 2/8] Drop gap detection from btrfs.

Since btrfs_find_space_cluster already sets up min_bytes so as to
avoid fragmentation, drop explicit limits on window size or density.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |   32 +++-----------------------------
 1 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7572396..13304fc 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2315,11 +2315,6 @@ again:
 
 	if (total_found < want_bits) {
 		i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
-		if (i - start > want_bits * 2) {
-			total_found = 0;
-			cluster->max_size = 0;
-			found = false;
-		}
 		goto again;
 	}
 
@@ -2345,13 +2340,11 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
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
@@ -2375,7 +2368,6 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	max_extent = entry->bytes;
 	first = entry;
 	last = entry;
-	prev = entry;
 
 	for (node = rb_next(&entry->offset_index); node;
 	     node = rb_next(&entry->offset_index)) {
@@ -2390,28 +2382,10 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 		if (entry->bytes < min_bytes)
 			continue;
 
-		/*
-		 * we haven't filled the empty size and the window is
-		 * very large.  reset and try again
-		 */
-		if (entry->offset - (prev->offset + prev->bytes) > max_gap ||
-		    entry->offset - window_start > (window_free * 2)) {
-			/* We got a cluster of the requested size,
-			   we're done.  */
-			if (window_free >= bytes)
-				break;
-			first = entry;
-			window_start = entry->offset;
-			window_free = entry->bytes;
-			last = entry;
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
 
 	if (window_free < bytes)
-- 
1.7.4.4


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0003-Require-at-least-one-extent-of-the-requested-size-bu.patch

>From 62f3e1673a1770893025e6b181601af891814a15 Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Mon, 24 Oct 2011 03:30:46 -0200
Subject: [PATCH 3/8] Require at least one extent of the requested size, but
 accept other smaller ones except when SSD_SPREAD is
 enabled.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 13304fc..2856265 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2268,7 +2268,8 @@ out:
 static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 				struct btrfs_free_space *entry,
 				struct btrfs_free_cluster *cluster,
-				u64 offset, u64 bytes, u64 min_bytes)
+				u64 offset, u64 bytes,
+				u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	unsigned long next_zero;
@@ -2279,7 +2280,6 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 	unsigned long start = 0;
 	unsigned long total_found = 0;
 	int ret;
-	bool found = false;
 
 	i = offset_to_bit(entry->offset, block_group->sectorsize,
 			  max_t(u64, offset, entry->offset));
@@ -2303,17 +2303,15 @@ again:
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
 
-	if (total_found < want_bits) {
+	if (total_found < want_bits || cluster->max_size < cont1_bytes) {
 		i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
 		goto again;
 	}
@@ -2330,12 +2328,14 @@ again:
 
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
@@ -2388,7 +2388,7 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			max_extent = entry->bytes;
 	}
 
-	if (window_free < bytes)
+	if (window_free < bytes || max_extent < cont1_bytes)
 		return -ENOSPC;
 
 	cluster->window_start = first->offset;
@@ -2426,7 +2426,7 @@ static noinline int
 setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 		     struct btrfs_free_cluster *cluster,
 		     struct list_head *bitmaps, u64 offset, u64 bytes,
-		     u64 min_bytes)
+		     u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry;
@@ -2444,7 +2444,7 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 		if (entry->bytes < min_bytes)
 			continue;
 		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
+					   bytes, cont1_bytes, min_bytes);
 		if (!ret)
 			return 0;
 	}
@@ -2478,7 +2478,7 @@ search:
 		if (entry->bytes < min_bytes)
 			continue;
 		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
+					   bytes, cont1_bytes, min_bytes);
 	} while (ret && node);
 
 	return ret;
@@ -2501,7 +2501,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct list_head bitmaps;
 	struct btrfs_free_space *entry, *tmp;
-	u64 min_bytes;
+	u64 min_bytes, cont1_bytes;
 	int ret;
 
 	/*
@@ -2511,11 +2511,14 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	 * data, keep it dense.
 	 */
 	if (btrfs_test_opt(root, SSD_SPREAD)) {
-		min_bytes = bytes + empty_size;
+		cont1_bytes = min_bytes = bytes + empty_size;
 	} else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
-		min_bytes = bytes;
-	} else
-		min_bytes = max(bytes, (bytes + empty_size) >> 2);
+		cont1_bytes = bytes;
+		min_bytes = block_group->sectorsize;
+	} else {
+		cont1_bytes = max(bytes, (bytes + empty_size) >> 2);
+		min_bytes = block_group->sectorsize;
+	}
 
 	spin_lock(&ctl->tree_lock);
 
@@ -2538,11 +2541,12 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&bitmaps);
 	ret = setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offset,
-				      bytes + empty_size, min_bytes);
+				      bytes + empty_size,
+				      cont1_bytes, min_bytes);
 	if (ret)
 		ret = setup_cluster_bitmap(block_group, cluster, &bitmaps,
 					   offset, bytes + empty_size,
-					   min_bytes);
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
