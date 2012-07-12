Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:33234 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933339Ab2GLJnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:49 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 02/15] Btrfs: join tree mod log code with the code holding back delayed refs
Date: Thu, 12 Jul 2012 11:43:34 +0200
Message-Id: <097b8a7c9e48e2cb50fd0eb9315791921beaf484.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've got two mechanisms both required for reliable backref resolving (tree
mod log and holding back delayed refs). You cannot make use of one without
the other. So instead of requiring the user of this mechanism to setup both
correctly, we join them into a single interface.

Additionally, we stop inserting non-blockers into fs_info->tree_mod_seq_list
as we did before, which was of no value.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c     |   30 ++----
 fs/btrfs/backref.h     |    3 +-
 fs/btrfs/ctree.c       |  275 ++++++++++++++++++++++++++++++------------------
 fs/btrfs/ctree.h       |   31 ++++--
 fs/btrfs/delayed-ref.c |   44 ++++----
 fs/btrfs/delayed-ref.h |   49 +--------
 fs/btrfs/disk-io.c     |    2 +
 fs/btrfs/extent-tree.c |   21 ++--
 fs/btrfs/transaction.c |    4 -
 9 files changed, 240 insertions(+), 219 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index a383c18..7d80ddd 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -773,9 +773,8 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
-			     u64 delayed_ref_seq, u64 time_seq,
-			     struct ulist *refs, struct ulist *roots,
-			     const u64 *extent_item_pos)
+			     u64 time_seq, struct ulist *refs,
+			     struct ulist *roots, const u64 *extent_item_pos)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -837,7 +836,7 @@ again:
 				btrfs_put_delayed_ref(&head->node);
 				goto again;
 			}
