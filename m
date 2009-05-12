From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 1/2] btrfs-progs: mixed back ref support
Date: Tue, 12 May 2009 14:05:52 +0800
Message-ID: <4A0911C0.9020608@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds mixed back ref support for btrfs programs.
The mixed back ref is a new disk format. back compatilibity
is still not implemented. To try the new disk format, you
need fresh formatted btrfs.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp btrfs-progs-unstable/crc32c.h btrfs-progs-2/crc32c.h
--- btrfs-progs-unstable/crc32c.h	2008-09-30 16:50:58.898877720 +0800
+++ btrfs-progs-2/crc32c.h	2009-04-22 15:13:09.000000000 +0800
@@ -24,4 +24,5 @@
 u32 crc32c_le(u32 seed, unsigned char const *data, size_t length);
 
 #define crc32c(seed, data, length) crc32c_le(seed, (unsigned char const *)data, length)
+#define btrfs_crc32c crc32c
 #endif
diff -urp btrfs-progs-unstable/ctree.c btrfs-progs-2/ctree.c
--- btrfs-progs-unstable/ctree.c	2009-01-08 08:30:09.752081135 +0800
+++ btrfs-progs-2/ctree.c	2009-05-01 14:07:13.000000000 +0800
@@ -85,6 +85,7 @@ int btrfs_copy_root(struct btrfs_trans_h
 	int ret = 0;
 	int level;
 	struct btrfs_root *new_root;
+	struct btrfs_disk_key disk_key;
 
 	new_root = kmalloc(sizeof(*new_root), GFP_NOFS);
 	if (!new_root)
@@ -98,8 +99,12 @@ int btrfs_copy_root(struct btrfs_trans_h
 	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
 
 	level = btrfs_header_level(buf);
-	cow = btrfs_alloc_free_block(trans, new_root, buf->len, 0,
-				     new_root_objectid, trans->transid,
+	if (level == 0)
+		btrfs_item_key(buf, &disk_key, 0);
+	else
+		btrfs_node_key(buf, &disk_key, 0);
+	cow = btrfs_alloc_free_block(trans, new_root, buf->len,
+				     new_root_objectid, &disk_key,
 				     level, buf->start, 0);
 	if (IS_ERR(cow)) {
 		kfree(new_root);
@@ -117,7 +122,7 @@ int btrfs_copy_root(struct btrfs_trans_h
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
-	ret = btrfs_inc_ref(trans, new_root, buf, cow, NULL);
+	ret = btrfs_inc_ref(trans, new_root, cow, 0);
 	kfree(new_root);
 
 	if (ret)
@@ -128,6 +133,74 @@ int btrfs_copy_root(struct btrfs_trans_h
 	return 0;
 }
 
+static noinline int __btrfs_update_ref(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root,
+				       struct extent_buffer *buf,
+				       struct extent_buffer *cow)
+{
+	u64 refs;
+	u64 owner;
+	u64 flags;
+	u64 new_flags;
+	int ret;
+
+	owner = btrfs_header_owner(buf);
+	BUG_ON(owner == BTRFS_TREE_RELOC_OBJECTID);
+	/*
+	 * There are only two places that can drop reference to
+	 * tree blocks created in old transaction and tree blocks
+	 * create by the relocation, one is here, the other place
+	 * is drop_snapshot. In both places, we check and decrease
+	 * the reference count while tree block is locked.
+	 * Furthermore, if reference count is one, it won't get
+	 * increased again.
+	 */
+	ret = btrfs_lookup_extent_info(trans, root, buf->start,
+				       buf->len, &refs, &flags);
+	BUG_ON(ret);
+	BUG_ON(refs == 0);
+
+	if (refs > 1) {
+		new_flags = flags;
+		if (owner == root->root_key.objectid &&
+		    !(flags & BTRFS_BLOCK_FULL_BACKREF)) {
+			ret = btrfs_inc_ref(trans, root, buf, 1);
+			BUG_ON(ret);
+
+			BUG_ON(flags & BTRFS_BLOCK_NO_OWNER_REF);
+			new_flags |= BTRFS_BLOCK_NO_OWNER_REF;
+			new_flags |= BTRFS_BLOCK_FULL_BACKREF;
+		} else {
+			ret = btrfs_inc_ref(trans, root, cow, 0);
+			BUG_ON(ret);
+
+			if (owner == root->root_key.objectid) {
+				BUG_ON(flags & BTRFS_BLOCK_NO_OWNER_REF);
+				new_flags |= BTRFS_BLOCK_NO_OWNER_REF;
+			}
+		}
+		if (new_flags != flags) {
+			ret = btrfs_update_extent_flags(trans, root,
+							buf->start, buf->len,
+							new_flags);
+			BUG_ON(ret);
+		}
+	} else {
+		if (flags & BTRFS_BLOCK_FULL_BACKREF) {
+			ret = btrfs_inc_ref(trans, root, cow, 0);
+			BUG_ON(ret);
+			ret = btrfs_dec_ref(trans, root, buf, 1);
+			BUG_ON(ret);
+		} else {
+			BUG_ON(owner != root->root_key.objectid);
+			BUG_ON(flags & BTRFS_BLOCK_NO_OWNER_REF);
+		}
+		clean_tree_block(trans, root, buf);
+	}
+
+	return 0;
+}
+
 int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct extent_buffer *buf,
@@ -135,26 +208,25 @@ int __btrfs_cow_block(struct btrfs_trans
 			     struct extent_buffer **cow_ret,
 			     u64 search_start, u64 empty_size)
 {
-	u64 parent_start;
+	u64 generation;
 	struct extent_buffer *cow;
-	u32 nritems;
-	int ret = 0;
-	int different_trans = 0;
+	struct btrfs_disk_key disk_key;
 	int level;
 
 	WARN_ON(root->ref_cows && trans->transid !=
 		root->fs_info->running_transaction->transid);
 	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
 
-	if (parent)
-		parent_start = parent->start;
+	level = btrfs_header_level(buf);
+	generation = btrfs_header_generation(buf);
+
+	if (level == 0)
+		btrfs_item_key(buf, &disk_key, 0);
 	else
-		parent_start = 0;
+		btrfs_node_key(buf, &disk_key, 0);
 
-	level = btrfs_header_level(buf);
-	nritems = btrfs_header_nritems(buf);
-	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
-				     root->root_key.objectid, trans->transid,
+	cow = btrfs_alloc_free_block(trans, root, buf->len,
+				     root->root_key.objectid, &disk_key,
 				     level, search_start, empty_size);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
@@ -170,28 +242,20 @@ int __btrfs_cow_block(struct btrfs_trans
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
-	if (btrfs_header_generation(buf) != trans->transid) {
-		different_trans = 1;
-		ret = btrfs_inc_ref(trans, root, buf, cow, NULL);
-		if (ret)
-			return ret;
-	} else {
-		ret = btrfs_update_ref(trans, root, buf, cow, 0, nritems);
-		if (ret)
-			return ret;
+
+	if (root->ref_cows && buf != root->node &&
+	    (generation <= btrfs_root_last_snapshot(&root->root_item) ||
+	     btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)))
+		__btrfs_update_ref(trans, root, buf, cow);
+	else
 		clean_tree_block(trans, root, buf);
-	}
 
 	if (buf == root->node) {
 		root->node = cow;
 		extent_buffer_get(cow);
-		if (buf != root->commit_root) {
-			btrfs_free_extent(trans, root, buf->start,
-					  buf->len, buf->start,
-					  root->root_key.objectid,
-					  btrfs_header_generation(buf),
-					  level, 1);
-		}
+
+		btrfs_free_extent(trans, root, buf->start, buf->len,
+				  0, root->root_key.objectid, level, 0);
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
 	} else {
@@ -202,9 +266,9 @@ int __btrfs_cow_block(struct btrfs_trans
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
 		WARN_ON(btrfs_header_generation(parent) != trans->transid);
+
 		btrfs_free_extent(trans, root, buf->start, buf->len,
-				  parent_start, btrfs_header_owner(parent),
-				  btrfs_header_generation(parent), level, 1);
+				  0, root->root_key.objectid, level, 1);
 	}
 	free_extent_buffer(buf);
 	btrfs_mark_buffer_dirty(cow);
@@ -698,22 +762,15 @@ static int balance_level(struct btrfs_tr
 		BUG_ON(ret);
 
 		root->node = child;
-
-		ret = btrfs_update_extent_ref(trans, root, child->start,
-					      mid->start, child->start,
-					      root->root_key.objectid,
-					      trans->transid, level - 1);
-		BUG_ON(ret);
-
 		add_root_to_dirty_list(root);
 		path->nodes[level] = NULL;
 		clean_tree_block(trans, root, mid);
 		wait_on_tree_block_writeback(root, mid);
 		/* once for the path */
 		free_extent_buffer(mid);
+
 		ret = btrfs_free_extent(trans, root, mid->start, mid->len,
-					mid->start, root->root_key.objectid,
-					btrfs_header_generation(mid),
+					0, root->root_key.objectid,
 					level, 1);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
@@ -764,7 +821,6 @@ static int balance_level(struct btrfs_tr
 			ret = wret;
 		if (btrfs_header_nritems(right) == 0) {
 			u64 bytenr = right->start;
-			u64 generation = btrfs_header_generation(parent);
 			u32 blocksize = right->len;
 
 			clean_tree_block(trans, root, right);
@@ -776,9 +832,9 @@ static int balance_level(struct btrfs_tr
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
@@ -813,7 +869,6 @@ static int balance_level(struct btrfs_tr
 	}
 	if (btrfs_header_nritems(mid) == 0) {
 		/* we've managed to empty the middle node, drop it */
-		u64 root_gen = btrfs_header_generation(parent);
 		u64 bytenr = mid->start;
 		u32 blocksize = mid->len;
 		clean_tree_block(trans, root, mid);
@@ -824,9 +879,8 @@ static int balance_level(struct btrfs_tr
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
@@ -1287,8 +1341,6 @@ static int push_node_left(struct btrfs_t
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
 
-	ret = btrfs_update_ref(trans, root, src, dst, dst_nritems, push_items);
-	BUG_ON(ret);
 	return ret;
 }
 
@@ -1351,8 +1403,6 @@ static int balance_node_right(struct btr
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
 
-	ret = btrfs_update_ref(trans, root, src, dst, 0, push_items);
-	BUG_ON(ret);
 	return ret;
 }
 
@@ -1372,7 +1422,6 @@ static int noinline insert_new_root(stru
 	struct extent_buffer *c;
 	struct extent_buffer *old;
 	struct btrfs_disk_key lower_key;
-	int ret;
 
 	BUG_ON(path->nodes[level]);
 	BUG_ON(path->nodes[level-1] != root->node);
@@ -1383,10 +1432,10 @@ static int noinline insert_new_root(stru
 	else
 		btrfs_node_key(lower, &lower_key, 0);
 
-	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
-				   root->root_key.objectid,
-				   trans->transid, level,
-				   root->node->start, 0);
+	c = btrfs_alloc_free_block(trans, root, root->nodesize,
+				   root->root_key.objectid, &lower_key, 
+				   level, root->node->start, 0);
+
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 
@@ -1417,12 +1466,6 @@ static int noinline insert_new_root(stru
 	old = root->node;
 	root->node = c;
 
-	ret = btrfs_update_extent_ref(trans, root, lower->start,
-				      lower->start, c->start,
-				      root->root_key.objectid,
-				      trans->transid, level - 1);
-	BUG_ON(ret);
-
 	/* the super has an extra ref to root->node */
 	free_extent_buffer(old);
 
@@ -1509,12 +1552,12 @@ static int split_node(struct btrfs_trans
 	}
 
 	c_nritems = btrfs_header_nritems(c);
+	mid = (c_nritems + 1) / 2;
+	btrfs_node_key(c, &disk_key, mid);
 
-	btrfs_node_key(c, &disk_key, 0);
 	split = btrfs_alloc_free_block(trans, root, root->nodesize,
-					 path->nodes[level + 1]->start,
-					 root->root_key.objectid,
-					 trans->transid, level, c->start, 0);
+					root->root_key.objectid,
+					&disk_key, level, c->start, 0);
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
@@ -1531,7 +1574,6 @@ static int split_node(struct btrfs_trans
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
 
-	mid = (c_nritems + 1) / 2;
 
 	copy_extent_buffer(split, c,
 			   btrfs_node_key_ptr_offset(0),
@@ -1544,16 +1586,12 @@ static int split_node(struct btrfs_trans
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
 		free_extent_buffer(c);
@@ -1744,9 +1782,6 @@ static int push_leaf_right(struct btrfs_
 	btrfs_set_node_key(upper, &disk_key, slot + 1);
 	btrfs_mark_buffer_dirty(upper);
 
-	ret = btrfs_update_ref(trans, root, left, right, 0, push_items);
-	BUG_ON(ret);
-
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] >= left_nritems) {
 		path->slots[0] -= left_nritems;
@@ -1907,10 +1942,6 @@ static int push_leaf_left(struct btrfs_t
 	if (wret)
 		ret = wret;
 
-	ret = btrfs_update_ref(trans, root, right, left,
-			       old_left_nritems, push_items);
-	BUG_ON(ret);
-
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
 		path->slots[0] += old_left_nritems;
@@ -1931,34 +1962,96 @@ static int push_leaf_left(struct btrfs_t
  *
  * returns 0 if all went well and < 0 on failure.
  */
-static int split_leaf(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *ins_key,
-		      struct btrfs_path *path, int data_size, int extend)
+static noinline int copy_for_split(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct btrfs_path *path,
+			       struct extent_buffer *l,
+			       struct extent_buffer *right,
+			       int slot, int mid, int nritems)
 {
+	int data_copy_size;
+	int rt_data_off;
+	int i;
+	int ret = 0;
+	int wret;
+	struct btrfs_disk_key disk_key;
+
+	nritems = nritems - mid;
+	btrfs_set_header_nritems(right, nritems);
+	data_copy_size = btrfs_item_end_nr(l, mid) - leaf_data_end(root, l);
+
+	copy_extent_buffer(right, l, btrfs_item_nr_offset(0),
+			   btrfs_item_nr_offset(mid),
+			   nritems * sizeof(struct btrfs_item));
+
+	copy_extent_buffer(right, l,
+		     btrfs_leaf_data(right) + BTRFS_LEAF_DATA_SIZE(root) -
+		     data_copy_size, btrfs_leaf_data(l) +
+		     leaf_data_end(root, l), data_copy_size);
+
+	rt_data_off = BTRFS_LEAF_DATA_SIZE(root) -
+		      btrfs_item_end_nr(l, mid);
+
+	for (i = 0; i < nritems; i++) {
+		struct btrfs_item *item = btrfs_item_nr(right, i);
+		u32 ioff = btrfs_item_offset(right, item);
+		btrfs_set_item_offset(right, item, ioff + rt_data_off);
+	}
+
+	btrfs_set_header_nritems(l, mid);
+	ret = 0;
+	btrfs_item_key(right, &disk_key, 0);
+	wret = insert_ptr(trans, root, path, &disk_key, right->start,
+			  path->slots[1] + 1, 1);
+	if (wret)
+		ret = wret;
+
+	btrfs_mark_buffer_dirty(right);
+	btrfs_mark_buffer_dirty(l);
+	BUG_ON(path->slots[0] != slot);
+
+	if (mid <= slot) {
+		free_extent_buffer(path->nodes[0]);
+		path->nodes[0] = right;
+		path->slots[0] -= mid;
+		path->slots[1] += 1;
+	} else {
+		free_extent_buffer(right);
+	}
+
+	BUG_ON(path->slots[0] < 0);
+
+	return ret;
+}
+
+/*
+ * split the path's leaf in two, making sure there is at least data_size
+ * available for the resulting leaf level of the path.
+ *
+ * returns 0 if all went well and < 0 on failure.
+ */
+static noinline int split_leaf(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct btrfs_key *ins_key,
+			       struct btrfs_path *path, int data_size,
+			       int extend)
+{
+	struct btrfs_disk_key disk_key;
 	struct extent_buffer *l;
 	u32 nritems;
 	int mid;
 	int slot;
 	struct extent_buffer *right;
-	int space_needed = data_size + sizeof(struct btrfs_item);
-	int data_copy_size;
-	int rt_data_off;
-	int i;
 	int ret = 0;
 	int wret;
-	int double_split;
+	int split;
 	int num_doubles = 0;
-	struct btrfs_disk_key disk_key;
-
-	if (extend && data_size)
-		space_needed = data_size;
 
 	/* first try to make some room by pushing left and right */
 	if (data_size && ins_key->type != BTRFS_DIR_ITEM_KEY) {
 		wret = push_leaf_right(trans, root, path, data_size, 0);
-		if (wret < 0) {
+		if (wret < 0)
 			return wret;
-		}
 		if (wret) {
 			wret = push_leaf_left(trans, root, path, data_size, 0);
 			if (wret < 0)
@@ -1967,7 +2060,7 @@ static int split_leaf(struct btrfs_trans
 		l = path->nodes[0];
 
 		/* did the pushes work? */
-		if (btrfs_leaf_free_space(root, l) >= space_needed)
+		if (btrfs_leaf_free_space(root, l) >= data_size)
 			return 0;
 	}
 
@@ -1977,144 +2070,115 @@ static int split_leaf(struct btrfs_trans
 			return ret;
 	}
 again:
-	double_split = 0;
+	split = 1;
 	l = path->nodes[0];
 	slot = path->slots[0];
 	nritems = btrfs_header_nritems(l);
-	mid = (nritems + 1)/ 2;
-
-	right = btrfs_alloc_free_block(trans, root, root->leafsize,
-					path->nodes[1]->start,
-					root->root_key.objectid,
-					trans->transid, 0, l->start, 0);
-	if (IS_ERR(right)) {
-		BUG_ON(1);
-		return PTR_ERR(right);
-	}
-
-	memset_extent_buffer(right, 0, 0, sizeof(struct btrfs_header));
-	btrfs_set_header_bytenr(right, right->start);
-	btrfs_set_header_generation(right, trans->transid);
-	btrfs_set_header_owner(right, root->root_key.objectid);
-	btrfs_set_header_level(right, 0);
-	write_extent_buffer(right, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(right),
-			    BTRFS_FSID_SIZE);
+	mid = (nritems + 1) / 2;
 
-	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(right),
-			    BTRFS_UUID_SIZE);
 	if (mid <= slot) {
 		if (nritems == 1 ||
-		    leaf_space_used(l, mid, nritems - mid) + space_needed >
+		    leaf_space_used(l, mid, nritems - mid) + data_size >
 			BTRFS_LEAF_DATA_SIZE(root)) {
 			if (slot >= nritems) {
-				btrfs_cpu_key_to_disk(&disk_key, ins_key);
-				btrfs_set_header_nritems(right, 0);
-				wret = insert_ptr(trans, root, path,
-						  &disk_key, right->start,
-						  path->slots[1] + 1, 1);
-				if (wret)
-					ret = wret;
-				free_extent_buffer(path->nodes[0]);
-				path->nodes[0] = right;
-				path->slots[0] = 0;
-				path->slots[1] += 1;
-				return ret;
-			}
-			mid = slot;
-			if (mid != nritems &&
-			    leaf_space_used(l, mid, nritems - mid) +
-			    space_needed > BTRFS_LEAF_DATA_SIZE(root)) {
-				double_split = 1;
+				split = 0;
+			} else {
+				mid = slot;
+				if (mid != nritems &&
+				    leaf_space_used(l, mid, nritems - mid) +
+				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
+					split = 2;
+				}
 			}
 		}
 	} else {
-		if (leaf_space_used(l, 0, mid + 1) + space_needed >
+		if (leaf_space_used(l, 0, mid) + data_size >
 			BTRFS_LEAF_DATA_SIZE(root)) {
 			if (!extend && data_size && slot == 0) {
-				btrfs_cpu_key_to_disk(&disk_key, ins_key);
-				btrfs_set_header_nritems(right, 0);
-				wret = insert_ptr(trans, root, path,
-						  &disk_key,
-						  right->start,
-						  path->slots[1], 1);
-				if (wret)
-					ret = wret;
-				free_extent_buffer(path->nodes[0]);
-				path->nodes[0] = right;
-				path->slots[0] = 0;
-				if (path->slots[1] == 0) {
-					wret = fixup_low_keys(trans, root,
-					           path, &disk_key, 1);
-					if (wret)
-						ret = wret;
-				}
-				return ret;
+				split = 0;
 			} else if ((extend || !data_size) && slot == 0) {
 				mid = 1;
 			} else {
 				mid = slot;
 				if (mid != nritems &&
 				    leaf_space_used(l, mid, nritems - mid) +
-				    space_needed > BTRFS_LEAF_DATA_SIZE(root)) {
-					double_split = 1;
+				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
+					split = 2 ;
 				}
 			}
 		}
 	}
-	nritems = nritems - mid;
-	btrfs_set_header_nritems(right, nritems);
-	data_copy_size = btrfs_item_end_nr(l, mid) - leaf_data_end(root, l);
-
-	copy_extent_buffer(right, l, btrfs_item_nr_offset(0),
-			   btrfs_item_nr_offset(mid),
-			   nritems * sizeof(struct btrfs_item));
-
-	copy_extent_buffer(right, l,
-		     btrfs_leaf_data(right) + BTRFS_LEAF_DATA_SIZE(root) -
-		     data_copy_size, btrfs_leaf_data(l) +
-		     leaf_data_end(root, l), data_copy_size);
-
-	rt_data_off = BTRFS_LEAF_DATA_SIZE(root) -
-		      btrfs_item_end_nr(l, mid);
+	
+	if (split == 0)
+		btrfs_cpu_key_to_disk(&disk_key, ins_key);
+	else
+		btrfs_item_key(l, &disk_key, mid);
 
-	for (i = 0; i < nritems; i++) {
-		struct btrfs_item *item = btrfs_item_nr(right, i);
-		u32 ioff = btrfs_item_offset(right, item);
-		btrfs_set_item_offset(right, item, ioff + rt_data_off);
+	right = btrfs_alloc_free_block(trans, root, root->leafsize,
+					root->root_key.objectid,
+					&disk_key, 0, l->start, 0);
+	if (IS_ERR(right)) {
+		BUG_ON(1);
+		return PTR_ERR(right);
 	}
 
-	btrfs_set_header_nritems(l, mid);
-	ret = 0;
-	btrfs_item_key(right, &disk_key, 0);
-	wret = insert_ptr(trans, root, path, &disk_key, right->start,
-			  path->slots[1] + 1, 1);
-	if (wret)
-		ret = wret;
+	memset_extent_buffer(right, 0, 0, sizeof(struct btrfs_header));
+	btrfs_set_header_bytenr(right, right->start);
+	btrfs_set_header_generation(right, trans->transid);
+	btrfs_set_header_owner(right, root->root_key.objectid);
+	btrfs_set_header_level(right, 0);
+	write_extent_buffer(right, root->fs_info->fsid,
+			    (unsigned long)btrfs_header_fsid(right),
+			    BTRFS_FSID_SIZE);
 
-	btrfs_mark_buffer_dirty(right);
-	btrfs_mark_buffer_dirty(l);
-	BUG_ON(path->slots[0] != slot);
+	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
+			    (unsigned long)btrfs_header_chunk_tree_uuid(right),
+			    BTRFS_UUID_SIZE);
 
-	ret = btrfs_update_ref(trans, root, l, right, 0, nritems);
-	BUG_ON(ret);
+	if (split == 0) {
+		if (mid <= slot) {
+			btrfs_set_header_nritems(right, 0);
+			wret = insert_ptr(trans, root, path,
+					  &disk_key, right->start,
+					  path->slots[1] + 1, 1);
+			if (wret)
+				ret = wret;
 
-	if (mid <= slot) {
-		free_extent_buffer(path->nodes[0]);
-		path->nodes[0] = right;
-		path->slots[0] -= mid;
-		path->slots[1] += 1;
-	} else
-		free_extent_buffer(right);
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
+			free_extent_buffer(path->nodes[0]);
+			path->nodes[0] = right;
+			path->slots[0] = 0;
+			if (path->slots[1] == 0) {
+				wret = fixup_low_keys(trans, root,
+						path, &disk_key, 1);
+				if (wret)
+					ret = wret;
+			}
+		}
+		btrfs_mark_buffer_dirty(right);
+		return ret;
+	}
 
-	BUG_ON(path->slots[0] < 0);
+	ret = copy_for_split(trans, root, path, l, right, slot, mid, nritems);
+	BUG_ON(ret);
 
-	if (double_split) {
+	if (split == 2) {
 		BUG_ON(num_doubles != 0);
 		num_doubles++;
 		goto again;
 	}
+
 	return ret;
 }
 
@@ -2580,6 +2644,33 @@ static int del_ptr(struct btrfs_trans_ha
 }
 
 /*
+ * a helper function to delete the leaf pointed to by path->slots[1] and
+ * path->nodes[1].
+ *
+ * This deletes the pointer in path->nodes[1] and frees the leaf
+ * block extent.  zero is returned if it all worked out, < 0 otherwise.
+ *
+ * The path must have already been setup for deleting the leaf, including
+ * all the proper balancing.  path->nodes[1] must be locked.
+ */
+static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_path *path,
+				   struct extent_buffer *leaf)
+{
+	int ret;
+
+	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
+	ret = del_ptr(trans, root, path, 1, path->slots[1]);
+	if (ret)
+		return ret;
+
+	ret = btrfs_free_extent(trans, root, leaf->start, leaf->len,
+				0, root->root_key.objectid, 0, 0);
+	return ret;
+}
+
+/*
  * delete the item at the leaf level in path.  If that empties
  * the leaf, remove it from the tree
  */
@@ -2633,17 +2724,11 @@ int btrfs_del_items(struct btrfs_trans_h
 		if (leaf == root->node) {
 			btrfs_set_header_level(leaf, 0);
 		} else {
-			u64 root_gen = btrfs_header_generation(path->nodes[1]);
 			clean_tree_block(trans, root, leaf);
 			wait_on_tree_block_writeback(root, leaf);
-			wret = del_ptr(trans, root, path, 1, path->slots[1]);
-			if (wret)
-				ret = wret;
-			wret = btrfs_free_extent(trans, root,
-					 leaf->start, leaf->len,
-					 path->nodes[1]->start,
-					 btrfs_header_owner(path->nodes[1]),
-					 root_gen, 0, 1);
+
+			wret = btrfs_del_leaf(trans, root, path, leaf);
+			BUG_ON(ret);
 			if (wret)
 				ret = wret;
 		}
@@ -2680,27 +2765,14 @@ int btrfs_del_items(struct btrfs_trans_h
 			}
 
 			if (btrfs_header_nritems(leaf) == 0) {
-				u64 root_gen;
-				u64 bytenr = leaf->start;
-				u32 blocksize = leaf->len;
-
-				root_gen = btrfs_header_generation(
-							   path->nodes[1]);
-
 				clean_tree_block(trans, root, leaf);
 				wait_on_tree_block_writeback(root, leaf);
 
-				wret = del_ptr(trans, root, path, 1, slot);
-				if (wret)
-					ret = wret;
-
+				path->slots[1] = slot;
+				ret = btrfs_del_leaf(trans, root, path, leaf);
+				BUG_ON(ret);
 				free_extent_buffer(leaf);
-				wret = btrfs_free_extent(trans, root, bytenr,
-					     blocksize, path->nodes[1]->start,
-					     btrfs_header_owner(path->nodes[1]),
-					     root_gen, 0, 1);
-				if (wret)
-					ret = wret;
+
 			} else {
 				btrfs_mark_buffer_dirty(leaf);
 				free_extent_buffer(leaf);
diff -urp btrfs-progs-unstable/ctree.h btrfs-progs-2/ctree.h
--- btrfs-progs-unstable/ctree.h	2009-01-08 08:30:09.754081530 +0800
+++ btrfs-progs-2/ctree.h	2009-05-11 17:06:21.000000000 +0800
@@ -250,6 +250,7 @@ static inline unsigned long btrfs_chunk_
 
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_HEADER_FLAG_WRITTEN (1 << 0)
+#define BTRFS_HEADER_FLAG_RELOC   (1 << 1)
 
 /*
  * every tree block (leaf or node) starts with this header.
@@ -387,34 +388,64 @@ struct btrfs_node {
  * The slots array records the index of the item or block pointer
  * used while walking the tree.
  */
+
 struct btrfs_path {
 	struct extent_buffer *nodes[BTRFS_MAX_LEVEL];
 	int slots[BTRFS_MAX_LEVEL];
+	/* if there is real range locking, this locks field will change */
+	int locks[BTRFS_MAX_LEVEL];
 	int reada;
+	/* keep some upper locks as we walk down */
 	int lowest_level;
 
 	/*
 	 * set by btrfs_split_item, tells search_slot to keep all locks
 	 * and to force calls to keep space in the nodes
 	 */
-	int search_for_split;
+	unsigned int search_for_split:1;
+	unsigned int keep_locks:1;
+	unsigned int skip_locking:1;
+	unsigned int leave_spinning:1;
 };
 
 /*
  * items in the extent btree are used to record the objectid of the
  * owner of the block and the number of references
  */
+
 struct btrfs_extent_item {
-	__le32 refs;
+	__le64 refs;
+	__le64 generation;
+	__le64 flags;
+} __attribute__ ((__packed__));
+
+#define BTRFS_EXTENT_FLAG_DATA		(1ULL << 0)
+#define BTRFS_EXTENT_FLAG_TREE_BLOCK		(1ULL << 1)
+
+/* following flags only apply to tree blocks */
+
+/* tree block is not referenced by its owner tree */
+#define BTRFS_BLOCK_NO_OWNER_REF	(1ULL << 8)
+/* use full backrefs for extent pointers in the block*/
+#define BTRFS_BLOCK_FULL_BACKREF	(1ULL << 9)
+
+struct btrfs_tree_block_info {
+	struct btrfs_disk_key key;
+	u8 level;
 } __attribute__ ((__packed__));
 
-struct btrfs_extent_ref {
+struct btrfs_extent_data_ref {
 	__le64 root;
-	__le64 generation;
 	__le64 objectid;
-	__le32 num_refs;
+	__le64 offset;
+	__le32 count;
+} __attribute__ ((__packed__));
+
+struct btrfs_shared_data_ref {
+	__le32 count;
 } __attribute__ ((__packed__));
 
+
 /* dev extents record free space on individual devices.  The owner
  * field points back to the chunk allocation mapping tree that allocated
  * the extent.  The chunk tree uuid field is a way to double check the owner
@@ -757,7 +788,17 @@ struct btrfs_root {
  * are used, and how many references there are to each block
  */
 #define BTRFS_EXTENT_ITEM_KEY	168
-#define BTRFS_EXTENT_REF_KEY	180
+
+#define BTRFS_TREE_BLOCK_INFO_KEY	174
+
+#define BTRFS_TREE_BLOCK_REF_KEY	180
+
+#define BTRFS_SHARED_BLOCK_REF_KEY	181
+
+#define BTRFS_EXTENT_DATA_REF_KEY	186
+
+#define BTRFS_SHARED_DATA_REF_KEY	187
+
 
 /*
  * block groups give us hints into the extent allocation trees.  Which
@@ -1062,24 +1103,40 @@ static inline u8 *btrfs_dev_extent_chunk
 	return (u8 *)((unsigned long)dev + ptr);
 }
 
-/* struct btrfs_extent_ref */
-BTRFS_SETGET_FUNCS(ref_root, struct btrfs_extent_ref, root, 64);
-BTRFS_SETGET_FUNCS(ref_generation, struct btrfs_extent_ref, generation, 64);
-BTRFS_SETGET_FUNCS(ref_objectid, struct btrfs_extent_ref, objectid, 64);
-BTRFS_SETGET_FUNCS(ref_num_refs, struct btrfs_extent_ref, num_refs, 32);
-
-BTRFS_SETGET_STACK_FUNCS(stack_ref_root, struct btrfs_extent_ref, root, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_generation, struct btrfs_extent_ref,
-			 generation, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_objectid, struct btrfs_extent_ref,
-			 objectid, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_num_refs, struct btrfs_extent_ref,
-			 num_refs, 32);
 
 /* struct btrfs_extent_item */
-BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 32);
-BTRFS_SETGET_STACK_FUNCS(stack_extent_refs, struct btrfs_extent_item,
-			 refs, 32);
+BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 64);
+BTRFS_SETGET_FUNCS(extent_generation, struct btrfs_extent_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(extent_flags, struct btrfs_extent_item, flags, 64);
+
+BTRFS_SETGET_FUNCS(tree_block_level, struct btrfs_tree_block_info, level, 8);
+
+static inline void btrfs_tree_block_key(struct extent_buffer *eb,
+					struct btrfs_tree_block_info *item,
+					struct btrfs_disk_key *key)
+{
+	read_eb_member(eb, item, struct btrfs_tree_block_info, key, key);
+}
+
+static inline void btrfs_set_tree_block_key(struct extent_buffer *eb,
+					    struct btrfs_tree_block_info *item,
+					    struct btrfs_disk_key *key)
+{
+	write_eb_member(eb, item, struct btrfs_tree_block_info, key, key);
+}
+
+BTRFS_SETGET_FUNCS(extent_data_ref_root, struct btrfs_extent_data_ref,
+		   root, 64);
+BTRFS_SETGET_FUNCS(extent_data_ref_objectid, struct btrfs_extent_data_ref,
+		   objectid, 64);
+BTRFS_SETGET_FUNCS(extent_data_ref_offset, struct btrfs_extent_data_ref,
+		   offset, 64);
+BTRFS_SETGET_FUNCS(extent_data_ref_count, struct btrfs_extent_data_ref,
+		   count, 32);
+
+BTRFS_SETGET_FUNCS(shared_data_ref_count, struct btrfs_shared_data_ref,
+		   count, 32);
 
 /* struct btrfs_node */
 BTRFS_SETGET_FUNCS(key_blockptr, struct btrfs_key_ptr, blockptr, 64);
@@ -1515,32 +1572,30 @@ struct btrfs_block_group_cache *btrfs_fi
 						 *hint, u64 search_start,
 						 int data, int owner);
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
-					     struct btrfs_root *root,
-					     u32 blocksize, u64 parent,
-					     u64 root_objectid,
-					     u64 ref_generation,
-					     int level,
-					     u64 hint,
-					     u64 empty_size);
+					struct btrfs_root *root,
+					u32 blocksize, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
+					u64 hint, u64 empty_size);
 int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
 		       u64 num_bytes, u64 parent,
 		       u64 root_objectid, u64 ref_generation,
 		       u64 owner, u64 empty_size, u64 hint_byte,
 		       u64 search_end, struct btrfs_key *ins, int data);
-int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 bytenr,
-			    u64 num_bytes, u32 *refs);
+int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 bytenr,
+			     u64 num_bytes, u64 *refs, u64 *flags);
+int btrfs_update_extent_flags(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      u64 bytenr, u64 num_bytes, u64 flags);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *orig_buf, struct extent_buffer *buf,
-		  u32 *nr_extents);
-int btrfs_update_ref(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root, struct extent_buffer *orig_buf,
-		     struct extent_buffer *buf, int start_slot, int nr);
-int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, u64 bytenr, u64 num_bytes, u64 parent,
-		      u64 root_objectid, u64 ref_generation,
-		      u64 owner_objectid, int pin);
+		  struct extent_buffer *buf, int record_parent);
+int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		  struct extent_buffer *buf, int record_parent);
+int btrfs_free_extent(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root,
+		      u64 bytenr, u64 num_bytes, u64 parent,
+		      u64 root_objectid, u64 owner, u64 offset);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct extent_io_tree *unpin);
diff -urp btrfs-progs-unstable/debug-tree.c btrfs-progs-2/debug-tree.c
--- btrfs-progs-unstable/debug-tree.c	2009-01-08 08:30:09.755082635 +0800
+++ btrfs-progs-2/debug-tree.c	2009-04-22 15:13:09.000000000 +0800
@@ -39,7 +39,7 @@ static void print_extent_leaf(struct btr
 {
 	int i;
 	struct btrfs_item *item;
-	struct btrfs_extent_ref *ref;
+//	struct btrfs_extent_ref *ref;
 	struct btrfs_key key;
 	static u64 last = 0;
 	static u64 last_len = 0;
@@ -55,6 +55,7 @@ static void print_extent_leaf(struct btr
 			last_len = key.offset;
 			last = key.objectid;
 			break;
+#if 0
 		case BTRFS_EXTENT_REF_KEY:
 			ref = btrfs_item_ptr(l, i, struct btrfs_extent_ref);
 			printf("%llu %llu extent back ref root %llu gen %llu "
@@ -66,6 +67,7 @@ static void print_extent_leaf(struct btr
 			       (unsigned long long)btrfs_ref_objectid(l, ref),
 			       (unsigned long)btrfs_ref_num_refs(l, ref));
 			break;
+#endif
 		};
 		fflush(stdout);
 	}
diff -urp btrfs-progs-unstable/disk-io.c btrfs-progs-2/disk-io.c
--- btrfs-progs-unstable/disk-io.c	2009-01-23 06:01:44.069371389 +0800
+++ btrfs-progs-2/disk-io.c	2009-04-22 15:13:09.000000000 +0800
@@ -365,46 +365,19 @@ int btrfs_commit_transaction(struct btrf
 			     struct btrfs_root *root)
 {
 	int ret = 0;
-	struct btrfs_root *new_root = NULL;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	if (root->commit_root == root->node)
 		goto commit_tree;
 
-	new_root = malloc(sizeof(*new_root));
-	if (!new_root)
-		return -ENOMEM;
-	memcpy(new_root, root, sizeof(*new_root));
-	new_root->node = root->commit_root;
+	free_extent_buffer(root->commit_root);
 	root->commit_root = NULL;
 
-	root->root_key.offset = trans->transid;
 	btrfs_set_root_bytenr(&root->root_item, root->node->start);
-	btrfs_set_root_generation(&root->root_item, root->root_key.offset);
+	btrfs_set_root_generation(&root->root_item, trans->transid);
 	root->root_item.level = btrfs_header_level(root->node);
-	ret = btrfs_insert_root(trans, fs_info->tree_root,
-				&root->root_key, &root->root_item);
-	BUG_ON(ret);
-
-	btrfs_set_root_refs(&new_root->root_item, 0);
 	ret = btrfs_update_root(trans, root->fs_info->tree_root,
-				&new_root->root_key, &new_root->root_item);
-	BUG_ON(ret);
-
-	ret = commit_tree_roots(trans, fs_info);
-	BUG_ON(ret);
-	ret = __commit_transaction(trans, root);
-	BUG_ON(ret);
-	write_ctree_super(trans, root);
-	btrfs_finish_extent_commit(trans, fs_info->extent_root,
-			           &fs_info->pinned_extents);
-	btrfs_free_transaction(root, trans);
-	fs_info->running_transaction = NULL;
-
-	trans = btrfs_start_transaction(root, 1);
-	ret = btrfs_drop_snapshot(trans, new_root);
-	BUG_ON(ret);
-	ret = btrfs_del_root(trans, fs_info->tree_root, &new_root->root_key);
+				&root->root_key, &root->root_item);
 	BUG_ON(ret);
 commit_tree:
 	ret = commit_tree_roots(trans, fs_info);
@@ -418,10 +391,6 @@ commit_tree:
 	free_extent_buffer(root->commit_root);
 	root->commit_root = NULL;
 	fs_info->running_transaction = NULL;
-	if (new_root) {
-		free_extent_buffer(new_root->node);
-		free(new_root);
-	}
 	return 0;
 }
 
diff -urp btrfs-progs-unstable/extent-tree.c btrfs-progs-2/extent-tree.c
--- btrfs-progs-unstable/extent-tree.c	2009-01-08 08:30:09.758081132 +0800
+++ btrfs-progs-2/extent-tree.c	2009-05-11 09:41:38.000000000 +0800
@@ -41,13 +41,21 @@ struct pending_extent_op {
 	int type;
 	u64 bytenr;
 	u64 num_bytes;
-	u64 parent;
-	u64 orig_parent;
-	u64 generation;
-	u64 orig_generation;
+	u64 flags;
+	struct btrfs_disk_key key;
 	int level;
 };
 
+static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     u64 root_objectid, u64 generation,
+				     u64 flags, struct btrfs_disk_key *key,
+				     int level, struct btrfs_key *ins);
+static int __free_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 u64 bytenr, u64 num_bytes, u64 parent,
+			 u64 root_objectid, u64 owner_objectid,
+			 u64 owner_offset, int refs_to_drop);
 static int finish_current_insert(struct btrfs_trans_handle *trans, struct
 				 btrfs_root *extent_root);
 static int del_pending_extents(struct btrfs_trans_handle *trans, struct
@@ -503,235 +511,393 @@ found:
  * to the key objectid.
  */
 
-static int noinline lookup_extent_backref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path,
-					  u64 bytenr, u64 parent,
-					  u64 ref_root, u64 ref_generation,
-					  u64 owner_objectid, int del)
+
+static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
+{
+	u32 high_crc = ~(u32)0;
+	u32 low_crc = ~(u32)0;
+	__le64 lenum;
+
+	lenum = cpu_to_le64(root_objectid);
+	high_crc = btrfs_crc32c(high_crc, &lenum, sizeof(lenum));
+	lenum = cpu_to_le64(owner);
+	low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
+	lenum = cpu_to_le64(offset);
+	low_crc = btrfs_crc32c(low_crc, &lenum, sizeof(lenum));
+
+	return ((u64)high_crc << 31) ^ (u64)low_crc;
+}
+
+static int match_extent_data_ref(struct extent_buffer *leaf,
+				 struct btrfs_extent_data_ref *ref,
+				 u64 root_objectid, u64 owner, u64 offset)
+{
+	if (btrfs_extent_data_ref_root(leaf, ref) != root_objectid ||
+	    btrfs_extent_data_ref_objectid(leaf, ref) != owner ||
+	    btrfs_extent_data_ref_offset(leaf, ref) != offset)
+		return 0;
+	return 1;
+}
+
+static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct btrfs_path *path,
+					   u64 bytenr, u64 parent,
+					   u64 root_objectid,
+					   u64 owner, u64 offset)
 {
 	struct btrfs_key key;
-	struct btrfs_extent_ref *ref;
+	struct btrfs_extent_data_ref *ref;
 	struct extent_buffer *leaf;
-	u64 ref_objectid;
+	u32 nritems;
 	int ret;
+	int recow;
+	int err = -ENOENT;
 
 	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_REF_KEY;
-	key.offset = parent;
+	if (parent) {
+		key.type = BTRFS_SHARED_DATA_REF_KEY;
+		key.offset = parent;
+	} else {
+		key.type = BTRFS_EXTENT_DATA_REF_KEY;
+		key.offset = hash_extent_data_ref(root_objectid,
+						  owner, offset);
+	}
+again:
+	recow = 0;
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0) {
+		err = ret;
+		goto fail;
+	}
 
-	ret = btrfs_search_slot(trans, root, &key, path, del ? -1 : 0, 1);
-	if (ret < 0)
-		goto out;
-	if (ret > 0) {
-		ret = -ENOENT;
-		goto out;
+	if (parent) {
+		if (ret > 0)
+			goto fail;
+		return 0;
 	}
 
 	leaf = path->nodes[0];
-	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
-	ref_objectid = btrfs_ref_objectid(leaf, ref);
-	if (btrfs_ref_root(leaf, ref) != ref_root ||
-	    btrfs_ref_generation(leaf, ref) != ref_generation ||
-	    (ref_objectid != owner_objectid &&
-	     ref_objectid != BTRFS_MULTIPLE_OBJECTIDS)) {
-		ret = -EIO;
-		WARN_ON(1);
-		goto out;
+	nritems = btrfs_header_nritems(leaf);
+	while (1) {
+		if (path->slots[0] >= nritems) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				err = ret;
+			if (ret)
+				goto fail;
+
+			leaf = path->nodes[0];
+			nritems = btrfs_header_nritems(leaf);
+			recow = 1;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid != bytenr ||
+		    key.type != BTRFS_EXTENT_DATA_REF_KEY)
+			goto fail;
+		
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_data_ref);
+
+		if (match_extent_data_ref(leaf, ref, root_objectid,
+					  owner, offset)) {
+			if (recow) {
+				btrfs_release_path(root, path);
+				goto again;
+			}
+			err = 0;
+			break;
+		}
+		path->slots[0]++;
 	}
-	ret = 0;
-out:
-	return ret;
+fail:
+	return err;
 }
 
-static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path,
-					  u64 bytenr, u64 parent,
-					  u64 ref_root, u64 ref_generation,
-					  u64 owner_objectid)
+static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct btrfs_path *path,
+					   u64 bytenr, u64 parent,
+					   u64 root_objectid, u64 owner,
+					   u64 offset, int refs_to_add)
 {
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
-	struct btrfs_extent_ref *ref;
+	u32 size;
 	u32 num_refs;
 	int ret;
 
 	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_REF_KEY;
-	key.offset = parent;
+	if (parent) {
+		key.type = BTRFS_SHARED_DATA_REF_KEY;
+		key.offset = parent;
+		size = sizeof(struct btrfs_shared_data_ref);
+	} else {
+		key.type = BTRFS_EXTENT_DATA_REF_KEY;
+		key.offset = hash_extent_data_ref(root_objectid,
+						  owner, offset);
+		size = sizeof(struct btrfs_extent_data_ref);
+	}
 
-	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(*ref));
-	if (ret == 0) {
-		leaf = path->nodes[0];
-		ref = btrfs_item_ptr(leaf, path->slots[0],
-				     struct btrfs_extent_ref);
-		btrfs_set_ref_root(leaf, ref, ref_root);
-		btrfs_set_ref_generation(leaf, ref, ref_generation);
-		btrfs_set_ref_objectid(leaf, ref, owner_objectid);
-		btrfs_set_ref_num_refs(leaf, ref, 1);
-	} else if (ret == -EEXIST) {
-		u64 existing_owner;
-		BUG_ON(owner_objectid < BTRFS_FIRST_FREE_OBJECTID);
-		leaf = path->nodes[0];
+	ret = btrfs_insert_empty_item(trans, root, path, &key, size);
+	if (ret && ret != -EEXIST)
+		goto fail;
+
+	leaf = path->nodes[0];
+	if (parent) {
+		struct btrfs_shared_data_ref *ref;
 		ref = btrfs_item_ptr(leaf, path->slots[0],
-				     struct btrfs_extent_ref);
-		if (btrfs_ref_root(leaf, ref) != ref_root ||
-		    btrfs_ref_generation(leaf, ref) != ref_generation) {
-			ret = -EIO;
-			WARN_ON(1);
-			goto out;
+				     struct btrfs_shared_data_ref);
+		if (ret == 0) {
+			btrfs_set_shared_data_ref_count(leaf, ref, refs_to_add);
+		} else {
+			num_refs = btrfs_shared_data_ref_count(leaf, ref);
+			num_refs += refs_to_add;
+			btrfs_set_shared_data_ref_count(leaf, ref, num_refs);
 		}
+	} else {
+		struct btrfs_extent_data_ref *ref;
+		while (ret == -EEXIST) {
+			ref = btrfs_item_ptr(leaf, path->slots[0],
+					     struct btrfs_extent_data_ref);
+			if (match_extent_data_ref(leaf, ref, root_objectid,
+						  owner, offset))
+				break;
+			btrfs_release_path(root, path);
 
-		num_refs = btrfs_ref_num_refs(leaf, ref);
-		BUG_ON(num_refs == 0);
-		btrfs_set_ref_num_refs(leaf, ref, num_refs + 1);
-
-		existing_owner = btrfs_ref_objectid(leaf, ref);
-		if (existing_owner != owner_objectid &&
-		    existing_owner != BTRFS_MULTIPLE_OBJECTIDS) {
-			btrfs_set_ref_objectid(leaf, ref,
-					BTRFS_MULTIPLE_OBJECTIDS);
+			key.offset++;
+			ret = btrfs_insert_empty_item(trans, root, path, &key,
+						      size);
+			if (ret && ret != -EEXIST)
+				goto fail;
+
+			leaf = path->nodes[0];
+		}
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_data_ref);
+		if (ret == 0) {
+			btrfs_set_extent_data_ref_root(leaf, ref,
+						       root_objectid);
+			btrfs_set_extent_data_ref_objectid(leaf, ref, owner);
+			btrfs_set_extent_data_ref_offset(leaf, ref, offset);
+			btrfs_set_extent_data_ref_count(leaf, ref, refs_to_add);
+		} else {
+			num_refs = btrfs_extent_data_ref_count(leaf, ref);
+			num_refs += refs_to_add;
+			btrfs_set_extent_data_ref_count(leaf, ref, num_refs);
 		}
-		ret = 0;
-	} else {
-		goto out;
 	}
-	btrfs_mark_buffer_dirty(path->nodes[0]);
-out:
+	btrfs_mark_buffer_dirty(leaf);
+	ret = 0;
+fail:
 	btrfs_release_path(root, path);
 	return ret;
 }
 
-static int noinline remove_extent_backref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path)
+static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct btrfs_path *path,
+					   int refs_to_drop)
 {
+	struct btrfs_key key;
+	struct btrfs_extent_data_ref *ref1 = NULL;
+	struct btrfs_shared_data_ref *ref2 = NULL;
 	struct extent_buffer *leaf;
-	struct btrfs_extent_ref *ref;
-	u32 num_refs;
+	u32 num_refs = 0;
 	int ret = 0;
 
 	leaf = path->nodes[0];
-	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
-	num_refs = btrfs_ref_num_refs(leaf, ref);
-	BUG_ON(num_refs == 0);
-	num_refs -= 1;
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+	if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
+		ref1 = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_extent_data_ref);
+		num_refs = btrfs_extent_data_ref_count(leaf, ref1);
+	} else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
+		ref2 = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_shared_data_ref);
+		num_refs = btrfs_shared_data_ref_count(leaf, ref2);
+	} else {
+		BUG();
+	}
+
+	BUG_ON(num_refs < refs_to_drop);
+	num_refs -= refs_to_drop;
+
 	if (num_refs == 0) {
 		ret = btrfs_del_item(trans, root, path);
 	} else {
-		btrfs_set_ref_num_refs(leaf, ref, num_refs);
+		if (key.type == BTRFS_EXTENT_DATA_REF_KEY)
+			btrfs_set_extent_data_ref_count(leaf, ref1, num_refs);
+		else
+			btrfs_set_shared_data_ref_count(leaf, ref2, num_refs);
+
 		btrfs_mark_buffer_dirty(leaf);
 	}
-	btrfs_release_path(root, path);
 	return ret;
 }
 
