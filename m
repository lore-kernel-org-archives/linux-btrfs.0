Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34438 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765917AbdAJSgA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:36:00 -0500
Received: by mail-wj0-f195.google.com with SMTP id qs7so50818427wjc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:35:59 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 06/12] btrfs: Make btrfs_delete_delayed_dir_index take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:36 +0200
Message-Id: <1484073342-28854-7-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 6 +++---
 fs/btrfs/delayed-inode.h | 2 +-
 fs/btrfs/inode.c         | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 473df414be1b..c7b40613e31c 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1508,18 +1508,18 @@ static int btrfs_delete_delayed_insertion_item(struct btrfs_fs_info *fs_info,
 
 int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   struct btrfs_fs_info *fs_info,
-				   struct inode *dir, u64 index)
+				   struct btrfs_inode *dir, u64 index)
 {
 	struct btrfs_delayed_node *node;
 	struct btrfs_delayed_item *item;
 	struct btrfs_key item_key;
 	int ret;
 
-	node = btrfs_get_or_create_delayed_node(BTRFS_I(dir));
+	node = btrfs_get_or_create_delayed_node(dir);
 	if (IS_ERR(node))
 		return PTR_ERR(node);
 
-	item_key.objectid = btrfs_ino(BTRFS_I(dir));
+	item_key.objectid = btrfs_ino(dir);
 	item_key.type = BTRFS_DIR_INDEX_KEY;
 	item_key.offset = index;
 
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 3cbd9bb79713..adf6a8a0b23a 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -107,7 +107,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 
 int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   struct btrfs_fs_info *fs_info,
-				   struct inode *dir, u64 index);
+				   struct btrfs_inode *dir, u64 index);
 
 int btrfs_inode_delayed_dir_index_count(struct inode *inode);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6818a09a0317..d5ca388ae710 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4061,7 +4061,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	}
 skip_backref:
-	ret = btrfs_delete_delayed_dir_index(trans, fs_info, dir, index);
+	ret = btrfs_delete_delayed_dir_index(trans, fs_info, BTRFS_I(dir), index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto err;
@@ -4225,7 +4225,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	ret = btrfs_delete_delayed_dir_index(trans, fs_info, dir, index);
+	ret = btrfs_delete_delayed_dir_index(trans, fs_info, BTRFS_I(dir), index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
-- 
2.7.4