-			ret = __add_delayed_refs(head, delayed_ref_seq,
+			ret = __add_delayed_refs(head, time_seq,
 						 &prefs_delayed);
 			mutex_unlock(&head->mutex);
 			if (ret) {
@@ -981,8 +980,7 @@ static void free_leaf_list(struct ulist *blocks)
  */
 static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 delayed_ref_seq, u64 time_seq,
-				struct ulist **leafs,
+				u64 time_seq, struct ulist **leafs,
 				const u64 *extent_item_pos)
 {
 	struct ulist *tmp;
@@ -997,7 +995,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
-	ret = find_parent_nodes(trans, fs_info, bytenr, delayed_ref_seq,
+	ret = find_parent_nodes(trans, fs_info, bytenr,
 				time_seq, *leafs, tmp, extent_item_pos);
 	ulist_free(tmp);
 
@@ -1024,8 +1022,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
  */
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 delayed_ref_seq, u64 time_seq,
-				struct ulist **roots)
+				u64 time_seq, struct ulist **roots)
 {
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
@@ -1043,7 +1040,7 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
-		ret = find_parent_nodes(trans, fs_info, bytenr, delayed_ref_seq,
+		ret = find_parent_nodes(trans, fs_info, bytenr,
 					time_seq, tmp, *roots, NULL);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
@@ -1376,11 +1373,9 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	struct ulist *roots = NULL;
 	struct ulist_node *ref_node = NULL;
 	struct ulist_node *root_node = NULL;
-	struct seq_list seq_elem = {};
 	struct seq_list tree_mod_seq_elem = {};
 	struct ulist_iterator ref_uiter;
 	struct ulist_iterator root_uiter;
-	struct btrfs_delayed_ref_root *delayed_refs = NULL;
 
 	pr_debug("resolving all inodes for extent %llu\n",
 			extent_item_objectid);
@@ -1391,16 +1386,11 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 		trans = btrfs_join_transaction(fs_info->extent_root);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
-
-		delayed_refs = &trans->transaction->delayed_refs;
-		spin_lock(&delayed_refs->lock);
-		btrfs_get_delayed_seq(delayed_refs, &seq_elem);
-		spin_unlock(&delayed_refs->lock);
 		btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
 	}
 
 	ret = btrfs_find_all_leafs(trans, fs_info, extent_item_objectid,
-				   seq_elem.seq, tree_mod_seq_elem.seq, &refs,
+				   tree_mod_seq_elem.seq, &refs,
 				   &extent_item_pos);
 	if (ret)
 		goto out;
@@ -1408,8 +1398,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	ULIST_ITER_INIT(&ref_uiter);
 	while (!ret && (ref_node = ulist_next(refs, &ref_uiter))) {
 		ret = btrfs_find_all_roots(trans, fs_info, ref_node->val,
-						seq_elem.seq,
-						tree_mod_seq_elem.seq, &roots);
+					   tree_mod_seq_elem.seq, &roots);
 		if (ret)
 			break;
 		ULIST_ITER_INIT(&root_uiter);
@@ -1431,7 +1420,6 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 out:
 	if (!search_commit_root) {
 		btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
-		btrfs_put_delayed_seq(delayed_refs, &seq_elem);
 		btrfs_end_transaction(trans, fs_info->extent_root);
 	}
 
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index c18d8ac..3a1ad3e 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -58,8 +58,7 @@ int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 delayed_ref_seq, u64 time_seq,
-				struct ulist **roots);
+				u64 time_seq, struct ulist **roots);
 
 struct btrfs_data_container *init_data_container(u32 total_bytes);
 struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 67fe46f..bef68ab 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -321,7 +321,7 @@ struct tree_mod_root {
 struct tree_mod_elem {
 	struct rb_node node;
 	u64 index;		/* shifted logical */
-	struct seq_list elem;
+	u64 seq;
 	enum mod_log_op op;
 
 	/* this is used for MOD_LOG_KEY_* and MOD_LOG_MOVE_KEYS operations */
@@ -341,20 +341,50 @@ struct tree_mod_elem {
 	struct tree_mod_root old_root;
 };
 
-static inline void
-__get_tree_mod_seq(struct btrfs_fs_info *fs_info, struct seq_list *elem)
+static inline void tree_mod_log_read_lock(struct btrfs_fs_info *fs_info)
 {
-	elem->seq = atomic_inc_return(&fs_info->tree_mod_seq);
-	list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
+	read_lock(&fs_info->tree_mod_log_lock);
 }
 
-void btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
-			    struct seq_list *elem)
+static inline void tree_mod_log_read_unlock(struct btrfs_fs_info *fs_info)
+{
+	read_unlock(&fs_info->tree_mod_log_lock);
+}
+
+static inline void tree_mod_log_write_lock(struct btrfs_fs_info *fs_info)
+{
+	write_lock(&fs_info->tree_mod_log_lock);
+}
+
+static inline void tree_mod_log_write_unlock(struct btrfs_fs_info *fs_info)
 {
-	elem->flags = 1;
+	write_unlock(&fs_info->tree_mod_log_lock);
+}
+
+/*
+ * This adds a new blocker to the tree mod log's blocker list if the @elem
+ * passed does not already have a sequence number set. So when a caller expects
+ * to record tree modifications, it should ensure to set elem->seq to zero
+ * before calling btrfs_get_tree_mod_seq.
+ * Returns a fresh, unused tree log modification sequence number, even if no new
+ * blocker was added.
+ */
+u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
+			   struct seq_list *elem)
+{
+	u64 seq;
+
+	tree_mod_log_write_lock(fs_info);
 	spin_lock(&fs_info->tree_mod_seq_lock);
-	__get_tree_mod_seq(fs_info, elem);
+	if (!elem->seq) {
+		elem->seq = btrfs_inc_tree_mod_seq(fs_info);
+		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
+	}
+	seq = btrfs_inc_tree_mod_seq(fs_info);
 	spin_unlock(&fs_info->tree_mod_seq_lock);
+	tree_mod_log_write_unlock(fs_info);
+
+	return seq;
 }
 
 void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
@@ -371,41 +401,46 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 	if (!seq_putting)
 		return;
 
-	BUG_ON(!(elem->flags & 1));
 	spin_lock(&fs_info->tree_mod_seq_lock);
 	list_del(&elem->list);
