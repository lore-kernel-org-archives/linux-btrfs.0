From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 3/4] Btrfs: kill the block group alloc mutex
Date: Fri, 20 Mar 2009 14:59:52 -0400
Message-ID: <1237575593-21101-4-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes the block group alloc mutex used to protect the free space
tree for allocations and replaces it with a spin lock which is used only to
protect the free space rb tree.  This means we only take the lock when we are
directly manipulating the tree, which makes us a touch faster with
multi-threaded workloads.  This patch also gets rid of btrfs_find_free_space and
replaces it with btrfs_find_space_for_alloc, which takes the number of bytes you
want to allocate, and empty_size, which is used to indicate how much free space
should be at the end of the allocation.  It will return an offset for the
allocator to use.  If we don't end up using it we _must_ call
btrfs_add_free_space to put it back.  This is the tradeoff to kill the
alloc_mutex, since we need to make sure nobody else comes along and takes our
space.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h            |   11 +--
 fs/btrfs/extent-tree.c      |   46 ++++++------
 fs/btrfs/free-space-cache.c |  183 +++++++++++++-----------------------------
 3 files changed, 83 insertions(+), 157 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4ddce91..bb9b78b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -637,7 +637,6 @@ struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
 	spinlock_t lock;
-	struct mutex alloc_mutex;
 	struct mutex cache_mutex;
 	u64 pinned;
 	u64 reserved;
@@ -649,6 +648,7 @@ struct btrfs_block_group_cache {
 	struct btrfs_space_info *space_info;
 
 	/* free space cache stuff */
+	spinlock_t tree_lock;
 	struct rb_root free_space_bytes;
 	struct rb_root free_space_offset;
 
@@ -2137,17 +2137,12 @@ int btrfs_acl_chmod(struct inode *inode);
 /* free-space-cache.c */
 int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 			 u64 bytenr, u64 size);
-int btrfs_add_free_space_lock(struct btrfs_block_group_cache *block_group,
-			      u64 offset, u64 bytes);
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			    u64 bytenr, u64 size);
-int btrfs_remove_free_space_lock(struct btrfs_block_group_cache *block_group,
-				 u64 offset, u64 bytes);
 void btrfs_remove_free_space_cache(struct btrfs_block_group_cache
 				   *block_group);
-struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
-					       *block_group, u64 offset,
-					       u64 bytes);
+u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
+			       u64 offset, u64 bytes, u64 empty_size);
 void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 			   u64 bytes);
 u64 btrfs_block_group_free_space(struct btrfs_block_group_cache *block_group);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3e9b675..4913a94 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2550,7 +2550,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
-	u64 total_needed = num_bytes;
 	u64 *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	int empty_cluster = 2 * 1024 * 1024;
@@ -2593,7 +2592,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		block_group = btrfs_lookup_block_group(root->fs_info,
 						       search_start);
 		if (block_group && block_group_bits(block_group, data)) {
-			total_needed += empty_size;
 			down_read(&space_info->groups_sem);
 			goto have_block_group;
 		}
@@ -2605,7 +2603,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 search:
 	down_read(&space_info->groups_sem);
 	list_for_each_entry(block_group, &space_info->block_groups, list) {
-		struct btrfs_free_space *free_space;
+		u64 offset;
 
 		atomic_inc(&block_group->count);
 		search_start = block_group->key.objectid;
@@ -2619,62 +2617,65 @@ have_block_group:
 				break;
 		}
 
-		mutex_lock(&block_group->alloc_mutex);
-
 		if (unlikely(block_group->ro))
 			goto loop;
 
-		free_space = btrfs_find_free_space(block_group, search_start,
-						   total_needed);
-		if (!free_space)
+		offset = btrfs_find_space_for_alloc(block_group, search_start,
+						    num_bytes, empty_size);
+		if (!offset)
 			goto loop;
 
