From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs: use hybrid extents+bitmap rb tree for free space cache
Date: Tue, 16 Jun 2009 14:05:35 -0400
Message-ID: <1245175535-4596-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs has a problem where it can use a ridiculous amount of RAM simply
tracking free space.  As free space gets fragmented, we end up with thousands of
entries on an rb-tree per block group, which usually spans 1 gig of area.  Since
we currently don't ever flush free space cache back to disk this gets to be a
bit unweildly on large fs's with lots of fragmentation.

This patch solves this problem by using PAGE_SIZE bitmaps for parts of the free
space cache.  Initially we calculate a threshold of extent entries we can
handle, which is however many extent entries we can cram into 16k of ram.  The
maximum amount of RAM that should ever be used to track 1 gigabyte of diskspace
will be 32k of RAM, which scales much better than we did before.

Once we pass the extent threshold, we start adding bitmaps and using those
instead for tracking the free space.  This patch also makes it so that any free
space thats less than 4 * sectorsize we go ahead and put into a bitmap.  This is
nice since we try and allocate out of the front of a block group, so if the
front of a block group is heavily fragmented and then has a huge chunk of free
space at the end, we go ahead and add the fragmented areas to bitmaps and use a
normal extent entry to track the big chunk at the back of the block group.

I've also taken the opportunity to revamp how we search for free space.
Previously we indexed free space via an offset indexed rb tree and a bytes
indexed rb tree.  I've dropped the bytes indexed rb tree and use only the offset
indexed rb tree.  This cuts the number of tree operations we were doing
previously down by half, and gives us a little bit of a better allocation
pattern since we will always start from a specific offset and search forward
from there, instead of searching for the size we need and try and get it as
close as possible to the offset we want.