+	elem->seq = 0;
 
 	list_for_each_entry(cur_elem, &fs_info->tree_mod_seq_list, list) {
-		if ((cur_elem->flags & 1) && cur_elem->seq < min_seq) {
+		if (cur_elem->seq < min_seq) {
 			if (seq_putting > cur_elem->seq) {
 				/*
 				 * blocker with lower sequence number exists, we
 				 * cannot remove anything from the log
 				 */
-				goto out;
+				spin_unlock(&fs_info->tree_mod_seq_lock);
+				return;
 			}
 			min_seq = cur_elem->seq;
 		}
 	}
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+
+	/*
+	 * we removed the lowest blocker from the blocker list, so there may be
+	 * more processible delayed refs.
+	 */
+	wake_up(&fs_info->tree_mod_seq_wait);
 
 	/*
 	 * anything that's lower than the lowest existing (read: blocked)
 	 * sequence number can be removed from the tree.
 	 */
-	write_lock(&fs_info->tree_mod_log_lock);
+	tree_mod_log_write_lock(fs_info);
 	tm_root = &fs_info->tree_mod_log;
 	for (node = rb_first(tm_root); node; node = next) {
 		next = rb_next(node);
 		tm = container_of(node, struct tree_mod_elem, node);
-		if (tm->elem.seq > min_seq)
+		if (tm->seq > min_seq)
 			continue;
 		rb_erase(node, tm_root);
-		list_del(&tm->elem.list);
 		kfree(tm);
 	}
-	write_unlock(&fs_info->tree_mod_log_lock);
-out:
-	spin_unlock(&fs_info->tree_mod_seq_lock);
+	tree_mod_log_write_unlock(fs_info);
 }
 
 /*
@@ -423,11 +458,9 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
 	struct rb_node **new;
 	struct rb_node *parent = NULL;
 	struct tree_mod_elem *cur;
-	int ret = 0;
 
-	BUG_ON(!tm || !tm->elem.seq);
+	BUG_ON(!tm || !tm->seq);
 
-	write_lock(&fs_info->tree_mod_log_lock);
 	tm_root = &fs_info->tree_mod_log;
 	new = &tm_root->rb_node;
 	while (*new) {
@@ -437,88 +470,81 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
 			new = &((*new)->rb_left);
 		else if (cur->index > tm->index)
 			new = &((*new)->rb_right);
-		else if (cur->elem.seq < tm->elem.seq)
+		else if (cur->seq < tm->seq)
 			new = &((*new)->rb_left);
-		else if (cur->elem.seq > tm->elem.seq)
+		else if (cur->seq > tm->seq)
 			new = &((*new)->rb_right);
 		else {
 			kfree(tm);
-			ret = -EEXIST;
-			goto unlock;
+			return -EEXIST;
 		}
 	}
 
 	rb_link_node(&tm->node, parent, new);
 	rb_insert_color(&tm->node, tm_root);
-unlock:
-	write_unlock(&fs_info->tree_mod_log_lock);
-	return ret;
+	return 0;
 }
 
+/*
+ * Determines if logging can be omitted. Returns 1 if it can. Otherwise, it
+ * returns zero with the tree_mod_log_lock acquired. The caller must hold
+ * this until all tree mod log insertions are recorded in the rb tree and then
+ * call tree_mod_log_write_unlock() to release.
+ */
 static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
 				    struct extent_buffer *eb) {
 	smp_mb();
 	if (list_empty(&(fs_info)->tree_mod_seq_list))
 		return 1;
-	if (!eb)
-		return 0;
-	if (btrfs_header_level(eb) == 0)
+	if (eb && btrfs_header_level(eb) == 0)
 		return 1;
+
+	tree_mod_log_write_lock(fs_info);
+	if (list_empty(&fs_info->tree_mod_seq_list)) {
+		/*
+		 * someone emptied the list while we were waiting for the lock.
+		 * we must not add to the list when no blocker exists.
+		 */
+		tree_mod_log_write_unlock(fs_info);
+		return 1;
+	}
+
 	return 0;
 }
 
 /*
- * This allocates memory and gets a tree modification sequence number when
- * needed.
+ * This allocates memory and gets a tree modification sequence number.
  *
- * Returns 0 when no sequence number is needed, < 0 on error.
- * Returns 1 when a sequence number was added. In this case,
- * fs_info->tree_mod_seq_lock was acquired and must be released by the caller
- * after inserting into the rb tree.
+ * Returns <0 on error.
+ * Returns >0 (the added sequence number) on success.
  */
 static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
 				 struct tree_mod_elem **tm_ret)
 {
 	struct tree_mod_elem *tm;
-	int seq;
 
-	if (tree_mod_dont_log(fs_info, NULL))
-		return 0;
-
-	tm = *tm_ret = kzalloc(sizeof(*tm), flags);
+	/*
+	 * once we switch from spin locks to something different, we should
+	 * honor the flags parameter here.
+	 */
+	tm = *tm_ret = kzalloc(sizeof(*tm), GFP_ATOMIC);
 	if (!tm)
 		return -ENOMEM;
 
-	tm->elem.flags = 0;
-	spin_lock(&fs_info->tree_mod_seq_lock);
-	if (list_empty(&fs_info->tree_mod_seq_list)) {
-		/*
-		 * someone emptied the list while we were waiting for the lock.
-		 * we must not add to the list, because no blocker exists. items
-		 * are removed from the list only when the existing blocker is
-		 * removed from the list.
-		 */
-		kfree(tm);
-		seq = 0;
-		spin_unlock(&fs_info->tree_mod_seq_lock);
-	} else {
-		__get_tree_mod_seq(fs_info, &tm->elem);
-		seq = tm->elem.seq;
-	}
-
-	return seq;
+	tm->seq = btrfs_inc_tree_mod_seq(fs_info);
+	return tm->seq;
 }
 
