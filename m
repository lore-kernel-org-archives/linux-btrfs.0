From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 01/18] btrfs: mark delayed refs as for cow
Date: Thu,  6 Oct 2011 17:54:11 +0200
Message-ID: <a4cbe186682c0d2af39b8bcdd146dcfe9177737d.1317915010.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Add a for_cow parameter to add_delayed_*_ref and pass the
appropriate value from every call site. The for_cow parameter
will later on be used to determine if a ref will change anything
with respect to qgroups.
Delayed refs coming from relocation are always counted as for_cow,
as they don't change subvol quota.
Also pass in the fs_info for later use.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.c       |   20 +++++-----
 fs/btrfs/ctree.h       |   13 ++++---
 fs/btrfs/delayed-ref.c |   50 ++++++++++++++++----------
 fs/btrfs/delayed-ref.h |   15 +++++---
 fs/btrfs/extent-tree.c |   95 +++++++++++++++++++++++++++++-------------------
 fs/btrfs/file.c        |   10 +++---
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/ioctl.c       |    3 +-
 fs/btrfs/relocation.c  |   18 +++++----
 fs/btrfs/transaction.c |    4 +-
 fs/btrfs/tree-log.c    |    2 +-
 11 files changed, 136 insertions(+), 96 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 011cab3..51b387b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -261,9 +261,9 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
-		ret = btrfs_inc_ref(trans, root, cow, 1);
+		ret = btrfs_inc_ref(trans, root, cow, 1, 1);
 	else
-		ret = btrfs_inc_ref(trans, root, cow, 0);
+		ret = btrfs_inc_ref(trans, root, cow, 0, 1);
 
 	if (ret)
 		return ret;
@@ -350,14 +350,14 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		if ((owner == root->root_key.objectid ||
 		     root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) &&
 		    !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
-			ret = btrfs_inc_ref(trans, root, buf, 1);
+			ret = btrfs_inc_ref(trans, root, buf, 1, 1);
 			BUG_ON(ret);
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID) {
-				ret = btrfs_dec_ref(trans, root, buf, 0);
+				ret = btrfs_dec_ref(trans, root, buf, 0, 1);
 				BUG_ON(ret);
-				ret = btrfs_inc_ref(trans, root, cow, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 1, 1);
 				BUG_ON(ret);
 			}
 			new_flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
@@ -365,9 +365,9 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID)
-				ret = btrfs_inc_ref(trans, root, cow, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 1, 1);
 			else
-				ret = btrfs_inc_ref(trans, root, cow, 0);
+				ret = btrfs_inc_ref(trans, root, cow, 0, 1);
 			BUG_ON(ret);
 		}
 		if (new_flags != 0) {
@@ -381,11 +381,11 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID)
-				ret = btrfs_inc_ref(trans, root, cow, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 1, 1);
 			else
-				ret = btrfs_inc_ref(trans, root, cow, 0);
+				ret = btrfs_inc_ref(trans, root, cow, 0, 1);
 			BUG_ON(ret);
-			ret = btrfs_dec_ref(trans, root, buf, 1);
+			ret = btrfs_dec_ref(trans, root, buf, 1, 1);
 			BUG_ON(ret);
 		}
 		clean_tree_block(trans, root, buf);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 03912c5..68f2315 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2183,17 +2183,17 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  u64 search_end, struct btrfs_key *ins,
 				  u64 data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref);
+		  struct extent_buffer *buf, int full_backref, int for_cow);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref);
+		  struct extent_buffer *buf, int full_backref, int for_cow);
 int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
 				int is_data);
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
-		      u64 bytenr, u64 num_bytes, u64 parent,
-		      u64 root_objectid, u64 owner, u64 offset);
+		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
+		      u64 owner, u64 offset, int for_cow);
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
@@ -2205,7 +2205,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset);
+			 u64 root_objectid, u64 owner, u64 offset, int for_cow);
 
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
@@ -2366,7 +2366,8 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
 void btrfs_drop_snapshot(struct btrfs_root *root,
-			 struct btrfs_block_rsv *block_rsv, int update_ref);
+			 struct btrfs_block_rsv *block_rsv, int update_ref,
+			 int for_reloc);
 int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct extent_buffer *node,
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 125cf76..3a0f0ab 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -390,7 +390,8 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
  * this does all the dirty work in terms of maintaining the correct
  * overall modification count.
  */
