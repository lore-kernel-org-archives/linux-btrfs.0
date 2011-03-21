From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: cleanup how we setup free space clusters
Date: Mon, 21 Mar 2011 10:18:53 -0400
Message-ID: <1300717133-23475-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes the free space cluster refilling code a little easier to
understand, and fixes some things with the bitmap part of it.  Currently we
either want to refill a cluster with

1) All normal extent entries (those without bitmaps)
2) A bitmap entry with enough space

The current code has this ugly jump around logic that will first try and fill up
the cluster with extent entries and then if it can't do that it will try and
find a bitmap to use.  So instead split this out into two functions, one that
tries to find only normal entries, and one that tries to find bitmaps.

This also fixes a suboptimal thing we would do with bitmaps.  If we used a
bitmap we would just tell the cluster that we were pointing at a bitmap and it
would do the tree search in the block group for that entry every time we tried
to make an allocation.  Instead of doing that now we just add it to the clusters
group.

I tested this with my ENOSPC tests and xfstests and it survived.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h            |    3 -
 fs/btrfs/free-space-cache.c |  361 +++++++++++++++++++++----------------------
 2 files changed, 179 insertions(+), 185 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6036fdb..0ee679b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -783,9 +783,6 @@ struct btrfs_free_cluster {
 	/* first extent starting offset */
 	u64 window_start;
 
-	/* if this cluster simply points at a bitmap in the block group */
-	bool points_to_bitmap;
-
 	struct btrfs_block_group_cache *block_group;
 	/*
 	 * when a cluster is allocated from a block group, we put the
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7a808d7..a328af9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1644,30 +1644,28 @@ __btrfs_return_cluster_to_free_space(
 {
 	struct btrfs_free_space *entry;
 	struct rb_node *node;
-	bool bitmap;
 
 	spin_lock(&cluster->lock);
 	if (cluster->block_group != block_group)
 		goto out;
 
-	bitmap = cluster->points_to_bitmap;
 	cluster->block_group = NULL;
 	cluster->window_start = 0;
 	list_del_init(&cluster->block_group_list);
-	cluster->points_to_bitmap = false;
-
-	if (bitmap)
-		goto out;
 
 	node = rb_first(&cluster->root);
 	while (node) {
+		bool bitmap;
+
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 		node = rb_next(&entry->offset_index);
 		rb_erase(&entry->offset_index, &cluster->root);
-		BUG_ON(entry->bitmap);
-		try_merge_free_space(block_group, entry, false);
+
+		bitmap = (entry->bitmap != NULL);
+		if (!bitmap)
+			try_merge_free_space(block_group, entry, false);
 		tree_insert_offset(&block_group->free_space_offset,
-				   entry->offset, &entry->offset_index, 0);
+				   entry->offset, &entry->offset_index, bitmap);
 	}
 	cluster->root = RB_ROOT;
 
@@ -1790,50 +1788,24 @@ int btrfs_return_cluster_to_free_space(
 
 static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 				   struct btrfs_free_cluster *cluster,
+				   struct btrfs_free_space *entry,
 				   u64 bytes, u64 min_start)
 {
-	struct btrfs_free_space *entry;
 	int err;
 	u64 search_start = cluster->window_start;
 	u64 search_bytes = bytes;
 	u64 ret = 0;
 
-	spin_lock(&block_group->tree_lock);
-	spin_lock(&cluster->lock);
-
-	if (!cluster->points_to_bitmap)
-		goto out;
-
-	if (cluster->block_group != block_group)
-		goto out;
-
-	/*
-	 * search_start is the beginning of the bitmap, but at some point it may
-	 * be a good idea to point to the actual start of the free area in the
-	 * bitmap, so do the offset_to_bitmap trick anyway, and set bitmap_only
-	 * to 1 to make sure we get the bitmap entry
-	 */
-	entry = tree_search_offset(block_group,
-				   offset_to_bitmap(block_group, search_start),
-				   1, 0);
-	if (!entry || !entry->bitmap)
-		goto out;
-
 	search_start = min_start;
 	search_bytes = bytes;
 
 	err = search_bitmap(block_group, entry, &search_start,
 			    &search_bytes);
 	if (err)
-		goto out;
+		return 0;
 
 	ret = search_start;
 	bitmap_clear_bits(block_group, entry, ret, bytes);
-	if (entry->bytes == 0)
-		free_bitmap(block_group, entry);
-out:
-	spin_unlock(&cluster->lock);
-	spin_unlock(&block_group->tree_lock);
 
 	return ret;
 }
