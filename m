Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28294 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbbJFPFt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 11:05:49 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2, RESEND] Btrfs: sysfs: support seed devices in the sysfs layout
Date: Tue,  6 Oct 2015 23:05:31 +0800
Message-Id: <1444143932-2139-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds an enhancement to show the seed fsid and its devices
on the btrfs sysfs.

The way sprouting handles fs_devices:
      clone seed fs_devices and add to the fs_uuids
      mem copy seed fs_devices and assign to fs_devices->seed (move dev_list)
      evacuate seed fs_devices contents to hold sprout fs devices contents

  So to be inline with this fs_devices changes during seeding,
  represent seed fsid under the sprout fsid, this is achieved
  by using the kobject_move()
  The end result will be,
    /sys/fs/btrfs/sprout-fsid/seed/level-1-seed-fsid/seed/(if)level-2-seed-fsid

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |   7 ++-
 fs/btrfs/disk-io.c     |   6 +-
 fs/btrfs/sysfs.c       | 150 +++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/sysfs.h       |  12 ++--
 fs/btrfs/volumes.c     |  26 ++++-----
 fs/btrfs/volumes.h     |   1 +
 6 files changed, 160 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 0978e52..3a1a920 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -397,7 +397,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 	btrfs_dev_replace_unlock(dev_replace);
 
-	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
+	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device, 0);
 	if (ret)
 		btrfs_err(root->fs_info, "kobj add dev failed %d\n", ret);
 
@@ -586,7 +586,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	mutex_unlock(&uuid_mutex);
 
 	/* replace the sysfs entry */
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, src_device);
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, src_device, 0);
+	if (src_device->fs_devices->seeding &&
+				!src_device->fs_devices->num_devices)
+		btrfs_sysfs_remove_fsid(src_device->fs_devices);
 	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
 
 	/* write back the superblocks */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1b72cb5..ac1e168 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2922,13 +2922,13 @@ retry_root_backup:
 
 	btrfs_close_extra_devices(fs_devices, 1);
 
-	ret = btrfs_sysfs_add_fsid(fs_devices, NULL);
-	if (ret) {
+	ret = btrfs_sysfs_add_fsid(fs_devices, NULL, 1);
+	if (ret && ret != -EEXIST) {
 		pr_err("BTRFS: failed to init sysfs fsid interface: %d\n", ret);
 		goto fail_block_groups;
 	}
 
-	ret = btrfs_sysfs_add_device(fs_devices);
+	ret = btrfs_sysfs_add_device(fs_devices, 1);
 	if (ret) {
 		pr_err("BTRFS: failed to init sysfs device interface: %d\n", ret);
 		goto fail_fsdev_sysfs;
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index e0ac859..3a45462 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -517,6 +517,11 @@ static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
 
 static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 {
+	if (fs_devs->seed) {
+		__btrfs_sysfs_remove_fsid(fs_devs->seed);
+		btrfs_sysfs_rm_seed_dir(fs_devs);
+	}
+
 	if (fs_devs->device_dir_kobj) {
 		kobject_del(fs_devs->device_dir_kobj);
 		kobject_put(fs_devs->device_dir_kobj);
@@ -557,7 +562,7 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->fs_devices->fsid_kobj, &btrfs_feature_attr_group);
 	sysfs_remove_files(&fs_info->fs_devices->fsid_kobj, btrfs_attrs);
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL);
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL, 1);
 }
 
 const char * const btrfs_feature_set_names[3] = {
@@ -638,7 +643,7 @@ static void init_feature_attrs(void)
 /* when one_device is NULL, it removes all device links */
 
 int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
-		struct btrfs_device *one_device)
+		struct btrfs_device *one_device, int follow_seed)
 {
 	struct hd_struct *disk;
 	struct kobject *disk_kobj;
@@ -668,27 +673,38 @@ int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
 						disk_kobj->name);
 	}
 
+	if (follow_seed && fs_devices->seed)
+		btrfs_sysfs_rm_device_link(fs_devices->seed, NULL, follow_seed);
+
 	return 0;
 }
 
-int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs)
+int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed)
 {
-	if (!fs_devs->device_dir_kobj)
-		fs_devs->device_dir_kobj = kobject_create_and_add("devices",
-						&fs_devs->fsid_kobj);
+	while (fs_devs) {
+		if (!fs_devs->device_dir_kobj)
+			fs_devs->device_dir_kobj = kobject_create_and_add(
+					"devices", &fs_devs->fsid_kobj);
 
-	if (!fs_devs->device_dir_kobj)
-		return -ENOMEM;
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
 
 int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
-				struct btrfs_device *one_device)
+			struct btrfs_device *one_device, int follow_seed)
 {
 	int error = 0;
 	struct btrfs_device *dev;
 
+again:
 	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
 		struct hd_struct *disk;
 		struct kobject *disk_kobj;
@@ -708,9 +724,37 @@ int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 			break;
 	}
 
