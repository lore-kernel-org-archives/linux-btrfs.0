From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 4/6] btrfs: various changes for the mixed back ref
Date: Mon, 11 May 2009 23:25:07 +0800
Message-ID: <4A084353.8030004@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch contains various update for the mixed back ref.



Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 4/fs/btrfs/ctree.c 5/fs/btrfs/ctree.c
--- 4/fs/btrfs/ctree.c	2009-05-11 16:38:07.000000000 +0800
+++ 5/fs/btrfs/ctree.c	2009-05-11 16:16:11.000000000 +0800
@@ -197,14 +197,7 @@ int btrfs_copy_root(struct btrfs_trans_h
 	u32 nritems;
 	int ret = 0;
 	int level;
-	struct btrfs_root *new_root;
-
-	new_root = kmalloc(sizeof(*new_root), GFP_NOFS);
-	if (!new_root)
-		return -ENOMEM;
-
-	memcpy(new_root, root, sizeof(*new_root));
-	new_root->root_key.objectid = new_root_objectid;
+	struct btrfs_disk_key disk_key;
 
 	WARN_ON(root->ref_cows && trans->transid !=
 		root->fs_info->running_transaction->transid);
@@ -212,28 +205,36 @@ int btrfs_copy_root(struct btrfs_trans_h
 
 	level = btrfs_header_level(buf);
 	nritems = btrfs_header_nritems(buf);
+	if (level == 0)
+		btrfs_item_key(buf, &disk_key, 0);
+	else
+		btrfs_node_key(buf, &disk_key, 0);
 
-	cow = btrfs_alloc_free_block(trans, new_root, buf->len, 0,
-				     new_root_objectid, trans->transid,
-				     level, buf->start, 0);
-	if (IS_ERR(cow)) {
-		kfree(new_root);
+	cow = btrfs_alloc_free_block(trans, root, buf->len, 0,
+				     new_root_objectid, &disk_key, level,
+				     buf->start, 0);
+	if (IS_ERR(cow))
 		return PTR_ERR(cow);
-	}
 
 	copy_extent_buffer(cow, buf, 0, 0, cow->len);
 	btrfs_set_header_bytenr(cow, cow->start);
 	btrfs_set_header_generation(cow, trans->transid);
-	btrfs_set_header_owner(cow, new_root_objectid);
-	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN);
+	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN |
+				     BTRFS_HEADER_FLAG_RELOC);
+	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
+		btrfs_set_header_flag(cow, BTRFS_HEADER_FLAG_RELOC);
+	else
+		btrfs_set_header_owner(cow, new_root_objectid);
 
 	write_extent_buffer(cow, root->fs_info->fsid,
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
-	ret = btrfs_inc_ref(trans, new_root, buf, cow, NULL);
-	kfree(new_root);
+	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
+		ret = btrfs_inc_ref(trans, root, cow, 1);
+	else
+		ret = btrfs_inc_ref(trans, root, cow, 0);
 
 	if (ret)
 		return ret;
@@ -403,34 +404,39 @@ static noinline int __btrfs_cow_block(st
 			     struct extent_buffer **cow_ret,
 			     u64 search_start, u64 empty_size)
 {
-	u64 parent_start;
+	struct btrfs_disk_key disk_key;
 	struct extent_buffer *cow;
-	u32 nritems;
-	int ret = 0;
 	int level;
 	int unlock_orig = 0;
+	u64 parent_start;
 
 	if (*cow_ret == buf)
 		unlock_orig = 1;
 
 	btrfs_assert_tree_locked(buf);
 
-	if (parent)
-		parent_start = parent->start;
-	else
-		parent_start = 0;
-
 	WARN_ON(root->ref_cows && trans->transid !=
 		root->fs_info->running_transaction->transid);
 	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
 
 	level = btrfs_header_level(buf);
-	nritems = btrfs_header_nritems(buf);
 
-	cow = btrfs_alloc_free_block(trans, root, buf->len,
-				     parent_start, root->root_key.objectid,
-				     trans->transid, level,
-				     search_start, empty_size);
+	if (level == 0)
+		btrfs_item_key(buf, &disk_key, 0);
+	else
+		btrfs_node_key(buf, &disk_key, 0);
+
+	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		if (parent)
+			parent_start = parent->start;
+		else
+			parent_start = 0;
+	} else
+		parent_start = 0;
+
+	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
+				     root->root_key.objectid, &disk_key,
+				     level, search_start, empty_size);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
@@ -1040,13 +1046,6 @@ static noinline int balance_level(struct
 		root->node = child;
 		spin_unlock(&root->node_lock);
 
-		ret = btrfs_update_extent_ref(trans, root, child->start,
-					      child->len,
-					      mid->start, child->start,
-					      root->root_key.objectid,
-					      trans->transid, level - 1);
-		BUG_ON(ret);
-
 		add_root_to_dirty_list(root);
 		btrfs_tree_unlock(child);
 
@@ -1057,9 +1056,7 @@ static noinline int balance_level(struct
 		/* once for the path */
 		free_extent_buffer(mid);
 		ret = btrfs_free_extent(trans, root, mid->start, mid->len,
-					mid->start, root->root_key.objectid,
-					btrfs_header_generation(mid),
-					level, 1);
+					0, root->root_key.objectid, level, 1);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
 		return ret;
@@ -1117,7 +1114,6 @@ static noinline int balance_level(struct
 			ret = wret;
 		if (btrfs_header_nritems(right) == 0) {
 			u64 bytenr = right->start;
-			u64 generation = btrfs_header_generation(parent);
 			u32 blocksize = right->len;
 
 			clean_tree_block(trans, root, right);
@@ -1129,9 +1125,9 @@ static noinline int balance_level(struct
 			if (wret)
 				ret = wret;
 			wret = btrfs_free_extent(trans, root, bytenr,
-						 blocksize, parent->start,
-						 btrfs_header_owner(parent),
-						 generation, level, 1);
+						 blocksize, 0,
+						 root->root_key.objectid,
+						 level, 0);
 			if (wret)
 				ret = wret;
 		} else {
@@ -1166,7 +1162,6 @@ static noinline int balance_level(struct
 	}
 	if (btrfs_header_nritems(mid) == 0) {
 		/* we've managed to empty the middle node, drop it */
-		u64 root_gen = btrfs_header_generation(parent);
 		u64 bytenr = mid->start;
 		u32 blocksize = mid->len;
 
@@ -1178,9 +1173,8 @@ static noinline int balance_level(struct
 		if (wret)
 			ret = wret;
 		wret = btrfs_free_extent(trans, root, bytenr, blocksize,
-					 parent->start,
-					 btrfs_header_owner(parent),
-					 root_gen, level, 1);
+					 0, root->root_key.objectid,
+					 level, 0);
 		if (wret)
 			ret = wret;
 	} else {
@@ -1556,7 +1550,7 @@ noinline void btrfs_unlock_up_safe(struc
 {
 	int i;
 
-	if (path->keep_locks || path->lowest_level)
+	if (path->keep_locks)
 		return;
 
 	for (i = level; i < BTRFS_MAX_LEVEL; i++) {
@@ -2115,9 +2109,6 @@ static int push_node_left(struct btrfs_t
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
 
-	ret = btrfs_update_ref(trans, root, src, dst, dst_nritems, push_items);
-	BUG_ON(ret);
-
 	return ret;
 }
 
@@ -2177,9 +2168,6 @@ static int balance_node_right(struct btr
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
 
-	ret = btrfs_update_ref(trans, root, src, dst, 0, push_items);
-	BUG_ON(ret);
-
 	return ret;
 }
 
@@ -2199,7 +2187,6 @@ static noinline int insert_new_root(stru
 	struct extent_buffer *c;
 	struct extent_buffer *old;
 	struct btrfs_disk_key lower_key;
-	int ret;
 
 	BUG_ON(path->nodes[level]);
 	BUG_ON(path->nodes[level-1] != root->node);
@@ -2211,7 +2198,7 @@ static noinline int insert_new_root(stru
 		btrfs_node_key(lower, &lower_key, 0);
 
 	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
-				   root->root_key.objectid, trans->transid,
+				   root->root_key.objectid, &lower_key,
 				   level, root->node->start, 0);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
@@ -2245,12 +2232,6 @@ static noinline int insert_new_root(stru
 	root->node = c;
 	spin_unlock(&root->node_lock);
 
-	ret = btrfs_update_extent_ref(trans, root, lower->start,
-				      lower->len, lower->start, c->start,
-				      root->root_key.objectid,
-				      trans->transid, level - 1);
-	BUG_ON(ret);
-
 	/* the super has an extra ref to root->node */
 	free_extent_buffer(old);
 
@@ -2338,11 +2319,12 @@ static noinline int split_node(struct bt
 	}
 
 	c_nritems = btrfs_header_nritems(c);
+	mid = (c_nritems + 1) / 2;
+	btrfs_node_key(c, &disk_key, mid);
 
-	split = btrfs_alloc_free_block(trans, root, root->nodesize,
-					path->nodes[level + 1]->start,
+	split = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 					root->root_key.objectid,
-					trans->transid, level, c->start, 0);
+					&disk_key, level, c->start, 0);
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
@@ -2359,7 +2341,6 @@ static noinline int split_node(struct bt
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
 
-	mid = (c_nritems + 1) / 2;
 
 	copy_extent_buffer(split, c,
 			   btrfs_node_key_ptr_offset(0),
@@ -2372,16 +2353,12 @@ static noinline int split_node(struct bt
 	btrfs_mark_buffer_dirty(c);
 	btrfs_mark_buffer_dirty(split);
 
-	btrfs_node_key(split, &disk_key, 0);
 	wret = insert_ptr(trans, root, path, &disk_key, split->start,
 			  path->slots[level + 1] + 1,
 			  level + 1);
 	if (wret)
 		ret = wret;
 
-	ret = btrfs_update_ref(trans, root, c, split, 0, c_nritems - mid);
-	BUG_ON(ret);
-
 	if (path->slots[level] >= mid) {
 		path->slots[level] -= mid;
 		btrfs_tree_unlock(c);
@@ -2454,7 +2431,6 @@ static noinline int __push_leaf_right(st
 	u32 right_nritems;
 	u32 data_end;
 	u32 this_item_size;
-	int ret;
 
 	if (empty)
 		nr = 0;
@@ -2567,9 +2543,6 @@ static noinline int __push_leaf_right(st
 		btrfs_mark_buffer_dirty(left);
 	btrfs_mark_buffer_dirty(right);
 
-	ret = btrfs_update_ref(trans, root, left, right, 0, push_items);
-	BUG_ON(ret);
-
 	btrfs_item_key(right, &disk_key, 0);
 	btrfs_set_node_key(upper, &disk_key, slot + 1);
 	btrfs_mark_buffer_dirty(upper);
@@ -2814,10 +2787,6 @@ static noinline int __push_leaf_left(str
 	if (right_nritems)
 		btrfs_mark_buffer_dirty(right);
 
-	ret = btrfs_update_ref(trans, root, right, left,
-			       old_left_nritems, push_items);
-	BUG_ON(ret);
-
 	btrfs_item_key(right, &disk_key, 0);
 	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
 	if (wret)
@@ -2974,9 +2943,6 @@ static noinline int copy_for_split(struc
 	btrfs_mark_buffer_dirty(l);
 	BUG_ON(path->slots[0] != slot);
 
-	ret = btrfs_update_ref(trans, root, l, right, 0, nritems);
-	BUG_ON(ret);
-
 	if (mid <= slot) {
 		btrfs_tree_unlock(path->nodes[0]);
 		free_extent_buffer(path->nodes[0]);
@@ -3005,6 +2971,7 @@ static noinline int split_leaf(struct bt
 			       struct btrfs_path *path, int data_size,
 			       int extend)
 {
+	struct btrfs_disk_key disk_key;
 	struct extent_buffer *l;
 	u32 nritems;
 	int mid;
@@ -3012,7 +2979,7 @@ static noinline int split_leaf(struct bt
 	struct extent_buffer *right;
 	int ret = 0;
 	int wret;
-	int double_split;
+	int split;
 	int num_doubles = 0;
 
 	/* first try to make some room by pushing left and right */
@@ -3039,16 +3006,53 @@ static noinline int split_leaf(struct bt
 			return ret;
 	}
 again:
-	double_split = 0;
+	split = 1;
 	l = path->nodes[0];
 	slot = path->slots[0];
 	nritems = btrfs_header_nritems(l);
 	mid = (nritems + 1) / 2;
 
-	right = btrfs_alloc_free_block(trans, root, root->leafsize,
-					path->nodes[1]->start,
+	if (mid <= slot) {
+		if (nritems == 1 ||
+		    leaf_space_used(l, mid, nritems - mid) + data_size >
+			BTRFS_LEAF_DATA_SIZE(root)) {
+			if (slot >= nritems) {
+				split = 0;
+			} else {
+				mid = slot;
+				if (mid != nritems &&
+				    leaf_space_used(l, mid, nritems - mid) +
+				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
+					split = 2;
+				}
+			}
+		}
+	} else {
+		if (leaf_space_used(l, 0, mid) + data_size >
+			BTRFS_LEAF_DATA_SIZE(root)) {
+			if (!extend && data_size && slot == 0) {
+				split = 0;
+			} else if ((extend || !data_size) && slot == 0) {
+				mid = 1;
+			} else {
+				mid = slot;
+				if (mid != nritems &&
+				    leaf_space_used(l, mid, nritems - mid) +
+				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
+					split = 2 ;
+				}
+			}
+		}
+	}
+
+	if (split == 0)
+		btrfs_cpu_key_to_disk(&disk_key, ins_key);
+	else
+		btrfs_item_key(l, &disk_key, mid);
+
+	right = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 					root->root_key.objectid,
-					trans->transid, 0, l->start, 0);
+					&disk_key, 0, l->start, 0);
 	if (IS_ERR(right)) {
 		BUG_ON(1);
 		return PTR_ERR(right);
@@ -3067,79 +3071,47 @@ again:
 			    (unsigned long)btrfs_header_chunk_tree_uuid(right),
 			    BTRFS_UUID_SIZE);
 
-	if (mid <= slot) {
-		if (nritems == 1 ||
-		    leaf_space_used(l, mid, nritems - mid) + data_size >
-			BTRFS_LEAF_DATA_SIZE(root)) {
-			if (slot >= nritems) {
-				struct btrfs_disk_key disk_key;
-
-				btrfs_cpu_key_to_disk(&disk_key, ins_key);
-				btrfs_set_header_nritems(right, 0);
-				wret = insert_ptr(trans, root, path,
-						  &disk_key, right->start,
-						  path->slots[1] + 1, 1);
-				if (wret)
-					ret = wret;
-
-				btrfs_tree_unlock(path->nodes[0]);
-				free_extent_buffer(path->nodes[0]);
-				path->nodes[0] = right;
-				path->slots[0] = 0;
-				path->slots[1] += 1;
-				btrfs_mark_buffer_dirty(right);
-				return ret;
-			}
-			mid = slot;
-			if (mid != nritems &&
-			    leaf_space_used(l, mid, nritems - mid) +
-			    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
-				double_split = 1;
-			}
-		}
-	} else {
-		if (leaf_space_used(l, 0, mid) + data_size >
-			BTRFS_LEAF_DATA_SIZE(root)) {
-			if (!extend && data_size && slot == 0) {
-				struct btrfs_disk_key disk_key;
+	if (split == 0) {
+		if (mid <= slot) {
+			btrfs_set_header_nritems(right, 0);
+			wret = insert_ptr(trans, root, path,
+					  &disk_key, right->start,
+					  path->slots[1] + 1, 1);
+			if (wret)
+				ret = wret;
 
-				btrfs_cpu_key_to_disk(&disk_key, ins_key);
-				btrfs_set_header_nritems(right, 0);
-				wret = insert_ptr(trans, root, path,
-						  &disk_key,
-						  right->start,
-						  path->slots[1], 1);
+			btrfs_tree_unlock(path->nodes[0]);
+			free_extent_buffer(path->nodes[0]);
+			path->nodes[0] = right;
+			path->slots[0] = 0;
+			path->slots[1] += 1;
+		} else {
+			btrfs_set_header_nritems(right, 0);
+			wret = insert_ptr(trans, root, path,
+					  &disk_key,
+					  right->start,
+					  path->slots[1], 1);
+			if (wret)
+				ret = wret;
+			btrfs_tree_unlock(path->nodes[0]);
+			free_extent_buffer(path->nodes[0]);
+			path->nodes[0] = right;
+			path->slots[0] = 0;
+			if (path->slots[1] == 0) {
+				wret = fixup_low_keys(trans, root,
+						path, &disk_key, 1);
 				if (wret)
 					ret = wret;
-				btrfs_tree_unlock(path->nodes[0]);
-				free_extent_buffer(path->nodes[0]);
-				path->nodes[0] = right;
-				path->slots[0] = 0;
-				if (path->slots[1] == 0) {
-					wret = fixup_low_keys(trans, root,
-						      path, &disk_key, 1);
-					if (wret)
-						ret = wret;
-				}
-				btrfs_mark_buffer_dirty(right);
-				return ret;
-			} else if ((extend || !data_size) && slot == 0) {
-				mid = 1;
-			} else {
-				mid = slot;
-				if (mid != nritems &&
-				    leaf_space_used(l, mid, nritems - mid) +
-				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
-					double_split = 1;
-				}
 			}
 		}
+		btrfs_mark_buffer_dirty(right);
+		return ret;
 	}
 
 	ret = copy_for_split(trans, root, path, l, right, slot, mid, nritems);
 	BUG_ON(ret);
 
-	if (double_split) {
+	if (split == 2) {
 		BUG_ON(num_doubles != 0);
 		num_doubles++;
 		goto again;
@@ -3541,7 +3513,7 @@ int btrfs_insert_some_items(struct btrfs
 		/* figure out how many keys we can insert in here */
 		total_data = data_size[0];
 		for (i = 1; i < nr; i++) {
-			if (comp_cpu_keys(&found_key, cpu_key + i) <= 0)
+			if (btrfs_comp_cpu_keys(&found_key, cpu_key + i) <= 0)
 				break;
 			total_data += data_size[i];
 		}
@@ -3839,9 +3811,7 @@ static int del_ptr(struct btrfs_trans_ha
 
 /*
  * a helper function to delete the leaf pointed to by path->slots[1] and
- * path->nodes[1].  bytenr is the node block pointer, but since the callers
- * already know it, it is faster to have them pass it down than to
- * read it out of the node again.
+ * path->nodes[1].
  *
  * This deletes the pointer in path->nodes[1] and frees the leaf
  * block extent.  zero is returned if it all worked out, < 0 otherwise.
@@ -3849,15 +3819,14 @@ static int del_ptr(struct btrfs_trans_ha
  * The path must have already been setup for deleting the leaf, including
  * all the proper balancing.  path->nodes[1] must be locked.
  */
-noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    struct btrfs_path *path, u64 bytenr)
+static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_path *path,
+				   struct extent_buffer *leaf)
 {
 	int ret;
-	u64 root_gen = btrfs_header_generation(path->nodes[1]);
-	u64 parent_start = path->nodes[1]->start;
-	u64 parent_owner = btrfs_header_owner(path->nodes[1]);
 
+	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
 	ret = del_ptr(trans, root, path, 1, path->slots[1]);
 	if (ret)
 		return ret;
@@ -3868,10 +3837,8 @@ noinline int btrfs_del_leaf(struct btrfs
 	 */
 	btrfs_unlock_up_safe(path, 0);
 
-	ret = btrfs_free_extent(trans, root, bytenr,
-				btrfs_level_size(root, 0),
-				parent_start, parent_owner,
-				root_gen, 0, 1);
+	ret = btrfs_free_extent(trans, root, leaf->start, leaf->len,
+				0, root->root_key.objectid, 0, 0);
 	return ret;
 }
 /*
@@ -3939,7 +3906,7 @@ int btrfs_del_items(struct btrfs_trans_h
 		if (leaf == root->node) {
 			btrfs_set_header_level(leaf, 0);
 		} else {
-			ret = btrfs_del_leaf(trans, root, path, leaf->start);
+			ret = btrfs_del_leaf(trans, root, path, leaf);
 			BUG_ON(ret);
 		}
 	} else {
@@ -3978,8 +3945,7 @@ int btrfs_del_items(struct btrfs_trans_h
 
 			if (btrfs_header_nritems(leaf) == 0) {
 				path->slots[1] = slot;
-				ret = btrfs_del_leaf(trans, root, path,
-						     leaf->start);
+				ret = btrfs_del_leaf(trans, root, path, leaf);
 				BUG_ON(ret);
 				free_extent_buffer(leaf);
 			} else {
diff -urp 4/fs/btrfs/ctree.h 5/fs/btrfs/ctree.h
--- 4/fs/btrfs/ctree.h	2009-05-11 16:44:39.000000000 +0800
+++ 5/fs/btrfs/ctree.h	2009-05-11 16:23:00.000000000 +0800
@@ -1982,9 +1982,6 @@ void btrfs_unlock_up_safe(struct btrfs_p
 
 int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int slot, int nr);
-int btrfs_del_leaf(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    struct btrfs_path *path, u64 bytenr);
 static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_path *path)
diff -urp 4/fs/btrfs/disk-io.c 5/fs/btrfs/disk-io.c
--- 4/fs/btrfs/disk-io.c	2009-05-11 16:38:07.000000000 +0800
+++ 5/fs/btrfs/disk-io.c	2009-05-11 16:16:11.000000000 +0800
@@ -1030,9 +1030,8 @@ static struct btrfs_root *alloc_log_tree
 	 */
 	root->ref_cows = 0;
 
-	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
-				      0, BTRFS_TREE_LOG_OBJECTID,
-				      trans->transid, 0, 0, 0);
+	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
+				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		kfree(root);
 		return ERR_CAST(leaf);
diff -urp 4/fs/btrfs/file.c 5/fs/btrfs/file.c
--- 4/fs/btrfs/file.c	2009-05-11 16:38:07.000000000 +0800
+++ 5/fs/btrfs/file.c	2009-05-11 16:16:11.000000000 +0800
@@ -291,16 +291,12 @@ noinline int btrfs_drop_extents(struct b
 {
 	u64 extent_end = 0;
 	u64 search_start = start;
-	u64 leaf_start;
 	u64 ram_bytes = 0;
-	u64 orig_parent = 0;
 	u64 disk_bytenr = 0;
 	u64 orig_locked_end = locked_end;
 	u8 compression;
 	u8 encryption;
 	u16 other_encoding = 0;
-	u64 root_gen;
-	u64 root_owner;
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *extent;
 	struct btrfs_path *path;
@@ -340,9 +336,6 @@ next_slot:
 		bookend = 0;
 		found_extent = 0;
 		found_inline = 0;
-		leaf_start = 0;
-		root_gen = 0;
-		root_owner = 0;
 		compression = 0;
 		encryption = 0;
 		extent = NULL;
@@ -417,9 +410,6 @@ next_slot:
 		if (found_extent) {
 			read_extent_buffer(leaf, &old, (unsigned long)extent,
 					   sizeof(old));
-			root_gen = btrfs_header_generation(leaf);
-			root_owner = btrfs_header_owner(leaf);
-			leaf_start = leaf->start;
 		}
 
 		if (end < extent_end && end >= key.offset) {
@@ -443,14 +433,14 @@ next_slot:
 				}
 				locked_end = extent_end;
 			}
-			orig_parent = path->nodes[0]->start;
 			disk_bytenr = le64_to_cpu(old.disk_bytenr);
 			if (disk_bytenr != 0) {
 				ret = btrfs_inc_extent_ref(trans, root,
 					   disk_bytenr,
-					   le64_to_cpu(old.disk_num_bytes),
-					   orig_parent, root->root_key.objectid,
-					   trans->transid, inode->i_ino);
+					   le64_to_cpu(old.disk_num_bytes), 0,
+					   root->root_key.objectid,
+					   key.objectid, key.offset -
+					   le64_to_cpu(old.offset));
 				BUG_ON(ret);
 			}
 		}
@@ -568,17 +558,6 @@ next_slot:
 			btrfs_mark_buffer_dirty(path->nodes[0]);
 			btrfs_set_lock_blocking(path->nodes[0]);
 
-			if (disk_bytenr != 0) {
-				ret = btrfs_update_extent_ref(trans, root,
-						disk_bytenr,
-						le64_to_cpu(old.disk_num_bytes),
-						orig_parent,
-						leaf->start,
-						root->root_key.objectid,
-						trans->transid, ins.objectid);
-
-				BUG_ON(ret);
-			}
 			path->leave_spinning = 0;
 			btrfs_release_path(root, path);
 			if (disk_bytenr != 0)
@@ -594,8 +573,9 @@ next_slot:
 				ret = btrfs_free_extent(trans, root,
 						old_disk_bytenr,
 						le64_to_cpu(old.disk_num_bytes),
-						leaf_start, root_owner,
-						root_gen, key.objectid, 0);
+						0, root->root_key.objectid,
+						key.objectid, key.offset -
+						le64_to_cpu(old.offset));
 				BUG_ON(ret);
 				*hint_byte = old_disk_bytenr;
 			}
@@ -664,12 +644,11 @@ int btrfs_mark_extent_written(struct btr
 	u64 bytenr;
 	u64 num_bytes;
 	u64 extent_end;
-	u64 extent_offset;
+	u64 orig_offset;
 	u64 other_start;
 	u64 other_end;
 	u64 split = start;
 	u64 locked_end = end;
-	u64 orig_parent;
 	int extent_type;
 	int split_end = 1;
 	int ret;
@@ -703,7 +682,7 @@ again:
 
 	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 	num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
-	extent_offset = btrfs_file_extent_offset(leaf, fi);
+	orig_offset = key.offset - btrfs_file_extent_offset(leaf, fi);
 
 	if (key.offset == start)
 		split = end;
@@ -711,8 +690,6 @@ again:
 	if (key.offset == start && extent_end == end) {
 		int del_nr = 0;
 		int del_slot = 0;
-		u64 leaf_owner = btrfs_header_owner(leaf);
-		u64 leaf_gen = btrfs_header_generation(leaf);
 		other_start = end;
 		other_end = 0;
 		if (extent_mergeable(leaf, path->slots[0] + 1, inode->i_ino,
@@ -721,8 +698,8 @@ again:
 			del_slot = path->slots[0] + 1;
 			del_nr++;
 			ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
-						leaf->start, leaf_owner,
-						leaf_gen, inode->i_ino, 0);
+						0, root->root_key.objectid,
+						inode->i_ino, orig_offset);
 			BUG_ON(ret);
 		}
 		other_start = 0;
@@ -733,8 +710,8 @@ again:
 			del_slot = path->slots[0];
 			del_nr++;
 			ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
-						leaf->start, leaf_owner,
-						leaf_gen, inode->i_ino, 0);
+						0, root->root_key.objectid,
+						inode->i_ino, orig_offset);
 			BUG_ON(ret);
 		}
 		split_end = 0;
@@ -768,13 +745,12 @@ again:
 			locked_end = extent_end;
 		}
 		btrfs_set_file_extent_num_bytes(leaf, fi, split - key.offset);
-		extent_offset += split - key.offset;
 	} else  {
 		BUG_ON(key.offset != start);
-		btrfs_set_file_extent_offset(leaf, fi, extent_offset +
-					     split - key.offset);
-		btrfs_set_file_extent_num_bytes(leaf, fi, extent_end - split);
 		key.offset = split;
+		btrfs_set_file_extent_offset(leaf, fi, key.offset -
+					     orig_offset);
+		btrfs_set_file_extent_num_bytes(leaf, fi, extent_end - split);
 		btrfs_set_item_key_safe(trans, root, path, &key);
 		extent_end = split;
 	}
@@ -793,7 +769,8 @@ again:
 					    struct btrfs_file_extent_item);
 			key.offset = split;
 			btrfs_set_item_key_safe(trans, root, path, &key);
-			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
+			btrfs_set_file_extent_offset(leaf, fi, key.offset -
+						     orig_offset);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							other_end - split);
 			goto done;
@@ -815,10 +792,9 @@ again:
 
 	btrfs_mark_buffer_dirty(leaf);
 
-	orig_parent = leaf->start;
-	ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
-				   orig_parent, root->root_key.objectid,
-				   trans->transid, inode->i_ino);
+	ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
+				   root->root_key.objectid,
+				   inode->i_ino, orig_offset);
 	BUG_ON(ret);
 	btrfs_release_path(root, path);
 
@@ -833,20 +809,12 @@ again:
 	btrfs_set_file_extent_type(leaf, fi, extent_type);
 	btrfs_set_file_extent_disk_bytenr(leaf, fi, bytenr);
 	btrfs_set_file_extent_disk_num_bytes(leaf, fi, num_bytes);
-	btrfs_set_file_extent_offset(leaf, fi, extent_offset);
+	btrfs_set_file_extent_offset(leaf, fi, key.offset - orig_offset);
 	btrfs_set_file_extent_num_bytes(leaf, fi, extent_end - key.offset);
 	btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
 	btrfs_set_file_extent_compression(leaf, fi, 0);
 	btrfs_set_file_extent_encryption(leaf, fi, 0);
 	btrfs_set_file_extent_other_encoding(leaf, fi, 0);
-
-	if (orig_parent != leaf->start) {
-		ret = btrfs_update_extent_ref(trans, root, bytenr, num_bytes,
-					      orig_parent, leaf->start,
-					      root->root_key.objectid,
-					      trans->transid, inode->i_ino);
-		BUG_ON(ret);
-	}
 done:
 	btrfs_mark_buffer_dirty(leaf);
 
diff -urp 4/fs/btrfs/inode.c 5/fs/btrfs/inode.c
--- 4/fs/btrfs/inode.c	2009-05-11 16:38:07.000000000 +0800
+++ 5/fs/btrfs/inode.c	2009-05-11 16:16:11.000000000 +0800
@@ -944,6 +944,7 @@ static noinline int run_delalloc_nocow(s
 	u64 cow_start;
 	u64 cur_offset;
 	u64 extent_end;
+	u64 extent_offset;
 	u64 disk_bytenr;
 	u64 num_bytes;
 	int extent_type;
@@ -1005,6 +1006,7 @@ next_slot:
 		if (extent_type == BTRFS_FILE_EXTENT_REG ||
 		    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 			disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+			extent_offset = btrfs_file_extent_offset(leaf, fi);
 			extent_end = found_key.offset +
 				btrfs_file_extent_num_bytes(leaf, fi);
 			if (extent_end <= start) {
@@ -1022,9 +1024,10 @@ next_slot:
 			if (btrfs_extent_readonly(root, disk_bytenr))
 				goto out_check;
 			if (btrfs_cross_ref_exist(trans, root, inode->i_ino,
-						  disk_bytenr))
+						  found_key.offset -
+						  extent_offset, disk_bytenr))
 				goto out_check;
-			disk_bytenr += btrfs_file_extent_offset(leaf, fi);
+			disk_bytenr += extent_offset;
 			disk_bytenr += cur_offset - found_key.offset;
 			num_bytes = min(end + 1, extent_end) - cur_offset;
 			/*
@@ -1489,9 +1492,9 @@ static int insert_reserved_file_extent(s
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
-	ret = btrfs_alloc_reserved_extent(trans, root, leaf->start,
-					  root->root_key.objectid,
-					  trans->transid, inode->i_ino, &ins);
+	ret = btrfs_alloc_reserved_file_extent(trans, root,
+					root->root_key.objectid,
+					inode->i_ino, file_pos, &ins);
 	BUG_ON(ret);
 	btrfs_free_path(path);
 
@@ -1956,23 +1959,13 @@ void btrfs_orphan_cleanup(struct btrfs_r
 		 * crossing root thing.  we store the inode number in the
 		 * offset of the orphan item.
 		 */
-		inode = btrfs_iget_locked(root->fs_info->sb,
-					  found_key.offset, root);
-		if (!inode)
+		found_key.objectid = found_key.offset;
+		found_key.type = BTRFS_INODE_ITEM_KEY;
+		found_key.offset = 0;
+		inode = btrfs_iget(root->fs_info->sb, &found_key, root);
+		if (IS_ERR(inode))
 			break;
 
-		if (inode->i_state & I_NEW) {
-			BTRFS_I(inode)->root = root;
-
-			/* have to set the location manually */
-			BTRFS_I(inode)->location.objectid = inode->i_ino;
-			BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
-			BTRFS_I(inode)->location.offset = 0;
-
-			btrfs_read_locked_inode(inode);
-			unlock_new_inode(inode);
-		}
-
 		/*
 		 * add this inode to the orphan list so btrfs_orphan_del does
 		 * the proper thing when we hit it
@@ -2069,7 +2062,7 @@ static noinline int acls_after_inode_ite
 /*
  * read an inode from the btree into the in-memory inode
  */
-void btrfs_read_locked_inode(struct inode *inode)
+static void btrfs_read_locked_inode(struct inode *inode)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -2599,9 +2592,8 @@ noinline int btrfs_truncate_inode_items(
 	struct btrfs_file_extent_item *fi;
 	u64 extent_start = 0;
 	u64 extent_num_bytes = 0;
+	u64 extent_offset = 0;
 	u64 item_end = 0;
-	u64 root_gen = 0;
-	u64 root_owner = 0;
 	int found_extent;
 	int del_item;
 	int pending_del_nr = 0;
@@ -2716,6 +2708,9 @@ search_again:
 				extent_num_bytes =
 					btrfs_file_extent_disk_num_bytes(leaf,
 									 fi);
+				extent_offset = found_key.offset -
+					btrfs_file_extent_offset(leaf, fi);
+
 				/* FIXME blocksize != 4096 */
 				num_dec = btrfs_file_extent_num_bytes(leaf, fi);
 				if (extent_start != 0) {
@@ -2723,8 +2718,6 @@ search_again:
 					if (root->ref_cows)
 						inode_sub_bytes(inode, num_dec);
 				}
-				root_gen = btrfs_header_generation(leaf);
-				root_owner = btrfs_header_owner(leaf);
 			}
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			/*
@@ -2771,9 +2764,9 @@ delete:
 		if (found_extent) {
 			btrfs_set_path_blocking(path);
 			ret = btrfs_free_extent(trans, root, extent_start,
-						extent_num_bytes,
-						leaf->start, root_owner,
-						root_gen, inode->i_ino, 0);
+						extent_num_bytes, 0,
+						btrfs_header_owner(leaf),
+						inode->i_ino, extent_offset);
 			BUG_ON(ret);
 		}
 next:
diff -urp 4/fs/btrfs/ioctl.c 5/fs/btrfs/ioctl.c
--- 4/fs/btrfs/ioctl.c	2009-05-11 16:38:07.000000000 +0800
+++ 5/fs/btrfs/ioctl.c	2009-05-11 16:16:11.000000000 +0800
@@ -82,8 +82,8 @@ static noinline int create_subvol(struct
 	if (ret)
 		goto fail;
 
-	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
-				      objectid, trans->transid, 0, 0, 0);
+	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
+				      0, objectid, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
 		goto fail;
@@ -98,6 +98,9 @@ static noinline int create_subvol(struct
 	write_extent_buffer(leaf, root->fs_info->fsid,
 			    (unsigned long)btrfs_header_fsid(leaf),
 			    BTRFS_FSID_SIZE);
+	write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
+			    (unsigned long)btrfs_header_chunk_tree_uuid(leaf),
+			    BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 
 	inode_item = &root_item.inode;
@@ -125,7 +128,7 @@ static noinline int create_subvol(struct
 	btrfs_set_root_dirid(&root_item, new_dirid);
 
 	key.objectid = objectid;
-	key.offset = 1;
+	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 	ret = btrfs_insert_root(trans, root->fs_info->tree_root, &key,
 				&root_item);
@@ -940,10 +943,10 @@ static long btrfs_ioctl_clone(struct fil
 				if (disko) {
 					inode_add_bytes(inode, datal);
 					ret = btrfs_inc_extent_ref(trans, root,
-						   disko, diskl, leaf->start,
-						   root->root_key.objectid,
-						   trans->transid,
-						   inode->i_ino);
+							disko, diskl, 0,
+							root->root_key.objectid,
+							inode->i_ino,
+							new_key.offset - datao);
 					BUG_ON(ret);
 				}
 			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
diff -urp 4/fs/btrfs/print-tree.c 5/fs/btrfs/print-tree.c
--- 4/fs/btrfs/print-tree.c	2009-05-11 16:38:07.000000000 +0800
+++ 5/fs/btrfs/print-tree.c	2009-05-11 16:16:11.000000000 +0800
@@ -45,9 +45,30 @@ static void print_dev_item(struct extent
 	       (unsigned long long)btrfs_device_total_bytes(eb, dev_item),
 	       (unsigned long long)btrfs_device_bytes_used(eb, dev_item));
 }
+static void print_extent_data_ref(struct extent_buffer *eb,
+				  struct btrfs_extent_data_ref *ref)
+{
+	printk(KERN_INFO "\t\textent data backref root %llu "
+	       "objectid %llu offset %llu count %u\n",
+	       (unsigned long long)btrfs_extent_data_ref_root(eb, ref),
+	       (unsigned long long)btrfs_extent_data_ref_objectid(eb, ref),
+	       (unsigned long long)btrfs_extent_data_ref_offset(eb, ref),
+	       btrfs_extent_data_ref_count(eb, ref));
+}
+
+static void print_extent_item(struct extent_buffer *eb,
+			      struct btrfs_extent_item *ei)
+{
+	printk(KERN_INFO "\t\textent data refs %llu gen %llu flags %llu\n",
+	       (unsigned long long)btrfs_extent_refs(eb, ei),
+	       (unsigned long long)btrfs_extent_generation(eb, ei),
+	       (unsigned long long)btrfs_extent_flags(eb, ei));
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
+	u32 type;
 	u32 nr = btrfs_header_nritems(l);
 	struct btrfs_item *item;
 	struct btrfs_extent_item *ei;
@@ -56,11 +77,11 @@ void btrfs_print_leaf(struct btrfs_root 
 	struct btrfs_inode_item *ii;
 	struct btrfs_block_group_item *bi;
 	struct btrfs_file_extent_item *fi;
+	struct btrfs_extent_data_ref *dref;
+	struct btrfs_shared_data_ref *sref;
+	struct btrfs_dev_extent *dev_extent;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	struct btrfs_extent_ref *ref;
-	struct btrfs_dev_extent *dev_extent;
-	u32 type;
 
 	printk(KERN_INFO "leaf %llu total ptrs %d free space %d\n",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
@@ -101,19 +122,28 @@ void btrfs_print_leaf(struct btrfs_root 
 			break;
 		case BTRFS_EXTENT_ITEM_KEY:
 			ei = btrfs_item_ptr(l, i, struct btrfs_extent_item);
-			printk(KERN_INFO "\t\textent data refs %u\n",
-				btrfs_extent_refs(l, ei));
+			print_extent_item(l, ei);
 			break;
-		case BTRFS_EXTENT_REF_KEY:
-			ref = btrfs_item_ptr(l, i, struct btrfs_extent_ref);
-			printk(KERN_INFO "\t\textent back ref root %llu "
-			       "gen %llu owner %llu num_refs %lu\n",
-			       (unsigned long long)btrfs_ref_root(l, ref),
-			       (unsigned long long)btrfs_ref_generation(l, ref),
-			       (unsigned long long)btrfs_ref_objectid(l, ref),
-			       (unsigned long)btrfs_ref_num_refs(l, ref));
+		case BTRFS_TREE_BLOCK_INFO_KEY:
+			printk(KERN_INFO "\t\ttree block info\n");
+			break;
+		case BTRFS_TREE_BLOCK_REF_KEY:
+			printk(KERN_INFO "\t\ttree block backref\n");
+			break;
+		case BTRFS_SHARED_BLOCK_REF_KEY:
+			printk(KERN_INFO "\t\tshared block backref\n");
+			break;
+		case BTRFS_EXTENT_DATA_REF_KEY:
+			dref = btrfs_item_ptr(l, i,
+					      struct btrfs_extent_data_ref);
+			print_extent_data_ref(l, dref);
+			break;
+		case BTRFS_SHARED_DATA_REF_KEY:
+			sref = btrfs_item_ptr(l, i,
+					      struct btrfs_shared_data_ref);
+			printk(KERN_INFO "\t\tshared data backref count %u\n",
+			       btrfs_shared_data_ref_count(l, sref));
 			break;
-
 		case BTRFS_EXTENT_DATA_KEY:
 			fi = btrfs_item_ptr(l, i,
 					    struct btrfs_file_extent_item);
diff -urp 4/fs/btrfs/tree-log.c 5/fs/btrfs/tree-log.c
--- 4/fs/btrfs/tree-log.c	2009-05-11 16:38:07.000000000 +0800
+++ 5/fs/btrfs/tree-log.c	2009-05-11 16:16:11.000000000 +0800
@@ -430,18 +430,16 @@ no_copy:
 static noinline struct inode *read_one_inode(struct btrfs_root *root,
 					     u64 objectid)
 {
+	struct btrfs_key key;
 	struct inode *inode;
-	inode = btrfs_iget_locked(root->fs_info->sb, objectid, root);
-	if (inode->i_state & I_NEW) {
-		BTRFS_I(inode)->root = root;
-		BTRFS_I(inode)->location.objectid = objectid;
-		BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
-		BTRFS_I(inode)->location.offset = 0;
-		btrfs_read_locked_inode(inode);
-		unlock_new_inode(inode);
 
-	}
-	if (is_bad_inode(inode)) {
+	key.objectid = objectid;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	inode = btrfs_iget(root->fs_info->sb, &key, root);
+	if (IS_ERR(inode)) {
+		inode = NULL;
+	} else if (is_bad_inode(inode)) {
 		iput(inode);
 		inode = NULL;
 	}
@@ -541,6 +539,7 @@ static noinline int replay_one_extent(st
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		u64 offset;
 		unsigned long dest_offset;
 		struct btrfs_key ins;
 
@@ -555,6 +554,8 @@ static noinline int replay_one_extent(st
 		ins.objectid = btrfs_file_extent_disk_bytenr(eb, item);
 		ins.offset = btrfs_file_extent_disk_num_bytes(eb, item);
 		ins.type = BTRFS_EXTENT_ITEM_KEY;
+		offset = key->offset - btrfs_file_extent_offset(eb, item);
+
 
 		if (ins.objectid > 0) {
 			u64 csum_start;
@@ -569,19 +570,16 @@ static noinline int replay_one_extent(st
 			if (ret == 0) {
 				ret = btrfs_inc_extent_ref(trans, root,
 						ins.objectid, ins.offset,
-						path->nodes[0]->start,
-						root->root_key.objectid,
-						trans->transid, key->objectid);
+						0, root->root_key.objectid,
+						key->objectid, offset);
 			} else {
 				/*
 				 * insert the extent pointer in the extent
 				 * allocation tree
 				 */
-				ret = btrfs_alloc_logged_extent(trans, root,
-						path->nodes[0]->start,
-						root->root_key.objectid,
-						trans->transid, key->objectid,
-						&ins);
+				ret = btrfs_alloc_logged_file_extent(trans,
+						root, root->root_key.objectid,
+						key->objectid, offset, &ins);
 				BUG_ON(ret);
 			}
 			btrfs_release_path(root, path);
@@ -2027,9 +2025,7 @@ int btrfs_sync_log(struct btrfs_trans_ha
 	ret = btrfs_write_and_wait_marked_extents(log, &log->dirty_log_pages);
 	BUG_ON(ret);
 
-	btrfs_set_root_bytenr(&log->root_item, log->node->start);
-	btrfs_set_root_generation(&log->root_item, trans->transid);
-	btrfs_set_root_level(&log->root_item, btrfs_header_level(log->node));
+	btrfs_set_root_node(&log->root_item, log->node);
 
 	root->log_batch = 0;
 	root->log_transid++;
@@ -2581,7 +2577,7 @@ static noinline int copy_items(struct bt
 				       ins_keys, ins_sizes, nr);
 	BUG_ON(ret);
 
-	for (i = 0; i < nr; i++) {
+	for (i = 0; i < nr; i++, dst_path->slots[0]++) {
 		dst_offset = btrfs_item_ptr_offset(dst_path->nodes[0],
 						   dst_path->slots[0]);
 
@@ -2617,36 +2613,37 @@ static noinline int copy_items(struct bt
 			found_type = btrfs_file_extent_type(src, extent);
 			if (found_type == BTRFS_FILE_EXTENT_REG ||
 			    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
-				u64 ds = btrfs_file_extent_disk_bytenr(src,
-								   extent);
-				u64 dl = btrfs_file_extent_disk_num_bytes(src,
-								      extent);
-				u64 cs = btrfs_file_extent_offset(src, extent);
-				u64 cl = btrfs_file_extent_num_bytes(src,
-								     extent);;
+				u64 ds, dl, cs, cl;
+				ds = btrfs_file_extent_disk_bytenr(src,
+								extent);
+				/* ds == 0 is a hole */
+				if (ds == 0)
+					continue;
+
+				dl = btrfs_file_extent_disk_num_bytes(src,
+								extent);
+				cs = btrfs_file_extent_offset(src, extent);
+				cl = btrfs_file_extent_num_bytes(src,
+								extent);;
+				ret = btrfs_inc_extent_ref(trans, log, ds, dl,
+						0, BTRFS_TREE_LOG_OBJECTID,
+						ins_keys[i].objectid,
+						ins_keys[i].offset - cs);
+				BUG_ON(ret);
+
 				if (btrfs_file_extent_compression(src,
 								  extent)) {
 					cs = 0;
 					cl = dl;
 				}
-				/* ds == 0 is a hole */
-				if (ds != 0) {
-					ret = btrfs_inc_extent_ref(trans, log,
-						   ds, dl,
-						   dst_path->nodes[0]->start,
-						   BTRFS_TREE_LOG_OBJECTID,
-						   trans->transid,
-						   ins_keys[i].objectid);
-					BUG_ON(ret);
-					ret = btrfs_lookup_csums_range(
-						   log->fs_info->csum_root,
-						   ds + cs, ds + cs + cl - 1,
-						   &ordered_sums);
-					BUG_ON(ret);
-				}
+
+				ret = btrfs_lookup_csums_range(
+						log->fs_info->csum_root,
+						ds + cs, ds + cs + cl - 1,
+						&ordered_sums);
+				BUG_ON(ret);
 			}
 		}
-		dst_path->slots[0]++;
 	}
 
 	btrfs_mark_buffer_dirty(dst_path->nodes[0]);


