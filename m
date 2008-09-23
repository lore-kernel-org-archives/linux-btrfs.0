From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH] Full back reference support
Date: Tue, 23 Sep 2008 23:19:51 +0800
Message-ID: <48D90917.3080302@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

This patch makes the back reference system to explicit record the
location of parent node for all types of extents. The location of
parent node is placed into the offset field of backref key. Every
time a tree block is balanced, the back references for the affected
lower level extents are updated.

Regards
Yan Zheng

---
diff -r 3bdaaf032a52 ctree.c
--- a/ctree.c	Tue Sep 23 09:00:03 2008 +0800
+++ b/ctree.c	Tue Sep 23 22:28:59 2008 +0800
@@ -125,7 +125,6 @@
 	u32 nritems;
 	int ret = 0;
 	int level;
-	struct btrfs_key first_key;
 	struct btrfs_root *new_root;
 
 	new_root = kmalloc(sizeof(*new_root), GFP_NOFS);
@@ -141,18 +140,10 @@
 
 	level = btrfs_header_level(buf);
 	nritems = btrfs_header_nritems(buf);
-	if (nritems) {
-		if (level == 0)
-			btrfs_item_key_to_cpu(buf, &first_key, 0);
-		else
-			btrfs_node_key_to_cpu(buf, &first_key, 0);
-	} else {
-		first_key.objectid = 0;
-	}
-	cow = btrfs_alloc_free_block(trans, new_root, buf->len,
-				       new_root_objectid,
-				       trans->transid, first_key.objectid,
-				       level, buf->start, 0);
+
+	cow = btrfs_alloc_free_block(trans, new_root, buf->len, 0,
+				     new_root_objectid, trans->transid,
+				     level, buf->start, 0);
 	if (IS_ERR(cow)) {
 		kfree(new_root);
 		return PTR_ERR(cow);
@@ -165,7 +156,7 @@
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
-	ret = btrfs_inc_ref(trans, new_root, buf, 0);
+	ret = btrfs_inc_ref(trans, new_root, buf, cow, NULL);
 	kfree(new_root);
 
 	if (ret)
@@ -184,39 +175,31 @@
 			     u64 search_start, u64 empty_size,
 			     u64 prealloc_dest)
 {
-	u64 root_gen;
+	u64 parent_start;
 	struct extent_buffer *cow;
 	u32 nritems;
 	int ret = 0;
 	int different_trans = 0;
 	int level;
 	int unlock_orig = 0;
-	struct btrfs_key first_key;
 
 	if (*cow_ret == buf)
 		unlock_orig = 1;
 
 	WARN_ON(!btrfs_tree_locked(buf));
 
-	if (root->ref_cows) {
-		root_gen = trans->transid;
-	} else {
-		root_gen = 0;
-	}
+	if (parent)
+		parent_start = parent->start;
+	else
+		parent_start = 0;
+
 	WARN_ON(root->ref_cows && trans->transid !=
 		root->fs_info->running_transaction->transid);
 	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
 
 	level = btrfs_header_level(buf);
 	nritems = btrfs_header_nritems(buf);
-	if (nritems) {
-		if (level == 0)
-			btrfs_item_key_to_cpu(buf, &first_key, 0);
-		else
-			btrfs_node_key_to_cpu(buf, &first_key, 0);
-	} else {
-		first_key.objectid = 0;
-	}
+
 	if (prealloc_dest) {
 		struct btrfs_key ins;
 
@@ -224,19 +207,19 @@
 		ins.offset = buf->len;
 		ins.type = BTRFS_EXTENT_ITEM_KEY;
 
-		ret = btrfs_alloc_reserved_extent(trans, root,
+		ret = btrfs_alloc_reserved_extent(trans, root, parent_start,
 						  root->root_key.objectid,
-						  root_gen, level,
-						  first_key.objectid,
+						  trans->transid, level, 0,
 						  &ins);
 		BUG_ON(ret);
 		cow = btrfs_init_new_buffer(trans, root, prealloc_dest,
 					    buf->len);
 	} else {
 		cow = btrfs_alloc_free_block(trans, root, buf->len,
+					     parent_start,
 					     root->root_key.objectid,
-					     root_gen, first_key.objectid,
-					     level, search_start, empty_size);
+					     trans->transid, level,
+					     search_start, empty_size);
 	}
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
@@ -249,17 +232,23 @@
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (btrfs_header_generation(buf) != trans->transid) {
+		u32 nr_extents;
 		different_trans = 1;
-		ret = btrfs_inc_ref(trans, root, buf, 1);
+		ret = btrfs_inc_ref(trans, root, buf, cow, &nr_extents);
 		if (ret)
 			return ret;
+
+		ret = btrfs_cache_ref(trans, root, buf, nr_extents);
+		WARN_ON(ret);
 	} else {
+		ret = btrfs_update_ref(trans, root, buf, cow, 0, nritems);
+		if (ret)
+			return ret;
 		clean_tree_block(trans, root, buf);
 	}
 
 	if (buf == root->node) {
 		WARN_ON(parent && parent != buf);
-		root_gen = btrfs_header_generation(buf);
 
 		spin_lock(&root->node_lock);
 		root->node = cow;
@@ -268,13 +257,14 @@
 
 		if (buf != root->commit_root) {
 			btrfs_free_extent(trans, root, buf->start,
-					  buf->len, root->root_key.objectid,
-					  root_gen, 0, 0, 1);
+					  buf->len, buf->start,
+					  root->root_key.objectid,
+					  btrfs_header_generation(buf),
+					  0, 0, 1);
 		}
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
 	} else {
-		root_gen = btrfs_header_generation(parent);
 		btrfs_set_node_blockptr(parent, parent_slot,
 					cow->start);
 		WARN_ON(trans->transid == 0);
@@ -283,8 +273,8 @@
 		btrfs_mark_buffer_dirty(parent);
 		WARN_ON(btrfs_header_generation(parent) != trans->transid);
 		btrfs_free_extent(trans, root, buf->start, buf->len,
-				  btrfs_header_owner(parent), root_gen,
-				  0, 0, 1);
+				  parent_start, btrfs_header_owner(parent),
+				  btrfs_header_generation(parent), 0, 0, 1);
 	}
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
@@ -831,6 +821,12 @@
 		root->node = child;
 		spin_unlock(&root->node_lock);
 
+		ret = btrfs_update_extent_ref(trans, root, child->start,
+					      mid->start, child->start,
+					      root->root_key.objectid,
+					      trans->transid, level - 1, 0);
+		BUG_ON(ret);
+
 		add_root_to_dirty_list(root);
 		btrfs_tree_unlock(child);
 		path->locks[level] = 0;
@@ -840,7 +836,7 @@
 		/* once for the path */
 		free_extent_buffer(mid);
 		ret = btrfs_free_extent(trans, root, mid->start, mid->len,
-					root->root_key.objectid,
+					mid->start, root->root_key.objectid,
 					btrfs_header_generation(mid), 0, 0, 1);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
@@ -905,7 +901,7 @@
 			if (wret)
 				ret = wret;
 			wret = btrfs_free_extent(trans, root, bytenr,
-						 blocksize,
+						 blocksize, parent->start,
 						 btrfs_header_owner(parent),
 						 generation, 0, 0, 1);
 			if (wret)
@@ -954,6 +950,7 @@
 		if (wret)
 			ret = wret;
 		wret = btrfs_free_extent(trans, root, bytenr, blocksize,
+					 parent->start,
 					 btrfs_header_owner(parent),
 					 root_gen, 0, 0, 1);
 		if (wret)
@@ -1500,6 +1497,41 @@
 }
 
 /*
+ * update item key.
+ *
+ * This function isn't completely safe. It's the caller's responsibility
+ * that the new key won't break the order
+ */
+int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *new_key)
+{
+	struct btrfs_disk_key disk_key;
+	struct extent_buffer *eb;
+	int slot;
+
+	eb = path->nodes[0];
+	slot = path->slots[0];
+	if (slot > 0) {
+		btrfs_item_key(eb, &disk_key, slot - 1);
+		if (comp_keys(&disk_key, new_key) >= 0)
+			return -1;
+	}
+	if (slot < btrfs_header_nritems(eb) - 1) {
+		btrfs_item_key(eb, &disk_key, slot + 1);
+		if (comp_keys(&disk_key, new_key) <= 0)
+			return -1;
+	}
+
+	btrfs_cpu_key_to_disk(&disk_key, new_key);
+	btrfs_set_item_key(eb, &disk_key, slot);
+	btrfs_mark_buffer_dirty(eb);
+	if (slot == 0)
+		fixup_low_keys(trans, root, path, &disk_key, 1);
+	return 0;
+}
+
+/*
  * try to push data from one node into the next node left in the
  * tree.
  *
@@ -1558,6 +1590,10 @@
 	btrfs_set_header_nritems(dst, dst_nritems + push_items);
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
+
+	ret = btrfs_update_ref(trans, root, src, dst, dst_nritems, push_items);
+	BUG_ON(ret);
+
 	return ret;
 }
 
@@ -1619,6 +1655,10 @@
 
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
+
+	ret = btrfs_update_ref(trans, root, src, dst, 0, push_items);
+	BUG_ON(ret);
+
 	return ret;
 }
 
@@ -1633,20 +1673,15 @@
 			   struct btrfs_root *root,
 			   struct btrfs_path *path, int level)
 {
-	u64 root_gen;
 	u64 lower_gen;
 	struct extent_buffer *lower;
 	struct extent_buffer *c;
 	struct extent_buffer *old;
 	struct btrfs_disk_key lower_key;
+	int ret;
 
 	BUG_ON(path->nodes[level]);
 	BUG_ON(path->nodes[level-1] != root->node);
-
-	if (root->ref_cows)
-		root_gen = trans->transid;
-	else
-		root_gen = 0;
 
 	lower = path->nodes[level-1];
 	if (level == 1)
@@ -1654,9 +1689,8 @@
 	else
 		btrfs_node_key(lower, &lower_key, 0);
 
-	c = btrfs_alloc_free_block(trans, root, root->nodesize,
-				   root->root_key.objectid,
-				   root_gen, le64_to_cpu(lower_key.objectid),
+	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
+				   root->root_key.objectid, trans->transid,
 				   level, root->node->start, 0);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
@@ -1679,7 +1713,7 @@
 	btrfs_set_node_key(c, &lower_key, 0);
 	btrfs_set_node_blockptr(c, 0, lower->start);
 	lower_gen = btrfs_header_generation(lower);
-	WARN_ON(lower_gen == 0);
+	WARN_ON(lower_gen != trans->transid);
 
 	btrfs_set_node_ptr_generation(c, 0, lower_gen);
 
@@ -1690,6 +1724,12 @@
 	root->node = c;
 	spin_unlock(&root->node_lock);
 
+	ret = btrfs_update_extent_ref(trans, root, lower->start,
+				      lower->start, c->start,
+				      root->root_key.objectid,
+				      trans->transid, level - 1, 0);
+	BUG_ON(ret);
+
 	/* the super has an extra ref to root->node */
 	free_extent_buffer(old);
 
@@ -1698,20 +1738,6 @@
 	path->nodes[level] = c;
 	path->locks[level] = 1;
 	path->slots[level] = 0;
-
-	if (root->ref_cows && lower_gen != trans->transid) {
-		struct btrfs_path *back_path = btrfs_alloc_path();
-		int ret;
-		mutex_lock(&root->fs_info->alloc_mutex);
-		ret = btrfs_insert_extent_backref(trans,
-						  root->fs_info->extent_root,
-						  path, lower->start,
-						  root->root_key.objectid,
-						  trans->transid, 0, 0);
-		BUG_ON(ret);
-		mutex_unlock(&root->fs_info->alloc_mutex);
-		btrfs_free_path(back_path);
-	}
 	return 0;
 }
 
@@ -1766,7 +1792,6 @@
 			       struct btrfs_root *root,
 			       struct btrfs_path *path, int level)
 {
-	u64 root_gen;
 	struct extent_buffer *c;
 	struct extent_buffer *split;
 	struct btrfs_disk_key disk_key;
@@ -1793,17 +1818,11 @@
 	}
 
 	c_nritems = btrfs_header_nritems(c);
-	if (root->ref_cows)
-		root_gen = trans->transid;
-	else
-		root_gen = 0;
 
-	btrfs_node_key(c, &disk_key, 0);
 	split = btrfs_alloc_free_block(trans, root, root->nodesize,
-					 root->root_key.objectid,
-					 root_gen,
-					 btrfs_disk_key_objectid(&disk_key),
-					 level, c->start, 0);
+					path->nodes[level + 1]->start,
+					root->root_key.objectid,
+					trans->transid, level, c->start, 0);
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
@@ -1839,6 +1858,9 @@
 			  level + 1);
 	if (wret)
 		ret = wret;
