Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731178AbeGRDkY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 23:40:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6I34inT000998
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 03:04:44 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2k7a3tb66x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 03:04:44 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6I34hU2030874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 03:04:43 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6I34hcg002995
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 03:04:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7] btrfs: introduce feature to forget a btrfs device
Date: Wed, 18 Jul 2018 11:08:00 +0800
Message-Id: <20180718030801.31617-2-anand.jain@oracle.com>
In-Reply-To: <20180718030801.31617-1-anand.jain@oracle.com>
References: <20180718030801.31617-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Support for a new command 'btrfs dev forget [dev]' is proposed here,
to undo the effects of 'btrfs dev scan [dev]'. For this purpose,
this patch proposes to use ioctl #5 as it was empty.
	IOW(BTRFS_IOCTL_MAGIC, 5, ..)
This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
the /dev/btrfs-control to forget one or all devices, (devices which are
not mounted) from the btrfs kernel.

The argument it takes is struct btrfs_ioctl_vol_args, and ::name can be
set to specify the device path. And all unmounted devices can be removed
from the kernel if no device path is provided.

Again, the devices are removed only if the relevant fsid aren't mounted.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c           | 3 +++
 fs/btrfs/volumes.c         | 9 +++++++++
 fs/btrfs/volumes.h         | 1 +
 include/uapi/linux/btrfs.h | 2 ++
 4 files changed, 15 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d7a54c648c5f..196b0773eedb 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2249,6 +2249,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		ret = PTR_ERR_OR_ZERO(device);
 		mutex_unlock(&uuid_mutex);
 		break;
+	case BTRFS_IOC_FORGET_DEV:
+		ret = btrfs_forget_devices(vol->name);
+		break;
 	case BTRFS_IOC_DEVICES_READY:
 		mutex_lock(&uuid_mutex);
 		device = btrfs_scan_one_device(vol->name, FMODE_READ,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 51451c0dd8f5..bc1e19663e81 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1208,6 +1208,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	return 0;
 }
 
+int btrfs_forget_devices(const char *path)
+{
+	mutex_lock(&uuid_mutex);
+	btrfs_free_stale_devices(path, NULL);
+	mutex_unlock(&uuid_mutex);
+
+	return 0;
+}
+
 /*
  * Look for a btrfs signature on a device. This may be called out of the mount path
  * and we are not allowed to call set_blocksize during the scan. The superblock
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 06d8bb7dd557..82502a7ff6e4 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -405,6 +405,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
 struct btrfs_device *btrfs_scan_one_device(const char *path,
 					   fmode_t flags, void *holder);
+int btrfs_forget_devices(const char *path);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..b1be7f828cb4 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -836,6 +836,8 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
+				   struct btrfs_ioctl_vol_args)
 /* trans start and trans end are dangerous, and only for
  * use by applications that know how to avoid the
  * resulting deadlocks
-- 
2.7.0