-static noinline int add_delayed_ref_head(struct btrfs_trans_handle *trans,
+static noinline int add_delayed_ref_head(struct btrfs_fs_info *fs_info,
+					struct btrfs_trans_handle *trans,
 					struct btrfs_delayed_ref_node *ref,
 					u64 bytenr, u64 num_bytes,
 					int action, int is_data)
@@ -468,10 +469,12 @@ static noinline int add_delayed_ref_head(struct btrfs_trans_handle *trans,
 /*
  * helper to insert a delayed tree ref into the rbtree.
  */
-static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+static noinline int add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
+					 struct btrfs_trans_handle *trans,
 					 struct btrfs_delayed_ref_node *ref,
 					 u64 bytenr, u64 num_bytes, u64 parent,
-					 u64 ref_root, int level, int action)
+					 u64 ref_root, int level, int action,
+					 int for_cow)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_tree_ref *full_ref;
@@ -522,11 +525,12 @@ static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 /*
  * helper to insert a delayed data ref into the rbtree.
  */
-static noinline int add_delayed_data_ref(struct btrfs_trans_handle *trans,
+static noinline int add_delayed_data_ref(struct btrfs_fs_info *fs_info,
+					 struct btrfs_trans_handle *trans,
 					 struct btrfs_delayed_ref_node *ref,
 					 u64 bytenr, u64 num_bytes, u64 parent,
 					 u64 ref_root, u64 owner, u64 offset,
-					 int action)
+					 int action, int for_cow)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_data_ref *full_ref;
@@ -554,6 +558,7 @@ static noinline int add_delayed_data_ref(struct btrfs_trans_handle *trans,
 		full_ref->root = ref_root;
 		ref->type = BTRFS_EXTENT_DATA_REF_KEY;
 	}
+
 	full_ref->objectid = owner;
 	full_ref->offset = offset;
 
@@ -580,10 +585,12 @@ static noinline int add_delayed_data_ref(struct btrfs_trans_handle *trans,
  * to make sure the delayed ref is eventually processed before this
  * transaction commits.
  */
-int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
+			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root,  int level, int action,
-			       struct btrfs_delayed_extent_op *extent_op)
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int for_cow)
 {
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
@@ -610,12 +617,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
-				   action, 0);
+	ret = add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
+				   num_bytes, action, 0);
 	BUG_ON(ret);
 
-	ret = add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes,
-				   parent, ref_root, level, action);
+	ret = add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
+				   num_bytes, parent, ref_root, level, action,
+				   for_cow);
 	BUG_ON(ret);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
