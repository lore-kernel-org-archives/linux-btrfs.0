Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20409 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbbCIRLA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:11:00 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 25/26] Btrfs: sysfs: support seed devices in the sysfs layout v3
Date: Tue, 10 Mar 2015 06:38:43 +0800
Message-Id: <1425940724-7744-26-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
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
  The end result will be,
    /sys/fs/btrfs/sprout-fsid/level-1-seed-fsid/(if)level-2-seed-fsid

eg: showing two levels of seeding.

find /sys/fs/btrfs/ -type d -name devices -exec ls {} \; -print

sde
/sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/f7ef2904-ce89-4421-bfb0-49fd999e9a0b/devices
sdd
/sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/f7ef2904-ce89-4421-bfb0-49fd999e9a0b/53ac3265-0c34-4afd-9453-cc0d1a07be64/devices
sdf
/sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/devices

Signed-off-by: Anand Jain <anand.jain@oracle.com>

Btrfs: sysfs: add check if super kobject is already initialized

v2: when kobject is already created return EEXIST
v3: squash with patch 25

Signed-off-by: Anand Jain <anand.jain@oracle.com>

Btrfs: rename btrfs_kobj_add/rm_device

rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link
rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link

Signed-off-by: Anand Jain <anand.jain@oracle.com>

Btrfs: rearrange code for easy readability

no logical change

Signed-off-by: Anand Jain <anand.jain@oracle.com>

Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted

rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted

rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h       |   4 +-
 fs/btrfs/dev-replace.c |   4 +-
 fs/btrfs/disk-io.c     |  12 +--
 fs/btrfs/sysfs.c       | 207 ++++++++++++++++++++++++++++++++++---------------
 fs/btrfs/sysfs.h       |  14 ++--
 fs/btrfs/volumes.c     |  26 +++----
 6 files changed, 172 insertions(+), 95 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9493b91..5f25607 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3976,8 +3976,8 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 /* sysfs.c */
 int btrfs_init_sysfs(void);
 void btrfs_exit_sysfs(void);
-int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info);
-void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info);
+int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
+void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 
 /* xattr.c */
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index f06390b..61d183b 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -376,7 +376,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	WARN_ON(!tgt_device);
 	dev_replace->tgtdev = tgt_device;
 
-	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
+	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device, 0);
 	if (ret)
 		btrfs_error(root->fs_info, ret, "kobj add dev failed");
 
@@ -596,7 +596,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	mutex_unlock(&uuid_mutex);
 
 	/* replace the sysfs entry */
-	btrfs_kobj_rm_device(fs_info->fs_devices, src_device);
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, src_device, 0);
 	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
 
 	/* write back the superblocks */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4b7f3b8..4b19e41 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2785,19 +2785,19 @@ retry_root_backup:
 
 	btrfs_close_extra_devices(fs_info, fs_devices, 1);
 
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
 	}
 
-	ret = btrfs_sysfs_add_one(fs_info);
+	ret = btrfs_sysfs_add_mounted(fs_info);
 	if (ret) {
 		pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
 		goto fail_fsdev_sysfs;
@@ -3012,7 +3012,7 @@ fail_cleaner:
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
 
 fail_sysfs:
-	btrfs_sysfs_remove_one(fs_info);
+	btrfs_sysfs_remove_mounted(fs_info);
 
 fail_fsdev_sysfs:
 	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
@@ -3693,7 +3693,7 @@ void close_ctree(struct btrfs_root *root)
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
-	btrfs_sysfs_remove_one(fs_info);
+	btrfs_sysfs_remove_mounted(fs_info);
 	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
 
 	btrfs_free_fs_roots(fs_info);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 51e2fae..e1b4f95 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -515,49 +515,6 @@ static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
 	return 0;
 }
 
