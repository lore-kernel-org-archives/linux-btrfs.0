Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:44053 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab2FNRQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 13:16:39 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] Btrfs: fix race in tree mod log addition
Date: Thu, 14 Jun 2012 19:16:38 +0200
Message-Id: <1339694198-13388-7-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When adding to the tree modification log, we grab two locks at different
stages. We must not drop the outer lock until we're done with section
protected by the inner lock. This moves the unlock call for the outer lock
to the appropriate position.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cb76b2a..04b06bc 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -467,6 +467,15 @@ static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+/*
+ * This allocates memory and gets a tree modification sequence number when
+ * needed.
+ *
+ * Returns 0 when no sequence number is needed, < 0 on error.
+ * Returns 1 when a sequence number was added. In this case,
+ * fs_info->tree_mod_seq_lock was acquired and must be released by the caller
+ * after inserting into the rb tree.
+ */
 static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
 				 struct tree_mod_elem **tm_ret)
 {
@@ -491,11 +500,11 @@ static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
 		 */
 		kfree(tm);
 		seq = 0;
+		spin_unlock(&fs_info->tree_mod_seq_lock);
 	} else {
 		__get_tree_mod_seq(fs_info, &tm->elem);
 		seq = tm->elem.seq;
 	}
-	spin_unlock(&fs_info->tree_mod_seq_lock);
 
 	return seq;
 }
@@ -521,7 +530,9 @@ tree_mod_log_insert_key_mask(struct btrfs_fs_info *fs_info,
 	tm->slot = slot;
 	tm->generation = btrfs_node_ptr_generation(eb, slot);
 
-	return __tree_mod_log_insert(fs_info, tm);
+	ret = __tree_mod_log_insert(fs_info, tm);
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+	return ret;
 }
 
 static noinline int
@@ -559,7 +570,9 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	tm->move.nr_items = nr_items;
 	tm->op = MOD_LOG_MOVE_KEYS;
 
-	return __tree_mod_log_insert(fs_info, tm);
+	ret = __tree_mod_log_insert(fs_info, tm);
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+	return ret;
 }
 
 static noinline int
@@ -580,7 +593,9 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 	tm->generation = btrfs_header_generation(old_root);
 	tm->op = MOD_LOG_ROOT_REPLACE;
 
-	return __tree_mod_log_insert(fs_info, tm);
+	ret = __tree_mod_log_insert(fs_info, tm);
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+	return ret;
 }
 
 static struct tree_mod_elem *
-- 
1.7.3.4

