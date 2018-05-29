Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2972 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754720AbeE2HCO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 03:02:14 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 475714B40405
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 15:02:08 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs: Remove fs_info argument from btrfs_uuid_tree_add
Date: Tue, 29 May 2018 15:01:53 +0800
Message-ID: <20180529070154.20560-2-lufq.fnst@cn.fujitsu.com>
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
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/ioctl.c       | 4 ++--
 fs/btrfs/transaction.c | 7 +++----
 fs/btrfs/uuid-tree.c   | 4 ++--
 fs/btrfs/volumes.c     | 5 ++---
 5 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6deb39d8415d..66a9ba039bf1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3044,8 +3044,7 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
 
 /* uuid-tree.c */
-int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u8 *uuid, u8 type,
+int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
 			u64 subid);
 int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, u8 *uuid, u8 type,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 89b1054796e6..99610af677a5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -718,7 +718,7 @@ static noinline int create_subvol(struct inode *dir,
 				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
 	BUG_ON(ret);
 
-	ret = btrfs_uuid_tree_add(trans, fs_info, root_item->uuid,
+	ret = btrfs_uuid_tree_add(trans, root_item->uuid,
 				  BTRFS_UUID_KEY_SUBVOL, objectid);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
@@ -5491,7 +5491,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 		goto out;
 	}
 	if (received_uuid_changed && !btrfs_is_empty_uuid(sa->uuid)) {
-		ret = btrfs_uuid_tree_add(trans, fs_info, sa->uuid,
+		ret = btrfs_uuid_tree_add(trans, sa->uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  root->root_key.objectid);
 		if (ret < 0 && ret != -EEXIST) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2cbc8ae142e0..1c923c14887a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1622,15 +1622,14 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
-	ret = btrfs_uuid_tree_add(trans, fs_info, new_uuid.b,
-				  BTRFS_UUID_KEY_SUBVOL, objectid);
+	ret = btrfs_uuid_tree_add(trans, new_uuid.b, BTRFS_UUID_KEY_SUBVOL,
+				  objectid);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
 	if (!btrfs_is_empty_uuid(new_root_item->received_uuid)) {
-		ret = btrfs_uuid_tree_add(trans, fs_info,
-					  new_root_item->received_uuid,
+		ret = btrfs_uuid_tree_add(trans, new_root_item->received_uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  objectid);
 		if (ret && ret != -EEXIST) {
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 1ba7ca2a4200..8be956ed4603 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -79,10 +79,10 @@ static int btrfs_uuid_tree_lookup(struct btrfs_root *uuid_root, u8 *uuid,
 	return ret;
 }
 
-int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u8 *uuid, u8 type,
+int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
 			u64 subid_cpu)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *uuid_root = fs_info->uuid_root;
 	int ret;
 	struct btrfs_path *path = NULL;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 74e02eadf265..a3c1f23f34cc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4353,8 +4353,7 @@ static int btrfs_uuid_scan_kthread(void *data)
 		}
 update_tree:
 		if (!btrfs_is_empty_uuid(root_item.uuid)) {
-			ret = btrfs_uuid_tree_add(trans, fs_info,
-						  root_item.uuid,
+			ret = btrfs_uuid_tree_add(trans, root_item.uuid,
 						  BTRFS_UUID_KEY_SUBVOL,
 						  key.objectid);
 			if (ret < 0) {
@@ -4365,7 +4364,7 @@ static int btrfs_uuid_scan_kthread(void *data)
 		}
 
 		if (!btrfs_is_empty_uuid(root_item.received_uuid)) {
-			ret = btrfs_uuid_tree_add(trans, fs_info,
+			ret = btrfs_uuid_tree_add(trans,
 						  root_item.received_uuid,
 						 BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 						  key.objectid);
-- 
2.17.0



