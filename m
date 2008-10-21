From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] nuke fs wide allocation mutex
Date: Tue, 21 Oct 2008 16:16:14 -0400
Message-ID: <20081021201613.GC3929@unused.rdu.redhat.com>
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
anything.  This has to be applied on top of my find_free_extent redo patch.
Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9caeb37..4f55552 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1390,8 +1390,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
 	WARN_ON(p->nodes[0] != NULL);
-	WARN_ON(cow && root == root->fs_info->extent_root &&
-		!mutex_is_locked(&root->fs_info->alloc_mutex));
+
 	if (ins_len < 0)
 		lowest_unlock = 2;
 
@@ -2051,6 +2050,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	if (c == root->node) {
 		/* trying to split the root, lets make a new one */
 		ret = insert_new_root(trans, root, path, level + 1);
+		printk(KERN_ERR "splitting the root, %llu\n", c->start);
 		if (ret)
 			return ret;
 	} else {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fad58b9..d1e304f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -516,12 +516,14 @@ struct btrfs_free_space {
 	struct rb_node offset_index;
 	u64 offset;
 	u64 bytes;
+	unsigned long ip;
 };
 
 struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
 	spinlock_t lock;
+	struct mutex alloc_mutex;
 	u64 pinned;
 	u64 reserved;
 	u64 flags;
@@ -600,6 +602,7 @@ struct btrfs_fs_info {
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
 	struct mutex alloc_mutex;
+	struct mutex extent_io_mutex;
 	struct mutex chunk_mutex;
 	struct mutex drop_mutex;
 	struct mutex volume_mutex;
@@ -1879,8 +1882,12 @@ int btrfs_acl_chmod(struct inode *inode);
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
index 0be044b..6da2345 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1458,6 +1458,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->tree_log_mutex);
 	mutex_init(&fs_info->drop_mutex);
 	mutex_init(&fs_info->alloc_mutex);
+	mutex_init(&fs_info->extent_io_mutex);
 	mutex_init(&fs_info->chunk_mutex);
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5f235fc..c27c71b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -164,6 +164,7 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 	u64 extent_start, extent_end, size;
 	int ret;
 
+	mutex_lock(&info->extent_io_mutex);
 	while (start < end) {
 		ret = find_first_extent_bit(&info->pinned_extents, start,
 					    &extent_start, &extent_end,
@@ -175,7 +176,8 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 			start = extent_end + 1;
 		} else if (extent_start > start && extent_start < end) {
 			size = extent_start - start;
-			ret = btrfs_add_free_space(block_group, start, size);
+			ret = btrfs_add_free_space_lock(block_group, start,
+							size);
 			BUG_ON(ret);
 			start = extent_end + 1;
 		} else {
@@ -185,9 +187,10 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 
 	if (start < end) {
 		size = end - start;
-		ret = btrfs_add_free_space(block_group, start, size);
+		ret = btrfs_add_free_space_lock(block_group, start, size);
 		BUG_ON(ret);
 	}
+	mutex_unlock(&info->extent_io_mutex);
 
 	return 0;
 }
@@ -231,6 +234,7 @@ static int cache_block_group(struct btrfs_root *root,
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
+
 	ret = btrfs_previous_item(root, path, 0, BTRFS_EXTENT_ITEM_KEY);
 	if (ret < 0)
 		goto err;
@@ -676,6 +680,7 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 
 		BUG_ON(owner_objectid >= BTRFS_MAX_LEVEL);
 		num_bytes = btrfs_level_size(root, (int)owner_objectid);
+		mutex_lock(&root->fs_info->extent_io_mutex);
 		if (test_range_bit(&root->fs_info->extent_ins, bytenr,
 				bytenr + num_bytes - 1, EXTENT_LOCKED, 0)) {
 			u64 priv;
@@ -707,6 +712,21 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 			set_state_private(&root->fs_info->extent_ins,
 					  bytenr, (unsigned long)extent_op);
 		}
+
+		if (extent_op->type == PENDING_BACKREF_UPDATE) {
+			path = btrfs_alloc_path();
+			BUG_ON(!path);
+			path->skip_locking = 1;
+			ret = lookup_extent_backref(trans, extent_root,
+						    path, bytenr, orig_parent,
+						    orig_root, orig_generation,
+						    owner_objectid, 0);
+			if (ret)
+				printk(KERN_ERR "Oops, %llu\n", orig_parent);
+			BUG_ON(ret);
+			btrfs_free_path(path);
+		}
+		mutex_unlock(&root->fs_info->extent_io_mutex);
 		return 0;
 	}
 
@@ -1390,9 +1410,11 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 
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
@@ -1479,18 +1501,25 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
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
+
+	spin_unlock(&space_info->lock);
 
 	while (!mutex_trylock(&extent_root->fs_info->chunk_mutex)) {
 		if (!force)
@@ -1501,13 +1530,20 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
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
+	if (ret)
+		goto out_unlock;
 	if (ret == -ENOSPC) {
 printk("space info full %Lu\n", flags);
-		space_info->full = 1;
 		goto out_unlock;
 	}
 	BUG_ON(ret);
@@ -1518,6 +1554,12 @@ printk("space info full %Lu\n", flags);
 
 out_unlock:
 	mutex_unlock(&extent_root->fs_info->chunk_mutex);
+	if (ret == -ENOSPC) {
+printk("space info full %Lu\n", flags);
+		spin_lock(&space_info->lock);
+		space_info->full = 1;
+		spin_unlock(&space_info->lock);
+	}
 out:
 	return ret;
 }
@@ -1533,7 +1575,6 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	u64 old_val;
 	u64 byte_in_group;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	while(total) {
 		cache = btrfs_lookup_block_group(info, bytenr);
 		if (!cache) {
@@ -1542,6 +1583,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		byte_in_group = bytenr - cache->key.objectid;
 		WARN_ON(byte_in_group > cache->key.offset);
 
+		spin_lock(&cache->space_info->lock);
 		spin_lock(&cache->lock);
 		cache->dirty = 1;
 		old_val = btrfs_block_group_used(&cache->item);
@@ -1551,11 +1593,13 @@ static int update_block_group(struct btrfs_trans_handle *trans,
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
@@ -1588,7 +1632,7 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
+	WARN_ON(!mutex_is_locked(&root->fs_info->extent_io_mutex));
 	if (pin) {
 		set_extent_dirty(&fs_info->pinned_extents,
 				bytenr, bytenr + num - 1, GFP_NOFS);
@@ -1602,16 +1646,20 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
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
@@ -1627,23 +1675,23 @@ static int update_reserved_extents(struct btrfs_root *root,
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
@@ -1658,6 +1706,7 @@ int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
 	struct extent_io_tree *pinned_extents = &root->fs_info->pinned_extents;
 	int ret;
 
+	mutex_lock(&root->fs_info->extent_io_mutex);
 	while(1) {
 		ret = find_first_extent_bit(pinned_extents, last,
 					    &start, &end, EXTENT_DIRTY);
@@ -1666,6 +1715,7 @@ int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
 		set_extent_dirty(copy, start, end, GFP_NOFS);
 		last = end + 1;
 	}
+	mutex_unlock(&root->fs_info->extent_io_mutex);
 	return 0;
 }
 
@@ -1679,6 +1729,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	struct btrfs_block_group_cache *cache;
 
 	mutex_lock(&root->fs_info->alloc_mutex);
+	mutex_lock(&root->fs_info->extent_io_mutex);
 	while(1) {
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
 					    EXTENT_DIRTY);
@@ -1690,11 +1741,14 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 		if (cache->cached)
 			btrfs_add_free_space(cache, start, end - start + 1);
 		if (need_resched()) {
+			mutex_unlock(&root->fs_info->extent_io_mutex);
 			mutex_unlock(&root->fs_info->alloc_mutex);
 			cond_resched();
 			mutex_lock(&root->fs_info->alloc_mutex);
+			mutex_lock(&root->fs_info->extent_io_mutex);
 		}
 	}
+	mutex_unlock(&root->fs_info->extent_io_mutex);
 	mutex_unlock(&root->fs_info->alloc_mutex);
 	return 0;
 }
@@ -1714,11 +1768,11 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	int ret;
 	int err = 0;
 
-	WARN_ON(!mutex_is_locked(&extent_root->fs_info->alloc_mutex));
 	btrfs_set_stack_extent_refs(&extent_item, 1);
 	path = btrfs_alloc_path();
 
 	while(1) {
+		mutex_lock(&extent_root->fs_info->extent_io_mutex);
 		ret = find_first_extent_bit(&info->extent_ins, 0, &start,
 					    &end, EXTENT_LOCKED);
 		if (ret)
@@ -1729,16 +1783,24 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 		extent_op = (struct pending_extent_op *)(unsigned long)priv;
 
 		if (extent_op->type == PENDING_EXTENT_INSERT) {
+			clear_extent_bits(&info->extent_ins, start, end,
+					  EXTENT_LOCKED, GFP_NOFS);
+			mutex_unlock(&extent_root->fs_info->extent_io_mutex);
+
+			/*
+			 * FIXME: when we decide to cull all of these BUG's
+			 * we need to re set those bits on the extent_ins
+			 * map if anything under here fails so we can recover
+			 * later
+			 */
 			key.objectid = start;
 			key.offset = end + 1 - start;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
+
 			err = btrfs_insert_item(trans, extent_root, &key,
 					&extent_item, sizeof(extent_item));
 			BUG_ON(err);
 
-			clear_extent_bits(&info->extent_ins, start, end,
-					  EXTENT_LOCKED, GFP_NOFS);
-
 			err = insert_extent_backref(trans, extent_root, path,
 						start, extent_op->parent,
 						extent_root->root_key.objectid,
@@ -1746,16 +1808,24 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 						extent_op->level);
 			BUG_ON(err);
 		} else if (extent_op->type == PENDING_BACKREF_UPDATE) {
+			clear_extent_bits(&info->extent_ins, start, end,
+					  EXTENT_LOCKED, GFP_NOFS);
+			if (test_range_bit(&info->pinned_extents, start,
+					   end, EXTENT_DIRTY, 0))
+				printk(KERN_ERR "%llu may not be found\n",
+				       start);
+			mutex_unlock(&extent_root->fs_info->extent_io_mutex);
+
+			/* FIXME: same note as above */
 			err = lookup_extent_backref(trans, extent_root, path,
 						start, extent_op->orig_parent,
 						extent_root->root_key.objectid,
 						extent_op->orig_generation,
 						extent_op->level, 0);
+			if (err == -ENOENT)
+				printk(KERN_ERR "couldn't find %llu\n", start);
 			BUG_ON(err);
 
-			clear_extent_bits(&info->extent_ins, start, end,
-					  EXTENT_LOCKED, GFP_NOFS);
-
 			key.objectid = start;
 			key.offset = extent_op->parent;
 			key.type = BTRFS_EXTENT_REF_KEY;
@@ -1772,13 +1842,8 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 			BUG_ON(1);
 		}
 		kfree(extent_op);
-
-		if (need_resched()) {
-			mutex_unlock(&extent_root->fs_info->alloc_mutex);
-			cond_resched();
-			mutex_lock(&extent_root->fs_info->alloc_mutex);
-		}
 	}
+	mutex_unlock(&extent_root->fs_info->extent_io_mutex);
 	btrfs_free_path(path);
 	return 0;
 }
@@ -1790,7 +1855,6 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 	int err = 0;
 	struct extent_buffer *buf;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	if (is_data)
 		goto pinit;
 
@@ -1847,7 +1911,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_item *ei;
 	u32 refs;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	key.objectid = bytenr;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
 	key.offset = num_bytes;
@@ -1935,8 +1998,10 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 #endif
 
 		if (pin) {
+			mutex_lock(&root->fs_info->extent_io_mutex);
 			ret = pin_down_bytes(trans, root, bytenr, num_bytes,
 				owner_objectid >= BTRFS_FIRST_FREE_OBJECTID);
+			mutex_unlock(&root->fs_info->extent_io_mutex);
 			if (ret > 0)
 				mark_free = 1;
 			BUG_ON(ret < 0);
@@ -1956,6 +2021,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
 		BUG_ON(ret);
+		btrfs_release_path(extent_root, path);
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
 					 mark_free);
 		BUG_ON(ret);
@@ -1980,6 +2046,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		}
 #endif
 	}
+
 	btrfs_free_path(path);
 	finish_current_insert(trans, extent_root);
 	return ret;
@@ -1994,7 +2061,6 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 {
 	int ret;
 	int err = 0;
-	int mark_free = 0;
 	u64 start;
 	u64 end;
 	u64 priv;
@@ -2002,11 +2068,11 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 	struct extent_io_tree *extent_ins;
 	struct pending_extent_op *extent_op;
 
-	WARN_ON(!mutex_is_locked(&extent_root->fs_info->alloc_mutex));
 	extent_ins = &extent_root->fs_info->extent_ins;
 	pending_del = &extent_root->fs_info->pending_del;
 
 	while(1) {
+		mutex_lock(&extent_root->fs_info->extent_io_mutex);
 		ret = find_first_extent_bit(pending_del, 0, &start, &end,
 					    EXTENT_LOCKED);
 		if (ret)
@@ -2019,21 +2085,20 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 		clear_extent_bits(pending_del, start, end, EXTENT_LOCKED,
 				  GFP_NOFS);
 
-		ret = pin_down_bytes(trans, extent_root, start,
-				     end + 1 - start, 0);
-		mark_free = ret > 0;
 		if (!test_range_bit(extent_ins, start, end,
 				    EXTENT_LOCKED, 0)) {
+			mutex_unlock(&extent_root->fs_info->extent_io_mutex);
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
+
 			ret = get_state_private(extent_ins, start, &priv);
 			BUG_ON(ret);
 			extent_op = (struct pending_extent_op *)
@@ -2042,23 +2107,25 @@ free_extent:
 			clear_extent_bits(extent_ins, start, end,
 					  EXTENT_LOCKED, GFP_NOFS);
 
-			if (extent_op->type == PENDING_BACKREF_UPDATE)
+			if (extent_op->type == PENDING_BACKREF_UPDATE) {
+				mutex_unlock(&extent_root->fs_info->extent_io_mutex);
 				goto free_extent;
+			}
+
+			ret = pin_down_bytes(trans, extent_root, start,
+					     end + 1 - start, 0);
+			mutex_unlock(&extent_root->fs_info->extent_io_mutex);
 
 			ret = update_block_group(trans, extent_root, start,
-						end + 1 - start, 0, mark_free);
+						end + 1 - start, 0, ret > 0);
 			BUG_ON(ret);
 			kfree(extent_op);
 		}
 		if (ret)
 			err = ret;
-
-		if (need_resched()) {
-			mutex_unlock(&extent_root->fs_info->alloc_mutex);
-			cond_resched();
-			mutex_lock(&extent_root->fs_info->alloc_mutex);
-		}
 	}
+	mutex_unlock(&extent_root->fs_info->extent_io_mutex);
+
 	return err;
 }
 
