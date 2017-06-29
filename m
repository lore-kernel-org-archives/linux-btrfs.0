Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52068 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751790AbdF2D43 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 23:56:29 -0400
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, jeffm@suse.com, linux-btrfs@vger.kernel.org,
        lufq.fnst@cn.fujitsu.com
Subject: [PATCH v2 12/13] btrfs: allow backref search checks for shared extents
Date: Wed, 28 Jun 2017 21:57:04 -0600
Message-Id: <20170629035705.1589-13-enadolski@suse.com>
In-Reply-To: <20170629035705.1589-1-enadolski@suse.com>
References: <20170629035705.1589-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When called with a struct share_check, find_parent_nodes()
will detect a shared extent and immediately return with
BACKREF_SHARED_FOUND.

Signed-off-by: Edmund Nadolski <enadolski@suse.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c | 161 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 113 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 3cd4f05..5011b2f 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -135,6 +135,25 @@ struct preftrees {
 	struct preftree indirect_missing_keys;
 };
 
+/*
+ * Checks for a shared extent during backref search.
+ *
+ * The share_count tracks prelim_refs (direct and indirect) having a
+ * ref->count >0:
+ *  - incremented when a ref->count transitions to >0
+ *  - decremented when a ref->count transitions to <1
+ */
+struct share_check {
+	u64 root_objectid;
+	u64 inum;
+	int share_count;
+};
+
+static inline int extent_is_shared(struct share_check *sc)
+{
+	return (sc && sc->share_count > 1) ? BACKREF_FOUND_SHARED : 0;
+}
+
 static struct kmem_cache *btrfs_prelim_ref_cache;
 
 int __init btrfs_prelim_ref_init(void)
@@ -195,14 +214,26 @@ static int prelim_ref_compare(struct prelim_ref *ref1,
 	return 0;
 }
 
+void update_share_count(struct share_check *sc, int oldcount, int newcount)
+{
+	if ((!sc) || (oldcount == 0 && newcount < 1))
+		return;
+
+	if (oldcount > 0 && newcount < 1)
+		sc->share_count--;
+	else if (oldcount < 1 && newcount > 0)
+		sc->share_count++;
+}
+
 /*
  * Add @newref to the @root rbtree, merging identical refs.
  *
- * Callers should assumed that newref has been freed after calling.
+ * Callers should assume that newref has been freed after calling.
  */
 static void prelim_ref_insert(const struct btrfs_fs_info *fs_info,
 			      struct preftree *preftree,
-			      struct prelim_ref *newref)
+			      struct prelim_ref *newref,
+			      struct share_check *sc)
 {
 	struct rb_root *root;
 	struct rb_node **p;
@@ -234,12 +265,20 @@ static void prelim_ref_insert(const struct btrfs_fs_info *fs_info,
 				eie->next = newref->inode_list;
 			trace_btrfs_prelim_ref_merge(fs_info, ref, newref,
 						     preftree->count);
+			/*
+			 * A delayed ref can have newref->count < 0.
+			 * The ref->count is updated to follow any
+			 * BTRFS_[ADD|DROP]_DELAYED_REF actions.
+			 */
+			update_share_count(sc, ref->count,
+					   ref->count + newref->count);
 			ref->count += newref->count;
 			free_pref(newref);
 			return;
 		}
 	}
 
+	update_share_count(sc, 0, newref->count);
 	preftree->count++;
 	trace_btrfs_prelim_ref_insert(fs_info, newref, NULL, preftree->count);
 	rb_link_node(&newref->rbnode, parent, p);
