Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34455 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939166AbdAJSgF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:36:05 -0500
Received: by mail-wj0-f195.google.com with SMTP id qs7so50818626wjc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:36:04 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 11/12] btrfs: Make btrfs_commit_inode_delayed_items take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:41 +0200
Message-Id: <1484073342-28854-12-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 4 ++--
 fs/btrfs/delayed-inode.h | 2 +-
 fs/btrfs/tree-log.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 17af7b186916..0afbea220fbb 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1194,9 +1194,9 @@ int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
-				     struct inode *inode)
+				     struct btrfs_inode *inode)
 {
-	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
+	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *block_rsv;
 	int ret;
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index cd80fe8f150f..40bf1a943146 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -119,7 +119,7 @@ int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans,
 void btrfs_balance_delayed_items(struct btrfs_fs_info *fs_info);
 
 int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
-				     struct inode *inode);
+				     struct btrfs_inode *inode);
 /* Used for evicting the inode. */
 void btrfs_remove_delayed_node(struct btrfs_inode *inode);
 void btrfs_kill_delayed_inode_items(struct btrfs_inode *inode);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 69ab3d19ea1e..4e6f081512ab 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4655,7 +4655,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	 */
 	if (S_ISDIR(inode->i_mode) ||
 	    BTRFS_I(inode)->generation > fs_info->last_trans_committed)
-		ret = btrfs_commit_inode_delayed_items(trans, inode);
+		ret = btrfs_commit_inode_delayed_items(trans, BTRFS_I(inode));
 	else
 		ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
 
-- 
2.7.4