-static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root, u64 bytenr,
-				     u64 orig_parent, u64 parent,
-				     u64 orig_root, u64 ref_root,
-				     u64 orig_generation, u64 ref_generation,
-				     u64 owner_objectid)
+static noinline u32 extent_data_ref_count(struct btrfs_root *root,
+					  struct btrfs_path *path)
 {
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	u32 num_refs = 0;
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+	if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
+		struct btrfs_extent_data_ref *ref1;
+		ref1 = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_extent_data_ref);
+		num_refs = btrfs_extent_data_ref_count(leaf, ref1);
+	} else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
+		struct btrfs_shared_data_ref *ref2;
+		ref2 = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_shared_data_ref);
+		num_refs = btrfs_shared_data_ref_count(leaf, ref2);
+	} else {
+		BUG();
+	}
+	return num_refs;
+}
+
+static noinline int lookup_tree_block_ref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path,
+					  u64 bytenr, u64 parent,
+					  u64 root_objectid)
+{
+	struct btrfs_key key;
 	int ret;
-	struct btrfs_root *extent_root = root->fs_info->extent_root;
-	struct btrfs_path *path;
 
-	if (root == root->fs_info->extent_root) {
-		struct pending_extent_op *extent_op;
-		u64 num_bytes;
+	key.objectid = bytenr;
+	if (parent) {
+		key.type = BTRFS_SHARED_BLOCK_REF_KEY;
+		key.offset = parent;
+	} else {
+		key.type = BTRFS_TREE_BLOCK_REF_KEY;
+		key.offset = root_objectid;
+	}
 
-		BUG_ON(owner_objectid >= BTRFS_MAX_LEVEL);
-		num_bytes = btrfs_level_size(root, (int)owner_objectid);
-		if (test_range_bit(&root->fs_info->extent_ins, bytenr,
-				bytenr + num_bytes - 1, EXTENT_LOCKED, 0)) {
-			u64 priv;
-			ret = get_state_private(&root->fs_info->extent_ins,
-						bytenr, &priv);
-			BUG_ON(ret);
-			extent_op = (struct pending_extent_op *)
-							(unsigned long)priv;
-			BUG_ON(extent_op->parent != orig_parent);
-			BUG_ON(extent_op->generation != orig_generation);
-			extent_op->parent = parent;
-			extent_op->generation = ref_generation;
-		} else {
-			extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
-			BUG_ON(!extent_op);
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	return ret;
+}
 
-			extent_op->type = PENDING_BACKREF_UPDATE;
-			extent_op->bytenr = bytenr;
-			extent_op->num_bytes = num_bytes;
-			extent_op->parent = parent;
-			extent_op->orig_parent = orig_parent;
-			extent_op->generation = ref_generation;
-			extent_op->orig_generation = orig_generation;
-			extent_op->level = (int)owner_objectid;
-
-			set_extent_bits(&root->fs_info->extent_ins,
-					bytenr, bytenr + num_bytes - 1,
-					EXTENT_LOCKED, GFP_NOFS);
-			set_state_private(&root->fs_info->extent_ins,
-					  bytenr, (unsigned long)extent_op);
-		}
-		return 0;
+static noinline int insert_tree_block_ref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path,
+					  u64 bytenr, u64 parent,
+					  u64 root_objectid)
+{
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = bytenr;
+	if (parent) {
+		key.type = BTRFS_SHARED_BLOCK_REF_KEY;
+		key.offset = parent;
+	} else {
+		key.type = BTRFS_TREE_BLOCK_REF_KEY;
+		key.offset = root_objectid;
 	}
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-	ret = lookup_extent_backref(trans, extent_root, path,
-				    bytenr, orig_parent, orig_root,
-				    orig_generation, owner_objectid, 1);
-	if (ret)
-		goto out;
-	ret = remove_extent_backref(trans, extent_root, path);
-	if (ret)
-		goto out;
-	ret = insert_extent_backref(trans, extent_root, path, bytenr,
-				    parent, ref_root, ref_generation,
-				    owner_objectid);
-	BUG_ON(ret);
-	finish_current_insert(trans, extent_root);
-	del_pending_extents(trans, extent_root);
-out:
-	btrfs_free_path(path);
+	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
+
+	btrfs_release_path(root, path);
 	return ret;
 }
 
