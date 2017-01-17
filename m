Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35990 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdAQWlk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:41:40 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so42001712wmr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:41:35 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 04/24] btrfs: Make btrfs_inode_in_log take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:30 +0200
Message-Id: <1484692310-3987-5-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/btrfs_inode.h | 16 +++++++---------
 fs/btrfs/file.c        |  2 +-
 fs/btrfs/inode.c       | 16 ++++++++--------
 fs/btrfs/tree-log.c    |  4 ++--
 4 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 4fed080545c6..b2dde0efebc0 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -255,16 +255,14 @@ static inline bool btrfs_is_free_space_inode(struct inode *inode)
 	return false;
 }
 
-static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
+static inline int btrfs_inode_in_log(struct btrfs_inode *inode, u64 generation)
 {
 	int ret = 0;
 
-	spin_lock(&BTRFS_I(inode)->lock);
-	if (BTRFS_I(inode)->logged_trans == generation &&
-	    BTRFS_I(inode)->last_sub_trans <=
-	    BTRFS_I(inode)->last_log_commit &&
-	    BTRFS_I(inode)->last_sub_trans <=
-	    BTRFS_I(inode)->root->last_log_commit) {
+	spin_lock(&inode->lock);
+	if (inode->logged_trans == generation &&
+	    inode->last_sub_trans <= inode->last_log_commit &&
+	    inode->last_sub_trans <= inode->root->last_log_commit) {
 		/*
 		 * After a ranged fsync we might have left some extent maps
 		 * (that fall outside the fsync's range). So return false
@@ -272,10 +270,10 @@ static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
 		 * will be called and process those extent maps.
 		 */
 		smp_mb();
-		if (list_empty(&BTRFS_I(inode)->extent_tree.modified_extents))
+		if (list_empty(&inode->extent_tree.modified_extents))
 			ret = 1;
 	}
-	spin_unlock(&BTRFS_I(inode)->lock);
+	spin_unlock(&inode->lock);
 	return ret;
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0d32f45cef28..149b79b3aaf8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2062,7 +2062,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * commit does not start nor waits for ordered extents to complete.
 	 */
 	smp_mb();
-	if (btrfs_inode_in_log(inode, fs_info->generation) ||
+	if (btrfs_inode_in_log(BTRFS_I(inode), fs_info->generation) ||
 	    (full_sync && BTRFS_I(inode)->last_trans <=
 	     fs_info->last_trans_committed) ||
 	    (!btrfs_have_ordered_extents_in_range(inode, start, len) &&
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a8374f1d8c61..9442c80fe551 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9683,11 +9683,11 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	 * allow the tasks to sync it.
 	 */
 	if (ret && (root_log_pinned || dest_log_pinned)) {
-		if (btrfs_inode_in_log(old_dir, fs_info->generation) ||
-		    btrfs_inode_in_log(new_dir, fs_info->generation) ||
-		    btrfs_inode_in_log(old_inode, fs_info->generation) ||
+		if (btrfs_inode_in_log(BTRFS_I(old_dir), fs_info->generation) ||
+		    btrfs_inode_in_log(BTRFS_I(new_dir), fs_info->generation) ||
+		    btrfs_inode_in_log(BTRFS_I(old_inode), fs_info->generation) ||
 		    (new_inode &&
-		     btrfs_inode_in_log(new_inode, fs_info->generation)))
+		     btrfs_inode_in_log(BTRFS_I(new_inode), fs_info->generation)))
 			btrfs_set_log_full_commit(fs_info, trans);
 
 		if (root_log_pinned) {
@@ -9959,11 +9959,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * allow the tasks to sync it.
 	 */
 	if (ret && log_pinned) {
-		if (btrfs_inode_in_log(old_dir, fs_info->generation) ||
-		    btrfs_inode_in_log(new_dir, fs_info->generation) ||
-		    btrfs_inode_in_log(old_inode, fs_info->generation) ||
+		if (btrfs_inode_in_log(BTRFS_I(old_dir), fs_info->generation) ||
+		    btrfs_inode_in_log(BTRFS_I(new_dir), fs_info->generation) ||
+		    btrfs_inode_in_log(BTRFS_I(old_inode), fs_info->generation) ||
 		    (new_inode &&
-		     btrfs_inode_in_log(new_inode, fs_info->generation)))
+		     btrfs_inode_in_log(BTRFS_I(new_inode), fs_info->generation)))
 			btrfs_set_log_full_commit(fs_info, trans);
 
 		btrfs_end_log_trans(root);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 581d31171683..37adad5dabd6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5237,7 +5237,7 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 				goto next_dir_inode;
 			}
 
-			if (btrfs_inode_in_log(di_inode, trans->transid)) {
+			if (btrfs_inode_in_log(BTRFS_I(di_inode), trans->transid)) {
 				iput(di_inode);
 				break;
 			}
@@ -5436,7 +5436,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto end_no_trans;
 
-	if (btrfs_inode_in_log(inode, trans->transid)) {
+	if (btrfs_inode_in_log(BTRFS_I(inode), trans->transid)) {
 		ret = BTRFS_NO_LOG_SYNC;
 		goto end_no_trans;
 	}
-- 
2.7.4

