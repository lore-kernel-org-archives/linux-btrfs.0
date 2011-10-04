From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 55/65] btrfs: Delayed ref mempool functions should return void
Date: Mon, 03 Oct 2011 23:23:25 -0400
Message-ID: <20111004032306.219698154@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that the delayed ref code uses mempools, allocations can't fail,
 and there are no more error conditions to report.

 This patch makes the following functions return void:
 - btrfs_alloc_reserved_file_extent
 - btrfs_add_delayed_tree_ref
 - btrfs_add_delayed_data_ref
 - btrfs_add_delayed_extent_op

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |    8 ++---
 fs/btrfs/delayed-ref.c |   27 +++++++---------
 fs/btrfs/delayed-ref.h |   24 +++++++--------
 fs/btrfs/extent-tree.c |   78 ++++++++++++++++++++-----------------------------
 fs/btrfs/inode.c       |    6 +--
 5 files changed, 63 insertions(+), 80 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2169,10 +2169,10 @@ struct extent_buffer *btrfs_init_new_buf
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
 					    int level);
-int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root,
-				     u64 root_objectid, u64 owner,
-				     u64 offset, struct btrfs_key *ins);
+void btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      u64 root_objectid, u64 owner,
+				      u64 offset, struct btrfs_key *ins);
 int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   u64 root_objectid, u64 owner, u64 offset,
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -586,10 +586,10 @@ static noinline void add_delayed_data_re
  * to make sure the delayed ref is eventually processed before this
  * transaction commits.
  */
