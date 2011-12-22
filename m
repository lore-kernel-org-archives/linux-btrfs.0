From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v1 03/10] Btrfs: mark delayed refs as for cow
Date: Thu, 22 Dec 2011 17:03:17 +0100
Message-ID: <66d7e7f09f77456fe68683247d77721032a00ee5.1324568415.git.list.btrfs@jan-o-sch.net>
References: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
Cc: lizf@cn.fujitsu.com, sensille@gmx.net
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Add a for_cow parameter to add_delayed_*_ref and pass the appropriate value
from every call site. The for_cow parameter will later on be used to
determine if a ref will change anything with respect to qgroups.

Delayed refs coming from relocation are always counted as for_cow, as they
don't change subvol quota.

Also pass in the fs_info for later use.

btrfs_find_all_roots() will use this as an optimization, as changes that are
for_cow will not change anything with respect to which root points to a
certain leaf. Thus, we don't need to add the current sequence number to
those delayed refs.

Signed-off-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c       |   42 ++++++++++----------
 fs/btrfs/ctree.h       |   17 ++++----
 fs/btrfs/delayed-ref.c |   50 +++++++++++++++---------
 fs/btrfs/delayed-ref.h |   15 +++++--
 fs/btrfs/disk-io.c     |    3 +-
 fs/btrfs/extent-tree.c |  101 ++++++++++++++++++++++++++++-------------------
 fs/btrfs/file.c        |   10 ++--
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/ioctl.c       |    5 +-
 fs/btrfs/relocation.c  |   18 +++++----
 fs/btrfs/transaction.c |    4 +-
 fs/btrfs/tree-log.c    |    2 +-
 12 files changed, 155 insertions(+), 114 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index dede441..0639a55 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -240,7 +240,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 
 	cow = btrfs_alloc_free_block(trans, root, buf->len, 0,
 				     new_root_objectid, &disk_key, level,
-				     buf->start, 0);
+				     buf->start, 0, 1);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
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
@@ -446,7 +446,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
 				     root->root_key.objectid, &disk_key,
-				     level, search_start, empty_size);
+				     level, search_start, empty_size, 1);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
@@ -484,7 +484,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		rcu_assign_pointer(root->node, cow);
 
 		btrfs_free_tree_block(trans, root, buf, parent_start,
-				      last_ref);
+				      last_ref, 1);
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
 	} else {
@@ -500,7 +500,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
 		btrfs_free_tree_block(trans, root, buf, parent_start,
-				      last_ref);
+				      last_ref, 1);
 	}
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
@@ -957,7 +957,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		free_extent_buffer(mid);
 
 		root_sub_used(root, mid->len);
-		btrfs_free_tree_block(trans, root, mid, 0, 1);
+		btrfs_free_tree_block(trans, root, mid, 0, 1, 0);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
 		return 0;
@@ -1015,7 +1015,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			if (wret)
 				ret = wret;
 			root_sub_used(root, right->len);
-			btrfs_free_tree_block(trans, root, right, 0, 1);
+			btrfs_free_tree_block(trans, root, right, 0, 1, 0);
 			free_extent_buffer(right);
 			right = NULL;
 		} else {
@@ -1055,7 +1055,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (wret)
 			ret = wret;
 		root_sub_used(root, mid->len);
-		btrfs_free_tree_block(trans, root, mid, 0, 1);
+		btrfs_free_tree_block(trans, root, mid, 0, 1, 0);
 		free_extent_buffer(mid);
 		mid = NULL;
 	} else {
@@ -2089,7 +2089,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 
 	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 				   root->root_key.objectid, &lower_key,
-				   level, root->node->start, 0);
+				   level, root->node->start, 0, 0);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 
@@ -2216,7 +2216,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 
 	split = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 					root->root_key.objectid,
-					&disk_key, level, c->start, 0);
+					&disk_key, level, c->start, 0, 0);
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
@@ -2970,7 +2970,7 @@ again:
 
 	right = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 					root->root_key.objectid,
-					&disk_key, 0, l->start, 0);
+					&disk_key, 0, l->start, 0, 0);
 	if (IS_ERR(right))
 		return PTR_ERR(right);
 
@@ -3781,7 +3781,7 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 
 	root_sub_used(root, leaf->len);
 
