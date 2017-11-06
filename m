Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28365 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdKFC14 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Nov 2017 21:27:56 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA62Rs0N020895
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 02:27:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA62RsAt005988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 02:27:54 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA62RsA1030032
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 02:27:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: move volume_mutex into the btrfs_rm_device()
Date: Mon,  6 Nov 2017 10:28:00 +0800
Message-Id: <20171106022800.9473-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A cleanup patch no functional change, we hold volume_mutex before
calling btrfs_rm_device, so move it into the function itself.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
David, This patch is based on your workspace/for-next plus your
recent patchset '[PATCH 00/11] Device fixes and cleanups'.
Thanks, Anand

 fs/btrfs/ioctl.c   | 4 ----
 fs/btrfs/volumes.c | 2 ++
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bc13b6d0f280..09c95f1b07dc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2695,14 +2695,12 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 		goto out;
 	}
 
-	mutex_lock(&fs_info->volume_mutex);
 	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID) {
 		ret = btrfs_rm_device(fs_info, NULL, vol_args->devid);
 	} else {
 		vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
 		ret = btrfs_rm_device(fs_info, vol_args->name, 0);
 	}
-	mutex_unlock(&fs_info->volume_mutex);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 
 	if (!ret) {
@@ -2746,9 +2744,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	}
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-	mutex_lock(&fs_info->volume_mutex);
 	ret = btrfs_rm_device(fs_info, vol_args->name, 0);
-	mutex_unlock(&fs_info->volume_mutex);
 
 	if (!ret)
 		btrfs_info(fs_info, "disk deleted %s", vol_args->name);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e913d2154ffb..5b03c2b1b851 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1913,6 +1913,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	u64 num_devices;
 	int ret = 0;
 
+	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&uuid_mutex);
 
 	num_devices = fs_info->fs_devices->num_devices;
@@ -2027,6 +2028,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 out:
 	mutex_unlock(&uuid_mutex);
+	mutex_unlock(&fs_info->volume_mutex);
 	return ret;
 
 error_undo:
-- 
2.13.1

