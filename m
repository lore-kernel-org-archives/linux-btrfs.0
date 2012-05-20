Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:33909 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab2ETQGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:37 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 11/24] Btrfs: fs_info variable for join_transaction
Date: Sun, 20 May 2012 18:06:22 +0200
Message-Id: <c50fa22945b3d8c49b96f781e2dead096fbc48da.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/transaction.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3642225..eb2bd82 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -55,48 +55,49 @@ static noinline void switch_commit_root(struct btrfs_root *root)
 static noinline int join_transaction(struct btrfs_root *root, int nofail)
 {
 	struct btrfs_transaction *cur_trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	spin_lock(&root->fs_info->trans_lock);
+	spin_lock(&fs_info->trans_lock);
 loop:
 	/* The file system has been taken offline. No new transactions. */
-	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
-		spin_unlock(&root->fs_info->trans_lock);
+	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		spin_unlock(&fs_info->trans_lock);
 		return -EROFS;
 	}
 
-	if (root->fs_info->trans_no_join) {
+	if (fs_info->trans_no_join) {
 		if (!nofail) {
-			spin_unlock(&root->fs_info->trans_lock);
+			spin_unlock(&fs_info->trans_lock);
 			return -EBUSY;
 		}
 	}
 
-	cur_trans = root->fs_info->running_transaction;
+	cur_trans = fs_info->running_transaction;
 	if (cur_trans) {
 		if (cur_trans->aborted) {
-			spin_unlock(&root->fs_info->trans_lock);
+			spin_unlock(&fs_info->trans_lock);
 			return cur_trans->aborted;
 		}
 		atomic_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		cur_trans->num_joined++;
-		spin_unlock(&root->fs_info->trans_lock);
+		spin_unlock(&fs_info->trans_lock);
 		return 0;
 	}
-	spin_unlock(&root->fs_info->trans_lock);
+	spin_unlock(&fs_info->trans_lock);
 
 	cur_trans = kmem_cache_alloc(btrfs_transaction_cachep, GFP_NOFS);
 	if (!cur_trans)
 		return -ENOMEM;
 
-	spin_lock(&root->fs_info->trans_lock);
-	if (root->fs_info->running_transaction) {
+	spin_lock(&fs_info->trans_lock);
+	if (fs_info->running_transaction) {
 		/*
 		 * someone started a transaction after we unlocked.  Make sure
 		 * to redo the trans_no_join checks above
 		 */
 		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
-		cur_trans = root->fs_info->running_transaction;
+		cur_trans = fs_info->running_transaction;
 		goto loop;
 	}
 
@@ -127,14 +128,14 @@ loop:
 	INIT_LIST_HEAD(&cur_trans->delayed_refs.seq_head);
 
 	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
-	list_add_tail(&cur_trans->list, &root->fs_info->trans_list);
+	list_add_tail(&cur_trans->list, &fs_info->trans_list);
 	extent_io_tree_init(&cur_trans->dirty_pages,
-			     root->fs_info->btree_inode->i_mapping);
-	root->fs_info->generation++;
-	cur_trans->transid = root->fs_info->generation;
-	root->fs_info->running_transaction = cur_trans;
+			     fs_info->btree_inode->i_mapping);
+	fs_info->generation++;
+	cur_trans->transid = fs_info->generation;
+	fs_info->running_transaction = cur_trans;
 	cur_trans->aborted = 0;
-	spin_unlock(&root->fs_info->trans_lock);
+	spin_unlock(&fs_info->trans_lock);
 
 	return 0;
 }
-- 
1.7.3.4