-int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 bytenr,
-			    u64 orig_parent, u64 parent,
-			    u64 ref_root, u64 ref_generation,
-			    u64 owner_objectid)
+
+static noinline int remove_tree_block_info(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct btrfs_path *path, u64 bytenr)
 {
+	struct btrfs_key key;
 	int ret;
-	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
-	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
-		return 0;
-	maybe_lock_mutex(root);
-	ret = __btrfs_update_extent_ref(trans, root, bytenr, orig_parent,
-					parent, ref_root, ref_root,
-					ref_generation, ref_generation,
-					owner_objectid);
-	maybe_unlock_mutex(root);
+
+	key.objectid = bytenr;
+	key.type = BTRFS_TREE_BLOCK_INFO_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret == 0)
+		ret = btrfs_del_item(trans, root, path);
+
+	btrfs_release_path(root, path);
 	return ret;
 }
 
-static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root, u64 bytenr,
-				  u64 orig_parent, u64 parent,
-				  u64 orig_root, u64 ref_root,
-				  u64 orig_generation, u64 ref_generation,
-				  u64 owner_objectid)
+static int lookup_extent_backref(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 u64 bytenr, u64 parent, u64 root_objectid,
+				 u64 owner, u64 offset)
+{
+	int ret;
+	if (owner >= BTRFS_FIRST_FREE_OBJECTID) {
+		ret = lookup_extent_data_ref(trans, root, path, bytenr, parent,
+					     root_objectid, owner, offset);
+	} else {
+		ret = lookup_tree_block_ref(trans, root, path, bytenr, parent,
+					    root_objectid);
+	}
+	return ret;
+}
+
+static int insert_extent_backref(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 u64 bytenr, u64 parent, u64 root_objectid,
+				 u64 owner, u64 offset, int refs_to_add)
+{
+	int ret;
+
+	if (owner >= BTRFS_FIRST_FREE_OBJECTID) {
+		ret = insert_extent_data_ref(trans, root, path, bytenr,
+					     parent, root_objectid,
+					     owner, offset, refs_to_add);
+	} else {
+		BUG_ON(refs_to_add != 1);
+		ret = insert_tree_block_ref(trans, root, path, bytenr,
+					    parent, root_objectid);
+	}
+	return ret;
+}
+
+static int remove_extent_backref(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 int refs_to_drop, int is_data)
 {
-	struct btrfs_path *path;
 	int ret;
+	if (is_data) {
+		ret = remove_extent_data_ref(trans, root, path, refs_to_drop);
+	} else {
+		BUG_ON(refs_to_drop != 1);
+		ret = btrfs_del_item(trans, root, path);
+	}
+	return ret;
+}
+
+int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 u64 bytenr, u64 num_bytes, u64 parent,
+			 u64 root_objectid, u64 owner, u64 offset)
+{
 	struct btrfs_key key;
+	struct btrfs_path *path;
 	struct extent_buffer *l;
 	struct btrfs_extent_item *item;
-	u32 refs;
+	u64 refs;
+	int ret;
+	int err = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -740,59 +906,56 @@ static int __btrfs_inc_extent_ref(struct
 	path->reada = 1;
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
-	key.offset = (u64)-1;
+	key.offset = num_bytes;
 
-	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
-				0, 1);
-	if (ret < 0)
-		return ret;
-	BUG_ON(ret == 0 || path->slots[0] == 0);
+	/* first find the extent item and update its reference count */
+	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key,
+				path, 0, 1);
+	if (ret < 0) {
+		err = ret;
+		goto out;
+	}
 
