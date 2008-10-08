From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Remove offset field from struct btrfs_extent_ref
Date: Wed, 08 Oct 2008 13:21:34 +0800
Message-ID: <48EC435E.9010401@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The offset field in struct btrfs_extent_ref records the position
inside file that file extent is referenced by. In the new back
reference system, which tree leaves hold reference to file extent
are recorded explicitly. we can scan these tree leaves, so the
offset field is not useful.

This patch also makes the back reference system check the objectid
when extents are in deleting.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2eab464..9caeb37 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -254,8 +254,7 @@ int noinline __btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_alloc_reserved_extent(trans, root, parent_start,
 						  root->root_key.objectid,
-						  trans->transid, level, 0,
-						  &ins);
+						  trans->transid, level, &ins);
 		BUG_ON(ret);
 		cow = btrfs_init_new_buffer(trans, root, prealloc_dest,
 					    buf->len);
@@ -333,7 +332,7 @@ int noinline __btrfs_cow_block(struct btrfs_trans_handle *trans,
 					  buf->len, buf->start,
 					  root->root_key.objectid,
 					  btrfs_header_generation(buf),
-					  0, 0, 1);
+					  level, 1);
 		}
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
@@ -347,7 +346,7 @@ int noinline __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		WARN_ON(btrfs_header_generation(parent) != trans->transid);
 		btrfs_free_extent(trans, root, buf->start, buf->len,
 				  parent_start, btrfs_header_owner(parent),
-				  btrfs_header_generation(parent), 0, 0, 1);
+				  btrfs_header_generation(parent), level, 1);
 	}
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
@@ -927,7 +926,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		ret = btrfs_update_extent_ref(trans, root, child->start,
 					      mid->start, child->start,
 					      root->root_key.objectid,
-					      trans->transid, level - 1, 0);
+					      trans->transid, level - 1);
 		BUG_ON(ret);
 
 		add_root_to_dirty_list(root);
@@ -940,7 +939,8 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		free_extent_buffer(mid);
 		ret = btrfs_free_extent(trans, root, mid->start, mid->len,
 					mid->start, root->root_key.objectid,
-					btrfs_header_generation(mid), 0, 0, 1);
+					btrfs_header_generation(mid),
+					level, 1);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
 		return ret;
@@ -1006,7 +1006,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			wret = btrfs_free_extent(trans, root, bytenr,
 						 blocksize, parent->start,
 						 btrfs_header_owner(parent),
-						 generation, 0, 0, 1);
+						 generation, level, 1);
 			if (wret)
 				ret = wret;
 		} else {
@@ -1055,7 +1055,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		wret = btrfs_free_extent(trans, root, bytenr, blocksize,
 					 parent->start,
 					 btrfs_header_owner(parent),
-					 root_gen, 0, 0, 1);
+					 root_gen, level, 1);
 		if (wret)
 			ret = wret;
 	} else {
@@ -1691,13 +1691,13 @@ next_level:
 					blocksize, parent->start,
 					btrfs_header_owner(parent),
 					btrfs_header_generation(parent),
-					level - 1, 0);
+					level - 1);
 		BUG_ON(ret);
 		ret = btrfs_free_extent(trans, root, bytenr,
 					blocksize, parent->start,
 					btrfs_header_owner(parent),
 					btrfs_header_generation(parent),
-					level - 1, 0, 1);
+					level - 1, 1);
 		BUG_ON(ret);
 
 		if (generation == trans->transid) {
@@ -1973,7 +1973,7 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_extent_ref(trans, root, lower->start,
 				      lower->start, c->start,
 				      root->root_key.objectid,
-				      trans->transid, level - 1, 0);
+				      trans->transid, level - 1);
 	BUG_ON(ret);
 
 	/* the super has an extra ref to root->node */
@@ -3213,7 +3213,7 @@ noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 				btrfs_level_size(root, 0),
 				path->nodes[1]->start,
 				btrfs_header_owner(path->nodes[1]),
