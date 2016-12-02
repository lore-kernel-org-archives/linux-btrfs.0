Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752563AbcLBFHu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:50 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 52674AC14
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:49 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 14/18] btrfs: root->fs_info cleanup, access fs_info->delayed_root directly
Date: Fri,  2 Dec 2016 00:07:34 -0500
Message-Id: <1480655258-15400-15-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This results in btrfs_assert_delayed_root_empty and
btrfs_destroy_delayed_inode taking an fs_info instead of a root.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/delayed-inode.c | 23 ++++++-----------------
 fs/btrfs/delayed-inode.h |  4 ++--
 fs/btrfs/disk-io.c       |  8 ++++----
 fs/btrfs/transaction.c   |  2 +-
 4 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index d7d5eb9..c8ffceb 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -72,12 +72,6 @@ static inline int btrfs_is_continuous_delayed_item(
 	return 0;
 }
 
-static inline struct btrfs_delayed_root *btrfs_get_delayed_root(
-							struct btrfs_root *root)
-{
-	return root->fs_info->delayed_root;
-}
-
 static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
 {
 	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
@@ -1163,7 +1157,7 @@ static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 	block_rsv = trans->block_rsv;
 	trans->block_rsv = &fs_info->delayed_block_rsv;
 
-	delayed_root = btrfs_get_delayed_root(root);
+	delayed_root = fs_info->delayed_root;
 
 	curr_node = btrfs_first_delayed_node(delayed_root);
 	while (curr_node && (!count || (count && nr--))) {
@@ -1390,11 +1384,9 @@ static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
 	return 0;
 }
 
-void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
+void btrfs_assert_delayed_root_empty(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_delayed_root *delayed_root;
-	delayed_root = btrfs_get_delayed_root(root);
-	WARN_ON(btrfs_first_delayed_node(delayed_root));
+	WARN_ON(btrfs_first_delayed_node(fs_info->delayed_root));
 }
 
 static int could_end_wait(struct btrfs_delayed_root *delayed_root, int seq)
@@ -1415,7 +1407,7 @@ void btrfs_balance_delayed_items(struct btrfs_root *root)
 	struct btrfs_delayed_root *delayed_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	delayed_root = btrfs_get_delayed_root(root);
+	delayed_root = fs_info->delayed_root;
 
 	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
 		return;
@@ -1980,14 +1972,11 @@ void btrfs_kill_all_delayed_nodes(struct btrfs_root *root)
 	}
 }
 
-void btrfs_destroy_delayed_inodes(struct btrfs_root *root)
+void btrfs_destroy_delayed_inodes(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_delayed_root *delayed_root;
 	struct btrfs_delayed_node *curr_node, *prev_node;
 
-	delayed_root = btrfs_get_delayed_root(root);
-
-	curr_node = btrfs_first_delayed_node(delayed_root);
+	curr_node = btrfs_first_delayed_node(fs_info->delayed_root);
 	while (curr_node) {
 		__btrfs_kill_delayed_node(curr_node);
 
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 2c1cbe2..7320d72 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -134,7 +134,7 @@ int btrfs_delayed_delete_inode_ref(struct inode *inode);
 void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
 
 /* Used for clean the transaction */
-void btrfs_destroy_delayed_inodes(struct btrfs_root *root);
+void btrfs_destroy_delayed_inodes(struct btrfs_fs_info *fs_info);
 
 /* Used for readdir() */
 bool btrfs_readdir_get_delayed_items(struct inode *inode,
@@ -153,6 +153,6 @@ int __init btrfs_delayed_inode_init(void);
 void btrfs_delayed_inode_exit(void);
 
 /* for debugging */
-void btrfs_assert_delayed_root_empty(struct btrfs_root *root);
+void btrfs_assert_delayed_root_empty(struct btrfs_fs_info *fs_info);
 
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 02ba794..5f7d283 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4587,8 +4587,8 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	cur_trans->state = TRANS_STATE_UNBLOCKED;
 	wake_up(&fs_info->transaction_wait);
 
-	btrfs_destroy_delayed_inodes(root);
-	btrfs_assert_delayed_root_empty(root);
+	btrfs_destroy_delayed_inodes(fs_info);
+	btrfs_assert_delayed_root_empty(fs_info);
 
 	btrfs_destroy_marked_extents(root, &cur_trans->dirty_pages,
 				     EXTENT_DIRTY);
@@ -4649,8 +4649,8 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 	}
 	spin_unlock(&fs_info->trans_lock);
 	btrfs_destroy_all_ordered_extents(fs_info);
-	btrfs_destroy_delayed_inodes(root);
-	btrfs_assert_delayed_root_empty(root);
+	btrfs_destroy_delayed_inodes(fs_info);
+	btrfs_assert_delayed_root_empty(fs_info);
 	btrfs_destroy_pinned_extent(root, fs_info->pinned_extents);
 	btrfs_destroy_all_delalloc_inodes(fs_info);
 	mutex_unlock(&fs_info->transaction_kthread_mutex);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7fa8a6a..56eeecf 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2133,7 +2133,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 * make sure none of the code above managed to slip in a
 	 * delayed item
 	 */
-	btrfs_assert_delayed_root_empty(root);
+	btrfs_assert_delayed_root_empty(fs_info);
 
 	WARN_ON(cur_trans != trans->transaction);
 
-- 
2.7.1

