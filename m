From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 2/5] btrfs: track changes to tree blocks' key
Date: Tue, 11 May 2010 16:24:32 +0800
Message-ID: <4BE91440.5040502@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

update key stored in back-reference after tree block's key
changes.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/ctree.c 3/fs/btrfs/ctree.c
--- 2/fs/btrfs/ctree.c	2010-05-11 14:00:04.122357838 +0800
+++ 3/fs/btrfs/ctree.c	2010-05-11 14:09:45.050108153 +0800
@@ -348,10 +348,8 @@ static noinline int update_ref_for_cow(s
 			BUG_ON(ret);
 		}
 		if (new_flags != 0) {
-			ret = btrfs_set_disk_extent_flags(trans, root,
-							  buf->start,
-							  buf->len,
-							  new_flags, 0);
+			ret = btrfs_update_tree_block_info(trans, root, buf,
+							   NULL, new_flags, 0);
 			BUG_ON(ret);
 		}
 	} else {
@@ -1126,6 +1124,10 @@ static noinline int balance_level(struct
 			btrfs_node_key(right, &right_key, 0);
 			btrfs_set_node_key(parent, &right_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
+
+			wret = btrfs_update_tree_block_key(trans, root,
+							right, &right_key);
+			BUG_ON(wret);
 		}
 	}
 	if (btrfs_header_nritems(mid) == 1) {
@@ -1167,6 +1169,10 @@ static noinline int balance_level(struct
 		btrfs_node_key(mid, &mid_key, 0);
 		btrfs_set_node_key(parent, &mid_key, pslot);
 		btrfs_mark_buffer_dirty(parent);
+
+		wret = btrfs_update_tree_block_key(trans, root,
+						mid, &mid_key);
+		BUG_ON(wret);
 	}
 
 	/* update the path */
@@ -1266,6 +1272,11 @@ static noinline int push_nodes_for_inser
 			btrfs_node_key(mid, &disk_key, 0);
 			btrfs_set_node_key(parent, &disk_key, pslot);
 			btrfs_mark_buffer_dirty(parent);
+
+			wret = btrfs_update_tree_block_key(trans, root,
+							mid, &disk_key);
+			BUG_ON(wret);
+
 			if (btrfs_header_nritems(left) > orig_slot) {
 				path->nodes[level] = left;
 				path->slots[level + 1] -= 1;
@@ -1318,6 +1329,10 @@ static noinline int push_nodes_for_inser
 			btrfs_set_node_key(parent, &disk_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 
+			wret = btrfs_update_tree_block_key(trans, root,
+							right, &disk_key);
+			BUG_ON(wret);
+
 			if (btrfs_header_nritems(mid) <= orig_slot) {
 				path->nodes[level] = right;
 				path->slots[level + 1] += 1;
@@ -1893,6 +1908,8 @@ static int fixup_low_keys(struct btrfs_t
 		btrfs_mark_buffer_dirty(path->nodes[i]);
 		if (tslot != 0)
 			break;
+		ret = btrfs_update_tree_block_key(trans, root, t, key);
+		BUG_ON(ret);
 	}
 	return ret;
 }
@@ -1927,9 +1944,13 @@ int btrfs_set_item_key_safe(struct btrfs
 	btrfs_cpu_key_to_disk(&disk_key, new_key);
 	btrfs_set_item_key(eb, &disk_key, slot);
 	btrfs_mark_buffer_dirty(eb);
-	if (slot == 0)
+	if (slot == 0) {
+		int ret;
+		btrfs_set_path_blocking(path);
+		ret = btrfs_update_tree_block_key(trans, root, eb, &disk_key);
+		BUG_ON(ret);
 		fixup_low_keys(trans, root, path, &disk_key, 1);
-
+	}
 	return 0;
 }
 
@@ -2312,6 +2333,7 @@ static noinline int __push_leaf_right(st
 	struct extent_buffer *upper = path->nodes[1];
 	struct btrfs_disk_key disk_key;
 	int slot;
+	int ret;
 	u32 i;
 	int push_space = 0;
 	int push_items = 0;
@@ -2439,6 +2461,9 @@ static noinline int __push_leaf_right(st
 	btrfs_set_node_key(upper, &disk_key, slot + 1);
 	btrfs_mark_buffer_dirty(upper);
 
+	ret = btrfs_update_tree_block_key(trans, root, right, &disk_key);
+	BUG_ON(ret);
+
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] >= left_nritems) {
 		path->slots[0] -= left_nritems;
@@ -2677,6 +2702,10 @@ static noinline int __push_leaf_left(str
 	if (right_nritems) {
 		btrfs_mark_buffer_dirty(right);
 		btrfs_item_key(right, &disk_key, 0);
+		wret = btrfs_update_tree_block_key(trans, root, right,
+						   &disk_key);
+		BUG_ON(wret);
+
 		wret = fixup_low_keys(trans, root, path, &disk_key, 1);
 		if (wret)
 			ret = wret;
@@ -3324,8 +3353,13 @@ int btrfs_truncate_item(struct btrfs_tra
 		offset = btrfs_disk_key_offset(&disk_key);
 		btrfs_set_disk_key_offset(&disk_key, offset + size_diff);
 		btrfs_set_item_key(leaf, &disk_key, slot);
-		if (slot == 0)
+		if (slot == 0) {
+			btrfs_set_path_blocking(path);
+			ret = btrfs_update_tree_block_key(trans, root,
+							leaf, &disk_key);
+			BUG_ON(ret);
 			fixup_low_keys(trans, root, path, &disk_key, 1);
+		}
 	}
 
 	item = btrfs_item_nr(leaf, slot);
@@ -3561,6 +3595,11 @@ int btrfs_insert_some_items(struct btrfs
 	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
+
+		btrfs_set_path_blocking(path);
+		ret = btrfs_update_tree_block_key(trans, root, leaf,
+						  &disk_key);
+		BUG_ON(ret);
 		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 
@@ -3669,6 +3708,11 @@ setup_items_for_insert(struct btrfs_tran
 	if (slot == 0) {
 		struct btrfs_disk_key disk_key;
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
+
+		btrfs_set_path_blocking(path);
+		ret = btrfs_update_tree_block_key(trans, root, leaf,
+						  &disk_key);
+		BUG_ON(ret);
 		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
@@ -3775,8 +3819,11 @@ static int del_ptr(struct btrfs_trans_ha
 		btrfs_set_header_level(root->node, 0);
 	} else if (slot == 0) {
 		struct btrfs_disk_key disk_key;
-
 		btrfs_node_key(parent, &disk_key, 0);
+
+		ret = btrfs_update_tree_block_key(trans, root, parent,
+						  &disk_key);
+		BUG_ON(ret);
 		wret = fixup_low_keys(trans, root, path, &disk_key, level + 1);
 		if (wret)
 			ret = wret;
@@ -3893,8 +3940,12 @@ int btrfs_del_items(struct btrfs_trans_h
 		int used = leaf_space_used(leaf, 0, nritems);
 		if (slot == 0) {
 			struct btrfs_disk_key disk_key;
-
 			btrfs_item_key(leaf, &disk_key, 0);
+
+			btrfs_set_path_blocking(path);
+			wret = btrfs_update_tree_block_key(trans, root,
+							leaf, &disk_key);
+			BUG_ON(wret);
 			wret = fixup_low_keys(trans, root, path,
 					      &disk_key, 1);
 			if (wret)
diff -urp 2/fs/btrfs/ctree.h 3/fs/btrfs/ctree.h
--- 2/fs/btrfs/ctree.h	2010-05-11 13:57:39.448108941 +0800
+++ 3/fs/btrfs/ctree.h	2010-05-11 14:09:45.052107958 +0800
@@ -2013,10 +2013,15 @@ int btrfs_inc_ref(struct btrfs_trans_han
 		  struct extent_buffer *buf, int full_backref);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref);
-int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
+int btrfs_update_tree_block_key(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes, u64 flags,
-				int is_data);
+				struct extent_buffer *eb,
+				struct btrfs_disk_key *key);
+int btrfs_update_tree_block_info(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct extent_buffer *eb,
+				 struct btrfs_disk_key *key,
+				 u64 flags_to_set, int update_gen);
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent,
diff -urp 2/fs/btrfs/delayed-ref.c 3/fs/btrfs/delayed-ref.c
--- 2/fs/btrfs/delayed-ref.c	2010-05-11 13:52:01.071108165 +0800
+++ 3/fs/btrfs/delayed-ref.c	2010-05-11 14:09:45.053108175 +0800
@@ -509,6 +509,9 @@ update_existing_head_ref(struct btrfs_de
 				       sizeof(ref->extent_op->key));
 				existing_ref->extent_op->update_key = 1;
 			}
+			if (ref->extent_op->update_gen)
+				existing_ref->extent_op->update_gen = 1;
+
 			if (ref->extent_op->update_flags) {
 				existing_ref->extent_op->flags_to_set |=
 					ref->extent_op->flags_to_set;
diff -urp 2/fs/btrfs/delayed-ref.h 3/fs/btrfs/delayed-ref.h
--- 2/fs/btrfs/delayed-ref.h	2010-05-11 13:52:01.072108243 +0800
+++ 3/fs/btrfs/delayed-ref.h	2010-05-11 14:09:45.054107903 +0800
@@ -58,6 +58,7 @@ struct btrfs_delayed_extent_op {
 	struct btrfs_disk_key key;
 	u64 flags_to_set;
 	unsigned int update_key:1;
+	unsigned int update_gen:1;
 	unsigned int update_flags:1;
 	unsigned int is_data:1;
 };
diff -urp 2/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 2/fs/btrfs/extent-tree.c	2010-05-11 14:00:54.906106739 +0800
+++ 3/fs/btrfs/extent-tree.c	2010-05-11 14:12:00.044357180 +0800
@@ -46,7 +46,7 @@ static int __btrfs_free_extent(struct bt
 				struct btrfs_delayed_extent_op *extra_op);
 static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 				    struct extent_buffer *leaf,
-				    struct btrfs_extent_item *ei);
+				    struct btrfs_extent_item *ei, u64 transid);
 static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      u64 parent, u64 root_objectid,
@@ -55,8 +55,8 @@ static int alloc_reserved_file_extent(st
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 parent, u64 root_objectid,
-				     u64 flags, struct btrfs_disk_key *key,
-				     int level, struct btrfs_key *ins);
+				     int level, struct btrfs_key *ins,
+				     struct btrfs_delayed_extent_op *extent_op);
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force);
@@ -1389,7 +1389,7 @@ int setup_inline_extent_backref(struct b
 	refs += refs_to_add;
 	btrfs_set_extent_refs(leaf, ei, refs);
 	if (extent_op)
-		__run_delayed_extent_op(extent_op, leaf, ei);
+		__run_delayed_extent_op(extent_op, leaf, ei, trans->transid);
 
 	ptr = (unsigned long)ei + item_offset;
 	end = (unsigned long)ei + btrfs_item_size_nr(leaf, path->slots[0]);
@@ -1478,7 +1478,7 @@ int update_inline_extent_backref(struct 
 	refs += refs_to_mod;
 	btrfs_set_extent_refs(leaf, ei, refs);
 	if (extent_op)
-		__run_delayed_extent_op(extent_op, leaf, ei);
+		__run_delayed_extent_op(extent_op, leaf, ei, trans->transid);
 
 	type = btrfs_extent_inline_ref_type(leaf, iref);
 
@@ -1681,7 +1681,7 @@ static int __btrfs_inc_extent_ref(struct
 	refs = btrfs_extent_refs(leaf, item);
 	btrfs_set_extent_refs(leaf, item, refs + refs_to_add);
 	if (extent_op)
-		__run_delayed_extent_op(extent_op, leaf, item);
+		__run_delayed_extent_op(extent_op, leaf, item, trans->transid);
 
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(root->fs_info->extent_root, path);
@@ -1724,6 +1724,7 @@ static int run_delayed_data_ref(struct b
 
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		if (extent_op) {
+			BUG_ON(extent_op->update_gen);
 			BUG_ON(extent_op->update_key);
 			flags |= extent_op->flags_to_set;
 		}
@@ -1751,7 +1752,7 @@ static int run_delayed_data_ref(struct b
 
 static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 				    struct extent_buffer *leaf,
-				    struct btrfs_extent_item *ei)
+				    struct btrfs_extent_item *ei, u64 transid)
 {
 	u64 flags = btrfs_extent_flags(leaf, ei);
 	if (extent_op->update_flags) {
@@ -1759,6 +1760,9 @@ static void __run_delayed_extent_op(stru
 		btrfs_set_extent_flags(leaf, ei, flags);
 	}
 
+	if (extent_op->update_gen)
+		btrfs_set_extent_generation(leaf, ei, transid);
+
 	if (extent_op->update_key) {
 		struct btrfs_tree_block_info *bi;
 		BUG_ON(!(flags & BTRFS_EXTENT_FLAG_TREE_BLOCK));
@@ -1817,7 +1821,7 @@ static int run_delayed_extent_op(struct 
 #endif
 	BUG_ON(item_size < sizeof(*ei));
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
-	__run_delayed_extent_op(extent_op, leaf, ei);
+	__run_delayed_extent_op(extent_op, leaf, ei, trans->transid);
 
 	btrfs_mark_buffer_dirty(leaf);
 out:
@@ -1849,13 +1853,10 @@ static int run_delayed_tree_ref(struct b
 
 	BUG_ON(node->ref_mod != 1);
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
-		BUG_ON(!extent_op || !extent_op->update_flags ||
-		       !extent_op->update_key);
 		ret = alloc_reserved_tree_block(trans, root,
 						parent, ref_root,
-						extent_op->flags_to_set,
-						&extent_op->key,
-						ref->level, &ins);
+						ref->level, &ins,
+						extent_op);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent, ref_root,
@@ -2156,24 +2157,55 @@ out:
 	return 0;
 }
 
-int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
+int btrfs_update_tree_block_key(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes, u64 flags,
-				int is_data)
+				struct extent_buffer *eb,
+				struct btrfs_disk_key *key)
 {
 	struct btrfs_delayed_extent_op *extent_op;
 	int ret;
 
-	extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
+		return 0;
+
+	extent_op = kzalloc(sizeof(*extent_op), GFP_NOFS);
 	if (!extent_op)
 		return -ENOMEM;
 
-	extent_op->flags_to_set = flags;
-	extent_op->update_flags = 1;
-	extent_op->update_key = 0;
-	extent_op->is_data = is_data ? 1 : 0;
+	memcpy(&extent_op->key, key, sizeof(extent_op->key));
+	extent_op->update_key = 1;
 
-	ret = btrfs_add_delayed_extent_op(trans, bytenr, num_bytes, extent_op);
+	ret = btrfs_add_delayed_extent_op(trans, eb->start, eb->len, extent_op);
+	if (ret)
+		kfree(extent_op);
+	return ret;
+}
+
+int btrfs_update_tree_block_info(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct extent_buffer *eb,
+				 struct btrfs_disk_key *key,
+				 u64 flags_to_set, int update_gen)
+{
+	struct btrfs_delayed_extent_op *extent_op;
+	int ret;
+
+	extent_op = kzalloc(sizeof(*extent_op), GFP_NOFS);
+	if (!extent_op)
+		return -ENOMEM;
+
+	if (key) {
+		memcpy(&extent_op->key, key, sizeof(extent_op->key));
+		extent_op->update_key = 1;
+	}
+	if (flags_to_set) {
+		extent_op->flags_to_set = flags_to_set;
+		extent_op->update_flags = 1;
+	}
+	if (update_gen)
+		extent_op->update_gen = 1;
+
+	ret = btrfs_add_delayed_extent_op(trans, eb->start, eb->len, extent_op);
 	if (ret)
 		kfree(extent_op);
 	return ret;
@@ -3883,7 +3915,8 @@ static int __btrfs_free_extent(struct bt
 
 	if (refs > 0) {
 		if (extent_op)
-			__run_delayed_extent_op(extent_op, leaf, ei);
+			__run_delayed_extent_op(extent_op, leaf, ei,
+						trans->transid);
 		/*
 		 * In the case of inline back ref, reference count will
 		 * be updated by remove_extent_backref
@@ -4783,8 +4816,8 @@ static int alloc_reserved_file_extent(st
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 parent, u64 root_objectid,
-				     u64 flags, struct btrfs_disk_key *key,
-				     int level, struct btrfs_key *ins)
+				     int level, struct btrfs_key *ins,
+				     struct btrfs_delayed_extent_op *extent_op)
 {
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4795,6 +4828,9 @@ static int alloc_reserved_tree_block(str
 	struct extent_buffer *leaf;
 	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);
 
+	BUG_ON(!extent_op ||
+	       !extent_op->update_flags || !extent_op->update_key);
+
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
@@ -4807,17 +4843,23 @@ static int alloc_reserved_tree_block(str
 	extent_item = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_item);
 	btrfs_set_extent_refs(leaf, extent_item, 1);
-	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
 	btrfs_set_extent_flags(leaf, extent_item,
-			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
-	block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
+			       BTRFS_EXTENT_FLAG_TREE_BLOCK |
+			       extent_op->flags_to_set);
+	if (extent_op->update_gen)
+		btrfs_set_extent_generation(leaf, extent_item,
+					    trans->transid);
+	else
+		btrfs_set_extent_generation(leaf, extent_item, 0);
 
-	btrfs_set_tree_block_key(leaf, block_info, key);
+	block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
+	btrfs_set_tree_block_key(leaf, block_info, &extent_op->key);
 	btrfs_set_tree_block_level(leaf, block_info, level);
 
 	iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
 	if (parent > 0) {
-		BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
+		BUG_ON(!(extent_op->flags_to_set &
+			 BTRFS_BLOCK_FLAG_FULL_BACKREF));
 		btrfs_set_extent_inline_ref_type(leaf, iref,
 						 BTRFS_SHARED_BLOCK_REF_KEY);
 		btrfs_set_extent_inline_ref_offset(leaf, iref, parent);
@@ -4946,16 +4988,14 @@ static int alloc_tree_block(struct btrfs
 
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
 		struct btrfs_delayed_extent_op *extent_op;
-		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+		extent_op = kzalloc(sizeof(*extent_op), GFP_NOFS);
 		BUG_ON(!extent_op);
 		if (key)
 			memcpy(&extent_op->key, key, sizeof(extent_op->key));
-		else
-			memset(&extent_op->key, 0, sizeof(extent_op->key));
 		extent_op->flags_to_set = flags;
 		extent_op->update_key = 1;
+		extent_op->update_gen = 1;
 		extent_op->update_flags = 1;
-		extent_op->is_data = 0;
 
 		ret = btrfs_add_delayed_tree_ref(trans, ins->objectid,
 					ins->offset, parent, root_objectid,
@@ -5193,8 +5233,8 @@ static noinline int walk_down_proc(struc
 		BUG_ON(ret);
 		ret = btrfs_dec_ref(trans, root, eb, 0);
 		BUG_ON(ret);
-		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
-						  eb->len, flag, 0);
+		ret = btrfs_update_tree_block_info(trans, root, eb,
+						   NULL, flag, 0);
 		BUG_ON(ret);
 		wc->flags[level] |= flag;
 	}