+	if (follow_seed && fs_devices->seed) {
+		fs_devices = fs_devices->seed;
+		goto again;
+	}
+
 	return error;
 }
 
+void btrfs_sysfs_rm_seed_dir(struct btrfs_fs_devices *fs_devs)
+{
+	if (fs_devs->seed_dir_kobj) {
+		kobject_del(fs_devs->seed_dir_kobj);
+		kobject_put(fs_devs->seed_dir_kobj);
+		fs_devs->seed_dir_kobj = NULL;
+	}
+}
+
+int btrfs_sysfs_add_seed_dir(struct btrfs_fs_devices *fs_devs)
+{
+	if (!fs_devs->seed_dir_kobj)
+		fs_devs->seed_dir_kobj = kobject_create_and_add(
+					"seed", &fs_devs->fsid_kobj);
+
+	if (!fs_devs->seed_dir_kobj)
+		return -ENOMEM;
+
+	BUG_ON(!fs_devs->seed_dir_kobj->state_initialized);
+
+	return 0;
+}
+
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
@@ -725,15 +769,29 @@ u64 btrfs_debugfs_test;
  * And parent can be specified for seed device
  */
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
-				struct kobject *parent)
+				struct kobject *parent, int follow_seed)
 {
-	int error;
+	int error = 0;
 
-	init_completion(&fs_devs->kobj_unregister);
-	fs_devs->fsid_kobj.kset = btrfs_kset;
-	error = kobject_init_and_add(&fs_devs->fsid_kobj,
-				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
-	return error;
+add_seed:
+	if (!fs_devs->fsid_kobj.state_initialized) {
+		init_completion(&fs_devs->kobj_unregister);
+		fs_devs->fsid_kobj.kset = btrfs_kset;
+		error = kobject_init_and_add(&fs_devs->fsid_kobj,
+			&btrfs_ktype, parent, "%pU", fs_devs->fsid);
+	} else {
+		error = -EEXIST;
+	}
+
+	if (!follow_seed || !fs_devs->seed)
+		return error;
+
+	btrfs_sysfs_add_seed_dir(fs_devs);
+
+	parent = fs_devs->seed_dir_kobj;
+	fs_devs = fs_devs->seed;
+
+	goto add_seed;
 }
 
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
@@ -744,13 +802,13 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 
 	btrfs_set_fs_info_ptr(fs_info);
 
-	error = btrfs_sysfs_add_device_link(fs_devs, NULL);
+	error = btrfs_sysfs_add_device_link(fs_devs, NULL, 1);
 	if (error)
 		return error;
 
 	error = sysfs_create_files(fsid_kobj, btrfs_attrs);
 	if (error) {
-		btrfs_sysfs_rm_device_link(fs_devs, NULL);
+		btrfs_sysfs_rm_device_link(fs_devs, NULL, 0);
 		return error;
 	}
 
@@ -826,3 +884,59 @@ void btrfs_exit_sysfs(void)
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 }
 
+void btrfs_sysfs_prepare_sprout_reset(void)
+{
+	/* close call would anyway cleanup */
+}
+
+void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
+				struct btrfs_fs_devices *seed_devices)
+{
+	char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
+
+	/*
+	 * Sprouting has changed fsid of the mounted root,
+	 * so rename the fsid on the sysfs
+	 */
+	snprintf(fsid_buf, BTRFS_UUID_UNPARSED_SIZE, "%pU", fs_devices->fsid);
+	if (kobject_rename(&fs_devices->fsid_kobj, fsid_buf)) {
+		pr_warn("Btrfs: sysfs: kobject rename failed\n");
+	}
+
+	/*
+	 * Create the seed fsid inside the sprout fsid
+	 * but should not create devices dir, instead
+	 * move it from the original fs_devices
+	 */
+	memset(&seed_devices->fsid_kobj, 0, sizeof(struct kobject));
+	seed_devices->device_dir_kobj = NULL;
+	memset(&seed_devices->kobj_unregister, 0,
+					sizeof(struct completion));
+	seed_devices->seed_dir_kobj = NULL;
+
+	if (!fs_devices->seed_dir_kobj)
+		btrfs_sysfs_add_seed_dir(fs_devices);
+
+	btrfs_sysfs_add_fsid(seed_devices, fs_devices->seed_dir_kobj, 0);
+
+	if (kobject_move(fs_devices->device_dir_kobj,
+					&seed_devices->fsid_kobj))
+		pr_warn("Btrfs: sysfs: dev kobject move failed\n");
+
+	seed_devices->device_dir_kobj = fs_devices->device_dir_kobj;
+	fs_devices->device_dir_kobj = NULL;
+	btrfs_sysfs_add_device(fs_devices, 0);
+
+	/*
+	 * the kobj dev and devices attribute will be created
+	 * in the main function as part of the init_new_device
+	 * If this is a nested seed, that is if there is seed's
+	 * seed device then move that one level deep.
+	 */
+	if (seed_devices->seed) {
+		btrfs_sysfs_add_seed_dir(seed_devices);
+		if (kobject_move(&seed_devices->seed->fsid_kobj,
+					seed_devices->seed_dir_kobj))
+			pr_warn("Btrfs: sysfs: kobject move failed\n");
+	}
+}
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 9c09522..5ace289 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -83,11 +83,15 @@ extern const char * const btrfs_feature_set_names[3];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
 int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
