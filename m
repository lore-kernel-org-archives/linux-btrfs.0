From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix lockdep warnings
Date: Thu, 30 Oct 2008 10:32:45 -0400
Message-ID: <20081030143243.GA31107@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

There is a lockdep warning that pops up complaining about grabbing the
block_group->alloc_mutex while holding the fs_info->pinned_mutex.  This is
because in cache_block_group we grabe the pinned_mutex while holding the
alloc_mutex.  This patch fixes this particular complaint by adding a cache_mutex
that will be held when caching the block group and no other time.  This will
keep the lockdep warning from happening, and is a little cleaner.  I also added
a test to see if the block group is cached before calling cache_block_group in
find_free_extent to keep us from checking the block group needlessly, since
really you are only going to need to call cache_block_group once, and every time
after that you will be fine.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index abb2733..8d9c2b4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -561,6 +561,7 @@ struct btrfs_block_group_cache {
 	struct btrfs_block_group_item item;
 	spinlock_t lock;
 	struct mutex alloc_mutex;
+	struct mutex cache_mutex;
 	u64 pinned;
 	u64 reserved;
 	u64 flags;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 155c8dc..59690f8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -158,8 +158,8 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 			start = extent_end + 1;
 		} else if (extent_start > start && extent_start < end) {
 			size = extent_start - start;
-			ret = btrfs_add_free_space_lock(block_group, start,
-							size);
+			ret = btrfs_add_free_space(block_group, start,
+						   size);
 			BUG_ON(ret);
 			start = extent_end + 1;
 		} else {
@@ -169,7 +169,7 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 
 	if (start < end) {
 		size = end - start;
-		ret = btrfs_add_free_space_lock(block_group, start, size);
+		ret = btrfs_add_free_space(block_group, start, size);
 		BUG_ON(ret);
 	}
 	mutex_unlock(&info->pinned_mutex);
@@ -2247,17 +2247,20 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 		 * should never happen
 		 */
 		WARN_ON(!block_group);
+
+		if (unlikely(!block_group->cached)) {
+			mutex_lock(&block_group->cache_mutex);
+			ret = cache_block_group(root, block_group);
+			mutex_unlock(&block_group->cache_mutex);
+			if (ret)
+				break;
+		}
+
 		mutex_lock(&block_group->alloc_mutex);
 		if (unlikely(!block_group_bits(block_group, data)))
 			goto new_group;
 
-		ret = cache_block_group(root, block_group);
-		if (ret) {
-			mutex_unlock(&block_group->alloc_mutex);
-			break;
-		}
-
-		if (block_group->ro)
+		if (unlikely(block_group->ro))
 			goto new_group;
 
 		free_space = btrfs_find_free_space(block_group, search_start,
@@ -2630,12 +2633,12 @@ int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_block_group_cache *block_group;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
-	mutex_lock(&block_group->alloc_mutex);
+	mutex_lock(&block_group->cache_mutex);
 	cache_block_group(root, block_group);
+	mutex_unlock(&block_group->cache_mutex);
 
-	ret = btrfs_remove_free_space_lock(block_group, ins->objectid,
-					   ins->offset);
-	mutex_unlock(&block_group->alloc_mutex);
+	ret = btrfs_remove_free_space(block_group, ins->objectid,
+				      ins->offset);
 	BUG_ON(ret);
 	ret = __btrfs_alloc_reserved_extent(trans, root, parent, root_objectid,
 					    ref_generation, owner, ins);
@@ -5156,6 +5159,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 		spin_lock_init(&cache->lock);
 		mutex_init(&cache->alloc_mutex);
+		mutex_init(&cache->cache_mutex);
 		INIT_LIST_HEAD(&cache->list);
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
@@ -5207,6 +5211,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->key.offset = size;
 	spin_lock_init(&cache->lock);
 	mutex_init(&cache->alloc_mutex);
+	mutex_init(&cache->cache_mutex);
 	INIT_LIST_HEAD(&cache->list);
 	btrfs_set_key_type(&cache->key, BTRFS_BLOCK_GROUP_ITEM_KEY);
 