@@ -303,7 +342,8 @@ static void prelim_release(struct preftree *preftree)
 static int add_prelim_ref(const struct btrfs_fs_info *fs_info,
 			  struct preftree *preftree, u64 root_id,
 			  const struct btrfs_key *key, int level, u64 parent,
-			  u64 wanted_disk_byte, int count, gfp_t gfp_mask)
+			  u64 wanted_disk_byte, int count,
+			  struct share_check *sc, gfp_t gfp_mask)
 {
 	struct prelim_ref *ref;
 
@@ -348,31 +388,32 @@ static int add_prelim_ref(const struct btrfs_fs_info *fs_info,
 	ref->count = count;
 	ref->parent = parent;
 	ref->wanted_disk_byte = wanted_disk_byte;
-	prelim_ref_insert(fs_info, preftree, ref);
-
-	return 0;
+	prelim_ref_insert(fs_info, preftree, ref, sc);
+	return extent_is_shared(sc);
 }
 
 /* direct refs use root == 0, key == NULL */
 static int add_direct_ref(const struct btrfs_fs_info *fs_info,
 			  struct preftrees *preftrees, int level, u64 parent,
-			  u64 wanted_disk_byte, int count, gfp_t gfp_mask)
+			  u64 wanted_disk_byte, int count,
+			  struct share_check *sc, gfp_t gfp_mask)
 {
 	return add_prelim_ref(fs_info, &preftrees->direct, 0, NULL, level,
-			      parent, wanted_disk_byte, count, gfp_mask);
+			      parent, wanted_disk_byte, count, sc, gfp_mask);
 }
 
 /* indirect refs use parent == 0 */
 static int add_indirect_ref(const struct btrfs_fs_info *fs_info,
 			    struct preftrees *preftrees, u64 root_id,
 			    const struct btrfs_key *key, int level,
-			    u64 wanted_disk_byte, int count, gfp_t gfp_mask)
+			    u64 wanted_disk_byte, int count,
+			    struct share_check *sc, gfp_t gfp_mask)
 {
 	struct preftree *tree = &preftrees->indirect;
 	if (!key)
 		tree = &preftrees->indirect_missing_keys;
 	return add_prelim_ref(fs_info, tree, root_id, key, level, 0,
-			      wanted_disk_byte, count, gfp_mask);
+			      wanted_disk_byte, count, sc, gfp_mask);
 }
 
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
@@ -570,7 +611,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path, u64 time_seq,
 				 struct preftrees *preftrees,
 				 const u64 *extent_item_pos, u64 total_refs,
-				 u64 root_objectid)
+				 struct share_check *sc)
 {
 	int err;
 	int ret = 0;
@@ -607,7 +648,8 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			continue;
 		}
 
-		if (root_objectid && ref->root_id != root_objectid) {
+		if (sc && sc->root_objectid &&
+		    ref->root_id != sc->root_objectid) {
 			free_pref(ref);
 			ret = BACKREF_FOUND_SHARED;
 			goto out;
@@ -649,11 +691,15 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			memcpy(new_ref, ref, sizeof(*ref));
 			new_ref->parent = node->val;
 			new_ref->inode_list = unode_aux_to_inode_list(node);
-			prelim_ref_insert(fs_info, &preftrees->direct, new_ref);
+			prelim_ref_insert(fs_info, &preftrees->direct,
+					  new_ref, NULL);
 		}
 
-		/* Now it's a direct ref, put it in the the direct tree */
-		prelim_ref_insert(fs_info, &preftrees->direct, ref);
+		/*
+		 * Now it's a direct ref, put it in the the direct tree. We must
+		 * do this last because the ref could be merged/freed here.
+		 */
+		prelim_ref_insert(fs_info, &preftrees->direct, ref, NULL);
 
 		ulist_reinit(parents);
 		cond_resched();
@@ -698,7 +744,7 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
 			btrfs_node_key_to_cpu(eb, &ref->key_for_search, 0);
 		btrfs_tree_read_unlock(eb);
 		free_extent_buffer(eb);
-		prelim_ref_insert(fs_info, &preftrees->indirect, ref);
+		prelim_ref_insert(fs_info, &preftrees->indirect, ref, NULL);
 		cond_resched();
 	}
 	return 0;
@@ -711,7 +757,7 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
 static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			    struct btrfs_delayed_ref_head *head, u64 seq,
 			    struct preftrees *preftrees, u64 *total_refs,