-		struct btrfs_device *one_device);
+		struct btrfs_device *one_device, int follow_seed);
 int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
-                struct btrfs_device *one_device);
+                struct btrfs_device *one_device, int follow_seed);
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
-				struct kobject *parent);
-int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
+				struct kobject *parent, int follow_seed);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
+int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed);
+int btrfs_sysfs_add_seed_dir(struct btrfs_fs_devices *fs_devs);
+void btrfs_sysfs_rm_seed_dir(struct btrfs_fs_devices *fs_devs);
+void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
+				struct btrfs_fs_devices *seed_devices);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 893c0e8..227f4be 100644
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
@@ -1787,7 +1788,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->bdev) {
 		device->fs_devices->open_devices--;
 		/* remove sysfs entry */
-		btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device);
+		btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device, 0);
 	}
 
 	call_rcu(&device->rcu, free_device);
@@ -1958,7 +1959,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	WARN_ON(!tgtdev);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, tgtdev);
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, tgtdev, 0);
 
 	if (tgtdev->bdev) {
 		btrfs_scratch_superblocks(tgtdev->bdev,
@@ -2087,6 +2088,9 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	fs_devices->open_devices = 0;
 	fs_devices->missing_devices = 0;
 	fs_devices->rotating = 0;
+	if (fs_devices->seed)
+		seed_devices->seed = fs_devices->seed;
+
 	fs_devices->seed = seed_devices;
 
 	generate_random_uuid(fs_devices->fsid);
@@ -2098,6 +2102,8 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 		      ~BTRFS_SUPER_FLAG_SEEDING;
 	btrfs_set_super_flags(disk_super, super_flags);
 
+	btrfs_sysfs_prepare_sprout(fs_devices, seed_devices);
+
 	return 0;
 }
 
@@ -2295,7 +2301,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 				    tmp + 1);
 
 	/* add sysfs device entry */
-	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device);
+	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device, 0);
 
 	/*
 	 * we've got more storage, clear any full flags on the space
@@ -2323,22 +2329,11 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 
 	if (seeding_dev) {
-		char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
-
 		ret = btrfs_finish_sprout(trans, root);
 		if (ret) {
 			btrfs_abort_transaction(trans, root, ret);
 			goto error_trans;
 		}
-
-		/* Sprouting would change fsid of the mounted root,
-		 * so rename the fsid on the sysfs
-		 */
-		snprintf(fsid_buf, BTRFS_UUID_UNPARSED_SIZE, "%pU",
-						root->fs_info->fsid);
-		if (kobject_rename(&root->fs_info->fs_devices->fsid_kobj,
-								fsid_buf))
-			pr_warn("BTRFS: sysfs: failed to create fsid for sprout\n");
 	}
 
 	root->fs_info->num_tolerated_disk_barrier_failures =
@@ -2374,7 +2369,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 error_trans:
 	btrfs_end_transaction(trans, root);
 	rcu_string_free(device->name);
-	btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device);
+	btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device, 0);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
@@ -6227,6 +6222,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_root *root,
 
 	fs_devices->seed = root->fs_info->fs_devices->seed;
 	root->fs_info->fs_devices->seed = fs_devices;
+
 out:
 	return fs_devices;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 38450dc..a6e3b37 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -246,6 +246,7 @@ struct btrfs_fs_devices {
 
 	struct btrfs_fs_devices *seed;
 	int seeding;
+	struct kobject *seed_dir_kobj;
 
 	int opened;
 
-- 
2.4.1