@@ -1851,10 +1823,6 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 	struct rb_node *node;
 	u64 ret = 0;
 
-	if (cluster->points_to_bitmap)
-		return btrfs_alloc_from_bitmap(block_group, cluster, bytes,
-					       min_start);
-
 	spin_lock(&cluster->lock);
 	if (bytes > cluster->max_size)
 		goto out;
@@ -1867,9 +1835,9 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 		goto out;
 
 	entry = rb_entry(node, struct btrfs_free_space, offset_index);
-
 	while(1) {
-		if (entry->bytes < bytes || entry->offset < min_start) {
+		if (entry->bytes < bytes ||
+		    (!entry->bitmap && entry->offset < min_start)) {
 			struct rb_node *node;
 
 			node = rb_next(&entry->offset_index);
@@ -1879,10 +1847,27 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 					 offset_index);
 			continue;
 		}
-		ret = entry->offset;
 
-		entry->offset += bytes;
-		entry->bytes -= bytes;
+		if (entry->bitmap) {
+			ret = btrfs_alloc_from_bitmap(block_group,
+						      cluster, entry, bytes,
+						      min_start);
+			if (ret == 0) {
+				struct rb_node *node;
+				node = rb_next(&entry->offset_index);
+				if (!node)
+					break;
+				entry = rb_entry(node, struct btrfs_free_space,
+						 offset_index);
+				continue;
+			}
+		} else {
+
+			ret = entry->offset;
+
+			entry->offset += bytes;
+			entry->bytes -= bytes;
+		}
 
 		if (entry->bytes == 0)
 			rb_erase(&entry->offset_index, &cluster->root);
@@ -1899,6 +1884,11 @@ out:
 	block_group->free_space -= bytes;
 	if (entry->bytes == 0) {
 		block_group->free_extents--;
+		if (entry->bitmap) {
+			kfree(entry->bitmap);
+			block_group->total_bitmaps--;
+			recalculate_thresholds(block_group);
+		}
 		kmem_cache_free(btrfs_free_space_cachep, entry);
 	}
 
@@ -1919,6 +1909,7 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 	unsigned long found_bits;
 	unsigned long start = 0;
 	unsigned long total_found = 0;
+	int ret;
 	bool found = false;
 
 	i = offset_to_bit(entry->offset, block_group->sectorsize,
@@ -1941,7 +1932,7 @@ again:
 	}
 
 	if (!found_bits)
-		return -1;
+		return -ENOSPC;
 
 	if (!found) {
 		start = i;
@@ -1965,12 +1956,142 @@ again:
 
 	cluster->window_start = start * block_group->sectorsize +
 		entry->offset;
-	cluster->points_to_bitmap = true;
+	rb_erase(&entry->offset_index, &block_group->free_space_offset);
+	ret = tree_insert_offset(&cluster->root, entry->offset,
+				 &entry->offset_index, 1);
+	BUG_ON(ret);
+
+	return 0;
+}
+
+/*
+ * This searches the block group for just extents to fill the cluster with.
+ */
+static int setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
+				   struct btrfs_free_cluster *cluster,
+				   u64 offset, u64 bytes, u64 min_bytes)
+{
+	struct btrfs_free_space *first = NULL;
+	struct btrfs_free_space *entry = NULL;
+	struct btrfs_free_space *prev = NULL;
+	struct btrfs_free_space *last;
+	struct rb_node *node;
+	u64 window_start;
+	u64 window_free;
+	u64 max_extent;
+	u64 max_gap = 128 * 1024;
+
+	entry = tree_search_offset(block_group, offset, 0, 1);
+	if (!entry)
+		return -ENOSPC;
+
+	/*
+	 * We don't want bitmaps, so just move along until we find a normal
+	 * extent entry.
+	 */
+	while (entry->bitmap) {
+		node = rb_next(&entry->offset_index);
+		if (!node)
+			return -ENOSPC;
+		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+	}
+
+	window_start = entry->offset;
+	window_free = entry->bytes;
+	max_extent = entry->bytes;
+	first = entry;
+	last = entry;
+	prev = entry;
+
+	while (window_free <= min_bytes) {
+		node = rb_next(&entry->offset_index);
+		if (!node)
+			return -ENOSPC;
+		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+
+		if (entry->bitmap)
+			continue;
+		/*
+		 * we haven't filled the empty size and the window is
+		 * very large.  reset and try again
+		 */
+		if (entry->offset - (prev->offset + prev->bytes) > max_gap ||
+		    entry->offset - window_start > (min_bytes * 2)) {
+			first = entry;
+			window_start = entry->offset;
+			window_free = entry->bytes;
+			last = entry;
+			max_extent = entry->bytes;
+		} else {
+			last = entry;
+			window_free += entry->bytes;
+			if (entry->bytes > max_extent)
+				max_extent = entry->bytes;
+		}
+		prev = entry;
+	}
+
+	cluster->window_start = first->offset;
+
+	node = &first->offset_index;
+
+	/*
+	 * now we've found our entries, pull them out of the free space
+	 * cache and put them into the cluster rbtree
+	 */
+	do {
+		int ret;
+
+		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+		node = rb_next(&entry->offset_index);
+		if (entry->bitmap)
+			continue;
+
+		rb_erase(&entry->offset_index, &block_group->free_space_offset);
+		ret = tree_insert_offset(&cluster->root, entry->offset,
+					 &entry->offset_index, 0);
+		BUG_ON(ret);
+	} while (node && entry != last);
+
+	cluster->max_size = max_extent;
 
 	return 0;
 }
 
 /*
+ * This specifically looks for bitmaps that may work in the cluster, we assume
+ * that we have already failed to find extents that will work.
+ */
+static int setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
+				struct btrfs_free_cluster *cluster,
+				u64 offset, u64 bytes, u64 min_bytes)
+{
+	struct btrfs_free_space *entry;
+	struct rb_node *node;
+	int ret = -ENOSPC;
+
+	if (block_group->total_bitmaps == 0)
+		return -ENOSPC;
+
+	entry = tree_search_offset(block_group,
+				   offset_to_bitmap(block_group, offset),
+				   0, 1);
+	node = &entry->offset_index;
+	do {
+		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+		node = rb_next(&entry->offset_index);
+		if (!entry->bitmap)
+			continue;
+		if (entry->bytes < min_bytes)
+			continue;
+		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
+					   bytes, min_bytes);
+	} while (ret && node);
+
+	return ret;
+}
+
+/*
  * here we try to find a cluster of blocks in a block group.  The goal
  * is to find at least bytes free and up to empty_size + bytes free.
  * We might not find them all in one contiguous area.
@@ -1984,15 +2105,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 			     struct btrfs_free_cluster *cluster,
 			     u64 offset, u64 bytes, u64 empty_size)
 {
-	struct btrfs_free_space *entry = NULL;
-	struct rb_node *node;
-	struct btrfs_free_space *next;
-	struct btrfs_free_space *last = NULL;
 	u64 min_bytes;
-	u64 window_start;
-	u64 window_free;
-	u64 max_extent = 0;
-	bool found_bitmap = false;
 	int ret;
 
 	/* for metadata, allow allocates with more holes */
