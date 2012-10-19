Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30914 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab2JSJv4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 05:51:56 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: list.btrfs@jan-o-sch.net
Subject: [PATCH 3/4] Btrfs: kill unnecessary arguments in del_ptr
Date: Fri, 19 Oct 2012 17:50:54 +0800
Message-Id: <1350640255-3760-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1350640255-3760-1-git-send-email-bo.li.liu@oracle.com>
References: <1350640255-3760-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The argument 'tree_mod_log' is not necessary since all of callers enable it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index bbea4fb..235831f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -38,8 +38,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *dst_buf,
 			      struct extent_buffer *src_buf);
 static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		    struct btrfs_path *path, int level, int slot,
-		    int tree_mod_log);
+		    struct btrfs_path *path, int level, int slot);
 static void tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 				 struct extent_buffer *eb);
 struct extent_buffer *read_old_tree_block(struct btrfs_root *root, u64 bytenr,
@@ -1789,7 +1788,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (btrfs_header_nritems(right) == 0) {
 			clean_tree_block(trans, root, right);
 			btrfs_tree_unlock(right);
-			del_ptr(trans, root, path, level + 1, pslot + 1, 1);
+			del_ptr(trans, root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
 			btrfs_free_tree_block(trans, root, right, 0, 1);
 			free_extent_buffer_stale(right);
@@ -1833,7 +1832,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	if (btrfs_header_nritems(mid) == 0) {
 		clean_tree_block(trans, root, mid);
 		btrfs_tree_unlock(mid);
-		del_ptr(trans, root, path, level + 1, pslot, 1);
+		del_ptr(trans, root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
 		btrfs_free_tree_block(trans, root, mid, 0, 1);
 		free_extent_buffer_stale(mid);
@@ -4562,14 +4561,13 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
  * empty a node.
  */
 static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		    struct btrfs_path *path, int level, int slot,
-		    int tree_mod_log)
+		    struct btrfs_path *path, int level, int slot)
 {
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
 	int ret;
 
-	if (tree_mod_log && level) {
+	if (level) {
 		ret = tree_mod_log_insert_key(root->fs_info, parent, slot,
 					      MOD_LOG_KEY_REMOVE);
 		BUG_ON(ret < 0);
@@ -4577,7 +4575,7 @@ static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems - 1) {
-		if (tree_mod_log && level)
+		if (level)
 			tree_mod_log_eb_move(root->fs_info, parent, slot,
 					     slot + 1, nritems - slot - 1);
 		memmove_extent_buffer(parent,
@@ -4618,7 +4616,7 @@ static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
 				    struct extent_buffer *leaf)
 {
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
-	del_ptr(trans, root, path, 1, path->slots[1], 1);
+	del_ptr(trans, root, path, 1, path->slots[1]);
 
 	/*
 	 * btrfs_free_extent is expensive, we want to make sure we
-- 
1.7.7.6