+
+	ret = btrfs_update_ref(trans, root, c, split, 0, c_nritems - mid);
+	BUG_ON(ret);
 
 	if (path->slots[level] >= mid) {
 		path->slots[level] -= mid;
@@ -1955,9 +1977,22 @@
 	else
 		nr = 1;
 
+	if (path->slots[0] >= left_nritems)
+		push_space += data_size + sizeof(*item);
+
 	i = left_nritems - 1;
 	while (i >= nr) {
 		item = btrfs_item_nr(left, i);
+
+		if (!empty && push_items > 0) {
+			if (path->slots[0] > i)
+				break;
+			if (path->slots[0] == i) {
+				int space = btrfs_leaf_free_space(root, left);
+				if (space + push_space * 2 > free_space)
+					break;
+			}
+		}
 
 		if (path->slots[0] == i)
 			push_space += data_size + sizeof(*item);
@@ -1973,6 +2008,7 @@
 		this_item_size = btrfs_item_size(left, item);
 		if (this_item_size + sizeof(*item) + push_space > free_space)
 			break;
+
 		push_items++;
 		push_space += this_item_size + sizeof(*item);
 		if (i == 0)
@@ -2045,6 +2081,9 @@
 	if (left_nritems)
 		btrfs_mark_buffer_dirty(left);
 	btrfs_mark_buffer_dirty(right);
+
+	ret = btrfs_update_ref(trans, root, left, right, 0, push_items);
+	BUG_ON(ret);
 
 	btrfs_item_key(right, &disk_key, 0);
 	btrfs_set_node_key(upper, &disk_key, slot + 1);
@@ -2145,6 +2184,16 @@
 					&right->map_token, &right->kaddr,
 					&right->map_start, &right->map_len,
 					KM_USER1);
+		}
+
+		if (!empty && push_items > 0) {
+			if (path->slots[0] < i)
+				break;
+			if (path->slots[0] == i) {
+				int space = btrfs_leaf_free_space(root, right);
+				if (space + push_space * 2 > free_space)
+					break;
+			}
 		}
 
 		if (path->slots[0] == i)
@@ -2255,6 +2304,10 @@
 	if (right_nritems)
 		btrfs_mark_buffer_dirty(right);
 
+	ret = btrfs_update_ref(trans, root, right, left,
+			       old_left_nritems, push_items);
+	BUG_ON(ret);
+
 	btrfs_item_key(right, &disk_key, 0);
 	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
 	if (wret)
@@ -2294,7 +2347,6 @@
 			       struct btrfs_path *path, int data_size,
 			       int extend)
 {
-	u64 root_gen;
 	struct extent_buffer *l;
 	u32 nritems;
 	int mid;
@@ -2312,11 +2364,6 @@
 
 	if (extend)
 		space_needed = data_size;
-
-	if (root->ref_cows)
-		root_gen = trans->transid;
-	else
-		root_gen = 0;
 
 	/* first try to make some room by pushing left and right */
 	if (ins_key->type != BTRFS_DIR_ITEM_KEY) {
@@ -2348,13 +2395,10 @@
 	nritems = btrfs_header_nritems(l);
 	mid = (nritems + 1)/ 2;
 
-	btrfs_item_key(l, &disk_key, 0);
-
 	right = btrfs_alloc_free_block(trans, root, root->leafsize,
-					 root->root_key.objectid,
-					 root_gen,
-					 le64_to_cpu(disk_key.objectid),
-					 0, l->start, 0);
+					path->nodes[1]->start,
+					root->root_key.objectid,
+					trans->transid, 0, l->start, 0);
 	if (IS_ERR(right)) {
 		BUG_ON(1);
 		return PTR_ERR(right);
@@ -2484,6 +2528,9 @@
 	btrfs_mark_buffer_dirty(right);
 	btrfs_mark_buffer_dirty(l);
 	BUG_ON(path->slots[0] != slot);
+
+	ret = btrfs_update_ref(trans, root, l, right, 0, nritems);
+	BUG_ON(ret);
 
 	if (mid <= slot) {
 		btrfs_tree_unlock(path->nodes[0]);
@@ -2956,6 +3003,7 @@
 				ret = wret;
 			wret = btrfs_free_extent(trans, root,
 					 leaf->start, leaf->len,
+					 path->nodes[1]->start,
 					 btrfs_header_owner(path->nodes[1]),
 					 root_gen, 0, 0, 1);
 			if (wret)
@@ -3007,7 +3055,7 @@
 
 				free_extent_buffer(leaf);
 				wret = btrfs_free_extent(trans, root, bytenr,
-					     blocksize,
+					     blocksize, path->nodes[1]->start,
 					     btrfs_header_owner(path->nodes[1]),
 					     root_gen, 0, 0, 1);
 				if (wret)
diff -r 3bdaaf032a52 ctree.h
--- a/ctree.h	Tue Sep 23 09:00:03 2008 +0800
+++ b/ctree.h	Tue Sep 23 22:28:59 2008 +0800
@@ -80,6 +80,9 @@
 /* does write ahead logging to speed up fsyncs */
 #define BTRFS_TREE_LOG_OBJECTID -6ULL
 #define BTRFS_TREE_LOG_FIXUP_OBJECTID -7ULL
+
+/* dummy objectid represents multiple objectids */
+#define BTRFS_MULTIPLE_OBJECTIDS -255ULL
 
 /*
  * All files have objectids in this range.
@@ -369,6 +372,7 @@
 	__le64 generation;
 	__le64 objectid;
 	__le64 offset;
+	__le32 num_refs;
 } __attribute__ ((__packed__));
 
 /* dev extents record free space on individual devices.  The owner
@@ -1047,9 +1051,6 @@
 BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
 BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
 
-/* struct btrfs_extent_item */
-BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 32);
-
 /* struct btrfs_dev_extent */
 BTRFS_SETGET_FUNCS(dev_extent_chunk_tree, struct btrfs_dev_extent,
 		   chunk_tree, 64);
@@ -1070,14 +1071,20 @@
 BTRFS_SETGET_FUNCS(ref_generation, struct btrfs_extent_ref, generation, 64);
 BTRFS_SETGET_FUNCS(ref_objectid, struct btrfs_extent_ref, objectid, 64);
 BTRFS_SETGET_FUNCS(ref_offset, struct btrfs_extent_ref, offset, 64);
+BTRFS_SETGET_FUNCS(ref_num_refs, struct btrfs_extent_ref, num_refs, 32);
 
 BTRFS_SETGET_STACK_FUNCS(stack_ref_root, struct btrfs_extent_ref, root, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_ref_generation, struct btrfs_extent_ref,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_ref_objectid, struct btrfs_extent_ref,
 			 objectid, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_offset, struct btrfs_extent_ref, offset, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_ref_offset, struct btrfs_extent_ref,
+			 offset, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_ref_num_refs, struct btrfs_extent_ref,
+			 num_refs, 32);
 
+/* struct btrfs_extent_item */
+BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_extent_refs, struct btrfs_extent_item,
 			 refs, 32);
 
@@ -1474,8 +1481,7 @@
 }
 
 /* extent-tree.c */
-int btrfs_lookup_extent(struct btrfs_root *root, struct btrfs_path *path,
-			u64 start, u64 len);
+int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_update_pinned_extents(struct btrfs_root *root,
 				u64 bytenr, u64 num, int pin);
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
@@ -1495,10 +1501,9 @@
 						 int data, int owner);
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
-					     u32 blocksize,
+					     u32 blocksize, u64 parent,
 					     u64 root_objectid,
 					     u64 ref_generation,
-					     u64 first_objectid,
 					     int level,
 					     u64 hint,
 					     u64 empty_size);
@@ -1508,23 +1513,24 @@
 int btrfs_shrink_extent_tree(struct btrfs_root *root, u64 new_size);
 int btrfs_insert_extent_backref(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
-				 struct btrfs_path *path, u64 bytenr,
+				 struct btrfs_path *path,
+				 u64 bytenr, u64 parent,
 				 u64 root_objectid, u64 ref_generation,
 				 u64 owner, u64 owner_offset);
 int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
-		       u64 num_bytes, u64 min_bytes,
+		       u64 num_bytes, u64 parent, u64 min_bytes,
 		       u64 root_objectid, u64 ref_generation,
 		       u64 owner, u64 owner_offset,
 		       u64 empty_size, u64 hint_byte,
 		       u64 search_end, struct btrfs_key *ins, u64 data);
 int btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
+				struct btrfs_root *root, u64 parent,
 				u64 root_objectid, u64 ref_generation,
 				u64 owner, u64 owner_offset,
 				struct btrfs_key *ins);
 int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
+				struct btrfs_root *root, u64 parent,
 				u64 root_objectid, u64 ref_generation,
 				u64 owner, u64 owner_offset,
 				struct btrfs_key *ins);
@@ -1535,9 +1541,16 @@
 				  u64 search_end, struct btrfs_key *ins,
 				  u64 data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int cache_ref);
-int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, u64 bytenr, u64 num_bytes,
+		  struct extent_buffer *orig_buf, struct extent_buffer *buf,
+		  u32 *nr_extents);
+int btrfs_cache_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		    struct extent_buffer *buf, u32 nr_extents);
+int btrfs_update_ref(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root, struct extent_buffer *orig_buf,
+		     struct extent_buffer *buf, int start_slot, int nr);
+int btrfs_free_extent(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root,
+		      u64 bytenr, u64 num_bytes, u64 parent,
 		      u64 root_objectid, u64 ref_generation,
 		      u64 owner_objectid, u64 owner_offset, int pin);
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
@@ -1545,10 +1558,15 @@
 			       struct btrfs_root *root,
 			       struct extent_io_tree *unpin);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes,
-				u64 root_objectid, u64 ref_generation,
-				u64 owner, u64 owner_offset);
+			 struct btrfs_root *root,
+			 u64 bytenr, u64 num_bytes, u64 parent,
+			 u64 root_objectid, u64 ref_generation,
+			 u64 owner, u64 owner_offset);
+int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, u64 bytenr,
+			    u64 orig_parent, u64 parent,
+			    u64 root_objectid, u64 ref_generation,
+			    u64 owner, u64 owner_offset);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
@@ -1561,7 +1579,9 @@
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
-
+int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
 int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
diff -r 3bdaaf032a52 disk-io.c
--- a/disk-io.c	Tue Sep 23 09:00:03 2008 +0800
+++ b/disk-io.c	Tue Sep 23 22:28:59 2008 +0800
@@ -873,8 +873,8 @@
 	root->ref_cows = 0;
 
 	root->node = btrfs_alloc_free_block(trans, root, root->leafsize,
-					    BTRFS_TREE_LOG_OBJECTID,
-					    0, 0, 0, 0, 0);
+					    0, BTRFS_TREE_LOG_OBJECTID,
+					    trans->transid, 0, 0, 0);
 
 	btrfs_set_header_nritems(root->node, 0);
 	btrfs_set_header_level(root->node, 0);
diff -r 3bdaaf032a52 extent-tree.c
--- a/extent-tree.c	Tue Sep 23 09:00:03 2008 +0800
+++ b/extent-tree.c	Tue Sep 23 22:28:59 2008 +0800
@@ -29,6 +29,21 @@
 #include "locking.h"
 #include "ref-cache.h"
 
+#define PENDING_EXTENT_INSERT 0
+#define PENDING_EXTENT_DELETE 1
+#define PENDING_BACKREF_UPDATE 2
+
+struct pending_extent_op {
+	int type;
+	u64 bytenr;
+	u64 num_bytes;
+	u64 parent;
+	u64 orig_parent;
+	u64 generation;
+	u64 orig_generation;
+	int level;
+};
+
 static int finish_current_insert(struct btrfs_trans_handle *trans, struct
 				 btrfs_root *extent_root);
 static int del_pending_extents(struct btrfs_trans_handle *trans, struct
@@ -486,48 +501,15 @@
 	return ret;
 }
 
-static u64 hash_extent_ref(u64 root_objectid, u64 ref_generation,
-			   u64 owner, u64 owner_offset)
-{
-	u32 high_crc = ~(u32)0;
-	u32 low_crc = ~(u32)0;
-	__le64 lenum;
-	lenum = cpu_to_le64(root_objectid);
-	high_crc = btrfs_crc32c(high_crc, &lenum, sizeof(lenum));
-	lenum = cpu_to_le64(ref_generation);
-	low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
-	if (owner >= BTRFS_FIRST_FREE_OBJECTID) {
-		lenum = cpu_to_le64(owner);
-		low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
-		lenum = cpu_to_le64(owner_offset);
-		low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
-	}
-	return ((u64)high_crc << 32) | (u64)low_crc;
-}
-
-static int match_extent_ref(struct extent_buffer *leaf,
-			    struct btrfs_extent_ref *disk_ref,
-			    struct btrfs_extent_ref *cpu_ref)
-{
-	int ret;
-	int len;
-
-	if (cpu_ref->objectid)
-		len = sizeof(*cpu_ref);
-	else
-		len = 2 * sizeof(u64);
-	ret = memcmp_extent_buffer(leaf, cpu_ref, (unsigned long)disk_ref,
-				   len);
-	return ret == 0;
-}
-
 /* simple helper to search for an existing extent at a given offset */
