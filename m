Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:44224 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab2EZK7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:52 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 10/15] Btrfs: put all block modifications into the tree mod log
Date: Sat, 26 May 2012 12:59:44 +0200
Message-Id: <0f5adc055ff4d548ce711175f89bb18998aae2c4.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running functions that can make changes to the internal trees
(e.g. btrfs_search_slot), we check if somebody may be interested in the
block we're currently modifying. If so, we record our modification to be
able to rewind it later on.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6a7418d..7c2d79c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -39,6 +39,14 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *src_buf);
 static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot);
+static void tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
+				 struct extent_buffer *eb);
+struct extent_buffer *read_old_tree_block(struct btrfs_root *root, u64 bytenr,
+					  u32 blocksize, u64 parent_transid,
+					  u64 time_seq);
+struct extent_buffer *btrfs_find_old_tree_block(struct btrfs_root *root,
+						u64 bytenr, u32 blocksize,
+						u64 time_seq);
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
@@ -677,6 +685,9 @@ static void tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 	int ret;
 	u32 nritems;
 
+	if (btrfs_header_level(eb) == 0)
+		return;
+
 	nritems = btrfs_header_nritems(eb);
 	for (i = nritems - 1; i >= 0; i--) {
 		ret = tree_mod_log_insert_key(fs_info, eb, i,
@@ -817,6 +828,12 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			ret = btrfs_dec_ref(trans, root, buf, 1, 1);
 			BUG_ON(ret); /* -ENOMEM */
 		}
+		/*
+		 * don't log freeing in case we're freeing the root node, this
+		 * is done by tree_mod_log_set_root_pointer later
+		 */
+		if (buf != root->node && btrfs_header_level(buf) != 0)
+			tree_mod_log_free_eb(root->fs_info, buf);
 		clean_tree_block(trans, root, buf);
 		*last_ref = 1;
 	}
@@ -914,6 +931,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			parent_start = 0;
 
 		extent_buffer_get(cow);
+		tree_mod_log_set_root_pointer(root, cow);
 		rcu_assign_pointer(root->node, cow);
 
 		btrfs_free_tree_block(trans, root, buf, parent_start,
@@ -927,6 +945,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			parent_start = 0;
 
 		WARN_ON(trans->transid != btrfs_header_generation(parent));
+		tree_mod_log_insert_key(root->fs_info, parent, parent_slot,
+					MOD_LOG_KEY_REPLACE);
 		btrfs_set_node_blockptr(parent, parent_slot,
 					cow->start);
 		btrfs_set_node_ptr_generation(parent, parent_slot,
@@ -1382,6 +1402,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			goto enospc;
 		}
 
+		tree_mod_log_set_root_pointer(root, child);
 		rcu_assign_pointer(root->node, child);
 
 		add_root_to_dirty_list(root);
@@ -1456,6 +1477,8 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		} else {
 			struct btrfs_disk_key right_key;
 			btrfs_node_key(right, &right_key, 0);
+			tree_mod_log_set_node_key(root->fs_info, parent,
+						  &right_key, pslot + 1, 0);
 			btrfs_set_node_key(parent, &right_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 		}
@@ -1499,6 +1522,8 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		/* update the parent key to reflect our changes */
 		struct btrfs_disk_key mid_key;
 		btrfs_node_key(mid, &mid_key, 0);
+		tree_mod_log_set_node_key(root->fs_info, parent, &mid_key,
+					  pslot, 0);
 		btrfs_set_node_key(parent, &mid_key, pslot);
 		btrfs_mark_buffer_dirty(parent);
 	}
@@ -1596,6 +1621,8 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			struct btrfs_disk_key disk_key;
 			orig_slot += left_nr;
 			btrfs_node_key(mid, &disk_key, 0);
+			tree_mod_log_set_node_key(root->fs_info, parent,
+						  &disk_key, pslot, 0);
 			btrfs_set_node_key(parent, &disk_key, pslot);
 			btrfs_mark_buffer_dirty(parent);
 			if (btrfs_header_nritems(left) > orig_slot) {
@@ -1647,6 +1674,8 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_node_key(right, &disk_key, 0);
+			tree_mod_log_set_node_key(root->fs_info, parent,
+						  &disk_key, pslot + 1, 0);
 			btrfs_set_node_key(parent, &disk_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 
@@ -2349,6 +2378,7 @@ static void fixup_low_keys(struct btrfs_trans_handle *trans,
 		if (!path->nodes[i])
 			break;
 		t = path->nodes[i];
+		tree_mod_log_set_node_key(root->fs_info, t, key, tslot, 1);
 		btrfs_set_node_key(t, key, tslot);
 		btrfs_mark_buffer_dirty(path->nodes[i]);
 		if (tslot != 0)
@@ -2431,12 +2461,16 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 	} else
 		push_items = min(src_nritems - 8, push_items);
 
+	tree_mod_log_eb_copy(root->fs_info, dst, src, dst_nritems, 0,
+			     push_items);
 	copy_extent_buffer(dst, src,
 			   btrfs_node_key_ptr_offset(dst_nritems),
 			   btrfs_node_key_ptr_offset(0),
 			   push_items * sizeof(struct btrfs_key_ptr));
 
 	if (push_items < src_nritems) {
+		tree_mod_log_eb_move(root->fs_info, src, 0, push_items,
+				     src_nritems - push_items);
 		memmove_extent_buffer(src, btrfs_node_key_ptr_offset(0),
 				      btrfs_node_key_ptr_offset(push_items),
 				      (src_nritems - push_items) *
@@ -2490,11 +2524,14 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 	if (max_push < push_items)
 		push_items = max_push;
 
+	tree_mod_log_eb_move(root->fs_info, dst, push_items, 0, dst_nritems);
 	memmove_extent_buffer(dst, btrfs_node_key_ptr_offset(push_items),
 				      btrfs_node_key_ptr_offset(0),
 				      (dst_nritems) *
 				      sizeof(struct btrfs_key_ptr));
 
+	tree_mod_log_eb_copy(root->fs_info, dst, src, 0,
+			     src_nritems - push_items, push_items);
 	copy_extent_buffer(dst, src,
 			   btrfs_node_key_ptr_offset(0),
 			   btrfs_node_key_ptr_offset(src_nritems - push_items),
@@ -2569,6 +2606,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(c);
 
 	old = root->node;
+	tree_mod_log_set_root_pointer(root, c);
 	rcu_assign_pointer(root->node, c);
 
 	/* the super has an extra ref to root->node */
@@ -2679,6 +2717,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
 
+	tree_mod_log_eb_copy(root->fs_info, split, c, 0, mid, c_nritems - mid);
 	copy_extent_buffer(split, c,
 			   btrfs_node_key_ptr_offset(0),
 			   btrfs_node_key_ptr_offset(mid),
-- 
1.7.3.4