-	btrfs_free_tree_block(trans, root, leaf, 0, 1);
+	btrfs_free_tree_block(trans, root, leaf, 0, 1, 0);
 	return 0;
 }
 /*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3e4a07b..543f60b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2277,11 +2277,11 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size);
+					u64 hint, u64 empty_size, int for_cow);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
-			   u64 parent, int last_ref);
+			   u64 parent, int last_ref, int for_cow);
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
@@ -2301,17 +2301,17 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
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
 int btrfs_free_and_pin_reserved_extent(struct btrfs_root *root,
@@ -2323,7 +2323,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset);
+			 u64 root_objectid, u64 owner, u64 offset, int for_cow);
 
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
@@ -2492,7 +2492,8 @@ static inline int btrfs_next_item(struct btrfs_root *root, struct btrfs_path *p)
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
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 94abc25..6f8cd17 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1243,7 +1243,8 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 	root->ref_cows = 0;
 
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
-				      BTRFS_TREE_LOG_OBJECTID, NULL, 0, 0, 0);
+				      BTRFS_TREE_LOG_OBJECTID, NULL,
+				      0, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		kfree(root);
 		return ERR_CAST(leaf);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 813c6bb..dc8b9a8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1872,20 +1872,24 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
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
@@ -2405,7 +2409,8 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 	extent_op->update_key = 0;
 	extent_op->is_data = is_data ? 1 : 0;
 
-	ret = btrfs_add_delayed_extent_op(trans, bytenr, num_bytes, extent_op);
+	ret = btrfs_add_delayed_extent_op(root->fs_info, trans, bytenr,
+					  num_bytes, extent_op);
 	if (ret)
 		kfree(extent_op);
 	return ret;
@@ -2590,7 +2595,7 @@ out:
 static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
-			   int full_backref, int inc)
+			   int full_backref, int inc, int for_cow)
 {
 	u64 bytenr;
 	u64 num_bytes;
@@ -2603,7 +2608,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int level;
 	int ret = 0;
 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64);
+			    u64, u64, u64, u64, u64, u64, int);
 
 	ref_root = btrfs_header_owner(buf);
 	nritems = btrfs_header_nritems(buf);
@@ -2640,14 +2645,15 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
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
@@ -2659,15 +2665,15 @@ fail:
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
@@ -4937,16 +4943,17 @@ out:
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
-			   u64 parent, int last_ref)
+			   u64 parent, int last_ref, int for_cow)
 {
 	struct btrfs_block_group_cache *cache = NULL;
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
+					BTRFS_DROP_DELAYED_REF, NULL, for_cow);
 		BUG_ON(ret);
 	}
 
@@ -4981,12 +4988,12 @@ out:
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
@@ -4998,14 +5005,17 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
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
@@ -5826,9 +5836,10 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
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
 
@@ -5998,7 +6009,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size)
+					u64 hint, u64 empty_size, int for_cow)
 {
 	struct btrfs_key ins;
 	struct btrfs_block_rsv *block_rsv;
@@ -6042,10 +6053,11 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		extent_op->update_flags = 1;
 		extent_op->is_data = 0;
 
-		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
+		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
+					ins.objectid,
 					ins.offset, parent, root_objectid,
 					level, BTRFS_ADD_DELAYED_EXTENT,
-					extent_op);
+					extent_op, for_cow);
 		BUG_ON(ret);
 	}
 	return buf;
@@ -6062,6 +6074,7 @@ struct walk_control {
 	int keep_locks;
 	int reada_slot;
 	int reada_count;
+	int for_reloc;
 };
 
 #define DROP_REFERENCE	1
@@ -6200,9 +6213,9 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
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
@@ -6346,7 +6359,7 @@ skip:
 		}
 
 		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
-					root->root_key.objectid, level - 1, 0);
+				root->root_key.objectid, level - 1, 0, 0);
 		BUG_ON(ret);
 	}
 	btrfs_tree_unlock(next);
@@ -6420,9 +6433,11 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
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
@@ -6449,7 +6464,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			       btrfs_header_owner(path->nodes[level + 1]));
 	}
 
-	btrfs_free_tree_block(trans, root, eb, parent, wc->refs[level] == 1);
+	btrfs_free_tree_block(trans, root, eb, parent, wc->refs[level] == 1, 0);
 out:
 	wc->refs[level] = 0;
 	wc->flags[level] = 0;
@@ -6533,7 +6548,8 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
  * blocks are properly updated.
  */
 void btrfs_drop_snapshot(struct btrfs_root *root,
-			 struct btrfs_block_rsv *block_rsv, int update_ref)
+			 struct btrfs_block_rsv *block_rsv, int update_ref,
+			 int for_reloc)
 {
 	struct btrfs_path *path;
 	struct btrfs_trans_handle *trans;
@@ -6621,6 +6637,7 @@ void btrfs_drop_snapshot(struct btrfs_root *root,
 	wc->stage = DROP_REFERENCE;
 	wc->update_ref = update_ref;
 	wc->keep_locks = 0;
+	wc->for_reloc = for_reloc;
 	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
@@ -6705,6 +6722,7 @@ out:
  * drop subtree rooted at tree block 'node'.
  *
  * NOTE: this function will unlock and release tree block 'node'
+ * only used by relocation code
  */
 int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
@@ -6749,6 +6767,7 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 	wc->stage = DROP_REFERENCE;
 	wc->update_ref = 0;
 	wc->keep_locks = 1;
+	wc->for_reloc = 1;
 	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f2e9282..d2b60ed 100644
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
index c5ccec2..ea81938 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3139,7 +3139,7 @@ delete:
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes, 0,
 						btrfs_header_owner(leaf),
-						ino, extent_offset);
+						ino, extent_offset, 0);
 			BUG_ON(ret);
 		}
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 72d4616..c48f2e9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -358,7 +358,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 		return PTR_ERR(trans);
 
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
-				      0, objectid, NULL, 0, 0, 0);
+				      0, objectid, NULL, 0, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
 		goto fail;
@@ -2425,7 +2425,8 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
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
index dff29d5..8c1aae2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1604,12 +1604,12 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
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
@@ -1778,21 +1778,23 @@ again:
 
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
index 81376d9..a2bfedc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1393,9 +1393,9 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 
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
index f4d81c0..fce7b9e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -589,7 +589,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
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