-int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes, u64 parent,
-			       u64 ref_root,  int level, int action,
-			       struct btrfs_delayed_extent_op *extent_op)
+void btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+			        u64 bytenr, u64 num_bytes, u64 parent,
+			        u64 ref_root,  int level, int action,
+			        struct btrfs_delayed_extent_op *extent_op)
 {
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
@@ -613,17 +613,16 @@ int btrfs_add_delayed_tree_ref(struct bt
 	add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes, parent,
 			     ref_root, level, action);
 	spin_unlock(&delayed_refs->lock);
-	return 0;
 }
 
 /*
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
-int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes,
-			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, int action,
-			       struct btrfs_delayed_extent_op *extent_op)
+void btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
+			        u64 bytenr, u64 num_bytes,
+			        u64 parent, u64 ref_root,
+			        u64 owner, u64 offset, int action,
+			        struct btrfs_delayed_extent_op *extent_op)
 {
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
@@ -647,12 +646,11 @@ int btrfs_add_delayed_data_ref(struct bt
 	add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes, parent,
 			     ref_root, owner, offset, action);
 	spin_unlock(&delayed_refs->lock);
-	return 0;
 }
 
-int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
-				u64 bytenr, u64 num_bytes,
-				struct btrfs_delayed_extent_op *extent_op)
+void btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
+				 u64 bytenr, u64 num_bytes,
+				 struct btrfs_delayed_extent_op *extent_op)
 {
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
@@ -666,7 +664,6 @@ int btrfs_add_delayed_extent_op(struct b
 	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
 			     BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data);
 	spin_unlock(&delayed_refs->lock);
-	return 0;
 }
 
 /*
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -152,18 +152,18 @@ static inline void btrfs_put_delayed_ref
 	}
 }
 
-int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes, u64 parent,
-			       u64 ref_root, int level, int action,
-			       struct btrfs_delayed_extent_op *extent_op);
-int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes,
-			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, int action,
-			       struct btrfs_delayed_extent_op *extent_op);
-int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
-				u64 bytenr, u64 num_bytes,
-				struct btrfs_delayed_extent_op *extent_op);
+void btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+			        u64 bytenr, u64 num_bytes, u64 parent,
+			        u64 ref_root, int level, int action,
+			        struct btrfs_delayed_extent_op *extent_op);
+void btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
+			        u64 bytenr, u64 num_bytes,
+			        u64 parent, u64 ref_root,
+			        u64 owner, u64 offset, int action,
+			        struct btrfs_delayed_extent_op *extent_op);
+void btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
+			         u64 bytenr, u64 num_bytes,
+				 struct btrfs_delayed_extent_op *extent_op);
 
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1821,20 +1821,19 @@ int btrfs_inc_extent_ref(struct btrfs_tr
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner, u64 offset)
 {
-	int ret;
 	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
 	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes,
-					parent, root_objectid, (int)owner,
-					BTRFS_ADD_DELAYED_REF, NULL);
+		btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes, parent,
+					   root_objectid, (int)owner,
+					   BTRFS_ADD_DELAYED_REF, NULL);
 	} else {
-		ret = btrfs_add_delayed_data_ref(trans, bytenr, num_bytes,
-					parent, root_objectid, owner, offset,
-					BTRFS_ADD_DELAYED_REF, NULL);
+		btrfs_add_delayed_data_ref(trans, bytenr, num_bytes, parent,
+					   root_objectid, owner, offset,
+					   BTRFS_ADD_DELAYED_REF, NULL);
 	}
-	return ret;
+	return 0;
 }
 
 static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
@@ -2347,7 +2346,6 @@ int btrfs_set_disk_extent_flags(struct b
 				int is_data)
 {
 	struct btrfs_delayed_extent_op *extent_op;
-	int ret;
 
 	extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
 	if (!extent_op)
@@ -2358,10 +2356,8 @@ int btrfs_set_disk_extent_flags(struct b
 	extent_op->update_key = 0;
 	extent_op->is_data = is_data ? 1 : 0;
 
-	ret = btrfs_add_delayed_extent_op(trans, bytenr, num_bytes, extent_op);
-	if (ret)
-		kfree(extent_op);
-	return ret;
+	btrfs_add_delayed_extent_op(trans, bytenr, num_bytes, extent_op);
+	return 0;
 }
 
 static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
@@ -4687,11 +4683,10 @@ void btrfs_free_tree_block(struct btrfs_
 	int ret;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, buf->start, buf->len,
-						parent, root->root_key.objectid,
-						btrfs_header_level(buf),
-						BTRFS_DROP_DELAYED_REF, NULL);
-		BUG_ON(ret);
+		btrfs_add_delayed_tree_ref(trans, buf->start, buf->len,
+					   parent, root->root_key.objectid,
+					   btrfs_header_level(buf),
+					   BTRFS_DROP_DELAYED_REF, NULL);
 	}
 
 	if (!last_ref)
@@ -4784,18 +4779,15 @@ int btrfs_free_extent(struct btrfs_trans
 			btrfs_panic(root->fs_info, ret, "Cannot pin "
 				    "extent in range %llu(%llu)\n",
 				    bytenr, num_bytes);
-	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes,
-					parent, root_objectid, (int)owner,
-					BTRFS_DROP_DELAYED_REF, NULL);
-		BUG_ON(ret);
-	} else {
-		ret = btrfs_add_delayed_data_ref(trans, bytenr, num_bytes,
-					parent, root_objectid, owner,
-					offset, BTRFS_DROP_DELAYED_REF, NULL);
-		BUG_ON(ret);
-	}
-	return ret;
+	} else if (owner < BTRFS_FIRST_FREE_OBJECTID)
+		btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes, parent,
+					   root_objectid, (int)owner,
+					   BTRFS_DROP_DELAYED_REF, NULL);
+	else
+		btrfs_add_delayed_data_ref(trans, bytenr, num_bytes, parent,
+					   root_objectid, owner, offset,
+					   BTRFS_DROP_DELAYED_REF, NULL);
+	return 0;
 }
 
 static u64 stripe_align(struct btrfs_root *root, u64 val)
@@ -5581,19 +5573,16 @@ static int alloc_reserved_tree_block(str
 	return ret;
 }
 
-int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root,
-				     u64 root_objectid, u64 owner,
-				     u64 offset, struct btrfs_key *ins)
+void btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      u64 root_objectid, u64 owner,
+				      u64 offset, struct btrfs_key *ins)
 {
-	int ret;
-
 	BUG_ON(root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
-	ret = btrfs_add_delayed_data_ref(trans, ins->objectid, ins->offset,
-					 0, root_objectid, owner, offset,
-					 BTRFS_ADD_DELAYED_EXTENT, NULL);
-	return ret;
+	btrfs_add_delayed_data_ref(trans, ins->objectid, ins->offset,
+				   0, root_objectid, owner, offset,
+				   BTRFS_ADD_DELAYED_EXTENT, NULL);
 }
 
 /*
@@ -5812,11 +5801,10 @@ struct extent_buffer *btrfs_alloc_free_b
 		extent_op->update_flags = 1;
 		extent_op->is_data = 0;
 
-		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
-					ins.offset, parent, root_objectid,
-					level, BTRFS_ADD_DELAYED_EXTENT,
-					extent_op);
-		BUG_ON(ret);
+		btrfs_add_delayed_tree_ref(trans, ins.objectid,
+					   ins.offset, parent, root_objectid,
+					   level, BTRFS_ADD_DELAYED_EXTENT,
+					   extent_op);
 	}
 	return buf;
 }
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1706,10 +1706,8 @@ static int insert_reserved_file_extent(s
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
-	ret = btrfs_alloc_reserved_file_extent(trans, root,
-					root->root_key.objectid,
-					btrfs_ino(inode), file_pos, &ins);
-	BUG_ON(ret);
+	btrfs_alloc_reserved_file_extent(trans, root, root->root_key.objectid,
+					 btrfs_ino(inode), file_pos, &ins);
 	btrfs_free_path(path);
 
 	return 0;



