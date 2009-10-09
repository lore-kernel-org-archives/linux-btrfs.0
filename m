From: "Yan, Zheng" <zheng.yan@ORACLE.COM>
Subject: [PATCH] Optimize back reference update
Date: Fri, 09 Oct 2009 17:21:13 +0800
Message-ID: <4ACF0089.5030704@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@ORACLE.COM>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch optimize the backrefs update part of btrfs_drop_snapshot.
It avoids reading level 0 tree blocks that already use full backrefs.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-10-09 09:38:36.357269710 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-10-09 11:09:16.828020537 +0800
@@ -4809,6 +4809,7 @@ static noinline void reada_walk_down(str
 	u64 bytenr;
 	u64 generation;
 	u64 refs;
+	u64 flags;
 	u64 last = 0;
 	u32 nritems;
 	u32 blocksize;
@@ -4846,15 +4847,19 @@ static noinline void reada_walk_down(str
 		    generation <= root->root_key.offset)
 			continue;
 
+		/* We don't lock the tree block, it's OK to be racy here */
+		ret = btrfs_lookup_extent_info(trans, root, bytenr, blocksize,
+					       &refs, &flags);
+		BUG_ON(ret);
+		BUG_ON(refs == 0);
+
 		if (wc->stage == DROP_REFERENCE) {
-			ret = btrfs_lookup_extent_info(trans, root,
-						bytenr, blocksize,
-						&refs, NULL);
-			BUG_ON(ret);
-			BUG_ON(refs == 0);
 			if (refs == 1)
 				goto reada;
 
+			if (wc->level == 1 &&
+			    (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF))
+				continue;
 			if (!wc->update_ref ||
 			    generation <= root->root_key.offset)
 				continue;
@@ -4863,6 +4868,10 @@ static noinline void reada_walk_down(str
 						  &wc->update_progress);
 			if (ret < 0)
 				continue;
+		} else {
+			if (wc->level == 1 &&
+			    (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF))
+				continue;
 		}
 reada:
 		ret = readahead_tree_block(root, bytenr, blocksize,
@@ -4886,7 +4895,7 @@ reada:
 static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct btrfs_path *path,
-				   struct walk_control *wc)
+				   struct walk_control *wc, int lookup_info)
 {
 	int level = wc->level;
 	struct extent_buffer *eb = path->nodes[level];
@@ -4901,8 +4910,9 @@ static noinline int walk_down_proc(struc
 	 * when reference count of tree block is 1, it won't increase
 	 * again. once full backref flag is set, we never clear it.
 	 */
-	if ((wc->stage == DROP_REFERENCE && wc->refs[level] != 1) ||
-	    (wc->stage == UPDATE_BACKREF && !(wc->flags[level] & flag))) {
+	if (lookup_info &&
+	    ((wc->stage == DROP_REFERENCE && wc->refs[level] != 1) ||
+	     (wc->stage == UPDATE_BACKREF && !(wc->flags[level] & flag)))) {
 		BUG_ON(!path->locks[level]);
 		ret = btrfs_lookup_extent_info(trans, root,
 					       eb->start, eb->len,
@@ -4963,7 +4973,7 @@ static noinline int walk_down_proc(struc
 static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_path *path,
-				 struct walk_control *wc)
+				 struct walk_control *wc, int *lookup_info)
 {
 	u64 bytenr;
 	u64 generation;
@@ -4983,8 +4993,10 @@ static noinline int do_walk_down(struct 
 	 * for the subtree
 	 */
 	if (wc->stage == UPDATE_BACKREF &&
-	    generation <= root->root_key.offset)
+	    generation <= root->root_key.offset) {
+		*lookup_info = 1;
 		return 1;
+	}
 
 	bytenr = btrfs_node_blockptr(path->nodes[level], path->slots[level]);
 	blocksize = btrfs_level_size(root, level - 1);
@@ -4997,14 +5009,19 @@ static noinline int do_walk_down(struct 
 	btrfs_tree_lock(next);
 	btrfs_set_lock_blocking(next);
 
-	if (wc->stage == DROP_REFERENCE) {
-		ret = btrfs_lookup_extent_info(trans, root, bytenr, blocksize,
-					       &wc->refs[level - 1],
-					       &wc->flags[level - 1]);
-		BUG_ON(ret);
-		BUG_ON(wc->refs[level - 1] == 0);
+	ret = btrfs_lookup_extent_info(trans, root, bytenr, blocksize,
+				       &wc->refs[level - 1],
+				       &wc->flags[level - 1]);
+	BUG_ON(ret);
+	BUG_ON(wc->refs[level - 1] == 0);
+	*lookup_info = 0;
 
+	if (wc->stage == DROP_REFERENCE) {
 		if (wc->refs[level - 1] > 1) {
+			if (level == 1 &&
+			    (wc->flags[0] & BTRFS_BLOCK_FLAG_FULL_BACKREF))
+				goto skip;
+
 			if (!wc->update_ref ||
 			    generation <= root->root_key.offset)
 				goto skip;
@@ -5018,12 +5035,17 @@ static noinline int do_walk_down(struct 
 			wc->stage = UPDATE_BACKREF;
 			wc->shared_level = level - 1;
 		}
+	} else {
+		if (level == 1 &&
+		    (wc->flags[0] & BTRFS_BLOCK_FLAG_FULL_BACKREF))
+			goto skip;
 	}
 
 	if (!btrfs_buffer_uptodate(next, generation)) {
 		btrfs_tree_unlock(next);
 		free_extent_buffer(next);
 		next = NULL;
+		*lookup_info = 1;
 	}
 
 	if (!next) {
@@ -5046,21 +5068,22 @@ static noinline int do_walk_down(struct 
 skip:
 	wc->refs[level - 1] = 0;
 	wc->flags[level - 1] = 0;
+	if (wc->stage == DROP_REFERENCE) {
+		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
+			parent = path->nodes[level]->start;
+		} else {
+			BUG_ON(root->root_key.objectid !=
+			       btrfs_header_owner(path->nodes[level]));
+			parent = 0;
+		}
 
-	if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
-		parent = path->nodes[level]->start;
-	} else {
-		BUG_ON(root->root_key.objectid !=
-		       btrfs_header_owner(path->nodes[level]));
-		parent = 0;
+		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
+					root->root_key.objectid, level - 1, 0);
+		BUG_ON(ret);
 	}
-
-	ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
-				root->root_key.objectid, level - 1, 0);
-	BUG_ON(ret);
-
 	btrfs_tree_unlock(next);
 	free_extent_buffer(next);
+	*lookup_info = 1;
 	return 1;
 }
 
@@ -5174,6 +5197,7 @@ static noinline int walk_down_tree(struc
 				   struct walk_control *wc)
 {
 	int level = wc->level;
+	int lookup_info = 1;
 	int ret;
 
 	while (level >= 0) {
@@ -5181,14 +5205,14 @@ static noinline int walk_down_tree(struc
 		    btrfs_header_nritems(path->nodes[level]))
 			break;
 
-		ret = walk_down_proc(trans, root, path, wc);
+		ret = walk_down_proc(trans, root, path, wc, lookup_info);
 		if (ret > 0)
 			break;
 
 		if (level == 0)
 			break;
 
-		ret = do_walk_down(trans, root, path, wc);
+		ret = do_walk_down(trans, root, path, wc, &lookup_info);
 		if (ret > 0) {
 			path->slots[level]++;
 			continue;
