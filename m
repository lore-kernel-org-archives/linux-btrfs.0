Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34004 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdALOBD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:03 -0500
Received: by mail-wm0-f68.google.com with SMTP id c85so3881065wmi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:02 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 04/24] btrfs: Make btrfs_inode_in_log take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:30 +0200
Message-Id: <1484229650-24554-5-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
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
index c8e73cf9306f..c2835d0b7098 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9676,11 +9676,11 @@ static int btrfs_rename_exchange(struct inode *old_dir,
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
@@ -9952,11 +9952,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
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
index db787d957b74..806e0ffc9150 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5230,7 +5230,7 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 				goto next_dir_inode;
 			}
 
-			if (btrfs_inode_in_log(di_inode, trans->transid)) {
+			if (btrfs_inode_in_log(BTRFS_I(di_inode), trans->transid)) {
 				iput(di_inode);
 				break;
 			}
@@ -5429,7 +5429,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto end_no_trans;
 
-	if (btrfs_inode_in_log(inode, trans->transid)) {
+	if (btrfs_inode_in_log(BTRFS_I(inode), trans->transid)) {
 		ret = BTRFS_NO_LOG_SYNC;
 		goto end_no_trans;
 	}
-- 
2.7.4

