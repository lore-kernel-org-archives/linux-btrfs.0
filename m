Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36110 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdALOA7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:00:59 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so3893807wmr.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:00:58 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 02/24] btrfs: Make btrfs_record_unlink_dir take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:28 +0200
Message-Id: <1484229650-24554-3-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/inode.c    |  8 ++++----
 fs/btrfs/tree-log.c | 18 +++++++++---------
 fs/btrfs/tree-log.h |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 80060aa2eda2..c8e73cf9306f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4142,7 +4142,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	btrfs_record_unlink_dir(trans, dir, d_inode(dentry), 0);
+	btrfs_record_unlink_dir(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)), 0);
 
 	ret = btrfs_unlink_inode(trans, root, dir, d_inode(dentry),
 				 dentry->d_name.name, dentry->d_name.len);
@@ -9586,8 +9586,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	new_inode->i_ctime = ctime;
 
 	if (old_dentry->d_parent != new_dentry->d_parent) {
-		btrfs_record_unlink_dir(trans, old_dir, old_inode, 1);
-		btrfs_record_unlink_dir(trans, new_dir, new_inode, 1);
+		btrfs_record_unlink_dir(trans, BTRFS_I(old_dir), BTRFS_I(old_inode), 1);
+		btrfs_record_unlink_dir(trans, BTRFS_I(new_dir), BTRFS_I(new_inode), 1);
 	}
 
 	/* src is a subvolume */
@@ -9866,7 +9866,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_inode->i_ctime = current_time(old_dir);
 
 	if (old_dentry->d_parent != new_dentry->d_parent)
-		btrfs_record_unlink_dir(trans, old_dir, old_inode, 1);
+		btrfs_record_unlink_dir(trans, BTRFS_I(old_dir), BTRFS_I(old_inode), 1);
 
 	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		root_objectid = BTRFS_I(old_inode)->root->root_key.objectid;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f6de921e28b0..0b1e2629ea48 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5723,7 +5723,7 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
  * inodes, etc) are done.
  */
 void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
-			     struct inode *dir, struct inode *inode,
+			     struct btrfs_inode *dir, struct btrfs_inode *inode,
 			     int for_rename)
 {
 	/*
@@ -5736,23 +5736,23 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 	 * into the file.  When the file is logged we check it and
 	 * don't log the parents if the file is fully on disk.
 	 */
-	mutex_lock(&BTRFS_I(inode)->log_mutex);
-	BTRFS_I(inode)->last_unlink_trans = trans->transid;
-	mutex_unlock(&BTRFS_I(inode)->log_mutex);
+	mutex_lock(&inode->log_mutex);
+	inode->last_unlink_trans = trans->transid;
+	mutex_unlock(&inode->log_mutex);
 
 	/*
 	 * if this directory was already logged any new
 	 * names for this file/dir will get recorded
 	 */
 	smp_mb();
-	if (BTRFS_I(dir)->logged_trans == trans->transid)
+	if (dir->logged_trans == trans->transid)
 		return;
 
 	/*
 	 * if the inode we're about to unlink was logged,
 	 * the log will be properly updated for any new names
 	 */
-	if (BTRFS_I(inode)->logged_trans == trans->transid)
+	if (inode->logged_trans == trans->transid)
 		return;
 
 	/*
@@ -5769,9 +5769,9 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 	return;
 
 record:
-	mutex_lock(&BTRFS_I(dir)->log_mutex);
-	BTRFS_I(dir)->last_unlink_trans = trans->transid;
-	mutex_unlock(&BTRFS_I(dir)->log_mutex);
+	mutex_lock(&dir->log_mutex);
+	dir->last_unlink_trans = trans->transid;
+	mutex_unlock(&dir->log_mutex);
 }
 
 /*
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index ab858e31ccbc..69702eef9603 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -80,7 +80,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 void btrfs_end_log_trans(struct btrfs_root *root);
 int btrfs_pin_log_trans(struct btrfs_root *root);
 void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
-			     struct inode *dir, struct inode *inode,
+			     struct btrfs_inode *dir, struct btrfs_inode *inode,
 			     int for_rename);
 void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
 				   struct inode *dir);
-- 
2.7.4