-int btrfs_lookup_extent(struct btrfs_root *root, struct btrfs_path *path,
-			u64 start, u64 len)
-{
-	int ret;
-	struct btrfs_key key;
-
+int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
+{
+	int ret;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	maybe_lock_mutex(root);
 	key.objectid = start;
 	key.offset = len;
@@ -535,72 +517,7 @@
 	ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key, path,
 				0, 0);
 	maybe_unlock_mutex(root);
-	return ret;
-}
-
-static int noinline lookup_extent_backref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path, u64 bytenr,
-					  u64 root_objectid,
-					  u64 ref_generation, u64 owner,
-					  u64 owner_offset, int del)
-{
-	u64 hash;
-	struct btrfs_key key;
-	struct btrfs_key found_key;
-	struct btrfs_extent_ref ref;
-	struct extent_buffer *leaf;
-	struct btrfs_extent_ref *disk_ref;
-	int ret;
-	int ret2;
-
-	btrfs_set_stack_ref_root(&ref, root_objectid);
-	btrfs_set_stack_ref_generation(&ref, ref_generation);
-	btrfs_set_stack_ref_objectid(&ref, owner);
-	btrfs_set_stack_ref_offset(&ref, owner_offset);
-
-	hash = hash_extent_ref(root_objectid, ref_generation, owner,
-			       owner_offset);
-	key.offset = hash;
-	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_REF_KEY;
-
-	while (1) {
-		ret = btrfs_search_slot(trans, root, &key, path,
-					del ? -1 : 0, del);
-		if (ret < 0)
-			goto out;
-		leaf = path->nodes[0];
-		if (ret != 0) {
-			u32 nritems = btrfs_header_nritems(leaf);
-			if (path->slots[0] >= nritems) {
-				ret2 = btrfs_next_leaf(root, path);
-				if (ret2)
-					goto out;
-				leaf = path->nodes[0];
-			}
-			btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-			if (found_key.objectid != bytenr ||
-			    found_key.type != BTRFS_EXTENT_REF_KEY)
-				goto out;
-			key.offset = found_key.offset;
-			if (del) {
-				btrfs_release_path(root, path);
-				continue;
-			}
-		}
-		disk_ref = btrfs_item_ptr(path->nodes[0],
-					  path->slots[0],
-					  struct btrfs_extent_ref);
-		if (match_extent_ref(path->nodes[0], disk_ref, &ref)) {
-			ret = 0;
-			goto out;
-		}
-		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-		key.offset = found_key.offset + 1;
-		btrfs_release_path(root, path);
-	}
-out:
+	btrfs_free_path(path);
 	return ret;
 }
 
@@ -621,7 +538,7 @@
  * File extents can be referenced by:
  *
  * - multiple snapshots, subvolumes, or different generations in one subvol
- * - different files inside a single subvolume (in theory, not implemented yet)
+ * - different files inside a single subvolume
  * - different offsets inside a file (bookend extents in file.c)
  *
  * The extent ref structure has fields for:
@@ -630,119 +547,284 @@
  * - Generation number of the tree holding the reference
  * - objectid of the file holding the reference
  * - offset in the file corresponding to the key holding the reference
+ * - number of references holding by parent node (alway 1 for tree blocks)
+ *
+ * Btree leaf may hold multiple references to a file extent. In most cases,
+ * these references are from same file and the corresponding offsets inside
+ * the file are close together. So inode objectid and offset in file are
+ * just hints, they provide hints about where in the btree the references
+ * can be found and when we can stop searching.
  *
  * When a file extent is allocated the fields are filled in:
- *     (root_key.objectid, trans->transid, inode objectid, offset in file)
+ *     (root_key.objectid, trans->transid, inode objectid, offset in file, 1)
  *
  * When a leaf is cow'd new references are added for every file extent found
- * in the leaf.  It looks the same as the create case, but trans->transid
- * will be different when the block is cow'd.
- *
- *     (root_key.objectid, trans->transid, inode objectid, offset in file)
- *
- * When a file extent is removed either during snapshot deletion or file
- * truncation, the corresponding back reference is found
- * by searching for:
- *
- *     (btrfs_header_owner(leaf), btrfs_header_generation(leaf),
- *      inode objectid, offset in file)
+ * in the leaf.  It looks similar to the create case, but trans->transid will
+ * be different when the block is cow'd.
+ *
+ *     (root_key.objectid, trans->transid, inode objectid, offset in file,
+ *      number of references in the leaf)
+ *
+ * Because inode objectid and offset in file are just hints, they are not
+ * used when backrefs are deleted. When a file extent is removed either
+ * during snapshot deletion or file truncation, we find the corresponding
+ * back back reference and check the following fields.
+ *
+ *     (btrfs_header_owner(leaf), btrfs_header_generation(leaf))
  *
  * Btree extents can be referenced by:
  *
  * - Different subvolumes
  * - Different generations of the same subvolume
  *
- * Storing sufficient information for a full reverse mapping of a btree
- * block would require storing the lowest key of the block in the backref,
- * and it would require updating that lowest key either before write out or
- * every time it changed.  Instead, the objectid of the lowest key is stored
- * along with the level of the tree block.  This provides a hint
- * about where in the btree the block can be found.  Searches through the
- * btree only need to look for a pointer to that block, so they stop one
- * level higher than the level recorded in the backref.
- *
- * Some btrees do not do reference counting on their extents.  These
- * include the extent tree and the tree of tree roots.  Backrefs for these
- * trees always have a generation of zero.
- *
  * When a tree block is created, back references are inserted:
  *
- * (root->root_key.objectid, trans->transid or zero, level, lowest_key_objectid)
- *
- * When a tree block is cow'd in a reference counted root,
- * new back references are added for all the blocks it points to.
- * These are of the form (trans->transid will have increased since creation):
- *
- * (root->root_key.objectid, trans->transid, level, lowest_key_objectid)
- *
- * Because the lowest_key_objectid and the level are just hints
- * they are not used when backrefs are deleted.  When a backref is deleted:
+ * (root->root_key.objectid, trans->transid, level, 0, 1)
+ *
+ * When a tree block is cow'd, new back references are added for all the
+ * blocks it points to. If the tree block isn't in reference counted root,
+ * the old back references are removed. These new back references are of
+ * the form (trans->transid will have increased since creation):
+ *
+ * (root->root_key.objectid, trans->transid, level, 0, 1)
+ *
+ * When a backref is in deleting, the following fields are checked:
  *
  * if backref was for a tree root:
- *     root_objectid = root->root_key.objectid
+ *     (btrfs_header_owner(itself), btrfs_header_generation(itself))
  * else
- *     root_objectid = btrfs_header_owner(parent)
- *
- * (root_objectid, btrfs_header_generation(parent) or zero, 0, 0)
- *
- * Back Reference Key hashing:
- *
- * Back references have four fields, each 64 bits long.  Unfortunately,
- * This is hashed into a single 64 bit number and placed into the key offset.
- * The key objectid corresponds to the first byte in the extent, and the
- * key type is set to BTRFS_EXTENT_REF_KEY
- */
-int btrfs_insert_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
-				 struct btrfs_path *path, u64 bytenr,
-				 u64 root_objectid, u64 ref_generation,
-				 u64 owner, u64 owner_offset)
-{
-	u64 hash;
-	struct btrfs_key key;
-	struct btrfs_extent_ref ref;
-	struct btrfs_extent_ref *disk_ref;
-	int ret;
-
-	btrfs_set_stack_ref_root(&ref, root_objectid);
-	btrfs_set_stack_ref_generation(&ref, ref_generation);
-	btrfs_set_stack_ref_objectid(&ref, owner);
-	btrfs_set_stack_ref_offset(&ref, owner_offset);
-
-	hash = hash_extent_ref(root_objectid, ref_generation, owner,
-			       owner_offset);
-	key.offset = hash;
+ *     (btrfs_header_owner(parent), btrfs_header_generation(parent))
+ *
+ * Back Reference Key composing:
+ *
+ * The key objectid corresponds to the first byte in the extent, the key
+ * type is set to BTRFS_EXTENT_REF_KEY, and the key offset is the first
+ * byte of parent extent. If a extent is tree root, the key offset is set
+ * to the key objectid.
+ */
+
+static int noinline lookup_extent_backref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path, u64 bytenr,
+					  u64 parent, u64 ref_root,
+					  u64 ref_generation, int del)
+{
+	struct btrfs_key key;
+	struct btrfs_extent_ref *ref;
+	struct extent_buffer *leaf;
+	int ret;
+
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_REF_KEY;
-
-	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(ref));
-	while (ret == -EEXIST) {
-		disk_ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
-					  struct btrfs_extent_ref);
-		if (match_extent_ref(path->nodes[0], disk_ref, &ref))
-			goto out;
-		key.offset++;
-		btrfs_release_path(root, path);
-		ret = btrfs_insert_empty_item(trans, root, path, &key,
-					      sizeof(ref));
-	}
-	if (ret)
-		goto out;
-	disk_ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				  struct btrfs_extent_ref);
-	write_extent_buffer(path->nodes[0], &ref, (unsigned long)disk_ref,
-			    sizeof(ref));
+	key.offset = parent;
+
+	ret = btrfs_search_slot(trans, root, &key, path, del ? -1 : 0, 1);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
+	if (btrfs_ref_root(leaf, ref) != ref_root ||
+	    btrfs_ref_generation(leaf, ref) != ref_generation) {
+		ret = -EIO;
+		WARN_ON(1);
+		goto out;
+	}
+	ret = 0;
+out:
+	return ret;
+}
+
+static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path,
+					  u64 bytenr, u64 parent,
+					  u64 ref_root, u64 ref_generation,
+					  u64 owner_objectid, u64 owner_offset)
+{
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct btrfs_extent_ref *ref;
+	u32 num_refs;
+	int ret;
+
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_REF_KEY;
+	key.offset = parent;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(*ref));
+	if (ret == 0) {
+		leaf = path->nodes[0];
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_ref);
+		btrfs_set_ref_root(leaf, ref, ref_root);
+		btrfs_set_ref_generation(leaf, ref, ref_generation);
+		btrfs_set_ref_objectid(leaf, ref, owner_objectid);
+		btrfs_set_ref_offset(leaf, ref, owner_offset);
+		btrfs_set_ref_num_refs(leaf, ref, 1);
+	} else if (ret == -EEXIST) {
+		u64 existing_owner;
+		BUG_ON(owner_objectid < BTRFS_FIRST_FREE_OBJECTID);
+		leaf = path->nodes[0];
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_ref);
+		if (btrfs_ref_root(leaf, ref) != ref_root ||
+		    btrfs_ref_generation(leaf, ref) != ref_generation) {
+			ret = -EIO;
+			WARN_ON(1);
+			goto out;
+		}
+
+		num_refs = btrfs_ref_num_refs(leaf, ref);
+		BUG_ON(num_refs == 0);
+		btrfs_set_ref_num_refs(leaf, ref, num_refs + 1);
+
+		existing_owner = btrfs_ref_objectid(leaf, ref);
+		if (existing_owner == owner_objectid &&
+		    btrfs_ref_offset(leaf, ref) > owner_offset) {
+			btrfs_set_ref_offset(leaf, ref, owner_offset);
+		} else if (existing_owner != owner_objectid &&
+			   existing_owner != BTRFS_MULTIPLE_OBJECTIDS) {
+			btrfs_set_ref_objectid(leaf, ref,
+					BTRFS_MULTIPLE_OBJECTIDS);
+			btrfs_set_ref_offset(leaf, ref, 0);
+		}
+		ret = 0;
+	} else {
+		goto out;
+	}
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 out:
 	btrfs_release_path(root, path);
 	return ret;
 }
 