-static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
-{
-	if (fs_devs->device_dir_kobj) {
-		kobject_del(fs_devs->device_dir_kobj);
-		kobject_put(fs_devs->device_dir_kobj);
-		fs_devs->device_dir_kobj = NULL;
-	}
-
-	kobject_del(&fs_devs->super_kobj);
-	kobject_put(&fs_devs->super_kobj);
-	wait_for_completion(&fs_devs->kobj_unregister);
-}
-
-/* when fs_devs is NULL it will remove all fsid kobject */
-void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
-{
-	struct list_head *fs_uuids = btrfs_get_fs_uuids();
-
-	if (fs_devs) {
-		__btrfs_sysfs_remove_fsid(fs_devs);
-		return;
-	}
-
-	list_for_each_entry(fs_devs, fs_uuids, list) {
-		__btrfs_sysfs_remove_fsid(fs_devs);
-	}
-}
-
-void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
-{
-	btrfs_reset_fs_info_ptr(fs_info);
-
-	if (fs_info->space_info_kobj) {
-		sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
-		kobject_del(fs_info->space_info_kobj);
-		kobject_put(fs_info->space_info_kobj);
-	}
-	addrm_unknown_feature_attrs(fs_info, false);
-	sysfs_remove_group(&fs_info->fs_devices->super_kobj, &btrfs_feature_attr_group);
-	sysfs_remove_files(&fs_info->fs_devices->super_kobj, btrfs_attrs);
-	btrfs_kobj_rm_device(fs_info->fs_devices, NULL);
-}
-
 const char * const btrfs_feature_set_names[3] = {
 	[FEAT_COMPAT]	 = "compat",
 	[FEAT_COMPAT_RO] = "compat_ro",
@@ -633,10 +590,59 @@ static void init_feature_attrs(void)
 	}
 }
 
+static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
+{
+	if (fs_devs->seed)
+		__btrfs_sysfs_remove_fsid(fs_devs->seed);
+
+	if (fs_devs->device_dir_kobj) {
+		kobject_del(fs_devs->device_dir_kobj);
+		kobject_put(fs_devs->device_dir_kobj);
+		fs_devs->device_dir_kobj = NULL;
+	}
+
+	if (fs_devs->super_kobj.state_initialized) {
+		kobject_del(&fs_devs->super_kobj);
+		kobject_put(&fs_devs->super_kobj);
+		wait_for_completion(&fs_devs->kobj_unregister);
+	}
+}
+
+/* when fs_devs is NULL it will remove all fsid kobject */
+void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
+{
+	struct list_head *fs_uuids = btrfs_get_fs_uuids();
+
+	if (fs_devs) {
+		__btrfs_sysfs_remove_fsid(fs_devs);
+		return;
+	}
+
+	list_for_each_entry(fs_devs, fs_uuids, list) {
+		__btrfs_sysfs_remove_fsid(fs_devs);
+	}
+}
+
+void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
+{
+	btrfs_reset_fs_info_ptr(fs_info);
+
+	if (fs_info->space_info_kobj) {
+		sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
+		kobject_del(fs_info->space_info_kobj);
+		kobject_put(fs_info->space_info_kobj);
+	}
+	addrm_unknown_feature_attrs(fs_info, false);
+	sysfs_remove_group(&fs_info->fs_devices->super_kobj, &btrfs_feature_attr_group);
+	sysfs_remove_files(&fs_info->fs_devices->super_kobj, btrfs_attrs);
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL, 1);
+}
+
+
 /* when one_device is NULL, it removes all device links */
 
-int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
-		struct btrfs_device *one_device)
+int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
+		struct btrfs_device *one_device, int follow_seed)
 {
 	struct hd_struct *disk;
 	struct kobject *disk_kobj;
@@ -666,27 +672,39 @@ int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
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
 
-int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
-				struct btrfs_device *one_device)
+int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
+			struct btrfs_device *one_device, int follow_seed)
 {
 	int error = 0;
 	struct btrfs_device *dev;
 
+again:
 	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
 		struct hd_struct *disk;
 		struct kobject *disk_kobj;
@@ -706,6 +724,11 @@ int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
 			break;
 	}
 
+	if (follow_seed && fs_devices->seed) {
+		fs_devices = fs_devices->seed;
+		goto again;
+	}
+
 	return error;
 }
 
@@ -723,18 +746,28 @@ u64 btrfs_debugfs_test;
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
+		if (!fs_devs->super_kobj.state_initialized) {
+			init_completion(&fs_devs->kobj_unregister);
+			fs_devs->super_kobj.kset = btrfs_kset;
+			error = kobject_init_and_add(&fs_devs->super_kobj,
 				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
+		} else {
+			error = -EEXIST;
+		}
+		if (!follow_seed)
+			return error;
+		parent = &fs_devs->super_kobj;
+		fs_devs = fs_devs->seed;
+	}
 	return error;
 }
 
-int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
+int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 {
 	int error;
 	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
@@ -742,13 +775,13 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 
 	btrfs_set_fs_info_ptr(fs_info);
 
-	error = btrfs_kobj_add_device(fs_devs, NULL);
+	error = btrfs_sysfs_add_device_link(fs_devs, NULL, 1);
 	if (error)
 		return error;
 
 	error = sysfs_create_files(super_kobj, btrfs_attrs);
 	if (error) {
-		btrfs_kobj_rm_device(fs_devs, NULL);
+		btrfs_sysfs_rm_device_link(fs_devs, NULL, 0);
 		return error;
 	}
 
@@ -774,7 +807,7 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 
 	return 0;
 failure:
-	btrfs_sysfs_remove_one(fs_info);
+	btrfs_sysfs_remove_mounted(fs_info);
 	return error;
 }
 
