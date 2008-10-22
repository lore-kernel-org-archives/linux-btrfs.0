From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] nuke fs wide allocation mutex V2
Date: Wed, 22 Oct 2008 08:47:52 -0400
Message-ID: <20081022124751.GD3929@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch removes the giant fs_info->alloc_mutex and replaces it with a bunch
of little locks.  There is now a pinned_mutex, which is used when messing with
the pinned_extents extent io tree, and the extent_ins_mutex which is used with
the pending_del and extent_ins extent io trees.  The locking for the extent tree                                                                                                                                                        
stuff was inspired by a patch that Yan Zheng wrote to fix a race condition, I                                                                                                                                                           
cleaned it up some and changed the locking around a little bit, but the idea                                                                                                                                                            
remains the same.  Basically instead of holding the extent_ins_mutex throughout                                                                                                                                                         
the processing of an extent on the extent_ins or pending_del trees, we just hold                                                                                                                                                        
it while we're searching and when we clear the bits on those trees, and lock the
extent for the duration of the operations on the extent.  Also to keep from  
getting hung up waiting to lock an extent, I've added a try_lock_extent so if we                                                                                                                                                        
cannot lock the extent, move on to the next one in the tree and we'll come back                  
to that one.  I have tested this heavily and it does not appear to break                                                                                                                                                                
anything.  This has to be applied on top of my find_free_extent redo patch.  I
tested this patch on top of Yan's space reblancing code and it worked fine.  The
only thing that has changed since the last version is I pulled out all my
debugging stuff, apparently I forgot to run guilt refresh before I sent the last
patch out.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 73899d0..f82f8db 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1387,8 +1387,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
 	WARN_ON(p->nodes[0] != NULL);
-	WARN_ON(cow && root == root->fs_info->extent_root &&
-		!mutex_is_locked(&root->fs_info->alloc_mutex));
+
 	if (ins_len < 0)
 		lowest_unlock = 2;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 80e7afb..1aa773d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -522,6 +522,7 @@ struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
 	spinlock_t lock;
+	struct mutex alloc_mutex;
 	u64 pinned;
 	u64 reserved;
 	u64 flags;
@@ -599,7 +600,8 @@ struct btrfs_fs_info {
 	struct mutex tree_log_mutex;
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
-	struct mutex alloc_mutex;
+	struct mutex extent_ins_mutex;
+	struct mutex pinned_mutex;
 	struct mutex chunk_mutex;
 	struct mutex drop_mutex;
 	struct mutex volume_mutex;
@@ -1878,8 +1880,12 @@ int btrfs_acl_chmod(struct inode *inode);
 /* free-space-cache.c */
 int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 			 u64 bytenr, u64 size);
+int btrfs_add_free_space_lock(struct btrfs_block_group_cache *block_group,
+			      u64 offset, u64 bytes);
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			    u64 bytenr, u64 size);
+int btrfs_remove_free_space_lock(struct btrfs_block_group_cache *block_group,
+				 u64 offset, u64 bytes);
 void btrfs_remove_free_space_cache(struct btrfs_block_group_cache
 				   *block_group);
 struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 21ac708..7e67960 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1455,7 +1455,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->trans_mutex);
 	mutex_init(&fs_info->tree_log_mutex);
 	mutex_init(&fs_info->drop_mutex);
-	mutex_init(&fs_info->alloc_mutex);
+	mutex_init(&fs_info->extent_ins_mutex);
+	mutex_init(&fs_info->pinned_mutex);
 	mutex_init(&fs_info->chunk_mutex);
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f22a627..ccaac6f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -53,24 +53,6 @@ __btrfs_find_block_group(struct btrfs_root *root,
 			 struct btrfs_block_group_cache *hint,
 			 u64 search_start, int data, int owner);
 
-void maybe_lock_mutex(struct btrfs_root *root)
-{
-	if (root != root->fs_info->extent_root &&
-	    root != root->fs_info->chunk_root &&
-	    root != root->fs_info->dev_root) {
-		mutex_lock(&root->fs_info->alloc_mutex);
-	}
-}
-
-void maybe_unlock_mutex(struct btrfs_root *root)
-{
-	if (root != root->fs_info->extent_root &&
-	    root != root->fs_info->chunk_root &&
-	    root != root->fs_info->dev_root) {
-		mutex_unlock(&root->fs_info->alloc_mutex);
-	}
-}
-
 static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
 {
 	return (cache->flags & bits) == bits;
@@ -164,6 +146,7 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 	u64 extent_start, extent_end, size;
 	int ret;
 
+	mutex_lock(&info->pinned_mutex);
 	while (start < end) {
 		ret = find_first_extent_bit(&info->pinned_extents, start,
 					    &extent_start, &extent_end,
@@ -175,7 +158,8 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 			start = extent_end + 1;
 		} else if (extent_start > start && extent_start < end) {
 			size = extent_start - start;
-			ret = btrfs_add_free_space(block_group, start, size);
+			ret = btrfs_add_free_space_lock(block_group, start,
+							size);
 			BUG_ON(ret);
 			start = extent_end + 1;
 		} else {
@@ -185,9 +169,10 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 
 	if (start < end) {
 		size = end - start;
-		ret = btrfs_add_free_space(block_group, start, size);
+		ret = btrfs_add_free_space_lock(block_group, start, size);
 		BUG_ON(ret);
 	}
+	mutex_unlock(&info->pinned_mutex);
 
 	return 0;
 }
@@ -445,13 +430,11 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
-	maybe_lock_mutex(root);
 	key.objectid = start;
 	key.offset = len;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
 	ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key, path,
 				0, 0);
-	maybe_unlock_mutex(root);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -676,8 +659,9 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 
 		BUG_ON(owner_objectid >= BTRFS_MAX_LEVEL);
 		num_bytes = btrfs_level_size(root, (int)owner_objectid);
+		mutex_lock(&root->fs_info->extent_ins_mutex);
 		if (test_range_bit(&root->fs_info->extent_ins, bytenr,
-				bytenr + num_bytes - 1, EXTENT_LOCKED, 0)) {
+				bytenr + num_bytes - 1, EXTENT_WRITEBACK, 0)) {
 			u64 priv;
 			ret = get_state_private(&root->fs_info->extent_ins,
 						bytenr, &priv);
@@ -686,6 +670,7 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 							(unsigned long)priv;
 			BUG_ON(extent_op->parent != orig_parent);
 			BUG_ON(extent_op->generation != orig_generation);
+
 			extent_op->parent = parent;
 			extent_op->generation = ref_generation;
 		} else {
@@ -703,10 +688,11 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 
 			set_extent_bits(&root->fs_info->extent_ins,
 					bytenr, bytenr + num_bytes - 1,
-					EXTENT_LOCKED, GFP_NOFS);
+					EXTENT_WRITEBACK, GFP_NOFS);
 			set_state_private(&root->fs_info->extent_ins,
 					  bytenr, (unsigned long)extent_op);
 		}