I've given this a healthy amount of testing pre-new format stuff, as well as
post-new format stuff.  I've booted up my fedora box which is installed on btrfs
with this patch and ran with it for a few days without issues.  I've not seen
any performance regressions in any of my tests.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h            |    8 +-
 fs/btrfs/extent-tree.c      |   25 ++-
 fs/btrfs/free-space-cache.c |  950 ++++++++++++++++++++++++++++++++++---------
 fs/btrfs/free-space-cache.h |    8 +
 4 files changed, 798 insertions(+), 193 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 03441a9..eb6639c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -709,6 +709,9 @@ struct btrfs_free_cluster {
 	/* first extent starting offset */
 	u64 window_start;
 
+	/* if this cluster simply points at a bitmap in the block group */
+	bool points_to_bitmap;
+
 	struct btrfs_block_group_cache *block_group;
 	/*
 	 * when a cluster is allocated from a block group, we put the
@@ -726,6 +729,10 @@ struct btrfs_block_group_cache {
 	u64 pinned;
 	u64 reserved;
 	u64 flags;
+	u64 sectorsize;
+	int extents_thresh;
+	int free_extents;
+	int total_bitmaps;
 	int cached;
 	int ro;
 	int dirty;
@@ -734,7 +741,6 @@ struct btrfs_block_group_cache {
 
 	/* free space cache stuff */
 	spinlock_t tree_lock;
-	struct rb_root free_space_bytes;
 	struct rb_root free_space_offset;
 
 	/* block group cache stuff */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index edc7d20..af9d94b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3638,7 +3638,6 @@ refill_cluster:
 			goto loop;
 checks:
 		search_start = stripe_align(root, offset);
-
 		/* move on to the next group */
 		if (search_start + num_bytes >= search_end) {
 			btrfs_add_free_space(block_group, offset, num_bytes);
@@ -6812,6 +6811,16 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		mutex_init(&cache->cache_mutex);
 		INIT_LIST_HEAD(&cache->list);
 		INIT_LIST_HEAD(&cache->cluster_list);
+		cache->sectorsize = root->sectorsize;
+
+		/*
+		 * we only want to have 32k of ram per block group for keeping
+		 * track of free space, and if we pass 1/2 of that we want to
+		 * start converting things over to using bitmaps
+		 */
+		cache->extents_thresh = ((1024 * 32) / 2) /
+			sizeof(struct btrfs_free_space);
+
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
 				   sizeof(cache->item));
@@ -6863,6 +6872,15 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->key.objectid = chunk_offset;
 	cache->key.offset = size;
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	cache->sectorsize = root->sectorsize;
+
+	/*
+	 * we only want to have 32k of ram per block group for keeping track
+	 * of free space, and if we pass 1/2 of that we want to start
+	 * converting things over to using bitmaps
+	 */
+	cache->extents_thresh = ((1024 * 32) / 2) /
+		sizeof(struct btrfs_free_space);
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
 	spin_lock_init(&cache->tree_lock);
@@ -6875,6 +6893,11 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
+	cache->cached = 1;
+	ret = btrfs_add_free_space(cache, chunk_offset, size);
+	BUG_ON(ret);
+	remove_sb_from_cache(root, cache);
+
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4538e48..b16c753 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -16,58 +16,80 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/pagemap.h>
 #include <linux/sched.h>
+#include <linux/math64.h>
 #include "ctree.h"
 #include "free-space-cache.h"
 #include "transaction.h"
 
-struct btrfs_free_space {
-	struct rb_node bytes_index;
-	struct rb_node offset_index;
-	u64 offset;
-	u64 bytes;
-};
+#define BITS_PER_BITMAP		(PAGE_CACHE_SIZE * 8)
+#define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
 
-static int tree_insert_offset(struct rb_root *root, u64 offset,
-			      struct rb_node *node)
+static inline unsigned long offset_to_bit(u64 bitmap_start, u64 sectorsize,
+					  u64 offset)
 {
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct btrfs_free_space *info;
+	offset -= bitmap_start;
+	return (unsigned long)(div64_u64(offset, sectorsize));
+}
 
-	while (*p) {
-		parent = *p;
-		info = rb_entry(parent, struct btrfs_free_space, offset_index);
+static inline unsigned long bytes_to_bits(u64 bytes, u64 sectorsize)
+{
+	return (unsigned long)(div64_u64(bytes, sectorsize));
+}
 
-		if (offset < info->offset)
-			p = &(*p)->rb_left;
-		else if (offset > info->offset)
-			p = &(*p)->rb_right;
-		else
-			return -EEXIST;
-	}
+static inline u64 offset_to_bitmap(struct btrfs_block_group_cache *block_group,
+				   u64 offset)
+{
+	u64 bytes_per_bitmap;	/* number of bytes that span a bitmap */
+	u64 bitmap_start;	/* the byte offset where this bitmap starts */
+	u64 bits_per_bg;	/* number of bits required to describe the
+				   entire blockgroup in a bitmap */
+	int max_bitmaps, i;
 
-	rb_link_node(node, parent, p);
-	rb_insert_color(node, root);
+	bits_per_bg = div64_u64(block_group->key.offset,
+				   block_group->sectorsize);
+	max_bitmaps = (int)(div64_u64(bits_per_bg, BITS_PER_BITMAP));
 
-	return 0;
+	BUG_ON(block_group->total_bitmaps > max_bitmaps);
+
+	bytes_per_bitmap = BITS_PER_BITMAP * block_group->sectorsize;
+
+	bitmap_start = block_group->key.objectid;
+	for (i = 0; i < max_bitmaps; i++) {
+		if (bitmap_start <= offset &&
+		    offset < bitmap_start + bytes_per_bitmap)
+			break;
+		bitmap_start += bytes_per_bitmap;
+	}
+
+	return bitmap_start;
 }
 
-static int tree_insert_bytes(struct rb_root *root, u64 bytes,
-			     struct rb_node *node)
+static int tree_insert_offset(struct rb_root *root, u64 offset,
+			      struct rb_node *node, int bitmap)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct btrfs_free_space *info;
+	bool existing = false;
 
 	while (*p) {
 		parent = *p;
-		info = rb_entry(parent, struct btrfs_free_space, bytes_index);
+		info = rb_entry(parent, struct btrfs_free_space, offset_index);
 
-		if (bytes < info->bytes)
+		if (offset < info->offset) {
 			p = &(*p)->rb_left;
-		else
+		} else if (offset > info->offset) {
 			p = &(*p)->rb_right;
+		} else {
+			WARN_ON(existing);
+			if (info->bitmap)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+			existing = true;
+		}
 	}
 
 	rb_link_node(node, parent, p);
@@ -79,110 +101,86 @@ static int tree_insert_bytes(struct rb_root *root, u64 bytes,
 /*
  * searches the tree for the given offset.
  *
- * fuzzy == 1: this is used for allocations where we are given a hint of where
- * to look for free space.  Because the hint may not be completely on an offset
- * mark, or the hint may no longer point to free space we need to fudge our
- * results a bit.  So we look for free space starting at or after offset with at
- * least bytes size.  We prefer to find as close to the given offset as we can.
- * Also if the offset is within a free space range, then we will return the free
- * space that contains the given offset, which means we can return a free space
- * chunk with an offset before the provided offset.
- *
- * fuzzy == 0: this is just a normal tree search.  Give us the free space that
- * starts at the given offset which is at least bytes size, and if its not there
- * return NULL.
+ * fuzzy - If this is set, then we are trying to make an allocation, and we just
+ * want a section that has at least bytes size and comes at or after the given
+ * offset.
  */
-static struct btrfs_free_space *tree_search_offset(struct rb_root *root,
-						   u64 offset, u64 bytes,
-						   int fuzzy)
+static struct btrfs_free_space *
+tree_search_offset(struct btrfs_block_group_cache *block_group,
+		   u64 offset, u64 bytes, int fuzzy)
 {
-	struct rb_node *n = root->rb_node;
+	struct rb_node *n = block_group->free_space_offset.rb_node;
 	struct btrfs_free_space *entry, *ret = NULL;
 
 	while (n) {
 		entry = rb_entry(n, struct btrfs_free_space, offset_index);
 
 		if (offset < entry->offset) {
+			/*
+			 * If fuzzy is set, and this entry is to the left of the
+			 * offset we are looking for, and if we haven't found a
+			 * suitable entry yet or this entry is closer to the
+			 * offset we are looking for and is the appropriate
+			 * size, then set the return value to this entry, and
+			 * keep looking for a better match.
+			 */
 			if (fuzzy &&
 			    (!ret || entry->offset < ret->offset) &&
 			    (bytes <= entry->bytes))
 				ret = entry;
 			n = n->rb_left;
 		} else if (offset > entry->offset) {
-			if (fuzzy &&
-			    (entry->offset + entry->bytes - 1) >= offset &&
-			    bytes <= entry->bytes) {
-				ret = entry;
-				break;
-			}
 			n = n->rb_right;
-		} else {
-			if (bytes > entry->bytes) {
-				n = n->rb_right;
+			if (entry->bytes < bytes)
 				continue;
-			}
-			ret = entry;
-			break;
-		}
-	}
 
-	return ret;
-}
-
-/*
- * return a chunk at least bytes size, as close to offset that we can get.
- */
-static struct btrfs_free_space *tree_search_bytes(struct rb_root *root,
-						  u64 offset, u64 bytes)
-{
-	struct rb_node *n = root->rb_node;
-	struct btrfs_free_space *entry, *ret = NULL;
-
-	while (n) {
-		entry = rb_entry(n, struct btrfs_free_space, bytes_index);
-
-		if (bytes < entry->bytes) {
 			/*
-			 * We prefer to get a hole size as close to the size we
-			 * are asking for so we don't take small slivers out of
-			 * huge holes, but we also want to get as close to the
-			 * offset as possible so we don't have a whole lot of
-			 * fragmentation.
+			 * if this entry is a bitmap, see if the offset falls
+			 * within the bitmap, if not just keep going
 			 */
-			if (offset <= entry->offset) {
-				if (!ret)
-					ret = entry;
-				else if (entry->bytes < ret->bytes)
-					ret = entry;
-				else if (entry->offset < ret->offset)
-					ret = entry;
-			}
-			n = n->rb_left;
-		} else if (bytes > entry->bytes) {
-			n = n->rb_right;
-		} else {
+			if (entry->bitmap &&
+			    (entry->offset + BITS_PER_BITMAP *
+			     block_group->sectorsize - 1) < offset)
+				continue;
+
 			/*
-			 * Ok we may have multiple chunks of the wanted size,
-			 * so we don't want to take the first one we find, we
-			 * want to take the one closest to our given offset, so
-			 * keep searching just in case theres a better match.
+			 * ok this entry isn't a bitmap, so if the offset
+			 * doesn't fall within this extent, keep going
 			 */
-			n = n->rb_right;
-			if (offset > entry->offset)
+			if (!entry->bitmap &&
+			    entry->offset + entry->bytes - 1 < offset)
 				continue;
-			else if (!ret || entry->offset < ret->offset)
+
+			/*
+			 * this is tricky, since bitmaps will span large
+			 * sections, we can have extent entries for
+			 * different parts of that same area.  Basically if we
+			 * are a bitmap, we want to set ret and keep looking for
+			 * a better match.  If this is an extent then we are
+			 * gold, and can go ahead and exit
+			 */
+			ret = entry;
+			if (!fuzzy || !entry->bitmap)
+				break;
+			continue;
+		} else {
+			if (bytes <= entry->bytes) {
 				ret = entry;
+				break;
+			}
+			n = n->rb_right;
 		}
 	}
 
 	return ret;
 }
 
+
 static void unlink_free_space(struct btrfs_block_group_cache *block_group,
 			      struct btrfs_free_space *info)
 {
 	rb_erase(&info->offset_index, &block_group->free_space_offset);
-	rb_erase(&info->bytes_index, &block_group->free_space_bytes);
+	block_group->free_extents--;
 }
 
 static int link_free_space(struct btrfs_block_group_cache *block_group,
@@ -190,17 +188,345 @@ static int link_free_space(struct btrfs_block_group_cache *block_group,
 {
 	int ret = 0;
 
-
-	BUG_ON(!info->bytes);
+	BUG_ON(!info->bitmap && !info->bytes);
 	ret = tree_insert_offset(&block_group->free_space_offset, info->offset,
-				 &info->offset_index);
+				 &info->offset_index, (info->bitmap != NULL));
 	if (ret)
 		return ret;
 
-	ret = tree_insert_bytes(&block_group->free_space_bytes, info->bytes,
-				&info->bytes_index);
-	if (ret)
-		return ret;
+	block_group->free_extents++;
+	return ret;
+}
+
+static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
+{
+	u64 max_bytes, possible_bytes;
+
+	/*
+	 * The goal is to keep the total amount of memory used per 1gb of space
+	 * at or below 32k, so we need to adjust how much memory we allow to be
+	 * used by extent based free space tracking
+	 */
+	max_bytes = MAX_CACHE_BYTES_PER_GIG *
+		(div64_u64(block_group->key.offset, 1024 * 1024 * 1024));
+
+	possible_bytes = (block_group->total_bitmaps * PAGE_CACHE_SIZE) +
+		(sizeof(struct btrfs_free_space) *
+		 block_group->extents_thresh);
+
+	if (possible_bytes > max_bytes) {
+		int extent_bytes = max_bytes -
+			(block_group->total_bitmaps * PAGE_CACHE_SIZE);
+
+		if (extent_bytes <= 0) {
+			block_group->extents_thresh = 0;
+			return;
+		}
+
+		block_group->extents_thresh = extent_bytes /
+			(sizeof(struct btrfs_free_space));
+	}
+}
+
+static void bitmap_clear_bits(struct btrfs_free_space *info, u64 offset, u64 bytes,
+			      u64 sectorsize)
+{
+	unsigned long start, end;
+	unsigned long i;
+
+	start = offset_to_bit(info->offset, sectorsize, offset);
+	end = start + bytes_to_bits(bytes, sectorsize);
+	BUG_ON(end > BITS_PER_BITMAP);
+
+	for (i = start; i < end; i++)
+		clear_bit(i, info->bitmap);
+
+	info->bytes -= bytes;
+}
+
+static void bitmap_set_bits(struct btrfs_free_space *info, u64 offset, u64 bytes,
+			    u64 sectorsize)
+{
+	unsigned long start, end;
+	unsigned long i;
+
+	start = offset_to_bit(info->offset, sectorsize, offset);
+	end = start + bytes_to_bits(bytes, sectorsize);
+	BUG_ON(end > BITS_PER_BITMAP);
+
+	for (i = start; i < end; i++)
+		set_bit(i, info->bitmap);
+
+	info->bytes += bytes;
+}
+
+static int search_bitmap(struct btrfs_block_group_cache *block_group,
+			 struct btrfs_free_space *bitmap_info, u64 *offset,
+			 u64 *bytes)
+{
+	unsigned long found_bits = 0;
+	unsigned long bits, i;
+	unsigned long next_zero;
+
+	i = offset_to_bit(bitmap_info->offset, block_group->sectorsize,
+			  *offset);
+	bits = bytes_to_bits(*bytes, block_group->sectorsize);
+
+	for (i = find_next_bit(bitmap_info->bitmap, BITS_PER_BITMAP, i);
+	     i < BITS_PER_BITMAP;
+	     i = find_next_bit(bitmap_info->bitmap, BITS_PER_BITMAP, i + 1)) {
+		next_zero = find_next_zero_bit(bitmap_info->bitmap,
+					       BITS_PER_BITMAP, i);
+		if ((next_zero - i) >= bits) {
+			found_bits = next_zero - i;
+			break;
+		}
+		i = next_zero;
+	}
+
+	if (found_bits) {
+		*offset = (u64)(i * block_group->sectorsize) +
+			bitmap_info->offset;
+		*bytes = (u64)(found_bits) * block_group->sectorsize;
+		return 0;
+	}
+
+	return -1;
+}
+
+static struct btrfs_free_space *find_free_space(struct btrfs_block_group_cache
+						*block_group, u64 *offset,
+						u64 *bytes, int debug)
+{
+	struct btrfs_free_space *entry;
+	struct rb_node *node;
+	int ret;
+	bool found = false;
+
+	if (!block_group->free_space_offset.rb_node)
+		return NULL;
+
+	entry = tree_search_offset(block_group, *offset, *bytes, 1);
+	if (!entry)
+		entry = tree_search_offset(block_group,
+					   offset_to_bitmap(block_group,
+							    *offset),
+					   *bytes, 1);
+
+	if (entry)
+		found = true;
+	else
+		entry = rb_entry(block_group->free_space_offset.rb_node,
+				 struct btrfs_free_space, offset_index);
+
+	/* we found a normal extent and its big enough, return it */
+	if (found && !entry->bitmap && entry->bytes >= *bytes) {
+		*offset = entry->offset;
+		*bytes = entry->bytes;
+		return entry;
+	}
+
+	/*
+	 * we found a bitmap, and it appears to have enough space in it, search
+	 * it to make sure and get the actual offset/bytes, and return it if it
+	 * is the right size
+	 */
+	if (found && entry->bitmap && entry->bytes >= *bytes) {
+		ret = search_bitmap(block_group, entry, offset, bytes);
+		if (!ret)
+			return entry;
+	}
+
+	for (node = rb_next(&entry->offset_index); node;
+	     node = rb_next(node)) {
+		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+		if (entry->bytes < *bytes)
+			continue;
+
+		if (entry->bitmap) {
+			ret = search_bitmap(block_group, entry, offset, bytes);
+			if (!ret)
+				return entry;
+			continue;
+		}
+
+		*offset = entry->offset;
+		*bytes = entry->bytes;
+		return entry;
+	}
+
+	return NULL;
+}
+
+static void add_new_bitmap(struct btrfs_block_group_cache *block_group,
+			   struct btrfs_free_space *info, u64 offset)
+{
+	info->offset = offset_to_bitmap(block_group, offset);
+	link_free_space(block_group, info);
+	block_group->total_bitmaps++;
+
+	recalculate_thresholds(block_group);
+}
+
+static noinline int remove_from_bitmap(struct btrfs_block_group_cache *block_group,
+			      struct btrfs_free_space *bitmap_info,
+			      u64 *offset, u64 *bytes)
+{
+	u64 end;
+
+again:
+	end = bitmap_info->offset +
+		(u64)(BITS_PER_BITMAP * block_group->sectorsize) - 1;
+
+	if (*offset > bitmap_info->offset && *offset + *bytes > end) {
+		bitmap_clear_bits(bitmap_info, *offset,
+				  end - *offset + 1, block_group->sectorsize);
+		*bytes -= end - *offset + 1;
+		*offset = end + 1;
+	} else if (*offset >= bitmap_info->offset && *offset + *bytes <= end) {
+		bitmap_clear_bits(bitmap_info, *offset,
+				  *bytes, block_group->sectorsize);
+		*bytes = 0;
+	}
+
+	if (*bytes) {
+		if (!bitmap_info->bytes) {
+			unlink_free_space(block_group, bitmap_info);
+			kfree(bitmap_info->bitmap);
+			kfree(bitmap_info);
+			block_group->total_bitmaps--;
+			recalculate_thresholds(block_group);
+		}
+
+		bitmap_info = tree_search_offset(block_group,
+						 offset_to_bitmap(block_group,
+								  *offset),
+						 0, 0);
+		if (!bitmap_info)
+			return -EINVAL;
+
+		if (!bitmap_info->bitmap)
+			return -EAGAIN;
+
+		goto again;
+	} else if (!bitmap_info->bytes) {
+		unlink_free_space(block_group, bitmap_info);
+		kfree(bitmap_info->bitmap);
+		kfree(bitmap_info);
+		block_group->total_bitmaps--;
+		recalculate_thresholds(block_group);
+	}
+
+	return 0;
+}
+
+static int insert_into_bitmap(struct btrfs_block_group_cache *block_group,
+			      struct btrfs_free_space *info)
+{
+	struct btrfs_free_space *bitmap_info;
+	int added = 0;
+	u64 bytes, offset, end;
+	int ret;
+
+	/*
+	 * If we are below the extents threshold then we can add this as an
+	 * extent, and don't have to deal with the bitmap
+	 */
+	if (block_group->free_extents < block_group->extents_thresh &&
+	    info->bytes > block_group->sectorsize * 4)
+		return 0;
+
+	/*
+	 * some block groups are so tiny they can't be enveloped by a bitmap, so
+	 * don't even bother to create a bitmap for this
+	 */
+	if (BITS_PER_BITMAP * block_group->sectorsize >
+	    block_group->key.offset)
+		return 0;
+
+	bytes = info->bytes;
+	offset = info->offset;
+
+again:
+	bitmap_info = tree_search_offset(block_group,
+					 offset_to_bitmap(block_group, offset),
+					 0, 0);
+	if (!bitmap_info) {
+		BUG_ON(added);
+		goto new_bitmap;
+	}
+
+	if (!bitmap_info->bitmap) {
+		struct rb_node *n = rb_next(&bitmap_info->offset_index);
+
+		if (!n)
+			goto new_bitmap;
+
+		bitmap_info = rb_entry(n, struct btrfs_free_space,
+				       offset_index);
+		if (!bitmap_info->bitmap)
+			goto new_bitmap;
+	}
+
+	end = bitmap_info->offset +
+		(u64)(BITS_PER_BITMAP * block_group->sectorsize - 1);
+
+	if (offset >= bitmap_info->offset && offset + bytes > end) {
+		bitmap_set_bits(bitmap_info, offset, end - offset + 1,
+				block_group->sectorsize);
+		bytes -= end - offset + 1;
+		offset = end + 1;
+		added = 0;
+	} else if (offset >= bitmap_info->offset && offset + bytes <= end) {
+		bitmap_set_bits(bitmap_info, offset, bytes,
+				block_group->sectorsize);
+		bytes = 0;
+	} else {
+		BUG();
+	}
+
+	if (!bytes) {
+		ret = 1;
+		goto out;
+	} else
+		goto again;
+
+new_bitmap:
+	if (info && info->bitmap) {
+		add_new_bitmap(block_group, info, offset);
+		added = 1;
+		info = NULL;
+		goto again;
+	} else {
+		spin_unlock(&block_group->tree_lock);
+
+		/* no pre-allocated info, allocate a new one */
+		if (!info) {
+			info = kzalloc(sizeof(struct btrfs_free_space),
+				       GFP_NOFS);
+			if (!info) {
+				spin_lock(&block_group->tree_lock);
+				ret = -ENOMEM;
+				goto out;
+			}
+		}
+
+		/* allocate the bitmap */
+		info->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
+		spin_lock(&block_group->tree_lock);
+		if (!info->bitmap) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		goto again;
+	}
+
+out:
+	if (info) {
+		if (info->bitmap)
+			kfree(info->bitmap);
+		kfree(info);
+	}
 
 	return ret;
 }
@@ -208,8 +534,8 @@ static int link_free_space(struct btrfs_block_group_cache *block_group,
 int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 			 u64 offset, u64 bytes)
 {
-	struct btrfs_free_space *right_info;
-	struct btrfs_free_space *left_info;
+	struct btrfs_free_space *right_info = NULL;
+	struct btrfs_free_space *left_info = NULL;
 	struct btrfs_free_space *info = NULL;
 	int ret = 0;
 
@@ -227,18 +553,38 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	 * are adding, if there is remove that struct and add a new one to
 	 * cover the entire range
 	 */
-	right_info = tree_search_offset(&block_group->free_space_offset,
-					offset+bytes, 0, 0);
-	left_info = tree_search_offset(&block_group->free_space_offset,
-				       offset-1, 0, 1);
+	right_info = tree_search_offset(block_group, offset + bytes, 0, 0);
+	if (right_info)
+		left_info = rb_entry(rb_prev(&right_info->offset_index),
+				     struct btrfs_free_space, offset_index);
+	else if (!right_info)
+		left_info = tree_search_offset(block_group, offset - 1, 0, 0);
 
-	if (right_info) {
+	/*
+	 * If there was no extent directly to the left or right of this new
+	 * extent then we know we're going to have to allocate a new extent, so
+	 * before we do that see if we need to drop this into a bitmap
+	 */
+	if ((!left_info || left_info->bitmap) &&
+	    (!right_info || right_info->bitmap)) {
+		ret = insert_into_bitmap(block_group, info);
+
+		if (ret < 0) {
+			goto out;
+		} else if (ret) {
+			ret = 0;
+			goto out;
+		}
+	}
+
+	if (right_info && !right_info->bitmap) {
 		unlink_free_space(block_group, right_info);
 		info->bytes += right_info->bytes;
 		kfree(right_info);
 	}
 
-	if (left_info && left_info->offset + left_info->bytes == offset) {
+	if (left_info && !left_info->bitmap &&
+	    left_info->offset + left_info->bytes == offset) {
 		unlink_free_space(block_group, left_info);
 		info->offset = left_info->offset;
 		info->bytes += left_info->bytes;
@@ -248,11 +594,11 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	ret = link_free_space(block_group, info);
 	if (ret)
 		kfree(info);
-
+out:
 	spin_unlock(&block_group->tree_lock);
 
 	if (ret) {
-		printk(KERN_ERR "btrfs: unable to add free space :%d\n", ret);
+		printk(KERN_CRIT "btrfs: unable to add free space :%d\n", ret);
 		BUG_ON(ret == -EEXIST);
 	}
 
@@ -263,39 +609,62 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			    u64 offset, u64 bytes)
 {
 	struct btrfs_free_space *info;
+	struct btrfs_free_space *next_info = NULL;
 	int ret = 0;
 
 	spin_lock(&block_group->tree_lock);
 
-	info = tree_search_offset(&block_group->free_space_offset, offset, 0,
-				  1);
-	if (info && info->offset == offset) {
-		if (info->bytes < bytes) {
-			printk(KERN_ERR "Found free space at %llu, size %llu,"
-			       "trying to use %llu\n",
-			       (unsigned long long)info->offset,
-			       (unsigned long long)info->bytes,
-			       (unsigned long long)bytes);
+again:
+	info = tree_search_offset(block_group, offset, 0, 0);
+	if (!info) {
+		info = tree_search_offset(block_group,
+					  offset_to_bitmap(block_group,
+							   offset),
+					  0, 0);
+		if (!info) {
 			WARN_ON(1);
-			ret = -EINVAL;
-			spin_unlock(&block_group->tree_lock);
-			goto out;
+			goto out_lock;
 		}
-		unlink_free_space(block_group, info);
+	}
 
-		if (info->bytes == bytes) {
-			kfree(info);
-			spin_unlock(&block_group->tree_lock);
-			goto out;
+	if (info->bytes < bytes && rb_next(&info->offset_index)) {
+		u64 end;
+		next_info = rb_entry(rb_next(&info->offset_index),
+					     struct btrfs_free_space,
+					     offset_index);
+
+		if (next_info->bitmap)
+			end = next_info->offset + BITS_PER_BITMAP *
+				block_group->sectorsize - 1;
+		else
+			end = next_info->offset + next_info->bytes;
+
+		if (next_info->bytes < bytes ||
+		    next_info->offset > offset || offset > end) {
+			printk(KERN_CRIT "Found free space at %llu, size %llu,"
+			      " trying to use %llu\n",
+			      (unsigned long long)info->offset,
+			      (unsigned long long)info->bytes,
+			      (unsigned long long)bytes);
+			WARN_ON(1);
+			ret = -EINVAL;
+			goto out_lock;
 		}
 
+		info = next_info;
+	}
+
+	if (info->bytes == bytes) {
+		unlink_free_space(block_group, info);
+		kfree(info);
+		goto out_lock;
+	}
+
+	if (!info->bitmap && info->offset == offset) {
 		info->offset += bytes;
 		info->bytes -= bytes;
-
-		ret = link_free_space(block_group, info);
-		spin_unlock(&block_group->tree_lock);
-		BUG_ON(ret);
-	} else if (info && info->offset < offset &&
+		goto out_lock;
+	} else if (!info->bitmap && info->offset < offset &&
 		   info->offset + info->bytes >= offset + bytes) {
 		u64 old_start = info->offset;
 		/*
@@ -312,7 +681,9 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			info->offset = offset + bytes;
 			info->bytes = old_end - info->offset;
 			ret = link_free_space(block_group, info);
-			BUG_ON(ret);
+			WARN_ON(ret);
+			if (ret)
+				goto out_lock;
 		} else {
 			/* the hole we're creating ends at the end
 			 * of the info struct, just free the info
@@ -320,32 +691,22 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			kfree(info);
 		}
 		spin_unlock(&block_group->tree_lock);
+
 		/* step two, insert a new info struct to cover anything
 		 * before the hole
 		 */
 		ret = btrfs_add_free_space(block_group, old_start,
 					   offset - old_start);
-		BUG_ON(ret);
-	} else {
-		spin_unlock(&block_group->tree_lock);
-		if (!info) {
-			printk(KERN_ERR "couldn't find space %llu to free\n",
-			       (unsigned long long)offset);
-			printk(KERN_ERR "cached is %d, offset %llu bytes %llu\n",
-			       block_group->cached,
-			       (unsigned long long)block_group->key.objectid,
-			       (unsigned long long)block_group->key.offset);
-			btrfs_dump_free_space(block_group, bytes);
-		} else if (info) {
-			printk(KERN_ERR "hmm, found offset=%llu bytes=%llu, "
-			       "but wanted offset=%llu bytes=%llu\n",
-			       (unsigned long long)info->offset,
-			       (unsigned long long)info->bytes,
-			       (unsigned long long)offset,
-			       (unsigned long long)bytes);
-		}
-		WARN_ON(1);
+		WARN_ON(ret);
+		goto out;
 	}
+
+	ret = remove_from_bitmap(block_group, info, &offset, &bytes);
+	if (ret == -EAGAIN)
+		goto again;
+	BUG_ON(ret);
+out_lock:
+	spin_unlock(&block_group->tree_lock);
 out:
 	return ret;
 }
@@ -361,10 +722,13 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 		info = rb_entry(n, struct btrfs_free_space, offset_index);
 		if (info->bytes >= bytes)
 			count++;
-		printk(KERN_ERR "entry offset %llu, bytes %llu\n",
+		printk(KERN_CRIT "entry offset %llu, bytes %llu, bitmap %s\n",
 		       (unsigned long long)info->offset,
-		       (unsigned long long)info->bytes);
+		       (unsigned long long)info->bytes,
+		       (info->bitmap) ? "yes" : "no");
 	}
+	printk(KERN_INFO "block group has cluster?: %s\n",
+	       list_empty(&block_group->cluster_list) ? "no" : "yes");
 	printk(KERN_INFO "%d blocks of free space at or bigger than bytes is"
 	       "\n", count);
 }
@@ -397,26 +761,35 @@ __btrfs_return_cluster_to_free_space(
 {
 	struct btrfs_free_space *entry;
 	struct rb_node *node;
+	bool bitmap;
 
 	spin_lock(&cluster->lock);
 	if (cluster->block_group != block_group)
 		goto out;
 
+	bitmap = cluster->points_to_bitmap;
+	cluster->block_group = NULL;
 	cluster->window_start = 0;
+	list_del_init(&cluster->block_group_list);
+	cluster->points_to_bitmap = false;
+
+	if (bitmap)
+		goto out;
+
 	node = rb_first(&cluster->root);
-	while(node) {
+	while (node) {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 		node = rb_next(&entry->offset_index);
 		rb_erase(&entry->offset_index, &cluster->root);
-		link_free_space(block_group, entry);
+		BUG_ON(entry->bitmap);
+		tree_insert_offset(&block_group->free_space_offset,
+				   entry->offset, &entry->offset_index, 0);
 	}
-	list_del_init(&cluster->block_group_list);
-
-	btrfs_put_block_group(cluster->block_group);
-	cluster->block_group = NULL;
 	cluster->root.rb_node = NULL;
+
 out:
 	spin_unlock(&cluster->lock);
+	btrfs_put_block_group(block_group);
 	return 0;
 }
 
@@ -425,20 +798,28 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 	struct btrfs_free_space *info;
 	struct rb_node *node;
 	struct btrfs_free_cluster *cluster;
-	struct btrfs_free_cluster *safe;
+	struct list_head *head;
 
 	spin_lock(&block_group->tree_lock);
-
-	list_for_each_entry_safe(cluster, safe, &block_group->cluster_list,
-				 block_group_list) {
+	while ((head = block_group->cluster_list.next) !=
+	       &block_group->cluster_list) {
+		cluster = list_entry(head, struct btrfs_free_cluster,
+				     block_group_list);
 
 		WARN_ON(cluster->block_group != block_group);
 		__btrfs_return_cluster_to_free_space(block_group, cluster);
+		if (need_resched()) {
+			spin_unlock(&block_group->tree_lock);
+			cond_resched();
+			spin_lock(&block_group->tree_lock);
+		}
 	}
 
-	while ((node = rb_last(&block_group->free_space_bytes)) != NULL) {
-		info = rb_entry(node, struct btrfs_free_space, bytes_index);
+	while ((node = rb_last(&block_group->free_space_offset)) != NULL) {
+		info = rb_entry(node, struct btrfs_free_space, offset_index);
 		unlink_free_space(block_group, info);
+		if (info->bitmap)
+			kfree(info->bitmap);
 		kfree(info);
 		if (need_resched()) {
 			spin_unlock(&block_group->tree_lock);
@@ -446,6 +827,7 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 			spin_lock(&block_group->tree_lock);
 		}
 	}
+
 	spin_unlock(&block_group->tree_lock);
 }
 
@@ -453,27 +835,37 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 			       u64 offset, u64 bytes, u64 empty_size)
 {
 	struct btrfs_free_space *entry = NULL;
+	u64 bytes_search = bytes + empty_size;
 	u64 ret = 0;
 
 	spin_lock(&block_group->tree_lock);
-	entry = tree_search_offset(&block_group->free_space_offset, offset,
-				   bytes + empty_size, 1);
+	entry = find_free_space(block_group, &offset, &bytes_search, 0);
 	if (!entry)
-		entry = tree_search_bytes(&block_group->free_space_bytes,
-					  offset, bytes + empty_size);
-	if (entry) {
-		unlink_free_space(block_group, entry);
-		ret = entry->offset;
+		goto out;
+
+	ret = offset;
+	if (entry->bitmap) {
+		bitmap_clear_bits(entry, offset, bytes,
+				  block_group->sectorsize);
+		if (!entry->bytes) {
+			unlink_free_space(block_group, entry);
+			kfree(entry->bitmap);
+			kfree(entry);
+			block_group->total_bitmaps--;
+			recalculate_thresholds(block_group);
+		}
+	} else {
 		entry->offset += bytes;
 		entry->bytes -= bytes;
 
-		if (!entry->bytes)
+		if (!entry->bytes) {
+			unlink_free_space(block_group, entry);
 			kfree(entry);
-		else
-			link_free_space(block_group, entry);
+		}
 	}
-	spin_unlock(&block_group->tree_lock);
 
+out:
+	spin_unlock(&block_group->tree_lock);
 	return ret;
 }
 
@@ -517,6 +909,59 @@ int btrfs_return_cluster_to_free_space(
 	return ret;
 }
 
+static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
+				   struct btrfs_free_cluster *cluster,
+				   u64 bytes, u64 min_start)
+{
+	struct btrfs_free_space *entry;
+	int err;
+	u64 search_start = cluster->window_start;
+	u64 search_bytes = bytes;
+	u64 ret = 0;
+
+	spin_lock(&block_group->tree_lock);
+	spin_lock(&cluster->lock);
+
+	if (!cluster->points_to_bitmap)
+		goto out;
+
+	if (cluster->block_group != block_group)
+		goto out;
+
+	entry = tree_search_offset(block_group, search_start, 0, 0);
+
+	if (!entry)
+		goto out;
+
+	if (!entry->bitmap) {
+		struct rb_node *n = rb_next(&entry->offset_index);
+
+		if (!n)
+			goto out;
+
+		entry = rb_entry(n, struct btrfs_free_space, offset_index);
+		if (!entry->bitmap || entry->offset != cluster->window_start)
+			goto out;
+		search_start = 0;
+	}
+
+	search_start = min_start;
+	search_bytes = bytes;
+
+	err = search_bitmap(block_group, entry, &search_start,
+			    &search_bytes);
+	if (err)
+		goto out;
+
+	ret = search_start;
+	bitmap_clear_bits(entry, ret, bytes, block_group->sectorsize);
+out:
+	spin_unlock(&block_group->tree_lock);
+	spin_unlock(&cluster->lock);
+
+	return ret;
+}
+
 /*
  * given a cluster, try to allocate 'bytes' from it, returns 0
  * if it couldn't find anything suitably large, or a logical disk offset
@@ -530,6 +975,10 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 	struct rb_node *node;
 	u64 ret = 0;
 
+	if (cluster->points_to_bitmap)
+		return btrfs_alloc_from_bitmap(block_group, cluster, bytes,
+					       min_start);
+
 	spin_lock(&cluster->lock);
 	if (bytes > cluster->max_size)
 		goto out;
@@ -567,9 +1016,73 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 	}
 out:
 	spin_unlock(&cluster->lock);
+
 	return ret;
 }
 
+static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
+				struct btrfs_free_space *entry,
+				struct btrfs_free_cluster *cluster,
+				u64 offset, u64 bytes, u64 min_bytes)
+{
+	unsigned long next_zero;
+	unsigned long i;
+	unsigned long search_bits;
+	unsigned long total_bits;
+	unsigned long found_bits;
+	unsigned long start = 0;
+	unsigned long total_found = 0;
+	bool found = false;
+
+	i = offset_to_bit(entry->offset, block_group->sectorsize,
+			  offset);
+	search_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
+	total_bits = bytes_to_bits(bytes, block_group->sectorsize);
+
+again:
+	found_bits = 0;
+	for (i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, i);
+	     i < BITS_PER_BITMAP;
+	     i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, i + 1)) {
+		next_zero = find_next_zero_bit(entry->bitmap,
+					       BITS_PER_BITMAP, i);
+		if ((next_zero - 1) >= search_bits) {
+			found_bits = next_zero - i;
+			break;
+		}
+		i = next_zero;
+	}
+
+	if (!found_bits)
+		return -1;
+
+	if (!found) {
+		start = i;
+		found = true;
+	}
+
+	total_found += found_bits;
+
+	if (cluster->max_size < found_bits * block_group->sectorsize)
+		cluster->max_size = found_bits * block_group->sectorsize;
+
+	if (total_found < total_bits) {
+		i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
+		if (i - start > total_bits * 2) {
+			total_found = 0;
+			cluster->max_size = 0;
+			found = false;
+		}
+		goto again;
+	}
+
+	cluster->window_start = start * block_group->sectorsize +
+		entry->offset;
+	cluster->points_to_bitmap = true;
+
+	return 0;
+}
+
 /*
  * here we try to find a cluster of blocks in a block group.  The goal
  * is to find at least bytes free and up to empty_size + bytes free.
@@ -587,12 +1100,13 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	struct btrfs_free_space *entry = NULL;
 	struct rb_node *node;
 	struct btrfs_free_space *next;
-	struct btrfs_free_space *last;
+	struct btrfs_free_space *last = NULL;
 	u64 min_bytes;
 	u64 window_start;
 	u64 window_free;
 	u64 max_extent = 0;
 	int total_retries = 0;
+	bool found_bitmap = false;
 	int ret;
 
 	/* for metadata, allow allocates with more holes */
@@ -621,12 +1135,46 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	}
 again:
 	min_bytes = min(min_bytes, bytes + empty_size);
-	entry = tree_search_bytes(&block_group->free_space_bytes,
-				  offset, min_bytes);
+	entry = tree_search_offset(block_group, offset, min_bytes, 1);
 	if (!entry) {
 		ret = -ENOSPC;
 		goto out;
 	}
+
+	while (entry->bitmap &&
+	       entry->bytes <= bytes + empty_size) {
+		struct rb_node *node = rb_next(&entry->offset_index);
+
+		if (!node) {
+			ret = -ENOSPC;
+			goto out;
+		}
+
+		entry = rb_entry(node, struct btrfs_free_space,
+				 offset_index);
+	}
+
+	if (entry->bitmap) {
+		/* we found this entry again, change offset drastically */
+		if (last == entry) {
+			offset = entry->offset +
+				BITS_PER_BITMAP * block_group->sectorsize;
+			goto again;
+		}
+
+		ret = btrfs_bitmap_cluster(block_group, entry, cluster,
+					   offset, bytes + empty_size,
+					   min_bytes);
+		if (ret < 0) {
+			/* make sure we don't just find this entry again */
+			last = entry;
+			offset += bytes + empty_size;
+			goto again;
+		}
+		goto got_it;
+	}
+
+	cluster->points_to_bitmap = false;
 	window_start = entry->offset;
 	window_free = entry->bytes;
 	last = entry;
@@ -639,11 +1187,20 @@ again:
 
 		node = rb_next(&last->offset_index);
 		if (!node) {
+			if (found_bitmap)
+				goto again;
 			ret = -ENOSPC;
 			goto out;
 		}
 		next = rb_entry(node, struct btrfs_free_space, offset_index);
 
+		if (next->bitmap) {
+			offset = next->offset;
+			found_bitmap = true;
+			last = next;
+			continue;
+		}
+
 		/*
 		 * we haven't filled the empty size and the window is
 		 * very large.  reset and try again
@@ -687,9 +1244,17 @@ again:
 	 */
 	while(1) {
 		node = rb_next(&entry->offset_index);
-		unlink_free_space(block_group, entry);
+		if (entry->bitmap && node) {
+			entry = rb_entry(node, struct btrfs_free_space,
+					 offset_index);
+			continue;
+		} else if (entry->bitmap && !node) {
+			break;
+		}
+
+		rb_erase(&entry->offset_index, &block_group->free_space_offset);
 		ret = tree_insert_offset(&cluster->root, entry->offset,
-					 &entry->offset_index);
+					 &entry->offset_index, 0);
 		BUG_ON(ret);
 
 		if (!node || entry == last)
@@ -697,8 +1262,10 @@ again:
 
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 	}
-	ret = 0;
+
 	cluster->max_size = max_extent;
+got_it:
+	ret = 0;
 	atomic_inc(&block_group->count);
 	list_add_tail(&cluster->block_group_list, &block_group->cluster_list);
 	cluster->block_group = block_group;
@@ -718,6 +1285,7 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 	spin_lock_init(&cluster->refill_lock);
 	cluster->root.rb_node = NULL;
 	cluster->max_size = 0;
+	cluster->points_to_bitmap = false;
 	INIT_LIST_HEAD(&cluster->block_group_list);
 	cluster->block_group = NULL;
 }
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 266fb87..890a8e7 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -19,6 +19,14 @@
 #ifndef __BTRFS_FREE_SPACE_CACHE
 #define __BTRFS_FREE_SPACE_CACHE
 
+struct btrfs_free_space {
+	struct rb_node offset_index;
+	u64 offset;
+	u64 bytes;
+	unsigned long *bitmap;
+	struct list_head list;
+};
+
 int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 			 u64 bytenr, u64 size);
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
-- 
1.5.4.3