-			    u64 inum)
+			    struct share_check *sc)
 {
 	struct btrfs_delayed_ref_node *node;
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
@@ -756,7 +802,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 					       &tmp_op_key, ref->level + 1,
 					       node->bytenr,
 					       node->ref_mod * sgn,
-					       GFP_ATOMIC);
+					       sc, GFP_ATOMIC);
 			break;
 		}
 		case BTRFS_SHARED_BLOCK_REF_KEY: {
@@ -768,7 +814,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			ret = add_direct_ref(fs_info, preftrees,
 					     ref->level + 1, ref->parent,
 					     node->bytenr, node->ref_mod * sgn,
-					     GFP_ATOMIC);
+					     sc, GFP_ATOMIC);
 			break;
 		}
 		case BTRFS_EXTENT_DATA_REF_KEY: {
@@ -784,15 +830,15 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			 * Found a inum that doesn't match our known inum, we
 			 * know it's shared.
 			 */
-			if (inum && ref->objectid != inum) {
+			if (sc && sc->inum && ref->objectid != sc->inum) {
 				ret = BACKREF_FOUND_SHARED;
-				break;
+				goto out;
 			}
 
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
 					       &key, 0, node->bytenr,
 					       node->ref_mod * sgn,
-					       GFP_ATOMIC);
+					       sc, GFP_ATOMIC);
 			break;
 		}
 		case BTRFS_SHARED_DATA_REF_KEY: {
@@ -804,26 +850,35 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			ret = add_direct_ref(fs_info, preftrees, 0,
 					     ref->parent, node->bytenr,
 					     node->ref_mod * sgn,
-					     GFP_ATOMIC);
+					     sc, GFP_ATOMIC);
 			break;
 		}
 		default:
 			WARN_ON(1);
 		}
-		if (ret)
+		/*
+		 * We must ignore BACKREF_FOUND_SHARED until all delayed
+		 * refs have been checked.
+		 */
+		if (ret && (ret != BACKREF_FOUND_SHARED))
 			break;
 	}
+	if (!ret)
+		ret = extent_is_shared(sc);
+out:
 	spin_unlock(&head->lock);
 	return ret;
 }
 
 /*
  * add all inline backrefs for bytenr to the list
+ *
+ * Returns 0 on success, <0 on error, or BACKREF_FOUND_SHARED.
  */
 static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			   struct btrfs_path *path, u64 bytenr,
 			   int *info_level, struct preftrees *preftrees,
-			   u64 *total_refs, u64 inum)
+			   u64 *total_refs, struct share_check *sc)
 {
 	int ret = 0;
 	int slot;
@@ -880,7 +935,7 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 		case BTRFS_SHARED_BLOCK_REF_KEY:
 			ret = add_direct_ref(fs_info, preftrees,
 					     *info_level + 1, offset,
-					     bytenr, 1, GFP_NOFS);
+					     bytenr, 1, NULL, GFP_NOFS);
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY: {
 			struct btrfs_shared_data_ref *sdref;
@@ -890,13 +945,13 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			count = btrfs_shared_data_ref_count(leaf, sdref);
 
 			ret = add_direct_ref(fs_info, preftrees, 0, offset,
-					     bytenr, count, GFP_NOFS);
+					     bytenr, count, sc, GFP_NOFS);
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
 			ret = add_indirect_ref(fs_info, preftrees, offset,
 					       NULL, *info_level + 1,
-					       bytenr, 1, GFP_NOFS);
+					       bytenr, 1, NULL, GFP_NOFS);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY: {
 			struct btrfs_extent_data_ref *dref;
@@ -910,7 +965,7 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (inum && key.objectid != inum) {
+			if (sc && sc->inum && key.objectid != sc->inum) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -919,7 +974,7 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 
 			ret = add_indirect_ref(fs_info, preftrees, root,
 					       &key, 0, bytenr, count,
-					       GFP_NOFS);
+					       sc, GFP_NOFS);
 			break;
 		}
 		default:
@@ -935,11 +990,13 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 
 /*
  * add all non-inline backrefs for bytenr to the list
+ *
+ * Returns 0 on success, <0 on error, or BACKREF_FOUND_SHARED.
  */
 static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			  struct btrfs_path *path, u64 bytenr,
 			  int info_level, struct preftrees *preftrees,
-			  u64 inum)
+			  struct share_check *sc)
 {
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	int ret;
@@ -972,7 +1029,7 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			/* SHARED DIRECT METADATA backref */
 			ret = add_direct_ref(fs_info, preftrees,
 					     info_level + 1, key.offset,
-					     bytenr, 1, GFP_NOFS);
+					     bytenr, 1, NULL, GFP_NOFS);
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY: {
 			/* SHARED DIRECT FULL backref */
@@ -984,14 +1041,14 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			count = btrfs_shared_data_ref_count(leaf, sdref);
 			ret = add_direct_ref(fs_info, preftrees, 0,
 					     key.offset, bytenr, count,
-					     GFP_NOFS);
+					     sc, GFP_NOFS);
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
 			/* NORMAL INDIRECT METADATA backref */
 			ret = add_indirect_ref(fs_info, preftrees, key.offset,
 					       NULL, info_level + 1, bytenr,
-					       1, GFP_NOFS);
+					       1, NULL, GFP_NOFS);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY: {
 			/* NORMAL INDIRECT DATA backref */
@@ -1007,7 +1064,7 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (inum && key.objectid != inum) {
+			if (sc && sc->inum && key.objectid != sc->inum) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -1015,7 +1072,7 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			root = btrfs_extent_data_ref_root(leaf, dref);
 			ret = add_indirect_ref(fs_info, preftrees, root,
 					       &key, 0, bytenr, count,
-					       GFP_NOFS);
+					       sc, GFP_NOFS);
 			break;
 		}
 		default:
