Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34950 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdKFIgV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 03:36:21 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA68aJ5L014407
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA68aJ8L023425
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:19 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA68aJqQ029123
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:19 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/7] btrfs: move volume_mutex into btrfs_init_new_device()
Date: Mon,  6 Nov 2017 16:36:17 +0800
Message-Id: <20171106083618.7617-7-anand.jain@oracle.com>
In-Reply-To: <20171106083618.7617-1-anand.jain@oracle.com>
References: <20171106083618.7617-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By moving the volume_mutex into btrfs_init_new_device() it will be
much closer to the items to be protected.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c   |  2 --
 fs/btrfs/volumes.c | 10 +++++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 86e7f5abd740..52289cc661f0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2648,7 +2648,6 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
 	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
 		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 
-	mutex_lock(&fs_info->volume_mutex);
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -2663,7 +2662,6 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
 
 	kfree(vol_args);
 out:
-	mutex_unlock(&fs_info->volume_mutex);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3d5ed4518f20..727c815e9040 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2380,6 +2380,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
+	mutex_lock(&fs_info->volume_mutex);
+
 	if (fs_info->fs_devices->seeding) {
 		seeding_dev = 1;
 		down_write(&sb->s_umount);
@@ -2529,8 +2531,11 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		up_write(&sb->s_umount);
 		unlocked = true;
 
-		if (ret) /* transaction commit */
+		if (ret) {
+			mutex_unlock(&fs_info->volume_mutex);
+			/* transaction commit */
 			return ret;
+		}
 
 		ret = btrfs_relocate_sys_chunks(fs_info);
 		if (ret < 0)
@@ -2547,6 +2552,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		ret = btrfs_commit_transaction(trans);
 	}
 
+	mutex_unlock(&fs_info->volume_mutex);
+
 	/* Update ctime/mtime for libblkid */
 	update_dev_time(device_path);
 	return ret;
@@ -2566,6 +2573,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
 	}
+	mutex_unlock(&fs_info->volume_mutex);
 	return ret;
 }
 
-- 
2.13.1