+static int noinline remove_extent_backref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_extent_ref *ref;
+	u32 num_refs;
+	int ret = 0;
+
+	leaf = path->nodes[0];
+	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
+	num_refs = btrfs_ref_num_refs(leaf, ref);
+	BUG_ON(num_refs == 0);
+	num_refs -= 1;
+	if (num_refs == 0) {
+		ret = btrfs_del_item(trans, root, path);
+	} else {
+		btrfs_set_ref_num_refs(leaf, ref, num_refs);
+		btrfs_mark_buffer_dirty(leaf);
+	}
+	btrfs_release_path(root, path);
+	return ret;
+}
+
+static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root, u64 bytenr,
+				     u64 orig_parent, u64 parent,
+				     u64 orig_root, u64 ref_root,
+				     u64 orig_generation, u64 ref_generation,
+				     u64 owner_objectid, u64 owner_offset)
+{
+	int ret;
+	struct btrfs_root *extent_root = root->fs_info->extent_root;
+	struct btrfs_path *path;
+
+	if (root == root->fs_info->extent_root) {
+		struct pending_extent_op *extent_op;
+		u64 num_bytes;
+
+		BUG_ON(owner_objectid >= BTRFS_MAX_LEVEL);
+		num_bytes = btrfs_level_size(root, (int)owner_objectid);
+		if (test_range_bit(&root->fs_info->extent_ins, bytenr,
+				bytenr + num_bytes - 1, EXTENT_LOCKED, 0)) {
+			u64 priv;
+			ret = get_state_private(&root->fs_info->extent_ins,
+						bytenr, &priv);
+			BUG_ON(ret);
+			extent_op = (struct pending_extent_op *)
+							(unsigned long)priv;
+			BUG_ON(extent_op->parent != orig_parent);
+			BUG_ON(extent_op->generation != orig_generation);
+			extent_op->parent = parent;
+			extent_op->generation = ref_generation;
+		} else {
+			extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+			BUG_ON(!extent_op);
+
+			extent_op->type = PENDING_BACKREF_UPDATE;
+			extent_op->bytenr = bytenr;
+			extent_op->num_bytes = num_bytes;
+			extent_op->parent = parent;
+			extent_op->orig_parent = orig_parent;
+			extent_op->generation = ref_generation;
+			extent_op->orig_generation = orig_generation;
+			extent_op->level = (int)owner_objectid;
+
+			set_extent_bits(&root->fs_info->extent_ins,
+					bytenr, bytenr + num_bytes - 1,
+					EXTENT_LOCKED, GFP_NOFS);
+			set_state_private(&root->fs_info->extent_ins,
+					  bytenr, (unsigned long)extent_op);
+		}
+		return 0;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	ret = lookup_extent_backref(trans, extent_root, path,
+				    bytenr, orig_parent, orig_root,
+				    orig_generation, 1);
+	if (ret)
+		goto out;
+	ret = remove_extent_backref(trans, extent_root, path);
+	if (ret)
+		goto out;
+	ret = insert_extent_backref(trans, extent_root, path, bytenr,
+				    parent, ref_root, ref_generation,
+				    owner_objectid, owner_offset);
+	BUG_ON(ret);
+	finish_current_insert(trans, extent_root);
+	del_pending_extents(trans, extent_root);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, u64 bytenr,
+			    u64 orig_parent, u64 parent,
+			    u64 ref_root, u64 ref_generation,
+			    u64 owner_objectid, u64 owner_offset)
+{
+	int ret;
+	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
+	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
+		return 0;
+	maybe_lock_mutex(root);
+	ret = __btrfs_update_extent_ref(trans, root, bytenr, orig_parent,
+					parent, ref_root, ref_root,
+					ref_generation, ref_generation,
+					owner_objectid, owner_offset);
+	maybe_unlock_mutex(root);
+	return ret;
+}
+
 static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes,
-				u64 root_objectid, u64 ref_generation,
-				u64 owner, u64 owner_offset)
+				  struct btrfs_root *root, u64 bytenr,
+				  u64 orig_parent, u64 parent,
+				  u64 orig_root, u64 ref_root,
+				  u64 orig_generation, u64 ref_generation,
+				  u64 owner_objectid, u64 owner_offset)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -751,24 +833,28 @@
 	struct btrfs_extent_item *item;
 	u32 refs;
 
-	WARN_ON(num_bytes < root->sectorsize);
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
 	path->reada = 1;
 	key.objectid = bytenr;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	key.offset = num_bytes;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = (u64)-1;
+
 	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
 				0, 1);
 	if (ret < 0)
 		return ret;
-	if (ret != 0) {
-		BUG();
-	}
-	BUG_ON(ret != 0);
+	BUG_ON(ret == 0 || path->slots[0] == 0);
+
+	path->slots[0]--;
 	l = path->nodes[0];
+
+	btrfs_item_key_to_cpu(l, &key, path->slots[0]);
+	BUG_ON(key.objectid != bytenr);
+	BUG_ON(key.type != BTRFS_EXTENT_ITEM_KEY);
+
 	item = btrfs_item_ptr(l, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(l, item);
 	btrfs_set_extent_refs(l, item, refs + 1);
@@ -777,9 +863,10 @@
 	btrfs_release_path(root->fs_info->extent_root, path);
 
 	path->reada = 1;
-	ret = btrfs_insert_extent_backref(trans, root->fs_info->extent_root,
-					  path, bytenr, root_objectid,
-					  ref_generation, owner, owner_offset);
+	ret = insert_extent_backref(trans, root->fs_info->extent_root,
+				    path, bytenr, parent,
+				    ref_root, ref_generation,
+				    owner_objectid, owner_offset);
 	BUG_ON(ret);
 	finish_current_insert(trans, root->fs_info->extent_root);
 	del_pending_extents(trans, root->fs_info->extent_root);
@@ -789,18 +876,20 @@
 }
 
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes,
-				u64 root_objectid, u64 ref_generation,
-				u64 owner, u64 owner_offset)
-{
-	int ret;
-
-	mutex_lock(&root->fs_info->alloc_mutex);
-	ret = __btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
-				     root_objectid, ref_generation,
-				     owner, owner_offset);
-	mutex_unlock(&root->fs_info->alloc_mutex);
+			 struct btrfs_root *root,
+			 u64 bytenr, u64 num_bytes, u64 parent,
+			 u64 ref_root, u64 ref_generation,
+			 u64 owner_objectid, u64 owner_offset)
+{
+	int ret;
+	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
+	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
+		return 0;
+	maybe_lock_mutex(root);
+	ret = __btrfs_inc_extent_ref(trans, root, bytenr, 0, parent,
+				     0, ref_root, 0, ref_generation,
+				     owner_objectid, owner_offset);
+	maybe_unlock_mutex(root);
 	return ret;
 }
 
@@ -812,9 +901,9 @@
 	return 0;
 }
 
-static int lookup_extent_ref(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 bytenr,
-			     u64 num_bytes, u32 *refs)
+int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, u64 bytenr,
+			    u64 num_bytes, u32 *refs)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -845,7 +934,6 @@
 	return 0;
 }
 
-
 static int get_reference_status(struct btrfs_root *root, u64 bytenr,
 				u64 parent_gen, u64 ref_objectid,
 			        u64 *min_generation, u32 *ref_count)
@@ -862,7 +950,7 @@
 	int ret;
 
 	key.objectid = bytenr;
-	key.offset = 0;
+	key.offset = (u64)-1;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 
 	path = btrfs_alloc_path();
@@ -871,7 +959,10 @@
 	if (ret < 0)
 		goto out;
 	BUG_ON(ret == 0);