-		search_start = stripe_align(root, free_space->offset);
+		search_start = stripe_align(root, offset);
 
 		/* move on to the next group */
-		if (search_start + num_bytes >= search_end)
+		if (search_start + num_bytes >= search_end) {
+			btrfs_add_free_space(block_group, offset, num_bytes);
 			goto loop;
+		}
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
-		    block_group->key.objectid + block_group->key.offset)
+		    block_group->key.objectid + block_group->key.offset) {
+			btrfs_add_free_space(block_group, offset, num_bytes);
 			goto loop;
+		}
 
-		if (using_hint && search_start > hint_byte)
+		if (using_hint && search_start > hint_byte) {
+			btrfs_add_free_space(block_group, offset, num_bytes);
 			goto loop;
+		}
 
 		if (exclude_nr > 0 &&
 		    (search_start + num_bytes > exclude_start &&
 		     search_start < exclude_start + exclude_nr)) {
 			search_start = exclude_start + exclude_nr;
 
+			btrfs_add_free_space(block_group, offset, num_bytes);
 			/*
 			 * if search_start is still in this block group
 			 * then we just re-search this block group
 			 */
 			if (search_start >= block_group->key.objectid &&
 			    search_start < (block_group->key.objectid +
-					    block_group->key.offset)) {
-				mutex_unlock(&block_group->alloc_mutex);
+					    block_group->key.offset))
 				goto have_block_group;
-			}
 			goto loop;
 		}
 
 		ins->objectid = search_start;
 		ins->offset = num_bytes;
 
-		btrfs_remove_free_space_lock(block_group, search_start,
-					     num_bytes);
+		if (offset < search_start)
+			btrfs_add_free_space(block_group, offset,
+					     search_start - offset);
+		BUG_ON(offset > search_start);
+
 		/* we are all good, lets return */
-		mutex_unlock(&block_group->alloc_mutex);
 		break;
 loop:
