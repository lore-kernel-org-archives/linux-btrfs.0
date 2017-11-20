Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38083 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdKTIiQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 03:38:16 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAK8cFte014891
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 08:38:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAK8cFdO019912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 08:38:15 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAK8cFfT028170
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 08:38:15 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: introduce feature to ignore a btrfs device
Date: Mon, 20 Nov 2017 16:38:29 +0800
Message-Id: <20171120083829.1132-2-anand.jain@oracle.com>
In-Reply-To: <20171120083829.1132-1-anand.jain@oracle.com>
References: <20171113054410.24872-1-anand.jain@oracle.com>
 <20171120083829.1132-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Support for a new command is being added here:
 btrfs dev ignore <dev>
Which shall undo the effects of the command
 btrfs dev scan <dev>

This cli/ioctl is needed as there is no way to continue to mount in
degraded mode if the device is already scanned, which is required to
recover from the split brain raid conditions.

This patch proposes to use ioctl #5 as it was empty.
	IOW(BTRFS_IOCTL_MAGIC, 5, ..)
If #5 is reserved for some other purpose, I think I should change this.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Use -EBUSY instead of -ENOENT
    Since now delete_device_from_list() holds device_list_mutex
    so dont hold device_list_mutex in its parent. Reword and indent
    pr_err/info.
v3: Send to correct ML

 fs/btrfs/super.c           |  4 +++
 fs/btrfs/volumes.c         | 64 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |  2 ++
 include/uapi/linux/btrfs.h |  2 ++
 4 files changed, 72 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fa7bad8b22da..64f4beb1526d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2183,6 +2183,10 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
 		break;
+	case BTRFS_IOC_IGNORE_DEV:
+		ret = btrfs_ignore_one_device(vol->name, FMODE_READ,
+					    &btrfs_fs_type, &fs_devices);
+		break;
 	case BTRFS_IOC_DEVICES_READY:
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 68f1dd44385b..e82b61da90e8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1214,6 +1214,70 @@ int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	return 0;
 }
 
+static int device_list_remove(struct btrfs_super_block *disk_super, u64 devid)
+{
+	int ret = 0;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
+
+	fs_devices = find_fsid(disk_super->fsid);
+	if (!fs_devices)
+		return -ENOENT;
+
+	if (fs_devices->opened)
+		return -EBUSY;
+
+	mutex_lock(&uuid_mutex);
+
+	device = find_device(fs_devices, devid, disk_super->dev_item.uuid);
+	if (device)
+		delete_device_from_list(device);
+
+	mutex_unlock(&uuid_mutex);
+
+	return ret;
+}
+
+int btrfs_ignore_one_device(const char *path, fmode_t flags, void *holder,
+			  struct btrfs_fs_devices **fs_devices_ret)
+{
+	struct btrfs_super_block *disk_super;
+	struct block_device *bdev;
+	struct page *page;
+	int ret = -EINVAL;
+	u64 devid;
+	u64 bytenr;
+
+	bytenr = btrfs_sb_offset(0);
+	flags |= FMODE_EXCL;
+
+	bdev = blkdev_get_by_path(path, flags, holder);
+	if (IS_ERR(bdev)) {
+		ret = PTR_ERR(bdev);
+		goto error;
+	}
+
+	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
+		goto error_bdev_put;
+
+	devid = btrfs_stack_device_id(&disk_super->dev_item);
+
+	ret = device_list_remove(disk_super, devid);
+	if (ret)
+		pr_err("BTRFS: %pU device %s devid %llu failed to ignore: %d\n",
+			disk_super->fsid, path, devid, ret);
+	else
+		pr_info("BTRFS: %pU device %s devid %llu ignored\n",
+			disk_super->fsid, path, devid);
+
+	btrfs_release_disk_super(page);
+
+error_bdev_put:
+	blkdev_put(bdev, flags);
+error:
+	return ret;
+}
+
 /*
  * Look for a btrfs signature on a device. This may be called out of the mount path
  * and we are not allowed to call set_blocksize during the scan. The superblock
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ff15208344a7..c5df0e6c2231 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -421,6 +421,8 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
+int btrfs_ignore_one_device(const char *path, fmode_t flags, void *holder,
+			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 6cdfd12cd14c..673ba6e6b331 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -740,6 +740,8 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_IGNORE_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
+				   struct btrfs_ioctl_vol_args)
 /* trans start and trans end are dangerous, and only for
  * use by applications that know how to avoid the
  * resulting deadlocks
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
