Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:30025 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab3DMNUN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Apr 2013 09:20:13 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: fix tree mod log regression on root split operations
Date: Sat, 13 Apr 2013 15:19:53 +0200
Message-Id: <1365859195-8620-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1365859195-8620-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1365859195-8620-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit d9abbf1c changed tree mod log locking around ROOT_REPLACE operations.
When a tree root is split, however, we were logging removal of all elements
from the root node before logging removal of half of the elements for the
split operation. This leads to a BUG_ON when rewinding.

This commit removes the erroneous logging of removal of all elements.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   55 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ca9d8f1..4439cb7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -643,7 +643,8 @@ __tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 static noinline int
 tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *old_root,
-			 struct extent_buffer *new_root, gfp_t flags)
+			 struct extent_buffer *new_root, gfp_t flags,
+			 int log_removal)
 {
 	struct tree_mod_elem *tm;
 	int ret;
@@ -651,7 +652,8 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 	if (tree_mod_dont_log(fs_info, NULL))
 		return 0;
 
-	__tree_mod_log_free_eb(fs_info, old_root);
+	if (log_removal)
+		__tree_mod_log_free_eb(fs_info, old_root);
 
 	ret = tree_mod_alloc(fs_info, flags, &tm);
 	if (ret < 0)
@@ -738,7 +740,7 @@ tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq)
 static noinline void
 tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 		     struct extent_buffer *src, unsigned long dst_offset,
-		     unsigned long src_offset, int nr_items, int log_removal)
+		     unsigned long src_offset, int nr_items)
 {
 	int ret;
 	int i;
@@ -752,12 +754,10 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	}
 
 	for (i = 0; i < nr_items; i++) {
-		if (log_removal) {
-			ret = tree_mod_log_insert_key_locked(fs_info, src,
-							i + src_offset,
-							MOD_LOG_KEY_REMOVE);
-			BUG_ON(ret < 0);
-		}
+		ret = tree_mod_log_insert_key_locked(fs_info, src,
+						i + src_offset,
+						MOD_LOG_KEY_REMOVE);
+		BUG_ON(ret < 0);
 		ret = tree_mod_log_insert_key_locked(fs_info, dst,
 						     i + dst_offset,
 						     MOD_LOG_KEY_ADD);
@@ -802,11 +802,12 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 
 static noinline void
 tree_mod_log_set_root_pointer(struct btrfs_root *root,
-			      struct extent_buffer *new_root_node)
+			      struct extent_buffer *new_root_node,
+			      int log_removal)
 {
 	int ret;
 	ret = tree_mod_log_insert_root(root->fs_info, root->node,
-				       new_root_node, GFP_NOFS);
+				       new_root_node, GFP_NOFS, log_removal);
 	BUG_ON(ret < 0);
 }
 
@@ -1028,7 +1029,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			parent_start = 0;
 
 		extent_buffer_get(cow);
-		tree_mod_log_set_root_pointer(root, cow);
+		tree_mod_log_set_root_pointer(root, cow, 1);
 		rcu_assign_pointer(root->node, cow);
 
 		btrfs_free_tree_block(trans, root, buf, parent_start,
@@ -1754,7 +1755,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			goto enospc;
 		}
 
-		tree_mod_log_set_root_pointer(root, child);
+		tree_mod_log_set_root_pointer(root, child, 1);
 		rcu_assign_pointer(root->node, child);
 
 		add_root_to_dirty_list(root);
@@ -2998,7 +2999,7 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 		push_items = min(src_nritems - 8, push_items);
 
 	tree_mod_log_eb_copy(root->fs_info, dst, src, dst_nritems, 0,
-			     push_items, 1);
+			     push_items);
 	copy_extent_buffer(dst, src,
 			   btrfs_node_key_ptr_offset(dst_nritems),
 			   btrfs_node_key_ptr_offset(0),
@@ -3069,7 +3070,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 				      sizeof(struct btrfs_key_ptr));
 
 	tree_mod_log_eb_copy(root->fs_info, dst, src, 0,
-			     src_nritems - push_items, push_items, 1);
+			     src_nritems - push_items, push_items);
 	copy_extent_buffer(dst, src,
 			   btrfs_node_key_ptr_offset(0),
 			   btrfs_node_key_ptr_offset(src_nritems - push_items),
@@ -3093,7 +3094,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
  */
 static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
-			   struct btrfs_path *path, int level)
+			   struct btrfs_path *path, int level, int log_removal)
 {
 	u64 lower_gen;
 	struct extent_buffer *lower;
@@ -3144,7 +3145,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(c);
 
 	old = root->node;
-	tree_mod_log_set_root_pointer(root, c);
+	tree_mod_log_set_root_pointer(root, c, log_removal);
 	rcu_assign_pointer(root->node, c);
 
 	/* the super has an extra ref to root->node */
@@ -3221,18 +3222,21 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	int mid;
 	int ret;
 	u32 c_nritems;
-	int tree_mod_log_removal = 1;
 
 	c = path->nodes[level];
 	WARN_ON(btrfs_header_generation(c) != trans->transid);
 	if (c == root->node) {
-		/* trying to split the root, lets make a new one */
-		ret = insert_new_root(trans, root, path, level + 1);
 		/*
-		 * removal of root nodes has been logged by
-		 * tree_mod_log_set_root_pointer due to locking
+		 * trying to split the root, lets make a new one
+		 *
+		 * tree mod log: We pass 0 as log_removal parameter to
+		 * insert_new_root, because that root buffer will be kept as a
+		 * normal node. We are going to log removal of half of the
+		 * elements below with tree_mod_log_eb_copy. We're holding a
+		 * tree lock on the buffer, which is why we cannot race with
+		 * other tree_mod_log users.
 		 */
-		tree_mod_log_removal = 0;
+		ret = insert_new_root(trans, root, path, level + 1, 0);
 		if (ret)
 			return ret;
 	} else {
@@ -3270,8 +3274,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
 
-	tree_mod_log_eb_copy(root->fs_info, split, c, 0, mid, c_nritems - mid,
-			     tree_mod_log_removal);
+	tree_mod_log_eb_copy(root->fs_info, split, c, 0, mid, c_nritems - mid);
 	copy_extent_buffer(split, c,
 			   btrfs_node_key_ptr_offset(0),
 			   btrfs_node_key_ptr_offset(mid),
@@ -3953,7 +3956,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	}
 
 	if (!path->nodes[1]) {
-		ret = insert_new_root(trans, root, path, 1);
+		ret = insert_new_root(trans, root, path, 1, 1);
 		if (ret)
 			return ret;
 	}
-- 
1.7.1

