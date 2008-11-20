From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] updated fix for lockdep warnings with alloc_mutex and
	pinned_mutex
Date: Thu, 20 Nov 2008 11:22:34 -0500
Message-ID: <20081120162233.GB3013@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is the updated patch of the one I sent a few weeks ago.  It fixes this
lockdep complaint by having a different mutex to gaurd caching the block group,
so you don't end up with this backwards dependancy.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c83cc5b..b3b15ee 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -563,6 +563,7 @@ struct btrfs_block_group_cache {
 	struct btrfs_block_group_item item;
 	spinlock_t lock;
 	struct mutex alloc_mutex;
+	struct mutex cache_mutex;
 	u64 pinned;
 	u64 reserved;
 	u64 flags;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 55d6a66..956fbb1 100644
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
@@ -2177,17 +2177,19 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 		if (!block_group)
 			goto new_group_no_lock;
 
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
@@ -2604,12 +2606,12 @@ int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
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
@@ -5132,6 +5134,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 		spin_lock_init(&cache->lock);
 		mutex_init(&cache->alloc_mutex);
+		mutex_init(&cache->cache_mutex);
 		INIT_LIST_HEAD(&cache->list);
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
@@ -5183,6 +5186,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->key.offset = size;
 	spin_lock_init(&cache->lock);
 	mutex_init(&cache->alloc_mutex);
+	mutex_init(&cache->cache_mutex);
 	INIT_LIST_HEAD(&cache->list);
 	btrfs_set_key_type(&cache->key, BTRFS_BLOCK_GROUP_ITEM_KEY);
 