-
+	if (ret < 0 || path->slots[0] == 0)
+		goto out;
+
+	path->slots[0]--;
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
@@ -908,7 +999,7 @@
 					  struct btrfs_extent_ref);
 		ref_generation = btrfs_ref_generation(leaf, ref_item);
 		/*
-		 * For (parent_gen > 0 && parent_gen > ref_gen):
+		 * For (parent_gen > 0 && parent_gen > ref_generation):
 		 *
 		 * we reach here through the oldest root, therefore
 		 * all other reference from same snapshot should have
@@ -918,8 +1009,7 @@
 		    (parent_gen > 0 && parent_gen > ref_generation) ||
 		    (ref_objectid >= BTRFS_FIRST_FREE_OBJECTID &&
 		     ref_objectid != btrfs_ref_objectid(leaf, ref_item))) {
-			if (ref_count)
-				*ref_count = 2;
+			*ref_count = 2;
 			break;
 		}
 
@@ -1019,80 +1109,29 @@
 	return ret;
 }
 
-int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int cache_ref)
-{
-	u64 bytenr;
+int btrfs_cache_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		    struct extent_buffer *buf, u32 nr_extents)
+{
 	u32 nritems;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
 	int i;
 	int level;
-	int ret;
-	int faili;
-	int nr_file_extents = 0;
+	int ret = 0;
 
 	if (!root->ref_cows)
 		return 0;
 
 	level = btrfs_header_level(buf);
 	nritems = btrfs_header_nritems(buf);
-	for (i = 0; i < nritems; i++) {
-		cond_resched();
-		if (level == 0) {
-			u64 disk_bytenr;
-			btrfs_item_key_to_cpu(buf, &key, i);
-			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
-				continue;
-			fi = btrfs_item_ptr(buf, i,
-					    struct btrfs_file_extent_item);
-			if (btrfs_file_extent_type(buf, fi) ==
-			    BTRFS_FILE_EXTENT_INLINE)
-				continue;
-			disk_bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
-			if (disk_bytenr == 0)
-				continue;
-
-			if (buf != root->commit_root)
-				nr_file_extents++;
-
-			mutex_lock(&root->fs_info->alloc_mutex);
-			ret = __btrfs_inc_extent_ref(trans, root, disk_bytenr,
-				    btrfs_file_extent_disk_num_bytes(buf, fi),
-				    root->root_key.objectid, trans->transid,
-				    key.objectid, key.offset);
-			mutex_unlock(&root->fs_info->alloc_mutex);
-			if (ret) {
-				faili = i;
-				WARN_ON(1);
-				goto fail;
-			}
-		} else {
-			bytenr = btrfs_node_blockptr(buf, i);
-			btrfs_node_key_to_cpu(buf, &key, i);
-
-			mutex_lock(&root->fs_info->alloc_mutex);
-			ret = __btrfs_inc_extent_ref(trans, root, bytenr,
-					   btrfs_level_size(root, level - 1),
-					   root->root_key.objectid,
-					   trans->transid,
-					   level - 1, key.objectid);
-			mutex_unlock(&root->fs_info->alloc_mutex);
-			if (ret) {
-				faili = i;
-				WARN_ON(1);
-				goto fail;
-			}
-		}
-	}
-	/* cache orignal leaf block's references */
-	if (level == 0 && cache_ref && buf != root->commit_root) {
+
+	if (level == 0) {
 		struct btrfs_leaf_ref *ref;
 		struct btrfs_extent_info *info;
 
-		ref = btrfs_alloc_leaf_ref(root, nr_file_extents);
+		ref = btrfs_alloc_leaf_ref(root, nr_extents);
 		if (!ref) {
-			WARN_ON(1);
+			ret = -ENOMEM;
 			goto out;
 		}
 
@@ -1100,10 +1139,10 @@
 		ref->bytenr = buf->start;
 		ref->owner = btrfs_header_owner(buf);
 		ref->generation = btrfs_header_generation(buf);
-		ref->nritems = nr_file_extents;
+		ref->nritems = nr_extents;
 		info = ref->extents;
 
-		for (i = 0; nr_file_extents > 0 && i < nritems; i++) {
+		for (i = 0; nr_extents > 0 && i < nritems; i++) {
 			u64 disk_bytenr;
 			btrfs_item_key_to_cpu(buf, &key, i);
 			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
@@ -1131,13 +1170,52 @@
 		btrfs_free_leaf_ref(root, ref);
 	}
 out:
-	return 0;
-fail:
-	WARN_ON(1);
-#if 0
-	for (i =0; i < faili; i++) {
+	return ret;
+}
+
+int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		  struct extent_buffer *orig_buf, struct extent_buffer *buf,
+		  u32 *nr_extents)
+{
+	u64 bytenr;
+	u64 ref_root;
+	u64 orig_root;
+	u64 ref_generation;
+	u64 orig_generation;
+	u32 nritems;
+	u32 nr_file_extents = 0;
+	struct btrfs_key key;
+	struct btrfs_file_extent_item *fi;
+	int i;
+	int level;
+	int ret = 0;
+	int faili = 0;
+	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
+			    u64, u64, u64, u64, u64, u64, u64, u64, u64);
+
+	ref_root = btrfs_header_owner(buf);
+	ref_generation = btrfs_header_generation(buf);
+	orig_root = btrfs_header_owner(orig_buf);
+	orig_generation = btrfs_header_generation(orig_buf);
+
+	nritems = btrfs_header_nritems(buf);
+	level = btrfs_header_level(buf);
+
+	if (root->ref_cows) {
+		process_func = __btrfs_inc_extent_ref;
+	} else {
+		if (level == 0 &&
+		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
+			goto out;
+		if (level != 0 &&
+		    root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
+			goto out;
+		process_func = __btrfs_update_extent_ref;
+	}
+
+	for (i = 0; i < nritems; i++) {
+		cond_resched();
 		if (level == 0) {
-			u64 disk_bytenr;
 			btrfs_item_key_to_cpu(buf, &key, i);
 			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
 				continue;
@@ -1146,22 +1224,129 @@
 			if (btrfs_file_extent_type(buf, fi) ==
 			    BTRFS_FILE_EXTENT_INLINE)
 				continue;
-			disk_bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
-			if (disk_bytenr == 0)
-				continue;
-			err = btrfs_free_extent(trans, root, disk_bytenr,
-				    btrfs_file_extent_disk_num_bytes(buf,
-								      fi), 0);
-			BUG_ON(err);
+			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
+			if (bytenr == 0)
+				continue;
+
+			nr_file_extents++;
+
+			maybe_lock_mutex(root);
+			ret = process_func(trans, root, bytenr,
+					   orig_buf->start, buf->start,
+					   orig_root, ref_root,
+					   orig_generation, ref_generation,
+					   key.objectid, key.offset);
+			maybe_unlock_mutex(root);
+
+			if (ret) {
+				faili = i;
+				WARN_ON(1);
+				goto fail;
+			}
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
-			err = btrfs_free_extent(trans, root, bytenr,
-					btrfs_level_size(root, level - 1), 0);
-			BUG_ON(err);
-		}
-	}
-#endif
-	return ret;
+			maybe_lock_mutex(root);
+			ret = process_func(trans, root, bytenr,
+					   orig_buf->start, buf->start,
+					   orig_root, ref_root,
+					   orig_generation, ref_generation,
+					   level - 1, 0);
+			maybe_unlock_mutex(root);
+			if (ret) {
+				faili = i;
+				WARN_ON(1);
+				goto fail;
+			}
+		}
+	}
+out:
+	if (nr_extents) {
+		if (level == 0)
+			*nr_extents = nr_file_extents;
+		else
+			*nr_extents = nritems;
+	}
+	return 0;
+fail:
+	WARN_ON(1);
+	return ret;
+}
+
+int btrfs_update_ref(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root, struct extent_buffer *orig_buf,
+		     struct extent_buffer *buf, int start_slot, int nr)
+
+{
+	u64 bytenr;
+	u64 ref_root;
+	u64 orig_root;
+	u64 ref_generation;
+	u64 orig_generation;
+	struct btrfs_key key;
+	struct btrfs_file_extent_item *fi;
+	int i;
+	int ret;
+	int slot;
+	int level;
+
+	BUG_ON(start_slot < 0);
+	BUG_ON(start_slot + nr > btrfs_header_nritems(buf));
+
+	ref_root = btrfs_header_owner(buf);
+	ref_generation = btrfs_header_generation(buf);
+	orig_root = btrfs_header_owner(orig_buf);
+	orig_generation = btrfs_header_generation(orig_buf);
+	level = btrfs_header_level(buf);
+
+	if (!root->ref_cows) {
+		if (level == 0 &&
+		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
+			return 0;
+		if (level != 0 &&
+		    root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
+			return 0;
+	}
+
+	for (i = 0, slot = start_slot; i < nr; i++, slot++) {
+		cond_resched();
+		if (level == 0) {
+			btrfs_item_key_to_cpu(buf, &key, slot);
+			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
+				continue;
+			fi = btrfs_item_ptr(buf, slot,
+					    struct btrfs_file_extent_item);
+			if (btrfs_file_extent_type(buf, fi) ==
+			    BTRFS_FILE_EXTENT_INLINE)
+				continue;
+			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
+			if (bytenr == 0)
+				continue;
+			maybe_lock_mutex(root);
+			ret = __btrfs_update_extent_ref(trans, root, bytenr,
+					    orig_buf->start, buf->start,
+					    orig_root, ref_root,
+					    orig_generation, ref_generation,
+					    key.objectid, key.offset);
+			maybe_unlock_mutex(root);
+			if (ret)
+				goto fail;
+		} else {
+			bytenr = btrfs_node_blockptr(buf, slot);
+			maybe_lock_mutex(root);
+			ret = __btrfs_update_extent_ref(trans, root, bytenr,
+					    orig_buf->start, buf->start,
+					    orig_root, ref_root,
+					    orig_generation, ref_generation,
+					    level - 1, 0);
+			maybe_unlock_mutex(root);
+			if (ret)
+				goto fail;
+		}
+	}
+	return 0;
+fail:
+	WARN_ON(1);
+	return -1;
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
@@ -1538,19 +1723,18 @@
 {
 	u64 start;
 	u64 end;
+	u64 priv;
 	struct btrfs_fs_info *info = extent_root->fs_info;
-	struct extent_buffer *eb;
-	struct btrfs_path *path;
-	struct btrfs_key ins;
-	struct btrfs_disk_key first;
+	struct btrfs_path *path;
+	struct btrfs_extent_ref *ref;
+	struct pending_extent_op *extent_op;
+	struct btrfs_key key;
 	struct btrfs_extent_item extent_item;
 	int ret;
-	int level;
 	int err = 0;
 
 	WARN_ON(!mutex_is_locked(&extent_root->fs_info->alloc_mutex));
 	btrfs_set_stack_extent_refs(&extent_item, 1);
-	btrfs_set_key_type(&ins, BTRFS_EXTENT_ITEM_KEY);
 	path = btrfs_alloc_path();
 
 	while(1) {
@@ -1559,37 +1743,54 @@
 		if (ret)
 			break;
 
-		ins.objectid = start;
-		ins.offset = end + 1 - start;
-		err = btrfs_insert_item(trans, extent_root, &ins,
+		ret = get_state_private(&info->extent_ins, start, &priv);
+		BUG_ON(ret);
+		extent_op = (struct pending_extent_op *)(unsigned long)priv;
+
+		if (extent_op->type == PENDING_EXTENT_INSERT) {
+			key.objectid = start;
+			key.offset = end + 1 - start;
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			err = btrfs_insert_item(trans, extent_root, &key,
 					&extent_item, sizeof(extent_item));
-		clear_extent_bits(&info->extent_ins, start, end, EXTENT_LOCKED,
-				  GFP_NOFS);
-
-		eb = btrfs_find_create_tree_block(extent_root, ins.objectid,
-					   ins.offset);
-
-		if (!btrfs_buffer_uptodate(eb, trans->transid))
-			btrfs_read_buffer(eb, trans->transid);
-
-		btrfs_tree_lock(eb);
-		level = btrfs_header_level(eb);
-		if (level == 0) {
-			btrfs_item_key(eb, &first, 0);
-		} else {
-			btrfs_node_key(eb, &first, 0);
-		}
-		btrfs_tree_unlock(eb);
-		free_extent_buffer(eb);
-		/*
-		 * the first key is just a hint, so the race we've created
-		 * against reading it is fine
-		 */
-		err = btrfs_insert_extent_backref(trans, extent_root, path,
-					  start, extent_root->root_key.objectid,
-					  0, level,
-					  btrfs_disk_key_objectid(&first));
-		BUG_ON(err);
+			BUG_ON(err);
+
+			clear_extent_bits(&info->extent_ins, start, end,
+					  EXTENT_LOCKED, GFP_NOFS);
+
+			err = insert_extent_backref(trans, extent_root, path,
+						start, extent_op->parent,
+						extent_root->root_key.objectid,
+						extent_op->generation,
+						extent_op->level, 0);
+			BUG_ON(err);
+		} else if (extent_op->type == PENDING_BACKREF_UPDATE) {
+			err = lookup_extent_backref(trans, extent_root, path,
+						start, extent_op->orig_parent,
+						extent_root->root_key.objectid,
+						extent_op->orig_generation, 0);
+			BUG_ON(err);
+
+			clear_extent_bits(&info->extent_ins, start, end,
+					  EXTENT_LOCKED, GFP_NOFS);
+
+			key.objectid = start;
+			key.offset = extent_op->parent;
+			key.type = BTRFS_EXTENT_REF_KEY;
+			err = btrfs_set_item_key_safe(trans, extent_root, path,
+						      &key);
+			BUG_ON(err);
+			ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					     struct btrfs_extent_ref);
+			btrfs_set_ref_generation(path->nodes[0], ref,
+						 extent_op->generation);
+			btrfs_mark_buffer_dirty(path->nodes[0]);
+			btrfs_release_path(extent_root, path);
+		} else {
+			BUG_ON(1);
+		}
+		kfree(extent_op);
+
 		if (need_resched()) {
 			mutex_unlock(&extent_root->fs_info->alloc_mutex);
 			cond_resched();
@@ -1600,52 +1801,44 @@
 	return 0;
 }
 
-static int pin_down_bytes(struct btrfs_root *root, u64 bytenr, u32 num_bytes,
-			  int is_data, int pending)
+static int pin_down_bytes(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  u64 bytenr, u64 num_bytes, int is_data)
 {
 	int err = 0;
-
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
-	if (!pending) {
-		struct extent_buffer *buf;
-
-		if (is_data)
-			goto pinit;
-
-		buf = btrfs_find_tree_block(root, bytenr, num_bytes);
-		if (buf) {
-			/* we can reuse a block if it hasn't been written
-			 * and it is from this transaction.  We can't
-			 * reuse anything from the tree log root because
-			 * it has tiny sub-transactions.
-			 */
-			if (btrfs_buffer_uptodate(buf, 0) &&
-			    btrfs_try_tree_lock(buf)) {
-				u64 transid =
-				    root->fs_info->running_transaction->transid;
-				u64 header_transid =
-					btrfs_header_generation(buf);
-				if (btrfs_header_owner(buf) !=
-				    BTRFS_TREE_LOG_OBJECTID &&
-				    header_transid == transid &&
-				    !btrfs_header_flag(buf,
-					       BTRFS_HEADER_FLAG_WRITTEN)) {
-					clean_tree_block(NULL, root, buf);
-					btrfs_tree_unlock(buf);
-					free_extent_buffer(buf);
-					return 1;
-				}
-				btrfs_tree_unlock(buf);
-			}
+	struct extent_buffer *buf;
+
+	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
+	if (is_data)
+		goto pinit;
+
+	buf = btrfs_find_tree_block(root, bytenr, num_bytes);
+	if (!buf)
+		goto pinit;
+
+	/* we can reuse a block if it hasn't been written
+	 * and it is from this transaction.  We can't
+	 * reuse anything from the tree log root because
+	 * it has tiny sub-transactions.
+	 */
+	if (btrfs_buffer_uptodate(buf, 0) &&
+	    btrfs_try_tree_lock(buf)) {
+		u64 header_owner = btrfs_header_owner(buf);
+		u64 header_transid = btrfs_header_generation(buf);
+		if (header_owner != BTRFS_TREE_LOG_OBJECTID &&
+		    header_transid == trans->transid &&
+		    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
+			clean_tree_block(NULL, root, buf);
+			btrfs_tree_unlock(buf);
 			free_extent_buffer(buf);
-		}
+			return 1;
+		}
+		btrfs_tree_unlock(buf);
+	}
+	free_extent_buffer(buf);
 pinit:
-		btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
-	} else {
-		set_extent_bits(&root->fs_info->pending_del,
-				bytenr, bytenr + num_bytes - 1,
-				EXTENT_LOCKED, GFP_NOFS);
-	}
+	btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
+
 	BUG_ON(err < 0);
 	return 0;
 }
@@ -1653,11 +1846,12 @@
 /*
  * remove an extent from the root, returns 0 on success
  */
-static int __free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
-			 *root, u64 bytenr, u64 num_bytes,
+static int __free_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 ref_generation,
-			 u64 owner_objectid, u64 owner_offset, int pin,
-			 int mark_free)
+			 u64 owner_objectid, u64 owner_offset,
+			 int pin, int mark_free)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -1680,10 +1874,8 @@
 		return -ENOMEM;
 
 	path->reada = 1;
-	ret = lookup_extent_backref(trans, extent_root, path,
-				    bytenr, root_objectid,
-				    ref_generation,
-				    owner_objectid, owner_offset, 1);
+	ret = lookup_extent_backref(trans, extent_root, path, bytenr, parent,
+				    root_objectid, ref_generation, 1);
 	if (ret == 0) {
 		struct btrfs_key found_key;
 		extent_slot = path->slots[0];
@@ -1701,8 +1893,15 @@
 			if (path->slots[0] - extent_slot > 5)
 				break;
 		}
-		if (!found_extent)
-			ret = btrfs_del_item(trans, extent_root, path);
+		if (!found_extent) {
+			ret = remove_extent_backref(trans, extent_root, path);
+			BUG_ON(ret);
+			btrfs_release_path(extent_root, path);
+			ret = btrfs_search_slot(trans, extent_root,
+						&key, path, -1, 1);
+			BUG_ON(ret);
+			extent_slot = path->slots[0];
+		}
 	} else {
 		btrfs_print_leaf(extent_root, path->nodes[0]);
 		WARN_ON(1);
@@ -1711,14 +1910,6 @@
 		       root_objectid, ref_generation, owner_objectid,
 		       owner_offset);
 	}
-	if (!found_extent) {
-		btrfs_release_path(extent_root, path);
-		ret = btrfs_search_slot(trans, extent_root, &key, path, -1, 1);
-		if (ret < 0)
-			return ret;
-		BUG_ON(ret);
-		extent_slot = path->slots[0];
-	}
 
 	leaf = path->nodes[0];
 	ei = btrfs_item_ptr(leaf, extent_slot,
@@ -1731,6 +1922,10 @@
 	btrfs_mark_buffer_dirty(leaf);
 
 	if (refs == 0 && found_extent && path->slots[0] == extent_slot + 1) {
+		struct btrfs_extent_ref *ref;
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_ref);
+		BUG_ON(btrfs_ref_num_refs(leaf, ref) != 1);
 		/* if the back ref and the extent are next to each other
 		 * they get deleted below in one shot
 		 */
@@ -1738,15 +1933,13 @@
 		num_to_del = 2;
 	} else if (found_extent) {
 		/* otherwise delete the extent back ref */
-		ret = btrfs_del_item(trans, extent_root, path);
+		ret = remove_extent_backref(trans, extent_root, path);
 		BUG_ON(ret);
 		/* if refs are 0, we need to setup the path for deletion */
 		if (refs == 0) {
 			btrfs_release_path(extent_root, path);
 			ret = btrfs_search_slot(trans, extent_root, &key, path,
 						-1, 1);
-			if (ret < 0)
-				return ret;
 			BUG_ON(ret);
 		}
 	}
@@ -1760,8 +1953,8 @@
 #endif
 
 		if (pin) {
-			ret = pin_down_bytes(root, bytenr, num_bytes,
-			     owner_objectid >= BTRFS_FIRST_FREE_OBJECTID, 0);
+			ret = pin_down_bytes(trans, root, bytenr, num_bytes,
+				owner_objectid >= BTRFS_FIRST_FREE_OBJECTID);
 			if (ret > 0)
 				mark_free = 1;
 			BUG_ON(ret < 0);
@@ -1780,9 +1973,7 @@
 					   root_used - num_bytes);
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
-		if (ret) {
-			return ret;
-		}
+		BUG_ON(ret);
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
 					 mark_free);
 		BUG_ON(ret);
@@ -1821,33 +2012,61 @@
 {
 	int ret;
 	int err = 0;
+	int mark_free = 0;
 	u64 start;
 	u64 end;
+	u64 priv;
 	struct extent_io_tree *pending_del;
-	struct extent_io_tree *pinned_extents;
+	struct extent_io_tree *extent_ins;
+	struct pending_extent_op *extent_op;
 
 	WARN_ON(!mutex_is_locked(&extent_root->fs_info->alloc_mutex));
+	extent_ins = &extent_root->fs_info->extent_ins;
 	pending_del = &extent_root->fs_info->pending_del;
-	pinned_extents = &extent_root->fs_info->pinned_extents;
 
 	while(1) {
 		ret = find_first_extent_bit(pending_del, 0, &start, &end,
 					    EXTENT_LOCKED);
 		if (ret)
 			break;
+
+		ret = get_state_private(pending_del, start, &priv);
+		BUG_ON(ret);
+		extent_op = (struct pending_extent_op *)(unsigned long)priv;
+
 		clear_extent_bits(pending_del, start, end, EXTENT_LOCKED,
 				  GFP_NOFS);
-		if (!test_range_bit(&extent_root->fs_info->extent_ins,
-				    start, end, EXTENT_LOCKED, 0)) {
-			btrfs_update_pinned_extents(extent_root, start,
-					      end + 1 - start, 1);
+
+		ret = pin_down_bytes(trans, extent_root, start,
+				     end + 1 - start, 0);
+		mark_free = ret > 0;
+		if (!test_range_bit(extent_ins, start, end,
+				    EXTENT_LOCKED, 0)) {
+free_extent:
 			ret = __free_extent(trans, extent_root,
-					     start, end + 1 - start,
-					     extent_root->root_key.objectid,
-					     0, 0, 0, 0, 0);
-		} else {
-			clear_extent_bits(&extent_root->fs_info->extent_ins,
-					  start, end, EXTENT_LOCKED, GFP_NOFS);
+					    start, end + 1 - start,
+					    extent_op->orig_parent,
+					    extent_root->root_key.objectid,
+					    extent_op->orig_generation,
+					    extent_op->level, 0, 0, mark_free);
+			kfree(extent_op);
+		} else {
+			kfree(extent_op);
+			ret = get_state_private(extent_ins, start, &priv);
+			BUG_ON(ret);
+			extent_op = (struct pending_extent_op *)
+							(unsigned long)priv;
+
+			clear_extent_bits(extent_ins, start, end,
+					  EXTENT_LOCKED, GFP_NOFS);
+
+			if (extent_op->type == PENDING_BACKREF_UPDATE)
+				goto free_extent;
+
+			ret = update_block_group(trans, extent_root, start,
+						end + 1 - start, 0, mark_free);
+			BUG_ON(ret);
+			kfree(extent_op);
 		}
 		if (ret)
 			err = ret;
@@ -1865,21 +2084,36 @@
  * remove an extent from the root, returns 0 on success
  */
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root, u64 bytenr,
-			       u64 num_bytes, u64 root_objectid,
-			       u64 ref_generation, u64 owner_objectid,
-			       u64 owner_offset, int pin)
+			       struct btrfs_root *root,
+			       u64 bytenr, u64 num_bytes, u64 parent,
+			       u64 root_objectid, u64 ref_generation,
+			       u64 owner_objectid, u64 owner_offset, int pin)
 {
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	int pending_ret;
 	int ret;
 
 	WARN_ON(num_bytes < root->sectorsize);
-	if (!root->ref_cows)
-		ref_generation = 0;
-
 	if (root == extent_root) {
-		pin_down_bytes(root, bytenr, num_bytes, 0, 1);
+		struct pending_extent_op *extent_op;
+
+		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+		BUG_ON(!extent_op);
+
+		extent_op->type = PENDING_EXTENT_DELETE;
+		extent_op->bytenr = bytenr;
+		extent_op->num_bytes = num_bytes;
+		extent_op->parent = parent;
+		extent_op->orig_parent = parent;
+		extent_op->generation = ref_generation;
+		extent_op->orig_generation = ref_generation;
+		extent_op->level = (int)owner_objectid;
+
+		set_extent_bits(&root->fs_info->pending_del,
+				bytenr, bytenr + num_bytes - 1,
+				EXTENT_LOCKED, GFP_NOFS);
+		set_state_private(&root->fs_info->pending_del,
+				  bytenr, (unsigned long)extent_op);
 		return 0;
 	}
 	/* if metadata always pin */
@@ -1900,9 +2134,9 @@
 	if (ref_generation != trans->transid)
 		pin = 1;
 
-	ret = __free_extent(trans, root, bytenr, num_bytes, root_objectid,
-			    ref_generation, owner_objectid, owner_offset,
-			    pin, pin == 0);
+	ret = __free_extent(trans, root, bytenr, num_bytes, parent,
+			    root_objectid, ref_generation, owner_objectid,
+			    owner_offset, pin, pin == 0);
 
 	finish_current_insert(trans, root->fs_info->extent_root);
 	pending_ret = del_pending_extents(trans, root->fs_info->extent_root);
@@ -1910,15 +2144,15 @@
 }
 
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, u64 bytenr,
-		      u64 num_bytes, u64 root_objectid,
-		      u64 ref_generation, u64 owner_objectid,
-		      u64 owner_offset, int pin)
-{
-	int ret;
-
-	maybe_lock_mutex(root);
-	ret = __btrfs_free_extent(trans, root, bytenr, num_bytes,
+		      struct btrfs_root *root,
+		      u64 bytenr, u64 num_bytes, u64 parent,
+		      u64 root_objectid, u64 ref_generation,
+		      u64 owner_objectid, u64 owner_offset, int pin)
+{
+	int ret;
+
+	maybe_lock_mutex(root);
+	ret = __btrfs_free_extent(trans, root, bytenr, num_bytes, parent,
 				  root_objectid, ref_generation,
 				  owner_objectid, owner_offset, pin);
 	maybe_unlock_mutex(root);
@@ -2270,7 +2504,7 @@
 }
 
 static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
-					 struct btrfs_root *root,
+					 struct btrfs_root *root, u64 parent,
 					 u64 root_objectid, u64 ref_generation,
 					 u64 owner, u64 owner_offset,
 					 struct btrfs_key *ins)
