From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Update backrefs during dropping snapshot
Date: Mon, 15 Jun 2009 21:22:51 +0800
Message-ID: <4A364B2B.2080600@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The new backref format has restriction on type of backref item.
If a tree block isn't referenced by its owner tree, full backrefs
must be used for the pointers in it. When a tree block loses its
owner tree's reference, backrefs for the pointers in it should be
updated to full backrefs. Current btrfs_drop_snapshot misses the
code that updates backrefs, so it's unsafe for general use.

This patch adds backrefs update code to btrfs_drop_snapshot.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.h 2/fs/btrfs/ctree.h
--- 1/fs/btrfs/ctree.h	2009-06-12 21:32:39.659514518 +0800
+++ 2/fs/btrfs/ctree.h	2009-06-12 23:07:33.000000000 +0800
@@ -2076,8 +2076,7 @@ static inline int btrfs_insert_empty_ite
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
-int btrfs_drop_snapshot(struct btrfs_trans_handle *trans, struct btrfs_root
-			*root);
+int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref);
 int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct extent_buffer *node,
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-06-12 21:32:39.697513876 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-06-15 17:14:11.000000000 +0800
@@ -990,15 +990,13 @@ static inline int extent_ref_type(u64 pa
 	return type;
 }
 
-static int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
+static int find_next_key(struct btrfs_path *path, int level,
+			 struct btrfs_key *key)
 
 {
-	int level;
-	BUG_ON(!path->keep_locks);
-	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
+	for (; level < BTRFS_MAX_LEVEL; level++) {
 		if (!path->nodes[level])
 			break;
-		btrfs_assert_tree_locked(path->nodes[level]);
 		if (path->slots[level] + 1 >=
 		    btrfs_header_nritems(path->nodes[level]))
 			continue;
@@ -1158,7 +1156,8 @@ int lookup_inline_extent_backref(struct 
 		 * For simplicity, we just do not add new inline back
 		 * ref if there is any kind of item for this block
 		 */
-		if (find_next_key(path, &key) == 0 && key.objectid == bytenr &&
+		if (find_next_key(path, 0, &key) == 0 &&
+		    key.objectid == bytenr &&
 		    key.type < BTRFS_BLOCK_GROUP_ITEM_KEY) {
 			err = -EAGAIN;
 			goto out;
@@ -4128,6 +4127,7 @@ struct extent_buffer *btrfs_alloc_free_b
 	return buf;
 }
 
+#if 0
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct extent_buffer *leaf)
 {
@@ -4171,8 +4171,6 @@ int btrfs_drop_leaf_ref(struct btrfs_tra
 	return 0;
 }
 
-#if 0
-
 static noinline int cache_drop_leaf_ref(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
 					struct btrfs_leaf_ref *ref)
@@ -4553,262 +4551,471 @@ out:
 }
 #endif
 
+struct walk_control {
+	u64 refs[BTRFS_MAX_LEVEL];
+	u64 flags[BTRFS_MAX_LEVEL];
+	struct btrfs_key update_progress;
+	int stage;
+	int level;
+	int shared_level;
+	int update_ref;
+	int keep_locks;
+};
+
+#define DROP_REFERENCE	1
+#define UPDATE_BACKREF	2
+
 /*
- * helper function for drop_subtree, this function is similar to
- * walk_down_tree. The main difference is that it checks reference
- * counts while tree blocks are locked.
+ * hepler to process tree block while walking down the tree.
+ *
+ * when wc->stage == DROP_REFERENCE, this function checks
+ * reference count of the block. if the block is shared and
+ * we need update back refs for the subtree rooted at the
+ * block, this function changes wc->stage to UPDATE_BACKREF
+ *
+ * when wc->stage == UPDATE_BACKREF, this function updates
+ * back refs for pointers in the block.
+ *
+ * NOTE: return value 1 means we should stop walking down.
  */
-static noinline int walk_down_tree(struct btrfs_trans_handle *trans,
+static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
-				   struct btrfs_path *path, int *level)
+				   struct btrfs_path *path,
+				   struct walk_control *wc)
 {
-	struct extent_buffer *next;
-	struct extent_buffer *cur;
-	struct extent_buffer *parent;
-	u64 bytenr;
-	u64 ptr_gen;
-	u64 refs;
-	u64 flags;
-	u32 blocksize;
+	int level = wc->level;
+	struct extent_buffer *eb = path->nodes[level];
+	struct btrfs_key key;
+	u64 flag = BTRFS_BLOCK_FLAG_FULL_BACKREF;
 	int ret;
 
-	cur = path->nodes[*level];
-	ret = btrfs_lookup_extent_info(trans, root, cur->start, cur->len,
-				       &refs, &flags);
-	BUG_ON(ret);
-	if (refs > 1)
-		goto out;
+	if (wc->stage == UPDATE_BACKREF &&
+	    btrfs_header_owner(eb) != root->root_key.objectid)
+		return 1;
 
-	BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
+	/*
+	 * when reference count of tree block is 1, it won't increase
+	 * again. once full backref flag is set, we never clear it.
+	 */
+	if ((wc->stage == DROP_REFERENCE && wc->refs[level] != 1) ||
+	    (wc->stage == UPDATE_BACKREF && !(wc->flags[level] & flag))) {
+		BUG_ON(!path->locks[level]);
+		ret = btrfs_lookup_extent_info(trans, root,
+					       eb->start, eb->len,
+					       &wc->refs[level],
+					       &wc->flags[level]);
+		BUG_ON(ret);
+		BUG_ON(wc->refs[level] == 0);
+	}
 
-	while (*level >= 0) {
-		cur = path->nodes[*level];
-		if (*level == 0) {
-			ret = btrfs_drop_leaf_ref(trans, root, cur);
-			BUG_ON(ret);
-			clean_tree_block(trans, root, cur);
-			break;
-		}
-		if (path->slots[*level] >= btrfs_header_nritems(cur)) {
-			clean_tree_block(trans, root, cur);
-			break;
+	if (wc->stage == DROP_REFERENCE &&
+	    wc->update_ref && wc->refs[level] > 1) {
+		BUG_ON(eb == root->node);
+		BUG_ON(path->slots[level] > 0);
+		if (level == 0)
+			btrfs_item_key_to_cpu(eb, &key, path->slots[level]);
+		else
+			btrfs_node_key_to_cpu(eb, &key, path->slots[level]);
+		if (btrfs_header_owner(eb) == root->root_key.objectid &&
+		    btrfs_comp_cpu_keys(&key, &wc->update_progress) >= 0) {
+			wc->stage = UPDATE_BACKREF;
+			wc->shared_level = level;
 		}
+	}
 
-		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
-		blocksize = btrfs_level_size(root, *level - 1);
-		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
+	if (wc->stage == DROP_REFERENCE) {
+		if (wc->refs[level] > 1)
+			return 1;
 
-		next = read_tree_block(root, bytenr, blocksize, ptr_gen);
-		btrfs_tree_lock(next);
-		btrfs_set_lock_blocking(next);
+		if (path->locks[level] && !wc->keep_locks) {
+			btrfs_tree_unlock(eb);
+			path->locks[level] = 0;
+		}
+		return 0;
+	}
 
-		ret = btrfs_lookup_extent_info(trans, root, bytenr, blocksize,
-					       &refs, &flags);
+	/* wc->stage == UPDATE_BACKREF */
+	if (!(wc->flags[level] & flag)) {
+		BUG_ON(!path->locks[level]);
+		ret = btrfs_inc_ref(trans, root, eb, 1);
 		BUG_ON(ret);
-		if (refs > 1) {
-			parent = path->nodes[*level];
-			ret = btrfs_free_extent(trans, root, bytenr,
-						blocksize, parent->start,
-						btrfs_header_owner(parent),
-						*level - 1, 0);
+		ret = btrfs_dec_ref(trans, root, eb, 0);
+		BUG_ON(ret);
+		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
+						  eb->len, flag, 0);
+		BUG_ON(ret);
+		wc->flags[level] |= flag;
+	}
+
+	/*
+	 * the block is shared by multiple trees, so it's not good to
+	 * keep the tree lock
+	 */
+	if (path->locks[level] && level > 0) {
+		btrfs_tree_unlock(eb);
+		path->locks[level] = 0;
+	}
+	return 0;
+}
+
+/*
+ * hepler to process tree block while walking up the tree.
+ *
+ * when wc->stage == DROP_REFERENCE, this function drops
+ * reference count on the block.
+ *
+ * when wc->stage == UPDATE_BACKREF, this function changes
+ * wc->stage back to DROP_REFERENCE if we changed wc->stage
+ * to UPDATE_BACKREF previously while processing the block.
+ *
+ * NOTE: return value 1 means we should stop walking up.
+ */
+static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 struct walk_control *wc)
+{
+	int ret = 0;
+	int level = wc->level;
+	struct extent_buffer *eb = path->nodes[level];
+	u64 parent = 0;
+
+	if (wc->stage == UPDATE_BACKREF) {
+		BUG_ON(wc->shared_level < level);
+		if (level < wc->shared_level)
+			goto out;
+
+		BUG_ON(wc->refs[level] <= 1);
+		ret = find_next_key(path, level + 1, &wc->update_progress);
+		if (ret > 0)
+			wc->update_ref = 0;
+
+		wc->stage = DROP_REFERENCE;
+		wc->shared_level = -1;
+		path->slots[level] = 0;
+
+		/*
+		 * check reference count again if the block isn't locked.
+		 * we should start walking down the tree again if reference
+		 * count is one.
+		 */
+		if (!path->locks[level]) {
+			BUG_ON(level == 0);
+			btrfs_tree_lock(eb);
+			btrfs_set_lock_blocking(eb);
+			path->locks[level] = 1;
+
+			ret = btrfs_lookup_extent_info(trans, root,
+						       eb->start, eb->len,
+						       &wc->refs[level],
+						       &wc->flags[level]);
 			BUG_ON(ret);
-			path->slots[*level]++;
-			btrfs_tree_unlock(next);
-			free_extent_buffer(next);
-			continue;
+			BUG_ON(wc->refs[level] == 0);
+			if (wc->refs[level] == 1) {
+				btrfs_tree_unlock(eb);
+				path->locks[level] = 0;
+				return 1;
+			}
+		} else {
+			BUG_ON(level != 0);
 		}
+	}
 
-		BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
+	/* wc->stage == DROP_REFERENCE */
+	BUG_ON(wc->refs[level] > 1 && !path->locks[level]);
 
-		*level = btrfs_header_level(next);
-		path->nodes[*level] = next;
-		path->slots[*level] = 0;
-		path->locks[*level] = 1;
-		cond_resched();
+	if (wc->refs[level] == 1) {
+		if (level == 0) {
+			if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
+				ret = btrfs_dec_ref(trans, root, eb, 1);
+			else
+				ret = btrfs_dec_ref(trans, root, eb, 0);
+			BUG_ON(ret);
+		}
+		/* make block locked assertion in clean_tree_block happy */
+		if (!path->locks[level] &&
+		    btrfs_header_generation(eb) == trans->transid) {
+			btrfs_tree_lock(eb);
+			btrfs_set_lock_blocking(eb);
+			path->locks[level] = 1;
+		}
+		clean_tree_block(trans, root, eb);
+	}
+
+	if (eb == root->node) {
+		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
+			parent = eb->start;
+		else
+			BUG_ON(root->root_key.objectid !=
+			       btrfs_header_owner(eb));
+	} else {
+		if (wc->flags[level + 1] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
+			parent = path->nodes[level + 1]->start;
+		else
+			BUG_ON(root->root_key.objectid !=
+			       btrfs_header_owner(path->nodes[level + 1]));
 	}
-out:
-	if (path->nodes[*level] == root->node)
-		parent = path->nodes[*level];
-	else
-		parent = path->nodes[*level + 1];
-	bytenr = path->nodes[*level]->start;
-	blocksize = path->nodes[*level]->len;
 
-	ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent->start,
-				btrfs_header_owner(parent), *level, 0);
+	ret = btrfs_free_extent(trans, root, eb->start, eb->len, parent,
+				root->root_key.objectid, level, 0);
 	BUG_ON(ret);
+out:
+	wc->refs[level] = 0;
+	wc->flags[level] = 0;
+	return ret;
+}
 
-	if (path->locks[*level]) {
-		btrfs_tree_unlock(path->nodes[*level]);
-		path->locks[*level] = 0;
+static noinline int walk_down_tree(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_path *path,
+				   struct walk_control *wc)
+{
+	struct extent_buffer *next;
+	struct extent_buffer *cur;
+	u64 bytenr;
+	u64 ptr_gen;
+	u32 blocksize;
+	int level = wc->level;
+	int ret;
+
+	while (level >= 0) {
+		cur = path->nodes[level];
+		BUG_ON(path->slots[level] >= btrfs_header_nritems(cur));
+
+		ret = walk_down_proc(trans, root, path, wc);
+		if (ret > 0)
+			break;
+
+		if (level == 0)
+			break;
+
+		bytenr = btrfs_node_blockptr(cur, path->slots[level]);
+		blocksize = btrfs_level_size(root, level - 1);
+		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[level]);
+
+		next = read_tree_block(root, bytenr, blocksize, ptr_gen);
+		btrfs_tree_lock(next);
+		btrfs_set_lock_blocking(next);
+
+		level--;
+		BUG_ON(level != btrfs_header_level(next));
+		path->nodes[level] = next;
+		path->slots[level] = 0;
+		path->locks[level] = 1;
+		wc->level = level;
 	}
-	free_extent_buffer(path->nodes[*level]);
-	path->nodes[*level] = NULL;
-	*level += 1;
-	cond_resched();
 	return 0;
 }
 
-/*
- * helper for dropping snapshots.  This walks back up the tree in the path
- * to find the first node higher up where we haven't yet gone through
- * all the slots
- */
 static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_path *path,
-				 int *level, int max_level)
+				 struct walk_control *wc, int max_level)
 {
-	struct btrfs_root_item *root_item = &root->root_item;
-	int i;
-	int slot;
+	int level = wc->level;
 	int ret;
 
-	for (i = *level; i < max_level && path->nodes[i]; i++) {
-		slot = path->slots[i];
-		if (slot + 1 < btrfs_header_nritems(path->nodes[i])) {
-			/*
-			 * there is more work to do in this level.
-			 * Update the drop_progress marker to reflect
-			 * the work we've done so far, and then bump
-			 * the slot number
-			 */
-			path->slots[i]++;
-			WARN_ON(*level == 0);
-			if (max_level == BTRFS_MAX_LEVEL) {
-				btrfs_node_key(path->nodes[i],
-					       &root_item->drop_progress,
-					       path->slots[i]);
-				root_item->drop_level = i;
-			}
-			*level = i;
+	path->slots[level] = btrfs_header_nritems(path->nodes[level]);
+	while (level < max_level && path->nodes[level]) {
+		wc->level = level;
+		if (path->slots[level] + 1 <
+		    btrfs_header_nritems(path->nodes[level])) {
+			path->slots[level]++;
 			return 0;
 		} else {
-			struct extent_buffer *parent;
-
-			/*
-			 * this whole node is done, free our reference
-			 * on it and go up one level
-			 */
-			if (path->nodes[*level] == root->node)
-				parent = path->nodes[*level];
-			else
-				parent = path->nodes[*level + 1];
+			ret = walk_up_proc(trans, root, path, wc);
+			if (ret > 0)
+				return 0;
 
-			clean_tree_block(trans, root, path->nodes[i]);
-			ret = btrfs_free_extent(trans, root,
-						path->nodes[i]->start,
-						path->nodes[i]->len,
-						parent->start,
-						btrfs_header_owner(parent),
-						*level, 0);
-			BUG_ON(ret);
-			if (path->locks[*level]) {
-				btrfs_tree_unlock(path->nodes[i]);
-				path->locks[i] = 0;
+			if (path->locks[level]) {
+				btrfs_tree_unlock(path->nodes[level]);
+				path->locks[level] = 0;
 			}
-			free_extent_buffer(path->nodes[i]);
-			path->nodes[i] = NULL;
-			*level = i + 1;
+			free_extent_buffer(path->nodes[level]);
+			path->nodes[level] = NULL;
+			level++;
 		}
 	}
 	return 1;
 }
 
 /*
- * drop the reference count on the tree rooted at 'snap'.  This traverses
- * the tree freeing any blocks that have a ref count of zero after being
- * decremented.
+ * drop a subvolume tree.
+ *
+ * this function traverses the tree freeing any blocks that only
+ * referenced by the tree.
+ *
+ * when a shared tree block is found. this function decreases its
+ * reference count by one. if update_ref is true, this function
+ * also make sure backrefs for the shared block and all lower level
+ * blocks are properly updated.
  */
-int btrfs_drop_snapshot(struct btrfs_trans_handle *trans, struct btrfs_root
-			*root)
+int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref)
 {
-	int ret = 0;
-	int wret;
-	int level;
 	struct btrfs_path *path;
-	int update_count;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *tree_root = root->fs_info->tree_root;
 	struct btrfs_root_item *root_item = &root->root_item;
+	struct walk_control *wc;
+	struct btrfs_key key;
+	int err = 0;
+	int ret;
+	int level;
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
-	level = btrfs_header_level(root->node);
+	wc = kzalloc(sizeof(*wc), GFP_NOFS);
+	BUG_ON(!wc);
+
+	trans = btrfs_start_transaction(tree_root, 1);
+
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
+		level = btrfs_header_level(root->node);
 		path->nodes[level] = btrfs_lock_root_node(root);
 		btrfs_set_lock_blocking(path->nodes[level]);
 		path->slots[level] = 0;
 		path->locks[level] = 1;
+		memset(&wc->update_progress, 0,
+		       sizeof(wc->update_progress));
 	} else {
-		struct btrfs_key key;
-		struct btrfs_disk_key found_key;
-		struct extent_buffer *node;
-
 		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
+		memcpy(&wc->update_progress, &key,
+		       sizeof(wc->update_progress));
+
 		level = root_item->drop_level;
+		BUG_ON(level == 0);
 		path->lowest_level = level;
-		wret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-		if (wret < 0) {
-			ret = wret;
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		path->lowest_level = 0;
+		if (ret < 0) {
+			err = ret;
 			goto out;
 		}
-		node = path->nodes[level];
-		btrfs_node_key(node, &found_key, path->slots[level]);
-		WARN_ON(memcmp(&found_key, &root_item->drop_progress,
-			       sizeof(found_key)));
+		btrfs_node_key_to_cpu(path->nodes[level], &key,
+				      path->slots[level]);
+		WARN_ON(memcmp(&key, &wc->update_progress, sizeof(key)));
+
 		/*
 		 * unlock our path, this is safe because only this
 		 * function is allowed to delete this snapshot
 		 */
 		btrfs_unlock_up_safe(path, 0);
+
+		level = btrfs_header_level(root->node);
+		while (1) {
+			btrfs_tree_lock(path->nodes[level]);
+			btrfs_set_lock_blocking(path->nodes[level]);
+
+			ret = btrfs_lookup_extent_info(trans, root,
+						path->nodes[level]->start,
+						path->nodes[level]->len,
+						&wc->refs[level],
+						&wc->flags[level]);
+			BUG_ON(ret);
+			BUG_ON(wc->refs[level] == 0);
+
+			if (level == root_item->drop_level)
+				break;
+
+			btrfs_tree_unlock(path->nodes[level]);
+			WARN_ON(wc->refs[level] != 1);
+			level--;
+		}
 	}
+
+	wc->level = level;
+	wc->shared_level = -1;
+	wc->stage = DROP_REFERENCE;
+	wc->update_ref = update_ref;
+	wc->keep_locks = 0;
+
 	while (1) {
-		unsigned long update;
-		wret = walk_down_tree(trans, root, path, &level);
-		if (wret > 0)
+		ret = walk_down_tree(trans, root, path, wc);
+		if (ret < 0) {
+			err = ret;
 			break;
-		if (wret < 0)
-			ret = wret;
+		}
 
-		wret = walk_up_tree(trans, root, path, &level,
-				    BTRFS_MAX_LEVEL);
-		if (wret > 0)
+		ret = walk_up_tree(trans, root, path, wc, BTRFS_MAX_LEVEL);
+		if (ret < 0) {
+			err = ret;
 			break;
-		if (wret < 0)
-			ret = wret;
-		if (trans->transaction->in_commit ||
-		    trans->transaction->delayed_refs.flushing) {
-			ret = -EAGAIN;
+		}
+
+		if (ret > 0) {
+			BUG_ON(wc->stage != DROP_REFERENCE);
 			break;
 		}
-		for (update_count = 0; update_count < 16; update_count++) {
+
+		if (wc->stage == DROP_REFERENCE) {
+			level = wc->level;
+			btrfs_node_key(path->nodes[level],
+				       &root_item->drop_progress,
+				       path->slots[level]);
+			root_item->drop_level = level;
+		}
+
+		BUG_ON(wc->level == 0);
+		if (trans->transaction->in_commit ||
+		    trans->transaction->delayed_refs.flushing) {
+			ret = btrfs_update_root(trans, tree_root,
+						&root->root_key,
+						root_item);
+			BUG_ON(ret);
+
+			btrfs_end_transaction(trans, tree_root);
+			trans = btrfs_start_transaction(tree_root, 1);
+		} else {
+			unsigned long update;
 			update = trans->delayed_ref_updates;
 			trans->delayed_ref_updates = 0;
 			if (update)
-				btrfs_run_delayed_refs(trans, root, update);
-			else
-				break;
+				btrfs_run_delayed_refs(trans, tree_root,
+						       update);
 		}
 	}
+	btrfs_release_path(root, path);
+	BUG_ON(err);
+
+	ret = btrfs_del_root(trans, tree_root, &root->root_key);
+	BUG_ON(ret);
+
+	free_extent_buffer(root->node);
+	free_extent_buffer(root->commit_root);
+	kfree(root);
 out:
+	btrfs_end_transaction(trans, tree_root);
+	kfree(wc);
 	btrfs_free_path(path);
-	return ret;
+	return err;
 }
 
+/*
+ * drop subtree rooted at tree block 'node'.
+ *
+ * NOTE: this function will unlock and release tree block 'node'
+ */
 int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct extent_buffer *node,
 			struct extent_buffer *parent)
 {
 	struct btrfs_path *path;
+	struct walk_control *wc;
 	int level;
 	int parent_level;
 	int ret = 0;
 	int wret;
 
+	BUG_ON(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
+
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
+	wc = kzalloc(sizeof(*wc), GFP_NOFS);
+	BUG_ON(!wc);
+
 	btrfs_assert_tree_locked(parent);
 	parent_level = btrfs_header_level(parent);
 	extent_buffer_get(parent);
@@ -4817,24 +5024,33 @@ int btrfs_drop_subtree(struct btrfs_tran
 
 	btrfs_assert_tree_locked(node);
 	level = btrfs_header_level(node);
-	extent_buffer_get(node);
 	path->nodes[level] = node;
 	path->slots[level] = 0;
+	path->locks[level] = 1;
+
+	wc->refs[parent_level] = 1;
+	wc->flags[parent_level] = BTRFS_BLOCK_FLAG_FULL_BACKREF;
+	wc->level = level;
+	wc->shared_level = -1;
+	wc->stage = DROP_REFERENCE;
+	wc->update_ref = 0;
+	wc->keep_locks = 1;
 
 	while (1) {
-		wret = walk_down_tree(trans, root, path, &level);
-		if (wret < 0)
+		wret = walk_down_tree(trans, root, path, wc);
+		if (wret < 0) {
 			ret = wret;
-		if (wret != 0)
 			break;
+		}
 
-		wret = walk_up_tree(trans, root, path, &level, parent_level);
+		wret = walk_up_tree(trans, root, path, wc, parent_level);
 		if (wret < 0)
 			ret = wret;
 		if (wret != 0)
 			break;
 	}
 
+	kfree(wc);
 	btrfs_free_path(path);
 	return ret;
 }
diff -urp 1/fs/btrfs/relocation.c 2/fs/btrfs/relocation.c
--- 1/fs/btrfs/relocation.c	2009-06-12 21:32:39.789515179 +0800
+++ 2/fs/btrfs/relocation.c	2009-06-12 23:07:33.000000000 +0800
@@ -1788,7 +1788,7 @@ static void merge_func(struct btrfs_work
 		btrfs_end_transaction(trans, root);
 	}
 
-	btrfs_drop_dead_root(reloc_root);
+	btrfs_drop_snapshot(reloc_root, 0);
 
 	if (atomic_dec_and_test(async->num_pending))
 		complete(async->done);
@@ -2075,9 +2075,6 @@ static int do_relocation(struct btrfs_tr
 
 			ret = btrfs_drop_subtree(trans, root, eb, upper->eb);
 			BUG_ON(ret);
-
-			btrfs_tree_unlock(eb);
-			free_extent_buffer(eb);
 		}
 		if (!lowest) {
 			btrfs_tree_unlock(upper->eb);
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2009-06-12 21:32:39.812512710 +0800
+++ 2/fs/btrfs/transaction.c	2009-06-15 13:33:56.000000000 +0800
@@ -593,6 +593,7 @@ int btrfs_defrag_root(struct btrfs_root 
 	return 0;
 }
 
+#if 0
 /*
  * when dropping snapshots, we generate a ton of delayed refs, and it makes
  * sense not to join the transaction while it is trying to flush the current
@@ -681,6 +682,7 @@ int btrfs_drop_dead_root(struct btrfs_ro
 	btrfs_btree_balance_dirty(tree_root, nr);
 	return ret;
 }
+#endif
 
 /*
  * new snapshots need to be created at a very specific time in the
@@ -1081,7 +1083,7 @@ int btrfs_clean_old_snapshots(struct btr
 	while (!list_empty(&list)) {
 		root = list_entry(list.next, struct btrfs_root, root_list);
 		list_del_init(&root->root_list);
-		btrfs_drop_dead_root(root);
+		btrfs_drop_snapshot(root, 0);
 	}
 	return 0;
 }
