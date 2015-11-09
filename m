Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbbKIK5t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:49 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvmCx014246
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Avmg7004902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:48 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Avmf0003541
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:48 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/15] btrfs: provide framework to get and put a spare device
Date: Mon,  9 Nov 2015 18:56:27 +0800
Message-Id: <1447066589-3835-14-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds functions to get and put a spare device from the list.
So that hot repace code can pick a spare device when needed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c   |  9 +++++++++
 fs/btrfs/volumes.c | 37 +++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  2 ++
 3 files changed, 48 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d495790..29836ca 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2035,6 +2035,15 @@ static int btrfs_control_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+void btrfs_put_spare_device(char *path)
+{
+	struct btrfs_fs_devices *fs_devices;
+
+	if (btrfs_scan_one_device(path, FMODE_READ,
+				    &btrfs_fs_type, &fs_devices))
+		printk(KERN_INFO "failed to return spare device\n");
+}
+
 /*
  * used by btrfsctl to scan devices when no FS is mounted
  */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 28f549d..3b90690 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7017,3 +7017,40 @@ void btrfs_force_device_close(struct btrfs_device *dev, char *why)
 		rcu_str_deref(dev->name), why);
 	rcu_read_unlock();
 }
+
+int btrfs_get_spare_device(char **path)
+{
+	int ret = 1;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
+	struct list_head *fs_uuids = btrfs_get_fs_uuids();
+
+	mutex_lock(&uuid_mutex);
+	list_for_each_entry(fs_devices, fs_uuids, list) {
+		if (!fs_devices->spare)
+			continue;
+
+		/* as of now there is only one device in the spare fs_devices */
+		device = list_entry(fs_devices->devices.next,
+					struct btrfs_device, dev_list);
+
+		if (!device || !device->name)
+			continue;
+
+		fs_devices->spare = 0;
+		rcu_read_lock();
+		*path = kstrdup(device->name->str, GFP_NOFS);
+		rcu_read_unlock();
+		ret = 0;
+		break;
+	}
+
+	if (!ret) {
+		btrfs_sysfs_remove_fsid(fs_devices);
+		list_del(&fs_devices->list);
+		free_fs_devices(fs_devices);
+	}
+	mutex_unlock(&uuid_mutex);
+
+	return ret;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 3d995b7..36184ec 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -577,5 +577,7 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_close_one_device(struct btrfs_device *device);
 int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags);
 void btrfs_force_device_close(struct btrfs_device *dev, char *why);
+int btrfs_get_spare_device(char **path);
+void btrfs_put_spare_device(char *path);
 
 #endif
-- 
2.4.1

