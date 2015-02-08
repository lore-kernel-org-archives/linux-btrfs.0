Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40949 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759849AbbBIH6q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:58:46 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 23/24] Btrfs: sysfs: support seed devices in the sysfs layout
Date: Mon,  9 Feb 2015 07:56:24 +0800
Message-Id: <1423439785-10260-24-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds an enhancement to show the seed fsid and devices.

The way sprouting handles fs_devices:
      clone seed fs_devices and add to the fs_uuids
      mem copy seed fs_devices and assign to fs_devices->seed (move dev_list)
      evacuate seed fs_devices contents to hold sprout fs devices contents

  So to be inline with this fs_devices changes during seeding,
  represent seed fsid under the sprout fsid, this is achieved
  by using the kobject_move()

eg: showing two levels of seeding.

find /sys/fs/btrfs/ -type d -name devices -exec ls {} \; -print

sde
/sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/f7ef2904-ce89-4421-bfb0-49fd999e9a0b/devices
sdd
/sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/f7ef2904-ce89-4421-bfb0-49fd999e9a0b/53ac3265-0c34-4afd-9453-cc0d1a07be64/devices
sdf
/sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/devices

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |  4 +--
 fs/btrfs/disk-io.c     |  4 +--
 fs/btrfs/sysfs.c       | 66 +++++++++++++++++++++++++++++++++++---------------
 fs/btrfs/sysfs.h       |  8 +++---
 fs/btrfs/volumes.c     | 40 +++++++++++++++++++++++++-----
 5 files changed, 89 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 124b60f..e72b986 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -592,8 +592,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	mutex_unlock(&uuid_mutex);
 
 	/* replace the sysfs entry */
-	btrfs_kobj_rm_device(fs_info->fs_devices, src_device);
-	btrfs_kobj_add_device(fs_info->fs_devices, tgt_device);
+	btrfs_kobj_rm_device(fs_info->fs_devices, src_device, 0);
+	btrfs_kobj_add_device(fs_info->fs_devices, tgt_device, 0);
 	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
 
 	/* write back the superblocks */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4b7f3b8..77372af 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2785,13 +2785,13 @@ retry_root_backup:
 
 	btrfs_close_extra_devices(fs_info, fs_devices, 1);
 
-	ret = btrfs_sysfs_add_fsid(fs_devices, NULL);
+	ret = btrfs_sysfs_add_fsid(fs_devices, NULL, 1);
 	if (ret) {
 		pr_err("BTRFS: failed to init sysfs fsid interface: %d\n", ret);
 		goto fail_block_groups;
 	}
 
-	ret = btrfs_sysfs_add_device(fs_devices);
+	ret = btrfs_sysfs_add_device(fs_devices, 1);
 	if (ret) {
 		pr_err("BTRFS: failed to init sysfs device interface: %d\n", ret);
 		goto fail_fsdev_sysfs;
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index d89bf4d..f8358d2 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -517,15 +517,20 @@ static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
 
 static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 {
+	if (fs_devs->seed)
+		__btrfs_sysfs_remove_fsid(fs_devs->seed);
+
 	if (fs_devs->device_dir_kobj) {
 		kobject_del(fs_devs->device_dir_kobj);
 		kobject_put(fs_devs->device_dir_kobj);
 		fs_devs->device_dir_kobj = NULL;
 	}
 
-	kobject_del(&fs_devs->super_kobj);
-	kobject_put(&fs_devs->super_kobj);
-	wait_for_completion(&fs_devs->kobj_unregister);
+	if (fs_devs->super_kobj.state_initialized) {
+		kobject_del(&fs_devs->super_kobj);
+		kobject_put(&fs_devs->super_kobj);
+		wait_for_completion(&fs_devs->kobj_unregister);
+	}
 }
 
 /* when fs_devs is NULL it will remove all fsid kobject */
@@ -555,7 +560,7 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->fs_devices->super_kobj, &btrfs_feature_attr_group);
 	sysfs_remove_files(&fs_info->fs_devices->super_kobj, btrfs_attrs);