@@ -2029,134 +2142,19 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 		ret = 0;
 		goto out;
 	}
-again:
-	entry = tree_search_offset(block_group, offset, found_bitmap, 1);
-	if (!entry) {
-		ret = -ENOSPC;
-		goto out;
-	}
-
-	/*
-	 * If found_bitmap is true, we exhausted our search for extent entries,
-	 * and we just want to search all of the bitmaps that we can find, and
-	 * ignore any extent entries we find.
-	 */
-	while (entry->bitmap || found_bitmap ||
-	       (!entry->bitmap && entry->bytes < min_bytes)) {
-		struct rb_node *node = rb_next(&entry->offset_index);
-
-		if (entry->bitmap && entry->bytes > bytes + empty_size) {
-			ret = btrfs_bitmap_cluster(block_group, entry, cluster,
-						   offset, bytes, min_bytes);
-			if (!ret)
-				goto got_it;
-		}
-
-		if (!node) {
-			ret = -ENOSPC;
-			goto out;
-		}
-		entry = rb_entry(node, struct btrfs_free_space, offset_index);
-	}
-
-	/*
-	 * We already searched all the extent entries from the passed in offset
-	 * to the end and didn't find enough space for the cluster, and we also
-	 * didn't find any bitmaps that met our criteria, just go ahead and exit
-	 */
-	if (found_bitmap) {
-		ret = -ENOSPC;
-		goto out;
-	}
 