@@ -2091,11 +2158,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		extent_op->orig_generation = ref_generation;
 		extent_op->level = (int)owner_objectid;
 
+		mutex_lock(&root->fs_info->extent_io_mutex);
 		set_extent_bits(&root->fs_info->pending_del,
 				bytenr, bytenr + num_bytes - 1,
 				EXTENT_LOCKED, GFP_NOFS);
 		set_state_private(&root->fs_info->pending_del,
 				  bytenr, (unsigned long)extent_op);
+		mutex_unlock(&root->fs_info->extent_io_mutex);
 		return 0;
 	}
 	/* if metadata always pin */
@@ -2163,7 +2232,7 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 				     u64 search_start, u64 search_end,
 				     u64 hint_byte, struct btrfs_key *ins,
 				     u64 exclude_start, u64 exclude_nr,
-				     int data)
+				     int data, unsigned long *ip)
 {
 	int ret = 0;
 	struct btrfs_root * root = orig_root->fs_info->extent_root;
@@ -2214,12 +2283,16 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
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
@@ -2250,8 +2323,10 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
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
@@ -2259,10 +2334,18 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 
 			ins->objectid = search_start;
 			ins->offset = num_bytes;
+
+			if (ip)
+				*ip = free_space->ip;
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
@@ -2357,13 +2440,12 @@ static int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  u64 num_bytes, u64 min_alloc_size,
 				  u64 empty_size, u64 hint_byte,
 				  u64 search_end, struct btrfs_key *ins,
-				  u64 data)
+				  u64 data, unsigned long *ip)
 {
 	int ret;
 	u64 search_start = 0;
 	u64 alloc_profile;
 	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_block_group_cache *cache;
 
 	if (data) {
 		alloc_profile = info->avail_data_alloc_bits &
@@ -2400,7 +2482,7 @@ again:
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
 			       search_start, search_end, hint_byte, ins,
 			       trans->alloc_exclude_start,
-			       trans->alloc_exclude_nr, data);
+			       trans->alloc_exclude_nr, data, ip);
 
 	if (ret == -ENOSPC && num_bytes > min_alloc_size) {
 		num_bytes = num_bytes >> 1;
@@ -2419,13 +2501,6 @@ again:
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
@@ -2434,16 +2509,13 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
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
 
@@ -2455,19 +2527,18 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  u64 data)
 {
 	int ret;
-	maybe_lock_mutex(root);
 	ret = __btrfs_reserve_extent(trans, root, num_bytes, min_alloc_size,
 				     empty_size, hint_byte, search_end, ins,
-				     data);
+				     data, NULL);
 	update_reserved_extents(root, ins->objectid, ins->offset, 1);