+		mutex_unlock(&root->fs_info->extent_ins_mutex);
 		return 0;
 	}
 
@@ -742,12 +728,10 @@ int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
 	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
 		return 0;
-	maybe_lock_mutex(root);
 	ret = __btrfs_update_extent_ref(trans, root, bytenr, orig_parent,
 					parent, ref_root, ref_root,
 					ref_generation, ref_generation,
 					owner_objectid);
-	maybe_unlock_mutex(root);
 	return ret;
 }
 
@@ -817,11 +801,9 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
 	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
 		return 0;
-	maybe_lock_mutex(root);
 	ret = __btrfs_inc_extent_ref(trans, root, bytenr, 0, parent,
 				     0, ref_root, 0, ref_generation,
 				     owner_objectid);
-	maybe_unlock_mutex(root);
 	return ret;
 }
 
@@ -886,7 +868,6 @@ static int get_reference_status(struct btrfs_root *root, u64 bytenr,
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 
 	path = btrfs_alloc_path();
-	mutex_lock(&root->fs_info->alloc_mutex);
 	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
@@ -953,7 +934,6 @@ static int get_reference_status(struct btrfs_root *root, u64 bytenr,
 	}
 	ret = 0;
 out:
-	mutex_unlock(&root->fs_info->alloc_mutex);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -1179,13 +1159,11 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 			nr_file_extents++;
 
-			maybe_lock_mutex(root);
 			ret = process_func(trans, root, bytenr,
 					   orig_buf->start, buf->start,
 					   orig_root, ref_root,
 					   orig_generation, ref_generation,
 					   key.objectid);
-			maybe_unlock_mutex(root);
 
 			if (ret) {
 				faili = i;
@@ -1194,13 +1172,11 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			}
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
-			maybe_lock_mutex(root);
 			ret = process_func(trans, root, bytenr,
 					   orig_buf->start, buf->start,
 					   orig_root, ref_root,
 					   orig_generation, ref_generation,
 					   level - 1);
-			maybe_unlock_mutex(root);
 			if (ret) {
 				faili = i;
 				WARN_ON(1);
@@ -1270,24 +1246,20 @@ int btrfs_update_ref(struct btrfs_trans_handle *trans,
 			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
 			if (bytenr == 0)
 				continue;
-			maybe_lock_mutex(root);
 			ret = __btrfs_update_extent_ref(trans, root, bytenr,
 					    orig_buf->start, buf->start,
 					    orig_root, ref_root,
 					    orig_generation, ref_generation,
 					    key.objectid);
-			maybe_unlock_mutex(root);
 			if (ret)
 				goto fail;
 		} else {
 			bytenr = btrfs_node_blockptr(buf, slot);
-			maybe_lock_mutex(root);
 			ret = __btrfs_update_extent_ref(trans, root, bytenr,
 					    orig_buf->start, buf->start,
 					    orig_root, ref_root,
 					    orig_generation, ref_generation,
 					    level - 1);
-			maybe_unlock_mutex(root);
 			if (ret)
 				goto fail;
 		}
@@ -1344,7 +1316,6 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	mutex_lock(&root->fs_info->alloc_mutex);
 	while(1) {
 		cache = NULL;
 		spin_lock(&root->fs_info->block_group_cache_lock);
@@ -1378,7 +1349,6 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 		}
 	}
 	btrfs_free_path(path);
-	mutex_unlock(&root->fs_info->alloc_mutex);
 	return werr;
 }
 
@@ -1390,9 +1360,11 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 
 	found = __find_space_info(info, flags);
 	if (found) {
+		spin_lock(&found->lock);
 		found->total_bytes += total_bytes;
 		found->bytes_used += bytes_used;
 		found->full = 0;
+		spin_unlock(&found->lock);
 		*space_info = found;
 		return 0;
 	}
@@ -1479,43 +1451,53 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	}
 	BUG_ON(!space_info);
 
+	spin_lock(&space_info->lock);
 	if (space_info->force_alloc) {
 		force = 1;
 		space_info->force_alloc = 0;
 	}
-	if (space_info->full)
+	if (space_info->full) {
+		spin_unlock(&space_info->lock);
 		goto out;
+	}
 
 	thresh = div_factor(space_info->total_bytes, 6);
 	if (!force &&
 	   (space_info->bytes_used + space_info->bytes_pinned +
-	    space_info->bytes_reserved + alloc_bytes) < thresh)
+	    space_info->bytes_reserved + alloc_bytes) < thresh) {
+		spin_unlock(&space_info->lock);
 		goto out;
+	}
 
-	while (!mutex_trylock(&extent_root->fs_info->chunk_mutex)) {
-		if (!force)
-			goto out;
-		mutex_unlock(&extent_root->fs_info->alloc_mutex);
-		cond_resched();
-		mutex_lock(&extent_root->fs_info->alloc_mutex);
+	spin_unlock(&space_info->lock);
+
+	ret = mutex_trylock(&extent_root->fs_info->chunk_mutex);
+	if (!ret && !force) {
+		goto out;
+	} else if (!ret) {
+		mutex_lock(&extent_root->fs_info->chunk_mutex);
 		waited = 1;
 	}
 
-	if (waited && space_info->full)
-		goto out_unlock;
+	if (waited) {
+		spin_lock(&space_info->lock);
+		if (space_info->full) {
+			spin_unlock(&space_info->lock);
+			goto out_unlock;
+		}
+		spin_unlock(&space_info->lock);
+	}
 
 	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags);