@@ -2288,6 +2522,9 @@
 	struct btrfs_path *path;
 	struct btrfs_key keys[2];
 
+	if (parent == 0)
+		parent = ins->objectid;
+
 	/* block accounting for super block */
 	spin_lock_irq(&info->delalloc_lock);
 	super_used = btrfs_super_bytes_used(&info->super_copy);
@@ -2299,17 +2536,32 @@
 	btrfs_set_root_used(&root->root_item, root_used + num_bytes);
 
 	if (root == extent_root) {
+		struct pending_extent_op *extent_op;
+
+		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+		BUG_ON(!extent_op);
+
+		extent_op->type = PENDING_EXTENT_INSERT;
+		extent_op->bytenr = ins->objectid;
+		extent_op->num_bytes = ins->offset;
+		extent_op->parent = parent;
+		extent_op->orig_parent = 0;
+		extent_op->generation = ref_generation;
+		extent_op->orig_generation = 0;
+		extent_op->level = (int)owner;
+
 		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
 				ins->objectid + ins->offset - 1,
 				EXTENT_LOCKED, GFP_NOFS);
+		set_state_private(&root->fs_info->extent_ins,
+				  ins->objectid, (unsigned long)extent_op);
 		goto update_block;
 	}
 
 	memcpy(&keys[0], ins, sizeof(*ins));
-	keys[1].offset = hash_extent_ref(root_objectid, ref_generation,
-					 owner, owner_offset);
 	keys[1].objectid = ins->objectid;
 	keys[1].type = BTRFS_EXTENT_REF_KEY;
+	keys[1].offset = parent;
 	sizes[0] = sizeof(*extent_item);
 	sizes[1] = sizeof(*ref);
 
@@ -2330,6 +2582,7 @@
 	btrfs_set_ref_generation(path->nodes[0], ref, ref_generation);
 	btrfs_set_ref_objectid(path->nodes[0], ref, owner);
 	btrfs_set_ref_offset(path->nodes[0], ref, owner_offset);
+	btrfs_set_ref_num_refs(path->nodes[0], ref, 1);
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 
@@ -2358,16 +2611,16 @@
 }
 
 int btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
+				struct btrfs_root *root, u64 parent,
 				u64 root_objectid, u64 ref_generation,
 				u64 owner, u64 owner_offset,
 				struct btrfs_key *ins)
 {
 	int ret;
 	maybe_lock_mutex(root);
-	ret = __btrfs_alloc_reserved_extent(trans, root, root_objectid,
-					    ref_generation, owner,
-					    owner_offset, ins);
+	ret = __btrfs_alloc_reserved_extent(trans, root, parent,
+					    root_objectid, ref_generation,
+					    owner, owner_offset, ins);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -2378,7 +2631,7 @@
  * space cache bits as well
  */
 int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
+				struct btrfs_root *root, u64 parent,
 				u64 root_objectid, u64 ref_generation,
 				u64 owner, u64 owner_offset,
 				struct btrfs_key *ins)
@@ -2392,10 +2645,9 @@
 
 	ret = btrfs_remove_free_space(block_group, ins->objectid, ins->offset);
 	BUG_ON(ret);
-
-	ret = __btrfs_alloc_reserved_extent(trans, root, root_objectid,
-					    ref_generation, owner,
-					    owner_offset, ins);
+	ret = __btrfs_alloc_reserved_extent(trans, root, parent,
+					    root_objectid, ref_generation,
+					    owner, owner_offset, ins);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -2409,9 +2661,9 @@
  */
 int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
-		       u64 num_bytes, u64 min_alloc_size,
+		       u64 num_bytes, u64 parent, u64 min_alloc_size,
 		       u64 root_objectid, u64 ref_generation,
-		       u64 owner, u64 owner_offset,
+		       u64 owner_objectid, u64 owner_offset,
 		       u64 empty_size, u64 hint_byte,
 		       u64 search_end, struct btrfs_key *ins, u64 data)
 {
@@ -2424,9 +2676,9 @@
 				     search_end, ins, data);
 	BUG_ON(ret);
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
-		ret = __btrfs_alloc_reserved_extent(trans, root, root_objectid,
-						    ref_generation, owner,
-						    owner_offset, ins);
+		ret = __btrfs_alloc_reserved_extent(trans, root, parent,
+					root_objectid, ref_generation,
+					owner_objectid, owner_offset, ins);
 		BUG_ON(ret);
 
 	}
@@ -2464,10 +2716,9 @@
  */
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
-					     u32 blocksize,
+					     u32 blocksize, u64 parent,
 					     u64 root_objectid,
 					     u64 ref_generation,
-					     u64 first_objectid,
 					     int level,
 					     u64 hint,
 					     u64 empty_size)
@@ -2476,10 +2727,9 @@
 	int ret;
 	struct extent_buffer *buf;
 