-	path->slots[0]--;
+	if (ret > 0) {
+		WARN_ON(1);
+		err = -EIO;
+		goto out;
+	}
 	l = path->nodes[0];
 
 	btrfs_item_key_to_cpu(l, &key, path->slots[0]);
-	BUG_ON(key.objectid != bytenr);
+	if (key.objectid != bytenr) {
+		btrfs_print_leaf(root->fs_info->extent_root, path->nodes[0]);
+		printk(KERN_ERR "btrfs wanted %llu found %llu\n",
+		       (unsigned long long)bytenr,
+		       (unsigned long long)key.objectid);
+		BUG();
+	}
 	BUG_ON(key.type != BTRFS_EXTENT_ITEM_KEY);
 
 	item = btrfs_item_ptr(l, path->slots[0], struct btrfs_extent_item);
+
 	refs = btrfs_extent_refs(l, item);
 	btrfs_set_extent_refs(l, item, refs + 1);
+
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 
 	btrfs_release_path(root->fs_info->extent_root, path);
 
 	path->reada = 1;
+
+	/* now insert the actual backref */
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
-				    path, bytenr, parent,
-				    ref_root, ref_generation,
-				    owner_objectid);
+				    path, bytenr, 0, root_objectid,
+				    owner, offset, 1);
 	BUG_ON(ret);
 	finish_current_insert(trans, root->fs_info->extent_root);
 	del_pending_extents(trans, root->fs_info->extent_root);
