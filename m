Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34212 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdAJSgB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:36:01 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so31527511wmi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:36:00 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 07/12] btrfs: Make btrfs_delayed_delete_inode_ref take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:37 +0200
Message-Id: <1484073342-28854-8-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 6 +++---
 fs/btrfs/delayed-inode.h | 2 +-
 fs/btrfs/inode.c         | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index c7b40613e31c..3adf47427451 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1854,9 +1854,9 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_delayed_delete_inode_ref(struct inode *inode)
+int btrfs_delayed_delete_inode_ref(struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	struct btrfs_delayed_node *delayed_node;
 
 	/*
@@ -1867,7 +1867,7 @@ int btrfs_delayed_delete_inode_ref(struct inode *inode)
 	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
 		return -EAGAIN;
 
-	delayed_node = btrfs_get_or_create_delayed_node(BTRFS_I(inode));
+	delayed_node = btrfs_get_or_create_delayed_node(inode);
 	if (IS_ERR(delayed_node))
 		return PTR_ERR(delayed_node);
 
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index adf6a8a0b23a..dbb02f4d5dda 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -129,7 +129,7 @@ int btrfs_commit_inode_delayed_inode(struct inode *inode);
 int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, struct inode *inode);
 int btrfs_fill_inode(struct inode *inode, u32 *rdev);
-int btrfs_delayed_delete_inode_ref(struct inode *inode);
+int btrfs_delayed_delete_inode_ref(struct btrfs_inode *inode);
 
 /* Used for drop dead root */
 void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d5ca388ae710..8e259c3ae4dd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4044,7 +4044,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	 * we update the inode item.
 	 */
 	if (BTRFS_I(inode)->dir_index) {
-		ret = btrfs_delayed_delete_inode_ref(inode);
+		ret = btrfs_delayed_delete_inode_ref(BTRFS_I(inode));
 		if (!ret) {
 			index = BTRFS_I(inode)->dir_index;
 			goto skip_backref;
-- 
2.7.4