-	ret = btrfs_alloc_extent(trans, root, blocksize, blocksize,
-				 root_objectid, ref_generation,
-				 level, first_objectid, empty_size, hint,
-				 (u64)-1, &ins, 0);
+	ret = btrfs_alloc_extent(trans, root, blocksize, parent, blocksize,
+				 root_objectid, ref_generation, level, 0,
+				 empty_size, hint, (u64)-1, &ins, 0);
 	if (ret) {
 		BUG_ON(ret > 0);
 		return ERR_PTR(ret);
@@ -2527,15 +2777,14 @@
 		mutex_lock(&root->fs_info->alloc_mutex);
 		ret = __btrfs_free_extent(trans, root, disk_bytenr,
 				btrfs_file_extent_disk_num_bytes(leaf, fi),
-				leaf_owner, leaf_generation,
+				leaf->start, leaf_owner, leaf_generation,
 				key.objectid, key.offset, 0);
 		mutex_unlock(&root->fs_info->alloc_mutex);
+		BUG_ON(ret);
 
 		atomic_inc(&root->fs_info->throttle_gen);
 		wake_up(&root->fs_info->transaction_throttle);
 		cond_resched();
-
-		BUG_ON(ret);
 	}
 	return 0;
 }
@@ -2550,10 +2799,10 @@
 
 	for (i = 0; i < ref->nritems; i++) {
 		mutex_lock(&root->fs_info->alloc_mutex);
-		ret = __btrfs_free_extent(trans, root,
-					info->bytenr, info->num_bytes,
-					ref->owner, ref->generation,
-					info->objectid, info->offset, 0);
+		ret = __btrfs_free_extent(trans, root, info->bytenr,
+					  info->num_bytes, ref->bytenr,
+					  ref->owner, ref->generation,
+					  info->objectid, info->offset, 0);
 		mutex_unlock(&root->fs_info->alloc_mutex);
 
 		atomic_inc(&root->fs_info->throttle_gen);
@@ -2572,7 +2821,7 @@
 {
 	int ret;
 
-	ret = lookup_extent_ref(NULL, root, start, len, refs);
+	ret = btrfs_lookup_extent_ref(NULL, root, start, len, refs);
 	BUG_ON(ret);
 
 #if 0 // some debugging code in case we see problems here
@@ -2668,8 +2917,8 @@
 
 			mutex_lock(&root->fs_info->alloc_mutex);
 			ret = __btrfs_free_extent(trans, root, bytenr,
-						blocksize, root_owner,
-						root_gen, 0, 0, 1);
+						blocksize, parent->start,
+						root_owner, root_gen, 0, 0, 1);
 			BUG_ON(ret);
 			mutex_unlock(&root->fs_info->alloc_mutex);
 
@@ -2686,8 +2935,6 @@
 		 * So, we don't need to check it again
 		 */
 		if (*level == 1) {
-			struct btrfs_key key;
-			btrfs_node_key_to_cpu(cur, &key, path->slots[*level]);
 			ref = btrfs_lookup_leaf_ref(root, bytenr);
 			if (ref) {
 				ret = cache_drop_leaf_ref(trans, root, ref);
@@ -2746,12 +2993,13 @@
 
 	mutex_lock(&root->fs_info->alloc_mutex);
 	ret = __btrfs_free_extent(trans, root, bytenr, blocksize,
-				  root_owner, root_gen, 0, 0, 1);
+				  parent->start, root_owner, root_gen,
+				  0, 0, 1);
+	mutex_unlock(&root->fs_info->alloc_mutex);
 	free_extent_buffer(path->nodes[*level]);
 	path->nodes[*level] = NULL;
 	*level += 1;
 	BUG_ON(ret);
-	mutex_unlock(&root->fs_info->alloc_mutex);
 
 	cond_resched();
 	return 0;
@@ -2788,19 +3036,18 @@
 			root_item->drop_level = i;
 			return 0;
 		} else {
-			if (path->nodes[*level] == root->node) {
-				root_owner = root->root_key.objectid;
-				root_gen =
-				   btrfs_header_generation(path->nodes[*level]);
-			} else {
-				struct extent_buffer *node;
-				node = path->nodes[*level + 1];
-				root_owner = btrfs_header_owner(node);
-				root_gen = btrfs_header_generation(node);
-			}
+			struct extent_buffer *parent;
+			if (path->nodes[*level] == root->node)
+				parent = path->nodes[*level];
+			else
+				parent = path->nodes[*level + 1];
+
+			root_owner = btrfs_header_owner(parent);
+			root_gen = btrfs_header_generation(parent);
 			ret = btrfs_free_extent(trans, root,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len,
+						parent->start,
 						root_owner, root_gen, 0, 0, 1);
 			BUG_ON(ret);
 			free_extent_buffer(path->nodes[*level]);
diff -r 3bdaaf032a52 extent_io.c
--- a/extent_io.c	Tue Sep 23 09:00:03 2008 +0800
+++ b/extent_io.c	Tue Sep 23 22:28:59 2008 +0800
@@ -2201,9 +2201,10 @@
 	}
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
-
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
 	if (wbc->range_cont)
 		wbc->range_start = index << PAGE_CACHE_SHIFT;
+#endif
 	return ret;
 }
 EXPORT_SYMBOL(extent_write_cache_pages);
diff -r 3bdaaf032a52 file.c
--- a/file.c	Tue Sep 23 09:00:03 2008 +0800
+++ b/file.c	Tue Sep 23 22:29:00 2008 +0800
@@ -524,6 +524,9 @@
 {
 	u64 extent_end = 0;
 	u64 search_start = start;
+	u64 leaf_start;
+	u64 root_gen;
+	u64 root_owner;
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *extent;
 	struct btrfs_path *path;
@@ -562,6 +565,9 @@
 		bookend = 0;
 		found_extent = 0;
 		found_inline = 0;
+		leaf_start = 0;
+		root_gen = 0;
+		root_owner = 0;
 		extent = NULL;
 		leaf = path->nodes[0];
 		slot = path->slots[0];
@@ -628,27 +634,18 @@
 			search_start = extent_end;
 		if (end <= extent_end && start >= key.offset && found_inline) {
 			*hint_byte = EXTENT_MAP_INLINE;
-			continue;
+			goto out;
 		}
+
+		if (found_extent) {
+			read_extent_buffer(leaf, &old, (unsigned long)extent,
+					   sizeof(old));
+			root_gen = btrfs_header_generation(leaf);
+			root_owner = btrfs_header_owner(leaf);
+			leaf_start = leaf->start;
+		}
+
 		if (end < extent_end && end >= key.offset) {
-			if (found_extent) {
-				u64 disk_bytenr =
-				    btrfs_file_extent_disk_bytenr(leaf, extent);
-				u64 disk_num_bytes =
-				    btrfs_file_extent_disk_num_bytes(leaf,
-								      extent);
-				read_extent_buffer(leaf, &old,
-						   (unsigned long)extent,
-						   sizeof(old));
-				if (disk_bytenr != 0) {
-					ret = btrfs_inc_extent_ref(trans, root,
-					         disk_bytenr, disk_num_bytes,
-						 root->root_key.objectid,
-						 trans->transid,
-						 key.objectid, end);
-					BUG_ON(ret);
-				}
-			}
 			bookend = 1;
 			if (found_inline && start <= key.offset)
 				keep = 1;
@@ -687,49 +684,12 @@
 		}
 		/* delete the entire extent */
 		if (!keep) {
-			u64 disk_bytenr = 0;
-			u64 disk_num_bytes = 0;
-			u64 extent_num_bytes = 0;
-			u64 root_gen;
-			u64 root_owner;
-
-			root_gen = btrfs_header_generation(leaf);
-			root_owner = btrfs_header_owner(leaf);
-			if (found_extent) {
-				disk_bytenr =
-				      btrfs_file_extent_disk_bytenr(leaf,
-								     extent);
-				disk_num_bytes =
-				      btrfs_file_extent_disk_num_bytes(leaf,
-								       extent);
-				extent_num_bytes =
-				      btrfs_file_extent_num_bytes(leaf, extent);
-				*hint_byte =
-					btrfs_file_extent_disk_bytenr(leaf,
-								      extent);
-			}
 			ret = btrfs_del_item(trans, root, path);
 			/* TODO update progress marker and return */
 			BUG_ON(ret);
+			extent = NULL;
 			btrfs_release_path(root, path);
-			extent = NULL;
-			if (found_extent && disk_bytenr != 0) {
-				dec_i_blocks(inode, extent_num_bytes);
-				ret = btrfs_free_extent(trans, root,
-						disk_bytenr,
-						disk_num_bytes,
-						root_owner,
-						root_gen, inode->i_ino,
-						key.offset, 0);
-			}
-
-			BUG_ON(ret);
-			if (!bookend && search_start >= end) {
-				ret = 0;
-				goto out;
-			}
-			if (!bookend)
-				continue;
+			/* the extent will be freed later */
 		}
 		if (bookend && found_inline && start <= key.offset) {
 			u32 new_size;
@@ -737,10 +697,13 @@
 						   extent_end - end);
 			dec_i_blocks(inode, (extent_end - key.offset) -
 					(extent_end - end));
-			btrfs_truncate_item(trans, root, path, new_size, 0);
+			ret = btrfs_truncate_item(trans, root, path,
+						  new_size, 0);
+			BUG_ON(ret);
 		}
 		/* create bookend, splitting the extent in two */
 		if (bookend && found_extent) {
+			u64 disk_bytenr;
 			struct btrfs_key ins;
 			ins.objectid = inode->i_ino;
 			ins.offset = end;
@@ -748,13 +711,9 @@
 			btrfs_release_path(root, path);
 			ret = btrfs_insert_empty_item(trans, root, path, &ins,
 						      sizeof(*extent));
+			BUG_ON(ret);
 
 			leaf = path->nodes[0];
-			if (ret) {
-				btrfs_print_leaf(root, leaf);
-				printk("got %d on inserting %Lu %u %Lu start %Lu end %Lu found %Lu %Lu keep was %d\n", ret , ins.objectid, ins.type, ins.offset, start, end, key.offset, extent_end, keep);
-			}
-			BUG_ON(ret);
 			extent = btrfs_item_ptr(leaf, path->slots[0],
 						struct btrfs_file_extent_item);
 			write_extent_buffer(leaf, &old,
@@ -770,11 +729,43 @@
 						   BTRFS_FILE_EXTENT_REG);
 
 			btrfs_mark_buffer_dirty(path->nodes[0]);
-			if (le64_to_cpu(old.disk_bytenr) != 0) {
+
+			disk_bytenr = le64_to_cpu(old.disk_bytenr);
+			if (disk_bytenr != 0) {
+				ret = btrfs_inc_extent_ref(trans, root,
+						disk_bytenr,
+						le64_to_cpu(old.disk_num_bytes),
+						leaf->start,
+						root->root_key.objectid,
+						trans->transid,
+						ins.objectid, ins.offset);
+				BUG_ON(ret);
+			}
+			btrfs_release_path(root, path);
+			if (disk_bytenr != 0) {
 				inode->i_blocks +=
 				      btrfs_file_extent_num_bytes(leaf,
 								  extent) >> 9;
 			}
+		}
+
+		if (found_extent && !keep) {
+			u64 disk_bytenr = le64_to_cpu(old.disk_bytenr);
+
+			if (disk_bytenr != 0) {
+				dec_i_blocks(inode, le64_to_cpu(old.num_bytes));
+				ret = btrfs_free_extent(trans, root,
+						disk_bytenr,
+						le64_to_cpu(old.disk_num_bytes),
+						leaf_start, root_owner,
+						root_gen, key.objectid,
+						key.offset, 0);
+				BUG_ON(ret);
+				*hint_byte = disk_bytenr;
+			}
+		}
+
+		if (search_start >= end) {
 			ret = 0;
 			goto out;
 		}
diff -r 3bdaaf032a52 inode.c
--- a/inode.c	Tue Sep 23 09:00:03 2008 +0800
+++ b/inode.c	Tue Sep 23 22:29:00 2008 +0800
@@ -528,6 +528,9 @@
 	struct btrfs_trans_handle *trans;
 	struct btrfs_ordered_extent *ordered_extent;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct btrfs_file_extent_item *extent_item;
+	struct btrfs_path *path = NULL;
+	struct extent_buffer *leaf;
 	u64 alloc_hint = 0;
 	struct list_head list;
 	struct btrfs_key ins;
@@ -544,20 +547,15 @@
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags))
 		goto nocow;
 
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+
 	lock_extent(io_tree, ordered_extent->file_offset,
 		    ordered_extent->file_offset + ordered_extent->len - 1,
 		    GFP_NOFS);
 
 	INIT_LIST_HEAD(&list);
 
-	ins.objectid = ordered_extent->start;
-	ins.offset = ordered_extent->len;
-	ins.type = BTRFS_EXTENT_ITEM_KEY;
-
-	ret = btrfs_alloc_reserved_extent(trans, root, root->root_key.objectid,
-					  trans->transid, inode->i_ino,
-					  ordered_extent->file_offset, &ins);
-	BUG_ON(ret);
 	mutex_lock(&BTRFS_I(inode)->extent_mutex);
 
 	ret = btrfs_drop_extents(trans, root, inode,
@@ -566,17 +564,41 @@
 				 ordered_extent->len,
 				 ordered_extent->file_offset, &alloc_hint);
 	BUG_ON(ret);