-static noinline int
-tree_mod_log_insert_key_mask(struct btrfs_fs_info *fs_info,
-			     struct extent_buffer *eb, int slot,
-			     enum mod_log_op op, gfp_t flags)
+static inline int
+__tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
+			  struct extent_buffer *eb, int slot,
+			  enum mod_log_op op, gfp_t flags)
 {
-	struct tree_mod_elem *tm;
 	int ret;
+	struct tree_mod_elem *tm;
 
 	ret = tree_mod_alloc(fs_info, flags, &tm);
-	if (ret <= 0)
+	if (ret < 0)
 		return ret;
 
 	tm->index = eb->start >> PAGE_CACHE_SHIFT;
@@ -530,8 +556,22 @@ tree_mod_log_insert_key_mask(struct btrfs_fs_info *fs_info,
 	tm->slot = slot;
 	tm->generation = btrfs_node_ptr_generation(eb, slot);
 
-	ret = __tree_mod_log_insert(fs_info, tm);
-	spin_unlock(&fs_info->tree_mod_seq_lock);
+	return __tree_mod_log_insert(fs_info, tm);
+}
+
+static noinline int
+tree_mod_log_insert_key_mask(struct btrfs_fs_info *fs_info,
+			     struct extent_buffer *eb, int slot,
+			     enum mod_log_op op, gfp_t flags)
+{
+	int ret;
+
+	if (tree_mod_dont_log(fs_info, eb))
+		return 0;
+
+	ret = __tree_mod_log_insert_key(fs_info, eb, slot, op, flags);
+
+	tree_mod_log_write_unlock(fs_info);
 	return ret;
 }
 
@@ -543,6 +583,14 @@ tree_mod_log_insert_key(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 }
 
 static noinline int
+tree_mod_log_insert_key_locked(struct btrfs_fs_info *fs_info,
+			     struct extent_buffer *eb, int slot,
+			     enum mod_log_op op)
+{
+	return __tree_mod_log_insert_key(fs_info, eb, slot, op, GFP_NOFS);
+}
+
+static noinline int
 tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *eb, int dst_slot, int src_slot,
 			 int nr_items, gfp_t flags)
@@ -555,14 +603,14 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	for (i = 0; i + dst_slot < src_slot && i < nr_items; i++) {
-		ret = tree_mod_log_insert_key(fs_info, eb, i + dst_slot,
+		ret = tree_mod_log_insert_key_locked(fs_info, eb, i + dst_slot,
 					      MOD_LOG_KEY_REMOVE_WHILE_MOVING);
 		BUG_ON(ret < 0);
 	}
 
 	ret = tree_mod_alloc(fs_info, flags, &tm);
-	if (ret <= 0)
-		return ret;
+	if (ret < 0)
+		goto out;
 
 	tm->index = eb->start >> PAGE_CACHE_SHIFT;
 	tm->slot = src_slot;
@@ -571,10 +619,26 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	tm->op = MOD_LOG_MOVE_KEYS;
 
 	ret = __tree_mod_log_insert(fs_info, tm);
-	spin_unlock(&fs_info->tree_mod_seq_lock);
+out:
+	tree_mod_log_write_unlock(fs_info);
 	return ret;
 }
 
+static inline void
+__tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
+{
+	int i;
+	u32 nritems;
+	int ret;
+
+	nritems = btrfs_header_nritems(eb);
+	for (i = nritems - 1; i >= 0; i--) {
+		ret = tree_mod_log_insert_key_locked(fs_info, eb, i,
+					      MOD_LOG_KEY_REMOVE_WHILE_FREEING);
+		BUG_ON(ret < 0);
+	}
+}
+
 static noinline int
 tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *old_root,
@@ -583,9 +647,14 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 	struct tree_mod_elem *tm;
 	int ret;
 
