From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 5/5] Btrfs: update disk extent ref generation
Date: Mon, 21 Nov 2011 18:10:24 +0800
Message-ID: <1321870224-20241-6-git-send-email-liubo2009@cn.fujitsu.com>
References: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <sensille@gmx.net>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We used to set disk extent refs' generation with transid,
but now with sub transid, it will cause a generation mismatch between
a tree block and its corresponding disk extent ref, and this will lead
to balance and scrub's crash.

Since these disk extent refs are delayed and stored in a rbtree,
the udpate will be easy.  When we update a block's generation, we
also update the related ref's generation in the rbtree.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.c       |   32 ++++++++++++--------
 fs/btrfs/ctree.h       |    6 +++-
 fs/btrfs/delayed-ref.c |    7 ++++-
 fs/btrfs/delayed-ref.h |    2 +
 fs/btrfs/disk-io.c     |    3 +-
 fs/btrfs/extent-tree.c |   72 ++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c       |    2 +-
 7 files changed, 95 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6cc9529..4ec35d9 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -227,6 +227,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	int level;
 	struct btrfs_disk_key disk_key;
+	u64 transid;
 
 	WARN_ON(root->ref_cows && trans->transaction->transid !=
 		root->fs_info->running_transaction->transid);
@@ -240,13 +241,13 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 
 	cow = btrfs_alloc_free_block(trans, root, buf->len, 0,
 				     new_root_objectid, &disk_key, level,
-				     buf->start, 0);
+				     buf->start, 0, &transid);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
 	copy_extent_buffer(cow, buf, 0, 0, cow->len);
 	btrfs_set_header_bytenr(cow, cow->start);
-	btrfs_set_header_generation(cow, trans->transaction->sub_transid);
+	btrfs_set_header_generation(cow, transid);
 	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN |
 				     BTRFS_HEADER_FLAG_RELOC);
@@ -419,6 +420,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	int last_ref = 0;
 	int unlock_orig = 0;
 	u64 parent_start;
+	u64 transid;
 
 	if (*cow_ret == buf)
 		unlock_orig = 1;
@@ -446,7 +448,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
 				     root->root_key.objectid, &disk_key,
-				     level, search_start, empty_size);
+				     level, search_start, empty_size, &transid);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
@@ -459,8 +461,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	    buf == root->node) {
 		btrfs_set_header_generation(cow, trans->transaction->transid);
 	} else {
-		btrfs_set_header_generation(cow,
-					    trans->transaction->sub_transid);
+		btrfs_set_header_generation(cow, transid);
 	}
 
 	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
@@ -556,6 +557,9 @@ static inline void update_block_generation(struct btrfs_trans_handle *trans,
 		return;
 
 	btrfs_set_header_generation(buf, transid);
+	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
+		btrfs_set_disk_extent_gen(trans, root, buf->start, buf->len,
+					  transid, 0);
 
 	if (buf == root->node) {
 		btrfs_mark_buffer_dirty(buf);
@@ -2154,6 +2158,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	struct extent_buffer *c;
 	struct extent_buffer *old;
 	struct btrfs_disk_key lower_key;
+	u64 transid;
 
 	BUG_ON(path->nodes[level]);
 	BUG_ON(path->nodes[level-1] != root->node);
@@ -2166,7 +2171,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 
 	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 				   root->root_key.objectid, &lower_key,
-				   level, root->node->start, 0);
+				   level, root->node->start, 0, &transid);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 
@@ -2188,8 +2193,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 					    trans->transaction->sub_transid);
 		btrfs_mark_buffer_dirty(lower);
 	} else {
-		btrfs_set_header_generation(c,
-					    trans->transaction->sub_transid);
+		btrfs_set_header_generation(c, transid);
 	}
 
 	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
@@ -2284,6 +2288,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	int ret;
 	int wret;
 	u32 c_nritems;
+	u64 transid;
 
 	c = path->nodes[level];
 	WARN_ON(btrfs_header_generation(c) < trans->transaction->transid);
@@ -2307,8 +2312,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_node_key(c, &disk_key, mid);
 
 	split = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
