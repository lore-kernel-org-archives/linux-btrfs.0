Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:46298 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3CTNjM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 09:39:12 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH] Btrfs: fix locking on ROOT_REPLACE operations in tree mod log
Date: Wed, 20 Mar 2013 14:38:49 +0100
Message-Id: <1363786729-19441-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To resolve backrefs, ROOT_REPLACE operations in the tree mod log are
required to be tied to at least one KEY_REMOVE_WHILE_FREEING operation.
Therefore, those operations must be enclosed by tree_mod_log_write_lock()
and tree_mod_log_write_unlock() calls.

Those calls are private to the tree_mod_log_* functions, which means that
removal of the elements of an old root node must be logged from
tree_mod_log_insert_root. This partly reverts and corrects commit ba1bfbd5
(Btrfs: fix a tree mod logging issue for root replacement operations).

This fixes the brand-new version of xfstest 276 as of commit cfe73f71.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
Has probably been Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
(unconfirmed).

 fs/btrfs/ctree.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index aa50952..9dfc74a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -763,6 +763,8 @@ pr_debug("MLL: tree mod seq list %p empty\n", &fs_info->tree_mod_seq_list);
 		return 0;
 }
 
+	__tree_mod_log_free_eb(fs_info, old_root);
+
 	ret = tree_mod_alloc(fs_info, flags, &tm);
 	if (ret < 0)
 		goto out;
@@ -859,7 +861,7 @@ tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq)
 static noinline void
 tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 		     struct extent_buffer *src, unsigned long dst_offset,
-		     unsigned long src_offset, int nr_items)
+		     unsigned long src_offset, int nr_items, int log_removal)
 {
 	int ret;
 	int i;
@@ -873,10 +875,12 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	}
 
 	for (i = 0; i < nr_items; i++) {
-		ret = tree_mod_log_insert_key_locked(fs_info, src,
-						     i + src_offset,
-						     MOD_LOG_KEY_REMOVE);
-		BUG_ON(ret < 0);
+		if (log_removal) {
+			ret = tree_mod_log_insert_key_locked(fs_info, src,
+							i + src_offset,
+							MOD_LOG_KEY_REMOVE);
+			BUG_ON(ret < 0);
+		}
 		ret = tree_mod_log_insert_key_locked(fs_info, dst,
 						     i + dst_offset,
 						     MOD_LOG_KEY_ADD);
@@ -1050,7 +1054,6 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			ret = btrfs_dec_ref(trans, root, buf, 1, 1);
 			BUG_ON(ret); /* -ENOMEM */
 		}
-		tree_mod_log_free_eb(root->fs_info, buf);
 		clean_tree_block(trans, root, buf);
 		*last_ref = 1;
 	}
@@ -1171,6 +1174,7 @@ DONE_mod_log("setting a new root: %llu -> %llu\n", root->node->start, cow->start
 		btrfs_set_node_ptr_generation(parent, parent_slot,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
+		tree_mod_log_free_eb(root->fs_info, buf);
 		btrfs_free_tree_block(trans, root, buf, parent_start,
 				      last_ref);
 	}
@@ -1901,7 +1905,6 @@ DONE_mod_log("promoting %llu as replacement root for almost empty %llu, tree dep
 		}
 DONE_mod_log("new root is %llu\n", child->start);
 
-		tree_mod_log_free_eb(root->fs_info, root->node);
 		tree_mod_log_set_root_pointer(root, child);
 		rcu_assign_pointer(root->node, child);
 
@@ -3210,7 +3213,7 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 		push_items = min(src_nritems - 8, push_items);
 
 	tree_mod_log_eb_copy(root->fs_info, dst, src, dst_nritems, 0,
-			     push_items);
+			     push_items, 1);
 	copy_extent_buffer(dst, src,
 			   btrfs_node_key_ptr_offset(dst_nritems),
 			   btrfs_node_key_ptr_offset(0),
@@ -3283,7 +3286,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 DONE_mod_log("pushing %d items from %llu (now has %d) to %llu (now has %d)\n", push_items, src->start, src_nritems - push_items, dst->start, dst_nritems + push_items);
 
 	tree_mod_log_eb_copy(root->fs_info, dst, src, 0,
-			     src_nritems - push_items, push_items);
+			     src_nritems - push_items, push_items, 1);
 	copy_extent_buffer(dst, src,
 			   btrfs_node_key_ptr_offset(0),
 			   btrfs_node_key_ptr_offset(src_nritems - push_items),
@@ -3436,6 +3439,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	int mid;
 	int ret;
 	u32 c_nritems;
+	int tree_mod_log_removal = 1;
 
 	c = path->nodes[level];
 DONE_mod_log("%llu\n", c->start);
@@ -3443,6 +3447,11 @@ DONE_mod_log("%llu\n", c->start);
 	if (c == root->node) {
 		/* trying to split the root, lets make a new one */
 		ret = insert_new_root(trans, root, path, level + 1);
+		/*
+		 * removal of root nodes has been logged by
+		 * tree_mod_log_set_root_pointer due to locking
+		 */
+		tree_mod_log_removal = 0;
 		if (ret)
 			return ret;
 	} else {
@@ -3481,7 +3490,8 @@ DONE_mod_log("buffer %llu, middle key (%llu %u %llu), split buffer %llu. nritems
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
 
-	tree_mod_log_eb_copy(root->fs_info, split, c, 0, mid, c_nritems - mid);
+	tree_mod_log_eb_copy(root->fs_info, split, c, 0, mid, c_nritems - mid,
+			     tree_mod_log_removal);
 	copy_extent_buffer(split, c,
 			   btrfs_node_key_ptr_offset(0),
 			   btrfs_node_key_ptr_offset(mid),
-- 
1.7.1

