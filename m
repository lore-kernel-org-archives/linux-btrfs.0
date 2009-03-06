From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] Btrfs: take block group fragmentation into account for allocation
Date: Fri,  6 Mar 2009 14:30:48 -0500
Message-ID: <1236367848-17972-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch improves the allocators packing ability to greatly improve cold-cache
reads.  Instead of handling the empty_size logic within find_free_extent, we
simply pass it to btrfs_find_free_space, where it will check the fragmentation
level of the block group and decide if it wants to look for a empty cluster, or
simply allocate space for what we need.

This is accomplished by taking the total amount of free space fragments and
dividing it by the maximum number of free space fragments there can be and
multiplying it by 100.  This gives us the percentage of free space
fragmentation.  The maximum number of free space fragments is simply the free
space divided by the sectorsize, and then dividing that by 2.  If we are 20% or
more fragmented we will ignore the empty_size and just allocate num_bytes as
close to search_start as we can.  This results in the allocator trying its best
to fill up block groups before moving on to one farther down the disk.

I've also changed how the allocation hints are given.  Instead of relying on the
last allocation for the transaction, we rely on the last offset the particular
root allocated from.  This will help in packing allocations per roots close
together even in the face of fragmentation.  I may take out the alloc hint in
the transaction altogether, but that will be farther down the line.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h            |    6 +++++-
 fs/btrfs/extent-tree.c      |   25 +++++++++++++++----------
 fs/btrfs/free-space-cache.c |   42 +++++++++++++-----------------------------
 3 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bdf826c..64b4ee6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -651,6 +651,10 @@ struct btrfs_block_group_cache {
 	struct rb_root free_space_bytes;
 	struct rb_root free_space_offset;
 
+	/* free space fragmentation stuff */
+	u64 fragments;
+	u64 fragment_size;
+
 	/* block group cache stuff */
 	struct rb_node cache_node;
 
@@ -2141,7 +2145,7 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache
 				   *block_group);
 struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
 					       *block_group, u64 offset,
-					       u64 bytes);
+					       u64 bytes, u64 empty_size);
 void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 			   u64 bytes);
 u64 btrfs_block_group_free_space(struct btrfs_block_group_cache *block_group);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 38820b1..2a6fe71 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3082,8 +3082,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
-	u64 total_needed = num_bytes;
 	u64 *last_ptr = NULL;
+	u64 total_used = 0;
 	struct btrfs_block_group_cache *block_group = NULL;
 	int allowed_chunk_alloc = 0;
 	int fill_root_alloc_info = 0;
@@ -3111,13 +3111,12 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	if ((data & BTRFS_BLOCK_GROUP_DATA) && btrfs_test_opt(root, SSD))
 		last_ptr = &root->fs_info->last_data_alloc;
 
-	if (last_ptr && *last_ptr)
+	if (last_ptr && *last_ptr && !hint_byte)
 		hint_byte = *last_ptr;
 
 	search_start = max(search_start, first_logical_byte(root, 0));
 	search_start = max(search_start, hint_byte);
 
-	total_needed += empty_size;
 	block_group = btrfs_lookup_block_group(root->fs_info, search_start);
 	if (!block_group)
 		block_group = btrfs_lookup_first_block_group(root->fs_info,
@@ -3163,10 +3162,12 @@ have_block_group:
 			goto loop;
 
 		free_space = btrfs_find_free_space(block_group, search_start,
-						   total_needed);
+						   num_bytes, empty_size);
 		if (!free_space)
 			goto loop;
 
+		total_used = min_t(u64, num_bytes + empty_size,
+				   free_space->bytes);
 		search_start = stripe_align(root, free_space->offset);
 
 		/* past where we're allowed to search */
@@ -3222,7 +3223,7 @@ have_block_group:
 			orig_root->alloc_bytes -= num_bytes;
 
 			if (!orig_root->alloc_bytes) {
-				orig_root->alloc_bytes = total_needed;
+				orig_root->alloc_bytes = total_used;
 				orig_root->alloc_offset = search_start;
 				used = 1;
 			}
@@ -3232,23 +3233,23 @@ have_block_group:
 			u64 bytes = orig_root->alloc_bytes;
 
 			orig_root->alloc_offset = search_start + num_bytes;