@@ -624,11 +632,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 /*
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
-int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
+int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
+			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, int action,
-			       struct btrfs_delayed_extent_op *extent_op)
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int for_cow)
 {
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
@@ -655,18 +665,20 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
-				   action, 1);
+	ret = add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
+				   num_bytes, action, 1);
 	BUG_ON(ret);
 
-	ret = add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes,
-				   parent, ref_root, owner, offset, action);
+	ret = add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
+				   num_bytes, parent, ref_root, owner, offset,
+				   action, for_cow);
 	BUG_ON(ret);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
 
-int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
+int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
+				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
 				struct btrfs_delayed_extent_op *extent_op)
 {
@@ -683,7 +695,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr,
+	ret = add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
 				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
 				   extent_op->is_data);
 	BUG_ON(ret);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index e287e3b..8316bff 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -151,16 +151,21 @@ static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
 	}
 }
 
-int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
+			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
-			       struct btrfs_delayed_extent_op *extent_op);
-int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int for_cow);
+int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
+			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, int action,
-			       struct btrfs_delayed_extent_op *extent_op);
-int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int for_cow);
+int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
+				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
 				struct btrfs_delayed_extent_op *extent_op);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f5be06a..29ac93e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1813,20 +1813,24 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset)
+			 u64 root_objectid, u64 owner, u64 offset, int for_cow)
 {
 	int ret;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
 	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
 	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes,
+		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
+					num_bytes,
 					parent, root_objectid, (int)owner,
-					BTRFS_ADD_DELAYED_REF, NULL);
+					BTRFS_ADD_DELAYED_REF, NULL, for_cow);
 	} else {
-		ret = btrfs_add_delayed_data_ref(trans, bytenr, num_bytes,
+		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
+					num_bytes,
 					parent, root_objectid, owner, offset,
-					BTRFS_ADD_DELAYED_REF, NULL);
+					BTRFS_ADD_DELAYED_REF, NULL, for_cow);
 	}
 	return ret;
 }
@@ -2346,7 +2350,8 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 	extent_op->update_key = 0;
 	extent_op->is_data = is_data ? 1 : 0;
 
-	ret = btrfs_add_delayed_extent_op(trans, bytenr, num_bytes, extent_op);
+	ret = btrfs_add_delayed_extent_op(root->fs_info, trans, bytenr,
+					  num_bytes, extent_op);
 	if (ret)
 		kfree(extent_op);
 	return ret;
@@ -2531,7 +2536,7 @@ out:
 static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
-			   int full_backref, int inc)
+			   int full_backref, int inc, int for_cow)
 {
 	u64 bytenr;
 	u64 num_bytes;
@@ -2544,7 +2549,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int level;
 	int ret = 0;
 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64);
+			    u64, u64, u64, u64, u64, u64, int);
 
 	ref_root = btrfs_header_owner(buf);
 	nritems = btrfs_header_nritems(buf);
@@ -2581,14 +2586,15 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			key.offset -= btrfs_file_extent_offset(buf, fi);
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, key.objectid,
-					   key.offset);
+					   key.offset, for_cow);
 			if (ret)
 				goto fail;
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
 			num_bytes = btrfs_level_size(root, level - 1);
 			ret = process_func(trans, root, bytenr, num_bytes,
-					   parent, ref_root, level - 1, 0);
+					   parent, ref_root, level - 1, 0,
+					   for_cow);
 			if (ret)
 				goto fail;
 		}
@@ -2600,15 +2606,15 @@ fail:
 }
 
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref)
+		  struct extent_buffer *buf, int full_backref, int for_cow)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 1);
+	return __btrfs_mod_ref(trans, root, buf, full_backref, 1, for_cow);
 }
 
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref)
+		  struct extent_buffer *buf, int full_backref, int for_cow)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 0);
+	return __btrfs_mod_ref(trans, root, buf, full_backref, 0, for_cow);
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
@@ -4673,10 +4679,11 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	int ret;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, buf->start, buf->len,
-						parent, root->root_key.objectid,
-						btrfs_header_level(buf),
-						BTRFS_DROP_DELAYED_REF, NULL);
+		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
+					buf->start, buf->len,
+					parent, root->root_key.objectid,
+					btrfs_header_level(buf),
+					BTRFS_DROP_DELAYED_REF, NULL, 0);
 		BUG_ON(ret);
 	}
 
@@ -4751,12 +4758,12 @@ out:
 	btrfs_put_block_group(cache);
 }
 
-int btrfs_free_extent(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root,
-		      u64 bytenr, u64 num_bytes, u64 parent,
-		      u64 root_objectid, u64 owner, u64 offset)
+int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
+		      u64 owner, u64 offset, int for_cow)
 {
 	int ret;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	/*
 	 * tree log blocks never actually go into the extent allocation
@@ -4768,14 +4775,17 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_pin_extent(root, bytenr, num_bytes, 1);
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes,
+		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
+					num_bytes,
 					parent, root_objectid, (int)owner,
-					BTRFS_DROP_DELAYED_REF, NULL);
+					BTRFS_DROP_DELAYED_REF, NULL, for_cow);
 		BUG_ON(ret);
 	} else {
-		ret = btrfs_add_delayed_data_ref(trans, bytenr, num_bytes,
-					parent, root_objectid, owner,
-					offset, BTRFS_DROP_DELAYED_REF, NULL);
+		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
+						num_bytes,
+						parent, root_objectid, owner,
+						offset, BTRFS_DROP_DELAYED_REF,
+						NULL, for_cow);
 		BUG_ON(ret);
 	}
 	return ret;
@@ -5573,9 +5583,10 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	BUG_ON(root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
-	ret = btrfs_add_delayed_data_ref(trans, ins->objectid, ins->offset,
-					 0, root_objectid, owner, offset,
-					 BTRFS_ADD_DELAYED_EXTENT, NULL);
+	ret = btrfs_add_delayed_data_ref(root->fs_info, trans, ins->objectid,
+					 ins->offset, 0,
+					 root_objectid, owner, offset,
+					 BTRFS_ADD_DELAYED_EXTENT, NULL, 0);
 	return ret;
 }
 
@@ -5787,10 +5798,11 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		extent_op->update_flags = 1;
 		extent_op->is_data = 0;
 
-		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
+		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
+					ins.objectid,
 					ins.offset, parent, root_objectid,
 					level, BTRFS_ADD_DELAYED_EXTENT,
-					extent_op);
+					extent_op, 0);
 		BUG_ON(ret);
 	}
 	return buf;
@@ -5807,6 +5819,7 @@ struct walk_control {
 	int keep_locks;
 	int reada_slot;
 	int reada_count;
+	int for_reloc;
 };
 
 #define DROP_REFERENCE	1
@@ -5945,9 +5958,9 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 	/* wc->stage == UPDATE_BACKREF */
 	if (!(wc->flags[level] & flag)) {
 		BUG_ON(!path->locks[level]);
-		ret = btrfs_inc_ref(trans, root, eb, 1);
+		ret = btrfs_inc_ref(trans, root, eb, 1, wc->for_reloc);
 		BUG_ON(ret);
-		ret = btrfs_dec_ref(trans, root, eb, 0);
+		ret = btrfs_dec_ref(trans, root, eb, 0, wc->for_reloc);
 		BUG_ON(ret);
 		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
 						  eb->len, flag, 0);
