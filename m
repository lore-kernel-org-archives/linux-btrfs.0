From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 3/5] btrfs: split btrfs_alloc_free_block()
Date: Tue, 11 May 2010 16:24:52 +0800
Message-ID: <4BE91454.6030203@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

split btrfs_alloc_free_block() into btrfs_reserved_tree_block()
and btrfs_alloc_reserved_tree_block().

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 3/fs/btrfs/ctree.h 4/fs/btrfs/ctree.h
--- 3/fs/btrfs/ctree.h	2010-05-11 14:09:45.052107958 +0800
+++ 4/fs/btrfs/ctree.h	2010-05-11 13:15:47.060357000 +0800
@@ -1978,6 +1978,15 @@ struct btrfs_block_group_cache *btrfs_lo
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 u64 btrfs_find_block_group(struct btrfs_root *root,
 			   u64 search_start, u64 search_hint, int owner);
+struct extent_buffer *btrfs_reserve_tree_block(struct btrfs_trans_handle *trans,
+					       struct btrfs_root *root,
+					       u32 blocksize, int level,
+					       u64 hint, u64 empty_size);
+int btrfs_alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct extent_buffer *buf,
+				    u64 parent, u64 root_objectid,
+				    struct btrfs_disk_key *key, int level);
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
diff -urp 3/fs/btrfs/extent-tree.c 4/fs/btrfs/extent-tree.c
--- 3/fs/btrfs/extent-tree.c	2010-05-11 14:12:00.044357180 +0800
+++ 4/fs/btrfs/extent-tree.c	2010-05-11 13:26:38.036107000 +0800
@@ -4956,64 +4998,6 @@ int btrfs_alloc_logged_file_extent(struc
 	return ret;
 }
 
-/*
- * finds a free extent and does all the dirty work required for allocation
- * returns the key for the extent through ins, and a tree buffer for
- * the first block of the extent through buf.
- *
- * returns 0 if everything worked, non-zero otherwise.
- */
-static int alloc_tree_block(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    u64 num_bytes, u64 parent, u64 root_objectid,
-			    struct btrfs_disk_key *key, int level,
-			    u64 empty_size, u64 hint_byte, u64 search_end,
-			    struct btrfs_key *ins)
-{
-	int ret;
-	u64 flags = 0;
-
-	ret = btrfs_reserve_extent(trans, root, num_bytes, num_bytes,
-				   empty_size, hint_byte, search_end,
-				   ins, 0);
-	if (ret)
-		return ret;
-
-	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
-		if (parent == 0)
-			parent = ins->objectid;
-		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
-	} else
-		BUG_ON(parent > 0);
-
-	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
-		struct btrfs_delayed_extent_op *extent_op;
-		extent_op = kzalloc(sizeof(*extent_op), GFP_NOFS);
-		BUG_ON(!extent_op);
-		if (key)
-			memcpy(&extent_op->key, key, sizeof(extent_op->key));
-		extent_op->flags_to_set = flags;
-		extent_op->update_key = 1;
-		extent_op->update_gen = 1;
-		extent_op->update_flags = 1;
-
-		ret = btrfs_add_delayed_tree_ref(trans, ins->objectid,
-					ins->offset, parent, root_objectid,
-					level, BTRFS_ADD_DELAYED_EXTENT,
-					extent_op);
-		BUG_ON(ret);
-	}
-
-	if (root_objectid == root->root_key.objectid) {
-		u64 used;
-		spin_lock(&root->node_lock);
-		used = btrfs_root_used(&root->root_item) + num_bytes;
-		btrfs_set_root_used(&root->root_item, used);
-		spin_unlock(&root->node_lock);
-	}
-	return ret;
-}
-
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
@@ -5052,8 +5036,68 @@ struct extent_buffer *btrfs_init_new_buf
 	return buf;
 }
 
+struct extent_buffer *btrfs_reserve_tree_block(struct btrfs_trans_handle *trans,
+					       struct btrfs_root *root,
+					       u32 blocksize, int level,
+					       u64 hint, u64 empty_size)
+{
+
+	struct btrfs_key ins;
+	struct extent_buffer *buf;
+	int ret;
+
+	ret = btrfs_reserve_extent(trans, root, blocksize, blocksize,
+				   empty_size, hint, (u64)-1, &ins, 0);
+	if (ret)
+		return ERR_PTR(ret);
+
+	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
+				    blocksize, level);
+	BUG_ON(IS_ERR(buf));
+
+	return buf;
+}
+
+int btrfs_alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct extent_buffer *buf,
+				    u64 parent, u64 root_objectid,
+				    struct btrfs_disk_key *key, int level)
+{
+	struct btrfs_delayed_extent_op *extent_op;
+	int ret;
+
+	if (root_objectid == BTRFS_TREE_LOG_OBJECTID)
+		return 0;
+
+	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		if (parent == 0)
+			parent = buf->start;
+	} else
+		BUG_ON(parent > 0);
+
+	extent_op = kzalloc(sizeof(*extent_op), GFP_NOFS);
+	BUG_ON(!extent_op);
+	if (key)
+		memcpy(&extent_op->key, key, sizeof(extent_op->key));
+
+	if (parent > 0)
+		extent_op->flags_to_set = BTRFS_BLOCK_FLAG_FULL_BACKREF;
+	extent_op->update_key = 1;
+	extent_op->update_gen = 1;
+	extent_op->update_flags = 1;
+
+	ret = btrfs_add_delayed_tree_ref(trans, buf->start, buf->len,
+					 parent, root_objectid, level,
+					 BTRFS_ADD_DELAYED_EXTENT, extent_op);
+	return ret;
+}
+
 /*
- * helper function to allocate a block for a given tree
+ * finds a free extent and does all the dirty work required for allocation
+ * returns the key for the extent through ins, and a tree buffer for
+ * the first block of the extent through buf.
+ *
  * returns the tree buffer or NULL.
  */
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
@@ -5062,19 +5106,17 @@ struct extent_buffer *btrfs_alloc_free_b
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size)
 {
-	struct btrfs_key ins;
-	int ret;
 	struct extent_buffer *buf;
+	int ret;
 
-	ret = alloc_tree_block(trans, root, blocksize, parent, root_objectid,
-			       key, level, empty_size, hint, (u64)-1, &ins);
-	if (ret) {
-		BUG_ON(ret > 0);
-		return ERR_PTR(ret);
-	}
+	buf = btrfs_reserve_tree_block(trans, root, blocksize, level,
+				       hint, empty_size);
+	if (IS_ERR(buf))
+		return ERR_CAST(buf);
 
-	buf = btrfs_init_new_buffer(trans, root, ins.objectid,
-				    blocksize, level);
+	ret = btrfs_alloc_reserved_tree_block(trans, root, buf, parent,
+					      root_objectid, key, level);
+	BUG_ON(ret);
 	return buf;
 }
 