+	if (tree_mod_dont_log(fs_info, NULL))
+		return 0;
+
+	__tree_mod_log_free_eb(fs_info, old_root);
+
 	ret = tree_mod_alloc(fs_info, flags, &tm);
-	if (ret <= 0)
-		return ret;
+	if (ret < 0)
+		goto out;
 
 	tm->index = new_root->start >> PAGE_CACHE_SHIFT;
 	tm->old_root.logical = old_root->start;
@@ -594,7 +663,8 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 	tm->op = MOD_LOG_ROOT_REPLACE;
 
 	ret = __tree_mod_log_insert(fs_info, tm);
-	spin_unlock(&fs_info->tree_mod_seq_lock);
+out:
+	tree_mod_log_write_unlock(fs_info);
 	return ret;
 }
 
@@ -608,7 +678,7 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
 	struct tree_mod_elem *found = NULL;
 	u64 index = start >> PAGE_CACHE_SHIFT;
 
-	read_lock(&fs_info->tree_mod_log_lock);
+	tree_mod_log_read_lock(fs_info);
 	tm_root = &fs_info->tree_mod_log;
 	node = tm_root->rb_node;
 	while (node) {
@@ -617,18 +687,18 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
 			node = node->rb_left;
 		} else if (cur->index > index) {
 			node = node->rb_right;
-		} else if (cur->elem.seq < min_seq) {
+		} else if (cur->seq < min_seq) {
 			node = node->rb_left;
 		} else if (!smallest) {
 			/* we want the node with the highest seq */
 			if (found)
-				BUG_ON(found->elem.seq > cur->elem.seq);
+				BUG_ON(found->seq > cur->seq);
 			found = cur;
 			node = node->rb_left;
-		} else if (cur->elem.seq > min_seq) {
+		} else if (cur->seq > min_seq) {
 			/* we want the node with the smallest seq */
 			if (found)
-				BUG_ON(found->elem.seq < cur->elem.seq);
+				BUG_ON(found->seq < cur->seq);
 			found = cur;
 			node = node->rb_right;
 		} else {
@@ -636,7 +706,7 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
 			break;
 		}
 	}
-	read_unlock(&fs_info->tree_mod_log_lock);
+	tree_mod_log_read_unlock(fs_info);
 
 	return found;
 }
@@ -664,7 +734,7 @@ tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq)
 	return __tree_mod_log_search(fs_info, start, min_seq, 0);
 }
 
-static inline void
+static noinline void
 tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 		     struct extent_buffer *src, unsigned long dst_offset,
 		     unsigned long src_offset, int nr_items)
@@ -675,18 +745,23 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	if (tree_mod_dont_log(fs_info, NULL))
 		return;
 
-	if (btrfs_header_level(dst) == 0 && btrfs_header_level(src) == 0)
+	if (btrfs_header_level(dst) == 0 && btrfs_header_level(src) == 0) {
+		tree_mod_log_write_unlock(fs_info);
 		return;
+	}
 
-	/* speed this up by single seq for all operations? */
 	for (i = 0; i < nr_items; i++) {
-		ret = tree_mod_log_insert_key(fs_info, src, i + src_offset,
-					      MOD_LOG_KEY_REMOVE);
+		ret = tree_mod_log_insert_key_locked(fs_info, src,
+						     i + src_offset,
+						     MOD_LOG_KEY_REMOVE);
 		BUG_ON(ret < 0);
-		ret = tree_mod_log_insert_key(fs_info, dst, i + dst_offset,
-					      MOD_LOG_KEY_ADD);
+		ret = tree_mod_log_insert_key_locked(fs_info, dst,
+						     i + dst_offset,
+						     MOD_LOG_KEY_ADD);
 		BUG_ON(ret < 0);
 	}
+
+	tree_mod_log_write_unlock(fs_info);
 }
 
 static inline void
@@ -699,7 +774,7 @@ tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	BUG_ON(ret < 0);
 }
 
-static inline void
+static noinline void
 tree_mod_log_set_node_key(struct btrfs_fs_info *fs_info,
 			  struct extent_buffer *eb,
 			  struct btrfs_disk_key *disk_key, int slot, int atomic)
@@ -712,30 +787,22 @@ tree_mod_log_set_node_key(struct btrfs_fs_info *fs_info,
 	BUG_ON(ret < 0);
 }
 