-		mutex_unlock(&block_group->alloc_mutex);
 		put_block_group(block_group);
 		if (using_hint) {
 			empty_size += empty_cluster;
-			total_needed += empty_cluster;
 			using_hint = 0;
 			up_read(&space_info->groups_sem);
 			goto search;
@@ -2685,7 +2686,6 @@ loop:
 	if (!ins->objectid && (empty_size || allowed_chunk_alloc)) {
 		int try_again = empty_size;
 
-		total_needed -= empty_size;
 		empty_size = 0;
 
 		if (allowed_chunk_alloc) {
@@ -5774,7 +5774,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 		atomic_set(&cache->count, 1);
 		spin_lock_init(&cache->lock);
-		mutex_init(&cache->alloc_mutex);
+		spin_lock_init(&cache->tree_lock);
 		mutex_init(&cache->cache_mutex);
 		INIT_LIST_HEAD(&cache->list);
 		read_extent_buffer(leaf, &cache->item,
@@ -5830,7 +5830,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
-	mutex_init(&cache->alloc_mutex);
+	spin_lock_init(&cache->tree_lock);
 	mutex_init(&cache->cache_mutex);
 	INIT_LIST_HEAD(&cache->list);
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 69b023f..df19b60 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -182,6 +182,7 @@ static int link_free_space(struct btrfs_block_group_cache *block_group,
 	int ret = 0;
 
 
+	BUG_ON(!info->bytes);
 	ret = tree_insert_offset(&block_group->free_space_offset, info->offset,
 				 &info->offset_index);
 	if (ret)
@@ -195,14 +196,23 @@ static int link_free_space(struct btrfs_block_group_cache *block_group,
 	return ret;
 }
 
-static int __btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
-				  u64 offset, u64 bytes)
+int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+			 u64 offset, u64 bytes)
 {
 	struct btrfs_free_space *right_info;
 	struct btrfs_free_space *left_info;
 	struct btrfs_free_space *info = NULL;
 	int ret = 0;
 
+	info = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
+	if (!info)
+		return -ENOMEM;
+
+	info->offset = offset;
+	info->bytes = bytes;
+
+	spin_lock(&block_group->tree_lock);
+
 	/*
 	 * first we want to see if there is free space adjacent to the range we
 	 * are adding, if there is remove that struct and add a new one to
@@ -215,42 +225,23 @@ static int __btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 
 	if (right_info) {
 		unlink_free_space(block_group, right_info);
-		info = right_info;
-		info->offset = offset;
-		info->bytes += bytes;
+		info->bytes += right_info->bytes;
+		kfree(right_info);
 	}
 
 	if (left_info && left_info->offset + left_info->bytes == offset) {
 		unlink_free_space(block_group, left_info);
-
-		if (info) {
-			info->offset = left_info->offset;
-			info->bytes += left_info->bytes;
-			kfree(left_info);
-		} else {
-			info = left_info;
-			info->bytes += bytes;
-		}
-	}
-
-	if (info) {
-		ret = link_free_space(block_group, info);
-		if (ret)
-			kfree(info);
-		goto out;
+		info->offset = left_info->offset;
+		info->bytes += left_info->bytes;
+		kfree(left_info);
 	}
 
-	info = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
-	if (!info)
-		return -ENOMEM;
-
-	info->offset = offset;
-	info->bytes = bytes;
-
 	ret = link_free_space(block_group, info);
 	if (ret)
 		kfree(info);
-out:
+
+	spin_unlock(&block_group->tree_lock);
+
 	if (ret) {
 		printk(KERN_ERR "btrfs: unable to add free space :%d\n", ret);
 		if (ret == -EEXIST)
@@ -260,17 +251,16 @@ out:
 	return ret;
 }
 
-static int
-__btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
-			  u64 offset, u64 bytes)
+int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
+			    u64 offset, u64 bytes)
 {
 	struct btrfs_free_space *info;
 	int ret = 0;
 
-	BUG_ON(!block_group->cached);
+	spin_lock(&block_group->tree_lock);
+
 	info = tree_search_offset(&block_group->free_space_offset, offset, 0,
 				  1);
-
 	if (info && info->offset == offset) {
 		if (info->bytes < bytes) {
 			printk(KERN_ERR "Found free space at %llu, size %llu,"
@@ -280,12 +270,14 @@ __btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			       (unsigned long long)bytes);
 			WARN_ON(1);
 			ret = -EINVAL;
+			spin_unlock(&block_group->tree_lock);
 			goto out;
 		}
 		unlink_free_space(block_group, info);
 
 		if (info->bytes == bytes) {
 			kfree(info);
+			spin_unlock(&block_group->tree_lock);
 			goto out;
 		}
 
@@ -293,6 +285,7 @@ __btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 		info->bytes -= bytes;
 
 		ret = link_free_space(block_group, info);
+		spin_unlock(&block_group->tree_lock);
 		BUG_ON(ret);
 	} else if (info && info->offset < offset &&
 		   info->offset + info->bytes >= offset + bytes) {
@@ -318,14 +311,15 @@ __btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			 */
 			kfree(info);
 		}
-
+		spin_unlock(&block_group->tree_lock);
 		/* step two, insert a new info struct to cover anything
 		 * before the hole
 		 */
-		ret = __btrfs_add_free_space(block_group, old_start,
-					     offset - old_start);
+		ret = btrfs_add_free_space(block_group, old_start,
+					   offset - old_start);
 		BUG_ON(ret);
 	} else {
+		spin_unlock(&block_group->tree_lock);
 		if (!info) {
 			printk(KERN_ERR "couldn't find space %llu to free\n",
 			       (unsigned long long)offset);
@@ -344,50 +338,6 @@ out:
 	return ret;
 }
 
-int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
-			 u64 offset, u64 bytes)
-{
-	int ret;
-
-	mutex_lock(&block_group->alloc_mutex);
-	ret = __btrfs_add_free_space(block_group, offset, bytes);
-	mutex_unlock(&block_group->alloc_mutex);
-
-	return ret;
-}
-
-int btrfs_add_free_space_lock(struct btrfs_block_group_cache *block_group,
-			      u64 offset, u64 bytes)
-{
-	int ret;
-
-	ret = __btrfs_add_free_space(block_group, offset, bytes);
-
-	return ret;
-}
-
-int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
-			    u64 offset, u64 bytes)
-{
-	int ret = 0;
-
-	mutex_lock(&block_group->alloc_mutex);
-	ret = __btrfs_remove_free_space(block_group, offset, bytes);
-	mutex_unlock(&block_group->alloc_mutex);
-
-	return ret;
-}
-
-int btrfs_remove_free_space_lock(struct btrfs_block_group_cache *block_group,
-				 u64 offset, u64 bytes)
-{
-	int ret;
-
-	ret = __btrfs_remove_free_space(block_group, offset, bytes);
-
-	return ret;
-}
-
 void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 			   u64 bytes)
 {
@@ -426,63 +376,44 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 	struct btrfs_free_space *info;
 	struct rb_node *node;
 
-	mutex_lock(&block_group->alloc_mutex);
+	spin_lock(&block_group->tree_lock);
 	while ((node = rb_last(&block_group->free_space_bytes)) != NULL) {
 		info = rb_entry(node, struct btrfs_free_space, bytes_index);
 		unlink_free_space(block_group, info);
 		kfree(info);
 		if (need_resched()) {
-			mutex_unlock(&block_group->alloc_mutex);
+			spin_unlock(&block_group->tree_lock);
 			cond_resched();
-			mutex_lock(&block_group->alloc_mutex);
+			spin_lock(&block_group->tree_lock);
 		}
 	}
-	mutex_unlock(&block_group->alloc_mutex);
-}
-
-#if 0
-static struct btrfs_free_space *btrfs_find_free_space_offset(struct
-						      btrfs_block_group_cache
-						      *block_group, u64 offset,
-						      u64 bytes)
-{
-	struct btrfs_free_space *ret;
-
-	mutex_lock(&block_group->alloc_mutex);
-	ret = tree_search_offset(&block_group->free_space_offset, offset,
-				 bytes, 0);
-	mutex_unlock(&block_group->alloc_mutex);
-
-	return ret;
+	spin_unlock(&block_group->tree_lock);
 }
 