-					root->root_key.objectid,
-					&disk_key, level, c->start, 0);
+					root->root_key.objectid, &disk_key,
+					level, c->start, 0, &transid);
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
@@ -2317,7 +2322,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	memset_extent_buffer(split, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_level(split, btrfs_header_level(c));
 	btrfs_set_header_bytenr(split, split->start);
-	btrfs_set_header_generation(split, trans->transaction->sub_transid);
+	btrfs_set_header_generation(split, transid);
 	btrfs_set_header_backref_rev(split, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(split, root->root_key.objectid);
 	write_extent_buffer(split, root->fs_info->fsid,
@@ -2981,6 +2986,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	int split;
 	int num_doubles = 0;
 	int tried_avoid_double = 0;
+	u64 transid;
 
 	l = path->nodes[0];
 	slot = path->slots[0];
@@ -3063,7 +3069,7 @@ again:
 
 	right = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 					root->root_key.objectid,
-					&disk_key, 0, l->start, 0);
+					&disk_key, 0, l->start, 0, &transid);
 	if (IS_ERR(right))
 		return PTR_ERR(right);
 
@@ -3071,7 +3077,7 @@ again:
 
 	memset_extent_buffer(right, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_bytenr(right, right->start);
-	btrfs_set_header_generation(right, trans->transaction->sub_transid);
+	btrfs_set_header_generation(right, transid);
 	btrfs_set_header_backref_rev(right, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(right, root->root_key.objectid);
 	btrfs_set_header_level(right, 0);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a635f1c..7fd10eb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2276,7 +2276,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size);
+					u64 hint, u64 empty_size, u64 *gen_ret);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
@@ -2307,6 +2307,10 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
 				int is_data);
+int btrfs_set_disk_extent_gen(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      u64 bytenr, u64 num_bytes, u64 gen,
+			      int is_data);
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent,
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 125cf76..c5fb298 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -376,6 +376,11 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
 					ref->extent_op->flags_to_set;
 				existing_ref->extent_op->update_flags = 1;
 			}
+			if (ref->extent_op->update_gen) {
+				existing_ref->extent_op->generation =
+					ref->extent_op->generation;
+				existing_ref->extent_op->update_gen = 1;
+			}
 			kfree(ref->extent_op);
 		}
 	}
@@ -674,7 +679,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int ret;
 
-	head_ref = kmalloc(sizeof(*head_ref), GFP_NOFS);
+	head_ref = kmalloc(sizeof(*head_ref), GFP_ATOMIC);
 	if (!head_ref)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index e287e3b..098e4c2 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -57,8 +57,10 @@ struct btrfs_delayed_ref_node {
 struct btrfs_delayed_extent_op {
 	struct btrfs_disk_key key;
 	u64 flags_to_set;
+	u64 generation;
 	unsigned int update_key:1;
 	unsigned int update_flags:1;
+	unsigned int update_gen:1;
 	unsigned int is_data:1;
 };
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6e1a660..8a72f0d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1243,7 +1243,8 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 	root->ref_cows = 0;
 
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
-				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0);
+				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0,
+				      NULL);
 	if (IS_ERR(leaf)) {
 		kfree(root);
 		return ERR_CAST(leaf);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1311beb..2279386 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -89,7 +89,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 parent, u64 root_objectid,
 				     u64 flags, struct btrfs_disk_key *key,
-				     int level, struct btrfs_key *ins);
+				     u64 gen, int level, struct btrfs_key *ins);
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force);
@@ -1971,6 +1971,8 @@ static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 		bi = (struct btrfs_tree_block_info *)(ei + 1);
 		btrfs_set_tree_block_key(leaf, bi, &extent_op->key);
 	}
+	if (extent_op->update_gen)
+		btrfs_set_extent_generation(leaf, ei, extent_op->generation);
 }
 
 static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
@@ -2056,11 +2058,12 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	BUG_ON(node->ref_mod != 1);
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags ||
-		       !extent_op->update_key);
+		       !extent_op->update_key || !extent_op->update_gen);
 		ret = alloc_reserved_tree_block(trans, root,
 						parent, ref_root,
 						extent_op->flags_to_set,
 						&extent_op->key,
+						extent_op->generation,
 						ref->level, &ins);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