-	maybe_unlock_mutex(root);
 	return ret;
 }
 
 static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 					 struct btrfs_root *root, u64 parent,
 					 u64 root_objectid, u64 ref_generation,
-					 u64 owner, struct btrfs_key *ins)
+					 u64 owner, struct btrfs_key *ins,
+					 unsigned long ip)
 {
 	int ret;
 	int pending_ret;
@@ -2510,11 +2581,13 @@ static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 		extent_op->orig_generation = 0;
 		extent_op->level = (int)owner;
 
+		mutex_lock(&root->fs_info->extent_io_mutex);
 		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
 				ins->objectid + ins->offset - 1,
 				EXTENT_LOCKED, GFP_NOFS);
 		set_state_private(&root->fs_info->extent_ins,
 				  ins->objectid, (unsigned long)extent_op);
+		mutex_unlock(&root->fs_info->extent_io_mutex);
 		goto update_block;
 	}
 
@@ -2530,6 +2603,36 @@ static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_empty_items(trans, extent_root, path, keys,
 				       sizes, 2);
+	if (ret == -EEXIST) {
+		u64 start, end;
+		struct btrfs_block_group_cache *cache =
+			btrfs_lookup_block_group(root->fs_info,
+						 keys[0].objectid);
+		printk(KERN_ERR "extent %Lu already exists, type %Ld, id %Ld, "
+		       "ip is %lu\n",
+		       keys[0].objectid, cache->flags,
+		       root->root_key.objectid, ip);
+		mutex_lock(&root->fs_info->extent_io_mutex);
+		ret = find_first_extent_bit(&extent_root->fs_info->pending_del,
+					    keys[0].objectid, &start, &end,
+					    EXTENT_LOCKED);
+		if (ret) {
+			printk(KERN_ERR "Ok its not on pending_del\n");
+		} else if (start == keys[0].objectid) {
+			printk(KERN_ERR "It was on the pending del list, why "
+			       "the fuck was the space available\n");
+		}
+		ret = find_first_extent_bit(&extent_root->fs_info->pinned_extents,
+					    keys[0].objectid, &start, &end,
+					    EXTENT_DIRTY);
+		if (ret || start != keys[0].objectid) {
+			printk(KERN_ERR "ok its not on pinned either\n");
+		} else if (start == keys[0].objectid) {
+			printk(KERN_ERR "it was on pinned\n");
+		}
+		ret = -EEXIST;
+		mutex_unlock(&root->fs_info->extent_io_mutex);
+	}
 	BUG_ON(ret);
 
 	extent_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
