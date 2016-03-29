Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46683 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbcC2OW7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:22:59 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 10/12] btrfs: provide framework to get and put a spare device
Date: Tue, 29 Mar 2016 22:22:27 +0800
Message-Id: <1459261349-32206-11-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
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
index 87639fa53b10..138fca39ffbb 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2164,6 +2164,15 @@ static int btrfs_control_open(struct inode *inode, struct file *file)
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
index 26ae4fd39ce7..308fcb55f2a1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7233,3 +7233,40 @@ void btrfs_force_device_close(struct btrfs_device *dev, char *why)
 		fs_devices->num_devices, fs_devices->rw_devices,
 		degrade_option ? "set":"unset");
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
index 6b3b730c2727..b9c04fdf7166 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -587,5 +587,7 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags);
 void btrfs_force_device_close(struct btrfs_device *dev, char *why);
+int btrfs_get_spare_device(char **path);
+void btrfs_put_spare_device(char *path);
 
 #endif
-- 
2.7.0

