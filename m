Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59986 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753997AbdLGOgD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 09:36:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB7EVclJ066398
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:36:02 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2eq4ag8v0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Dec 2017 14:36:02 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB7Ea1Hl021054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:36:01 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vB7Ea0Ad018301
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:36:01 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 2/3] btrfs: introduce feature to deregister a btrfs device
Date: Thu,  7 Dec 2017 22:36:22 +0800
Message-Id: <20171207143623.26710-3-anand.jain@oracle.com>
In-Reply-To: <20171207143623.26710-1-anand.jain@oracle.com>
References: <20171207143623.26710-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Support for a new command is being added here:
 btrfs dev deregister <dev>
Which shall undo the effects of the command
 btrfs dev scan <dev>

This cli/ioctl is needed as there is no way to continue to mount in
degraded mode if the device is already scanned, which is required to
recover from the split brain raid conditions.

This patch proposes to use ioctl #5 as it was empty.
	IOW(BTRFS_IOCTL_MAGIC, 5, ..)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Use -EBUSY instead of -ENOENT
    Since now delete_device_from_list() holds device_list_mutex
    so dont hold device_list_mutex in its parent. Reword and indent
    pr_err/info.
v3: Send to correct ML
v4: no change.
v5: Make sure uuid_mutex in device_list_remove(), set ret value to near
to the event.

 fs/btrfs/super.c           |  4 +++
 fs/btrfs/volumes.c         | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |  2 ++
 include/uapi/linux/btrfs.h |  3 +-
 4 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f443517fa2f8..ea6fe4742834 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2212,6 +2212,10 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
 		break;
+	case BTRFS_IOC_PURGE_DEV:
+		ret = btrfs_purge_one_device(vol->name, FMODE_READ,
+					    &btrfs_fs_type, &fs_devices);
+		break;
 	case BTRFS_IOC_DEVICES_READY:
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f53d62e92fa9..5adab70c7658 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1260,6 +1260,82 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	return 0;
 }
 
+static int device_list_remove(struct btrfs_super_block *disk_super, u64 devid)
+{
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
+	int ret;
+
+	mutex_lock(&uuid_mutex);
+	fs_devices = find_fsid(disk_super->fsid);
+	if (!fs_devices) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (fs_devices->opened) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	device = find_device(fs_devices, devid, disk_super->dev_item.uuid);
+	if (!device) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	delete_device_from_list(device);
+	ret = 0;
+out:
+	mutex_unlock(&uuid_mutex);
+
+	return ret;
+}
+
+int btrfs_purge_one_device(const char *path, fmode_t flags, void *holder,
+			  struct btrfs_fs_devices **fs_devices_ret)
+{
+	struct btrfs_super_block *disk_super;
+	struct block_device *bdev;
+	struct page *page;
+	u64 bytenr;
+	u64 devid;
+	int ret;
+
+	bytenr = btrfs_sb_offset(0);
+	flags |= FMODE_EXCL;
+
+	bdev = blkdev_get_by_path(path, flags, holder);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
+		ret = -EINVAL;
+		goto error_bdev_put;
+	}
+
+	devid = btrfs_stack_device_id(&disk_super->dev_item);
+
+	ret = device_list_remove(disk_super, devid);
+	/* User error */
+	if (ret == -ENOENT)
+		goto error;
+
+	if (ret)
+		pr_err("BTRFS: %pU device %s devid %llu failed to deregister: %d\n",
+			disk_super->fsid, path, devid, ret);
+	else
+		pr_info("BTRFS: %pU device %s devid %llu deregistered\n",
+			disk_super->fsid, path, devid);
+
+error:
+	btrfs_release_disk_super(page);
+
+error_bdev_put:
+	blkdev_put(bdev, flags);
+	return ret;
+}
+
 /*
  * Look for a btrfs signature on a device. This may be called out of the mount path
  * and we are not allowed to call set_blocksize during the scan. The superblock
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index efb5117301b7..8389d2815750 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -422,6 +422,8 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
+int btrfs_purge_one_device(const char *path, fmode_t flags, void *holder,
+			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index adf0b088d9a0..de0f1144d945 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -105,7 +105,6 @@ struct btrfs_ioctl_qgroup_limit_args {
  * - BTRFS_IOC_SUBVOL_GETFLAGS
  * - BTRFS_IOC_SUBVOL_SETFLAGS
  */
-
 struct btrfs_ioctl_vol_args_v2 {
 	__s64 fd;
 	__u64 transid;
@@ -744,6 +743,8 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_PURGE_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
+				   struct btrfs_ioctl_vol_args)
 /* trans start and trans end are dangerous, and only for
  * use by applications that know how to avoid the
  * resulting deadlocks
-- 
2.7.0

