Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754859AbdLOEDU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 23:03:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF41aIc149449
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 04:03:19 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2ev7088080-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 04:03:19 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3mIe3001224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:48:18 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3mHo0022753
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:48:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5] btrfs: introduce feature to ignore a btrfs device
Date: Fri, 15 Dec 2017 11:48:46 +0800
Message-Id: <20171215034847.26258-2-anand.jain@oracle.com>
In-Reply-To: <20171215034847.26258-1-anand.jain@oracle.com>
References: <20171215034847.26258-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Support for a new command is being added here:
 btrfs dev ignore [dev]

This cli/ioctl is needed as there is no way to continue to mount in
degraded mode if the device is already scanned, which is required to
recover from the split brain raid conditions.

This patch proposes to use ioctl #5 as it was empty.
	IOW(BTRFS_IOCTL_MAGIC, 5, ..)

This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
the /dev/btrfs-control to delete one or all stale (devices which are
not mounted) from the btrfs kernel.
The argument it takes is struct btrfs_ioctl_vol_args_v2, and ::name can be
set to specify the device path. And all stale devices can be removed
from the kernel using the flag BTRFS_DEVICE_SPEC_ALL_DEV. Remove all
devices functionality would override remove one device when both are
specified in an IOCTL call.

The devices are removed only if the relevant fsid aren't mounted.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5: Use btrfs_free_stale_devices(), depends on its preparatory patches
    in the ML.
    Use btrfs_ioctl_vol_args_v2 instead of btrfs_ioctl_vol_args
    Introduce BTRFS_DEVICE_SPEC_ALL_DEV to forget all stale devices
    No need to read the given SB device, instead match its device path,
     btrfs_free_stale_devices() just skips all mounted devices anyway.
     Also SB read may fail.
    Patch commit log update.

v4: no change
v3: Send to correct ML
v2: Use -EBUSY instead of -ENOENT
    Since now delete_device_from_list() holds device_list_mutex
    so dont hold device_list_mutex in its parent. Reword and indent
    pr_err/info.

 fs/btrfs/super.c           | 27 +++++++++++++++++++++++----
 fs/btrfs/volumes.c         |  9 +++++++++
 fs/btrfs/volumes.h         |  1 +
 include/uapi/linux/btrfs.h |  6 +++++-
 4 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f443517fa2f8..99223035ac55 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2197,21 +2197,37 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	struct btrfs_ioctl_vol_args *vol;
+	struct btrfs_ioctl_vol_args_v2 *vol2;
 	struct btrfs_fs_devices *fs_devices;
 	int ret = -ENOTTY;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol = memdup_user((void __user *)arg, sizeof(*vol));
-	if (IS_ERR(vol))
-		return PTR_ERR(vol);
+	if (cmd == BTRFS_IOC_FORGET_DEV) {
+		vol2 = memdup_user((void __user *)arg, sizeof(*vol2));
+		if (IS_ERR(vol2))
+			return PTR_ERR(vol2);
+
+		if (vol2->flags & ~BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED)
+			return -EOPNOTSUPP;
+	} else {
+		vol = memdup_user((void __user *)arg, sizeof(*vol));
+		if (IS_ERR(vol))
+			return PTR_ERR(vol);
+	}
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
 		break;
+	case BTRFS_IOC_FORGET_DEV:
+		if (vol2->flags & BTRFS_DEVICE_SPEC_ALL_DEV)
+			ret = btrfs_forget_devices(NULL);
+		else
+			ret = btrfs_forget_devices(vol2->name);
+		break;
 	case BTRFS_IOC_DEVICES_READY:
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
@@ -2224,7 +2240,10 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		break;
 	}
 
-	kfree(vol);
+	if (cmd == BTRFS_IOC_FORGET_DEV)
+		kfree(vol2);
+	else
+		kfree(vol);
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f9db59c118a4..fb1c2ebbe410 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1166,6 +1166,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	return 0;
 }
 
+int btrfs_forget_devices(const char *path)
+{
+	mutex_lock(&uuid_mutex);
+	btrfs_free_stale_device(path, NULL);
+	mutex_unlock(&uuid_mutex);
+
+	return 0;
+}
+
 /*
  * Look for a btrfs signature on a device. This may be called out of the mount path
  * and we are not allowed to call set_blocksize during the scan. The superblock
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 81cf8ab15a41..558b2eddb6e4 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -422,6 +422,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
+int btrfs_forget_devices(const char *path);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index adf0b088d9a0..e77c4287e36c 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -40,12 +40,14 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
 #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
 #define BTRFS_DEVICE_SPEC_BY_ID		(1ULL << 3)
+#define BTRFS_DEVICE_SPEC_ALL_DEV	(1ULL << 4)
 
 #define BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED		\
 			(BTRFS_SUBVOL_CREATE_ASYNC |	\
 			BTRFS_SUBVOL_RDONLY |		\
 			BTRFS_SUBVOL_QGROUP_INHERIT |	\
-			BTRFS_DEVICE_SPEC_BY_ID)
+			BTRFS_DEVICE_SPEC_BY_ID |	\
+			BTRFS_DEVICE_SPEC_ALL_DEV)
 
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
@@ -744,6 +746,8 @@ enum btrfs_err_code {
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

