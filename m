From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/7] Btrfs: Make free space cache code generic
Date: Wed, 16 Mar 2011 16:50:11 +0800
Message-ID: <4D8079C3.8080401@cn.fujitsu.com>
References: <4D807977.1040506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D807977.1040506@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

So we can re-use the code to cache free inode numbers.

The change is quite straightforward. Two new structures are introduced.

- struct btrfs_free_space_ctl

  We move those variables that are used for caching free space from
  struct btrfs_block_group_cache to this new struct.

- struct btrfs_free_space_op

  We do block group specific work (e.g. calculation of extents threshold)
  through functions registered in this struct.

And then we can remove references to struct btrfs_block_group_cache.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h            |    7 +-
 fs/btrfs/extent-tree.c      |   37 +++--
 fs/btrfs/free-space-cache.c |  367 +++++++++++++++++++++++--------------------
 fs/btrfs/free-space-cache.h |   20 +++
 4 files changed, 238 insertions(+), 193 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8b4b9d1..2a1e36e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -829,9 +829,6 @@ struct btrfs_block_group_cache {
 	u64 bytes_super;
 	u64 flags;
 	u64 sectorsize;
-	int extents_thresh;
-	int free_extents;
-	int total_bitmaps;
 	unsigned int ro:1;
 	unsigned int dirty:1;
 	unsigned int iref:1;
@@ -846,9 +843,7 @@ struct btrfs_block_group_cache {
 	struct btrfs_space_info *space_info;
 
 	/* free space cache stuff */
-	spinlock_t tree_lock;
-	struct rb_root free_space_offset;
-	u64 free_space;
+	struct btrfs_free_space_ctl *free_space_ctl;
 
 	/* block group cache stuff */
 	struct rb_node cache_node;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f1db57d..49eb826 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -88,6 +88,7 @@ void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
 		WARN_ON(cache->pinned > 0);
 		WARN_ON(cache->reserved > 0);
 		WARN_ON(cache->reserved_pinned > 0);
+		kfree(cache->free_space_ctl);
 		kfree(cache);
 	}
 }
@@ -4808,7 +4809,7 @@ wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
 		return 0;
 
 	wait_event(caching_ctl->wait, block_group_cache_done(cache) ||
-		   (cache->free_space >= num_bytes));
+		   (cache->free_space_ctl->free_space >= num_bytes));
 
 	put_caching_control(caching_ctl);
 	return 0;
@@ -8433,10 +8434,16 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			ret = -ENOMEM;
 			goto error;
 		}
+		cache->free_space_ctl = kzalloc(sizeof(*cache->free_space_ctl),
+						GFP_NOFS);
+		if (!cache->free_space_ctl) {
+			kfree(cache);
+			ret = -ENOMEM;
+			goto error;
+		}
 
 		atomic_set(&cache->count, 1);
 		spin_lock_init(&cache->lock);
-		spin_lock_init(&cache->tree_lock);
 		cache->fs_info = info;
 		INIT_LIST_HEAD(&cache->list);
 		INIT_LIST_HEAD(&cache->cluster_list);
@@ -8444,14 +8451,6 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		if (need_clear)
 			cache->disk_cache_state = BTRFS_DC_CLEAR;
 
-		/*
-		 * we only want to have 32k of ram per block group for keeping
-		 * track of free space, and if we pass 1/2 of that we want to
-		 * start converting things over to using bitmaps
-		 */
-		cache->extents_thresh = ((1024 * 32) / 2) /
-			sizeof(struct btrfs_free_space);
-
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
 				   sizeof(cache->item));
@@ -8462,6 +8461,8 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		cache->flags = btrfs_block_group_flags(&cache->item);
 		cache->sectorsize = root->sectorsize;
 
+		btrfs_init_free_space_ctl(cache);
+
 		/*
 		 * We need to exclude the super stripes now so that the space
 		 * info has super bytes accounted for, otherwise we'll think
@@ -8548,6 +8549,12 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache = kzalloc(sizeof(*cache), GFP_NOFS);
 	if (!cache)
 		return -ENOMEM;
+	cache->free_space_ctl = kzalloc(sizeof(*cache->free_space_ctl),
+					GFP_NOFS);
+	if (!cache->free_space_ctl) {
+		kfree(cache);
+		return -ENOMEM;
+	}
 
 	cache->key.objectid = chunk_offset;
 	cache->key.offset = size;
@@ -8555,19 +8562,13 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->sectorsize = root->sectorsize;
 	cache->fs_info = root->fs_info;
 
-	/*
-	 * we only want to have 32k of ram per block group for keeping track
-	 * of free space, and if we pass 1/2 of that we want to start
-	 * converting things over to using bitmaps
-	 */
-	cache->extents_thresh = ((1024 * 32) / 2) /
-		sizeof(struct btrfs_free_space);
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
-	spin_lock_init(&cache->tree_lock);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
 
+	btrfs_init_free_space_ctl(cache);
+
 	btrfs_set_block_group_used(&cache->item, bytes_used);
 	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
 	cache->flags = type;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bc60114..8799208 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -28,9 +28,7 @@
 #define BITS_PER_BITMAP		(PAGE_CACHE_SIZE * 8)
 #define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
 