-static void tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
-				 struct extent_buffer *eb)
+static noinline void
+tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 {
-	int i;
-	int ret;
-	u32 nritems;
-
 	if (tree_mod_dont_log(fs_info, eb))
 		return;
 
-	nritems = btrfs_header_nritems(eb);
-	for (i = nritems - 1; i >= 0; i--) {
-		ret = tree_mod_log_insert_key(fs_info, eb, i,
-					      MOD_LOG_KEY_REMOVE_WHILE_FREEING);
-		BUG_ON(ret < 0);
-	}
+	__tree_mod_log_free_eb(fs_info, eb);
+
+	tree_mod_log_write_unlock(fs_info);
 }
 
-static inline void
+static noinline void
 tree_mod_log_set_root_pointer(struct btrfs_root *root,
 			      struct extent_buffer *new_root_node)
 {
 	int ret;
-	tree_mod_log_free_eb(root->fs_info, root->node);
 	ret = tree_mod_log_insert_root(root->fs_info, root->node,
 				       new_root_node, GFP_NOFS);
 	BUG_ON(ret < 0);
@@ -1069,7 +1136,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 	unsigned long p_size = sizeof(struct btrfs_key_ptr);
 
 	n = btrfs_header_nritems(eb);
-	while (tm && tm->elem.seq >= time_seq) {
+	while (tm && tm->seq >= time_seq) {
 		/*
 		 * all the operations are recorded with the operator used for
 		 * the modification. as we're going backwards, we do the
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 84ac723..8f8dc46 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1030,6 +1030,13 @@ struct btrfs_block_group_cache {
 	struct list_head cluster_list;
 };
 
+/* delayed seq elem */
+struct seq_list {
+	struct list_head list;
+	u64 seq;
+};
+
+/* fs_info */
 struct reloc_control;
 struct btrfs_device;
 struct btrfs_fs_devices;
@@ -1144,6 +1151,8 @@ struct btrfs_fs_info {
 	spinlock_t tree_mod_seq_lock;
 	atomic_t tree_mod_seq;
 	struct list_head tree_mod_seq_list;
+	struct seq_list tree_mod_seq_elem;
+	wait_queue_head_t tree_mod_seq_wait;
 
 	/* this protects tree_mod_log */
 	rwlock_t tree_mod_log_lock;
@@ -2798,6 +2807,16 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info);
 }
 
+/* tree mod log functions from ctree.c */
+u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
+			   struct seq_list *elem);
+void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
+			    struct seq_list *elem);
+static inline u64 btrfs_inc_tree_mod_seq(struct btrfs_fs_info *fs_info)
+{
+	return atomic_inc_return(&fs_info->tree_mod_seq);
+}
+
 /* root-item.c */
 int btrfs_find_root_ref(struct btrfs_root *tree_root,
 			struct btrfs_path *path,
@@ -3157,18 +3176,6 @@ void btrfs_reada_detach(void *handle);
 int btree_readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 			 u64 start, int err);
 
-/* delayed seq elem */
-struct seq_list {
-	struct list_head list;
-	u64 seq;
-	u32 flags;
-};
-
-void btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
-			    struct seq_list *elem);
-void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
-			    struct seq_list *elem);
-
 static inline int is_fstree(u64 rootid)
 {
 	if (rootid == BTRFS_FS_TREE_OBJECTID ||
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 13ae7b0..21a7577 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -233,22 +233,26 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_check_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
+int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
+			    struct btrfs_delayed_ref_root *delayed_refs,
 			    u64 seq)
 {
 	struct seq_list *elem;
-
-	assert_spin_locked(&delayed_refs->lock);
-	if (list_empty(&delayed_refs->seq_head))
-		return 0;
-
-	elem = list_first_entry(&delayed_refs->seq_head, struct seq_list, list);
-	if (seq >= elem->seq) {
-		pr_debug("holding back delayed_ref %llu, lowest is %llu (%p)\n",
-			 seq, elem->seq, delayed_refs);
-		return 1;
+	int ret = 0;
+
+	spin_lock(&fs_info->tree_mod_seq_lock);
+	if (!list_empty(&fs_info->tree_mod_seq_list)) {
+		elem = list_first_entry(&fs_info->tree_mod_seq_list,
+					struct seq_list, list);
+		if (seq >= elem->seq) {
+			pr_debug("holding back delayed_ref %llu, lowest is "
+				 "%llu (%p)\n", seq, elem->seq, delayed_refs);
+			ret = 1;
+		}
 	}
-	return 0;
+
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+	return ret;
 }
 
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
@@ -526,7 +530,7 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->in_tree = 1;
 
 	if (is_fstree(ref_root))
-		seq = inc_delayed_seq(delayed_refs);
+		seq = btrfs_inc_tree_mod_seq(fs_info);
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_tree_ref(ref);
@@ -585,7 +589,7 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	ref->in_tree = 1;
 
 	if (is_fstree(ref_root))
-		seq = inc_delayed_seq(delayed_refs);
+		seq = btrfs_inc_tree_mod_seq(fs_info);
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_data_ref(ref);
@@ -659,8 +663,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 				   num_bytes, parent, ref_root, level, action,
 				   for_cow);
 	if (!is_fstree(ref_root) &&
-	    waitqueue_active(&delayed_refs->seq_wait))
-		wake_up(&delayed_refs->seq_wait);
+	    waitqueue_active(&fs_info->tree_mod_seq_wait))
+		wake_up(&fs_info->tree_mod_seq_wait);
 	spin_unlock(&delayed_refs->lock);
 
 	return 0;