@@ -2578,9 +2681,9 @@ int btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 
 	if (root_objectid == BTRFS_TREE_LOG_OBJECTID)
 		return 0;
-	maybe_lock_mutex(root);
 	ret = __btrfs_alloc_reserved_extent(trans, root, parent, root_objectid,
-					    ref_generation, owner, ins);
+					    ref_generation, owner, ins, 0);
+	maybe_lock_mutex(root);
 	update_reserved_extents(root, ins->objectid, ins->offset, 0);
 	maybe_unlock_mutex(root);
 	return ret;
@@ -2599,15 +2702,15 @@ int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
 	int ret;
 	struct btrfs_block_group_cache *block_group;
 
-	maybe_lock_mutex(root);
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
+	mutex_lock(&block_group->alloc_mutex);
 	cache_block_group(root, block_group);
+	mutex_unlock(&block_group->alloc_mutex);
 
 	ret = btrfs_remove_free_space(block_group, ins->objectid, ins->offset);
 	BUG_ON(ret);
 	ret = __btrfs_alloc_reserved_extent(trans, root, parent, root_objectid,
-					    ref_generation, owner, ins);
-	maybe_unlock_mutex(root);
+					    ref_generation, owner, ins, 0);
 	return ret;
 }
 
@@ -2626,23 +2729,23 @@ int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       u64 search_end, struct btrfs_key *ins, u64 data)
 {
 	int ret;
-
-	maybe_lock_mutex(root);
+	unsigned long ip = 0;
 
 	ret = __btrfs_reserve_extent(trans, root, num_bytes,
 				     min_alloc_size, empty_size, hint_byte,
-				     search_end, ins, data);
+				     search_end, ins, data, &ip);
 	BUG_ON(ret);
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
 		ret = __btrfs_alloc_reserved_extent(trans, root, parent,
 					root_objectid, ref_generation,
-					owner_objectid, ins);
+					owner_objectid, ins, ip);
 		BUG_ON(ret);
 
 	} else {
+		maybe_lock_mutex(root);
 		update_reserved_extents(root, ins->objectid, ins->offset, 1);
+		maybe_unlock_mutex(root);
 	}
