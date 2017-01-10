Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:36015 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765917AbdAJSf4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:35:56 -0500
Received: by mail-wj0-f195.google.com with SMTP id dh1so8083336wjb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:35:55 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 02/12] btrfs: Make btrfs_get_delayed_node take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:32 +0200
Message-Id: <1484073342-28854-3-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is internal to btrfs and doesn't really deal with any
VFS members, as such it needn't take a struct inode refrence but
btrfs_inode.

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 15f9b8e9dbf6..ad95b97bb6c6 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -72,9 +72,8 @@ static inline int btrfs_is_continuous_delayed_item(
 	return 0;
 }
 
-static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
+static struct btrfs_delayed_node *btrfs_get_delayed_node(struct btrfs_inode *btrfs_inode)
 {
-	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
 	struct btrfs_root *root = btrfs_inode->root;
 	u64 ino = btrfs_ino(btrfs_inode);
 	struct btrfs_delayed_node *node;
@@ -116,7 +115,7 @@ static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
 	int ret;
 
 again:
-	node = btrfs_get_delayed_node(inode);
+	node = btrfs_get_delayed_node(btrfs_inode);
 	if (node)
 		return node;
 
@@ -1198,7 +1197,7 @@ int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans,
 int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 				     struct inode *inode)
 {
-	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
+	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *block_rsv;
 	int ret;
@@ -1237,7 +1236,7 @@ int btrfs_commit_inode_delayed_inode(struct inode *inode)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_trans_handle *trans;
-	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
+	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *block_rsv;
 	int ret;
@@ -1560,7 +1559,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 
 int btrfs_inode_delayed_dir_index_count(struct inode *inode)
 {
-	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
+	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
 
 	if (!delayed_node)
 		return -ENOENT;
@@ -1587,7 +1586,7 @@ bool btrfs_readdir_get_delayed_items(struct inode *inode,
 	struct btrfs_delayed_node *delayed_node;
 	struct btrfs_delayed_item *item;
 
-	delayed_node = btrfs_get_delayed_node(inode);
+	delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
 	if (!delayed_node)
 		return false;
 
@@ -1776,7 +1775,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	struct btrfs_delayed_node *delayed_node;
 	struct btrfs_inode_item *inode_item;
 
-	delayed_node = btrfs_get_delayed_node(inode);
+	delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
 	if (!delayed_node)
 		return -ENOENT;
 
@@ -1937,7 +1936,7 @@ void btrfs_kill_delayed_inode_items(struct inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
 
-	delayed_node = btrfs_get_delayed_node(inode);
+	delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
 	if (!delayed_node)
 		return;
 
-- 
2.7.4