-	if (ret == -ENOSPC) {
+	if (ret) {
 printk("space info full %Lu\n", flags);
 		space_info->full = 1;
 		goto out_unlock;
 	}
-	BUG_ON(ret);
 
 	ret = btrfs_make_block_group(trans, extent_root, 0, flags,
 		     BTRFS_FIRST_CHUNK_TREE_OBJECTID, start, num_bytes);
 	BUG_ON(ret);
-
 out_unlock:
 	mutex_unlock(&extent_root->fs_info->chunk_mutex);
 out:
@@ -1533,7 +1515,6 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	u64 old_val;
 	u64 byte_in_group;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	while(total) {
 		cache = btrfs_lookup_block_group(info, bytenr);
 		if (!cache) {
@@ -1542,6 +1523,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		byte_in_group = bytenr - cache->key.objectid;
 		WARN_ON(byte_in_group > cache->key.offset);
 
+		spin_lock(&cache->space_info->lock);
 		spin_lock(&cache->lock);
 		cache->dirty = 1;
 		old_val = btrfs_block_group_used(&cache->item);
@@ -1551,11 +1533,13 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			cache->space_info->bytes_used += num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
 			spin_unlock(&cache->lock);
+			spin_unlock(&cache->space_info->lock);
 		} else {
 			old_val -= num_bytes;
 			cache->space_info->bytes_used -= num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
 			spin_unlock(&cache->lock);
+			spin_unlock(&cache->space_info->lock);
 			if (mark_free) {
 				int ret;
 				ret = btrfs_add_free_space(cache, bytenr,
@@ -1588,7 +1572,7 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
+	WARN_ON(!mutex_is_locked(&root->fs_info->pinned_mutex));
 	if (pin) {
 		set_extent_dirty(&fs_info->pinned_extents,
 				bytenr, bytenr + num - 1, GFP_NOFS);
@@ -1602,16 +1586,20 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
 		len = min(num, cache->key.offset -
 			  (bytenr - cache->key.objectid));
 		if (pin) {
+			spin_lock(&cache->space_info->lock);
 			spin_lock(&cache->lock);
 			cache->pinned += len;
 			cache->space_info->bytes_pinned += len;
 			spin_unlock(&cache->lock);
+			spin_unlock(&cache->space_info->lock);
 			fs_info->total_pinned += len;
 		} else {
+			spin_lock(&cache->space_info->lock);
 			spin_lock(&cache->lock);
 			cache->pinned -= len;
 			cache->space_info->bytes_pinned -= len;
 			spin_unlock(&cache->lock);
+			spin_unlock(&cache->space_info->lock);
 			fs_info->total_pinned -= len;
 		}
 		bytenr += len;
@@ -1627,23 +1615,23 @@ static int update_reserved_extents(struct btrfs_root *root,
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	while (num > 0) {
 		cache = btrfs_lookup_block_group(fs_info, bytenr);
 		BUG_ON(!cache);
 		len = min(num, cache->key.offset -
 			  (bytenr - cache->key.objectid));
+
+		spin_lock(&cache->space_info->lock);
+		spin_lock(&cache->lock);
 		if (reserve) {
-			spin_lock(&cache->lock);
 			cache->reserved += len;
 			cache->space_info->bytes_reserved += len;
-			spin_unlock(&cache->lock);
 		} else {
-			spin_lock(&cache->lock);
 			cache->reserved -= len;
 			cache->space_info->bytes_reserved -= len;
-			spin_unlock(&cache->lock);
 		}
+		spin_unlock(&cache->lock);
+		spin_unlock(&cache->space_info->lock);
 		bytenr += len;
 		num -= len;
 	}
@@ -1658,6 +1646,7 @@ int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
 	struct extent_io_tree *pinned_extents = &root->fs_info->pinned_extents;
 	int ret;
 
+	mutex_lock(&root->fs_info->pinned_mutex);
 	while(1) {
 		ret = find_first_extent_bit(pinned_extents, last,
 					    &start, &end, EXTENT_DIRTY);
@@ -1666,6 +1655,7 @@ int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
 		set_extent_dirty(copy, start, end, GFP_NOFS);
 		last = end + 1;
 	}
+	mutex_unlock(&root->fs_info->pinned_mutex);
 	return 0;
 }
 
@@ -1678,7 +1668,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	int ret;
 	struct btrfs_block_group_cache *cache;
 
-	mutex_lock(&root->fs_info->alloc_mutex);
+	mutex_lock(&root->fs_info->pinned_mutex);
 	while(1) {
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
 					    EXTENT_DIRTY);
@@ -1690,12 +1680,12 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 		if (cache->cached)
 			btrfs_add_free_space(cache, start, end - start + 1);
 		if (need_resched()) {
-			mutex_unlock(&root->fs_info->alloc_mutex);
+			mutex_unlock(&root->fs_info->pinned_mutex);
 			cond_resched();
-			mutex_lock(&root->fs_info->alloc_mutex);
+			mutex_lock(&root->fs_info->pinned_mutex);
 		}
 	}
-	mutex_unlock(&root->fs_info->alloc_mutex);
+	mutex_unlock(&root->fs_info->pinned_mutex);
 	return 0;
 }
 
@@ -1705,6 +1695,7 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	u64 start;
 	u64 end;
 	u64 priv;
+	u64 search = 0;
 	struct btrfs_fs_info *info = extent_root->fs_info;
 	struct btrfs_path *path;
 	struct btrfs_extent_ref *ref;
@@ -1714,20 +1705,37 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	int ret;
 	int err = 0;
 
-	WARN_ON(!mutex_is_locked(&extent_root->fs_info->alloc_mutex));
 	btrfs_set_stack_extent_refs(&extent_item, 1);
 	path = btrfs_alloc_path();
 
 	while(1) {
-		ret = find_first_extent_bit(&info->extent_ins, 0, &start,
-					    &end, EXTENT_LOCKED);
-		if (ret)
+		mutex_lock(&info->extent_ins_mutex);
+		ret = find_first_extent_bit(&info->extent_ins, search, &start,
+					    &end, EXTENT_WRITEBACK);
+		if (ret) {
+			mutex_unlock(&info->extent_ins_mutex);
+			if (search) {
+				search = 0;
+				continue;
+			}
 			break;
+		}
+
+		ret = try_lock_extent(&info->extent_ins, start, end, GFP_NOFS);
+		if (!ret) {
+			search = end+1;
+			mutex_unlock(&info->extent_ins_mutex);
+			cond_resched();
+			continue;
+		}
+		BUG_ON(ret < 0);
 
 		ret = get_state_private(&info->extent_ins, start, &priv);
 		BUG_ON(ret);
 		extent_op = (struct pending_extent_op *)(unsigned long)priv;
 
+		mutex_unlock(&info->extent_ins_mutex);
+
 		if (extent_op->type == PENDING_EXTENT_INSERT) {
 			key.objectid = start;
 			key.offset = end + 1 - start;
@@ -1736,8 +1744,10 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 					&extent_item, sizeof(extent_item));
 			BUG_ON(err);
 
+			mutex_lock(&info->extent_ins_mutex);
 			clear_extent_bits(&info->extent_ins, start, end,
-					  EXTENT_LOCKED, GFP_NOFS);
+					  EXTENT_WRITEBACK, GFP_NOFS);
+			mutex_unlock(&info->extent_ins_mutex);
 
 			err = insert_extent_backref(trans, extent_root, path,
 						start, extent_op->parent,
@@ -1753,8 +1763,10 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 						extent_op->level, 0);
 			BUG_ON(err);
 
+			mutex_lock(&info->extent_ins_mutex);
 			clear_extent_bits(&info->extent_ins, start, end,
-					  EXTENT_LOCKED, GFP_NOFS);
+					  EXTENT_WRITEBACK, GFP_NOFS);
+			mutex_unlock(&info->extent_ins_mutex);
 
 			key.objectid = start;
 			key.offset = extent_op->parent;
@@ -1772,12 +1784,10 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 			BUG_ON(1);
 		}
 		kfree(extent_op);
+		unlock_extent(&info->extent_ins, start, end, GFP_NOFS);
+		search = 0;
 
-		if (need_resched()) {
-			mutex_unlock(&extent_root->fs_info->alloc_mutex);
-			cond_resched();
-			mutex_lock(&extent_root->fs_info->alloc_mutex);
-		}
+		cond_resched();
 	}
 	btrfs_free_path(path);
 	return 0;
@@ -1790,7 +1800,6 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 	int err = 0;
 	struct extent_buffer *buf;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	if (is_data)
 		goto pinit;
 
@@ -1847,7 +1856,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_item *ei;
 	u32 refs;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	key.objectid = bytenr;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
 	key.offset = num_bytes;
@@ -1935,8 +1943,10 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 #endif
 
 		if (pin) {
+			mutex_lock(&root->fs_info->pinned_mutex);
 			ret = pin_down_bytes(trans, root, bytenr, num_bytes,
 				owner_objectid >= BTRFS_FIRST_FREE_OBJECTID);
+			mutex_unlock(&root->fs_info->pinned_mutex);
 			if (ret > 0)
 				mark_free = 1;
 			BUG_ON(ret < 0);
@@ -1956,6 +1966,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
 		BUG_ON(ret);
+		btrfs_release_path(extent_root, path);
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
 					 mark_free);
 		BUG_ON(ret);
@@ -1994,70 +2005,91 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 {
 	int ret;
 	int err = 0;
-	int mark_free = 0;
 	u64 start;
 	u64 end;
 	u64 priv;
+	u64 search = 0;
 	struct extent_io_tree *pending_del;
 	struct extent_io_tree *extent_ins;
 	struct pending_extent_op *extent_op;
+	struct btrfs_fs_info *info = extent_root->fs_info;
 
-	WARN_ON(!mutex_is_locked(&extent_root->fs_info->alloc_mutex));
 	extent_ins = &extent_root->fs_info->extent_ins;
 	pending_del = &extent_root->fs_info->pending_del;
 
 	while(1) {
-		ret = find_first_extent_bit(pending_del, 0, &start, &end,
-					    EXTENT_LOCKED);
-		if (ret)
+		mutex_lock(&info->extent_ins_mutex);
+		ret = find_first_extent_bit(pending_del, search, &start, &end,
+					    EXTENT_WRITEBACK);
+		if (ret) {
+			mutex_unlock(&info->extent_ins_mutex);
+			if (search) {
+				search = 0;
+				continue;
+			}
 			break;
+		}
+
+		ret = try_lock_extent(extent_ins, start, end, GFP_NOFS);
+		if (!ret) {
+			search = end+1;
+			mutex_unlock(&info->extent_ins_mutex);
+			cond_resched();
+			continue;
+		}
+		BUG_ON(ret < 0);
 
 		ret = get_state_private(pending_del, start, &priv);
 		BUG_ON(ret);
 		extent_op = (struct pending_extent_op *)(unsigned long)priv;
 
-		clear_extent_bits(pending_del, start, end, EXTENT_LOCKED,
+		clear_extent_bits(pending_del, start, end, EXTENT_WRITEBACK,
 				  GFP_NOFS);
-
-		ret = pin_down_bytes(trans, extent_root, start,
-				     end + 1 - start, 0);
-		mark_free = ret > 0;
 		if (!test_range_bit(extent_ins, start, end,
-				    EXTENT_LOCKED, 0)) {
+				    EXTENT_WRITEBACK, 0)) {
+			mutex_unlock(&info->extent_ins_mutex);
 free_extent:
 			ret = __free_extent(trans, extent_root,
 					    start, end + 1 - start,
 					    extent_op->orig_parent,
 					    extent_root->root_key.objectid,
 					    extent_op->orig_generation,
-					    extent_op->level, 0, mark_free);
+					    extent_op->level, 1, 0);
 			kfree(extent_op);
 		} else {
 			kfree(extent_op);
-			ret = get_state_private(extent_ins, start, &priv);
+
+			ret = get_state_private(&info->extent_ins, start,
+						&priv);
 			BUG_ON(ret);
 			extent_op = (struct pending_extent_op *)
-							(unsigned long)priv;
+						(unsigned long)priv;
+
+			clear_extent_bits(&info->extent_ins, start, end,
+					  EXTENT_WRITEBACK, GFP_NOFS);
 
-			clear_extent_bits(extent_ins, start, end,
-					  EXTENT_LOCKED, GFP_NOFS);
+			mutex_unlock(&info->extent_ins_mutex);
 
 			if (extent_op->type == PENDING_BACKREF_UPDATE)
 				goto free_extent;
 
+			mutex_lock(&extent_root->fs_info->pinned_mutex);
+			ret = pin_down_bytes(trans, extent_root, start,
+					     end + 1 - start, 0);
+			mutex_unlock(&extent_root->fs_info->pinned_mutex);
+
 			ret = update_block_group(trans, extent_root, start,
-						end + 1 - start, 0, mark_free);
+						end + 1 - start, 0, ret > 0);
+
 			BUG_ON(ret);
 			kfree(extent_op);
 		}
 		if (ret)
 			err = ret;
+		unlock_extent(extent_ins, start, end, GFP_NOFS);
 
-		if (need_resched()) {
-			mutex_unlock(&extent_root->fs_info->alloc_mutex);
-			cond_resched();
-			mutex_lock(&extent_root->fs_info->alloc_mutex);
-		}
+		search = 0;
+		cond_resched();
 	}
 	return err;
 }