-
+out:
 	btrfs_free_path(path);
 	return 0;
 }
 
-int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 ref_root, u64 ref_generation,
-			 u64 owner_objectid)
-{
-	int ret;
-	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
-	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
-		return 0;
-	maybe_lock_mutex(root);
-	ret = __btrfs_inc_extent_ref(trans, root, bytenr, 0, parent,
-				     0, ref_root, 0, ref_generation,
-				     owner_objectid);
-	maybe_unlock_mutex(root);
-	return ret;
-}
-
 int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root)
 {
@@ -801,9 +964,9 @@ int btrfs_extent_post_op(struct btrfs_tr
 	return 0;
 }
 
-int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 bytenr,
-			    u64 num_bytes, u32 *refs)
+int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 bytenr,
+			     u64 num_bytes, u64 *refs, u64 *flags)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -828,48 +991,86 @@ int btrfs_lookup_extent_ref(struct btrfs
 	}
 	l = path->nodes[0];
 	item = btrfs_item_ptr(l, path->slots[0], struct btrfs_extent_item);
-	*refs = btrfs_extent_refs(l, item);
+	if (refs)
+		*refs = btrfs_extent_refs(l, item);
+	if (flags)
+		*flags = btrfs_extent_flags(l, item);
 out:
 	btrfs_free_path(path);
 	return 0;
 }
 
-int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *orig_buf, struct extent_buffer *buf,
-		  u32 *nr_extents)
+int btrfs_update_extent_flags(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      u64 bytenr, u64 num_bytes, u64 flags)
+{
+	struct btrfs_path *path;
+	int ret;
+	struct btrfs_key key;
+	struct extent_buffer *l;
+	struct btrfs_extent_item *item;
+
+	WARN_ON(num_bytes < root->sectorsize);
+	path = btrfs_alloc_path();
+	path->reada = 1;
+	key.objectid = bytenr;
+	key.offset = num_bytes;
+	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
+	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
+				0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret != 0) {
+		btrfs_print_leaf(root, path->nodes[0]);
+		printk("failed to find block number %Lu\n", bytenr);
+		BUG();
+	}
+	l = path->nodes[0];
+	item = btrfs_item_ptr(l, path->slots[0], struct btrfs_extent_item);
+	btrfs_set_extent_flags(l, item, flags);
+
+	finish_current_insert(trans, root->fs_info->extent_root);
+	del_pending_extents(trans, root->fs_info->extent_root);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct extent_buffer *buf,
+			   int record_parent, int inc)
 {
 	u64 bytenr;
+	u64 num_bytes;
+	u64 parent;
 	u64 ref_root;
-	u64 orig_root;
-	u64 ref_generation;
-	u64 orig_generation;
 	u32 nritems;
-	u32 nr_file_extents = 0;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
 	int i;
 	int level;
 	int ret = 0;
 	int faili = 0;
-	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64, u64, u64);
+	int (*process_func)(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    u64, u64, u64, u64, u64, u64);
+
+	BUG_ON(!root->ref_cows);
+
+	if (inc)
+		process_func = btrfs_inc_extent_ref;
+	else
+		process_func = btrfs_free_extent;
 
 	ref_root = btrfs_header_owner(buf);