-	ret = btrfs_insert_file_extent(trans, root, inode->i_ino,
-				       ordered_extent->file_offset,
-				       ordered_extent->start,
-				       ordered_extent->len,
-				       ordered_extent->len, 0);
+
+	ins.objectid = inode->i_ino;
+	ins.offset = ordered_extent->file_offset;
+	ins.type = BTRFS_EXTENT_DATA_KEY;
+	ret = btrfs_insert_empty_item(trans, root, path, &ins,
+				      sizeof(*extent_item));
 	BUG_ON(ret);
+	leaf = path->nodes[0];
+	extent_item = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_file_extent_item);
+	btrfs_set_file_extent_generation(leaf, extent_item, trans->transid);
+	btrfs_set_file_extent_type(leaf, extent_item, BTRFS_FILE_EXTENT_REG);
+	btrfs_set_file_extent_disk_bytenr(leaf, extent_item,
+					  ordered_extent->start);
+	btrfs_set_file_extent_disk_num_bytes(leaf, extent_item,
+					     ordered_extent->len);
+	btrfs_set_file_extent_offset(leaf, extent_item, 0);
+	btrfs_set_file_extent_num_bytes(leaf, extent_item,
+					ordered_extent->len);
+	btrfs_mark_buffer_dirty(leaf);
 
 	btrfs_drop_extent_cache(inode, ordered_extent->file_offset,
 				ordered_extent->file_offset +
 				ordered_extent->len - 1);
 	mutex_unlock(&BTRFS_I(inode)->extent_mutex);
+
+	ins.objectid = ordered_extent->start;
+	ins.offset = ordered_extent->len;
+	ins.type = BTRFS_EXTENT_ITEM_KEY;
+	ret = btrfs_alloc_reserved_extent(trans, root, leaf->start,
+					  root->root_key.objectid,
+					  trans->transid, inode->i_ino,
+					  ordered_extent->file_offset, &ins);
+	BUG_ON(ret);
+	btrfs_release_path(root, path);
 
 	inode->i_blocks += ordered_extent->len >> 9;
 	unlock_extent(io_tree, ordered_extent->file_offset,
@@ -596,6 +618,8 @@
 	btrfs_put_ordered_extent(ordered_extent);
 
 	btrfs_end_transaction(trans, root);
+	if (path)
+		btrfs_free_path(path);
 	return 0;
 }
 
@@ -1433,10 +1457,7 @@
 					if (root->ref_cows)
 						dec_i_blocks(inode, num_dec);
 				}
-				if (root->ref_cows) {
-					root_gen =
-						btrfs_header_generation(leaf);
-				}
+				root_gen = btrfs_header_generation(leaf);
 				root_owner = btrfs_header_owner(leaf);
 			}
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
@@ -1477,7 +1498,7 @@
 		if (found_extent) {
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes,
-						root_owner,
+						leaf->start, root_owner,
 						root_gen, inode->i_ino,
 						found_key.offset, 0);
 			BUG_ON(ret);
diff -r 3bdaaf032a52 ioctl.c
--- a/ioctl.c	Tue Sep 23 09:00:03 2008 +0800
+++ b/ioctl.c	Tue Sep 23 22:29:00 2008 +0800
@@ -76,9 +76,8 @@
 	if (ret)
 		goto fail;
 
-	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
-				      objectid, trans->transid, 0, 0,
-				      0, 0);
+	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
+				      objectid, trans->transid, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
 		goto fail;
@@ -525,13 +524,10 @@
 	struct file *src_file;
 	struct inode *src;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_ordered_extent *ordered;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	char *buf;
 	struct btrfs_key key;
-	struct btrfs_key new_key;
-	u32 size;
 	u32 nritems;
 	int slot;
 	int ret;
@@ -576,6 +572,7 @@
 	/* do any pending delalloc/csum calc on src, one way or
 	   another, and lock file content */
 	while (1) {
+		struct btrfs_ordered_extent *ordered;
 		lock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
 		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
 		if (BTRFS_I(src)->delalloc_bytes == 0 && !ordered)
@@ -619,6 +616,32 @@
 		    key.objectid != src->i_ino)
 			break;
 
+		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY ||
+		    btrfs_key_type(&key) == BTRFS_CSUM_ITEM_KEY) {
+			u32 size;
+			struct btrfs_key new_key;
+
+			size = btrfs_item_size_nr(leaf, slot);
+			read_extent_buffer(leaf, buf,
+					   btrfs_item_ptr_offset(leaf, slot),
+					   size);
+			btrfs_release_path(root, path);
+
+			memcpy(&new_key, &key, sizeof(new_key));
+			new_key.objectid = inode->i_ino;
+			ret = btrfs_insert_empty_item(trans, root, path,
+						      &new_key, size);
+			if (ret)
+				goto out;
+
+			leaf = path->nodes[0];
+			slot = path->slots[0];
+			write_extent_buffer(leaf, buf,
+					    btrfs_item_ptr_offset(leaf, slot),
+					    size);
+			btrfs_mark_buffer_dirty(leaf);
+		}
+
 		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
 			struct btrfs_file_extent_item *extent;
 			int found_type;
@@ -634,31 +657,15 @@
 				/* ds == 0 means there's a hole */
 				if (ds != 0) {
 					ret = btrfs_inc_extent_ref(trans, root,
-						     ds, dl,
+						     ds, dl, leaf->start,
 						     root->root_key.objectid,
 						     trans->transid,
 						     inode->i_ino, key.offset);
-					if (ret)
-						goto out;
+					BUG_ON(ret);
 				}
 			}
 		}
-
-		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY ||
-		    btrfs_key_type(&key) == BTRFS_CSUM_ITEM_KEY) {
-			size = btrfs_item_size_nr(leaf, slot);
-			read_extent_buffer(leaf, buf,
-					   btrfs_item_ptr_offset(leaf, slot),
-					   size);
-			btrfs_release_path(root, path);
-			memcpy(&new_key, &key, sizeof(new_key));
-			new_key.objectid = inode->i_ino;
-			ret = btrfs_insert_item(trans, root, &new_key,
-						buf, size);
-			BUG_ON(ret);
-		} else {
-			btrfs_release_path(root, path);
-		}
+		btrfs_release_path(root, path);
 		key.offset++;
 	}
 	ret = 0;
diff -r 3bdaaf032a52 print-tree.c
--- a/print-tree.c	Tue Sep 23 09:00:03 2008 +0800
+++ b/print-tree.c	Tue Sep 23 22:29:00 2008 +0800
@@ -102,11 +102,12 @@
 		case BTRFS_EXTENT_REF_KEY:
 			ref = btrfs_item_ptr(l, i, struct btrfs_extent_ref);
 			printk("\t\textent back ref root %llu gen %llu "
-			       "owner %llu offset %llu\n",
+			       "owner %llu offset %llu num_refs %lu\n",
 			       (unsigned long long)btrfs_ref_root(l, ref),
 			       (unsigned long long)btrfs_ref_generation(l, ref),
 			       (unsigned long long)btrfs_ref_objectid(l, ref),
-			       (unsigned long long)btrfs_ref_offset(l, ref));
+			       (unsigned long long)btrfs_ref_offset(l, ref),
+			       (unsigned long)btrfs_ref_num_refs(l, ref));
 			break;
 
 		case BTRFS_EXTENT_DATA_KEY:
diff -r 3bdaaf032a52 tree-log.c
--- a/tree-log.c	Tue Sep 23 09:00:03 2008 +0800
+++ b/tree-log.c	Tue Sep 23 22:29:00 2008 +0800
@@ -89,9 +89,9 @@
 	int ret;
 	u64 objectid = root->root_key.objectid;
 
-	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
+	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 				      BTRFS_TREE_LOG_OBJECTID,
-				      0, 0, 0, 0, 0);
+				      trans->transid, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
 		return ret;
@@ -433,6 +433,49 @@
 						   trans->transid);
 		}
 	}
+
+	if (overwrite_root &&
+	    key->type == BTRFS_EXTENT_DATA_KEY) {
+		int extent_type;
+		struct btrfs_file_extent_item *fi;
+
+		fi = (struct btrfs_file_extent_item *)dst_ptr;
+		extent_type = btrfs_file_extent_type(path->nodes[0], fi);
+		if (extent_type == BTRFS_FILE_EXTENT_REG) {
+			struct btrfs_key ins;
+			ins.objectid = btrfs_file_extent_disk_bytenr(
+							path->nodes[0], fi);
+			ins.offset = btrfs_file_extent_disk_num_bytes(
+							path->nodes[0], fi);
+			ins.type = BTRFS_EXTENT_ITEM_KEY;
+
+			/*
+			 * is this extent already allocated in the extent
+			 * allocation tree?  If so, just add a reference
+			 */
+			ret = btrfs_lookup_extent(root, ins.objectid,
+						  ins.offset);
+			if (ret == 0) {
+				ret = btrfs_inc_extent_ref(trans, root,
+						ins.objectid, ins.offset,
+						path->nodes[0]->start,
+						root->root_key.objectid,
+						trans->transid,
+						key->objectid, key->offset);
+			} else {
+				/*
+				 * insert the extent pointer in the extent
+				 * allocation tree
+				 */
+				ret = btrfs_alloc_logged_extent(trans, root,
+						path->nodes[0]->start,
+						root->root_key.objectid,
+						trans->transid, key->objectid,
+						key->offset, &ins);
+				BUG_ON(ret);
+			}
+		}
+	}
 no_copy:
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_release_path(root, path);
@@ -551,45 +594,10 @@
 			 start, extent_end, start, &alloc_hint);
 	BUG_ON(ret);
 
+	/* insert the extent */
+	ret = overwrite_item(trans, root, path, eb, slot, key);
 	BUG_ON(ret);
-	if (found_type == BTRFS_FILE_EXTENT_REG) {
-		struct btrfs_key ins;
 
-		ins.objectid = btrfs_file_extent_disk_bytenr(eb, item);
-		ins.offset = btrfs_file_extent_disk_num_bytes(eb, item);
-		ins.type = BTRFS_EXTENT_ITEM_KEY;
-
-		/* insert the extent pointer in the file */
-		ret = overwrite_item(trans, root, path, eb, slot, key);
-		BUG_ON(ret);
-
-		/*
-		 * is this extent already allocated in the extent
-		 * allocation tree?  If so, just add a reference
-		 */
-		ret = btrfs_lookup_extent(root, path, ins.objectid, ins.offset);
-		btrfs_release_path(root, path);
-		if (ret == 0) {
-			ret = btrfs_inc_extent_ref(trans, root,
-				   ins.objectid, ins.offset,
-				   root->root_key.objectid,
-				   trans->transid, key->objectid, start);
-		} else {
-			/*
-			 * insert the extent pointer in the extent
-			 * allocation tree
-			 */
-			ret = btrfs_alloc_logged_extent(trans, root,
-						root->root_key.objectid,
-						trans->transid, key->objectid,
-						start, &ins);
-			BUG_ON(ret);
-		}
-	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
-		/* inline extents are easy, we just overwrite them */
-		ret = overwrite_item(trans, root, path, eb, slot, key);
-		BUG_ON(ret);
-	}
 	/* btrfs_drop_extents changes i_blocks, update it here */
 	inode->i_blocks += (extent_end - start) >> 9;
 	btrfs_update_inode(trans, root, inode);
@@ -1806,16 +1814,14 @@
 			WARN_ON(*level == 0);
 			return 0;
 		} else {
-			if (path->nodes[*level] == root->node) {
-				root_owner = root->root_key.objectid;
-				root_gen =
-				   btrfs_header_generation(path->nodes[*level]);
-			} else {
-				struct extent_buffer *node;
-				node = path->nodes[*level + 1];
-				root_owner = btrfs_header_owner(node);
-				root_gen = btrfs_header_generation(node);
-			}
+			struct extent_buffer *parent;
+			if (path->nodes[*level] == root->node)
+				parent = path->nodes[*level];
+			else
+				parent = path->nodes[*level + 1];
+
+			root_owner = btrfs_header_owner(parent);
+			root_gen = btrfs_header_generation(parent);
 			wc->process_func(root, path->nodes[*level], wc,
 				 btrfs_header_generation(path->nodes[*level]));
 			if (wc->free) {
@@ -2525,8 +2531,10 @@
 				if (ds != 0) {
 					ret = btrfs_inc_extent_ref(trans, log,
 						   ds, dl,
+						   dst_path->nodes[0]->start,
 						   BTRFS_TREE_LOG_OBJECTID,
-						   0, ins_keys[i].objectid,
+						   trans->transid,
+						   ins_keys[i].objectid,
 						   ins_keys[i].offset);
 					BUG_ON(ret);
 				}