@@ -2091,11 +2123,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		extent_op->orig_generation = ref_generation;
 		extent_op->level = (int)owner_objectid;
 
+		mutex_lock(&root->fs_info->extent_ins_mutex);
 		set_extent_bits(&root->fs_info->pending_del,
 				bytenr, bytenr + num_bytes - 1,
-				EXTENT_LOCKED, GFP_NOFS);
+				EXTENT_WRITEBACK, GFP_NOFS);
 		set_state_private(&root->fs_info->pending_del,
 				  bytenr, (unsigned long)extent_op);
+		mutex_unlock(&root->fs_info->extent_ins_mutex);
 		return 0;
 	}
 	/* if metadata always pin */
@@ -2134,11 +2168,9 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	maybe_lock_mutex(root);
 	ret = __btrfs_free_extent(trans, root, bytenr, num_bytes, parent,
 				  root_objectid, ref_generation,
 				  owner_objectid, pin);
-	maybe_unlock_mutex(root);
 	return ret;
 }
 
@@ -2214,12 +2246,16 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 		 * group thats not of the proper type, while looping this
 		 * should never happen
 		 */
+		WARN_ON(!block_group);
+		mutex_lock(&block_group->alloc_mutex);
 		if (unlikely(!block_group_bits(block_group, data)))
 			goto new_group;
 
 		ret = cache_block_group(root, block_group);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&block_group->alloc_mutex);
 			break;
