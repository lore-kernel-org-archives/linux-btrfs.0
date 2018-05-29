Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:11630 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754723AbeE2HCO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 03:02:14 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 19BA74B41E69
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 15:02:09 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs: Remove fs_info argument from btrfs_uuid_tree_rem
Date: Tue, 29 May 2018 15:01:54 +0800
Message-ID: <20180529070154.20560-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180529070154.20560-1-lufq.fnst@cn.fujitsu.com>
References: <20180529070154.20560-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function always takes a transaction handle which contains a
reference to the fs_info. Use that and remove the extra argument.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h     | 3 +--
 fs/btrfs/inode.c     | 5 ++---
 fs/btrfs/ioctl.c     | 5 ++---
 fs/btrfs/uuid-tree.c | 6 +++---
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 66a9ba039bf1..cd3c839e5230 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3046,8 +3046,7 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 /* uuid-tree.c */
 int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
 			u64 subid);
-int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u8 *uuid, u8 type,
+int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
 			u64 subid);
 int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
 			    int (*check_func)(struct btrfs_fs_info *, u8 *, u8,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9228cb866115..1412e62ac94c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4370,7 +4370,7 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 		}
 	}
 
-	ret = btrfs_uuid_tree_rem(trans, fs_info, dest->root_item.uuid,
+	ret = btrfs_uuid_tree_rem(trans, dest->root_item.uuid,
 				  BTRFS_UUID_KEY_SUBVOL,
 				  dest->root_key.objectid);
 	if (ret && ret != -ENOENT) {
@@ -4379,8 +4379,7 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 		goto out_end_trans;
 	}
 	if (!btrfs_is_empty_uuid(dest->root_item.received_uuid)) {
-		ret = btrfs_uuid_tree_rem(trans, fs_info,
-					  dest->root_item.received_uuid,
+		ret = btrfs_uuid_tree_rem(trans, dest->root_item.received_uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  dest->root_key.objectid);
 		if (ret && ret != -ENOENT) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 99610af677a5..d968709a5d62 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1961,7 +1961,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	        if (!btrfs_is_empty_uuid(root->root_item.received_uuid)) {
 			struct btrfs_root_item *root_item = &root->root_item;
 
-	                ret = btrfs_uuid_tree_rem(trans, fs_info,
+			ret = btrfs_uuid_tree_rem(trans,
 	                                root->root_item.received_uuid,
 	                                BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 	                                root->root_key.objectid);
@@ -5466,8 +5466,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 				       BTRFS_UUID_SIZE);
 	if (received_uuid_changed &&
 	    !btrfs_is_empty_uuid(root_item->received_uuid)) {
-		ret = btrfs_uuid_tree_rem(trans, fs_info,
-					  root_item->received_uuid,
+		ret = btrfs_uuid_tree_rem(trans, root_item->received_uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  root->root_key.objectid);
 		if (ret && ret != -ENOENT) {
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 8be956ed4603..894b7dc5bb98 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -144,10 +144,10 @@ int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
 	return ret;
 }
 
-int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u8 *uuid, u8 type,
+int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
 			u64 subid)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *uuid_root = fs_info->uuid_root;
 	int ret;
 	struct btrfs_path *path = NULL;
@@ -239,7 +239,7 @@ static int btrfs_uuid_iter_rem(struct btrfs_root *uuid_root, u8 *uuid, u8 type,
 		goto out;
 	}
 
-	ret = btrfs_uuid_tree_rem(trans, uuid_root->fs_info, uuid, type, subid);
+	ret = btrfs_uuid_tree_rem(trans, uuid, type, subid);
 	btrfs_end_transaction(trans);
 
 out:
-- 
2.17.0



