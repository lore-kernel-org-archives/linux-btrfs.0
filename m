Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753627AbdLGOjo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 09:39:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB7EdfmP175460
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:39:44 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2epd12qk6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Dec 2017 14:39:41 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB7Ea2xd021398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:36:02 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB7Ea2tN006562
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:36:02 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 3/3] btrfs: add feature to deregister all unmounted devices
Date: Thu,  7 Dec 2017 22:36:23 +0800
Message-Id: <20171207143623.26710-4-anand.jain@oracle.com>
In-Reply-To: <20171207143623.26710-1-anand.jain@oracle.com>
References: <20171207143623.26710-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a feature to remove all registered/scanned devices,
which are not mounted or it got staled by some means.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Suggested-by: David Sterba <dsterba@suse.cz>
---
v2-4: Does not exist.

 fs/btrfs/super.c           |  7 ++++++-
 fs/btrfs/volumes.c         | 23 +++++++++++++++++++++++
 fs/btrfs/volumes.h         |  1 +
 include/uapi/linux/btrfs.h |  6 +++++-
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ea6fe4742834..409804843b74 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2213,7 +2213,12 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 					    &btrfs_fs_type, &fs_devices);
 		break;
 	case BTRFS_IOC_PURGE_DEV:
-		ret = btrfs_purge_one_device(vol->name, FMODE_READ,
+		if (vol->ioctl_flag & ~BTRFS_IOCTL_PURGE_ALL_DEVS)
+			return -EOPNOTSUPP;
+		if (vol->ioctl_flag & BTRFS_IOCTL_PURGE_ALL_DEVS)
+			ret = btrfs_purge_devices();
+		else
+			ret = btrfs_purge_one_device(vol->name, FMODE_READ,
 					    &btrfs_fs_type, &fs_devices);
 		break;
 	case BTRFS_IOC_DEVICES_READY:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5adab70c7658..9fa2539a8493 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1336,6 +1336,29 @@ int btrfs_purge_one_device(const char *path, fmode_t flags, void *holder,
 	return ret;
 }
 
+int btrfs_purge_devices(void)
+{
+	struct btrfs_fs_devices *fs_devices, *tmp;
+
+	mutex_lock(&uuid_mutex);
+	list_for_each_entry_safe(fs_devices, tmp, &fs_uuids, list) {
+		/*
+		 * For now ignore stale device within a mounted FS.
+		 */
+		if (fs_devices->opened)
+			continue;
+
+		pr_info("BTRFS: %pU num_devices %llu deregistered",
+			fs_devices->fsid, fs_devices->num_devices);
+		btrfs_sysfs_remove_fsid(fs_devices);
+		list_del(&fs_devices->list);
+		free_fs_devices(fs_devices);
+	}
+	mutex_unlock(&uuid_mutex);
+
+	return 0;
+}
+
 /*
  * Look for a btrfs signature on a device. This may be called out of the mount path
  * and we are not allowed to call set_blocksize during the scan. The superblock
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8389d2815750..dec27ee4f67d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -424,6 +424,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_purge_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
+int btrfs_purge_devices(void);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index de0f1144d945..eaf6ef04b300 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -28,8 +28,12 @@
 
 /* this should be 4k */
 #define BTRFS_PATH_NAME_MAX 4087
+#define BTRFS_IOCTL_PURGE_ALL_DEVS	(1ULL << 0)
 struct btrfs_ioctl_vol_args {
-	__s64 fd;
+	union {
+		__s64 fd;
+		__u64 ioctl_flag;
+	};
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
-- 
2.7.0

