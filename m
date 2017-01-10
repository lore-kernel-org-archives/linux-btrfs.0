Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34192 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765917AbdAJSgE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:36:04 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so31527397wmi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:35:58 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 05/12] btrfs: Make btrfs_insert_delayed_dir_index take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:35 +0200
Message-Id: <1484073342-28854-6-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 6 +++---
 fs/btrfs/delayed-inode.h | 2 +-
 fs/btrfs/dir-item.c      | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 7be90eb978d5..473df414be1b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1432,7 +1432,7 @@ void btrfs_balance_delayed_items(struct btrfs_fs_info *fs_info)
 int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   struct btrfs_fs_info *fs_info,
 				   const char *name, int name_len,
-				   struct inode *dir,
+				   struct btrfs_inode *dir,
 				   struct btrfs_disk_key *disk_key, u8 type,
 				   u64 index)
 {
@@ -1441,7 +1441,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	struct btrfs_dir_item *dir_item;
 	int ret;
 
-	delayed_node = btrfs_get_or_create_delayed_node(BTRFS_I(dir));
+	delayed_node = btrfs_get_or_create_delayed_node(dir);
 	if (IS_ERR(delayed_node))
 		return PTR_ERR(delayed_node);
 
@@ -1451,7 +1451,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 		goto release_node;
 	}
 
-	delayed_item->key.objectid = btrfs_ino(BTRFS_I(dir));
+	delayed_item->key.objectid = btrfs_ino(dir);
 	delayed_item->key.type = BTRFS_DIR_INDEX_KEY;
 	delayed_item->key.offset = index;
 
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 8a2bf5e3e4cf..3cbd9bb79713 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -101,7 +101,7 @@ static inline void btrfs_init_delayed_root(
 int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   struct btrfs_fs_info *fs_info,
 				   const char *name, int name_len,
-				   struct inode *dir,
+				   struct btrfs_inode *dir,
 				   struct btrfs_disk_key *disk_key, u8 type,
 				   u64 index);
 
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 74de492bd490..2c2b707567e4 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -174,7 +174,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_release_path(path);
 
 	ret2 = btrfs_insert_delayed_dir_index(trans, root->fs_info, name,
-					      name_len, dir, &disk_key, type,
+					      name_len, BTRFS_I(dir), &disk_key, type,
 					      index);
 out_free:
 	btrfs_free_path(path);
-- 
2.7.4

