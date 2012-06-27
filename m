Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:12976 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757755Ab2F0RZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:25:01 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] Btrfs: always put insert_ptr modifications into the tree mod log
Date: Wed, 27 Jun 2012 19:24:56 +0200
Message-Id: <1340817899-16343-5-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several callers of insert_ptr set the tree_mod_log parameter to 0 to avoid
addition to the tree mod log. In fact, we need all of those operations. This
commit simply removes the additional parameter and makes addition to the
tree mod log unconditional.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7d1e4fc..e005d9b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2997,7 +2997,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 static void insert_ptr(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct btrfs_path *path,
 		       struct btrfs_disk_key *key, u64 bytenr,
-		       int slot, int level, int tree_mod_log)
+		       int slot, int level)
 {
 	struct extent_buffer *lower;
 	int nritems;
@@ -3010,7 +3010,7 @@ static void insert_ptr(struct btrfs_trans_handle *trans,
 	BUG_ON(slot > nritems);
 	BUG_ON(nritems == BTRFS_NODEPTRS_PER_BLOCK(root));
 	if (slot != nritems) {
-		if (tree_mod_log && level)
+		if (level)
 			tree_mod_log_eb_move(root->fs_info, lower, slot + 1,
 					     slot, nritems - slot);
 		memmove_extent_buffer(lower,
@@ -3018,7 +3018,7 @@ static void insert_ptr(struct btrfs_trans_handle *trans,
 			      btrfs_node_key_ptr_offset(slot),
 			      (nritems - slot) * sizeof(struct btrfs_key_ptr));
 	}
-	if (tree_mod_log && level) {
+	if (level) {
 		ret = tree_mod_log_insert_key(root->fs_info, lower, slot,
 					      MOD_LOG_KEY_ADD);
 		BUG_ON(ret < 0);
@@ -3106,7 +3106,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(split);
 
 	insert_ptr(trans, root, path, &disk_key, split->start,
-		   path->slots[level + 1] + 1, level + 1, 1);
+		   path->slots[level + 1] + 1, level + 1);
 
 	if (path->slots[level] >= mid) {
 		path->slots[level] -= mid;
@@ -3643,7 +3643,7 @@ static noinline void copy_for_split(struct btrfs_trans_handle *trans,
 	btrfs_set_header_nritems(l, mid);
 	btrfs_item_key(right, &disk_key, 0);
 	insert_ptr(trans, root, path, &disk_key, right->start,
-		   path->slots[1] + 1, 1, 0);
+		   path->slots[1] + 1, 1);
 
 	btrfs_mark_buffer_dirty(right);
 	btrfs_mark_buffer_dirty(l);
@@ -3850,7 +3850,7 @@ again:
 		if (mid <= slot) {
 			btrfs_set_header_nritems(right, 0);
 			insert_ptr(trans, root, path, &disk_key, right->start,
-				   path->slots[1] + 1, 1, 0);
+				   path->slots[1] + 1, 1);
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
@@ -3859,7 +3859,7 @@ again:
 		} else {
 			btrfs_set_header_nritems(right, 0);
 			insert_ptr(trans, root, path, &disk_key, right->start,
-					  path->slots[1], 1, 0);
+					  path->slots[1], 1);
 			btrfs_tree_unlock(path->nodes[0]);
 			free_extent_buffer(path->nodes[0]);
 			path->nodes[0] = right;
-- 
1.7.3.4

