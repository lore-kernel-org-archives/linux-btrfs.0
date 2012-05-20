Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46301 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab2ETQGj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:39 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 08/24] Btrfs: put all modifications into the tree mod log
Date: Sun, 20 May 2012 18:06:19 +0200
Message-Id: <fd709988b0c8ac09fcacc9d43e8a800a1701f915.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running functions that can make changes to the internal trees
(e.g. btrfs_search_slot), we check if somebody may be interested in the
block we're currently modifying. If so, we record our modification to be
able to rewind it later on.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |  126 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 79 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6420638..724eade 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -38,7 +38,18 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *dst_buf,
 			      struct extent_buffer *src_buf);
 static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   struct btrfs_path *path, int level, int slot);
+		    struct btrfs_path *path, int level, int slot,
+		    int tree_mod_log);
+static inline void set_root_pointer(struct btrfs_root *root,
+				    struct extent_buffer *new_root_node);
+static void __log_cleaning(struct btrfs_fs_info *fs_info,
+			   struct extent_buffer *eb);
+struct extent_buffer *read_old_tree_block(struct btrfs_root *root, u64 bytenr,
+					  u32 blocksize, u64 parent_transid,
+					  u64 time_seq);
+struct extent_buffer *btrfs_find_old_tree_block(struct btrfs_root *root,
+						u64 bytenr, u32 blocksize,
+						u64 time_seq);
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
@@ -678,6 +689,9 @@ static void __log_cleaning(struct btrfs_fs_info *fs_info,
 	int ret;
 	u32 nritems;
 
+	if (btrfs_header_level(eb) == 0)
+		return;
+
 	nritems = btrfs_header_nritems(eb);
 	for (i = nritems - 1; i >= 0; i--) {
 		ret = tree_mod_log_insert_key(fs_info, eb, i,
@@ -818,6 +832,9 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			ret = btrfs_dec_ref(trans, root, buf, 1, 1);
 			BUG_ON(ret); /* -ENOMEM */
 		}
+		/* the root node will be logged in set_root_pointer later */
+		if (buf != root->node && btrfs_header_level(buf) != 0)
+			__log_cleaning(root->fs_info, buf);
 		clean_tree_block(trans, root, buf);
 		*last_ref = 1;
 	}
@@ -915,7 +932,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			parent_start = 0;
 
 		extent_buffer_get(cow);
-		rcu_assign_pointer(root->node, cow);
+		set_root_pointer(root, cow);
 
 		btrfs_free_tree_block(trans, root, buf, parent_start,
 				      last_ref);
@@ -928,6 +945,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			parent_start = 0;
 
 		WARN_ON(trans->transid != btrfs_header_generation(parent));
+		tree_mod_log_insert_key(root->fs_info, parent, parent_slot,
+					MOD_LOG_KEY_REPLACE);
 		btrfs_set_node_blockptr(parent, parent_slot,
 					cow->start);
 		btrfs_set_node_ptr_generation(parent, parent_slot,
@@ -1383,7 +1402,9 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			goto enospc;
 		}
 
-		rcu_assign_pointer(root->node, child);
+		ret = tree_mod_log_insert_key(root->fs_info, mid, 0,
+					      MOD_LOG_KEY_REMOVE);
+		set_root_pointer(root, child);
 
 		add_root_to_dirty_list(root);
 		btrfs_tree_unlock(child);
@@ -1449,7 +1470,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (btrfs_header_nritems(right) == 0) {
 			clean_tree_block(trans, root, right);
 			btrfs_tree_unlock(right);
-			del_ptr(trans, root, path, level + 1, pslot + 1);
+			del_ptr(trans, root, path, level + 1, pslot + 1, 1);
 			root_sub_used(root, right->len);
 			btrfs_free_tree_block(trans, root, right, 0, 1);
 			free_extent_buffer_stale(right);
@@ -1457,7 +1478,8 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		} else {
 			struct btrfs_disk_key right_key;
 			btrfs_node_key(right, &right_key, 0);
-			btrfs_set_node_key(parent, &right_key, pslot + 1);
+			__set_node_key_log(root->fs_info, parent,
+					   &right_key, pslot + 1, 0);
 			btrfs_mark_buffer_dirty(parent);
 		}
 	}
