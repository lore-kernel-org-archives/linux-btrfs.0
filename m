Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932624AbeGCJEW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 05:04:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6393pPn033521
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 09:04:21 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jx1tnyp12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2018 09:04:21 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6394Lbp020670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 09:04:21 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6394KIh009339
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2018 09:04:21 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: fix missing superblock update in the device delete commit transaction
Date: Tue,  3 Jul 2018 17:07:24 +0800
Message-Id: <20180703090724.22023-2-anand.jain@oracle.com>
In-Reply-To: <20180703090724.22023-1-anand.jain@oracle.com>
References: <20180703090724.22023-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a device is deleted, the btrfs_super_block::number_devices is
reduced by 1, but we do that after the commit transaction, so this
change did not made it to the disk and waits for the next commit
transaction whenever it happens.

This can be easily demonstrated using the following test case where I
use the btrfs device ready cli to read the disk and report.

  mkfs.btrfs -fq -dsingle -msingle $dev1 $dev2
  mount $dev1 /btrfs
  btrfs dev del $dev2 /btrfs
  btrfs dev ready $dev1; echo RESULT=$? <-- 1
   Without this patch RESULT returns 1, indicating not ready!

  Testing with a seed device:

  mkfs.btrfs -fq $dev1
  btrfstune -S1 $dev1
  mount $dev1 /btrfs
  btrfs dev add -f $dev2 /btrfs
  umount /btrfs
  mount $dev2 /btrfs
  btrfs dev del $dev1 /btrfs
  btrfs dev ready $dev2; echo RESULT=$? <-- 1

  Fix this by bringing in the num_devices update with in the
  current commit transaction.
  Also align the local variable declarations in the function
  btrfs_rm_dev_item()
  Delete a todo comment about transient inconsistent state

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2:
 Delete a todo comment
 Refactor btrfs_rm_dev_item to use trans->fs_info and drop fs_info in
the argument
 
 fs/btrfs/volumes.c | 46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b5a60ab37a1c..1bdfd5e05bb5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1822,47 +1822,32 @@ static void update_dev_time(const char *path_name)
 	filp_close(filp, NULL);
 }
 
-static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
+static int btrfs_rm_dev_item(struct btrfs_trans_handle *trans,
 			     struct btrfs_device *device)
 {
-	struct btrfs_root *root = fs_info->chunk_root;
-	int ret;
+	struct btrfs_root *root = trans->fs_info->chunk_root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct btrfs_trans_handle *trans;
+	int ret;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans)) {
-		btrfs_free_path(path);
-		return PTR_ERR(trans);
-	}
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret) {
-		if (ret > 0)
-			ret = -ENOENT;
-		btrfs_abort_transaction(trans, ret);
-		btrfs_end_transaction(trans);
+	if (ret > 0) {
+		ret = -ENOENT;
 		goto out;
 	}
 
 	ret = btrfs_del_item(trans, root, path);
-	if (ret) {
-		btrfs_abort_transaction(trans, ret);
-		btrfs_end_transaction(trans);
-	}
 
 out:
 	btrfs_free_path(path);
-	if (!ret)
-		ret = btrfs_commit_transaction(trans);
 	return ret;
 }
 
@@ -1946,7 +1931,9 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		u64 devid)
 {
 	struct btrfs_device *device;
+	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_devices *cur_devices;
+	struct btrfs_root *root = fs_info->dev_root;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u64 num_devices;
 	int ret = 0;
@@ -1994,14 +1981,18 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (ret)
 		goto error_undo;
 
-	/*
-	 * TODO: the superblock still includes this device in its num_devices
-	 * counter although write_all_supers() is not locked out. This
-	 * could give a filesystem state which requires a degraded mount.
-	 */
-	ret = btrfs_rm_dev_item(fs_info, device);
-	if (ret)
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto error_undo;
+	}
+
+	ret = btrfs_rm_dev_item(trans, device);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
+		goto error_undo;
+	}
 
 	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	btrfs_scrub_cancel_dev(fs_info, device);
@@ -2070,6 +2061,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		free_fs_devices(cur_devices);
 	}
 
+	ret = btrfs_commit_transaction(trans);
 out:
 	mutex_unlock(&uuid_mutex);
 	return ret;
-- 
2.7.0