@@ -1035,20 +1092,23 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
  * indirect refs to their parent bytenr.
  * When roots are found, they're added to the roots list
  *
- * NOTE: This can return values > 0
- *
  * If time_seq is set to SEQ_LAST, it will not search delayed_refs, and behave
  * much like trans == NULL case, the difference only lies in it will not
  * commit root.
  * The special case is for qgroup to search roots in commit_transaction().
  *
+ * @sc - if !NULL, then immediately return BACKREF_FOUND_SHARED when a
+ * shared extent is detected.
+ *
+ * Otherwise this returns 0 for success and <0 for an error.
+ *
  * FIXME some caching might speed things up
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 time_seq, struct ulist *refs,
 			     struct ulist *roots, const u64 *extent_item_pos,
-			     u64 root_objectid, u64 inum)
+			     struct share_check *sc)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -1129,7 +1189,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			}
 			spin_unlock(&delayed_refs->lock);
 			ret = add_delayed_refs(fs_info, head, time_seq,
-					       &preftrees, &total_refs, inum);
+					       &preftrees, &total_refs, sc);
 			mutex_unlock(&head->mutex);
 			if (ret)
 				goto out;
@@ -1151,11 +1211,11 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 		     key.type == BTRFS_METADATA_ITEM_KEY)) {
 			ret = add_inline_refs(fs_info, path, bytenr,
 					      &info_level, &preftrees,
-					      &total_refs, inum);
+					      &total_refs, sc);
 			if (ret)
 				goto out;
 			ret = add_keyed_refs(fs_info, path, bytenr, info_level,
-					     &preftrees, inum);
+					     &preftrees, sc);
 			if (ret)
 				goto out;
 		}
@@ -1170,8 +1230,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	WARN_ON(!RB_EMPTY_ROOT(&preftrees.indirect_missing_keys.root));
 
 	ret = resolve_indirect_refs(fs_info, path, time_seq, &preftrees,
-				    extent_item_pos, total_refs,
-				    root_objectid);
+				    extent_item_pos, total_refs, sc);
 	if (ret)
 		goto out;
 
@@ -1190,7 +1249,8 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 		node = rb_next(&ref->rbnode);
 		WARN_ON(ref->count < 0);
 		if (roots && ref->count && ref->root_id && ref->parent == 0) {
-			if (root_objectid && ref->root_id != root_objectid) {
+			if (sc && sc->root_objectid &&
+			    ref->root_id != sc->root_objectid) {
 				ret = BACKREF_FOUND_SHARED;
 				goto out;
 			}
@@ -1294,7 +1354,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	ret = find_parent_nodes(trans, fs_info, bytenr, time_seq,
-				*leafs, NULL, extent_item_pos, 0, 0);
+				*leafs, NULL, extent_item_pos, NULL);
 	if (ret < 0 && ret != -ENOENT) {
 		free_leaf_list(*leafs);
 		return ret;
@@ -1337,7 +1397,7 @@ static int btrfs_find_all_roots_safe(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr, time_seq,
-					tmp, *roots, NULL, 0, 0);
+					tmp, *roots, NULL, NULL);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
@@ -1393,6 +1453,11 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 	struct ulist_node *node;
 	struct seq_list elem = SEQ_LIST_INIT(elem);
 	int ret = 0;
+	struct share_check shared = {
+		.root_objectid = root->objectid,
+		.inum = inum,
+		.share_count = 0,
+	};
 
 	tmp = ulist_alloc(GFP_NOFS);
 	roots = ulist_alloc(GFP_NOFS);
@@ -1413,7 +1478,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr, elem.seq, tmp,
-					roots, NULL, root->objectid, inum);
+					roots, NULL, &shared);
 		if (ret == BACKREF_FOUND_SHARED) {
 			/* this is the only condition under which we return 1 */
 			ret = 1;
-- 
2.10.2