-				root_gen, 0, 0, 1);
+				root_gen, 0, 1);
 	return ret;
 }
 /*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8566eb3..d670760 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -374,7 +374,6 @@ struct btrfs_extent_ref {
 	__le64 root;
 	__le64 generation;
 	__le64 objectid;
-	__le64 offset;
 	__le32 num_refs;
 } __attribute__ ((__packed__));
 
@@ -1082,7 +1081,6 @@ static inline u8 *btrfs_dev_extent_chunk_tree_uuid(struct btrfs_dev_extent *dev)
 BTRFS_SETGET_FUNCS(ref_root, struct btrfs_extent_ref, root, 64);
 BTRFS_SETGET_FUNCS(ref_generation, struct btrfs_extent_ref, generation, 64);
 BTRFS_SETGET_FUNCS(ref_objectid, struct btrfs_extent_ref, objectid, 64);
-BTRFS_SETGET_FUNCS(ref_offset, struct btrfs_extent_ref, offset, 64);
 BTRFS_SETGET_FUNCS(ref_num_refs, struct btrfs_extent_ref, num_refs, 32);
 
 BTRFS_SETGET_STACK_FUNCS(stack_ref_root, struct btrfs_extent_ref, root, 64);
@@ -1090,8 +1088,6 @@ BTRFS_SETGET_STACK_FUNCS(stack_ref_generation, struct btrfs_extent_ref,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_ref_objectid, struct btrfs_extent_ref,
 			 objectid, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_offset, struct btrfs_extent_ref,
-			 offset, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_ref_num_refs, struct btrfs_extent_ref,
 			 num_refs, 32);
 
@@ -1522,29 +1518,20 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize);
-int btrfs_insert_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
-				 struct btrfs_path *path,
-				 u64 bytenr, u64 parent,
-				 u64 root_objectid, u64 ref_generation,
-				 u64 owner, u64 owner_offset);
 int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
 		       u64 num_bytes, u64 parent, u64 min_bytes,
 		       u64 root_objectid, u64 ref_generation,
-		       u64 owner, u64 owner_offset,
-		       u64 empty_size, u64 hint_byte,
+		       u64 owner, u64 empty_size, u64 hint_byte,
 		       u64 search_end, struct btrfs_key *ins, u64 data);
 int btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, u64 parent,
 				u64 root_objectid, u64 ref_generation,
-				u64 owner, u64 owner_offset,
-				struct btrfs_key *ins);
+				u64 owner, struct btrfs_key *ins);
 int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, u64 parent,
 				u64 root_objectid, u64 ref_generation,
-				u64 owner, u64 owner_offset,
-				struct btrfs_key *ins);
+				u64 owner, struct btrfs_key *ins);
 int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  u64 num_bytes, u64 min_alloc_size,
@@ -1563,7 +1550,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent,
 		      u64 root_objectid, u64 ref_generation,
-		      u64 owner_objectid, u64 owner_offset, int pin);
+		      u64 owner_objectid, int pin);
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
@@ -1572,12 +1559,12 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 ref_generation,
-			 u64 owner, u64 owner_offset);
+			 u64 owner_objectid);
 int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 bytenr,
 			    u64 orig_parent, u64 parent,
 			    u64 root_objectid, u64 ref_generation,
-			    u64 owner, u64 owner_offset);
+			    u64 owner_objectid);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2938046..250bbf9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -525,31 +525,28 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
  * - Objectid of the subvolume root
  * - Generation number of the tree holding the reference
  * - objectid of the file holding the reference
- * - offset in the file corresponding to the key holding the reference
  * - number of references holding by parent node (alway 1 for tree blocks)
  *
  * Btree leaf may hold multiple references to a file extent. In most cases,
  * these references are from same file and the corresponding offsets inside
- * the file are close together. So inode objectid and offset in file are
- * just hints, they provide hints about where in the btree the references
- * can be found and when we can stop searching.
+ * the file are close together.
  *
  * When a file extent is allocated the fields are filled in:
- *     (root_key.objectid, trans->transid, inode objectid, offset in file, 1)
+ *     (root_key.objectid, trans->transid, inode objectid, 1)
  *
  * When a leaf is cow'd new references are added for every file extent found
  * in the leaf.  It looks similar to the create case, but trans->transid will
  * be different when the block is cow'd.
  *
- *     (root_key.objectid, trans->transid, inode objectid, offset in file,
+ *     (root_key.objectid, trans->transid, inode objectid,
  *      number of references in the leaf)
  *
- * Because inode objectid and offset in file are just hints, they are not
- * used when backrefs are deleted. When a file extent is removed either
- * during snapshot deletion or file truncation, we find the corresponding
- * back back reference and check the following fields.
+ * When a file extent is removed either during snapshot deletion or
+ * file truncation, we find the corresponding back reference and check
+ * the following fields:
  *
- *     (btrfs_header_owner(leaf), btrfs_header_generation(leaf))
+ *     (btrfs_header_owner(leaf), btrfs_header_generation(leaf),
+ *      inode objectid)
  *
  * Btree extents can be referenced by:
  *
@@ -558,21 +555,21 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
  *
  * When a tree block is created, back references are inserted:
  *
- * (root->root_key.objectid, trans->transid, level, 0, 1)
+ * (root->root_key.objectid, trans->transid, level, 1)
  *
  * When a tree block is cow'd, new back references are added for all the
  * blocks it points to. If the tree block isn't in reference counted root,
  * the old back references are removed. These new back references are of
  * the form (trans->transid will have increased since creation):
  *
- * (root->root_key.objectid, trans->transid, level, 0, 1)
+ * (root->root_key.objectid, trans->transid, level, 1)
  *
  * When a backref is in deleting, the following fields are checked:
  *
  * if backref was for a tree root:
- *     (btrfs_header_owner(itself), btrfs_header_generation(itself))
+ *     (btrfs_header_owner(itself), btrfs_header_generation(itself), level)
  * else
- *     (btrfs_header_owner(parent), btrfs_header_generation(parent))
+ *     (btrfs_header_owner(parent), btrfs_header_generation(parent), level)
  *
  * Back Reference Key composing:
  *
@@ -584,13 +581,15 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
 
 static int noinline lookup_extent_backref(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root,
-					  struct btrfs_path *path, u64 bytenr,
-					  u64 parent, u64 ref_root,
-					  u64 ref_generation, int del)
+					  struct btrfs_path *path,
+					  u64 bytenr, u64 parent,
+					  u64 ref_root, u64 ref_generation,
+					  u64 owner_objectid, int del)
 {
 	struct btrfs_key key;
 	struct btrfs_extent_ref *ref;
 	struct extent_buffer *leaf;
+	u64 ref_objectid;
 	int ret;
 
 	key.objectid = bytenr;
@@ -607,8 +606,11 @@ static int noinline lookup_extent_backref(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
+	ref_objectid = btrfs_ref_objectid(leaf, ref);
 	if (btrfs_ref_root(leaf, ref) != ref_root ||
-	    btrfs_ref_generation(leaf, ref) != ref_generation) {
+	    btrfs_ref_generation(leaf, ref) != ref_generation ||
+	    (ref_objectid != owner_objectid &&
+	     ref_objectid != BTRFS_MULTIPLE_OBJECTIDS)) {
 		ret = -EIO;
 		WARN_ON(1);
 		goto out;
@@ -623,7 +625,7 @@ static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
 					  struct btrfs_path *path,
 					  u64 bytenr, u64 parent,
 					  u64 ref_root, u64 ref_generation,
-					  u64 owner_objectid, u64 owner_offset)
+					  u64 owner_objectid)
 {
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
@@ -643,7 +645,6 @@ static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
 		btrfs_set_ref_root(leaf, ref, ref_root);
 		btrfs_set_ref_generation(leaf, ref, ref_generation);
 		btrfs_set_ref_objectid(leaf, ref, owner_objectid);
-		btrfs_set_ref_offset(leaf, ref, owner_offset);
 		btrfs_set_ref_num_refs(leaf, ref, 1);
 	} else if (ret == -EEXIST) {
 		u64 existing_owner;
@@ -663,14 +664,10 @@ static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
 		btrfs_set_ref_num_refs(leaf, ref, num_refs + 1);
 
 		existing_owner = btrfs_ref_objectid(leaf, ref);
-		if (existing_owner == owner_objectid &&
-		    btrfs_ref_offset(leaf, ref) > owner_offset) {
-			btrfs_set_ref_offset(leaf, ref, owner_offset);
-		} else if (existing_owner != owner_objectid &&
-			   existing_owner != BTRFS_MULTIPLE_OBJECTIDS) {
+		if (existing_owner != owner_objectid &&
+		    existing_owner != BTRFS_MULTIPLE_OBJECTIDS) {
 			btrfs_set_ref_objectid(leaf, ref,
 					BTRFS_MULTIPLE_OBJECTIDS);
-			btrfs_set_ref_offset(leaf, ref, 0);
 		}
 		ret = 0;
 	} else {
@@ -711,7 +708,7 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 				     u64 orig_parent, u64 parent,
 				     u64 orig_root, u64 ref_root,
 				     u64 orig_generation, u64 ref_generation,
-				     u64 owner_objectid, u64 owner_offset)
+				     u64 owner_objectid)
 {
 	int ret;
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
@@ -762,7 +759,7 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	ret = lookup_extent_backref(trans, extent_root, path,
 				    bytenr, orig_parent, orig_root,
-				    orig_generation, 1);
+				    orig_generation, owner_objectid, 1);
 	if (ret)
 		goto out;
 	ret = remove_extent_backref(trans, extent_root, path);
@@ -770,7 +767,7 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 		goto out;
 	ret = insert_extent_backref(trans, extent_root, path, bytenr,
 				    parent, ref_root, ref_generation,
-				    owner_objectid, owner_offset);
+				    owner_objectid);
 	BUG_ON(ret);
 	finish_current_insert(trans, extent_root);
 	del_pending_extents(trans, extent_root);
@@ -783,7 +780,7 @@ int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 bytenr,
 			    u64 orig_parent, u64 parent,
 			    u64 ref_root, u64 ref_generation,
-			    u64 owner_objectid, u64 owner_offset)
+			    u64 owner_objectid)
 {
 	int ret;
 	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
@@ -793,7 +790,7 @@ int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 	ret = __btrfs_update_extent_ref(trans, root, bytenr, orig_parent,
 					parent, ref_root, ref_root,
 					ref_generation, ref_generation,
-					owner_objectid, owner_offset);
+					owner_objectid);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -803,7 +800,7 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  u64 orig_parent, u64 parent,
 				  u64 orig_root, u64 ref_root,
 				  u64 orig_generation, u64 ref_generation,
-				  u64 owner_objectid, u64 owner_offset)
+				  u64 owner_objectid)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -845,7 +842,7 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
 				    path, bytenr, parent,
 				    ref_root, ref_generation,
-				    owner_objectid, owner_offset);
+				    owner_objectid);
 	BUG_ON(ret);
 	finish_current_insert(trans, root->fs_info->extent_root);
 	del_pending_extents(trans, root->fs_info->extent_root);
@@ -858,7 +855,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 ref_root, u64 ref_generation,
-			 u64 owner_objectid, u64 owner_offset)
+			 u64 owner_objectid)
 {
 	int ret;
 	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
@@ -867,7 +864,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	maybe_lock_mutex(root);
 	ret = __btrfs_inc_extent_ref(trans, root, bytenr, 0, parent,
 				     0, ref_root, 0, ref_generation,
-				     owner_objectid, owner_offset);
+				     owner_objectid);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -1179,7 +1176,7 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int ret = 0;
 	int faili = 0;
 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64, u64, u64, u64);
+			    u64, u64, u64, u64, u64, u64, u64, u64);
 
 	ref_root = btrfs_header_owner(buf);
 	ref_generation = btrfs_header_generation(buf);
@@ -1223,7 +1220,7 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 					   orig_buf->start, buf->start,
 					   orig_root, ref_root,
 					   orig_generation, ref_generation,
-					   key.objectid, key.offset);
+					   key.objectid);
 			maybe_unlock_mutex(root);
 
 			if (ret) {
@@ -1238,7 +1235,7 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 					   orig_buf->start, buf->start,
 					   orig_root, ref_root,
 					   orig_generation, ref_generation,
-					   level - 1, 0);
+					   level - 1);
 			maybe_unlock_mutex(root);
 			if (ret) {
 				faili = i;
@@ -1314,7 +1311,7 @@ int btrfs_update_ref(struct btrfs_trans_handle *trans,
 					    orig_buf->start, buf->start,
 					    orig_root, ref_root,
 					    orig_generation, ref_generation,
-					    key.objectid, key.offset);
+					    key.objectid);
 			maybe_unlock_mutex(root);
 			if (ret)
 				goto fail;
@@ -1325,7 +1322,7 @@ int btrfs_update_ref(struct btrfs_trans_handle *trans,
 					    orig_buf->start, buf->start,
 					    orig_root, ref_root,
 					    orig_generation, ref_generation,
-					    level - 1, 0);
+					    level - 1);
 			maybe_unlock_mutex(root);
 			if (ret)
 				goto fail;
@@ -1781,13 +1778,14 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 						start, extent_op->parent,
 						extent_root->root_key.objectid,
 						extent_op->generation,
-						extent_op->level, 0);
+						extent_op->level);
 			BUG_ON(err);
 		} else if (extent_op->type == PENDING_BACKREF_UPDATE) {
 			err = lookup_extent_backref(trans, extent_root, path,
 						start, extent_op->orig_parent,
 						extent_root->root_key.objectid,
-						extent_op->orig_generation, 0);
+						extent_op->orig_generation,
+						extent_op->level, 0);
 			BUG_ON(err);
 
 			clear_extent_bits(&info->extent_ins, start, end,
@@ -1870,8 +1868,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 ref_generation,
-			 u64 owner_objectid, u64 owner_offset,
-			 int pin, int mark_free)
+			 u64 owner_objectid, int pin, int mark_free)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -1894,8 +1891,9 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	path->reada = 1;
-	ret = lookup_extent_backref(trans, extent_root, path, bytenr, parent,
-				    root_objectid, ref_generation, 1);
+	ret = lookup_extent_backref(trans, extent_root, path,
+				    bytenr, parent, root_objectid,
+				    ref_generation, owner_objectid, 1);
 	if (ret == 0) {
 		struct btrfs_key found_key;
 		extent_slot = path->slots[0];
@@ -1926,9 +1924,8 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		btrfs_print_leaf(extent_root, path->nodes[0]);
 		WARN_ON(1);
 		printk("Unable to find ref byte nr %Lu root %Lu "
-		       " gen %Lu owner %Lu offset %Lu\n", bytenr,
-		       root_objectid, ref_generation, owner_objectid,
-		       owner_offset);
+		       "gen %Lu owner %Lu\n", bytenr,
+		       root_objectid, ref_generation, owner_objectid);
 	}
 
 	leaf = path->nodes[0];
@@ -2068,7 +2065,7 @@ free_extent:
 					    extent_op->orig_parent,
 					    extent_root->root_key.objectid,
 					    extent_op->orig_generation,
-					    extent_op->level, 0, 0, mark_free);
+					    extent_op->level, 0, mark_free);
 			kfree(extent_op);
 		} else {
 			kfree(extent_op);
@@ -2107,7 +2104,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 root_objectid, u64 ref_generation,
-			       u64 owner_objectid, u64 owner_offset, int pin)
+			       u64 owner_objectid, int pin)
 {
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	int pending_ret;
@@ -2156,8 +2153,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		pin = 1;
 
 	ret = __free_extent(trans, root, bytenr, num_bytes, parent,
-			    root_objectid, ref_generation, owner_objectid,
-			    owner_offset, pin, pin == 0);
+			    root_objectid, ref_generation,
+			    owner_objectid, pin, pin == 0);
 
 	finish_current_insert(trans, root->fs_info->extent_root);
 	pending_ret = del_pending_extents(trans, root->fs_info->extent_root);
@@ -2168,14 +2165,14 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent,
 		      u64 root_objectid, u64 ref_generation,
-		      u64 owner_objectid, u64 owner_offset, int pin)
+		      u64 owner_objectid, int pin)
 {
 	int ret;
 
 	maybe_lock_mutex(root);
 	ret = __btrfs_free_extent(trans, root, bytenr, num_bytes, parent,
 				  root_objectid, ref_generation,
-				  owner_objectid, owner_offset, pin);
+				  owner_objectid, pin);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -2522,8 +2519,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 					 struct btrfs_root *root, u64 parent,
 					 u64 root_objectid, u64 ref_generation,
-					 u64 owner, u64 owner_offset,
-					 struct btrfs_key *ins)
+					 u64 owner, struct btrfs_key *ins)
 {
 	int ret;
 	int pending_ret;
@@ -2597,7 +2593,6 @@ static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_ref_root(path->nodes[0], ref, root_objectid);
 	btrfs_set_ref_generation(path->nodes[0], ref, ref_generation);
 	btrfs_set_ref_objectid(path->nodes[0], ref, owner);
-	btrfs_set_ref_offset(path->nodes[0], ref, owner_offset);
 	btrfs_set_ref_num_refs(path->nodes[0], ref, 1);
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
@@ -2629,17 +2624,15 @@ out:
 int btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, u64 parent,
 				u64 root_objectid, u64 ref_generation,
-				u64 owner, u64 owner_offset,
-				struct btrfs_key *ins)
+				u64 owner, struct btrfs_key *ins)
 {
 	int ret;
 
 	if (root_objectid == BTRFS_TREE_LOG_OBJECTID)
 		return 0;
 	maybe_lock_mutex(root);
-	ret = __btrfs_alloc_reserved_extent(trans, root, parent,
-					    root_objectid, ref_generation,
-					    owner, owner_offset, ins);
+	ret = __btrfs_alloc_reserved_extent(trans, root, parent, root_objectid,
+					    ref_generation, owner, ins);
 	update_reserved_extents(root, ins->objectid, ins->offset, 0);
 	maybe_unlock_mutex(root);
 	return ret;
@@ -2653,8 +2646,7 @@ int btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, u64 parent,
 				u64 root_objectid, u64 ref_generation,
-				u64 owner, u64 owner_offset,
-				struct btrfs_key *ins)
+				u64 owner, struct btrfs_key *ins)
 {
 	int ret;
 	struct btrfs_block_group_cache *block_group;
@@ -2665,9 +2657,8 @@ int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_remove_free_space(block_group, ins->objectid, ins->offset);
 	BUG_ON(ret);
-	ret = __btrfs_alloc_reserved_extent(trans, root, parent,
-					    root_objectid, ref_generation,
-					    owner, owner_offset, ins);
+	ret = __btrfs_alloc_reserved_extent(trans, root, parent, root_objectid,
+					    ref_generation, owner, ins);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -2683,8 +2674,7 @@ int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
 		       u64 num_bytes, u64 parent, u64 min_alloc_size,
 		       u64 root_objectid, u64 ref_generation,
-		       u64 owner_objectid, u64 owner_offset,
-		       u64 empty_size, u64 hint_byte,
+		       u64 owner_objectid, u64 empty_size, u64 hint_byte,
 		       u64 search_end, struct btrfs_key *ins, u64 data)
 {
 	int ret;
@@ -2698,7 +2688,7 @@ int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
 		ret = __btrfs_alloc_reserved_extent(trans, root, parent,
 					root_objectid, ref_generation,
-					owner_objectid, owner_offset, ins);
+					owner_objectid, ins);
 		BUG_ON(ret);
 
 	} else {
@@ -2750,7 +2740,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 	struct extent_buffer *buf;
 
 	ret = btrfs_alloc_extent(trans, root, blocksize, parent, blocksize,
-				 root_objectid, ref_generation, level, 0,
+				 root_objectid, ref_generation, level,
 				 empty_size, hint, (u64)-1, &ins, 0);
 	if (ret) {
 		BUG_ON(ret > 0);
@@ -2800,7 +2790,7 @@ int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
 		ret = __btrfs_free_extent(trans, root, disk_bytenr,
 				btrfs_file_extent_disk_num_bytes(leaf, fi),
 				leaf->start, leaf_owner, leaf_generation,
-				key.objectid, key.offset, 0);
+				key.objectid, 0);
 		mutex_unlock(&root->fs_info->alloc_mutex);
 		BUG_ON(ret);
 
@@ -2824,7 +2814,7 @@ static int noinline cache_drop_leaf_ref(struct btrfs_trans_handle *trans,
 		ret = __btrfs_free_extent(trans, root, info->bytenr,
 					  info->num_bytes, ref->bytenr,
 					  ref->owner, ref->generation,
-					  info->objectid, info->offset, 0);
+					  info->objectid, 0);
 		mutex_unlock(&root->fs_info->alloc_mutex);
 
 		atomic_inc(&root->fs_info->throttle_gen);
@@ -2940,7 +2930,8 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
 			mutex_lock(&root->fs_info->alloc_mutex);
 			ret = __btrfs_free_extent(trans, root, bytenr,
 						blocksize, parent->start,
-						root_owner, root_gen, 0, 0, 1);
+						root_owner, root_gen,
+						*level - 1, 1);
 			BUG_ON(ret);
 			mutex_unlock(&root->fs_info->alloc_mutex);
 
@@ -2970,9 +2961,10 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
 				*level = 0;
 				break;
 			}
-			if (printk_ratelimit())
+			if (printk_ratelimit()) {
 				printk("leaf ref miss for bytenr %llu\n",
 				       (unsigned long long)bytenr);
+			}
 		}
 		next = btrfs_find_tree_block(root, bytenr, blocksize);
 		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
@@ -3020,7 +3012,7 @@ out:
 	mutex_lock(&root->fs_info->alloc_mutex);
 	ret = __btrfs_free_extent(trans, root, bytenr, blocksize,
 				  parent->start, root_owner, root_gen,
-				  0, 0, 1);
+				  *level, 1);
 	mutex_unlock(&root->fs_info->alloc_mutex);
 	free_extent_buffer(path->nodes[*level]);
 	path->nodes[*level] = NULL;
@@ -3073,8 +3065,8 @@ static int noinline walk_up_tree(struct btrfs_trans_handle *trans,
 			ret = btrfs_free_extent(trans, root,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len,
-						parent->start,
-						root_owner, root_gen, 0, 0, 1);
+						parent->start, root_owner,
+						root_gen, *level, 1);
 			BUG_ON(ret);
 			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] = NULL;
@@ -3308,7 +3300,6 @@ struct btrfs_ref_path {
 	u64 root_objectid;
 	u64 root_generation;
 	u64 owner_objectid;
-	u64 owner_offset;
 	u32 num_refs;
 	int lowest_level;
 	int current_level;
@@ -3480,7 +3471,6 @@ found:
 
 		if (ref_path->lowest_level == level) {
 			ref_path->owner_objectid = ref_objectid;
-			ref_path->owner_offset = btrfs_ref_offset(leaf, ref);
 			ref_path->num_refs = btrfs_ref_num_refs(leaf, ref);
 		}
 
@@ -3686,16 +3676,20 @@ static int noinline replace_one_extent(struct btrfs_trans_handle *trans,
 	u64 ext_offset;
 	u64 first_pos;
 	u32 nritems;
+	int nr_scaned = 0;
 	int extent_locked = 0;
 	int ret;
 
-	first_pos = ref_path->owner_offset;
+	memcpy(&key, leaf_key, sizeof(key));
+	first_pos = INT_LIMIT(loff_t) - extent_key->offset;
 	if (ref_path->owner_objectid != BTRFS_MULTIPLE_OBJECTIDS) {
-		key.objectid = ref_path->owner_objectid;
-		key.offset = ref_path->owner_offset;
-		key.type = BTRFS_EXTENT_DATA_KEY;
-	} else {
-		memcpy(&key, leaf_key, sizeof(key));
+		if (key.objectid < ref_path->owner_objectid ||
+		    (key.objectid == ref_path->owner_objectid &&
+		     key.type < BTRFS_EXTENT_DATA_KEY)) {
+			key.objectid = ref_path->owner_objectid;
+			key.type = BTRFS_EXTENT_DATA_KEY;
+			key.offset = 0;
+		}
 	}
 
 	while (1) {
@@ -3718,8 +3712,7 @@ next:
 		}
 
 		if (path->slots[0] >= nritems) {
-			if (ref_path->owner_objectid ==
-			    BTRFS_MULTIPLE_OBJECTIDS)
+			if (++nr_scaned > 2)
 				break;
 
 			BUG_ON(extent_locked);
@@ -3858,7 +3851,7 @@ next:
 						leaf->start,
 						root->root_key.objectid,
 						trans->transid,
-						key.objectid, key.offset);
+						key.objectid);
 			BUG_ON(ret);
 
 			ret = btrfs_free_extent(trans, root,
@@ -3867,7 +3860,7 @@ next:
 						leaf->start,
 						btrfs_header_owner(leaf),
 						btrfs_header_generation(leaf),
-						key.objectid, key.offset, 0);
+						key.objectid, 0);
 			BUG_ON(ret);
 
 			btrfs_release_path(root, path);
@@ -3925,8 +3918,7 @@ next:
 						new_extents[i].disk_num_bytes,
 						leaf->start,
 						root->root_key.objectid,
-						trans->transid,
-						key.objectid, key.offset);
+						trans->transid, key.objectid);
 				BUG_ON(ret);
 				btrfs_release_path(root, path);
 
@@ -4182,14 +4174,13 @@ static int noinline replace_extents_in_leaf(struct btrfs_trans_handle *trans,
 					new_extent->disk_num_bytes,
 					leaf->start,
 					root->root_key.objectid,
-					trans->transid,
-					key.objectid, key.offset);
+					trans->transid, key.objectid);
 		BUG_ON(ret);
 		ret = btrfs_free_extent(trans, root,
 					bytenr, num_bytes, leaf->start,
 					btrfs_header_owner(leaf),
 					btrfs_header_generation(leaf),
-					key.objectid, key.offset, 0);
+					key.objectid, 0);
 		BUG_ON(ret);
 		cond_resched();
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a03d1bb..51a4789 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -785,8 +785,7 @@ next_slot:
 						le64_to_cpu(old.disk_num_bytes),
 						leaf->start,
 						root->root_key.objectid,
-						trans->transid,
-						ins.objectid, ins.offset);
+						trans->transid, ins.objectid);
 				BUG_ON(ret);
 			}
 			btrfs_release_path(root, path);
@@ -806,8 +805,7 @@ next_slot:
 						disk_bytenr,
 						le64_to_cpu(old.disk_num_bytes),
 						leaf_start, root_owner,
-						root_gen, key.objectid,
-						key.offset, 0);
+						root_gen, key.objectid, 0);
 				BUG_ON(ret);
 				*hint_byte = disk_bytenr;
 			}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ff0c359..fe4d19d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -647,8 +647,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
 	ret = btrfs_alloc_reserved_extent(trans, root, leaf->start,
 					  root->root_key.objectid,
-					  trans->transid, inode->i_ino,
-					  ordered_extent->file_offset, &ins);
+					  trans->transid, inode->i_ino, &ins);
 	BUG_ON(ret);
 	btrfs_release_path(root, path);
 
@@ -1734,8 +1733,7 @@ delete:
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes,
 						leaf->start, root_owner,
-						root_gen, inode->i_ino,
-						found_key.offset, 0);
+						root_gen, inode->i_ino, 0);
 			BUG_ON(ret);
 		}
 next:
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 04de767..219487f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -658,7 +658,7 @@ long btrfs_ioctl_clone(struct file *file, unsigned long src_fd)
 						     ds, dl, leaf->start,
 						     root->root_key.objectid,
 						     trans->transid,
-						     inode->i_ino, key.offset);
+						     inode->i_ino);
 					BUG_ON(ret);
 				}
 			}
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 3577bad..bd9ab3e 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -102,11 +102,10 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_EXTENT_REF_KEY:
 			ref = btrfs_item_ptr(l, i, struct btrfs_extent_ref);
 			printk("\t\textent back ref root %llu gen %llu "
-			       "owner %llu offset %llu num_refs %lu\n",
+			       "owner %llu num_refs %lu\n",
 			       (unsigned long long)btrfs_ref_root(l, ref),
 			       (unsigned long long)btrfs_ref_generation(l, ref),
 			       (unsigned long long)btrfs_ref_objectid(l, ref),
-			       (unsigned long long)btrfs_ref_offset(l, ref),
 			       (unsigned long)btrfs_ref_num_refs(l, ref));
 			break;
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 88bbfd9..13d6cb0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -460,8 +460,7 @@ insert:
 						ins.objectid, ins.offset,
 						path->nodes[0]->start,
 						root->root_key.objectid,
-						trans->transid,
-						key->objectid, key->offset);
+						trans->transid, key->objectid);
 			} else {
 				/*
 				 * insert the extent pointer in the extent
@@ -471,7 +470,7 @@ insert:
 						path->nodes[0]->start,
 						root->root_key.objectid,
 						trans->transid, key->objectid,
-						key->offset, &ins);
+						&ins);
 				BUG_ON(ret);
 			}
 		}
@@ -2534,8 +2533,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 						   dst_path->nodes[0]->start,
 						   BTRFS_TREE_LOG_OBJECTID,
 						   trans->transid,
-						   ins_keys[i].objectid,
-						   ins_keys[i].offset);
+						   ins_keys[i].objectid);
 					BUG_ON(ret);
 				}
 			}
