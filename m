From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: dynamically remove unused block groups
Date: Tue, 30 Nov 2010 11:46:30 -0500
Message-ID: <1291135590-26775-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs only allocates chunks as we need them, however we do not delete chunks as
we stop using them.  This patch adds this capability.  Whenever we clear the
last bit of used space in a block group we try and mark it read only, and then
when the last pinned space is finally removed we queue up the deletion work.
I've tested this with xfstests and my enospc tests.  When filling up the disk
I see that we've allocated the entire disk of chunks, and then when I do rm *
there is a bunch of space freed up.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    3 +
 fs/btrfs/extent-tree.c |  148 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.c     |   52 +++++++++++------
 fs/btrfs/volumes.h     |    4 +
 4 files changed, 174 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8db9234..50ec64b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -839,6 +839,9 @@ struct btrfs_block_group_cache {
 	 * Today it will only have one thing on it, but that may change
 	 */
 	struct list_head cluster_list;
+
+	/* Worker for deleting the block group if its empty */
+	struct btrfs_work work;
 };
 
 struct reloc_control;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 43aa62a..87aae66 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -64,6 +64,11 @@ static int find_next_key(struct btrfs_path *path, int level,
 			 struct btrfs_key *key);
 static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 			    int dump_block_groups);
+static int btrfs_set_block_group_ro_trans(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_block_group_cache
+					  *cache);
+static int set_block_group_ro_lock(struct btrfs_block_group_cache *cache);
 
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
@@ -4052,6 +4057,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	u64 old_val;
 	u64 byte_in_group;
 	int factor;
+	int empty = 0;
 
 	/* block accounting for super block */
 	spin_lock(&info->delalloc_lock);
@@ -4064,6 +4070,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	spin_unlock(&info->delalloc_lock);
 
 	while (total) {
+		empty = 0;
 		cache = btrfs_lookup_block_group(info, bytenr);
 		if (!cache)
 			return -1;
@@ -4096,6 +4103,12 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		old_val = btrfs_block_group_used(&cache->item);
 		num_bytes = min(total, cache->key.offset - byte_in_group);
 		if (alloc) {
+			/*
+			 * We raced with setting the block group read only, we
+			 * need to change it back to rw
+			 */
+			if (cache->ro)
+				empty = -1;
 			old_val += num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
 			cache->reserved -= num_bytes;
@@ -4106,6 +4119,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			spin_unlock(&cache->space_info->lock);
 		} else {
 			old_val -= num_bytes;
+			if (old_val == 0)
+				empty = 1;
 			btrfs_set_block_group_used(&cache->item, old_val);
 			cache->pinned += num_bytes;
 			cache->space_info->bytes_pinned += num_bytes;
@@ -4118,6 +4133,29 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 					 bytenr, bytenr + num_bytes - 1,
 					 GFP_NOFS | __GFP_NOFAIL);
 		}
+		/*
+		 * So we need to deal with 2 cases here
+		 *
+		 * 1) empty == 1, which means the block group is empty and
+		 * needs to be marked ro so we can remove it later
+		 *
+		 * -or-
+		 *
+		 * 2) empty == -1, which means the block group was previously
+		 * empty and marked read only, but not before somebody tried to
+		 * make an allocation, so go ahead and mark it rw.
+		 */
+		switch (empty) {
+		case -1:
+			btrfs_set_block_group_rw(root, cache);
+			break;
+		case 1:
+			btrfs_set_block_group_ro_trans(trans, root, cache);
+			break;
+		default:
+			break;
+		}
+
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
 		bytenr += num_bytes;
@@ -4288,6 +4326,17 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 			cache->reserved_pinned -= len;
 			cache->space_info->bytes_reserved += len;
 		}
+
+		if (btrfs_block_group_used(&cache->item) == 0 &&
+		    cache->pinned == 0) {
+			int ret = 0;
+
+			if (!cache->ro)
+				ret = set_block_group_ro_lock(cache);
+			if (!ret)
+				btrfs_queue_worker(&fs_info->generic_worker,
+						   &cache->work);
+		}
 		spin_unlock(&cache->lock);
 		spin_unlock(&cache->space_info->lock);
 	}
@@ -7905,7 +7954,7 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 	return flags;
 }
 
-static int set_block_group_ro(struct btrfs_block_group_cache *cache)
+static int set_block_group_ro_lock(struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
 	u64 num_bytes;
@@ -7914,8 +7963,6 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache)
 	if (cache->ro)
 		return 0;
 
-	spin_lock(&sinfo->lock);
-	spin_lock(&cache->lock);
 	num_bytes = cache->key.offset - cache->reserved - cache->pinned -
 		    cache->bytes_super - btrfs_block_group_used(&cache->item);
 
@@ -7928,37 +7975,67 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache)
 		cache->ro = 1;
 		ret = 0;
 	}
+
+	return ret;
+}
+
+static int set_block_group_ro(struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_space_info *sinfo = cache->space_info;
+	int ret;
+
+	spin_lock(&sinfo->lock);
+	spin_lock(&cache->lock);
+	ret = set_block_group_ro_lock(cache);
 	spin_unlock(&cache->lock);
 	spin_unlock(&sinfo->lock);
+
 	return ret;
 }
 
-int btrfs_set_block_group_ro(struct btrfs_root *root,
-			     struct btrfs_block_group_cache *cache)
-
+static int btrfs_set_block_group_ro_trans(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_block_group_cache
+					  *cache)
 {
-	struct btrfs_trans_handle *trans;
 	u64 alloc_flags;
 	int ret;
+	bool alloc = true;
 
-	BUG_ON(cache->ro);
+	/*
+	 * If we're trying to set the block group as read only in a transaction
+	 * commit then avoid doing the chunk alloc to make lockdep happy.
+	 */
+	if (trans->transaction->in_commit)
+		alloc = false;
 
-	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(IS_ERR(trans));
+	if (cache->ro)
+		return 0;
 
 	alloc_flags = update_block_group_flags(root, cache->flags);
-	if (alloc_flags != cache->flags)
+	if (alloc && alloc_flags != cache->flags)
 		do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags, 1);
 
 	ret = set_block_group_ro(cache);