-			orig_root->alloc_bytes = total_needed - num_bytes;
+			orig_root->alloc_bytes = total_used - num_bytes;
 			used = 1;
 			spin_unlock(&orig_root->alloc_lock);
 
 			btrfs_add_free_space_lock(block_group, offset, bytes);
 		} else {
 			orig_root->alloc_offset = search_start + num_bytes;
-			orig_root->alloc_bytes = total_needed - num_bytes;
+			orig_root->alloc_bytes = total_used - num_bytes;
 			used = 1;
 			spin_unlock(&orig_root->alloc_lock);
 		}
 
 		if (used) {
 			btrfs_remove_free_space_lock(block_group, search_start,
-						     total_needed);
+						     total_used);
 			if (last_ptr)
-				*last_ptr = search_start + total_needed;
+				*last_ptr = search_start + total_used;
 		}
 
 		mutex_unlock(&block_group->alloc_mutex);
@@ -3271,7 +3272,6 @@ loop:
 		int try_again = empty_size;
 
 		block_group = NULL;
-		total_needed -= empty_size;
 		empty_size = 0;
 
 		if (allowed_chunk_alloc) {
@@ -3356,6 +3356,7 @@ again:
 			spin_unlock(&root->alloc_lock);
 			return 0;
 		}
+		hint_byte = root->alloc_offset;
 		spin_unlock(&root->alloc_lock);
 	}
 
@@ -6398,6 +6399,8 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		set_avail_alloc_bits(root->fs_info, cache->flags);
 		if (btrfs_chunk_readonly(root, cache->key.objectid))
 			set_block_group_readonly(cache);
+		cache->fragments = 0;
+		cache->fragment_size = root->sectorsize;
 	}
 	ret = 0;
 error:
@@ -6430,6 +6433,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	mutex_init(&cache->alloc_mutex);
 	mutex_init(&cache->cache_mutex);
 	INIT_LIST_HEAD(&cache->list);
+	cache->fragments = 0;
+	cache->fragment_size = root->sectorsize;
 
 	btrfs_set_block_group_used(&cache->item, bytes_used);
 	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d1e5f0e..23cb12c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -163,6 +163,7 @@ static void unlink_free_space(struct btrfs_block_group_cache *block_group,
 {
 	rb_erase(&info->offset_index, &block_group->free_space_offset);
 	rb_erase(&info->bytes_index, &block_group->free_space_bytes);
+	block_group->fragments -= 1;
 }
 
 static int link_free_space(struct btrfs_block_group_cache *block_group,
@@ -181,6 +182,8 @@ static int link_free_space(struct btrfs_block_group_cache *block_group,
 	if (ret)
 		return ret;
 
+	block_group->fragments += 1;
+
 	return ret;
 }
 
@@ -447,44 +450,25 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 	mutex_unlock(&block_group->alloc_mutex);
 }
 
-#if 0
-static struct btrfs_free_space *btrfs_find_free_space_offset(struct
-						      btrfs_block_group_cache
-						      *block_group, u64 offset,
-						      u64 bytes)
+static int fragmentation_percent(struct btrfs_block_group_cache *block_group)
 {
-	struct btrfs_free_space *ret;
+	u64 max_fragments;
 
-	mutex_lock(&block_group->alloc_mutex);
-	ret = tree_search_offset(&block_group->free_space_offset, offset,
-				 bytes, 0);
-	mutex_unlock(&block_group->alloc_mutex);
-
-	return ret;
+	max_fragments = (block_group->key.offset -
+		btrfs_block_group_used(&block_group->item)) /
+		block_group->fragment_size;
+	return ((block_group->fragments / max_fragments) * 100);
 }
 
-static struct btrfs_free_space *btrfs_find_free_space_bytes(struct
-						     btrfs_block_group_cache
-						     *block_group, u64 offset,
-						     u64 bytes)
-{
-	struct btrfs_free_space *ret;
-
-	mutex_lock(&block_group->alloc_mutex);
-
-	ret = tree_search_bytes(&block_group->free_space_bytes, offset, bytes);
-	mutex_unlock(&block_group->alloc_mutex);
-
-	return ret;
-}
-#endif
-
 struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
 					       *block_group, u64 offset,
-					       u64 bytes)
+					       u64 bytes, u64 empty_size)
 {
 	struct btrfs_free_space *ret = NULL;
 
+	if (empty_size && fragmentation_percent(block_group) < 20)
+		bytes += empty_size;
+
 	ret = tree_search_offset(&block_group->free_space_offset, offset,
 				 bytes, 0);
 	if (!ret)
-- 
1.5.4.3

