Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36040 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936994AbdAJSf5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:35:57 -0500
Received: by mail-wm0-f67.google.com with SMTP id r126so11434545wmr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:35:56 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 03/12] btrfs: Make btrfs_get_or_create_delayed_node take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:33 +0200
Message-Id: <1484073342-28854-4-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index ad95b97bb6c6..4059b4168210 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -106,10 +106,9 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(struct btrfs_inode *btr
 
 /* Will return either the node or PTR_ERR(-ENOMEM) */
 static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
-							struct inode *inode)
+							struct btrfs_inode *btrfs_inode)
 {
 	struct btrfs_delayed_node *node;
-	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
 	struct btrfs_root *root = btrfs_inode->root;
 	u64 ino = btrfs_ino(btrfs_inode);
 	int ret;
@@ -1442,7 +1441,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	struct btrfs_dir_item *dir_item;
 	int ret;
 
-	delayed_node = btrfs_get_or_create_delayed_node(dir);
+	delayed_node = btrfs_get_or_create_delayed_node(BTRFS_I(dir));
 	if (IS_ERR(delayed_node))
 		return PTR_ERR(delayed_node);
 
@@ -1516,7 +1515,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	struct btrfs_key item_key;
 	int ret;
 
-	node = btrfs_get_or_create_delayed_node(dir);
+	node = btrfs_get_or_create_delayed_node(BTRFS_I(dir));
 	if (IS_ERR(node))
 		return PTR_ERR(node);
 
@@ -1830,7 +1829,7 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_node *delayed_node;
 	int ret = 0;
 
-	delayed_node = btrfs_get_or_create_delayed_node(inode);
+	delayed_node = btrfs_get_or_create_delayed_node(BTRFS_I(inode));
 	if (IS_ERR(delayed_node))
 		return PTR_ERR(delayed_node);
 
@@ -1868,7 +1867,7 @@ int btrfs_delayed_delete_inode_ref(struct inode *inode)
 	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
 		return -EAGAIN;
 
-	delayed_node = btrfs_get_or_create_delayed_node(inode);
+	delayed_node = btrfs_get_or_create_delayed_node(BTRFS_I(inode));
 	if (IS_ERR(delayed_node))
 		return PTR_ERR(delayed_node);
 
-- 
2.7.4