-	if (!ret)
-		goto out;
+	if (!ret || !alloc)
+		return ret;
 	alloc_flags = get_alloc_profile(root, cache->space_info->flags);
 	ret = do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags, 1);
 	if (ret < 0)
-		goto out;
-	ret = set_block_group_ro(cache);
-out:
+		return ret;
+	return set_block_group_ro(cache);
+}
+
+int btrfs_set_block_group_ro(struct btrfs_root *root,
+			     struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	trans = btrfs_join_transaction(root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+	ret = btrfs_set_block_group_ro_trans(trans, root, cache);
 	btrfs_end_transaction(trans, root);
 	return ret;
 }
@@ -8206,6 +8283,43 @@ static void __link_block_group(struct btrfs_space_info *space_info,
 	up_write(&space_info->groups_sem);
 }
 
+static void block_group_delete_fn(struct btrfs_work *work)
+{
+	struct btrfs_block_group_cache *cache;
+	struct btrfs_fs_info *info;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root;
+	u64 chunk_tree;
+	u64 chunk_objectid;
+	int ret;
+
+	/*
+	 * If anything fails in here, just mark the block group as rw and
+	 * return.
+	 */
+	cache = container_of(work, struct btrfs_block_group_cache, work);
+	info = cache->fs_info;
+	root = info->extent_root;
+	chunk_tree = info->chunk_root->root_key.objectid;
+	chunk_objectid = btrfs_block_group_chunk_objectid(&cache->item);
+
+	if (!cache->ro) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	trans = btrfs_start_transaction(info->extent_root, 0);
+	if (IS_ERR(trans)) {
+		btrfs_set_block_group_rw(root, cache);
+		return;
+	}
+	ret = btrfs_remove_chunk(trans, root, chunk_tree, chunk_objectid,
+				 cache->key.objectid);
+	if (ret)
+		btrfs_set_block_group_rw(root, cache);
+	btrfs_end_transaction(trans, root);
+}
+
 int btrfs_read_block_groups(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
@@ -8257,6 +8371,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		cache->fs_info = info;
 		INIT_LIST_HEAD(&cache->list);
 		INIT_LIST_HEAD(&cache->cluster_list);
+		cache->work.func = block_group_delete_fn;
 
 		if (need_clear)
 			cache->disk_cache_state = BTRFS_DC_CLEAR;
@@ -8379,6 +8494,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	spin_lock_init(&cache->tree_lock);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
+	cache->work.func = block_group_delete_fn;
 
 	btrfs_set_block_group_used(&cache->item, bytes_used);
 	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cc04dc1..49c055b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1726,13 +1726,13 @@ static int btrfs_del_sys_chunk(struct btrfs_root *root, u64 chunk_objectid, u64
 	return ret;
 }
 
-static int btrfs_relocate_chunk(struct btrfs_root *root,
-			 u64 chunk_tree, u64 chunk_objectid,
-			 u64 chunk_offset)
+int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
+		       u64 chunk_tree, u64 chunk_objectid,
+		       u64 chunk_offset)
 {
 	struct extent_map_tree *em_tree;
 	struct btrfs_root *extent_root;
-	struct btrfs_trans_handle *trans;
 	struct extent_map *em;
 	struct map_lookup *map;
 	int ret;
@@ -1742,18 +1742,6 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	extent_root = root->fs_info->extent_root;
 	em_tree = &root->fs_info->mapping_tree.map_tree;
 
-	ret = btrfs_can_relocate(extent_root, chunk_offset);
-	if (ret)
-		return -ENOSPC;
-
-	/* step one, relocate all the extents inside this chunk */
-	ret = btrfs_relocate_block_group(extent_root, chunk_offset);
-	if (ret)
-		return ret;
-
-	trans = btrfs_start_transaction(root, 0);
-	BUG_ON(!trans);
-
 	lock_chunks(root);
 
 	/*
@@ -1804,10 +1792,40 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	free_extent_map(em);
 
 	unlock_chunks(root);
-	btrfs_end_transaction(trans, root);
 	return 0;
 }
 
+static int btrfs_relocate_chunk(struct btrfs_root *root,
+			 u64 chunk_tree, u64 chunk_objectid,
+			 u64 chunk_offset)
+{
+	struct btrfs_root *extent_root;
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	root = root->fs_info->chunk_root;
+	extent_root = root->fs_info->extent_root;
+
+	ret = btrfs_can_relocate(extent_root, chunk_offset);
+	if (ret)
+		return -ENOSPC;
+
+	/* step one, relocate all the extents inside this chunk */
+	ret = btrfs_relocate_block_group(extent_root, chunk_offset);
+	if (ret)
+		return ret;
+
+	trans = btrfs_start_transaction(root, 0);
+	BUG_ON(!trans);
+
+	ret = btrfs_remove_chunk(trans, root, chunk_tree, chunk_objectid,
+				 chunk_offset);
+
+	btrfs_end_transaction(trans, root);
+
+	return ret;
+}
+
 static int btrfs_relocate_sys_chunks(struct btrfs_root *root)
 {
 	struct btrfs_root *chunk_root = root->fs_info->chunk_root;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2b638b6..4917cc0 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -183,4 +183,8 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
+		       u64 chunk_tree, u64 chunk_objectid,
+		       u64 chunk_offset);
 #endif
-- 
1.6.6.1

