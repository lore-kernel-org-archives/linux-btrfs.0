Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36058 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdAQWlh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:41:37 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so42002461wmr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:41:32 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 05/24] btrfs: Make btrfs_log_new_name take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:31 +0200
Message-Id: <1484692310-3987-6-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/inode.c    |  8 ++++----
 fs/btrfs/tree-log.c | 18 ++++++++----------
 fs/btrfs/tree-log.h |  2 +-
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9442c80fe551..41b1e2ed63b4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6600,7 +6600,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 				goto fail;
 		}
 		d_instantiate(dentry, inode);
-		btrfs_log_new_name(trans, inode, NULL, parent);
+		btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent);
 	}
 
 	btrfs_balance_delayed_items(fs_info);
@@ -9660,13 +9660,13 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 
 	if (root_log_pinned) {
 		parent = new_dentry->d_parent;
-		btrfs_log_new_name(trans, old_inode, old_dir, parent);
+		btrfs_log_new_name(trans, BTRFS_I(old_inode), BTRFS_I(old_dir), parent);
 		btrfs_end_log_trans(root);
 		root_log_pinned = false;
 	}
 	if (dest_log_pinned) {
 		parent = old_dentry->d_parent;
-		btrfs_log_new_name(trans, new_inode, new_dir, parent);
+		btrfs_log_new_name(trans, BTRFS_I(new_inode), BTRFS_I(new_dir), parent);
 		btrfs_end_log_trans(dest);
 		dest_log_pinned = false;
 	}
@@ -9932,7 +9932,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (log_pinned) {
 		struct dentry *parent = new_dentry->d_parent;
 
-		btrfs_log_new_name(trans, old_inode, old_dir, parent);
+		btrfs_log_new_name(trans, BTRFS_I(old_inode), BTRFS_I(old_dir), parent);
 		btrfs_end_log_trans(root);
 		log_pinned = false;
 	}
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 37adad5dabd6..df822908f2be 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5809,30 +5809,28 @@ void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
  * full transaction commit is required.
  */
 int btrfs_log_new_name(struct btrfs_trans_handle *trans,
-			struct inode *inode, struct inode *old_dir,
+			struct btrfs_inode *inode, struct btrfs_inode *old_dir,
 			struct dentry *parent)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root * root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root * root = inode->root;
 
 	/*
 	 * this will force the logging code to walk the dentry chain
 	 * up for the file
 	 */
-	if (S_ISREG(inode->i_mode))
-		BTRFS_I(inode)->last_unlink_trans = trans->transid;
+	if (S_ISREG(inode->vfs_inode.i_mode))
+		inode->last_unlink_trans = trans->transid;
 
 	/*
 	 * if this inode hasn't been logged and directory we're renaming it
 	 * from hasn't been logged, we don't need to log it
 	 */
-	if (BTRFS_I(inode)->logged_trans <=
-	    fs_info->last_trans_committed &&
-	    (!old_dir || BTRFS_I(old_dir)->logged_trans <=
-		    fs_info->last_trans_committed))
+	if (inode->logged_trans <= fs_info->last_trans_committed &&
+	    (!old_dir || old_dir->logged_trans <= fs_info->last_trans_committed))
 		return 0;
 
-	return btrfs_log_inode_parent(trans, root, inode, parent, 0,
+	return btrfs_log_inode_parent(trans, root, &inode->vfs_inode, parent, 0,
 				      LLONG_MAX, 1, NULL);
 }
 
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index e08ce78b2ad4..2bcbac7efa9c 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -85,6 +85,6 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
 				   struct btrfs_inode *dir);
 int btrfs_log_new_name(struct btrfs_trans_handle *trans,
-			struct inode *inode, struct inode *old_dir,
+			struct btrfs_inode *inode, struct btrfs_inode *old_dir,
 			struct dentry *parent);
 #endif
-- 
2.7.4