+		}
 
 		if (block_group->ro)
 			goto new_group;
@@ -2250,8 +2286,10 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 				 * then we just re-search this block group
 				 */
 				if (search_start >= start &&
-				    search_start < end)
+				    search_start < end) {
+					mutex_unlock(&block_group->alloc_mutex);
 					continue;
+				}
 
 				/* else we go to the next block group */
 				goto new_group;
@@ -2259,10 +2297,15 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 
 			ins->objectid = search_start;
 			ins->offset = num_bytes;
+
+			btrfs_remove_free_space_lock(block_group, search_start,
+						     num_bytes);
 			/* we are all good, lets return */
+			mutex_unlock(&block_group->alloc_mutex);
 			break;
 		}
 new_group:
+		mutex_unlock(&block_group->alloc_mutex);
 		/*
 		 * Here's how this works.
 		 * loop == 0: we were searching a block group via a hint
@@ -2363,7 +2406,6 @@ static int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 	u64 search_start = 0;
 	u64 alloc_profile;
 	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_block_group_cache *cache;
 
 	if (data) {
 		alloc_profile = info->avail_data_alloc_bits &
@@ -2419,13 +2461,6 @@ again:
 		dump_space_info(sinfo, num_bytes);
 		BUG();
 	}
-	cache = btrfs_lookup_block_group(root->fs_info, ins->objectid);
-	if (!cache) {
-		printk(KERN_ERR "Unable to find block group for %Lu\n", ins->objectid);
-		return -ENOSPC;
-	}
-
-	ret = btrfs_remove_free_space(cache, ins->objectid, ins->offset);
 
 	return ret;
 }
@@ -2434,16 +2469,13 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 {
 	struct btrfs_block_group_cache *cache;
 
-	maybe_lock_mutex(root);
 	cache = btrfs_lookup_block_group(root->fs_info, start);
 	if (!cache) {
 		printk(KERN_ERR "Unable to find block group for %Lu\n", start);
-		maybe_unlock_mutex(root);
 		return -ENOSPC;
 	}
 	btrfs_add_free_space(cache, start, len);
 	update_reserved_extents(root, start, len, 0);
-	maybe_unlock_mutex(root);
 	return 0;
 }
 
@@ -2455,12 +2487,10 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  u64 data)
 {
 	int ret;
-	maybe_lock_mutex(root);
 	ret = __btrfs_reserve_extent(trans, root, num_bytes, min_alloc_size,
 				     empty_size, hint_byte, search_end, ins,
 				     data);
 	update_reserved_extents(root, ins->objectid, ins->offset, 1);
-	maybe_unlock_mutex(root);
 	return ret;
 }
 
@@ -2510,11 +2540,13 @@ static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 		extent_op->orig_generation = 0;
 		extent_op->level = (int)owner;
 
+		mutex_lock(&root->fs_info->extent_ins_mutex);
 		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
 				ins->objectid + ins->offset - 1,
-				EXTENT_LOCKED, GFP_NOFS);
+				EXTENT_WRITEBACK, GFP_NOFS);
 		set_state_private(&root->fs_info->extent_ins,
 				  ins->objectid, (unsigned long)extent_op);
+		mutex_unlock(&root->fs_info->extent_ins_mutex);
 		goto update_block;
 	}
 
@@ -2578,11 +2610,9 @@ int btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 
 	if (root_objectid == BTRFS_TREE_LOG_OBJECTID)
 		return 0;
-	maybe_lock_mutex(root);
 	ret = __btrfs_alloc_reserved_extent(trans, root, parent, root_objectid,
 					    ref_generation, owner, ins);
 	update_reserved_extents(root, ins->objectid, ins->offset, 0);
-	maybe_unlock_mutex(root);
 	return ret;
 }
 
@@ -2599,15 +2629,16 @@ int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
 	int ret;
 	struct btrfs_block_group_cache *block_group;
 
-	maybe_lock_mutex(root);
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
+	mutex_lock(&block_group->alloc_mutex);
 	cache_block_group(root, block_group);
 
-	ret = btrfs_remove_free_space(block_group, ins->objectid, ins->offset);
+	ret = btrfs_remove_free_space_lock(block_group, ins->objectid,
+					   ins->offset);
+	mutex_unlock(&block_group->alloc_mutex);
 	BUG_ON(ret);
 	ret = __btrfs_alloc_reserved_extent(trans, root, parent, root_objectid,
 					    ref_generation, owner, ins);
-	maybe_unlock_mutex(root);
 	return ret;
 }
 
@@ -2627,8 +2658,6 @@ int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	maybe_lock_mutex(root);
-
 	ret = __btrfs_reserve_extent(trans, root, num_bytes,
 				     min_alloc_size, empty_size, hint_byte,
 				     search_end, ins, data);
@@ -2642,7 +2671,6 @@ int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 	} else {
 		update_reserved_extents(root, ins->objectid, ins->offset, 1);
 	}
-	maybe_unlock_mutex(root);
 	return ret;
 }
 
@@ -2734,12 +2762,10 @@ int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
 		if (disk_bytenr == 0)
 			continue;
 
-		mutex_lock(&root->fs_info->alloc_mutex);
 		ret = __btrfs_free_extent(trans, root, disk_bytenr,
 				btrfs_file_extent_disk_num_bytes(leaf, fi),
 				leaf->start, leaf_owner, leaf_generation,
 				key.objectid, 0);
-		mutex_unlock(&root->fs_info->alloc_mutex);
 		BUG_ON(ret);
 
 		atomic_inc(&root->fs_info->throttle_gen);
@@ -2758,12 +2784,10 @@ static int noinline cache_drop_leaf_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_info *info = ref->extents;
 
 	for (i = 0; i < ref->nritems; i++) {
-		mutex_lock(&root->fs_info->alloc_mutex);
 		ret = __btrfs_free_extent(trans, root, info->bytenr,
 					  info->num_bytes, ref->bytenr,
 					  ref->owner, ref->generation,
 					  info->objectid, 0);
-		mutex_unlock(&root->fs_info->alloc_mutex);
 
 		atomic_inc(&root->fs_info->throttle_gen);
 		wake_up(&root->fs_info->transaction_throttle);
@@ -2875,13 +2899,11 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
 			root_gen = btrfs_header_generation(parent);
 			path->slots[*level]++;
 
-			mutex_lock(&root->fs_info->alloc_mutex);
 			ret = __btrfs_free_extent(trans, root, bytenr,
 						blocksize, parent->start,
 						root_owner, root_gen,
 						*level - 1, 1);
 			BUG_ON(ret);
-			mutex_unlock(&root->fs_info->alloc_mutex);
 
 			atomic_inc(&root->fs_info->throttle_gen);
 			wake_up(&root->fs_info->transaction_throttle);
@@ -2957,11 +2979,9 @@ out:
 	root_owner = btrfs_header_owner(parent);
 	root_gen = btrfs_header_generation(parent);
 
-	mutex_lock(&root->fs_info->alloc_mutex);
 	ret = __btrfs_free_extent(trans, root, bytenr, blocksize,
 				  parent->start, root_owner, root_gen,
 				  *level, 1);
-	mutex_unlock(&root->fs_info->alloc_mutex);
 	free_extent_buffer(path->nodes[*level]);
 	path->nodes[*level] = NULL;
 	*level += 1;
@@ -3435,8 +3455,6 @@ static int noinline __next_ref_path(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	mutex_lock(&extent_root->fs_info->alloc_mutex);
-
 	if (first_time) {
 		ref_path->lowest_level = -1;
 		ref_path->current_level = -1;
@@ -3493,9 +3511,7 @@ next:
 		level--;
 		btrfs_release_path(extent_root, path);
 		if (need_resched()) {
-			mutex_unlock(&extent_root->fs_info->alloc_mutex);
 			cond_resched();
-			mutex_lock(&extent_root->fs_info->alloc_mutex);
 		}
 	}
 	/* reached lowest level */
