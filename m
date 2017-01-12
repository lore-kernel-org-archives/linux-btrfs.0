Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34025 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750887AbdALOBD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:03 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so3881230wmi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:03 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 07/24] btrfs: Make btrfs_del_inode_ref take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:33 +0200
Message-Id: <1484229650-24554-8-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/inode.c    |  2 +-
 fs/btrfs/tree-log.c | 10 +++++-----
 fs/btrfs/tree-log.h |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7d441931fc1e..9693f83cfc4b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4068,7 +4068,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_del_inode_ref_in_log(trans, root, name, name_len,
-					 inode, dir_ino);
+					 BTRFS_I(inode), dir_ino);
 	if (ret != 0 && ret != -ENOENT) {
 		btrfs_abort_transaction(trans, ret);
 		goto err;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 904f12b5ec72..ffe9aad04be5 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3191,25 +3191,25 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       const char *name, int name_len,
-			       struct inode *inode, u64 dirid)
+			       struct btrfs_inode *inode, u64 dirid)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *log;
 	u64 index;
 	int ret;
 
-	if (BTRFS_I(inode)->logged_trans < trans->transid)
+	if (inode->logged_trans < trans->transid)
 		return 0;
 
 	ret = join_running_log_trans(root);
 	if (ret)
 		return 0;
 	log = root->log_root;
-	mutex_lock(&BTRFS_I(inode)->log_mutex);
+	mutex_lock(&inode->log_mutex);
 
-	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(BTRFS_I(inode)),
+	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(inode),
 				  dirid, &index);
-	mutex_unlock(&BTRFS_I(inode)->log_mutex);
+	mutex_unlock(&inode->log_mutex);
 	if (ret == -ENOSPC) {
 		btrfs_set_log_full_commit(fs_info, trans);
 		ret = 0;
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 6c2b316b28e0..bc50f128c6be 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -76,7 +76,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       const char *name, int name_len,
-			       struct inode *inode, u64 dirid);
+			       struct btrfs_inode *inode, u64 dirid);
 void btrfs_end_log_trans(struct btrfs_root *root);
 int btrfs_pin_log_trans(struct btrfs_root *root);
 void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
-- 
2.7.4

