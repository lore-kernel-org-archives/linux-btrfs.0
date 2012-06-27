Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:24271 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339Ab2F0RZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:25:01 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 3/7] Btrfs: fix tree mod log for root replacements at leaf level
Date: Wed, 27 Jun 2012 19:24:55 +0200
Message-Id: <1340817899-16343-4-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the tree mod log, we don't log any operations at leaf level. If the root
is at the leaf level (i.e. the tree consists only of the root), then
__tree_mod_log_oldest_root will find a ROOT_REPLACE operation in the log
(because we always log that one no matter which level), but no other
operations.

With this patch __tree_mod_log_oldest_root exits cleanly instead of
BUGging in this situation. get_old_root checks if its really a root at leaf
level in case we don't have any operations and WARNs if this assumption
breaks.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 15cbc2b..7d1e4fc 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1024,11 +1024,18 @@ __tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
 		if (!looped && !tm)
 			return 0;
 		/*
-		 * we must have key remove operations in the log before the
-		 * replace operation.
+		 * if there are no tree operation for the oldest root, we simply
+		 * return it. this should only happen if that (old) root is at
+		 * level 0.
 		 */
-		BUG_ON(!tm);
+		if (!tm)
+			break;
 
+		/*
+		 * if there's an operation that's not a root replacement, we
+		 * found the oldest version of our root. normally, we'll find a
+		 * MOD_LOG_KEY_REMOVE_WHILE_FREEING operation here.
+		 */
 		if (tm->op != MOD_LOG_ROOT_REPLACE)
 			break;
 
@@ -1192,16 +1199,8 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	}
 
 	tm = tree_mod_log_search(root->fs_info, logical, time_seq);
-	/*
-	 * there was an item in the log when __tree_mod_log_oldest_root
-	 * returned. this one must not go away, because the time_seq passed to
-	 * us must be blocking its removal.
-	 */
-	BUG_ON(!tm);
-
 	if (old_root)
-		eb = alloc_dummy_extent_buffer(tm->index << PAGE_CACHE_SHIFT,
-					       root->nodesize);
+		eb = alloc_dummy_extent_buffer(logical, root->nodesize);
 	else
 		eb = btrfs_clone_extent_buffer(root->node);
 	btrfs_tree_read_unlock(root->node);
@@ -1216,7 +1215,10 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		btrfs_set_header_level(eb, old_root->level);
 		btrfs_set_header_generation(eb, old_generation);
 	}
-	__tree_mod_log_rewind(eb, time_seq, tm);
+	if (tm)
+		__tree_mod_log_rewind(eb, time_seq, tm);
+	else
+		WARN_ON(btrfs_header_level(eb) != 0);
 	extent_buffer_get(eb);
 
 	return eb;
-- 
1.7.3.4

