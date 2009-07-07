From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] speed up snapshot dropping v2
Date: Tue, 07 Jul 2009 19:02:21 +0800
Message-ID: <4A532B3D.40504@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
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

Fixed a bug since v1, the old one might trigger BUG_ON if snapshot's creation
generation isn't recorded in root_key.offset.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-07-03 08:08:34.152846801 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-07-07 18:44:32.817115175 +0800
@@ -4568,11 +4568,6 @@ struct walk_control {
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
@@ -4585,7 +4580,6 @@ static noinline int walk_down_proc(struc
 {
 	int level = wc->level;
 	struct extent_buffer *eb = path->nodes[level];
-	struct btrfs_key key;
 	u64 flag = BTRFS_BLOCK_FLAG_FULL_BACKREF;
 	int ret;
 
@@ -4608,21 +4602,6 @@ static noinline int walk_down_proc(struc
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
@@ -4659,6 +4638,113 @@ static noinline int walk_down_proc(struc
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
+	struct extent_buffer *next = NULL;
+	int level = wc->level;
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
+	if (wc->stage == DROP_REFERENCE) {
+		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
+		btrfs_tree_lock(next);
+		btrfs_set_lock_blocking(next);
+
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
+		if (!btrfs_buffer_uptodate(next, generation)) {
+			btrfs_tree_unlock(next);
+			free_extent_buffer(next);
+			next = NULL;
+		}
+	}
+
+	if (!next) {
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
@@ -4770,17 +4856,13 @@ static noinline int walk_down_tree(struc
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
@@ -4789,20 +4871,12 @@ static noinline int walk_down_tree(struc
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
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2009-07-03 08:08:34.161846457 +0800
+++ 2/fs/btrfs/transaction.c	2009-07-07 15:39:08.452836151 +0800
@@ -715,7 +715,8 @@ static noinline int create_pending_snaps
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 
 	key.objectid = objectid;
-	key.offset = 0;
+	/* record when the snapshot was created in key.offset */
+	key.offset = trans->transid;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 
 	old = btrfs_lock_root_node(root);