-	ref_generation = btrfs_header_generation(buf);
-	orig_root = btrfs_header_owner(orig_buf);
-	orig_generation = btrfs_header_generation(orig_buf);
-
 	nritems = btrfs_header_nritems(buf);
 	level = btrfs_header_level(buf);
 
-	if (root->ref_cows) {
-		process_func = __btrfs_inc_extent_ref;
-	} else {
-		if (level == 0 &&
-		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
-			goto out;
-		process_func = __btrfs_update_extent_ref;
-	}
+	if (record_parent)
+		parent = buf->start;
+	else
+		parent = 0;
 
 	for (i = 0; i < nritems; i++) {
 		cond_resched();
@@ -885,17 +1086,12 @@ int btrfs_inc_ref(struct btrfs_trans_han
 			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
 			if (bytenr == 0)
 				continue;
-
-			nr_file_extents++;
-
-			maybe_lock_mutex(root);
-			ret = process_func(trans, root, bytenr,
-					   orig_buf->start, buf->start,
-					   orig_root, ref_root,
-					   orig_generation, ref_generation,
-					   key.objectid);
-			maybe_unlock_mutex(root);
-
+			
+			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
+			key.offset -= btrfs_file_extent_offset(buf, fi);
+			ret = process_func(trans, root, bytenr, num_bytes,
+					   parent, ref_root, key.objectid,
+					   key.offset);
 			if (ret) {
 				faili = i;
 				WARN_ON(1);
@@ -903,13 +1099,9 @@ int btrfs_inc_ref(struct btrfs_trans_han
 			}
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
-			maybe_lock_mutex(root);
-			ret = process_func(trans, root, bytenr,
-					   orig_buf->start, buf->start,
-					   orig_root, ref_root,
-					   orig_generation, ref_generation,
-					   level - 1);
-			maybe_unlock_mutex(root);
+			num_bytes = btrfs_level_size(root, level - 1);
+			ret = process_func(trans, root, bytenr, num_bytes,
+					   parent, ref_root, level - 1, 0);
 			if (ret) {
 				faili = i;
 				WARN_ON(1);
@@ -917,13 +1109,6 @@ int btrfs_inc_ref(struct btrfs_trans_han
 			}
 		}
 	}
-out:
-	if (nr_extents) {
-		if (level == 0)
-			*nr_extents = nr_file_extents;
-		else
-			*nr_extents = nritems;
-	}
 	return 0;
 fail:
 	WARN_ON(1);
@@ -957,79 +1142,16 @@ fail:
 	return ret;
 }
 
-int btrfs_update_ref(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root, struct extent_buffer *orig_buf,
-		     struct extent_buffer *buf, int start_slot, int nr)
-
+int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		  struct extent_buffer *buf, int record_parent)
 {
-	u64 bytenr;
-	u64 ref_root;
-	u64 orig_root;
-	u64 ref_generation;
-	u64 orig_generation;
-	struct btrfs_key key;
-	struct btrfs_file_extent_item *fi;
-	int i;
-	int ret;
-	int slot;
-	int level;
-
-	BUG_ON(start_slot < 0);
-	BUG_ON(start_slot + nr > btrfs_header_nritems(buf));
-
-	ref_root = btrfs_header_owner(buf);
-	ref_generation = btrfs_header_generation(buf);
-	orig_root = btrfs_header_owner(orig_buf);
-	orig_generation = btrfs_header_generation(orig_buf);
-	level = btrfs_header_level(buf);
-
-	if (!root->ref_cows) {
-		if (level == 0 &&
-		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
-			return 0;
-	}
-
-	for (i = 0, slot = start_slot; i < nr; i++, slot++) {
-		cond_resched();
-		if (level == 0) {
-			btrfs_item_key_to_cpu(buf, &key, slot);
-			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
-				continue;
-			fi = btrfs_item_ptr(buf, slot,
-					    struct btrfs_file_extent_item);
-			if (btrfs_file_extent_type(buf, fi) ==
-			    BTRFS_FILE_EXTENT_INLINE)
-				continue;
-			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
-			if (bytenr == 0)
-				continue;
+	return __btrfs_mod_ref(trans, root, buf, record_parent, 1);
+}
 
-			maybe_lock_mutex(root);
-			ret = __btrfs_update_extent_ref(trans, root, bytenr,
-					    orig_buf->start, buf->start,
-					    orig_root, ref_root,
-					    orig_generation, ref_generation,
-					    key.objectid);
-			maybe_unlock_mutex(root);
-			if (ret)
-				goto fail;
-		} else {
-			bytenr = btrfs_node_blockptr(buf, slot);
-			maybe_lock_mutex(root);
-			ret = __btrfs_update_extent_ref(trans, root, bytenr,
-					    orig_buf->start, buf->start,
-					    orig_root, ref_root,
-					    orig_generation, ref_generation,
-					    level - 1);
-			maybe_unlock_mutex(root);
-			if (ret)
-				goto fail;
-		}
-	}
-	return 0;
-fail:
-	WARN_ON(1);
-	return -1;
+int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		  struct extent_buffer *buf, int record_parent)
+{
+	return __btrfs_mod_ref(trans, root, buf, record_parent, 0);
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
@@ -1224,6 +1346,22 @@ static int update_block_group(struct btr
 	u64 start;
 	u64 end;
 
+	/* block accounting for super block */
+	old_val = btrfs_super_bytes_used(&info->super_copy);
+	if (alloc)
+		old_val += num_bytes;
+	else
+		old_val -= num_bytes;
+	btrfs_set_super_bytes_used(&info->super_copy, old_val);
+
+	/* block accounting for root item */
+	old_val = btrfs_root_used(&root->root_item);
+	if (alloc)
+		old_val += num_bytes;
+	else
+		old_val -= num_bytes;
+	btrfs_set_root_used(&root->root_item, old_val);
+
 	while(total) {
 		cache = btrfs_lookup_block_group(info, bytenr);
 		if (!cache) {
@@ -1340,14 +1478,10 @@ static int finish_current_insert(struct 
 	u64 priv;
 	struct btrfs_fs_info *info = extent_root->fs_info;
 	struct btrfs_path *path;
-	struct btrfs_extent_ref *ref;
 	struct pending_extent_op *extent_op;
 	struct btrfs_key key;
-	struct btrfs_extent_item extent_item;
 	int ret;
-	int err = 0;
 
-	btrfs_set_stack_extent_refs(&extent_item, 1);
 	path = btrfs_alloc_path();
 
 	while(1) {
@@ -1364,45 +1498,18 @@ static int finish_current_insert(struct 
 			key.objectid = start;
 			key.offset = end + 1 - start;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
-			err = btrfs_insert_item(trans, extent_root, &key,
-					&extent_item, sizeof(extent_item));
-			BUG_ON(err);
-
-			clear_extent_bits(&info->extent_ins, start, end,
-					  EXTENT_LOCKED, GFP_NOFS);
-
-			err = insert_extent_backref(trans, extent_root, path,
-						start, extent_op->parent,
+			ret = alloc_reserved_tree_block(trans, extent_root,
 						extent_root->root_key.objectid,
-						extent_op->generation,
-						extent_op->level);
-			BUG_ON(err);
-		} else if (extent_op->type == PENDING_BACKREF_UPDATE) {
-			err = lookup_extent_backref(trans, extent_root, path,
-						start, extent_op->orig_parent,
-						extent_root->root_key.objectid,
-						extent_op->orig_generation,
-						extent_op->level, 0);
-			BUG_ON(err);
-
-			clear_extent_bits(&info->extent_ins, start, end,
-					  EXTENT_LOCKED, GFP_NOFS);
-
-			key.objectid = start;
-			key.offset = extent_op->parent;
-			key.type = BTRFS_EXTENT_REF_KEY;
-			err = btrfs_set_item_key_safe(trans, extent_root, path,
-						      &key);
-			BUG_ON(err);
-			ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
-					     struct btrfs_extent_ref);
-			btrfs_set_ref_generation(path->nodes[0], ref,
-						 extent_op->generation);
-			btrfs_mark_buffer_dirty(path->nodes[0]);
-			btrfs_release_path(extent_root, path);
+						trans->transid,
+						extent_op->flags,
+						&extent_op->key,
+					       	extent_op->level, &key);
 		} else {
 			BUG_ON(1);
 		}
+
+		clear_extent_bits(&info->extent_ins, start, end, EXTENT_LOCKED,
+				  GFP_NOFS);
 		kfree(extent_op);
 	}
 	btrfs_free_path(path);
@@ -1451,46 +1558,48 @@ pinit:
 /*
  * remove an extent from the root, returns 0 on success
  */
-static int __free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
-			 *root, u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 ref_generation,
-			 u64 owner_objectid, int pin, int mark_free)
+static int __free_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 u64 bytenr, u64 num_bytes, u64 parent,
+			 u64 root_objectid, u64 owner_objectid,
+			 u64 owner_offset, int refs_to_drop)
 {
-	struct btrfs_path *path;
 	struct btrfs_key key;
+	struct btrfs_path *path;
 	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_extent_ops *ops = info->extent_ops;
 	struct btrfs_root *extent_root = info->extent_root;
 	struct extent_buffer *leaf;
+	struct btrfs_extent_item *ei;
 	int ret;
+	int is_data;
 	int extent_slot = 0;
 	int found_extent = 0;
 	int num_to_del = 1;
-	struct btrfs_extent_item *ei;
-	u32 refs;
+	u64 refs;
 
-	key.objectid = bytenr;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	key.offset = num_bytes;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
+	path->reada = 1;
+
+	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
+	BUG_ON(!is_data && refs_to_drop != 1);
+
 	ret = lookup_extent_backref(trans, extent_root, path,
 				    bytenr, parent, root_objectid,
-				    ref_generation, owner_objectid, 1);
+				    owner_objectid, owner_offset);
 	if (ret == 0) {
-		struct btrfs_key found_key;
 		extent_slot = path->slots[0];
-		while(extent_slot > 0) {
+		while (extent_slot > 0) {
 			extent_slot--;
-			btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
 					      extent_slot);
-			if (found_key.objectid != bytenr)
+			if (key.objectid != bytenr)
 				break;
-			if (found_key.type == BTRFS_EXTENT_ITEM_KEY &&
-			    found_key.offset == num_bytes) {
+			if (key.type == BTRFS_EXTENT_ITEM_KEY &&
+			    key.offset == num_bytes) {
 				found_extent = 1;
 				break;
 			}
@@ -1498,98 +1607,104 @@ static int __free_extent(struct btrfs_tr
 				break;
 		}
 		if (!found_extent) {
-			ret = remove_extent_backref(trans, extent_root, path);
+			ret = remove_extent_backref(trans, extent_root, path,
+						    refs_to_drop, is_data);
 			BUG_ON(ret);
 			btrfs_release_path(extent_root, path);
+
+			key.objectid = bytenr;
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			key.offset = num_bytes;
+
 			ret = btrfs_search_slot(trans, extent_root,
 						&key, path, -1, 1);
+			if (ret) {
+				printk(KERN_ERR "umm, got %d back from search"
+				       ", was looking for %llu\n", ret,
+				       (unsigned long long)bytenr);
+				btrfs_print_leaf(extent_root, path->nodes[0]);
+			}
 			BUG_ON(ret);
 			extent_slot = path->slots[0];
 		}
 	} else {
 		btrfs_print_leaf(extent_root, path->nodes[0]);
-		printk("Unable to find ref byte nr %llu root %llu "
-		       " gen %llu owner %llu\n",
+		WARN_ON(1);
+		printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
+		       "parent %llu root %llu  owner %llu offset %llu\n",
 		       (unsigned long long)bytenr,
+		       (unsigned long long)parent,
 		       (unsigned long long)root_objectid,
-		       (unsigned long long)ref_generation,
-		       (unsigned long long)owner_objectid);
-		BUG_ON(1);
+		       (unsigned long long)owner_objectid,
+		       (unsigned long long)owner_offset);
 	}
 
 	leaf = path->nodes[0];
 	ei = btrfs_item_ptr(leaf, extent_slot,
 			    struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, ei);
-	BUG_ON(refs == 0);
-	refs -= 1;
-	btrfs_set_extent_refs(leaf, ei, refs);
 
+	/*
+	 * we're not allowed to delete the extent item if there
+	 * are other delayed ref updates pending
+	 */
+
+	BUG_ON(refs < refs_to_drop);
+	refs -= refs_to_drop;
+	btrfs_set_extent_refs(leaf, ei, refs);
 	btrfs_mark_buffer_dirty(leaf);
 
-	if (refs == 0 && found_extent && path->slots[0] == extent_slot + 1) {
-		struct btrfs_extent_ref *ref;
-		ref = btrfs_item_ptr(leaf, path->slots[0],
-				     struct btrfs_extent_ref);
-		BUG_ON(btrfs_ref_num_refs(leaf, ref) != 1);
-		/* if the back ref and the extent are next to each other
-		 * they get deleted below in one shot
-		 */
-		path->slots[0] = extent_slot;
-		num_to_del = 2;
-	} else if (found_extent) {
-		/* otherwise delete the extent back ref */
-		ret = remove_extent_backref(trans, extent_root, path);
-		BUG_ON(ret);
-		/* if refs are 0, we need to setup the path for deletion */
+	if (found_extent) {
 		if (refs == 0) {
-			btrfs_release_path(extent_root, path);
-			ret = btrfs_search_slot(trans, extent_root, &key, path,
-						-1, 1);
-			if (ret < 0)
-				return ret;
+			if (is_data) {
+				BUG_ON(refs_to_drop !=
+				       extent_data_ref_count(root, path));
+				num_to_del = 2;
+			} else {
+				BUG_ON(path->slots[0] != extent_slot + 2);
+				btrfs_item_key_to_cpu(leaf, &key,
+						      extent_slot + 1);
+				BUG_ON(key.type != BTRFS_TREE_BLOCK_INFO_KEY);
+				num_to_del = 3;
+			}
+			path->slots[0] = extent_slot;
+		} else {
+			ret = remove_extent_backref(trans, extent_root, path,
+						    refs_to_drop, is_data);
 			BUG_ON(ret);
 		}
+	} else {
+		if (refs == 0 && !is_data &&
+		    path->slots[0] < btrfs_header_nritems(leaf) - 1) {
+			btrfs_item_key_to_cpu(leaf, &key, path->slots[0] + 1);
+			BUG_ON(key.objectid != bytenr ||
+			       key.type != BTRFS_TREE_BLOCK_INFO_KEY);
+			num_to_del = 2;
+		}
 	}
 
 	if (refs == 0) {
-		u64 super_used;
-		u64 root_used;
-
+		int mark_free = 0;
 
+		ret = pin_down_bytes(trans, root, bytenr, num_bytes, is_data);
+		if (ret > 0)
+			mark_free = 1;
+		BUG_ON(ret < 0);
 
-		/* block accounting for super block */
-		super_used = btrfs_super_bytes_used(&info->super_copy);
-		btrfs_set_super_bytes_used(&info->super_copy,
-					   super_used - num_bytes);
-
-		/* block accounting for root item */
-		root_used = btrfs_root_used(&root->root_item);
-		btrfs_set_root_used(&root->root_item,
-					   root_used - num_bytes);
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
-		if (ret)
-			return ret;
-
-		if (ops && ops->free_extent) {
-			ret = ops->free_extent(root, bytenr, num_bytes);
-			if (ret > 0) {
-				pin = 0;
-				mark_free = 0;
-			}
-		}
-
-		if (pin) {
-			ret = pin_down_bytes(trans, root, bytenr, num_bytes, 0);
-			if (ret > 0)
-				mark_free = 1;
-			BUG_ON(ret < 0);
-		}
+		BUG_ON(ret);
+		btrfs_release_path(extent_root, path);
 
-		if (owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
+		if (is_data) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			BUG_ON(ret);
+		} else {
+			if (num_to_del == 1) {
+				ret = remove_tree_block_info(trans, extent_root,
+							     path, bytenr);
+				BUG_ON(ret);
+			}
 		}
 
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
@@ -1610,7 +1725,6 @@ static int del_pending_extents(struct bt
 {
 	int ret;
 	int err = 0;
-	int mark_free = 0;
 	u64 start;
 	u64 end;
 	u64 priv;
@@ -1634,18 +1748,12 @@ static int del_pending_extents(struct bt
 		clear_extent_bits(pending_del, start, end, EXTENT_LOCKED,
 				  GFP_NOFS);
 
-		ret = pin_down_bytes(trans, extent_root, start,
-				     end + 1 - start, 0);
-		mark_free = ret > 0;
 		if (!test_range_bit(extent_ins, start, end,
 				    EXTENT_LOCKED, 0)) {
-free_extent:
 			ret = __free_extent(trans, extent_root,
-					    start, end + 1 - start,
-					    extent_op->orig_parent,
+					    start, end + 1 - start, 0,
 					    extent_root->root_key.objectid,
-					    extent_op->orig_generation,
-					    extent_op->level, 0, mark_free);
+					    extent_op->level, 0, 1);
 			kfree(extent_op);
 		} else {
 			kfree(extent_op);
@@ -1658,11 +1766,8 @@ free_extent:
 					  EXTENT_LOCKED, GFP_NOFS);
 
 			if (extent_op->type == PENDING_BACKREF_UPDATE)
-				goto free_extent;
+				BUG_ON(1);
 
-			ret = update_block_group(trans, extent_root, start,
-						end + 1 - start, 0, mark_free);
-			BUG_ON(ret);
 			kfree(extent_op);
 		}
 		if (ret)
@@ -1674,10 +1779,11 @@ free_extent:
 /*
  * remove an extent from the root, returns 0 on success
  */
-int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, u64 bytenr, u64 num_bytes, u64 parent,
-		      u64 root_objectid, u64 ref_generation,
-		      u64 owner_objectid, int pin)
+
+int btrfs_free_extent(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root,
+		      u64 bytenr, u64 num_bytes, u64 parent,
+		      u64 root_objectid, u64 owner, u64 offset)
 {
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	int pending_ret;
@@ -1693,11 +1799,7 @@ int btrfs_free_extent(struct btrfs_trans
 		extent_op->type = PENDING_EXTENT_DELETE;
 		extent_op->bytenr = bytenr;
 		extent_op->num_bytes = num_bytes;
-		extent_op->parent = parent;
-		extent_op->orig_parent = parent;
-		extent_op->generation = ref_generation;
-		extent_op->orig_generation = ref_generation;
-		extent_op->level = (int)owner_objectid;
+		extent_op->level = (int)owner;
 
 		set_extent_bits(&root->fs_info->pending_del,
 				bytenr, bytenr + num_bytes - 1,
@@ -1707,8 +1809,7 @@ int btrfs_free_extent(struct btrfs_trans
 		return 0;
 	}
 	ret = __free_extent(trans, root, bytenr, num_bytes, parent,
-			    root_objectid, ref_generation,
-			    owner_objectid, pin, pin == 0);
+			    root_objectid, owner, offset, 1);
 	pending_ret = del_pending_extents(trans, root->fs_info->extent_root);
 	return ret ? ret : pending_ret;
 }
@@ -1835,32 +1936,17 @@ new_group:
 error:
 	return ret;
 }
-/*
- * finds a free extent and does all the dirty work required for allocation
- * returns the key for the extent through ins, and a tree buffer for
- * the first block of the extent through buf.
- *
- * returns 0 if everything worked, non-zero otherwise.
- */
-int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
-		       u64 num_bytes, u64 parent,
-		       u64 root_objectid, u64 ref_generation,
-		       u64 owner, u64 empty_size, u64 hint_byte,
-		       u64 search_end, struct btrfs_key *ins, int data)
+
+static int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				u64 num_bytes, u64 empty_size,
+				u64 hint_byte, u64 search_end,
+				struct btrfs_key *ins, int data)
 {
 	int ret;
-	int pending_ret;
-	u64 super_used, root_used;
 	u64 search_start = 0;
 	u64 alloc_profile;
-	u32 sizes[2];
 	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_root *extent_root = info->extent_root;
-	struct btrfs_path *path;
-	struct btrfs_extent_item *extent_item;
-	struct btrfs_extent_ref *ref;
-	struct btrfs_key keys[2];
 
 	if (info->extent_ops) {
 		struct btrfs_extent_ops *ops = info->extent_ops;
@@ -1903,100 +1989,113 @@ int btrfs_alloc_extent(struct btrfs_tran
 			       trans->alloc_exclude_nr, data);
 	BUG_ON(ret);
 found:
-	if (ret)
-		return ret;
-
-	if (parent == 0)
-		parent = ins->objectid;
-
-	/* block accounting for super block */
-	super_used = btrfs_super_bytes_used(&info->super_copy);
-	btrfs_set_super_bytes_used(&info->super_copy, super_used + num_bytes);
-
-	/* block accounting for root item */
-	root_used = btrfs_root_used(&root->root_item);
-	btrfs_set_root_used(&root->root_item, root_used + num_bytes);
-
 	clear_extent_dirty(&root->fs_info->free_space_cache,
 			   ins->objectid, ins->objectid + ins->offset - 1,
 			   GFP_NOFS);
+	return ret;
+}
 
-	if (root == extent_root) {
-		struct pending_extent_op *extent_op;
-
-		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
-		BUG_ON(!extent_op);
-
-		extent_op->type = PENDING_EXTENT_INSERT;
-		extent_op->bytenr = ins->objectid;
-		extent_op->num_bytes = ins->offset;
-		extent_op->parent = parent;
-		extent_op->orig_parent = 0;
-		extent_op->generation = ref_generation;
-		extent_op->orig_generation = 0;
-		extent_op->level = (int)owner;
-
-		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
-				ins->objectid + ins->offset - 1,
-				EXTENT_LOCKED, GFP_NOFS);
-		set_state_private(&root->fs_info->extent_ins,
-				  ins->objectid, (unsigned long)extent_op);
-		goto update_block;
-	}
-
-	WARN_ON(trans->alloc_exclude_nr);
-	trans->alloc_exclude_start = ins->objectid;
-	trans->alloc_exclude_nr = ins->offset;
+static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     u64 root_objectid, u64 generation,
+				     u64 flags, struct btrfs_disk_key *key,
+				     int level, struct btrfs_key *ins)
+{
+	int ret;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_extent_item *extent_item;
+	struct btrfs_tree_block_info *block_info;
+	struct btrfs_path *path;
+	struct btrfs_key keys[3];
+	u32 sizes[3];
 
 	memcpy(&keys[0], ins, sizeof(*ins));
 	keys[1].objectid = ins->objectid;
-	keys[1].type = BTRFS_EXTENT_REF_KEY;
-	keys[1].offset = parent;
+	keys[1].type = BTRFS_TREE_BLOCK_INFO_KEY;
+	keys[1].offset = 0;
+	keys[2].objectid = ins->objectid;
+	keys[2].type = BTRFS_TREE_BLOCK_REF_KEY;
+	keys[2].offset = root_objectid;
 	sizes[0] = sizeof(*extent_item);
-	sizes[1] = sizeof(*ref);
+	sizes[1] = sizeof(*block_info);
+	sizes[2] = 0;
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
-	ret = btrfs_insert_empty_items(trans, extent_root, path, keys,
-				       sizes, 2);
-
+	ret = btrfs_insert_empty_items(trans, fs_info->extent_root, path,
+					keys, sizes, 3);
+	if (ret) {
+		btrfs_print_leaf(fs_info->extent_root, path->nodes[0]);
+	}
 	BUG_ON(ret);
+
 	extent_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_extent_item);
 	btrfs_set_extent_refs(path->nodes[0], extent_item, 1);
-	ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
-			     struct btrfs_extent_ref);
+	btrfs_set_extent_generation(path->nodes[0], extent_item, generation);
+	btrfs_set_extent_flags(path->nodes[0], extent_item,
+			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
+	block_info = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
+				    struct btrfs_tree_block_info);
 
-	btrfs_set_ref_root(path->nodes[0], ref, root_objectid);
-	btrfs_set_ref_generation(path->nodes[0], ref, ref_generation);
-	btrfs_set_ref_objectid(path->nodes[0], ref, owner);
-	btrfs_set_ref_num_refs(path->nodes[0], ref, 1);
+	btrfs_set_tree_block_key(path->nodes[0], block_info, key);
+	btrfs_set_tree_block_level(path->nodes[0], block_info, level);
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
-
-	trans->alloc_exclude_start = 0;
-	trans->alloc_exclude_nr = 0;
 	btrfs_free_path(path);
-	finish_current_insert(trans, extent_root);
-	pending_ret = del_pending_extents(trans, extent_root);
 
-	if (ret) {
-		return ret;
-	}
-	if (pending_ret) {
-		return pending_ret;
-	}
+	if (ret)
+		goto out;
 
-update_block:
-	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1, 0);
+	ret = update_block_group(trans, root, ins->objectid, ins->offset,
+				 1, 0);
 	if (ret) {
-		printk("update block group failed for %llu %llu\n",
-		       (unsigned long long)ins->objectid,
+		printk(KERN_ERR "btrfs update block group failed for %llu "
+		       "%llu\n", (unsigned long long)ins->objectid,
 		       (unsigned long long)ins->offset);
 		BUG();
 	}
-	return 0;
+out:
+	return ret;
+}
+
+static int alloc_tree_block(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, u64 num_bytes,
+			    u64 root_objectid, u64 generation,
+			    u64 flags, struct btrfs_disk_key *key,
+			    int level, u64 empty_size, u64 hint_byte,
+			    u64 search_end, struct btrfs_key *ins)
+{
+	int ret;
+	ret = btrfs_reserve_extent(trans, root, num_bytes, empty_size,
+				   hint_byte, search_end, ins, 0);
+	BUG_ON(ret);
+
+	if (root_objectid == BTRFS_EXTENT_TREE_OBJECTID) {
+		struct pending_extent_op *extent_op;
+
+		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+		BUG_ON(!extent_op);
+
+		extent_op->type = PENDING_EXTENT_INSERT;
+		extent_op->bytenr = ins->objectid;
+		extent_op->num_bytes = ins->offset;
+		extent_op->level = level;
+		extent_op->flags = flags;
+		memcpy(&extent_op->key, key, sizeof(*key));
+
+		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
+				ins->objectid + ins->offset - 1,
+				EXTENT_LOCKED, GFP_NOFS);
+		set_state_private(&root->fs_info->extent_ins,
+				  ins->objectid, (unsigned long)extent_op);
+	} else {
+		ret = alloc_reserved_tree_block(trans, root, root_objectid,
+						generation, flags,
+						key, level, ins);
+	}
+	return ret;
 }
 
 /*
@@ -2004,41 +2103,38 @@ update_block:
  * returns the tree buffer or NULL.
  */
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
-					     struct btrfs_root *root,
-					     u32 blocksize, u64 parent,
-					     u64 root_objectid,
-					     u64 ref_generation,
-					     int level,
-					     u64 hint,
-					     u64 empty_size)
+					struct btrfs_root *root,
+					u32 blocksize, u64 root_objectid,
+					struct btrfs_disk_key *key, int level,
+					u64 hint, u64 empty_size)
 {
 	struct btrfs_key ins;
 	int ret;
 	struct extent_buffer *buf;
 
-	ret = btrfs_alloc_extent(trans, root, blocksize, parent,
-				 root_objectid, ref_generation,
-				 level, empty_size, hint,
-				 (u64)-1, &ins, 0);
+	ret = alloc_tree_block(trans, root, blocksize, root_objectid,
+			       trans->transid, 0, key, level,
+			       empty_size, hint, (u64)-1, &ins);
 	if (ret) {
 		BUG_ON(ret > 0);
 		return ERR_PTR(ret);
 	}
+
 	buf = btrfs_find_create_tree_block(root, ins.objectid, blocksize);
 	if (!buf) {
-		if (parent == 0)
-			parent = ins.objectid;
-		btrfs_free_extent(trans, root, ins.objectid, blocksize,
-				  parent, root->root_key.objectid,
-				  ref_generation, level, 0);
+		btrfs_free_extent(trans, root, ins.objectid, ins.offset,
+				  0, root->root_key.objectid, level, 0);
 		BUG_ON(1);
 		return ERR_PTR(-ENOMEM);
 	}
 	btrfs_set_buffer_uptodate(buf);
 	trans->blocks_used++;
+
 	return buf;
 }
 