@@ -3608,15 +3624,12 @@ found:
 
 		btrfs_release_path(extent_root, path);
 		if (need_resched()) {
-			mutex_unlock(&extent_root->fs_info->alloc_mutex);
 			cond_resched();
-			mutex_lock(&extent_root->fs_info->alloc_mutex);
 		}
 	}
 	/* reached max tree level, but no tree root found. */
 	BUG();
 out:
-	mutex_unlock(&extent_root->fs_info->alloc_mutex);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -4532,14 +4545,6 @@ static int noinline relocate_tree_block(struct btrfs_trans_handle *trans,
 					struct btrfs_ref_path *ref_path)
 {
 	int ret;
-	int needs_lock = 0;
-
-	if (root == root->fs_info->extent_root ||
-	    root == root->fs_info->chunk_root ||
-	    root == root->fs_info->dev_root) {
-		needs_lock = 1;
-		mutex_lock(&root->fs_info->alloc_mutex);
-	}
 
 	ret = relocate_one_path(trans, root, path, first_key,
 				ref_path, NULL, NULL);
@@ -4547,8 +4552,6 @@ static int noinline relocate_tree_block(struct btrfs_trans_handle *trans,
 
 	if (root == root->fs_info->extent_root)
 		btrfs_extent_post_op(trans, root);
-	if (needs_lock)
-		mutex_unlock(&root->fs_info->alloc_mutex);
 
 	return 0;
 }
@@ -4560,14 +4563,12 @@ static int noinline del_extent_zero(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	mutex_lock(&extent_root->fs_info->alloc_mutex);
 	ret = btrfs_search_slot(trans, extent_root, extent_key, path, -1, 1);
 	if (ret)
 		goto out;
 	ret = btrfs_del_item(trans, extent_root, path);
 out:
 	btrfs_release_path(extent_root, path);
-	mutex_unlock(&extent_root->fs_info->alloc_mutex);
 	return ret;
 }
 
@@ -4603,7 +4604,6 @@ static int noinline relocate_one_extent(struct btrfs_root *extent_root,
 	struct btrfs_key first_key;
 	u64 prev_block = 0;
 
-	mutex_unlock(&extent_root->fs_info->alloc_mutex);
 
 	trans = btrfs_start_transaction(extent_root, 1);
 	BUG_ON(!trans);
@@ -4730,7 +4730,6 @@ out:
 	btrfs_end_transaction(trans, extent_root);
 	kfree(new_extents);
 	kfree(ref_path);
-	mutex_lock(&extent_root->fs_info->alloc_mutex);
 	return ret;
 }
 
@@ -4783,10 +4782,8 @@ int __alloc_chunk_for_shrink(struct btrfs_root *root,
 	spin_lock(&shrink_block_group->lock);
 	if (btrfs_block_group_used(&shrink_block_group->item) > 0) {
 		spin_unlock(&shrink_block_group->lock);
-		mutex_unlock(&root->fs_info->alloc_mutex);
 
 		trans = btrfs_start_transaction(root, 1);
-		mutex_lock(&root->fs_info->alloc_mutex);
 		spin_lock(&shrink_block_group->lock);
 
 		new_alloc_flags = update_block_group_flags(root,
@@ -4802,9 +4799,7 @@ int __alloc_chunk_for_shrink(struct btrfs_root *root,
 		do_chunk_alloc(trans, root->fs_info->extent_root,
 			       calc + 2 * 1024 * 1024, new_alloc_flags, force);
 
-		mutex_unlock(&root->fs_info->alloc_mutex);
 		btrfs_end_transaction(trans, root);
-		mutex_lock(&root->fs_info->alloc_mutex);
 	} else
 		spin_unlock(&shrink_block_group->lock);
 	return 0;
@@ -4927,14 +4922,10 @@ int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start)
 	reloc_inode = create_reloc_inode(info, block_group);
 	BUG_ON(IS_ERR(reloc_inode));
 
-	mutex_lock(&root->fs_info->alloc_mutex);
-
 	__alloc_chunk_for_shrink(root, block_group, 1);
 	block_group->ro = 1;
 	block_group->space_info->total_bytes -= block_group->key.offset;
 
-	mutex_unlock(&root->fs_info->alloc_mutex);
-
 	btrfs_start_delalloc_inodes(info->tree_root);
 	btrfs_wait_ordered_extents(info->tree_root, 0);
 again:
@@ -4953,8 +4944,6 @@ again:
 	btrfs_remove_leaf_refs(info->tree_root, (u64)-1, 1);
 	mutex_unlock(&root->fs_info->cleaner_mutex);
 
-	mutex_lock(&root->fs_info->alloc_mutex);
-
 	while(1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
@@ -4982,9 +4971,7 @@ next:
 
 		if (progress && need_resched()) {
 			btrfs_release_path(root, path);
-			mutex_unlock(&root->fs_info->alloc_mutex);
 			cond_resched();
-			mutex_lock(&root->fs_info->alloc_mutex);
 			progress = 0;
 			continue;
 		}
@@ -5011,7 +4998,6 @@ next:
 	}
 
 	btrfs_release_path(root, path);
-	mutex_unlock(&root->fs_info->alloc_mutex);
 
 	if (pass == 0) {
 		btrfs_wait_ordered_range(reloc_inode, 0, (u64)-1);
@@ -5033,8 +5019,6 @@ next:
 	trans = btrfs_start_transaction(info->tree_root, 1);
 	btrfs_commit_transaction(trans, info->tree_root);
 
-	mutex_lock(&root->fs_info->alloc_mutex);
-
 	spin_lock(&block_group->lock);
 	WARN_ON(block_group->pinned > 0);
 	WARN_ON(block_group->reserved > 0);
@@ -5042,7 +5026,6 @@ next:
 	spin_unlock(&block_group->lock);
 	ret = 0;
 out:
-	mutex_unlock(&root->fs_info->alloc_mutex);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -5089,7 +5072,6 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 	struct btrfs_block_group_cache *block_group;
 	struct rb_node *n;
 
-	mutex_lock(&info->alloc_mutex);
 	spin_lock(&info->block_group_cache_lock);
 	while ((n = rb_last(&info->block_group_cache_tree)) != NULL) {
 		block_group = rb_entry(n, struct btrfs_block_group_cache,
@@ -5107,7 +5089,6 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		kfree(block_group);
 	}
 	spin_unlock(&info->block_group_cache_lock);
-	mutex_unlock(&info->alloc_mutex);
 	return 0;
 }
 
@@ -5130,7 +5111,6 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	if (!path)
 		return -ENOMEM;
 
-	mutex_lock(&root->fs_info->alloc_mutex);
 	while(1) {
 		ret = find_first_block_group(root, path, &key);
 		if (ret > 0) {
@@ -5149,6 +5129,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		}
 
 		spin_lock_init(&cache->lock);
+		mutex_init(&cache->alloc_mutex);
 		INIT_LIST_HEAD(&cache->list);
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
@@ -5176,7 +5157,6 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	ret = 0;
 error:
 	btrfs_free_path(path);
-	mutex_unlock(&root->fs_info->alloc_mutex);
 	return ret;
 }
 
@@ -5189,7 +5169,6 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_root *extent_root;
 	struct btrfs_block_group_cache *cache;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	extent_root = root->fs_info->extent_root;
 
 	root->fs_info->last_trans_new_blockgroup = trans->transid;
@@ -5201,6 +5180,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->key.objectid = chunk_offset;
 	cache->key.offset = size;
 	spin_lock_init(&cache->lock);
+	mutex_init(&cache->alloc_mutex);
 	INIT_LIST_HEAD(&cache->list);
 	btrfs_set_key_type(&cache->key, BTRFS_BLOCK_GROUP_ITEM_KEY);
 
@@ -5239,7 +5219,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	int ret;
 
-	BUG_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	root = root->fs_info->extent_root;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, group_start);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 563b2d1..941be8b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -937,6 +937,20 @@ int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
 }
 EXPORT_SYMBOL(lock_extent);
 
+int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
+		    gfp_t mask)
+{
+	int err;
+	u64 failed_start;
+
+	err = set_extent_bit(tree, start, end, EXTENT_LOCKED, 1,
+			     &failed_start, mask);
+	if (err == -EEXIST)
+		return 0;
+	return 1;
+}
+EXPORT_SYMBOL(try_lock_extent);
+
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end,
 		  gfp_t mask)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c9d1908..f089b58 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -122,6 +122,8 @@ int try_release_extent_state(struct extent_map_tree *map,
 			     gfp_t mask);
 int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