-static struct btrfs_free_space *btrfs_find_free_space_bytes(struct
-						     btrfs_block_group_cache
-						     *block_group, u64 offset,
-						     u64 bytes)
+u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
+			       u64 offset, u64 bytes, u64 empty_size)
 {
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
-struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
-					       *block_group, u64 offset,
-					       u64 bytes)
-{
-	struct btrfs_free_space *ret = NULL;
+	struct btrfs_free_space *entry = NULL;
+	u64 ret = 0;
 
-	ret = tree_search_offset(&block_group->free_space_offset, offset,
-				 bytes, 1);
-	if (!ret)
-		ret = tree_search_bytes(&block_group->free_space_bytes,
-					offset, bytes);
+	spin_lock(&block_group->tree_lock);
+	entry = tree_search_offset(&block_group->free_space_offset, offset,
+				   bytes + empty_size, 1);
+	if (!entry)
+		entry = tree_search_bytes(&block_group->free_space_bytes,
+					  offset, bytes + empty_size);
+	if (entry) {
+		unlink_free_space(block_group, entry);
+		ret = entry->offset;
+		entry->offset += bytes;
+		entry->bytes -= bytes;
+
+		if (!entry->bytes)
+			kfree(entry);
+		else
+			link_free_space(block_group, entry);
+	}
+	spin_unlock(&block_group->tree_lock);
 
 	return ret;
 }
-- 
1.5.4.3

