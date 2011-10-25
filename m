From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 56/66] btrfs: Delayed ref mempool functions should return void
Date: Mon, 24 Oct 2011 21:03:32 -0400
Message-ID: <20111025010856.990696748@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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
 fs/btrfs/ctree.h       |    8 ++--
 fs/btrfs/delayed-ref.c |   27 +++++++---------
 fs/btrfs/delayed-ref.h |   24 +++++++-------
 fs/btrfs/extent-tree.c |   78 ++++++++++++++++++++---------------------------
 fs/btrfs/inode.c       |    6 +--
 5 files changed, 63 insertions(+), 80 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ea47c73..f704253 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2179,10 +2179,10 @@ struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
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
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index a70c40d..16aea4e 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -586,10 +586,10 @@ static noinline void add_delayed_data_ref(struct btrfs_trans_handle *trans,
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
@@ -613,17 +613,16 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
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
@@ -647,12 +646,11 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
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
@@ -666,7 +664,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
 			     BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data);
 	spin_unlock(&delayed_refs->lock);
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 6c41d8d..8b2cec2 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -152,18 +152,18 @@ static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
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
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a706480..fe95f37 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1837,20 +1837,19 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
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
@@ -2363,7 +2362,6 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				int is_data)
 {
 	struct btrfs_delayed_extent_op *extent_op;
-	int ret;
 
 	extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
 	if (!extent_op)
@@ -2374,10 +2372,8 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
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
@@ -4767,11 +4763,10 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
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
@@ -4824,18 +4819,15 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
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
@@ -5624,19 +5616,16 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
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
@@ -5851,11 +5840,10 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
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
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1a9574f..46f3d4a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1706,10 +1706,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
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