@@ -6091,7 +6104,7 @@ skip:
 		}
 
 		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
-					root->root_key.objectid, level - 1, 0);
+				root->root_key.objectid, level - 1, 0, 0);
 		BUG_ON(ret);
 	}
 	btrfs_tree_unlock(next);
@@ -6165,9 +6178,11 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 	if (wc->refs[level] == 1) {
 		if (level == 0) {
 			if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
-				ret = btrfs_dec_ref(trans, root, eb, 1);
+				ret = btrfs_dec_ref(trans, root, eb, 1,
+						    wc->for_reloc);
 			else
-				ret = btrfs_dec_ref(trans, root, eb, 0);
+				ret = btrfs_dec_ref(trans, root, eb, 0,
+						    wc->for_reloc);
 			BUG_ON(ret);
 		}
 		/* make block locked assertion in clean_tree_block happy */
@@ -6278,7 +6293,8 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
  * blocks are properly updated.
  */
 void btrfs_drop_snapshot(struct btrfs_root *root,
-			 struct btrfs_block_rsv *block_rsv, int update_ref)
+			 struct btrfs_block_rsv *block_rsv, int update_ref,
+			 int for_reloc)
 {
 	struct btrfs_path *path;
 	struct btrfs_trans_handle *trans;
@@ -6366,6 +6382,7 @@ void btrfs_drop_snapshot(struct btrfs_root *root,
 	wc->stage = DROP_REFERENCE;
 	wc->update_ref = update_ref;
 	wc->keep_locks = 0;
+	wc->for_reloc = for_reloc;
 	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
@@ -6450,6 +6467,7 @@ out:
  * drop subtree rooted at tree block 'node'.
  *
  * NOTE: this function will unlock and release tree block 'node'
+ * only used by relocation code
  */
 int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
@@ -6494,6 +6512,7 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 	wc->stage = DROP_REFERENCE;
 	wc->update_ref = 0;
 	wc->keep_locks = 1;
+	wc->for_reloc = 1;
 	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..61e1b80 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -678,7 +678,7 @@ next_slot:
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
 						new_key.objectid,
-						start - extent_offset);
+						start - extent_offset, 0);
 				BUG_ON(ret);
 				*hint_byte = disk_bytenr;
 			}
@@ -753,7 +753,7 @@ next_slot:
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
 						key.objectid, key.offset -
