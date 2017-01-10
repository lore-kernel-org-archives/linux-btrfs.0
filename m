Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:36044 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdAJSgH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:36:07 -0500
Received: by mail-wj0-f196.google.com with SMTP id dh1so8083600wjb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:36:06 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 08/12] btrfs: Make btrfs_kill_delayed_inode_items take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:38 +0200
Message-Id: <1484073342-28854-9-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 4 ++--
 fs/btrfs/delayed-inode.h | 2 +-
 fs/btrfs/inode.c         | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 3adf47427451..73a588d0f957 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1931,11 +1931,11 @@ static void __btrfs_kill_delayed_node(struct btrfs_delayed_node *delayed_node)
 	mutex_unlock(&delayed_node->mutex);
 }
 
-void btrfs_kill_delayed_inode_items(struct inode *inode)
+void btrfs_kill_delayed_inode_items(struct btrfs_inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
 
-	delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
+	delayed_node = btrfs_get_delayed_node(inode);
 	if (!delayed_node)
 		return;
 
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index dbb02f4d5dda..fbada25cd17e 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -122,7 +122,7 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 				     struct inode *inode);
 /* Used for evicting the inode. */
 void btrfs_remove_delayed_node(struct inode *inode);
-void btrfs_kill_delayed_inode_items(struct inode *inode);
+void btrfs_kill_delayed_inode_items(struct btrfs_inode *inode);
 int btrfs_commit_inode_delayed_inode(struct inode *inode);
 
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8e259c3ae4dd..1a72ee1e4994 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4440,7 +4440,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	 * items.
 	 */
 	if (min_type == 0 && root == BTRFS_I(inode)->root)
-		btrfs_kill_delayed_inode_items(inode);
+		btrfs_kill_delayed_inode_items(BTRFS_I(inode));
 
 	key.objectid = ino;
 	key.offset = (u64)-1;
-- 
2.7.4