-	btrfs_kobj_rm_device(fs_info->fs_devices, NULL);
+	btrfs_kobj_rm_device(fs_info->fs_devices, NULL, 1);
 }
 
 const char * const btrfs_feature_set_names[3] = {
@@ -636,7 +641,7 @@ static void init_feature_attrs(void)
 /* when one_device is NULL, it removes all device links */
 
 int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
-		struct btrfs_device *one_device)
+		struct btrfs_device *one_device, int follow_seed)
 {
 	struct hd_struct *disk;
 	struct kobject *disk_kobj;
@@ -666,27 +671,39 @@ int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
 						disk_kobj->name);
 	}
 
+	if (follow_seed && fs_devices->seed)
+		btrfs_kobj_rm_device(fs_devices->seed, NULL, follow_seed);
+
 	return 0;
 }
 
-int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs)
+int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed)
 {
-	if (!fs_devs->device_dir_kobj)
-		fs_devs->device_dir_kobj = kobject_create_and_add("devices",
-						&fs_devs->super_kobj);
 
-	if (!fs_devs->device_dir_kobj)
-		return -ENOMEM;
+	while (fs_devs) {
+		if (!fs_devs->device_dir_kobj)
+			fs_devs->device_dir_kobj = kobject_create_and_add(
+					"devices", &fs_devs->super_kobj);
+
+		if (!fs_devs->device_dir_kobj)
+			return -ENOMEM;
+
+		if (!follow_seed)
+			return 0;
+
+		fs_devs = fs_devs->seed;
+	}
 
 	return 0;
 }
 
 int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
-				struct btrfs_device *one_device)
+			struct btrfs_device *one_device, int follow_seed)
 {
 	int error = 0;
 	struct btrfs_device *dev;
 
+again:
 	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
 		struct hd_struct *disk;
 		struct kobject *disk_kobj;
@@ -706,6 +723,11 @@ int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
 			break;
 	}
 
+	if (follow_seed && fs_devices->seed) {
+		fs_devices = fs_devices->seed;
+		goto again;
+	}
+
 	return error;
 }
 
@@ -723,14 +745,20 @@ u64 btrfs_debugfs_test;
  * And parent can be specified for seed device
  */
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
-				struct kobject *parent)
+				struct kobject *parent, int follow_seed)
 {
-	int error;
+	int error = 0;
 
-	init_completion(&fs_devs->kobj_unregister);
-	fs_devs->super_kobj.kset = btrfs_kset;
-	error = kobject_init_and_add(&fs_devs->super_kobj,
+	while (fs_devs) {
+		init_completion(&fs_devs->kobj_unregister);
+		fs_devs->super_kobj.kset = btrfs_kset;
+		error = kobject_init_and_add(&fs_devs->super_kobj,
 				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
+		if (!follow_seed)
+			return error;
+		parent = &fs_devs->super_kobj;
+		fs_devs = fs_devs->seed;
+	}
 	return error;
 }
 
@@ -742,13 +770,13 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 
 	fs_devs->fs_info = fs_info;
 
-	error = btrfs_kobj_add_device(fs_devs, NULL);
+	error = btrfs_kobj_add_device(fs_devs, NULL, 1);
 	if (error)
 		return error;
 
 	error = sysfs_create_files(super_kobj, btrfs_attrs);
 	if (error) {
-		btrfs_kobj_rm_device(fs_devs, NULL);
+		btrfs_kobj_rm_device(fs_devs, NULL, 0);
 		return error;
 	}
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 2b31f6f..59e7dba 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -71,11 +71,11 @@ extern const char * const btrfs_feature_set_names[3];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
 int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
-		struct btrfs_device *one_device);
+		struct btrfs_device *one_device, int follow_seed);
 int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
