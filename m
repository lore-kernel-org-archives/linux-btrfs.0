From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 1/5] btrfs: pass buffer extent to btrfs_free_tree_block
Date: Tue, 11 May 2010 16:24:00 +0800
Message-ID: <4BE91420.5030505@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

prepare for the log code

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.c 2/fs/btrfs/ctree.c
--- 1/fs/btrfs/ctree.c	2010-04-14 14:49:56.342950744 +0800
+++ 2/fs/btrfs/ctree.c	2010-05-11 14:00:04.122357838 +0800
@@ -279,7 +279,8 @@ int btrfs_block_can_be_shared(struct btr
 static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 				       struct btrfs_root *root,
 				       struct extent_buffer *buf,
-				       struct extent_buffer *cow)
+				       struct extent_buffer *cow,
+				       int *last_ref)
 {
 	u64 refs;
 	u64 owner;
@@ -365,6 +366,7 @@ static noinline int update_ref_for_cow(s
 			BUG_ON(ret);
 		}
 		clean_tree_block(trans, root, buf);
+		*last_ref = 1;
 	}
 	return 0;
 }
@@ -392,6 +394,7 @@ static noinline int __btrfs_cow_block(st
 	struct extent_buffer *cow;
 	int level;
 	int unlock_orig = 0;
+	int last_ref = 0;
 	u64 parent_start;
 
 	if (*cow_ret == buf)
@@ -441,7 +444,7 @@ static noinline int __btrfs_cow_block(st
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
-	update_ref_for_cow(trans, root, buf, cow);
+	update_ref_for_cow(trans, root, buf, cow, &last_ref);
 
 	if (buf == root->node) {
 		WARN_ON(parent && parent != buf);
@@ -456,8 +459,8 @@ static noinline int __btrfs_cow_block(st
 		extent_buffer_get(cow);
 		spin_unlock(&root->node_lock);
 
-		btrfs_free_tree_block(trans, root, buf->start, buf->len,
-				parent_start, root->root_key.objectid, level);
+		btrfs_free_tree_block(trans, root, buf, parent_start,
+				      last_ref);
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
 	} else {
@@ -472,8 +475,8 @@ static noinline int __btrfs_cow_block(st
 		btrfs_set_node_ptr_generation(parent, parent_slot,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
-		btrfs_free_tree_block(trans, root, buf->start, buf->len,
-				parent_start, root->root_key.objectid, level);
+		btrfs_free_tree_block(trans, root, buf, parent_start,
+				      last_ref);
 	}
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
@@ -948,6 +951,22 @@ int btrfs_bin_search(struct extent_buffe
 	return bin_search(eb, key, level, slot);
 }
 
+static void root_add_used(struct btrfs_root *root, u32 size)
+{
+	spin_lock(&root->node_lock);
+	btrfs_set_root_used(&root->root_item,
+			    btrfs_root_used(&root->root_item) + size);
+	spin_unlock(&root->node_lock);
+}
+
+static void root_sub_used(struct btrfs_root *root, u32 size)
+{
+	spin_lock(&root->node_lock);
+	btrfs_set_root_used(&root->root_item,
+			    btrfs_root_used(&root->root_item) - size);
+	spin_unlock(&root->node_lock);
+}
+
 /* given a node and slot number, this reads the blocks it points to.  The
  * extent buffer is returned with a reference taken (but unlocked).
  * NULL is returned on error.
@@ -1018,7 +1037,11 @@ static noinline int balance_level(struct
 		btrfs_tree_lock(child);
 		btrfs_set_lock_blocking(child);
 		ret = btrfs_cow_block(trans, root, child, mid, 0, &child);
-		BUG_ON(ret);
+		if (ret) {
+			btrfs_tree_unlock(child);
+			free_extent_buffer(child);
+			goto enospc;
+		}
 
 		spin_lock(&root->node_lock);
 		root->node = child;
@@ -1033,11 +1056,12 @@ static noinline int balance_level(struct
 		btrfs_tree_unlock(mid);
 		/* once for the path */
 		free_extent_buffer(mid);
-		ret = btrfs_free_tree_block(trans, root, mid->start, mid->len,
-					    0, root->root_key.objectid, level);
+
+		root_sub_used(root, mid->len);
+		btrfs_free_tree_block(trans, root, mid, 0, 1);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
-		return ret;
+		return 0;
 	}
 	if (btrfs_header_nritems(mid) >
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
@@ -1087,23 +1111,16 @@ static noinline int balance_level(struct
 		if (wret < 0 && wret != -ENOSPC)
 			ret = wret;
 		if (btrfs_header_nritems(right) == 0) {
-			u64 bytenr = right->start;
-			u32 blocksize = right->len;
-
 			clean_tree_block(trans, root, right);
 			btrfs_tree_unlock(right);
-			free_extent_buffer(right);
-			right = NULL;
 			wret = del_ptr(trans, root, path, level + 1, pslot +
 				       1);
 			if (wret)
 				ret = wret;
-			wret = btrfs_free_tree_block(trans, root,
-						     bytenr, blocksize, 0,
-						     root->root_key.objectid,
-						     level);
-			if (wret)
-				ret = wret;
+			root_sub_used(root, right->len);
+			btrfs_free_tree_block(trans, root, right, 0, 1);
+			free_extent_buffer(right);
+			right = NULL;
 		} else {
 			struct btrfs_disk_key right_key;
 			btrfs_node_key(right, &right_key, 0);
@@ -1135,21 +1152,15 @@ static noinline int balance_level(struct
 		BUG_ON(wret == 1);
 	}
 	if (btrfs_header_nritems(mid) == 0) {
-		/* we've managed to empty the middle node, drop it */
-		u64 bytenr = mid->start;
-		u32 blocksize = mid->len;
-
 		clean_tree_block(trans, root, mid);
 		btrfs_tree_unlock(mid);
-		free_extent_buffer(mid);
-		mid = NULL;
 		wret = del_ptr(trans, root, path, level + 1, pslot);
 		if (wret)
 			ret = wret;
-		wret = btrfs_free_tree_block(trans, root, bytenr, blocksize,
-					 0, root->root_key.objectid, level);
-		if (wret)
-			ret = wret;
+		root_sub_used(root, mid->len);
+		btrfs_free_tree_block(trans, root, mid, 0, 1);
+		free_extent_buffer(mid);
+		mid = NULL;
 	} else {
 		/* update the parent key to reflect our changes */
 		struct btrfs_disk_key mid_key;
@@ -1589,7 +1600,7 @@ read_block_for_search(struct btrfs_trans
 	btrfs_release_path(NULL, p);
 
 	ret = -EAGAIN;
-	tmp = read_tree_block(root, blocknr, blocksize, gen);
+	tmp = read_tree_block(root, blocknr, blocksize, 0);
 	if (tmp) {
 		/*
 		 * If the read above didn't mark this buffer up to date,
@@ -1739,7 +1750,6 @@ again:
 					      p->nodes[level + 1],
 					      p->slots[level + 1], &b);
 			if (err) {
-				free_extent_buffer(b);
 				ret = err;
 				goto done;
 			}
@@ -1919,6 +1929,7 @@ int btrfs_set_item_key_safe(struct btrfs
 	btrfs_mark_buffer_dirty(eb);
 	if (slot == 0)
 		fixup_low_keys(trans, root, path, &disk_key, 1);
+
 	return 0;
 }
 
@@ -2075,6 +2086,8 @@ static noinline int insert_new_root(stru
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 
+	root_add_used(root, root->nodesize);
+
 	memset_extent_buffer(c, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_nritems(c, 1);
 	btrfs_set_header_level(c, level);
@@ -2133,6 +2146,7 @@ static int insert_ptr(struct btrfs_trans
 	int nritems;
 
 	BUG_ON(!path->nodes[level]);
+	btrfs_assert_tree_locked(path->nodes[level]);
 	lower = path->nodes[level];
 	nritems = btrfs_header_nritems(lower);
 	BUG_ON(slot > nritems);
@@ -2201,6 +2215,8 @@ static noinline int split_node(struct bt
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
+	root_add_used(root, root->nodesize);
+
 	memset_extent_buffer(split, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_level(split, btrfs_header_level(c));
 	btrfs_set_header_bytenr(split, split->start);
@@ -2414,6 +2430,9 @@ static noinline int __push_leaf_right(st
 
 	if (left_nritems)
 		btrfs_mark_buffer_dirty(left);
+	else
+		clean_tree_block(trans, root, left);
+
 	btrfs_mark_buffer_dirty(right);
 
 	btrfs_item_key(right, &disk_key, 0);
@@ -2423,8 +2442,6 @@ static noinline int __push_leaf_right(st
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] >= left_nritems) {
 		path->slots[0] -= left_nritems;
-		if (btrfs_header_nritems(path->nodes[0]) == 0)
-			clean_tree_block(trans, root, path->nodes[0]);
 		btrfs_tree_unlock(path->nodes[0]);
 		free_extent_buffer(path->nodes[0]);
 		path->nodes[0] = right;
@@ -2657,19 +2674,19 @@ static noinline int __push_leaf_left(str
 	}
 
 	btrfs_mark_buffer_dirty(left);
-	if (right_nritems)
+	if (right_nritems) {
 		btrfs_mark_buffer_dirty(right);
-
-	btrfs_item_key(right, &disk_key, 0);
-	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
-	if (wret)
-		ret = wret;
+		btrfs_item_key(right, &disk_key, 0);
+		wret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		if (wret)
+			ret = wret;
+	} else {
+		clean_tree_block(trans, root, right);
+	}
 
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
 		path->slots[0] += old_left_nritems;
-		if (btrfs_header_nritems(path->nodes[0]) == 0)
-			clean_tree_block(trans, root, path->nodes[0]);
 		btrfs_tree_unlock(path->nodes[0]);
 		free_extent_buffer(path->nodes[0]);
 		path->nodes[0] = left;
@@ -2931,10 +2948,10 @@ again:
 	right = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 					root->root_key.objectid,
 					&disk_key, 0, l->start, 0);
-	if (IS_ERR(right)) {
-		BUG_ON(1);
+	if (IS_ERR(right))
 		return PTR_ERR(right);
-	}
+
+	root_add_used(root, root->leafsize);
 
 	memset_extent_buffer(right, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_bytenr(right, right->start);
@@ -3053,7 +3070,8 @@ static noinline int setup_leaf_for_split
 
 	btrfs_set_path_blocking(path);
 	ret = split_leaf(trans, root, &key, path, ins_len, 1);
-	BUG_ON(ret);
+	if (ret)
+		goto err;
 
 	path->keep_locks = 0;
 	btrfs_unlock_up_safe(path, 1);
@@ -3763,6 +3781,7 @@ static int del_ptr(struct btrfs_trans_ha
 		if (wret)
 			ret = wret;
 	}
+
 	btrfs_mark_buffer_dirty(parent);
 	return ret;
 }
@@ -3795,9 +3814,10 @@ static noinline int btrfs_del_leaf(struc
 	 */
 	btrfs_unlock_up_safe(path, 0);
 
-	ret = btrfs_free_tree_block(trans, root, leaf->start, leaf->len,
-				    0, root->root_key.objectid, 0);
-	return ret;
+	root_sub_used(root, leaf->len);
+
+	btrfs_free_tree_block(trans, root, leaf, 0, 1);
+	return 0;
 }
 /*
  * delete the item at the leaf level in path.  If that empties
@@ -3864,6 +3884,8 @@ int btrfs_del_items(struct btrfs_trans_h
 		if (leaf == root->node) {
 			btrfs_set_header_level(leaf, 0);
 		} else {
+			btrfs_set_path_blocking(path);
+			clean_tree_block(trans, root, leaf);
 			ret = btrfs_del_leaf(trans, root, path, leaf);
 			BUG_ON(ret);
 		}
diff -urp 1/fs/btrfs/ctree.h 2/fs/btrfs/ctree.h
--- 1/fs/btrfs/ctree.h	2010-04-14 14:49:56.399956135 +0800
+++ 2/fs/btrfs/ctree.h	2010-05-11 13:57:39.448108941 +0800
@@ -1983,10 +1983,14 @@ struct extent_buffer *btrfs_alloc_free_b
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size);
-int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  u64 bytenr, u32 blocksize,
-			  u64 parent, u64 root_objectid, int level);
+void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct extent_buffer *buf,
+			   u64 parent, int last_ref);
+void btrfs_free_reserved_tree_block(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    u64 bytenr, u32 blocksize,
+				    struct extent_buffer *buf);
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2010-04-14 14:49:56.932956992 +0800
+++ 2/fs/btrfs/extent-tree.c	2010-05-11 14:00:54.906106739 +0800
@@ -4066,19 +4066,58 @@ int btrfs_free_extent(struct btrfs_trans
 	return ret;
 }
 
-int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  u64 bytenr, u32 blocksize,
-			  u64 parent, u64 root_objectid, int level)
-{
-	u64 used;
-	spin_lock(&root->node_lock);
-	used = btrfs_root_used(&root->root_item) - blocksize;
-	btrfs_set_root_used(&root->root_item, used);
-	spin_unlock(&root->node_lock);
+void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct extent_buffer *buf,
+			   u64 parent, int last_ref)
+{
+	struct extent_buffer *orig_buf = buf;
+	u64 bytenr = buf->start;
+	u32 blocksize = buf->len;
+	int level;
+	int ret;
+
+	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
+		BUG_ON(!last_ref);
+		btrfs_free_reserved_tree_block(trans, root,
+					       bytenr, blocksize, buf);
+		return;
+	}
+
+	level = btrfs_header_level(buf);
+	ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
+				root->root_key.objectid, level, 0);
+	BUG_ON(ret);
+
+	if (orig_buf && orig_buf != buf)
+		free_extent_buffer(orig_buf);
+}
 
-	return btrfs_free_extent(trans, root, bytenr, blocksize,
-				 parent, root_objectid, level, 0);
+void btrfs_free_reserved_tree_block(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    u64 bytenr, u32 blocksize,
+				    struct extent_buffer *buf)
+{
+	int ret;
+
+	if (buf) {
+		bytenr = buf->start;
+		blocksize = buf->len;
+	}
+
+	buf = NULL;
+	ret = pin_down_bytes(trans, root, NULL, bytenr, blocksize, 0, 1, &buf);
+
+	if (buf) {
+		clean_tree_block(NULL, root, buf);
+		btrfs_tree_unlock(buf);
+		free_extent_buffer(buf);
+	}
+
+	if (ret > 0) {
+		ret = btrfs_free_reserved_extent(root, bytenr, blocksize);
+		BUG_ON(ret);
+	}
 }
 
 static u64 stripe_align(struct btrfs_root *root, u64 val)
diff -urp 1/fs/btrfs/tree-log.c 2/fs/btrfs/tree-log.c
--- 1/fs/btrfs/tree-log.c	2010-04-14 14:49:58.978946890 +0800
+++ 2/fs/btrfs/tree-log.c	2010-05-11 13:27:58.658108016 +0800
@@ -1671,7 +1671,6 @@ static noinline int walk_down_log_tree(s
 	struct extent_buffer *cur;
 	struct extent_buffer *parent;
 	u32 blocksize;
-	int ret = 0;
 
 	WARN_ON(*level < 0);
 	WARN_ON(*level >= BTRFS_MAX_LEVEL);
@@ -1713,9 +1712,8 @@ static noinline int walk_down_log_tree(s
 
 				WARN_ON(root_owner !=
 					BTRFS_TREE_LOG_OBJECTID);
-				ret = btrfs_free_reserved_extent(root,
-							 bytenr, blocksize);
-				BUG_ON(ret);
+				btrfs_free_reserved_tree_block(trans, root,
+								0, 0, next);
 			}
 			free_extent_buffer(next);
 			continue;
@@ -1756,8 +1754,7 @@ static noinline int walk_down_log_tree(s
 		btrfs_tree_unlock(next);
 
 		WARN_ON(root_owner != BTRFS_TREE_LOG_OBJECTID);
-		ret = btrfs_free_reserved_extent(root, bytenr, blocksize);
-		BUG_ON(ret);
+		btrfs_free_reserved_tree_block(trans, root, 0, 0, next);
 	}
 	free_extent_buffer(path->nodes[*level]);
 	path->nodes[*level] = NULL;
@@ -1776,7 +1773,6 @@ static noinline int walk_up_log_tree(str
 	u64 root_gen;
 	int i;
 	int slot;
-	int ret;
 
 	for (i = *level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
 		slot = path->slots[i];
@@ -1810,10 +1806,8 @@ static noinline int walk_up_log_tree(str
 				btrfs_tree_unlock(next);
 
 				WARN_ON(root_owner != BTRFS_TREE_LOG_OBJECTID);
-				ret = btrfs_free_reserved_extent(root,
-						path->nodes[*level]->start,
-						path->nodes[*level]->len);
-				BUG_ON(ret);
+				btrfs_free_reserved_tree_block(trans, root,
+						0, 0, path->nodes[*level]);
 			}
 			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] = NULL;
@@ -1878,9 +1872,7 @@ static int walk_log_tree(struct btrfs_tr
 
 			WARN_ON(log->root_key.objectid !=
 				BTRFS_TREE_LOG_OBJECTID);
-			ret = btrfs_free_reserved_extent(log, next->start,
-							 next->len);
-			BUG_ON(ret);
+			btrfs_free_reserved_tree_block(trans, log, 0, 0, next);
 		}
 	}
 