@@ -1491,7 +1513,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	if (btrfs_header_nritems(mid) == 0) {
 		clean_tree_block(trans, root, mid);
 		btrfs_tree_unlock(mid);
-		del_ptr(trans, root, path, level + 1, pslot);
+		del_ptr(trans, root, path, level + 1, pslot, 1);
 		root_sub_used(root, mid->len);
 		btrfs_free_tree_block(trans, root, mid, 0, 1);
 		free_extent_buffer_stale(mid);
@@ -1500,7 +1522,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		/* update the parent key to reflect our changes */
 		struct btrfs_disk_key mid_key;
 		btrfs_node_key(mid, &mid_key, 0);
-		btrfs_set_node_key(parent, &mid_key, pslot);
+		__set_node_key_log(root->fs_info, parent, &mid_key, pslot, 0);
 		btrfs_mark_buffer_dirty(parent);
 	}
 
@@ -1597,7 +1619,8 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			struct btrfs_disk_key disk_key;
 			orig_slot += left_nr;
 			btrfs_node_key(mid, &disk_key, 0);
-			btrfs_set_node_key(parent, &disk_key, pslot);
+			__set_node_key_log(root->fs_info, parent, &disk_key,
+					   pslot, 0);
 			btrfs_mark_buffer_dirty(parent);
 			if (btrfs_header_nritems(left) > orig_slot) {
 				path->nodes[level] = left;
@@ -1648,7 +1671,8 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_node_key(right, &disk_key, 0);
-			btrfs_set_node_key(parent, &disk_key, pslot + 1);
+			__set_node_key_log(root->fs_info, parent, &disk_key,
+					   pslot + 1, 0);
 			btrfs_mark_buffer_dirty(parent);
 
 			if (btrfs_header_nritems(mid) <= orig_slot) {
@@ -2350,7 +2374,7 @@ static void fixup_low_keys(struct btrfs_trans_handle *trans,
 		if (!path->nodes[i])
 			break;
 		t = path->nodes[i];
-		btrfs_set_node_key(t, key, tslot);
+		__set_node_key_log(root->fs_info, t, key, tslot, 1);
 		btrfs_mark_buffer_dirty(path->nodes[i]);
 		if (tslot != 0)
 			break;
@@ -2432,16 +2456,14 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 	} else
 		push_items = min(src_nritems - 8, push_items);
 
-	copy_extent_buffer(dst, src,
-			   btrfs_node_key_ptr_offset(dst_nritems),
-			   btrfs_node_key_ptr_offset(0),
-			   push_items * sizeof(struct btrfs_key_ptr));
+
+	__copy_extent_buffer_log(root->fs_info, dst, src, dst_nritems, 0,
+				 push_items, sizeof(struct btrfs_key_ptr));
 
 	if (push_items < src_nritems) {
-		memmove_extent_buffer(src, btrfs_node_key_ptr_offset(0),
-				      btrfs_node_key_ptr_offset(push_items),
-				      (src_nritems - push_items) *
-				      sizeof(struct btrfs_key_ptr));
+		__memmove_extent_buffer_log(root->fs_info, src, 0, push_items,
+					src_nritems - push_items,
+					sizeof(struct btrfs_key_ptr), 1);
 	}
 	btrfs_set_header_nritems(src, src_nritems - push_items);
 	btrfs_set_header_nritems(dst, dst_nritems + push_items);
@@ -2491,15 +2513,13 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 	if (max_push < push_items)
 		push_items = max_push;
 
-	memmove_extent_buffer(dst, btrfs_node_key_ptr_offset(push_items),
-				      btrfs_node_key_ptr_offset(0),
-				      (dst_nritems) *
-				      sizeof(struct btrfs_key_ptr));
+	__memmove_extent_buffer_log(root->fs_info, dst, push_items, 0,
+				    dst_nritems,
+				    sizeof(struct btrfs_key_ptr), 1);
 
-	copy_extent_buffer(dst, src,
-			   btrfs_node_key_ptr_offset(0),
-			   btrfs_node_key_ptr_offset(src_nritems - push_items),
-			   push_items * sizeof(struct btrfs_key_ptr));
+	__copy_extent_buffer_log(root->fs_info, dst, src, 0,
+				 src_nritems - push_items,
+				 push_items, sizeof(struct btrfs_key_ptr));
 
 	btrfs_set_header_nritems(src, src_nritems - push_items);
 	btrfs_set_header_nritems(dst, dst_nritems + push_items);
@@ -2570,7 +2590,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(c);
 
 	old = root->node;
-	rcu_assign_pointer(root->node, c);
+	set_root_pointer(root, c);
 
 	/* the super has an extra ref to root->node */
 	free_extent_buffer(old);
@@ -2593,10 +2613,11 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
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
@@ -2605,10 +2626,15 @@ static void insert_ptr(struct btrfs_trans_handle *trans,
 	BUG_ON(slot > nritems);
 	BUG_ON(nritems == BTRFS_NODEPTRS_PER_BLOCK(root));
 	if (slot != nritems) {
-		memmove_extent_buffer(lower,
-			      btrfs_node_key_ptr_offset(slot + 1),
-			      btrfs_node_key_ptr_offset(slot),
-			      (nritems - slot) * sizeof(struct btrfs_key_ptr));
+		__memmove_extent_buffer_log(root->fs_info, lower, slot + 1,
+					    slot, nritems - slot,
+					    sizeof(struct btrfs_key_ptr),
+					    tree_mod_log && level);
+	}
+	if (tree_mod_log && level) {
+		ret = tree_mod_log_insert_key(root->fs_info, lower, slot,
+					      MOD_LOG_KEY_ADD);
+		BUG_ON(ret < 0);
 	}
 	btrfs_set_node_key(lower, key, slot);
 	btrfs_set_node_blockptr(lower, slot, bytenr);
@@ -2681,10 +2707,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 			    BTRFS_UUID_SIZE);
 
 
-	copy_extent_buffer(split, c,
-			   btrfs_node_key_ptr_offset(0),
-			   btrfs_node_key_ptr_offset(mid),
-			   (c_nritems - mid) * sizeof(struct btrfs_key_ptr));
+	__copy_extent_buffer_log(root->fs_info, split, c, 0, mid,
+				 c_nritems - mid, sizeof(struct btrfs_key_ptr));
 	btrfs_set_header_nritems(split, c_nritems - mid);
 	btrfs_set_header_nritems(c, mid);
 	ret = 0;
@@ -2693,7 +2717,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(split);
 
 	insert_ptr(trans, root, path, &disk_key, split->start,
-		   path->slots[level + 1] + 1, level + 1);
+		   path->slots[level + 1] + 1, level + 1, 1);
 
 	if (path->slots[level] >= mid) {
 		path->slots[level] -= mid;
@@ -3230,7 +3254,7 @@ static noinline void copy_for_split(struct btrfs_trans_handle *trans,
 	btrfs_set_header_nritems(l, mid);
 	btrfs_item_key(right, &disk_key, 0);
 	insert_ptr(trans, root, path, &disk_key, right->start,
-		   path->slots[1] + 1, 1);
+		   path->slots[1] + 1, 1, 0);
 
 	btrfs_mark_buffer_dirty(right);
 	btrfs_mark_buffer_dirty(l);
@@ -3437,7 +3461,7 @@ again:
 		if (mid <= slot) {
 			btrfs_set_header_nritems(right, 0);
 			insert_ptr(trans, root, path, &disk_key, right->start,
-				   path->slots[1] + 1, 1);
+				   path->slots[1] + 1, 1, 0);
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
@@ -3446,7 +3470,7 @@ again:
 		} else {
 			btrfs_set_header_nritems(right, 0);
 			insert_ptr(trans, root, path, &disk_key, right->start,
-					  path->slots[1], 1);
+					  path->slots[1], 1, 0);
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
@@ -4158,19 +4182,27 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
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
-		memmove_extent_buffer(parent,
-			      btrfs_node_key_ptr_offset(slot),
-			      btrfs_node_key_ptr_offset(slot + 1),
-			      sizeof(struct btrfs_key_ptr) *
-			      (nritems - slot - 1));
+		__memmove_extent_buffer_log(root->fs_info, parent, slot,
+					    slot + 1, nritems - slot - 1,
+					    sizeof(struct btrfs_key_ptr),
+					    tree_mod_log && level);
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
@@ -4202,7 +4234,7 @@ static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
 				    struct extent_buffer *leaf)
 {
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
-	del_ptr(trans, root, path, 1, path->slots[1]);
+	del_ptr(trans, root, path, 1, path->slots[1], 1);
 
 	/*
 	 * btrfs_free_extent is expensive, we want to make sure we
-- 
1.7.3.4

