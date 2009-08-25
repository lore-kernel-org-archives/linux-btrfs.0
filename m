From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 1/4] speed up snapshot dropping
Date: Tue, 25 Aug 2009 22:38:18 +0800
Message-ID: <4A93F75A.9050108@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch contains two changes to avoid unnecessary tree block reads during
snapshot dropping. First, check tree block's reference count and flags before
reading the tree block. if reference count > 1 and there is no need to update
backrefs, we can avoid reading the tree block. Second, save when snapshot was
created in root_key.offset. we can compare block pointer's generation with
snapshot's creation generation during updating backrefs. If a given block was
created before snapshot was created, the snapshot can't be the tree block's
owner. So we can avoid reading the block.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-08-11 09:49:15.643738232 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-08-24 10:36:43.016348000 +0800
@@ -4779,19 +4779,90 @@ struct walk_control {
 	int shared_level;
 	int update_ref;
 	int keep_locks;
+	int reada_end;
+	int reada_count;
 };
 
 #define DROP_REFERENCE	1
 #define UPDATE_BACKREF	2
 
+static noinline void reada_walk_down(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     struct walk_control *wc,
+				     struct btrfs_path *path)
+{
+	u64 bytenr;
+	u64 generation;
+	u64 refs;
+	u64 last = 0;
+	u32 nritems;
+	u32 blocksize;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	int ret;
+	int slot;
+	int nread = 0;
+
+	if (path->slots[wc->level] < wc->reada_end) {
+		wc->reada_count = wc->reada_count * 2 / 3;
+		wc->reada_count = max(wc->reada_count, 2);
+	} else {
+		wc->reada_count = wc->reada_count * 3 / 2;
+		wc->reada_count = min_t(int, wc->reada_count,
+					BTRFS_NODEPTRS_PER_BLOCK(root));
+	}
+
+	eb = path->nodes[wc->level];
+	nritems = btrfs_header_nritems(eb);
+	blocksize = btrfs_level_size(root, wc->level - 1);
+
+	for (slot = path->slots[wc->level]; slot < nritems; slot++) {
+		if (nread >= wc->reada_count)
+			break;
+
+		cond_resched();
+		bytenr = btrfs_node_blockptr(eb, slot);
+		generation = btrfs_node_ptr_generation(eb, slot);
+
+		if (slot == path->slots[wc->level])
+			goto reada;
+
+		if (wc->stage == UPDATE_BACKREF &&
+		    generation <= root->root_key.offset)
+			continue;
+
+		if (wc->stage == DROP_REFERENCE) {
+			ret = btrfs_lookup_extent_info(trans, root,
+						bytenr, blocksize,
+						&refs, NULL);
+			BUG_ON(ret);
+			BUG_ON(refs == 0);
+			if (refs == 1)
+				goto reada;
+
+			if (!wc->update_ref ||
+			    generation <= root->root_key.offset)
+				continue;
+			btrfs_node_key_to_cpu(eb, &key, slot);
+			ret = btrfs_comp_cpu_keys(&key,
+						  &wc->update_progress);
+			if (ret < 0)
+				continue;
+		}
+reada:
+		ret = readahead_tree_block(root, bytenr, blocksize,
+					   generation);
+		if (ret)
+			break;
+		last = bytenr + blocksize;
+		nread++;
+	}
+	wc->reada_end = slot;
+}
+
 /*
  * hepler to process tree block while walking down the tree.
  *
- * when wc->stage == DROP_REFERENCE, this function checks
- * reference count of the block. if the block is shared and
- * we need update back refs for the subtree rooted at the
- * block, this function changes wc->stage to UPDATE_BACKREF
- *
  * when wc->stage == UPDATE_BACKREF, this function updates
  * back refs for pointers in the block.
  *
@@ -4804,7 +4875,6 @@ static noinline int walk_down_proc(struc
 {
 	int level = wc->level;
 	struct extent_buffer *eb = path->nodes[level];
-	struct btrfs_key key;
 	u64 flag = BTRFS_BLOCK_FLAG_FULL_BACKREF;
 	int ret;
 
@@ -4827,21 +4897,6 @@ static noinline int walk_down_proc(struc
 		BUG_ON(wc->refs[level] == 0);
 	}
 
-	if (wc->stage == DROP_REFERENCE &&
-	    wc->update_ref && wc->refs[level] > 1) {
-		BUG_ON(eb == root->node);
-		BUG_ON(path->slots[level] > 0);
-		if (level == 0)
-			btrfs_item_key_to_cpu(eb, &key, path->slots[level]);
-		else
-			btrfs_node_key_to_cpu(eb, &key, path->slots[level]);
-		if (btrfs_header_owner(eb) == root->root_key.objectid &&
-		    btrfs_comp_cpu_keys(&key, &wc->update_progress) >= 0) {
-			wc->stage = UPDATE_BACKREF;
-			wc->shared_level = level;
-		}
-	}
-
 	if (wc->stage == DROP_REFERENCE) {
 		if (wc->refs[level] > 1)
 			return 1;
@@ -4878,6 +4933,123 @@ static noinline int walk_down_proc(struc
 }
 
 /*
+ * hepler to process tree block pointer.
+ *
+ * when wc->stage == DROP_REFERENCE, this function checks
+ * reference count of the block pointed to. if the block
+ * is shared and we need update back refs for the subtree
+ * rooted at the block, this function changes wc->stage to
+ * UPDATE_BACKREF. if the block is shared and there is no
+ * need to update back, this function drops the reference
+ * to the block.
+ *
+ * NOTE: return value 1 means we should stop walking down.
+ */
+static noinline int do_walk_down(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_path *path,
+				 struct walk_control *wc)
+{
+	u64 bytenr;
+	u64 generation;
+	u64 parent;
+	u32 blocksize;
+	struct btrfs_key key;
+	struct extent_buffer *next;
+	int level = wc->level;
+	int reada = 0;
+	int ret = 0;
+
+	generation = btrfs_node_ptr_generation(path->nodes[level],
+					       path->slots[level]);
+	/*
+	 * if the lower level block was created before the snapshot
+	 * was created, we know there is no need to update back refs
+	 * for the subtree
+	 */
+	if (wc->stage == UPDATE_BACKREF &&
+	    generation <= root->root_key.offset)
+		return 1;
+
+	bytenr = btrfs_node_blockptr(path->nodes[level], path->slots[level]);
+	blocksize = btrfs_level_size(root, level - 1);
+
+	next = btrfs_find_tree_block(root, bytenr, blocksize);
+	if (!next) {
+		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
+		reada = 1;
+	}
+	btrfs_tree_lock(next);
+	btrfs_set_lock_blocking(next);
+
+	if (wc->stage == DROP_REFERENCE) {
+		ret = btrfs_lookup_extent_info(trans, root, bytenr, blocksize,
+					       &wc->refs[level - 1],
+					       &wc->flags[level - 1]);
+		BUG_ON(ret);
+		BUG_ON(wc->refs[level - 1] == 0);
+
+		if (wc->refs[level - 1] > 1) {
+			if (!wc->update_ref ||
+			    generation <= root->root_key.offset)
+				goto skip;
+
+			btrfs_node_key_to_cpu(path->nodes[level], &key,
+					      path->slots[level]);
+			ret = btrfs_comp_cpu_keys(&key, &wc->update_progress);
+			if (ret < 0)
+				goto skip;
+
+			wc->stage = UPDATE_BACKREF;
+			wc->shared_level = level - 1;
+		}
+	}
+
+	if (!btrfs_buffer_uptodate(next, generation)) {
+		btrfs_tree_unlock(next);
+		free_extent_buffer(next);
+		next = NULL;
+	}
+
+	if (!next) {
+		if (reada && level == 1)
+			reada_walk_down(trans, root, wc, path);
+		next = read_tree_block(root, bytenr, blocksize, generation);
+		btrfs_tree_lock(next);
+		btrfs_set_lock_blocking(next);
+	}
+
+	level--;
+	BUG_ON(level != btrfs_header_level(next));
+	path->nodes[level] = next;
+	path->slots[level] = 0;
+	path->locks[level] = 1;
+	wc->level = level;
+	if (wc->level == 1)
+		wc->reada_end = 0;
+	return 0;
+skip:
+	wc->refs[level - 1] = 0;
+	wc->flags[level - 1] = 0;
+
+	if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
+		parent = path->nodes[level]->start;
+	} else {
+		BUG_ON(root->root_key.objectid !=
+		       btrfs_header_owner(path->nodes[level]));
+		parent = 0;
+	}
+
+	ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
+				root->root_key.objectid, level - 1, 0);
+	BUG_ON(ret);
+
+	btrfs_tree_unlock(next);
+	free_extent_buffer(next);
+	return 1;
+}
+
+/*
  * hepler to process tree block while walking up the tree.
  *
  * when wc->stage == DROP_REFERENCE, this function drops
@@ -4904,7 +5076,6 @@ static noinline int walk_up_proc(struct 
 		if (level < wc->shared_level)
 			goto out;
 
-		BUG_ON(wc->refs[level] <= 1);
 		ret = find_next_key(path, level + 1, &wc->update_progress);
 		if (ret > 0)
 			wc->update_ref = 0;
@@ -4935,8 +5106,6 @@ static noinline int walk_up_proc(struct 
 				path->locks[level] = 0;
 				return 1;
 			}
-		} else {
-			BUG_ON(level != 0);
 		}
 	}
 
@@ -4989,17 +5158,13 @@ static noinline int walk_down_tree(struc
 				   struct btrfs_path *path,
 				   struct walk_control *wc)
 {
-	struct extent_buffer *next;
-	struct extent_buffer *cur;
-	u64 bytenr;
-	u64 ptr_gen;
-	u32 blocksize;
 	int level = wc->level;
 	int ret;
 
 	while (level >= 0) {
-		cur = path->nodes[level];
-		BUG_ON(path->slots[level] >= btrfs_header_nritems(cur));
+		if (path->slots[level] >=
+		    btrfs_header_nritems(path->nodes[level]))
+			break;
 
 		ret = walk_down_proc(trans, root, path, wc);
 		if (ret > 0)
@@ -5008,20 +5173,12 @@ static noinline int walk_down_tree(struc
 		if (level == 0)
 			break;
 
-		bytenr = btrfs_node_blockptr(cur, path->slots[level]);
-		blocksize = btrfs_level_size(root, level - 1);
-		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[level]);
-
-		next = read_tree_block(root, bytenr, blocksize, ptr_gen);
-		btrfs_tree_lock(next);
-		btrfs_set_lock_blocking(next);
-
-		level--;
-		BUG_ON(level != btrfs_header_level(next));
-		path->nodes[level] = next;
-		path->slots[level] = 0;
-		path->locks[level] = 1;
-		wc->level = level;
+		ret = do_walk_down(trans, root, path, wc);
+		if (ret > 0) {
+			path->slots[level]++;
+			continue;
+		}
+		level = wc->level;
 	}
 	return 0;
 }
@@ -5111,9 +5268,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 			err = ret;
 			goto out;
 		}
-		btrfs_node_key_to_cpu(path->nodes[level], &key,
-				      path->slots[level]);
-		WARN_ON(memcmp(&key, &wc->update_progress, sizeof(key)));
+		WARN_ON(ret > 0);
 
 		/*
 		 * unlock our path, this is safe because only this
@@ -5148,6 +5303,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	wc->stage = DROP_REFERENCE;
 	wc->update_ref = update_ref;
 	wc->keep_locks = 0;
+	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
 		ret = walk_down_tree(trans, root, path, wc);
@@ -5254,6 +5410,7 @@ int btrfs_drop_subtree(struct btrfs_tran
 	wc->stage = DROP_REFERENCE;
 	wc->update_ref = 0;
 	wc->keep_locks = 1;
+	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
 		wret = walk_down_tree(trans, root, path, wc);
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2009-07-31 13:48:03.038025845 +0800
+++ 2/fs/btrfs/transaction.c	2009-08-24 10:36:46.248107000 +0800
@@ -720,7 +720,8 @@ static noinline int create_pending_snaps
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 
 	key.objectid = objectid;
-	key.offset = 0;
+	/* record when the snapshot was created in key.offset */
+	key.offset = trans->transid;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 
 	old = btrfs_lock_root_node(root);