+#if 0
+
 static int noinline drop_leaf_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  struct extent_buffer *leaf)
@@ -2356,6 +2452,8 @@ out:
 	return ret;
 }
 
+#endif
+
 int btrfs_free_block_groups(struct btrfs_fs_info *info)
 {
 	u64 start;
diff -urp btrfs-progs-unstable/kerncompat.h btrfs-progs-2/kerncompat.h
--- btrfs-progs-unstable/kerncompat.h	2009-01-08 08:30:09.758081132 +0800
+++ btrfs-progs-2/kerncompat.h	2009-04-22 15:13:09.000000000 +0800
@@ -191,6 +191,7 @@ static inline long IS_ERR(const void *pt
  */
 #define printk(fmt, args...) fprintf(stderr, fmt, ##args)
 #define	KERN_CRIT	""
+#define KERN_ERR	""
 
 /*
  * kmalloc/kfree
diff -urp btrfs-progs-unstable/Makefile btrfs-progs-2/Makefile
--- btrfs-progs-unstable/Makefile	2009-01-23 06:01:44.061371486 +0800
+++ btrfs-progs-2/Makefile	2009-04-24 16:35:55.000000000 +0800
@@ -1,10 +1,11 @@
 CC=gcc
-AM_CFLAGS = -Wall -fno-strict-aliasing -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
-CFLAGS = -g -Werror -Os
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
+CFLAGS = -g 
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
 	  volumes.o utils.o
+
 #
 CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 		-Wuninitialized -Wshadow -Wundef
@@ -15,8 +16,7 @@ prefix ?= /usr/local
 bindir = $(prefix)/bin
 LIBS=-luuid
 
-progs = btrfsctl btrfsck mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol \
-	btrfstune btrfs-image
+progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck
 
 # make C=1 to enable sparse
 ifdef C
diff -urp btrfs-progs-unstable/mkfs.c btrfs-progs-2/mkfs.c
--- btrfs-progs-unstable/mkfs.c	2009-01-13 18:55:53.216451553 +0800
+++ btrfs-progs-2/mkfs.c	2009-05-02 19:31:37.000000000 +0800
@@ -252,7 +252,7 @@ static int create_data_reloc_tree(struct
 
 	location.objectid = objectid;
 	location.type = BTRFS_ROOT_ITEM_KEY;
-	location.offset = trans->transid;
+	location.offset = 0;
 	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
 				&location, &root_item);
 	BUG_ON(ret);
diff -urp btrfs-progs-unstable/print-tree.c btrfs-progs-2/print-tree.c
--- btrfs-progs-unstable/print-tree.c	2009-01-08 08:30:09.760083063 +0800
+++ btrfs-progs-2/print-tree.c	2009-05-11 09:35:00.000000000 +0800
@@ -207,8 +207,20 @@ static void print_key_type(u8 type)
 	case BTRFS_EXTENT_ITEM_KEY:
 		printf("EXTENT_ITEM");
 		break;
-	case BTRFS_EXTENT_REF_KEY:
-		printf("EXTENT_REF");
+	case BTRFS_TREE_BLOCK_INFO_KEY:
+		printf("TREE_BLOCK_INFO");
+		break;
+	case BTRFS_TREE_BLOCK_REF_KEY:
+		printf("TREE_BLOCK_REF");
+		break;
+	case BTRFS_SHARED_BLOCK_REF_KEY:
+		printf("SHARED_BLOCK_REF");
+		break;
+	case BTRFS_EXTENT_DATA_REF_KEY:
+		printf("EXTENT_DATA_REF");
+		break;
+	case BTRFS_SHARED_DATA_REF_KEY:
+		printf("SHARED_DATA_REF");
 		break;
 	case BTRFS_CSUM_ITEM_KEY:
 		printf("CSUM_ITEM");
@@ -251,7 +263,8 @@ void btrfs_print_leaf(struct btrfs_root 
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_csum_item *ci;
 	struct btrfs_block_group_item *bi;
-	struct btrfs_extent_ref *ref;
+	struct btrfs_extent_data_ref *dref;
+	struct btrfs_shared_data_ref *sref;
 	struct btrfs_inode_ref *iref;
 	struct btrfs_dev_extent *dev_extent;
 	struct btrfs_disk_key disk_key;
@@ -329,17 +342,33 @@ void btrfs_print_leaf(struct btrfs_root 
 			break;
 		case BTRFS_EXTENT_ITEM_KEY:
 			ei = btrfs_item_ptr(l, i, struct btrfs_extent_item);
-			printf("\t\textent data refs %u\n",
-				btrfs_extent_refs(l, ei));
-			break;
-		case BTRFS_EXTENT_REF_KEY:
-			ref = btrfs_item_ptr(l, i, struct btrfs_extent_ref);
-			printf("\t\textent back ref root %llu gen %llu "
-			       "owner %llu num_refs %lu\n",
-			       (unsigned long long)btrfs_ref_root(l, ref),
-			       (unsigned long long)btrfs_ref_generation(l, ref),
-			       (unsigned long long)btrfs_ref_objectid(l, ref),
-			       (unsigned long)btrfs_ref_num_refs(l, ref));
+			printf("\t\textent refs %llu gen %llu flags %llu\n",
+				(unsigned long long)btrfs_extent_refs(l, ei),
+				(unsigned long long)btrfs_extent_generation(l, ei),
+				(unsigned long long)btrfs_extent_flags(l, ei));
+			break;
+		case BTRFS_TREE_BLOCK_INFO_KEY:
+			printf("\t\ttree block info\n");
+			break;
+		case BTRFS_TREE_BLOCK_REF_KEY:
+			printf("\t\ttree block backref\n");
+			break;
+		case BTRFS_SHARED_BLOCK_REF_KEY:
+			printf("\t\tshared block backref\n");
+			break;
+		case BTRFS_EXTENT_DATA_REF_KEY:
+			dref = btrfs_item_ptr(l, i, struct btrfs_extent_data_ref);
+			printf("\t\textent data backref root %llu"
+			       "objectid %llu offset %llu count %u\n",
+			       (unsigned long long)btrfs_extent_data_ref_root(l, dref),
+			       (unsigned long long)btrfs_extent_data_ref_objectid(l, dref),
+			       (unsigned long long)btrfs_extent_data_ref_offset(l, dref),
+			       btrfs_extent_data_ref_count(l, dref));
+			break;
+		case BTRFS_SHARED_DATA_REF_KEY:
+			sref = btrfs_item_ptr(l, i, struct btrfs_shared_data_ref);
+			printf("\t\tshared data backref count %u\n",
+			       btrfs_shared_data_ref_count(l, sref));
 			break;
 		case BTRFS_CSUM_ITEM_KEY:
 			ci = btrfs_item_ptr(l, i, struct btrfs_csum_item);
diff -urp btrfs-progs-unstable/utils.c btrfs-progs-2/utils.c
--- btrfs-progs-unstable/utils.c	2009-01-23 06:01:44.071371364 +0800
+++ btrfs-progs-2/utils.c	2009-05-11 09:06:21.000000000 +0800
@@ -63,8 +63,8 @@ int make_btrfs(int fd, const char *devic
 	struct extent_buffer *buf;
 	struct btrfs_root_item root_item;
 	struct btrfs_disk_key disk_key;
-	struct btrfs_extent_ref *extent_ref;
 	struct btrfs_extent_item *extent_item;
+	struct btrfs_tree_block_info *block_info;
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_chunk *chunk;
 	struct btrfs_dev_item *dev_item;
@@ -212,25 +212,32 @@ int make_btrfs(int fd, const char *devic
 		extent_item = btrfs_item_ptr(buf, nritems,
 					     struct btrfs_extent_item);
 		btrfs_set_extent_refs(buf, extent_item, 1);
+		btrfs_set_extent_generation(buf, extent_item, 1);
+		nritems++;
+
+		/* create tree block info */
+		itemoff = itemoff - sizeof(struct btrfs_tree_block_info);
+		btrfs_set_disk_key_objectid(&disk_key, blocks[i]);
+		btrfs_set_disk_key_offset(&disk_key, 0);
+		btrfs_set_disk_key_type(&disk_key, BTRFS_TREE_BLOCK_INFO_KEY);
+		btrfs_set_item_key(buf, &disk_key, nritems);
+		btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems),
+				      itemoff);
+		btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems),
+				    sizeof(struct btrfs_tree_block_info));
+		block_info =  btrfs_item_ptr(buf, nritems,
+					     struct btrfs_tree_block_info);
 		nritems++;
 
 		/* create extent ref */
 		ref_root = reference_root_table[i];
-		itemoff = itemoff - sizeof(struct btrfs_extent_ref);
 		btrfs_set_disk_key_objectid(&disk_key, blocks[i]);
-		btrfs_set_disk_key_offset(&disk_key, blocks[i]);
-		btrfs_set_disk_key_type(&disk_key, BTRFS_EXTENT_REF_KEY);
+		btrfs_set_disk_key_offset(&disk_key, ref_root);
+		btrfs_set_disk_key_type(&disk_key, BTRFS_TREE_BLOCK_REF_KEY);
 		btrfs_set_item_key(buf, &disk_key, nritems);
 		btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems),
 				      itemoff);
-		btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems),
-				    sizeof(struct btrfs_extent_ref));
-		extent_ref = btrfs_item_ptr(buf, nritems,
-					     struct btrfs_extent_ref);
-		btrfs_set_ref_root(buf, extent_ref, ref_root);
-		btrfs_set_ref_generation(buf, extent_ref, 1);
-		btrfs_set_ref_objectid(buf, extent_ref, 0);
-		btrfs_set_ref_num_refs(buf, extent_ref, 1);
+		btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems), 0);
 		nritems++;
 	}
 	btrfs_set_header_bytenr(buf, blocks[2]);