-static void recalculate_thresholds(struct btrfs_block_group_cache
-				   *block_group);
-static int link_free_space(struct btrfs_block_group_cache *block_group,
+static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
 
 struct inode *lookup_free_space_inode(struct btrfs_root *root,
@@ -209,6 +207,7 @@ static int readahead_cache(struct inode *inode)
 int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_group_cache *block_group)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_root *root = fs_info->tree_root;
 	struct inode *inode;
 	struct btrfs_free_space_header *header;
@@ -412,9 +411,9 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			}
 
 			if (entry->type == BTRFS_FREE_SPACE_EXTENT) {
-				spin_lock(&block_group->tree_lock);
-				ret = link_free_space(block_group, e);
-				spin_unlock(&block_group->tree_lock);
+				spin_lock(&ctl->tree_lock);
+				ret = link_free_space(ctl, e);
+				spin_unlock(&ctl->tree_lock);
 				BUG_ON(ret);
 			} else {
 				e->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
@@ -425,11 +424,11 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 					page_cache_release(page);
 					goto free_cache;
 				}
-				spin_lock(&block_group->tree_lock);
-				ret = link_free_space(block_group, e);
-				block_group->total_bitmaps++;
-				recalculate_thresholds(block_group);
-				spin_unlock(&block_group->tree_lock);
+				spin_lock(&ctl->tree_lock);
+				ret = link_free_space(ctl, e);
+				ctl->total_bitmaps++;
+				ctl->op->recalc_thresholds(ctl);
+				spin_unlock(&ctl->tree_lock);
 				list_add_tail(&e->list, &bitmaps);
 			}
 
@@ -486,6 +485,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 			  struct btrfs_block_group_cache *block_group,
 			  struct btrfs_path *path)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
 	struct inode *inode;
@@ -524,7 +524,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		return 0;
 	}
 
-	node = rb_first(&block_group->free_space_offset);
+	node = rb_first(&ctl->free_space_offset);
 	if (!node) {
 		iput(inode);
 		return 0;
@@ -780,30 +780,30 @@ out_free:
 	return ret;
 }
 
