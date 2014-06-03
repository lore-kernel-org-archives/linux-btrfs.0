Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24382 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaFCDgl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 23:36:41 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 6/6 RFC v2] btrfs: revamp /sys/fs/btrfs/<fsid>/devices
Date: Tue,  3 Jun 2014 11:36:04 +0800
Message-Id: <1401766564-7381-7-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>

From: Anand Jain <anand.jain@oracle.com>

As of now with out this patch the sysfs interface under dir
/sys/fs/btrfs/<fsid>/devices is just link to the block devs.

Moving forward we would need the above btrfs sysfs path to contain more
info about the btrfs devices. So this patch provides a framework for
the same.

And as of now a probe interface is added, which can be used to notify
btrfs for any change in the device status.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
  V2: On the 2nd thought I kept the device link, but under the device name.
      eg: /sys/fs/btrfs/<fsid>/devices/<sdx>/sdx-> link to blk device
          /sys/fs/btrfs/<fsid>/devices/<sdx>/probe
      and commit update accordingly

 fs/btrfs/sysfs.c   | 73 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.h |  2 ++
 2 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 9733cfc..92fb3bb 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -31,8 +31,11 @@
 #include "transaction.h"
 #include "sysfs.h"
 #include "volumes.h"
+#include "rcu-string.h"
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
+int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
+		struct btrfs_device *one_device);
 
 static u64 get_features(struct btrfs_fs_info *fs_info,
 			enum btrfs_feature_set set)
@@ -490,8 +493,13 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 		kobject_del(fs_info->space_info_kobj);
 		kobject_put(fs_info->space_info_kobj);
 	}
-	kobject_del(fs_info->device_dir_kobj);
-	kobject_put(fs_info->device_dir_kobj);
+
+	if (fs_info->device_dir_kobj) {
+		btrfs_kobj_rm_device(fs_info, NULL);
+		kobject_del(fs_info->device_dir_kobj);
+		kobject_put(fs_info->device_dir_kobj);
+	}
+
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->super_kobj, &btrfs_feature_attr_group);
 	__btrfs_sysfs_remove_one(fs_info);
@@ -577,21 +585,68 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
 {
 	struct hd_struct *disk;
 	struct kobject *disk_kobj;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *dev;
 
 	if (!fs_info->device_dir_kobj)
 		return -EINVAL;
 
 	if (one_device) {
+		if (!one_device->device_kobj.parent)
+			return -EINVAL;
+
 		disk = one_device->bdev->bd_part;
 		disk_kobj = &part_to_dev(disk)->kobj;
 
-		sysfs_remove_link(fs_info->device_dir_kobj,
+		sysfs_remove_link(&one_device->device_kobj,
 						disk_kobj->name);
+		kobject_del(&one_device->device_kobj);
+		kobject_put(&one_device->device_kobj);
+		return 0;
 	}
 
+	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
+		if (!dev->device_kobj.parent)
+			continue;
+
+		disk = dev->bdev->bd_part;
+		disk_kobj = &part_to_dev(disk)->kobj;
+
+		sysfs_remove_link(&dev->device_kobj, disk_kobj->name);
+		kobject_del(&dev->device_kobj);
+		kobject_put(&dev->device_kobj);
+	}
 	return 0;
 }
 
+#define to_btrfs_device(_kobj) container_of(_kobj, struct btrfs_device, device_kobj)
+
+static ssize_t device_kobj_probe_store(struct kobject *dev_kobj,
+			struct kobj_attribute *a, const char *buf, size_t len)
+{
+	/* Fixme: Call appropriate device check status handler */
+
+        return len;
+}
+
+BTRFS_ATTR_RW(probe, 0200, NULL, device_kobj_probe_store);
+
+static struct attribute *device_kobj_attrs[] = {
+	BTRFS_ATTR_PTR(probe),
+	NULL,
+};
+
+static void device_kobj_release(struct kobject *dev_kobj)
+{
+	/* nothing to free as of now */
+}
+
+struct kobj_type device_ktype = {
+	.sysfs_ops	= &kobj_sysfs_ops,
+	.release	= device_kobj_release,
+	.default_attrs	= device_kobj_attrs,
+};
+
 int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
 		struct btrfs_device *one_device)
 {
@@ -610,19 +665,25 @@ int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
 		struct hd_struct *disk;
 		struct kobject *disk_kobj;
 
-		if (!dev->bdev)
+		if (!dev->bdev || dev->missing || dev->device_kobj.parent)
 			continue;
 
 		if (one_device && one_device != dev)
 			continue;
 
+		error = kobject_init_and_add(&dev->device_kobj, &device_ktype,
+				fs_info->device_dir_kobj, "%s",
+				strrchr(rcu_str_deref(dev->name), '/') + 1);
+		if (error)
+			break;
+
 		disk = dev->bdev->bd_part;
 		disk_kobj = &part_to_dev(disk)->kobj;
-
-		error = sysfs_create_link(fs_info->device_dir_kobj,
+		error = sysfs_create_link(&dev->device_kobj,
 					  disk_kobj, disk_kobj->name);
 		if (error)
 			break;
+
 	}
 
 	return error;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 25f0505..d0c9c32 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -113,6 +113,8 @@ struct btrfs_device {
 	int dev_stats_valid;
 	int dev_stats_dirty; /* counters need to be written to disk */
 	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
+
+	struct kobject device_kobj;
 };
 
 struct btrfs_fs_devices {
-- 
1.8.5.3

