Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53594 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753979AbeEaHdA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 03:33:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4V7W2Qh031678
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 07:32:59 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2j9x4hamqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 07:32:59 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4V7WwmY019183
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 07:32:59 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4V7WwP6017390
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 07:32:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix missing superblock update in the device delete commit transaction
Date: Thu, 31 May 2018 15:35:29 +0800
Message-Id: <20180531073529.15309-2-anand.jain@oracle.com>
In-Reply-To: <20180531073529.15309-1-anand.jain@oracle.com>
References: <20180531073529.15309-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a device is deleted the btrfs_super_block::number_devices is
reduced by 1, but since we are do that after the last commit transaction
for the device delete transaction, the update to
btrfs_super_block::number_devices waits for the next commit/fsync
transaction to make it to the disk.

This can be easily demonstrated using the following test case where I
use the btrfs device ready cli to read the and report, as it reads the
device directly (which is unnecessary for the mounted device) and checks
for the fs_devices::total_devices.

  mkfs.btrfs -fq -dsingle -msingle $dev1 $dev2
  mount $dev1 /btrfs
  btrfs dev del $dev2 /btrfs
  btrfs dev ready $dev1; echo RESULT=$? <-- 1
   Without this patch RESULT returns 1, indicating not ready!

 Same thing using seed device:

  mkfs.btrfs -fq $dev1
  btrfstune -S1 $dev1
  mount $dev1 /btrfs
  btrfs dev add -f $dev2 /btrfs
  umount /btrfs
  mount $dev2 /btrfs
  btrfs dev del $dev1 /btrfs
  btrfs dev ready $dev2; echo RESULT=$?

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
The seed device test case needs to fix the bug as in the patch,
 [PATCH 1/2] btrfs: fix parent in memory total_devices after seed delete

As there is a bug in the btrfs_device_rm() code,

 fs/btrfs/volumes.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5296f26be2f6..4138f17d4e58 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1843,46 +1843,32 @@ static void update_dev_time(const char *path_name)
 }
 
 static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
-			     struct btrfs_device *device)
+			     struct btrfs_device *device,
+			     struct btrfs_trans_handle *trans)
 {
 	struct btrfs_root *root = fs_info->chunk_root;
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct btrfs_trans_handle *trans;
 
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
 
@@ -1966,7 +1952,9 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		u64 devid)
 {
 	struct btrfs_device *device;
+	struct btrfs_trans_handle *trans;
 	struct btrfs_fs_devices *cur_devices;
+	struct btrfs_root *root = fs_info->dev_root;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u64 num_devices;
 	int ret = 0;
@@ -2014,14 +2002,23 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (ret)
 		goto error_undo;
 
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto error_undo;
+	}
+
 	/*
 	 * TODO: the superblock still includes this device in its num_devices
 	 * counter although write_all_supers() is not locked out. This
 	 * could give a filesystem state which requires a degraded mount.
 	 */
-	ret = btrfs_rm_dev_item(fs_info, device);
-	if (ret)
+	ret = btrfs_rm_dev_item(fs_info, device, trans);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
 		goto error_undo;
+	}
 
 	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	btrfs_scrub_cancel_dev(fs_info, device);
@@ -2090,6 +2087,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		free_fs_devices(cur_devices);
 	}
 
+	ret = btrfs_commit_transaction(trans);
 out:
 	mutex_unlock(&uuid_mutex);
 	return ret;
-- 
2.7.0