-                struct btrfs_device *one_device);
+                struct btrfs_device *one_device, int follow_seed);
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
-				struct kobject *parent);
-int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
+				struct kobject *parent, int follow_seed);
+int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1490723..9e87143 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
+#include <linux/kobject.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -1701,7 +1702,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->bdev) {
 		device->fs_devices->open_devices--;
 		/* remove sysfs entry */
-		btrfs_kobj_rm_device(root->fs_info->fs_devices, device);
+		btrfs_kobj_rm_device(root->fs_info->fs_devices, device, 0);
 	}
 
 	call_rcu(&device->rcu, free_device);
@@ -1979,11 +1980,15 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 
 	memcpy(seed_devices, fs_devices, sizeof(*seed_devices));
 	seed_devices->opened = 1;
+	seed_devices->device_dir_kobj = NULL;
+	memset(&seed_devices->super_kobj, 0, sizeof(struct kobject));
+	memset(&seed_devices->kobj_unregister, 0, sizeof(struct completion));
 	INIT_LIST_HEAD(&seed_devices->devices);
 	INIT_LIST_HEAD(&seed_devices->alloc_list);
 	mutex_init(&seed_devices->device_list_mutex);
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	btrfs_kobj_rm_device(fs_devices, NULL, 0);
 	list_splice_init_rcu(&fs_devices->devices, &seed_devices->devices,
 			      synchronize_rcu);
 	list_for_each_entry(device, &seed_devices->devices, dev_list)
@@ -2206,7 +2211,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 				    tmp + 1);
 
 	/* add sysfs device entry */
-	btrfs_kobj_add_device(root->fs_info->fs_devices, device);
+	btrfs_kobj_add_device(root->fs_info->fs_devices, device, 0);
 
 	/*
 	 * we've got more storage, clear any full flags on the space
@@ -2235,6 +2240,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 	if (seeding_dev) {
 		char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
+		struct btrfs_fs_devices *fs_devs = root->fs_info->fs_devices;
 
 		ret = btrfs_finish_sprout(trans, root);
 		if (ret) {
@@ -2242,15 +2248,37 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 			goto error_trans;
 		}
 
-		/* Sprouting would change fsid of the mounted root,
+		/*
+		 * Sprouting would change fsid of the mounted root,
 		 * so rename the fsid on the sysfs
 		 */
 		snprintf(fsid_buf, BTRFS_UUID_UNPARSED_SIZE, "%pU",
 						root->fs_info->fsid);
-		if (kobject_rename(&root->fs_info->fs_devices->super_kobj,
-								fsid_buf))
+		if (!kobject_rename(&fs_devs->super_kobj, fsid_buf)) {
+			struct btrfs_fs_devices *seed_devs;
+
+			seed_devs = fs_devs->seed;
+
+			/* Create the seed fsid inside the sprout fsid */
+
+			btrfs_sysfs_add_fsid(seed_devs, &fs_devs->super_kobj, 0);
+			btrfs_sysfs_add_device(seed_devs, 0);
+			btrfs_kobj_add_device(seed_devs, NULL, 0);
+
+			/*
+			 * If this is a nested seed, that is if there is seed's
+			 * seed device then move that inside its seed device.
+			 */
+			if (seed_devs->seed) {
+				if (kobject_move(&seed_devs->seed->super_kobj,
+							&seed_devs->super_kobj))
+					printk(KERN_WARNING\
+						"Btrfs: sysfs: kobject move failed\n");
+			}
+		} else {
 			printk(KERN_WARNING\
 			"BTRFS: sysfs: failed to create fsid for sprout\n");
+		}
 	}
 
 	root->fs_info->num_tolerated_disk_barrier_failures =
@@ -2286,7 +2314,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 error_trans:
 	btrfs_end_transaction(trans, root);
 	rcu_string_free(device->name);
-	btrfs_kobj_rm_device(root->fs_info->fs_devices, device);
+	btrfs_kobj_rm_device(root->fs_info->fs_devices, device, 0);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.0.0.153.g79dcccc