-static inline unsigned long offset_to_bit(u64 bitmap_start, u64 sectorsize,
+static inline unsigned long offset_to_bit(u64 bitmap_start, u32 unit,
 					  u64 offset)
 {
 	BUG_ON(offset < bitmap_start);
 	offset -= bitmap_start;
-	return (unsigned long)(div64_u64(offset, sectorsize));
+	return (unsigned long)(div_u64(offset, unit));
 }
 
-static inline unsigned long bytes_to_bits(u64 bytes, u64 sectorsize)
+static inline unsigned long bytes_to_bits(u64 bytes, u32 unit)
 {
-	return (unsigned long)(div64_u64(bytes, sectorsize));
+	return (unsigned long)(div_u64(bytes, unit));
 }
 
-static inline u64 offset_to_bitmap(struct btrfs_block_group_cache *block_group,
+static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
 				   u64 offset)
 {
 	u64 bitmap_start;
 	u64 bytes_per_bitmap;
 
-	bytes_per_bitmap = BITS_PER_BITMAP * block_group->sectorsize;
-	bitmap_start = offset - block_group->key.objectid;
+	bytes_per_bitmap = BITS_PER_BITMAP * ctl->unit;
+	bitmap_start = offset - ctl->start;
 	bitmap_start = div64_u64(bitmap_start, bytes_per_bitmap);
 	bitmap_start *= bytes_per_bitmap;
-	bitmap_start += block_group->key.objectid;
+	bitmap_start += ctl->start;
 
 	return bitmap_start;
 }
@@ -861,10 +861,10 @@ static int tree_insert_offset(struct rb_root *root, u64 offset,
  * offset.
  */
 static struct btrfs_free_space *
-tree_search_offset(struct btrfs_block_group_cache *block_group,
+tree_search_offset(struct btrfs_free_space_ctl *ctl,
 		   u64 offset, int bitmap_only, int fuzzy)
 {
-	struct rb_node *n = block_group->free_space_offset.rb_node;
+	struct rb_node *n = ctl->free_space_offset.rb_node;
 	struct btrfs_free_space *entry, *prev = NULL;
 
 	/* find entry that is closest to the 'offset' */
@@ -960,8 +960,7 @@ tree_search_offset(struct btrfs_block_group_cache *block_group,
 				break;
 			}
 		}
-		if (entry->offset + BITS_PER_BITMAP *
-		    block_group->sectorsize > offset)
+		if (entry->offset + BITS_PER_BITMAP * ctl->unit > offset)
 			return entry;
 	} else if (entry->offset + entry->bytes > offset)
 		return entry;
@@ -972,7 +971,7 @@ tree_search_offset(struct btrfs_block_group_cache *block_group,
 	while (1) {
 		if (entry->bitmap) {
 			if (entry->offset + BITS_PER_BITMAP *
-			    block_group->sectorsize > offset)
+			    ctl->unit > offset)
 				break;
 		} else {
 			if (entry->offset + entry->bytes > offset)
@@ -988,38 +987,39 @@ tree_search_offset(struct btrfs_block_group_cache *block_group,
 }
 
 static inline void
-__unlink_free_space(struct btrfs_block_group_cache *block_group,
+__unlink_free_space(struct btrfs_free_space_ctl *ctl,
 		    struct btrfs_free_space *info)
 {
-	rb_erase(&info->offset_index, &block_group->free_space_offset);
-	block_group->free_extents--;
+	rb_erase(&info->offset_index, &ctl->free_space_offset);
+	ctl->free_extents--;
 }
 
-static void unlink_free_space(struct btrfs_block_group_cache *block_group,
+static void unlink_free_space(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info)
 {
-	__unlink_free_space(block_group, info);
-	block_group->free_space -= info->bytes;
+	__unlink_free_space(ctl, info);
+	ctl->free_space -= info->bytes;
 }
 
-static int link_free_space(struct btrfs_block_group_cache *block_group,
+static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info)
 {
 	int ret = 0;
 
 	BUG_ON(!info->bitmap && !info->bytes);
-	ret = tree_insert_offset(&block_group->free_space_offset, info->offset,
+	ret = tree_insert_offset(&ctl->free_space_offset, info->offset,
 				 &info->offset_index, (info->bitmap != NULL));
 	if (ret)
 		return ret;
 
-	block_group->free_space += info->bytes;
-	block_group->free_extents++;
+	ctl->free_space += info->bytes;
+	ctl->free_extents++;
 	return ret;
 }
 
-static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
+static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 {
+	struct btrfs_block_group_cache *block_group = ctl->private;
 	u64 max_bytes;
 	u64 bitmap_bytes;
 	u64 extent_bytes;
@@ -1041,10 +1041,10 @@ static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
 	 * sure we don't go over our overall goal of MAX_CACHE_BYTES_PER_GIG as
 	 * we add more bitmaps.
 	 */
-	bitmap_bytes = (block_group->total_bitmaps + 1) * PAGE_CACHE_SIZE;
+	bitmap_bytes = (ctl->total_bitmaps + 1) * PAGE_CACHE_SIZE;
 
 	if (bitmap_bytes >= max_bytes) {
-		block_group->extents_thresh = 0;
+		ctl->extents_thresh = 0;
 		return;
 	}
 
@@ -1055,43 +1055,43 @@ static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
 	extent_bytes = max_bytes - bitmap_bytes;
 	extent_bytes = min_t(u64, extent_bytes, div64_u64(max_bytes, 2));
 
-	block_group->extents_thresh =
+	ctl->extents_thresh =
 		div64_u64(extent_bytes, (sizeof(struct btrfs_free_space)));
 }
 
-static void bitmap_clear_bits(struct btrfs_block_group_cache *block_group,
+static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info, u64 offset,
 			      u64 bytes)
 {
 	unsigned long start, count;
 
-	start = offset_to_bit(info->offset, block_group->sectorsize, offset);
-	count = bytes_to_bits(bytes, block_group->sectorsize);
+	start = offset_to_bit(info->offset, ctl->unit, offset);
+	count = bytes_to_bits(bytes, ctl->unit);
 	BUG_ON(start + count > BITS_PER_BITMAP);
 
 	bitmap_clear(info->bitmap, start, count);
 
 	info->bytes -= bytes;
-	block_group->free_space -= bytes;
+	ctl->free_space -= bytes;
 }
 
-static void bitmap_set_bits(struct btrfs_block_group_cache *block_group,
+static void bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
 			    struct btrfs_free_space *info, u64 offset,
 			    u64 bytes)
 {
 	unsigned long start, count;
 
-	start = offset_to_bit(info->offset, block_group->sectorsize, offset);
-	count = bytes_to_bits(bytes, block_group->sectorsize);
+	start = offset_to_bit(info->offset, ctl->unit, offset);
+	count = bytes_to_bits(bytes, ctl->unit);
 	BUG_ON(start + count > BITS_PER_BITMAP);
 
 	bitmap_set(info->bitmap, start, count);
 
 	info->bytes += bytes;
-	block_group->free_space += bytes;
+	ctl->free_space += bytes;
 }
 
-static int search_bitmap(struct btrfs_block_group_cache *block_group,
+static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 			 struct btrfs_free_space *bitmap_info, u64 *offset,
 			 u64 *bytes)
 {
@@ -1099,9 +1099,9 @@ static int search_bitmap(struct btrfs_block_group_cache *block_group,
 	unsigned long bits, i;
 	unsigned long next_zero;
 
-	i = offset_to_bit(bitmap_info->offset, block_group->sectorsize,
+	i = offset_to_bit(bitmap_info->offset, ctl->unit,
 			  max_t(u64, *offset, bitmap_info->offset));
-	bits = bytes_to_bits(*bytes, block_group->sectorsize);
+	bits = bytes_to_bits(*bytes, ctl->unit);
 
 	for (i = find_next_bit(bitmap_info->bitmap, BITS_PER_BITMAP, i);
 	     i < BITS_PER_BITMAP;
@@ -1116,29 +1116,25 @@ static int search_bitmap(struct btrfs_block_group_cache *block_group,
 	}
 
 	if (found_bits) {
-		*offset = (u64)(i * block_group->sectorsize) +
-			bitmap_info->offset;
-		*bytes = (u64)(found_bits) * block_group->sectorsize;
+		*offset = (u64)(i * ctl->unit) + bitmap_info->offset;
+		*bytes = (u64)(found_bits) * ctl->unit;
 		return 0;
 	}
 
 	return -1;
 }
 
-static struct btrfs_free_space *find_free_space(struct btrfs_block_group_cache
-						*block_group, u64 *offset,
-						u64 *bytes, int debug)
+static struct btrfs_free_space *
+find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes)
 {
 	struct btrfs_free_space *entry;
 	struct rb_node *node;
 	int ret;
 
-	if (!block_group->free_space_offset.rb_node)
+	if (!ctl->free_space_offset.rb_node)
 		return NULL;
 
-	entry = tree_search_offset(block_group,
-				   offset_to_bitmap(block_group, *offset),
-				   0, 1);
+	entry = tree_search_offset(ctl, offset_to_bitmap(ctl, *offset), 0, 1);
 	if (!entry)
 		return NULL;
 
@@ -1148,7 +1144,7 @@ static struct btrfs_free_space *find_free_space(struct btrfs_block_group_cache
 			continue;
 
 		if (entry->bitmap) {
-			ret = search_bitmap(block_group, entry, offset, bytes);
+			ret = search_bitmap(ctl, entry, offset, bytes);
 			if (!ret)
 				return entry;
 			continue;
@@ -1162,33 +1158,28 @@ static struct btrfs_free_space *find_free_space(struct btrfs_block_group_cache
 	return NULL;
 }
 
-static void add_new_bitmap(struct btrfs_block_group_cache *block_group,
+static void add_new_bitmap(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info, u64 offset)
 {
-	u64 bytes_per_bg = BITS_PER_BITMAP * block_group->sectorsize;
-	int max_bitmaps = (int)div64_u64(block_group->key.offset +
-					 bytes_per_bg - 1, bytes_per_bg);
-	BUG_ON(block_group->total_bitmaps >= max_bitmaps);
-
-	info->offset = offset_to_bitmap(block_group, offset);
+	info->offset = offset_to_bitmap(ctl, offset);
 	info->bytes = 0;
-	link_free_space(block_group, info);
-	block_group->total_bitmaps++;
+	link_free_space(ctl, info);
+	ctl->total_bitmaps++;
 
-	recalculate_thresholds(block_group);
+	ctl->op->recalc_thresholds(ctl);
 }
 
-static void free_bitmap(struct btrfs_block_group_cache *block_group,
+static void free_bitmap(struct btrfs_free_space_ctl *ctl,
 			struct btrfs_free_space *bitmap_info)
 {
-	unlink_free_space(block_group, bitmap_info);
+	unlink_free_space(ctl, bitmap_info);
 	kfree(bitmap_info->bitmap);
 	kfree(bitmap_info);
-	block_group->total_bitmaps--;
-	recalculate_thresholds(block_group);
+	ctl->total_bitmaps--;
+	ctl->op->recalc_thresholds(ctl);
 }
 
-static noinline int remove_from_bitmap(struct btrfs_block_group_cache *block_group,
+static noinline int remove_from_bitmap(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *bitmap_info,
 			      u64 *offset, u64 *bytes)
 {
@@ -1197,8 +1188,7 @@ static noinline int remove_from_bitmap(struct btrfs_block_group_cache *block_gro
 	int ret;
 
 again:
-	end = bitmap_info->offset +
-		(u64)(BITS_PER_BITMAP * block_group->sectorsize) - 1;
+	end = bitmap_info->offset + (u64)(BITS_PER_BITMAP * ctl->unit) - 1;
 
 	/*
 	 * XXX - this can go away after a few releases.
@@ -1213,24 +1203,22 @@ again:
 	search_start = *offset;
 	search_bytes = *bytes;
 	search_bytes = min(search_bytes, end - search_start + 1);
-	ret = search_bitmap(block_group, bitmap_info, &search_start,
-			    &search_bytes);
+	ret = search_bitmap(ctl, bitmap_info, &search_start, &search_bytes);
 	BUG_ON(ret < 0 || search_start != *offset);
 
 	if (*offset > bitmap_info->offset && *offset + *bytes > end) {
-		bitmap_clear_bits(block_group, bitmap_info, *offset,
-				  end - *offset + 1);
+		bitmap_clear_bits(ctl, bitmap_info, *offset, end - *offset + 1);
 		*bytes -= end - *offset + 1;
 		*offset = end + 1;
 	} else if (*offset >= bitmap_info->offset && *offset + *bytes <= end) {
-		bitmap_clear_bits(block_group, bitmap_info, *offset, *bytes);
+		bitmap_clear_bits(ctl, bitmap_info, *offset, *bytes);
 		*bytes = 0;
 	}
 
 	if (*bytes) {
 		struct rb_node *next = rb_next(&bitmap_info->offset_index);
 		if (!bitmap_info->bytes)
-			free_bitmap(block_group, bitmap_info);
+			free_bitmap(ctl, bitmap_info);
 
 		/*
 		 * no entry after this bitmap, but we still have bytes to
@@ -1257,33 +1245,30 @@ again:
 		 */
 		search_start = *offset;
 		search_bytes = *bytes;
-		ret = search_bitmap(block_group, bitmap_info, &search_start,
+		ret = search_bitmap(ctl, bitmap_info, &search_start,
 				    &search_bytes);
 		if (ret < 0 || search_start != *offset)
 			return -EAGAIN;
 
 		goto again;
 	} else if (!bitmap_info->bytes)
-		free_bitmap(block_group, bitmap_info);
+		free_bitmap(ctl, bitmap_info);
 
 	return 0;
 }
 
-static int insert_into_bitmap(struct btrfs_block_group_cache *block_group,
-			      struct btrfs_free_space *info)
+static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
+			struct btrfs_free_space *info)
 {
-	struct btrfs_free_space *bitmap_info;
-	int added = 0;
-	u64 bytes, offset, end;
-	int ret;
+	struct btrfs_block_group_cache *block_group = ctl->private;
 
 	/*
 	 * If we are below the extents threshold then we can add this as an
 	 * extent, and don't have to deal with the bitmap
 	 */
-	if (block_group->free_extents < block_group->extents_thresh &&
+	if (ctl->free_extents < ctl->extents_thresh &&
 	    info->bytes > block_group->sectorsize * 4)
-		return 0;
+		return false;
 
 	/*
 	 * some block groups are so tiny they can't be enveloped by a bitmap, so
@@ -1291,31 +1276,42 @@ static int insert_into_bitmap(struct btrfs_block_group_cache *block_group,
 	 */
 	if (BITS_PER_BITMAP * block_group->sectorsize >
 	    block_group->key.offset)
-		return 0;
+		return false;
+
+	return true;
+}
+
+static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
+			      struct btrfs_free_space *info)
+{
+	struct btrfs_free_space *bitmap_info;
+	int added = 0;
+	u64 bytes, offset, end;
+	int ret;
 
 	bytes = info->bytes;
 	offset = info->offset;
 
+	if (!ctl->op->use_bitmap(ctl, info))
+		return 0;
+
 again:
-	bitmap_info = tree_search_offset(block_group,
-					 offset_to_bitmap(block_group, offset),
+	bitmap_info = tree_search_offset(ctl, offset_to_bitmap(ctl, offset),
 					 1, 0);
 	if (!bitmap_info) {
 		BUG_ON(added);
 		goto new_bitmap;
 	}
 
-	end = bitmap_info->offset +
-		(u64)(BITS_PER_BITMAP * block_group->sectorsize);
+	end = bitmap_info->offset + (u64)(BITS_PER_BITMAP * ctl->unit);
 
 	if (offset >= bitmap_info->offset && offset + bytes > end) {
-		bitmap_set_bits(block_group, bitmap_info, offset,
-				end - offset);
+		bitmap_set_bits(ctl, bitmap_info, offset, end - offset);
 		bytes -= end - offset;
 		offset = end;
 		added = 0;
 	} else if (offset >= bitmap_info->offset && offset + bytes <= end) {
-		bitmap_set_bits(block_group, bitmap_info, offset, bytes);
+		bitmap_set_bits(ctl, bitmap_info, offset, bytes);
 		bytes = 0;
 	} else {
 		BUG();
@@ -1329,19 +1325,19 @@ again:
 
 new_bitmap:
 	if (info && info->bitmap) {
-		add_new_bitmap(block_group, info, offset);
+		add_new_bitmap(ctl, info, offset);
 		added = 1;
 		info = NULL;
 		goto again;
 	} else {
-		spin_unlock(&block_group->tree_lock);
+		spin_unlock(&ctl->tree_lock);
 
 		/* no pre-allocated info, allocate a new one */
 		if (!info) {
 			info = kzalloc(sizeof(struct btrfs_free_space),
 				       GFP_NOFS);
 			if (!info) {
-				spin_lock(&block_group->tree_lock);
+				spin_lock(&ctl->tree_lock);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -1349,7 +1345,7 @@ new_bitmap:
 
 		/* allocate the bitmap */
 		info->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
-		spin_lock(&block_group->tree_lock);
+		spin_lock(&ctl->tree_lock);
 		if (!info->bitmap) {
 			ret = -ENOMEM;
 			goto out;
@@ -1367,7 +1363,7 @@ out:
 	return ret;
 }
 
-bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
+bool try_merge_free_space(struct btrfs_free_space_ctl *ctl,
 			  struct btrfs_free_space *info, bool update_stat)
 {
 	struct btrfs_free_space *left_info;
@@ -1381,18 +1377,18 @@ bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
 	 * are adding, if there is remove that struct and add a new one to
 	 * cover the entire range
 	 */
-	right_info = tree_search_offset(block_group, offset + bytes, 0, 0);
+	right_info = tree_search_offset(ctl, offset + bytes, 0, 0);
 	if (right_info && rb_prev(&right_info->offset_index))
 		left_info = rb_entry(rb_prev(&right_info->offset_index),
 				     struct btrfs_free_space, offset_index);
 	else
-		left_info = tree_search_offset(block_group, offset - 1, 0, 0);
+		left_info = tree_search_offset(ctl, offset - 1, 0, 0);
 
 	if (right_info && !right_info->bitmap) {
 		if (update_stat)
-			unlink_free_space(block_group, right_info);
+			unlink_free_space(ctl, right_info);
 		else
-			__unlink_free_space(block_group, right_info);
+			__unlink_free_space(ctl, right_info);
 		info->bytes += right_info->bytes;
 		kfree(right_info);
 		merged = true;
@@ -1401,9 +1397,9 @@ bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
 	if (left_info && !left_info->bitmap &&
 	    left_info->offset + left_info->bytes == offset) {
 		if (update_stat)
-			unlink_free_space(block_group, left_info);
+			unlink_free_space(ctl, left_info);
 		else
-			__unlink_free_space(block_group, left_info);
+			__unlink_free_space(ctl, left_info);
 		info->offset = left_info->offset;
 		info->bytes += left_info->bytes;
 		kfree(left_info);
@@ -1416,6 +1412,7 @@ bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
 int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 			 u64 offset, u64 bytes)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *info;
 	int ret = 0;
 
@@ -1426,9 +1423,9 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	info->offset = offset;
 	info->bytes = bytes;
 
-	spin_lock(&block_group->tree_lock);
+	spin_lock(&ctl->tree_lock);
 
-	if (try_merge_free_space(block_group, info, true))
+	if (try_merge_free_space(ctl, info, true))
 		goto link;
 
 	/*
@@ -1436,7 +1433,7 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	 * extent then we know we're going to have to allocate a new extent, so
 	 * before we do that see if we need to drop this into a bitmap
 	 */
-	ret = insert_into_bitmap(block_group, info);
+	ret = insert_into_bitmap(ctl, info);
 	if (ret < 0) {
 		goto out;
 	} else if (ret) {
@@ -1444,11 +1441,11 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 		goto out;
 	}
 link:
-	ret = link_free_space(block_group, info);
+	ret = link_free_space(ctl, info);
 	if (ret)
 		kfree(info);
 out:
-	spin_unlock(&block_group->tree_lock);
+	spin_unlock(&ctl->tree_lock);
 
 	if (ret) {
 		printk(KERN_CRIT "btrfs: unable to add free space :%d\n", ret);
@@ -1461,21 +1458,21 @@ out:
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			    u64 offset, u64 bytes)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *info;
 	struct btrfs_free_space *next_info = NULL;
 	int ret = 0;
 
-	spin_lock(&block_group->tree_lock);
+	spin_lock(&ctl->tree_lock);
 
 again:
-	info = tree_search_offset(block_group, offset, 0, 0);
+	info = tree_search_offset(ctl, offset, 0, 0);
 	if (!info) {
 		/*
 		 * oops didn't find an extent that matched the space we wanted
 		 * to remove, look for a bitmap instead
 		 */
-		info = tree_search_offset(block_group,
-					  offset_to_bitmap(block_group, offset),
+		info = tree_search_offset(ctl, offset_to_bitmap(ctl, offset),
 					  1, 0);
 		if (!info) {
 			WARN_ON(1);
@@ -1490,8 +1487,8 @@ again:
 					     offset_index);
 
 		if (next_info->bitmap)
-			end = next_info->offset + BITS_PER_BITMAP *
-				block_group->sectorsize - 1;
+			end = next_info->offset +
+			      BITS_PER_BITMAP * ctl->unit - 1;
 		else
 			end = next_info->offset + next_info->bytes;
 
@@ -1511,20 +1508,20 @@ again:
 	}
 
 	if (info->bytes == bytes) {
-		unlink_free_space(block_group, info);
+		unlink_free_space(ctl, info);
 		if (info->bitmap) {
 			kfree(info->bitmap);
-			block_group->total_bitmaps--;
+			ctl->total_bitmaps--;
 		}
 		kfree(info);
 		goto out_lock;
 	}
 
 	if (!info->bitmap && info->offset == offset) {
-		unlink_free_space(block_group, info);
+		unlink_free_space(ctl, info);
 		info->offset += bytes;
 		info->bytes -= bytes;
-		link_free_space(block_group, info);
+		link_free_space(ctl, info);
 		goto out_lock;
 	}
 
@@ -1538,13 +1535,13 @@ again:
 		 * first unlink the old info and then
 		 * insert it again after the hole we're creating
 		 */
-		unlink_free_space(block_group, info);
+		unlink_free_space(ctl, info);
 		if (offset + bytes < info->offset + info->bytes) {
 			u64 old_end = info->offset + info->bytes;
 
 			info->offset = offset + bytes;
 			info->bytes = old_end - info->offset;
-			ret = link_free_space(block_group, info);
+			ret = link_free_space(ctl, info);
 			WARN_ON(ret);
 			if (ret)
 				goto out_lock;
@@ -1554,7 +1551,7 @@ again:
 			 */
 			kfree(info);
 		}
-		spin_unlock(&block_group->tree_lock);
+		spin_unlock(&ctl->tree_lock);
 
 		/* step two, insert a new info struct to cover
 		 * anything before the hole
@@ -1565,12 +1562,12 @@ again:
 		goto out;
 	}
 
-	ret = remove_from_bitmap(block_group, info, &offset, &bytes);
+	ret = remove_from_bitmap(ctl, info, &offset, &bytes);
 	if (ret == -EAGAIN)
 		goto again;
 	BUG_ON(ret);
 out_lock:
-	spin_unlock(&block_group->tree_lock);
+	spin_unlock(&ctl->tree_lock);
 out:
 	return ret;
 }
@@ -1578,11 +1575,12 @@ out:
 void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 			   u64 bytes)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *info;
 	struct rb_node *n;
 	int count = 0;
 
-	for (n = rb_first(&block_group->free_space_offset); n; n = rb_next(n)) {
+	for (n = rb_first(&ctl->free_space_offset); n; n = rb_next(n)) {
 		info = rb_entry(n, struct btrfs_free_space, offset_index);
 		if (info->bytes >= bytes)
 			count++;
@@ -1597,6 +1595,30 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 	       "\n", count);
 }
 
+static struct btrfs_free_space_op free_space_op = {
+	.recalc_thresholds	= recalculate_thresholds,
+	.use_bitmap		= use_bitmap,
+};
+
+void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group)
+{
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
+
+	spin_lock_init(&ctl->tree_lock);
+	ctl->unit = block_group->sectorsize;
+	ctl->start = block_group->key.objectid;
+	ctl->private = block_group;
+	ctl->op = &free_space_op;
+
+	/*
+	 * we only want to have 32k of ram per block group for keeping
+	 * track of free space, and if we pass 1/2 of that we want to
+	 * start converting things over to using bitmaps
+	 */
+	ctl->extents_thresh = ((1024 * 32) / 2) /
+				sizeof(struct btrfs_free_space);
+}
+
 /*
  * for a given cluster, put all of its extents back into the free
  * space cache.  If the block group passed doesn't match the block group
@@ -1608,6 +1630,7 @@ __btrfs_return_cluster_to_free_space(
 			     struct btrfs_block_group_cache *block_group,
 			     struct btrfs_free_cluster *cluster)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry;
 	struct rb_node *node;
 	bool bitmap;
@@ -1631,8 +1654,8 @@ __btrfs_return_cluster_to_free_space(
 		node = rb_next(&entry->offset_index);
 		rb_erase(&entry->offset_index, &cluster->root);
 		BUG_ON(entry->bitmap);
-		try_merge_free_space(block_group, entry, false);
-		tree_insert_offset(&block_group->free_space_offset,
+		try_merge_free_space(ctl, entry, false);
+		tree_insert_offset(&ctl->free_space_offset,
 				   entry->offset, &entry->offset_index, 0);
 	}
 	cluster->root = RB_ROOT;
@@ -1645,12 +1668,13 @@ out:
 
 void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *info;
 	struct rb_node *node;
 	struct btrfs_free_cluster *cluster;
 	struct list_head *head;
 
-	spin_lock(&block_group->tree_lock);
+	spin_lock(&ctl->tree_lock);
 	while ((head = block_group->cluster_list.next) !=
 	       &block_group->cluster_list) {
 		cluster = list_entry(head, struct btrfs_free_cluster,
@@ -1659,57 +1683,58 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 		WARN_ON(cluster->block_group != block_group);
 		__btrfs_return_cluster_to_free_space(block_group, cluster);
 		if (need_resched()) {
-			spin_unlock(&block_group->tree_lock);
+			spin_unlock(&ctl->tree_lock);
 			cond_resched();
-			spin_lock(&block_group->tree_lock);
+			spin_lock(&ctl->tree_lock);
 		}
 	}
 
-	while ((node = rb_last(&block_group->free_space_offset)) != NULL) {
+	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
 		info = rb_entry(node, struct btrfs_free_space, offset_index);
-		unlink_free_space(block_group, info);
+		unlink_free_space(ctl, info);
 		if (info->bitmap)
 			kfree(info->bitmap);
 		kfree(info);
 		if (need_resched()) {
-			spin_unlock(&block_group->tree_lock);
+			spin_unlock(&ctl->tree_lock);
 			cond_resched();
-			spin_lock(&block_group->tree_lock);
+			spin_lock(&ctl->tree_lock);
 		}
 	}
 
-	spin_unlock(&block_group->tree_lock);
+	spin_unlock(&ctl->tree_lock);
 }
 
 u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 			       u64 offset, u64 bytes, u64 empty_size)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry = NULL;
 	u64 bytes_search = bytes + empty_size;
 	u64 ret = 0;
 
-	spin_lock(&block_group->tree_lock);
-	entry = find_free_space(block_group, &offset, &bytes_search, 0);
+	spin_lock(&ctl->tree_lock);
+	entry = find_free_space(ctl, &offset, &bytes_search);
 	if (!entry)
 		goto out;
 
 	ret = offset;
 	if (entry->bitmap) {
-		bitmap_clear_bits(block_group, entry, offset, bytes);
+		bitmap_clear_bits(ctl, entry, offset, bytes);
 		if (!entry->bytes)
-			free_bitmap(block_group, entry);
+			free_bitmap(ctl, entry);
 	} else {
-		unlink_free_space(block_group, entry);
+		unlink_free_space(ctl, entry);
 		entry->offset += bytes;
 		entry->bytes -= bytes;
 		if (!entry->bytes)
 			kfree(entry);
 		else
-			link_free_space(block_group, entry);
+			link_free_space(ctl, entry);
 	}
 
 out:
-	spin_unlock(&block_group->tree_lock);
+	spin_unlock(&ctl->tree_lock);
 
 	return ret;
 }
@@ -1726,6 +1751,7 @@ int btrfs_return_cluster_to_free_space(
 			       struct btrfs_block_group_cache *block_group,
 			       struct btrfs_free_cluster *cluster)
 {
+	struct btrfs_free_space_ctl *ctl;
 	int ret;
 
 	/* first, get a safe pointer to the block group */
@@ -1744,10 +1770,12 @@ int btrfs_return_cluster_to_free_space(
 	atomic_inc(&block_group->count);
 	spin_unlock(&cluster->lock);
 
+	ctl = block_group->free_space_ctl;
+
 	/* now return any extents the cluster had on it */
-	spin_lock(&block_group->tree_lock);
+	spin_lock(&ctl->tree_lock);
 	ret = __btrfs_return_cluster_to_free_space(block_group, cluster);
-	spin_unlock(&block_group->tree_lock);
+	spin_unlock(&ctl->tree_lock);
 
 	/* finally drop our ref */
 	btrfs_put_block_group(block_group);
@@ -1758,13 +1786,14 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 				   struct btrfs_free_cluster *cluster,
 				   u64 bytes, u64 min_start)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry;
 	int err;
 	u64 search_start = cluster->window_start;
 	u64 search_bytes = bytes;
 	u64 ret = 0;
 
-	spin_lock(&block_group->tree_lock);
+	spin_lock(&ctl->tree_lock);
 	spin_lock(&cluster->lock);
 
 	if (!cluster->points_to_bitmap)
@@ -1779,8 +1808,7 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 	 * bitmap, so do the offset_to_bitmap trick anyway, and set bitmap_only
 	 * to 1 to make sure we get the bitmap entry
 	 */
-	entry = tree_search_offset(block_group,
-				   offset_to_bitmap(block_group, search_start),
+	entry = tree_search_offset(ctl, offset_to_bitmap(ctl, search_start),
 				   1, 0);
 	if (!entry || !entry->bitmap)
 		goto out;
@@ -1788,18 +1816,17 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 	search_start = min_start;
 	search_bytes = bytes;
 
-	err = search_bitmap(block_group, entry, &search_start,
-			    &search_bytes);
+	err = search_bitmap(ctl, entry, &search_start, &search_bytes);
 	if (err)
 		goto out;
 
 	ret = search_start;
-	bitmap_clear_bits(block_group, entry, ret, bytes);
+	bitmap_clear_bits(ctl, entry, ret, bytes);
 	if (entry->bytes == 0)
-		free_bitmap(block_group, entry);
+		free_bitmap(ctl, entry);
 out:
 	spin_unlock(&cluster->lock);
-	spin_unlock(&block_group->tree_lock);
+	spin_unlock(&ctl->tree_lock);
 
 	return ret;
 }
@@ -1813,6 +1840,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 			     struct btrfs_free_cluster *cluster, u64 bytes,
 			     u64 min_start)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry = NULL;
 	struct rb_node *node;
 	u64 ret = 0;
@@ -1860,15 +1888,15 @@ out:
 	if (!ret)
 		return 0;
 
-	spin_lock(&block_group->tree_lock);
+	spin_lock(&ctl->tree_lock);
 
-	block_group->free_space -= bytes;
+	ctl->free_space -= bytes;
 	if (entry->bytes == 0) {
-		block_group->free_extents--;
+		ctl->free_extents--;
 		kfree(entry);
 	}
 
-	spin_unlock(&block_group->tree_lock);
+	spin_unlock(&ctl->tree_lock);
 
 	return ret;
 }
@@ -1950,6 +1978,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 			     struct btrfs_free_cluster *cluster,
 			     u64 offset, u64 bytes, u64 empty_size)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry = NULL;
 	struct rb_node *node;
 	struct btrfs_free_space *next;
@@ -1977,7 +2006,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	} else
 		min_bytes = max(bytes, (bytes + empty_size) >> 2);
 
-	spin_lock(&block_group->tree_lock);
+	spin_lock(&ctl->tree_lock);
 	spin_lock(&cluster->lock);
 
 	/* someone already found a cluster, hooray */
@@ -1986,7 +2015,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 again:
-	entry = tree_search_offset(block_group, offset, found_bitmap, 1);
+	entry = tree_search_offset(ctl, offset, found_bitmap, 1);
 	if (!entry) {
 		ret = -ENOSPC;
 		goto out;
@@ -2097,7 +2126,7 @@ again:
 			break;
 		}
 
-		rb_erase(&entry->offset_index, &block_group->free_space_offset);
+		rb_erase(&entry->offset_index, &ctl->free_space_offset);
 		ret = tree_insert_offset(&cluster->root, entry->offset,
 					 &entry->offset_index, 0);
 		BUG_ON(ret);
@@ -2116,7 +2145,7 @@ got_it:
 	cluster->block_group = block_group;
 out:
 	spin_unlock(&cluster->lock);
-	spin_unlock(&block_group->tree_lock);
+	spin_unlock(&ctl->tree_lock);
 
 	return ret;
 }
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index ef5d7e1..322b7e0 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -27,6 +27,25 @@ struct btrfs_free_space {
 	struct list_head list;
 };
 
+struct btrfs_free_space_ctl {
+	spinlock_t tree_lock;
+	struct rb_root free_space_offset;
+	u64 free_space;
+	int extents_thresh;
+	int free_extents;
+	int total_bitmaps;
+	int unit;
+	u64 start;
+	struct btrfs_free_space_op *op;
+	void *private;
+};
+
+struct btrfs_free_space_op {
+	void (*recalc_thresholds)(struct btrfs_free_space_ctl *ctl);
+	bool (*use_bitmap)(struct btrfs_free_space_ctl *ctl,
+			   struct btrfs_free_space *info);
+};
+
 struct inode *lookup_free_space_inode(struct btrfs_root *root,
 				      struct btrfs_block_group_cache
 				      *block_group, struct btrfs_path *path);
@@ -45,6 +64,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 			  struct btrfs_trans_handle *trans,
 			  struct btrfs_block_group_cache *block_group,
 			  struct btrfs_path *path);
+void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group);
 int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 			 u64 bytenr, u64 size);
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
-- 
1.7.3.1
