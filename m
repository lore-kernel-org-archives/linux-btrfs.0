Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:44225 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab2EZK7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:52 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 11/15] Btrfs: add del_ptr and insert_ptr modifications to the tree mod log
Date: Sat, 26 May 2012 12:59:45 +0200
Message-Id: <dded25261853b1ee4f47dd8649ef811332dc7918.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Record all relevant modifications to block pointers in the tree mod log so
that we can rewind them later on for backref walking.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   42 ++++++++++++++++++++++++++++++++----------
 1 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7c2d79c..1edec6f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -38,7 +38,8 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *dst_buf,
 			      struct extent_buffer *src_buf);
 static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   struct btrfs_path *path, int level, int slot);
+		    struct btrfs_path *path, int level, int slot,
+		    int tree_mod_log);
 static void tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 				 struct extent_buffer *eb);
 struct extent_buffer *read_old_tree_block(struct btrfs_root *root, u64 bytenr,
@@ -1469,7 +1470,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (btrfs_header_nritems(right) == 0) {
 			clean_tree_block(trans, root, right);
 			btrfs_tree_unlock(right);
-			del_ptr(trans, root, path, level + 1, pslot + 1);
+			del_ptr(trans, root, path, level + 1, pslot + 1, 1);
 			root_sub_used(root, right->len);
 			btrfs_free_tree_block(trans, root, right, 0, 1);
 			free_extent_buffer_stale(right);
@@ -1513,7 +1514,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	if (btrfs_header_nritems(mid) == 0) {
 		clean_tree_block(trans, root, mid);
 		btrfs_tree_unlock(mid);
-		del_ptr(trans, root, path, level + 1, pslot);
+		del_ptr(trans, root, path, level + 1, pslot, 1);
 		root_sub_used(root, mid->len);
 		btrfs_free_tree_block(trans, root, mid, 0, 1);
 		free_extent_buffer_stale(mid);
@@ -2630,10 +2631,11 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 static void insert_ptr(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct btrfs_path *path,
 		       struct btrfs_disk_key *key, u64 bytenr,
-		       int slot, int level)
+		       int slot, int level, int tree_mod_log)
 {
 	struct extent_buffer *lower;
 	int nritems;
+	int ret;
 
 	BUG_ON(!path->nodes[level]);
 	btrfs_assert_tree_locked(path->nodes[level]);
@@ -2642,11 +2644,19 @@ static void insert_ptr(struct btrfs_trans_handle *trans,
 	BUG_ON(slot > nritems);
 	BUG_ON(nritems == BTRFS_NODEPTRS_PER_BLOCK(root));
 	if (slot != nritems) {
+		if (tree_mod_log && level)
+			tree_mod_log_eb_move(root->fs_info, lower, slot + 1,
+					     slot, nritems - slot);
 		memmove_extent_buffer(lower,
 			      btrfs_node_key_ptr_offset(slot + 1),
 			      btrfs_node_key_ptr_offset(slot),
 			      (nritems - slot) * sizeof(struct btrfs_key_ptr));
 	}
+	if (tree_mod_log && level) {
+		ret = tree_mod_log_insert_key(root->fs_info, lower, slot,
+					      MOD_LOG_KEY_ADD);
+		BUG_ON(ret < 0);
+	}
 	btrfs_set_node_key(lower, key, slot);
 	btrfs_set_node_blockptr(lower, slot, bytenr);
 	WARN_ON(trans->transid == 0);
@@ -2730,7 +2740,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(split);
 
 	insert_ptr(trans, root, path, &disk_key, split->start,
-		   path->slots[level + 1] + 1, level + 1);
+		   path->slots[level + 1] + 1, level + 1, 1);
 
 	if (path->slots[level] >= mid) {
 		path->slots[level] -= mid;
@@ -3267,7 +3277,7 @@ static noinline void copy_for_split(struct btrfs_trans_handle *trans,
 	btrfs_set_header_nritems(l, mid);
 	btrfs_item_key(right, &disk_key, 0);
 	insert_ptr(trans, root, path, &disk_key, right->start,
-		   path->slots[1] + 1, 1);
+		   path->slots[1] + 1, 1, 0);
 
 	btrfs_mark_buffer_dirty(right);
 	btrfs_mark_buffer_dirty(l);
@@ -3474,7 +3484,7 @@ again:
 		if (mid <= slot) {
 			btrfs_set_header_nritems(right, 0);
 			insert_ptr(trans, root, path, &disk_key, right->start,
-				   path->slots[1] + 1, 1);
+				   path->slots[1] + 1, 1, 0);
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
@@ -3483,7 +3493,7 @@ again:
 		} else {
 			btrfs_set_header_nritems(right, 0);
 			insert_ptr(trans, root, path, &disk_key, right->start,
-					  path->slots[1], 1);
+					  path->slots[1], 1, 0);
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
@@ -4195,19 +4205,31 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
  * empty a node.
  */
 static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		    struct btrfs_path *path, int level, int slot)
+		    struct btrfs_path *path, int level, int slot,
+		    int tree_mod_log)
 {
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
+	int ret;
 
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
+		if (tree_mod_log && level)
+			tree_mod_log_eb_move(root->fs_info, parent, slot,
+					     slot + 1, nritems - slot - 1);
 		memmove_extent_buffer(parent,
 			      btrfs_node_key_ptr_offset(slot),
 			      btrfs_node_key_ptr_offset(slot + 1),
 			      sizeof(struct btrfs_key_ptr) *
 			      (nritems - slot - 1));
 	}
+
+	if (tree_mod_log && level) {
+		ret = tree_mod_log_insert_key(root->fs_info, parent, slot,
+					      MOD_LOG_KEY_REMOVE);
+		BUG_ON(ret < 0);
+	}
+
 	nritems--;
 	btrfs_set_header_nritems(parent, nritems);
 	if (nritems == 0 && parent == root->node) {
@@ -4239,7 +4261,7 @@ static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
 				    struct extent_buffer *leaf)
 {
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
-	del_ptr(trans, root, path, 1, path->slots[1]);
+	del_ptr(trans, root, path, 1, path->slots[1], 1);
 
 	/*
 	 * btrfs_free_extent is expensive, we want to make sure we
-- 
1.7.3.4