-						extent_offset);
+						extent_offset, 0);
 				BUG_ON(ret);
 				inode_sub_bytes(inode,
 						extent_end - key.offset);
@@ -962,7 +962,7 @@ again:
 
 		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
 					   root->root_key.objectid,
-					   ino, orig_offset);
+					   ino, orig_offset, 0);
 		BUG_ON(ret);
 
 		if (split == start) {
@@ -989,7 +989,7 @@ again:
 		del_nr++;
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
-					ino, orig_offset);
+					ino, orig_offset, 0);
 		BUG_ON(ret);
 	}
 	other_start = 0;
@@ -1006,7 +1006,7 @@ again:
 		del_nr++;
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
-					ino, orig_offset);
+					ino, orig_offset, 0);
 		BUG_ON(ret);
 	}
 	if (del_nr == 0) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc743..f7e4ba7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3314,7 +3314,7 @@ delete:
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes, 0,
 						btrfs_header_owner(leaf),
-						ino, extent_offset);
+						ino, extent_offset, 0);
 			BUG_ON(ret);
 		}
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..fade500 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2366,7 +2366,8 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 							disko, diskl, 0,
 							root->root_key.objectid,
 							btrfs_ino(inode),
-							new_key.offset - datao);
+							new_key.offset - datao,
+							0);
 					BUG_ON(ret);
 				}
 			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 59bb176..0b34182 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1602,12 +1602,12 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 		ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
 					   num_bytes, parent,
 					   btrfs_header_owner(leaf),
-					   key.objectid, key.offset);
+					   key.objectid, key.offset, 1);
 		BUG_ON(ret);
 
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					parent, btrfs_header_owner(leaf),
-					key.objectid, key.offset);
+					key.objectid, key.offset, 1);
 		BUG_ON(ret);
 	}
 	if (dirty)
@@ -1776,21 +1776,23 @@ again:
 
 		ret = btrfs_inc_extent_ref(trans, src, old_bytenr, blocksize,
 					path->nodes[level]->start,
-					src->root_key.objectid, level - 1, 0);
+					src->root_key.objectid, level - 1, 0,
+					1);
 		BUG_ON(ret);
 		ret = btrfs_inc_extent_ref(trans, dest, new_bytenr, blocksize,
 					0, dest->root_key.objectid, level - 1,
-					0);
+					0, 1);
 		BUG_ON(ret);
 
 		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
 					path->nodes[level]->start,
-					src->root_key.objectid, level - 1, 0);
+					src->root_key.objectid, level - 1, 0,
+					1);
 		BUG_ON(ret);
 
 		ret = btrfs_free_extent(trans, dest, old_bytenr, blocksize,
 					0, dest->root_key.objectid, level - 1,
-					0);
+					0, 1);
 		BUG_ON(ret);
 
 		btrfs_unlock_up_safe(path, 0);
@@ -2244,7 +2246,7 @@ again:
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
-		btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0);
+		btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0, 1);
 	}
 
 	if (found) {
@@ -2558,7 +2560,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 						node->eb->start, blocksize,
 						upper->eb->start,
 						btrfs_header_owner(upper->eb),
-						node->level, 0);
+						node->level, 0, 1);
 			BUG_ON(ret);
 
 			ret = btrfs_drop_subtree(trans, root, eb, upper->eb);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7dc36fa..b5ee16b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1413,9 +1413,9 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 
 		if (btrfs_header_backref_rev(root->node) <
 		    BTRFS_MIXED_BACKREF_REV)
-			btrfs_drop_snapshot(root, NULL, 0);
+			btrfs_drop_snapshot(root, NULL, 0, 0);
 		else
-			btrfs_drop_snapshot(root, NULL, 1);
+			btrfs_drop_snapshot(root, NULL, 1, 0);
 	}
 	return 0;
 }
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 786639f..1551e1e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -588,7 +588,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 				ret = btrfs_inc_extent_ref(trans, root,
 						ins.objectid, ins.offset,
 						0, root->root_key.objectid,
-						key->objectid, offset);
+						key->objectid, offset, 0);
 				BUG_ON(ret);
 			} else {
 				/*
-- 
1.7.3.4

