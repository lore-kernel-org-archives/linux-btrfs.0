Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31057 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaESRCa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 13:02:30 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s4JH2SSx006338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:02:29 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4JH2Sd9006956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:02:28 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4JH2RtF012872
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:02:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: revamp /sys/fs/btrfs/<fsid>/devices
Date: Tue, 20 May 2014 01:05:22 +0800
Message-Id: <1400519122-5620-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now with out this patch the content under the
dir /sys/fs/btrfs/<fsid>/devices is just links to the
block devs.

Moving forward we would need the above btrfs sysfs path
to contain more info about the btrfs devices.

This patch provide a framework and as of now a fault
notification interface, which is needed to notify when
disk disappear.

The idea is to call
  /sys/fs/btrfs/<fsid>/devices/<disk>/fault
when we get a kobject notification about the disk
disappearance.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c   | 110 +++++++++++++++++++++++++++++++++++++++++------------
 fs/btrfs/sysfs.h   |   3 ++
 fs/btrfs/volumes.c |   5 +++
 fs/btrfs/volumes.h |   2 +
 4 files changed, 96 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index f729199..7c80a99 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -31,6 +31,7 @@
 #include "transaction.h"
 #include "sysfs.h"
 #include "volumes.h"
+#include "rcu-string.h"
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
 
@@ -475,19 +476,6 @@ static void __btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 	wait_for_completion(&fs_info->kobj_unregister);
 }
 
-void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
-{
-	if (fs_info->space_info_kobj) {
-		sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
-		kobject_del(fs_info->space_info_kobj);
-		kobject_put(fs_info->space_info_kobj);
-	}
-	kobject_del(fs_info->device_dir_kobj);
-	kobject_put(fs_info->device_dir_kobj);
-	addrm_unknown_feature_attrs(fs_info, false);
-	sysfs_remove_group(&fs_info->super_kobj, &btrfs_feature_attr_group);
-	__btrfs_sysfs_remove_one(fs_info);
-}
 
 const char * const btrfs_feature_set_names[3] = {
 	[FEAT_COMPAT]	 = "compat",
@@ -564,36 +552,91 @@ static void init_feature_attrs(void)
 	}
 }
 
-static int add_device_membership(struct btrfs_fs_info *fs_info)
+
+#define to_btrfs_device(_kobj) container_of(_kobj, struct btrfs_device, device_kobj)
+
+static ssize_t device_kobj_fault_store(struct kobject *dev_kobj,
+			struct kobj_attribute *a, const char *buf, size_t len)
+{
+	struct btrfs_device *dev = to_btrfs_device(dev_kobj);
+
+	if (dev->missing || !dev->bdev)
+		return -EINVAL;
+
+	/* Fixme: Call appropriate device check status handler */
+
+        return len;
+}
+
+BTRFS_ATTR_RW(fault, 0200, NULL, device_kobj_fault_store);
+
+static struct attribute *device_kobj_attrs[] = {
+	BTRFS_ATTR_PTR(fault),
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
+int device_add_kobject(struct btrfs_fs_info *fs_info)
 {
 	int error = 0;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *dev;
 
-	fs_info->device_dir_kobj = kobject_create_and_add("devices",
+	if (!fs_info->device_dir_kobj)
+		fs_info->device_dir_kobj = kobject_create_and_add("devices",
 						&fs_info->super_kobj);
 	if (!fs_info->device_dir_kobj)
 		return -ENOMEM;
 
 	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
-		struct hd_struct *disk;
-		struct kobject *disk_kobj;
 
-		if (!dev->bdev)
+		if (!dev->bdev || dev->missing || dev->device_kobj.parent)
 			continue;
 
-		disk = dev->bdev->bd_part;
-		disk_kobj = &part_to_dev(disk)->kobj;
+		error = kobject_init_and_add(&dev->device_kobj, &device_ktype,
+			fs_info->device_dir_kobj, "%s",
+			strrchr(rcu_str_deref(dev->name), '/') + 1);
 
-		error = sysfs_create_link(fs_info->device_dir_kobj,
-					  disk_kobj, disk_kobj->name);
 		if (error)
 			break;
 	}
-
 	return error;
 }
 
+/*
+ * Remove the sysfs entries for the devices.
+ * devid provides a perticular devid for which the sysfs entry
+ * has to be removed, if -1 it would remove for all devs
+ */
+void device_rm_kobject(struct btrfs_fs_info *fs_info, u64 devid)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *dev;
+
+	if (!fs_info->device_dir_kobj)
+		return;
+
+	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
+		if (!dev->device_kobj.parent)
+			continue;
+
+		if (devid == -1 || devid == dev->devid) {
+			kobject_del(&dev->device_kobj);
+			kobject_put(&dev->device_kobj);
+		}
+	}
+}
+
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
@@ -603,6 +646,25 @@ static struct dentry *btrfs_debugfs_root_dentry;
 /* Debugging tunables and exported data */
 u64 btrfs_debugfs_test;
 
+void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
+{
+	if (fs_info->space_info_kobj) {
+		sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
+		kobject_del(fs_info->space_info_kobj);
+		kobject_put(fs_info->space_info_kobj);
+	}
+
+	if (fs_info->device_dir_kobj) {
+		device_rm_kobject(fs_info, -1);
+		kobject_del(fs_info->device_dir_kobj);
+		kobject_put(fs_info->device_dir_kobj);
+	}
+
+	addrm_unknown_feature_attrs(fs_info, false);
+	sysfs_remove_group(&fs_info->super_kobj, &btrfs_feature_attr_group);
+	__btrfs_sysfs_remove_one(fs_info);
+}
+
 int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 {
 	int error;
@@ -625,7 +687,7 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 	if (error)
 		goto failure;
 
-	error = add_device_membership(fs_info);
+	error = device_add_kobject(fs_info);
 	if (error)
 		goto failure;
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 9ab5763..ff4b87b 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -66,4 +66,7 @@ char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 extern const char * const btrfs_feature_set_names[3];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
+
+int device_add_kobject(struct btrfs_fs_info *fs_info);
+void device_rm_kobject(struct btrfs_fs_info *fs_info, u64 devid);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index db211fd..27dfbb4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -40,6 +40,7 @@
 #include "rcu-string.h"
 #include "math.h"
 #include "dev-replace.h"
+#include "sysfs.h"
 
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -1633,6 +1634,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 	cur_devices = device->fs_devices;
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+
+	device_rm_kobject(root->fs_info, device->devid);
+
 	list_del_rcu(&device->dev_list);
 
 	device->fs_devices->num_devices--;
@@ -2129,6 +2133,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 			btrfs_abort_transaction(trans, root, ret);
 			goto error_trans;
 		}
+		device_add_kobject(root->fs_info);
 	}
 
 	/*
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 4ca67b3..a434611 100644
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

