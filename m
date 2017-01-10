Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34237 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938830AbdAJSgC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:36:02 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so31527749wmi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:36:02 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 09/12] btrfs: Make btrfs_remove_delayed_node take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:39 +0200
Message-Id: <1484073342-28854-10-git-send-email-n.borisov.lkml@gmail.com>
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
index 73a588d0f957..5d4dd3e18af3 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1286,15 +1286,15 @@ int btrfs_commit_inode_delayed_inode(struct inode *inode)
 	return ret;
 }
 
-void btrfs_remove_delayed_node(struct inode *inode)
+void btrfs_remove_delayed_node(struct btrfs_inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
 
-	delayed_node = ACCESS_ONCE(BTRFS_I(inode)->delayed_node);
+	delayed_node = ACCESS_ONCE(inode->delayed_node);
 	if (!delayed_node)
 		return;
 
-	BTRFS_I(inode)->delayed_node = NULL;
+	inode->delayed_node = NULL;
 	btrfs_release_delayed_node(delayed_node);
 }
 
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index fbada25cd17e..81572693d0e0 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -121,7 +121,7 @@ void btrfs_balance_delayed_items(struct btrfs_fs_info *fs_info);
 int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 				     struct inode *inode);
 /* Used for evicting the inode. */
-void btrfs_remove_delayed_node(struct inode *inode);
+void btrfs_remove_delayed_node(struct btrfs_inode *inode);
 void btrfs_kill_delayed_inode_items(struct btrfs_inode *inode);
 int btrfs_commit_inode_delayed_inode(struct inode *inode);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1a72ee1e4994..874a8689938f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5399,7 +5399,7 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
 no_delete:
-	btrfs_remove_delayed_node(inode);
+	btrfs_remove_delayed_node(BTRFS_I(inode));
 	clear_inode(inode);
 }
 
-- 
2.7.4