@@ -708,8 +712,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action, for_cow);
 	if (!is_fstree(ref_root) &&
-	    waitqueue_active(&delayed_refs->seq_wait))
-		wake_up(&delayed_refs->seq_wait);
+	    waitqueue_active(&fs_info->tree_mod_seq_wait))
+		wake_up(&fs_info->tree_mod_seq_wait);
 	spin_unlock(&delayed_refs->lock);
 
 	return 0;
@@ -736,8 +740,8 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
 				   extent_op->is_data);
 
-	if (waitqueue_active(&delayed_refs->seq_wait))
-		wake_up(&delayed_refs->seq_wait);
+	if (waitqueue_active(&fs_info->tree_mod_seq_wait))
+		wake_up(&fs_info->tree_mod_seq_wait);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 413927f..2b5cb27 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -139,26 +139,6 @@ struct btrfs_delayed_ref_root {
 	int flushing;
 
 	u64 run_delayed_start;
-
-	/*
-	 * seq number of delayed refs. We need to know if a backref was being
-	 * added before the currently processed ref or afterwards.
-	 */
-	u64 seq;
-
-	/*
-	 * seq_list holds a list of all seq numbers that are currently being
-	 * added to the list. While walking backrefs (btrfs_find_all_roots,
-	 * qgroups), which might take some time, no newer ref must be processed,
-	 * as it might influence the outcome of the walk.
-	 */
-	struct list_head seq_head;
-
-	/*
-	 * when the only refs we have in the list must not be processed, we want
-	 * to wait for more refs to show up or for the end of backref walking.
-	 */
-	wait_queue_head_t seq_wait;
 };
 
 static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
@@ -195,33 +175,8 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
 			   struct list_head *cluster, u64 search_start);
 