-	cluster->points_to_bitmap = false;
-	window_start = entry->offset;
-	window_free = entry->bytes;
-	last = entry;
-	max_extent = entry->bytes;
-
-	while (1) {
-		/* out window is just right, lets fill it */
-		if (window_free >= min_bytes)
-			break;
-
-		node = rb_next(&last->offset_index);
-		if (!node) {
-			if (found_bitmap)
-				goto again;
-			ret = -ENOSPC;
-			goto out;
-		}
-		next = rb_entry(node, struct btrfs_free_space, offset_index);
-
-		/*
-		 * we found a bitmap, so if this search doesn't result in a
-		 * cluster, we know to go and search again for the bitmaps and
-		 * start looking for space there
-		 */
-		if (next->bitmap) {
-			if (!found_bitmap)
-				offset = next->offset;
-			found_bitmap = true;
-			last = next;
-			continue;
-		}
-
-		/*
-		 * we haven't filled the empty size and the window is
-		 * very large.  reset and try again
-		 */
-		if (next->offset - (last->offset + last->bytes) > 128 * 1024 ||
-		    next->offset - window_start > (bytes + empty_size) * 2) {
-			entry = next;
-			window_start = entry->offset;
-			window_free = entry->bytes;
-			last = entry;
-			max_extent = entry->bytes;
-		} else {
-			last = next;
-			window_free += next->bytes;
-			if (entry->bytes > max_extent)
-				max_extent = entry->bytes;
-		}
-	}
-
-	cluster->window_start = entry->offset;
-
-	/*
-	 * now we've found our entries, pull them out of the free space
-	 * cache and put them into the cluster rbtree
-	 *
-	 * The cluster includes an rbtree, but only uses the offset index
-	 * of each free space cache entry.
-	 */
-	while (1) {
-		node = rb_next(&entry->offset_index);
-		if (entry->bitmap && node) {
-			entry = rb_entry(node, struct btrfs_free_space,
-					 offset_index);
-			continue;
-		} else if (entry->bitmap && !node) {
-			break;
-		}
-
-		rb_erase(&entry->offset_index, &block_group->free_space_offset);
-		ret = tree_insert_offset(&cluster->root, entry->offset,
-					 &entry->offset_index, 0);
-		BUG_ON(ret);
-
-		if (!node || entry == last)
-			break;
+	ret = setup_cluster_no_bitmap(block_group, cluster, offset, bytes,
+				      min_bytes);
+	if (ret)
+		ret = setup_cluster_bitmap(block_group, cluster, offset,
+					   bytes, min_bytes);
 
-		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+	if (!ret) {
+		atomic_inc(&block_group->count);
+		list_add_tail(&cluster->block_group_list,
+			      &block_group->cluster_list);
+		cluster->block_group = block_group;
 	}
-
-	cluster->max_size = max_extent;
-got_it:
-	ret = 0;
-	atomic_inc(&block_group->count);
-	list_add_tail(&cluster->block_group_list, &block_group->cluster_list);
-	cluster->block_group = block_group;
 out:
 	spin_unlock(&cluster->lock);
 	spin_unlock(&block_group->tree_lock);
@@ -2173,7 +2171,6 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 	spin_lock_init(&cluster->refill_lock);
 	cluster->root = RB_ROOT;
 	cluster->max_size = 0;
-	cluster->points_to_bitmap = false;
 	INIT_LIST_HEAD(&cluster->block_group_list);
 	cluster->block_group = NULL;
 }
-- 
1.7.2.3