-	maybe_unlock_mutex(root);
 	return ret;
 }
 
@@ -5067,6 +5170,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		}
 
 		spin_lock_init(&cache->lock);
+		mutex_init(&cache->alloc_mutex);
 		INIT_LIST_HEAD(&cache->list);
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
@@ -5107,7 +5211,6 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_root *extent_root;
 	struct btrfs_block_group_cache *cache;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	extent_root = root->fs_info->extent_root;
 
 	root->fs_info->last_trans_new_blockgroup = trans->transid;
@@ -5119,6 +5222,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->key.objectid = chunk_offset;
 	cache->key.offset = size;
 	spin_lock_init(&cache->lock);
+	mutex_init(&cache->alloc_mutex);
 	INIT_LIST_HEAD(&cache->list);
 	btrfs_set_key_type(&cache->key, BTRFS_BLOCK_GROUP_ITEM_KEY);
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 96241f0..25a3110 100644
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
 
@@ -334,17 +331,65 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
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
+	sp->ip = (unsigned long)__builtin_return_address(0);
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
+	sp->ip = (unsigned long)__builtin_return_address(0);
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
 
@@ -386,18 +431,18 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
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
@@ -407,10 +452,10 @@ struct btrfs_free_space *btrfs_find_free_space_offset(struct
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
@@ -422,10 +467,10 @@ struct btrfs_free_space *btrfs_find_free_space_bytes(struct
 {
 	struct btrfs_free_space *ret;
 
-	spin_lock(&block_group->lock);
+	mutex_lock(&block_group->alloc_mutex);
 
 	ret = tree_search_bytes(&block_group->free_space_bytes, offset, bytes);
-	spin_unlock(&block_group->lock);
+	mutex_unlock(&block_group->alloc_mutex);
 
 	return ret;
 }
@@ -434,16 +479,13 @@ struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
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
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cf618cc..fc3a8d8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -272,8 +272,10 @@ static int process_one_buffer(struct btrfs_root *log,
 {
 	if (wc->pin) {
 		mutex_lock(&log->fs_info->alloc_mutex);
+		mutex_lock(&log->fs_info->extent_io_mutex);
 		btrfs_update_pinned_extents(log->fs_info->extent_root,
 					    eb->start, eb->len, 1);
+		mutex_unlock(&log->fs_info->extent_io_mutex);
 		mutex_unlock(&log->fs_info->alloc_mutex);
 	}
 