-static inline u64 inc_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs)
-{
-	assert_spin_locked(&delayed_refs->lock);
-	++delayed_refs->seq;
-	return delayed_refs->seq;
-}
-
-static inline void
-btrfs_get_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
-		      struct seq_list *elem)
-{
-	assert_spin_locked(&delayed_refs->lock);
-	elem->seq = delayed_refs->seq;
-	list_add_tail(&elem->list, &delayed_refs->seq_head);
-}
-
-static inline void
-btrfs_put_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
-		      struct seq_list *elem)
-{
-	spin_lock(&delayed_refs->lock);
-	list_del(&elem->list);
-	wake_up(&delayed_refs->seq_wait);
-	spin_unlock(&delayed_refs->lock);
-}
-
-int btrfs_check_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
+int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
+			    struct btrfs_delayed_ref_root *delayed_refs,
 			    u64 seq);
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8cc4710..19a39e1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1944,6 +1944,8 @@ int open_ctree(struct super_block *sb,
 	fs_info->free_chunk_space = 0;
 	fs_info->tree_mod_log = RB_ROOT;
 
+	init_waitqueue_head(&fs_info->tree_mod_seq_wait);
+
 	/* readahead state */
 	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
 	spin_lock_init(&fs_info->reada_lock);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6e1d367..94ce79f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2217,6 +2217,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_node *ref;
 	struct btrfs_delayed_ref_head *locked_ref = NULL;
 	struct btrfs_delayed_extent_op *extent_op;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 	int count = 0;
 	int must_insert_reserved = 0;
@@ -2255,7 +2256,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		ref = select_delayed_ref(locked_ref);
 
 		if (ref && ref->seq &&
-		    btrfs_check_delayed_seq(delayed_refs, ref->seq)) {
+		    btrfs_check_delayed_seq(fs_info, delayed_refs, ref->seq)) {
 			/*
 			 * there are still refs with lower seq numbers in the
 			 * process of being added. Don't run this ref yet.
@@ -2337,7 +2338,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		}
 
 next:
-		do_chunk_alloc(trans, root->fs_info->extent_root,
+		do_chunk_alloc(trans, fs_info->extent_root,
 			       2 * 1024 * 1024,
 			       btrfs_get_alloc_profile(root, 0),
 			       CHUNK_ALLOC_NO_FORCE);
@@ -2347,18 +2348,19 @@ next:
 	return count;
 }
 
-static void wait_for_more_refs(struct btrfs_delayed_ref_root *delayed_refs,
+static void wait_for_more_refs(struct btrfs_fs_info *fs_info,
+			       struct btrfs_delayed_ref_root *delayed_refs,
 			       unsigned long num_refs,
 			       struct list_head *first_seq)
 {
 	spin_unlock(&delayed_refs->lock);
 	pr_debug("waiting for more refs (num %ld, first %p)\n",
 		 num_refs, first_seq);
-	wait_event(delayed_refs->seq_wait,
+	wait_event(fs_info->tree_mod_seq_wait,
 		   num_refs != delayed_refs->num_entries ||
-		   delayed_refs->seq_head.next != first_seq);
+		   fs_info->tree_mod_seq_list.next != first_seq);
 	pr_debug("done waiting for more refs (num %ld, first %p)\n",
-		 delayed_refs->num_entries, delayed_refs->seq_head.next);
+		 delayed_refs->num_entries, fs_info->tree_mod_seq_list.next);
 	spin_lock(&delayed_refs->lock);
 }
 
@@ -2403,6 +2405,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 again:
 	consider_waiting = 0;
 	spin_lock(&delayed_refs->lock);
+
 	if (count == 0) {
 		count = delayed_refs->num_entries * 2;
 		run_most = 1;
@@ -2437,7 +2440,7 @@ again:
 				num_refs = delayed_refs->num_entries;
 				first_seq = root->fs_info->tree_mod_seq_list.next;
 			} else {
-				wait_for_more_refs(delayed_refs,
+				wait_for_more_refs(root->fs_info, delayed_refs,
 						   num_refs, first_seq);
 				/*
 				 * after waiting, things have changed. we
@@ -5190,8 +5193,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	rb_erase(&head->node.rb_node, &delayed_refs->root);
 
 	delayed_refs->num_entries--;
-	if (waitqueue_active(&delayed_refs->seq_wait))
-		wake_up(&delayed_refs->seq_wait);
+	if (waitqueue_active(&root->fs_info->tree_mod_seq_wait))
+		wake_up(&root->fs_info->tree_mod_seq_wait);
 
 	/*
 	 * we don't take a ref on the node because we're removing it from the
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b72b068..621c8dc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -38,7 +38,6 @@ void put_transaction(struct btrfs_transaction *transaction)
 	if (atomic_dec_and_test(&transaction->use_count)) {
 		BUG_ON(!list_empty(&transaction->list));
 		WARN_ON(transaction->delayed_refs.root.rb_node);
-		WARN_ON(!list_empty(&transaction->delayed_refs.seq_head));
 		memset(transaction, 0, sizeof(*transaction));
 		kmem_cache_free(btrfs_transaction_cachep, transaction);
 	}
@@ -126,7 +125,6 @@ loop:
 	cur_trans->delayed_refs.num_heads = 0;
 	cur_trans->delayed_refs.flushing = 0;
 	cur_trans->delayed_refs.run_delayed_start = 0;
-	cur_trans->delayed_refs.seq = 1;
 
 	/*
 	 * although the tree mod log is per file system and not per transaction,
@@ -145,10 +143,8 @@ loop:
 	}
 	atomic_set(&fs_info->tree_mod_seq, 0);
 
-	init_waitqueue_head(&cur_trans->delayed_refs.seq_wait);
 	spin_lock_init(&cur_trans->commit_lock);
 	spin_lock_init(&cur_trans->delayed_refs.lock);
-	INIT_LIST_HEAD(&cur_trans->delayed_refs.seq_head);
 
 	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
-- 
1.7.3.4