@@ -816,3 +849,53 @@ void btrfs_exit_sysfs(void)
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
+	if (kobject_rename(&fs_devices->super_kobj, fsid_buf)) {
+		pr_warn("Btrfs: sysfs: kobject move failed\n");
+		return;
+	}
+
+	/*
+	 * Create the seed fsid inside the sprout fsid
+	 * but should not create devices dir, instead
+	 * move it from the original fs_devices
+	 */
+	memset(&seed_devices->super_kobj, 0, sizeof(struct kobject));
+	seed_devices->device_dir_kobj = NULL;
+	memset(&seed_devices->kobj_unregister, 0,
+					sizeof(struct completion));
+	btrfs_sysfs_add_fsid(seed_devices, &fs_devices->super_kobj, 0);
+	if (kobject_move(fs_devices->device_dir_kobj,
+					&seed_devices->super_kobj))
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
+		if (kobject_move(&seed_devices->seed->super_kobj,
+					&seed_devices->super_kobj))
+			pr_warn("Btrfs: sysfs: kobject move failed\n");
+	}
+}
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 2b31f6f..b23e94c 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -70,12 +70,14 @@ char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 extern const char * const btrfs_feature_set_names[3];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
-int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
-		struct btrfs_device *one_device);
-int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
-                struct btrfs_device *one_device);
+int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
+		struct btrfs_device *one_device, int follow_seed);
+int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
+                struct btrfs_device *one_device, int follow_seed);
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
-				struct kobject *parent);
-int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
+				struct kobject *parent, int follow_seed);
+int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
+void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
+				struct btrfs_fs_devices *seed_devices);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f51f5ba..bf59224 100644
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
@@ -478,13 +479,13 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 		if (del) {
 			/* delete the stale */
 			if (fs_devs->num_devices == 1) {
-				btrfs_kobj_rm_device(fs_devs, dev);
+				btrfs_sysfs_rm_device_link(fs_devs, dev, 0);
 				btrfs_sysfs_remove_fsid(fs_devs);
 				list_del(&fs_devs->list);
 				free_fs_devices(fs_devs);
 			} else {
 				fs_devs->num_devices--;
-				btrfs_kobj_rm_device(fs_devs, dev);
+				btrfs_sysfs_rm_device_link(fs_devs, dev, 0);
 				list_del(&dev->dev_list);
 				rcu_string_free(dev->name);
 				kfree(dev);
@@ -1752,7 +1753,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->bdev) {
 		device->fs_devices->open_devices--;
 		/* remove sysfs entry */
-		btrfs_kobj_rm_device(root->fs_info->fs_devices, device);
+		btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device, 0);
 	}
 
 	call_rcu(&device->rcu, free_device);
@@ -1922,7 +1923,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	WARN_ON(!tgtdev);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 
-	btrfs_kobj_rm_device(fs_info->fs_devices, tgtdev);
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, tgtdev, 0);
 
 	if (tgtdev->bdev) {
 		btrfs_scratch_superblock(tgtdev);
@@ -2063,6 +2064,8 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 		      ~BTRFS_SUPER_FLAG_SEEDING;
 	btrfs_set_super_flags(disk_super, super_flags);
 
+	btrfs_sysfs_prepare_sprout(fs_devices, seed_devices);
+
 	return 0;
 }
 
@@ -2260,7 +2263,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 				    tmp + 1);
 
 	/* add sysfs device entry */
-	btrfs_kobj_add_device(root->fs_info->fs_devices, device);
+	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device, 0);
 
 	/*
 	 * we've got more storage, clear any full flags on the space
@@ -2288,22 +2291,11 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
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
-		if (kobject_rename(&root->fs_info->fs_devices->super_kobj,
-								fsid_buf))
-			pr_warn("BTRFS: sysfs: failed to create fsid for sprout\n");
 	}
 
 	root->fs_info->num_tolerated_disk_barrier_failures =
@@ -2339,7 +2331,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 error_trans:
 	btrfs_end_transaction(trans, root);
 	rcu_string_free(device->name);
-	btrfs_kobj_rm_device(root->fs_info->fs_devices, device);
+	btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device, 0);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.0.0.153.g79dcccc

