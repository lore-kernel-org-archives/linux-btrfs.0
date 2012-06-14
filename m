Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:44051 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab2FNRQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 13:16:39 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] Btrfs: fix return value for __tree_mod_log_oldest_root
Date: Thu, 14 Jun 2012 19:16:36 +0200
Message-Id: <1339694198-13388-5-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In __tree_mod_log_oldest_root() we must return the found operation even if
it's not a ROOT_REPLACE operation. Otherwise, the caller assumes that there
are no operations to be rewinded and returns immediately.

The code in the caller is modified to improve readability.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   33 ++++++++++++++++++++-------------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2cde7b0..50d7c99 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1023,6 +1023,10 @@ __tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
 		looped = 1;
 	}
 
+	/* if there's no old root to return, return what we found instead */
+	if (!found)
+		found = tm;
+
 	return found;
 }
 
@@ -1155,18 +1159,24 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 {
 	struct tree_mod_elem *tm;
 	struct extent_buffer *eb;
-	struct tree_mod_root *old_root;
+	struct tree_mod_root *old_root = NULL;
 	u64 old_generation;
+	u64 logical;
 
 	eb = btrfs_read_lock_root_node(root);
 	tm = __tree_mod_log_oldest_root(root->fs_info, root, time_seq);
 	if (!tm)
 		return root->node;
 
-	old_root = &tm->old_root;
-	old_generation = tm->generation;
+	if (tm->op == MOD_LOG_ROOT_REPLACE) {
+		old_root = &tm->old_root;
+		old_generation = tm->generation;
+		logical = old_root->logical;
+	} else {
+		logical = root->node->start;
+	}
 
-	tm = tree_mod_log_search(root->fs_info, old_root->logical, time_seq);
+	tm = tree_mod_log_search(root->fs_info, logical, time_seq);
 	/*
 	 * there was an item in the log when __tree_mod_log_oldest_root
 	 * returned. this one must not go away, because the time_seq passed to
@@ -1174,26 +1184,23 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	 */
 	BUG_ON(!tm);
 
-	if (old_root->logical == root->node->start) {
-		/* there are logged operations for the current root */
-		eb = btrfs_clone_extent_buffer(root->node);
-	} else {
-		/* there's a root replace operation for the current root */
+	if (old_root)
 		eb = alloc_dummy_extent_buffer(tm->index << PAGE_CACHE_SHIFT,
 					       root->nodesize);
-	}
+	else
+		eb = btrfs_clone_extent_buffer(root->node);
 	btrfs_tree_read_unlock(root->node);
 	free_extent_buffer(root->node);
 	if (!eb)
 		return NULL;
 	btrfs_tree_read_lock(eb);
-	if (old_root->logical != root->node->start) {
+	if (old_root) {
 		btrfs_set_header_bytenr(eb, eb->start);
 		btrfs_set_header_backref_rev(eb, BTRFS_MIXED_BACKREF_REV);
 		btrfs_set_header_owner(eb, root->root_key.objectid);
+		btrfs_set_header_level(eb, old_root->level);
+		btrfs_set_header_generation(eb, old_generation);
 	}
-	btrfs_set_header_level(eb, old_root->level);
-	btrfs_set_header_generation(eb, old_generation);
 	__tree_mod_log_rewind(eb, time_seq, tm);
 	extent_buffer_get(eb);
 
-- 
1.7.3.4