+int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,
+		    gfp_t mask);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 			  get_extent_t *get_extent);
 int __init extent_io_init(void);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 96241f0..f4926c0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -184,8 +184,8 @@ static int link_free_space(struct btrfs_block_group_cache *block_group,
 	return ret;
 }
 
-int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
-			 u64 offset, u64 bytes)
+static int __btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+				  u64 offset, u64 bytes)
 {
 	struct btrfs_free_space *right_info;
 	struct btrfs_free_space *left_info;
@@ -202,8 +202,6 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	 * are adding, if there is remove that struct and add a new one to
 	 * cover the entire range
 	 */
-	spin_lock(&block_group->lock);
-
 	right_info = tree_search_offset(&block_group->free_space_offset,
 					offset+bytes, 0, 1);
 	left_info = tree_search_offset(&block_group->free_space_offset,
@@ -261,7 +259,6 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	if (ret)
 		kfree(info);
 out:
-	spin_unlock(&block_group->lock);
 	if (ret) {
 		printk(KERN_ERR "btrfs: unable to add free space :%d\n", ret);
 		if (ret == -EEXIST)
@@ -274,13 +271,13 @@ out:
 	return ret;
 }
 
-int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
-			    u64 offset, u64 bytes)
+static int
+__btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
+			  u64 offset, u64 bytes)
 {
 	struct btrfs_free_space *info;
 	int ret = 0;
 
-	spin_lock(&block_group->lock);
 	info = tree_search_offset(&block_group->free_space_offset, offset, 0,
 				  1);
 
@@ -334,17 +331,63 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 		/* step two, insert a new info struct to cover anything
 		 * before the hole
 		 */
-		spin_unlock(&block_group->lock);
-		ret = btrfs_add_free_space(block_group, old_start,
-					   offset - old_start);
+		ret = __btrfs_add_free_space(block_group, old_start,
+					     offset - old_start);
 		BUG_ON(ret);
-		goto out_nolock;
 	} else {
 		WARN_ON(1);
 	}
 out:
-	spin_unlock(&block_group->lock);
-out_nolock:
+	return ret;
+}
+
+int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+			 u64 offset, u64 bytes)
+{
+	int ret;
+	struct btrfs_free_space *sp;
+
+	mutex_lock(&block_group->alloc_mutex);
+	ret = __btrfs_add_free_space(block_group, offset, bytes);
+	sp = tree_search_offset(&block_group->free_space_offset, offset, 0, 1);
+	BUG_ON(!sp);
+	mutex_unlock(&block_group->alloc_mutex);
+
+	return ret;
+}
+
+int btrfs_add_free_space_lock(struct btrfs_block_group_cache *block_group,
+			      u64 offset, u64 bytes)
+{
+	int ret;
+	struct btrfs_free_space *sp;
+
+	ret = __btrfs_add_free_space(block_group, offset, bytes);
+	sp = tree_search_offset(&block_group->free_space_offset, offset, 0, 1);
+	BUG_ON(!sp);
+
+	return ret;
+}
+
+int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
+			    u64 offset, u64 bytes)
+{
+	int ret = 0;
+
+	mutex_lock(&block_group->alloc_mutex);
+	ret = __btrfs_remove_free_space(block_group, offset, bytes);
+	mutex_unlock(&block_group->alloc_mutex);
+
+	return ret;
+}
+
+int btrfs_remove_free_space_lock(struct btrfs_block_group_cache *block_group,
+				 u64 offset, u64 bytes)
+{
+	int ret;
+
+	ret = __btrfs_remove_free_space(block_group, offset, bytes);
+
 	return ret;
 }
 
@@ -386,18 +429,18 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 	struct btrfs_free_space *info;
 	struct rb_node *node;
 
-	spin_lock(&block_group->lock);
+	mutex_lock(&block_group->alloc_mutex);
 	while ((node = rb_last(&block_group->free_space_bytes)) != NULL) {
 		info = rb_entry(node, struct btrfs_free_space, bytes_index);
 		unlink_free_space(block_group, info);
 		kfree(info);
 		if (need_resched()) {
-			spin_unlock(&block_group->lock);
+			mutex_unlock(&block_group->alloc_mutex);
 			cond_resched();
-			spin_lock(&block_group->lock);
+			mutex_lock(&block_group->alloc_mutex);
 		}
 	}
-	spin_unlock(&block_group->lock);
+	mutex_unlock(&block_group->alloc_mutex);
 }
 
 struct btrfs_free_space *btrfs_find_free_space_offset(struct
@@ -407,10 +450,10 @@ struct btrfs_free_space *btrfs_find_free_space_offset(struct
 {
 	struct btrfs_free_space *ret;
 
-	spin_lock(&block_group->lock);
+	mutex_lock(&block_group->alloc_mutex);
 	ret = tree_search_offset(&block_group->free_space_offset, offset,
 				 bytes, 0);
-	spin_unlock(&block_group->lock);
+	mutex_unlock(&block_group->alloc_mutex);
 
 	return ret;
 }
@@ -422,10 +465,10 @@ struct btrfs_free_space *btrfs_find_free_space_bytes(struct
 {
 	struct btrfs_free_space *ret;
 
-	spin_lock(&block_group->lock);
+	mutex_lock(&block_group->alloc_mutex);
 
 	ret = tree_search_bytes(&block_group->free_space_bytes, offset, bytes);
-	spin_unlock(&block_group->lock);
+	mutex_unlock(&block_group->alloc_mutex);
 
 	return ret;
 }
@@ -434,16 +477,13 @@ struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
 					       *block_group, u64 offset,
 					       u64 bytes)
 {
-	struct btrfs_free_space *ret;
+	struct btrfs_free_space *ret = NULL;
 
-	spin_lock(&block_group->lock);
 	ret = tree_search_offset(&block_group->free_space_offset, offset,
 				 bytes, 0);
 	if (!ret)
 		ret = tree_search_bytes(&block_group->free_space_bytes,
 					offset, bytes);
 
-	spin_unlock(&block_group->lock);
-
 	return ret;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1df6712..48b455f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -670,7 +670,6 @@ static noinline int drop_dirty_roots(struct btrfs_root *tree_root,
 		atomic_dec(&root->fs_info->throttles);
 		wake_up(&root->fs_info->transaction_throttle);
 
-		mutex_lock(&root->fs_info->alloc_mutex);
 		num_bytes -= btrfs_root_used(&dirty->root->root_item);
 		bytes_used = btrfs_root_used(&root->root_item);
 		if (num_bytes) {
@@ -678,7 +677,6 @@ static noinline int drop_dirty_roots(struct btrfs_root *tree_root,
 			btrfs_set_root_used(&root->root_item,
 					    bytes_used - num_bytes);
 		}
-		mutex_unlock(&root->fs_info->alloc_mutex);
 
 		ret = btrfs_del_root(trans, tree_root, &dirty->root->root_key);
 		if (ret) {
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 6f57d08..a6a3956 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -125,9 +125,6 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 	if (is_extent)
 		btrfs_extent_post_op(trans, root);
 out:
-	if (is_extent)
-		mutex_unlock(&root->fs_info->alloc_mutex);
-
 	if (path)
 		btrfs_free_path(path);
 	if (ret == -EAGAIN) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cf618cc..77b933f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -271,10 +271,10 @@ static int process_one_buffer(struct btrfs_root *log,
 			      struct walk_control *wc, u64 gen)
 {
 	if (wc->pin) {
-		mutex_lock(&log->fs_info->alloc_mutex);
+		mutex_lock(&log->fs_info->pinned_mutex);
 		btrfs_update_pinned_extents(log->fs_info->extent_root,
 					    eb->start, eb->len, 1);
-		mutex_unlock(&log->fs_info->alloc_mutex);
+		mutex_unlock(&log->fs_info->pinned_mutex);
 	}
 
 	if (btrfs_buffer_uptodate(eb, gen)) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2eed7f9..7ccaa44 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -58,14 +58,12 @@ void btrfs_unlock_volumes(void)
 
 static void lock_chunks(struct btrfs_root *root)
 {
-	mutex_lock(&root->fs_info->alloc_mutex);
 	mutex_lock(&root->fs_info->chunk_mutex);
 }
 
 static void unlock_chunks(struct btrfs_root *root)
 {
 	mutex_unlock(&root->fs_info->chunk_mutex);
-	mutex_unlock(&root->fs_info->alloc_mutex);
 }
 
 int btrfs_cleanup_fs_uuids(void)