@@ -2347,29 +2350,67 @@ out:
 	return 0;
 }
 
-int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes, u64 flags,
-				int is_data)
+static int __btrfs_update_disk_extent_attr(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   u64 bytenr, u64 num_bytes,
+					   u64 flags, u64 gen,
+					   int update_flags, int update_gen,
+					   int is_data)
 {
 	struct btrfs_delayed_extent_op *extent_op;
 	int ret;
 
-	extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+	extent_op = kmalloc(sizeof(*extent_op), GFP_ATOMIC);
 	if (!extent_op)
 		return -ENOMEM;
 
-	extent_op->flags_to_set = flags;
-	extent_op->update_flags = 1;
+	extent_op->update_flags = 0;
 	extent_op->update_key = 0;
+	extent_op->update_gen = 0;
 	extent_op->is_data = is_data ? 1 : 0;
 
+	if (update_flags) {
+		extent_op->flags_to_set = flags;
+		extent_op->update_flags = 1;
+	}
+
+	if (update_gen) {
+		extent_op->generation = gen;
+		extent_op->update_gen = 1;
+	}
+
 	ret = btrfs_add_delayed_extent_op(trans, bytenr, num_bytes, extent_op);
 	if (ret)
 		kfree(extent_op);
 	return ret;
 }
 
+int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				u64 bytenr, u64 num_bytes, u64 flags,
+				int is_data)
+{
+	int ret;
+
+	ret = __btrfs_update_disk_extent_attr(trans, root, bytenr, num_bytes,
+					      flags, 0, 1, 0, is_data);
+	BUG_ON(ret);
+	return ret;
+}
+
+int btrfs_set_disk_extent_gen(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      u64 bytenr, u64 num_bytes, u64 gen,
+			      int is_data)
+{
+	int ret;
+
+	ret = __btrfs_update_disk_extent_attr(trans, root, bytenr, num_bytes,
+					      0, gen, 0, 1, is_data);
+	BUG_ON(ret);
+	return ret;
+}
+
 static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      struct btrfs_path *path,
@@ -5697,7 +5738,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 parent, u64 root_objectid,
 				     u64 flags, struct btrfs_disk_key *key,
-				     int level, struct btrfs_key *ins)
+				     u64 gen, int level, struct btrfs_key *ins)
 {
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -5721,7 +5762,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	extent_item = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_item);
 	btrfs_set_extent_refs(leaf, extent_item, 1);
-	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
+	btrfs_set_extent_generation(leaf, extent_item, gen);
 	btrfs_set_extent_flags(leaf, extent_item,
 			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
 	block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
@@ -5935,12 +5976,13 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size)
+					u64 hint, u64 empty_size, u64 *gen_ret)
 {
 	struct btrfs_key ins;
 	struct btrfs_block_rsv *block_rsv;
 	struct extent_buffer *buf;
 	u64 flags = 0;
+	u64 gen;
 	int ret;
 
 
@@ -5966,6 +6008,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 	} else
 		BUG_ON(parent > 0);
 
+	gen = trans->transaction->sub_transid;
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
 		struct btrfs_delayed_extent_op *extent_op;
 		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
@@ -5975,8 +6018,10 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		else
 			memset(&extent_op->key, 0, sizeof(extent_op->key));
 		extent_op->flags_to_set = flags;
+		extent_op->generation = gen;
 		extent_op->update_key = 1;
 		extent_op->update_flags = 1;
+		extent_op->update_gen = 1;
 		extent_op->is_data = 0;
 
 		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
@@ -5985,6 +6030,9 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					extent_op);
 		BUG_ON(ret);
 	}
+
+	if (gen_ret)
+		*gen_ret = gen;
 	return buf;
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c7c81e6..fe8876c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -358,7 +358,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 		return PTR_ERR(trans);
 
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
-				      0, objectid, NULL, 0, 0, 0);
+				      0, objectid, NULL, 0, 0, 0, NULL);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
 		goto fail;
-- 
1.6.5.2

