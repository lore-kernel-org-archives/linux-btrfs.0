Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965749AbaFSVut (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 17:50:49 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: btrfs: qgroup: account shared subtrees during snapshot delete
Date: Thu, 19 Jun 2014 14:49:27 -0700
Message-Id: <1403214567-3137-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1403214567-3137-1-git-send-email-mfasheh@suse.de>
References: <1403214567-3137-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During it's tree walk, btrfs_drop_snapshot() will skip any shared
subtrees it encounters. This is incorrect when we have qgroups
turned on as those subtrees need to have their contents
accounted. In particular, the case we're concerned with is when
removing our snapshot root leaves the subtree with only one root
reference.

In those cases we need to find the last remaining root and add
each extent in the subtree to the corresponding qgroup exclusive
counts.

This patch implements the shared subtree walk and a new qgroup
operation, BTRFS_QGROUP_OPER_SUB_SUBTREE. When an operation of
this type is encountered during qgroup accounting, we search for
any root references to that extent and in the case that we find
only one reference left, we go ahead and do the math on it's
exclusive counts.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/extent-tree.c       | 234 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.c            | 166 ++++++++++++++++++++++++++++--
 fs/btrfs/qgroup.h            |   1 +
 include/trace/events/btrfs.h |   3 +-
 4 files changed, 397 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 46f39bf..672d2a4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7324,6 +7324,237 @@ reada:
 	wc->reada_slot = slot;
 }
 
+static int account_leaf_items(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root,
+			      struct extent_buffer *eb)
+{
+	int nr = btrfs_header_nritems(eb);
+	int i, extent_type, ret;
+	struct btrfs_key key;
+	struct btrfs_file_extent_item *fi;
+	u64 bytenr, num_bytes;
+
+	for (i = 0; i < nr; i++) {
+		btrfs_item_key_to_cpu(eb, &key, i);
+
+		if (key.type != BTRFS_EXTENT_DATA_KEY)
+			continue;
+
+		fi = btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
+		/* filter out non qgroup-accountable extents  */
+		extent_type = btrfs_file_extent_type(eb, fi);
+
+		if (extent_type == BTRFS_FILE_EXTENT_INLINE)
+			continue;
+
+		bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
+		if (!bytenr)
+			continue;
+
+		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
+
+		ret = btrfs_qgroup_record_ref(trans, root->fs_info,
+					      root->objectid,
+					      bytenr, num_bytes,
+					      BTRFS_QGROUP_OPER_SUB_SUBTREE, 0);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/*
+ * Walk up the tree from the bottom, freeing leaves and any interior
+ * nodes which have had all slots visited. If a node (leaf or
+ * interior) is freed, the node above it will have it's slot
+ * incremented. The root node will never be freed.
+ *
+ * At the end of this function, we should have a path which has all
+ * slots incremented to the next position for a search. If we need to
+ * read a new node it will be NULL and the node above it will have the
+ * correct slot selected for a later read.
+ *
+ * If we increment the root nodes slot counter past the number of
+ * elements, 1 is returned to signal completion of the search.
+ */
+static int adjust_slots_upwards(struct btrfs_root *root,
+				struct btrfs_path *path, int root_level)
+{
+	int level = 0;
+	int nr, slot;
+	struct extent_buffer *eb;
+
+	if (root_level == 0)
+		return 1;
+
+	while (level <= root_level) {
+		eb = path->nodes[level];
+		nr = btrfs_header_nritems(eb);
+		path->slots[level]++;
+		slot = path->slots[level];
+		if (slot >= nr || level == 0) {
+			/*
+			 * Don't free the root -  we will detect this
+			 * condition after our loop and return a
+			 * positive value for caller to stop walking the tree.
+			 */
+			if (level != root_level) {
+				btrfs_tree_unlock_rw(eb, path->locks[level]);
+				path->locks[level] = 0;
+
+				free_extent_buffer(eb);
+				path->nodes[level] = NULL;
+				path->slots[level] = 0;
+			}
+		} else {
+			/*
+			 * We have a valid slot to walk back down
+			 * from. Stop here so caller can process these
+			 * new nodes.
+			 */
+			break;
+		}
+
+		level++;
+	}
+
+	eb = path->nodes[root_level];
+	if (path->slots[root_level] >= btrfs_header_nritems(eb))
+		return 1;
+
+	return 0;
+}
+
+/*
+ * root_eb is the subtree root and is locked before this function is called.
+ */
+static int account_shared_subtree(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct extent_buffer *root_eb,
+				  u64 root_gen,
+				  int root_level)
+{
+	int ret;
+	int level;
+	struct extent_buffer *eb = root_eb;
+	struct btrfs_path *path = NULL;
+
+	BUG_ON(root_level < 0 || root_level > BTRFS_MAX_LEVEL);
+	BUG_ON(root_eb == NULL);
+
+	if (!root->fs_info->quota_enabled)
+		return 0;
+
+	if (!extent_buffer_uptodate(root_eb)) {
+		ret = btrfs_read_buffer(root_eb, root_gen);
+		if (ret)
+			goto out;
+	}
+	/* XXX: Is this check necessary? */
+	if (!extent_buffer_uptodate(root_eb)) {
+		ret = -EIO;
+		goto out;
+	}
+
+	if (root_level == 0) {
+		ret = account_leaf_items(trans, root, root_eb);
+		if (ret)
+			goto out;
+		goto out_done;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/*
+	 * Walk down the tree.  Missing extent blocks are filled in as
+	 * we go. Metadata is accounted every time we read a new
+	 * extent block.
+	 *
+	 * When we reach a leaf, we account for file extent items in it,
+	 * walk back up the tree (adjusting slot pointers as we go)
+	 * and restart the search process.
+	 */
+	extent_buffer_get(root_eb); /* For path */
+	path->nodes[root_level] = root_eb;
+	path->slots[root_level] = 0;
+	path->locks[root_level] = 0; /* so release_path doesn't try to unlock */
+walk_down:
+	level = root_level;
+	while (level >= 0) {
+		if (path->nodes[level] == NULL) {
+			int child_bsize = btrfs_level_size(root, level);
+			int parent_slot;
+			u64 child_gen;
+			u64 child_bytenr;
+
+			/* We need to get child blockptr/gen from
+			 * parent before we can read it. */
+			eb = path->nodes[level + 1];
+			parent_slot = path->slots[level + 1];
+			child_bytenr = btrfs_node_blockptr(eb, parent_slot);
+			child_gen = btrfs_node_ptr_generation(eb, parent_slot);
+
+			eb = read_tree_block(root, child_bytenr, child_bsize,
+					     child_gen);
+			if (!eb || !extent_buffer_uptodate(eb)) {
+				ret = -EIO;
+				goto out;
+			}
+
+			path->nodes[level] = eb;
+			path->slots[level] = 0;
+
+			btrfs_tree_read_lock(eb);
+			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
+
+			ret = btrfs_qgroup_record_ref(trans, root->fs_info,
+						root->objectid,
+						child_bytenr,
+						child_bsize,
+						BTRFS_QGROUP_OPER_SUB_SUBTREE,
+						0);
+			if (ret)
+				goto out;
+
+		}
+
+		if (level == 0) {
+			ret = account_leaf_items(trans, root, path->nodes[level]);
+			if (ret)
+				goto out;
+
+			/* Nonzero return here means we completed our search */
+			ret = adjust_slots_upwards(root, path, root_level);
+			if (ret)
+				break;
+
+			/* Restart search with new slots */
+			goto walk_down;
+		}
+
+		level--;
+	}
+
+out_done:
+	ret = btrfs_qgroup_record_ref(trans, root->fs_info,
+				      root->objectid, root_eb->start,
+				      btrfs_level_size(root, root_level),
+				      BTRFS_QGROUP_OPER_SUB_SUBTREE, 0);
+	if (ret)
+		goto out;
+
+	ret = 0;
+out:
+
+	if (path)
+		btrfs_free_path(path);
+
+	return ret;
+}
+
 /*
  * helper to process tree block while walking down the tree.
  *
@@ -7472,6 +7703,9 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 
 	if (wc->stage == DROP_REFERENCE) {
 		if (wc->refs[level - 1] > 1) {
+			account_shared_subtree(trans, root, next, generation,
+					       level - 1);
+
 			if (level == 1 &&
 			    (wc->flags[0] & BTRFS_BLOCK_FLAG_FULL_BACKREF))
 				goto skip;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a9f0f05..05c36e5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1202,7 +1202,7 @@ out:
 	return ret;
 }
 static int comp_oper(struct btrfs_qgroup_operation *oper1,
-		     struct btrfs_qgroup_operation *oper2)
+		     struct btrfs_qgroup_operation *oper2, int for_insert)
 {
 	if (oper1->bytenr < oper2->bytenr)
 		return -1;
@@ -1216,10 +1216,37 @@ static int comp_oper(struct btrfs_qgroup_operation *oper1,
 		return -1;
 	if (oper1->ref_root > oper2->ref_root)
 		return 1;
-	if (oper1->type < oper2->type)
-		return -1;
-	if (oper1->type > oper2->type)
-		return 1;
+	if (for_insert) {
+		if (oper1->type < oper2->type)
+			return -1;
+		if (oper1->type > oper2->type)
+			return 1;
+	}
+	return 0;
+}
+
+static int qgroup_oper_exists(struct btrfs_fs_info *fs_info,
+			      struct btrfs_qgroup_operation *oper)
+{
+	struct rb_node *n;
+	struct btrfs_qgroup_operation *cur;
+	int cmp;
+
+	spin_lock(&fs_info->qgroup_op_lock);
+	n = fs_info->qgroup_op_tree.rb_node;
+	while (n) {
+		cur = rb_entry(n, struct btrfs_qgroup_operation, n);
+		cmp = comp_oper(cur, oper, 0);
+		if (cmp < 0) {
+			n = n->rb_right;
+		} else if (cmp) {
+			n = n->rb_left;
+		} else {
+			spin_unlock(&fs_info->qgroup_op_lock);
+			return -EEXIST;
+		}
+	}
+	spin_unlock(&fs_info->qgroup_op_lock);
 	return 0;
 }
 
@@ -1236,7 +1263,7 @@ static int insert_qgroup_oper(struct btrfs_fs_info *fs_info,
 	while (*p) {
 		parent = *p;
 		cur = rb_entry(parent, struct btrfs_qgroup_operation, n);
-		cmp = comp_oper(cur, oper);
+		cmp = comp_oper(cur, oper, 1);
 		if (cmp < 0) {
 			p = &(*p)->rb_right;
 		} else if (cmp) {
@@ -1290,7 +1317,25 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	oper->seq = atomic_inc_return(&fs_info->qgroup_op_seq);
 	INIT_LIST_HEAD(&oper->elem.list);
 	oper->elem.seq = 0;
+
 	trace_btrfs_qgroup_record_ref(oper);
+
+	if (type == BTRFS_QGROUP_OPER_SUB_SUBTREE) {
+		/*
+		 * If any operation for this bytenr/ref_root combo
+		 * exists, then we know it's not exclusively owned and
+		 * shouldn't be queued up.
+		 *
+		 * XXX: Do other operations need to search for
+		 * SUB_SHARED opers queued up on this bytenr? What do
+		 * they do in that case?
+		 */
+		if (qgroup_oper_exists(fs_info, oper)) {
+			kfree(oper);
+			return 0;
+		}
+	}
+
 	ret = insert_qgroup_oper(fs_info, oper);
 	if (ret) {
 		/* Shouldn't happen so have an assert for developers */
@@ -1883,6 +1928,112 @@ out:
 }
 
 /*
+ * Process a reference to a shared subtree. This type of operation is
+ * queued during snapshot removal when we encounter extents which are
+ * shared between more than one root.
+ */
+static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
+				     struct btrfs_fs_info *fs_info,
+				     struct btrfs_qgroup_operation *oper)
+{
+	struct ulist *roots = NULL;
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct btrfs_qgroup_list *glist;
+	struct ulist *parents;
+	int ret = 0;
+	int found;
+	struct btrfs_qgroup *qg;
+	u64 root_obj = 0;
+	struct seq_list elem = {};
+
+	parents = ulist_alloc(GFP_NOFS);
+	if (!parents)
+		return -ENOMEM;
+
+	btrfs_get_tree_mod_seq(fs_info, &elem);
+	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr,
+				   elem.seq, &roots);
+	btrfs_put_tree_mod_seq(fs_info, &elem);
+	if (ret < 0)
+		return ret;
+
+	found = 0;
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(roots, &uiter))) {
+		/*
+		 * If we find our ref root then that means all refs
+		 * this extent has to the root have not yet been
+		 * deleted. In that case, we do nothing and let the
+		 * last ref for this bytenr drive our update.
+		 *
+		 * This can happen for example if an extent is
+		 * referenced multiple times in a snapshot (clone,
+		 * etc). If we are in the middle of snapshot removal,
+		 * queued updates for such an extent will find the
+		 * root if we have not yet finished removing the
+		 * snapshot.
+		 */
+		if (unode->val == oper->ref_root)
+			goto out;
+
+		if (!found)
+			root_obj = unode->val;
+		found++;
+	}
+
+	if (found == 1) {
+		BUG_ON(!root_obj);
+
+		spin_lock(&fs_info->qgroup_lock);
+		qg = find_qgroup_rb(fs_info, root_obj);
+		if (!qg)
+			goto out_unlock;
+
+		qg->excl += oper->num_bytes;
+		qg->excl_cmpr += oper->num_bytes;
+		qgroup_dirty(fs_info, qg);
+
+		/*
+		 * Adjust counts for parent groups. First we find all
+		 * parents, then in the 2nd loop we do the adjustment
+		 * while adding parents of the parents to our ulist.
+		 */
+		list_for_each_entry(glist, &qg->groups, next_group) {
+			ret = ulist_add(parents, glist->group->qgroupid,
+					ptr_to_u64(glist->group), GFP_ATOMIC);
+			if (ret < 0)
+				goto out_unlock;
+		}
+
+		ULIST_ITER_INIT(&uiter);
+		while ((unode = ulist_next(parents, &uiter))) {
+			qg = u64_to_ptr(unode->aux);
+			qg->excl += oper->num_bytes;
+			qg->excl_cmpr += oper->num_bytes;
+			qgroup_dirty(fs_info, qg);
+
+			/* Add any parents of the parents */
+			list_for_each_entry(glist, &qg->groups, next_group) {
+				ret = ulist_add(parents, glist->group->qgroupid,
+						ptr_to_u64(glist->group),
+						GFP_ATOMIC);
+				if (ret < 0)
+					goto out_unlock;
+			}
+		}
+
+out_unlock:
+		spin_unlock(&fs_info->qgroup_lock);
+	}
+
+out:
+	ulist_free(roots);
+	ulist_free(parents);
+	return ret;
+}
+
+/*
  * btrfs_qgroup_account_ref is called for every ref that is added to or deleted
  * from the fs. First, all roots referencing the extent are searched, and
  * then the space is accounted accordingly to the different roots. The
@@ -1921,6 +2072,9 @@ static int btrfs_qgroup_account(struct btrfs_trans_handle *trans,
 	case BTRFS_QGROUP_OPER_SUB_SHARED:
 		ret = qgroup_shared_accounting(trans, fs_info, oper);
 		break;
+	case BTRFS_QGROUP_OPER_SUB_SUBTREE:
+		ret = qgroup_subtree_accounting(trans, fs_info, oper);
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 5952ff1..18cc68c 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -44,6 +44,7 @@ enum btrfs_qgroup_operation_type {
 	BTRFS_QGROUP_OPER_ADD_SHARED,
 	BTRFS_QGROUP_OPER_SUB_EXCL,
 	BTRFS_QGROUP_OPER_SUB_SHARED,
+	BTRFS_QGROUP_OPER_SUB_SUBTREE,
 };
 
 struct btrfs_qgroup_operation {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index b8774b3..96daac6 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1125,7 +1125,8 @@ DEFINE_EVENT(btrfs__workqueue_done, btrfs_workqueue_destroy,
 		{ BTRFS_QGROUP_OPER_ADD_EXCL, 	"OPER_ADD_EXCL" },	\
 		{ BTRFS_QGROUP_OPER_ADD_SHARED, "OPER_ADD_SHARED" },	\
 		{ BTRFS_QGROUP_OPER_SUB_EXCL, 	"OPER_SUB_EXCL" },	\
-		{ BTRFS_QGROUP_OPER_SUB_SHARED,	"OPER_SUB_SHARED" })
+		{ BTRFS_QGROUP_OPER_SUB_SHARED,	"OPER_SUB_SHARED" },	\
+		{ BTRFS_QGROUP_OPER_SUB_SUBTREE,"OPER_SUB_SUBTREE" })
 
 DECLARE_EVENT_CLASS(btrfs_qgroup_oper,
 
-- 
1.8.4.5

