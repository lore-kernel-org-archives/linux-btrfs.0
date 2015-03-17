Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20900 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034AbbCQJwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 05:52:16 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/1] Btrfs: add sysfs layout to show volume info
Date: Tue, 17 Mar 2015 09:52:06 +0800
Message-Id: <1426557126-3133-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426557126-3133-1-git-send-email-anand.jain@oracle.com>
References: <1426557126-3133-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not yet ready for integration, for review of the new sysfs layout.

This patch makes btrfs_fs_devices and btrfs_device information readable
from sysfs. This uses the sysfs group visible entry point to mark
certain attributes visible/hidden depending the FS state.

The new merged and extended layout is as shown below.

/sys/fs/btrfs/
	./7b047f4d-c2ce-4f22-94a3-68c09057f1bf*
		status
		fsid*
		missing_devices
		num_devices*
		open_devices
		opened*
		rotating
		rw_devices
		seeding
		total_devices*
		total_rw_bytes
		./e6701882-220a-4416-98ac-a99f095bddcc*
			active_pending
			bdev
			bytes_used
			can_discard
			devid*
			dev_root_fsid
			devstats_valid
			dev_totalbytes
			generation*
			in_fs_metadata
			io_align
			io_width
			missing
			name*
			nobarriers
			replace_tgtdev
			sector_size
			total_bytes
			type
			uuid*
			writeable

(* indicates that attribute will be visible even when device is
unmounted but registered with btrfs kernel)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |   5 +
 fs/btrfs/disk-io.c     |  15 +-
 fs/btrfs/sysfs.c       | 531 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/sysfs.h       |  12 +-
 fs/btrfs/volumes.c     |  43 +++-
 fs/btrfs/volumes.h     |  10 +
 6 files changed, 566 insertions(+), 50 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 61d183b..6539268 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -380,6 +380,10 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	if (ret)
 		btrfs_error(root->fs_info, ret, "kobj add dev failed");
 
+	ret = btrfs_sysfs_create_dev(tgt_device);
+	if (ret && ret != -EEXIST)
+		btrfs_error(root->fs_info, ret, "sysfs create dev failed");
+
 	printk_in_rcu(KERN_INFO
 		      "BTRFS: dev_replace from %s (devid %llu) to %s started\n",
 		      src_device->missing ? "<missing disk>" :
@@ -597,6 +601,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	/* replace the sysfs entry */
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, src_device, 0);
+	btrfs_sysfs_destroy_dev(src_device);
 	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
 
 	/* write back the superblocks */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0155ce8..032f59a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2785,18 +2785,6 @@ retry_root_backup:
 
 	btrfs_close_extra_devices(fs_info, fs_devices, 1);
 
-	ret = btrfs_sysfs_add_fsid(fs_devices, NULL, 1);
-	if (ret && ret != -EEXIST) {
-		pr_err("BTRFS: failed to init sysfs fsid interface: %d\n", ret);
-		goto fail_block_groups;
-	}
-
-	ret = btrfs_sysfs_add_device(fs_devices, 1);
-	if (ret) {
-		pr_err("BTRFS: failed to init sysfs device interface: %d\n", ret);
-		goto fail_fsdev_sysfs;
-	}
-
 	ret = btrfs_sysfs_add_mounted(fs_info);
 	if (ret) {
 		pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
@@ -3693,10 +3681,11 @@ void close_ctree(struct btrfs_root *root)
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
-	btrfs_sysfs_remove_mounted(fs_info);
 	if (fs_info->fs_devices->seed)
 		btrfs_sysfs_remove_fsid(fs_info->fs_devices->seed);
 
+	btrfs_sysfs_remove_mounted(fs_info);
+
 	btrfs_free_fs_roots(fs_info);
 
 	btrfs_put_block_group_cache(fs_info);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 253e57e..a6868b9 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -31,9 +31,11 @@
 #include "transaction.h"
 #include "sysfs.h"
 #include "volumes.h"
+#include "rcu-string.h"
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
 static inline struct btrfs_fs_devices *to_fs_devs(struct kobject *kobj);
+static inline struct btrfs_device *to_btrfs_dev(struct kobject *kobj);
 
 static u64 get_features(struct btrfs_fs_info *fs_info,
 			enum btrfs_feature_set set)
@@ -452,8 +454,6 @@ static struct kobj_type btrfs_ktype = {
 
 static inline struct btrfs_fs_devices *to_fs_devs(struct kobject *kobj)
 {
-	if (kobj->ktype != &btrfs_ktype)
-		return NULL;
 	return container_of(kobj, struct btrfs_fs_devices, super_kobj);
 }
 
@@ -596,12 +596,14 @@ static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 		__btrfs_sysfs_remove_fsid(fs_devs->seed);
 
 	if (fs_devs->device_dir_kobj) {
+		btrfs_sysfs_destroy_devs(fs_devs);
 		kobject_del(fs_devs->device_dir_kobj);
 		kobject_put(fs_devs->device_dir_kobj);
 		fs_devs->device_dir_kobj = NULL;
 	}
 
 	if (fs_devs->super_kobj.state_initialized) {
+		btrfs_sysfs_destroy_fs_devs(fs_devs);
 		kobject_del(&fs_devs->super_kobj);
 		kobject_put(&fs_devs->super_kobj);
 		wait_for_completion(&fs_devs->kobj_unregister);
@@ -636,6 +638,7 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 	sysfs_remove_group(&fs_info->fs_devices->super_kobj, &btrfs_feature_attr_group);
 	sysfs_remove_files(&fs_info->fs_devices->super_kobj, btrfs_attrs);
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL, 1);
+	btrfs_sysfs_update_vol_attr(fs_info->fs_devices, 1);
 }
 
 
@@ -678,22 +681,15 @@ int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
 	return 0;
 }
 
-int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed)
+int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs)
 {
 
-	while (fs_devs) {
-		if (!fs_devs->device_dir_kobj)
-			fs_devs->device_dir_kobj = kobject_create_and_add(
+	if (!fs_devs->device_dir_kobj)
+		fs_devs->device_dir_kobj = kobject_create_and_add(
 					"devices", &fs_devs->super_kobj);
 
-		if (!fs_devs->device_dir_kobj)
-			return -ENOMEM;
-
-		if (!follow_seed)
-			return 0;
-
-		fs_devs = fs_devs->seed;
-	}
+	if (!fs_devs->device_dir_kobj)
+		return -ENOMEM;
 
 	return 0;
 }
@@ -746,23 +742,18 @@ u64 btrfs_debugfs_test;
  * And parent can be specified for seed device
  */
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
-				struct kobject *parent, int follow_seed)
+					struct kobject *parent)
 {
 	int error = 0;
 
-	while (fs_devs) {
-		if (!fs_devs->super_kobj.state_initialized) {
-			init_completion(&fs_devs->kobj_unregister);
-			fs_devs->super_kobj.kset = btrfs_kset;
-			error = kobject_init_and_add(&fs_devs->super_kobj,
-				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
-		} else {
-			error = -EEXIST;
-		}
-		if (!follow_seed)
-			return error;
-		parent = &fs_devs->super_kobj;
-		fs_devs = fs_devs->seed;
+	if (!fs_devs->super_kobj.state_initialized) {
+		init_completion(&fs_devs->kobj_unregister);
+		fs_devs->super_kobj.kset = btrfs_kset;
+		error = kobject_init_and_add(&fs_devs->super_kobj,
+			&btrfs_ktype, parent, "%pU", fs_devs->fsid);
+		error = btrfs_sysfs_create_fs_devs(fs_devs);
+	} else {
+		error = -EEXIST;
 	}
 	return error;
 }
@@ -785,6 +776,8 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 		return error;
 	}
 
+	btrfs_sysfs_update_vol_attr(fs_devs, 1);
+
 	error = sysfs_create_group(super_kobj,
 				   &btrfs_feature_attr_group);
 	if (error)
@@ -880,14 +873,14 @@ void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
 	seed_devices->device_dir_kobj = NULL;
 	memset(&seed_devices->kobj_unregister, 0,
 					sizeof(struct completion));
-	btrfs_sysfs_add_fsid(seed_devices, &fs_devices->super_kobj, 0);
+	btrfs_sysfs_add_fsid(seed_devices, &fs_devices->super_kobj);
 	if (kobject_move(fs_devices->device_dir_kobj,
 					&seed_devices->super_kobj))
 		pr_warn("Btrfs: sysfs: dev kobject move failed\n");
 
 	seed_devices->device_dir_kobj = fs_devices->device_dir_kobj;
 	fs_devices->device_dir_kobj = NULL;
-	btrfs_sysfs_add_device(fs_devices, 0);
+	btrfs_sysfs_add_device(fs_devices);
 
 	/*
 	 * the kobj dev and devices attribute will be created
@@ -895,12 +888,486 @@ void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
 	 * If this is a nested seed, that is if there is seed's
 	 * seed device then move that one level deep.
 	 */
+
 	if (seed_devices->seed) {
 		if (kobject_move(&seed_devices->seed->super_kobj,
 					&seed_devices->super_kobj))
 			pr_warn("Btrfs: sysfs: kobject move failed\n");
 	}
 
-	btrfs_sysfs_add_fsid(old_devices, NULL, 0);
-	btrfs_sysfs_add_device(old_devices, 0);
+	btrfs_sysfs_add_fsid(old_devices, NULL);
+	btrfs_sysfs_add_device(old_devices);
+	btrfs_sysfs_create_devs(old_devices);
+}
+
+
+static ssize_t btrfs_show_uuid(u8 *valptr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%pU\n", valptr);
+}
+
+static ssize_t btrfs_show_str(char *strptr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", strptr);
+}
+
+static ssize_t btrfs_show_u(uint val, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static ssize_t btrfs_show_d(int val, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", val);
+}
+
+
+/* btrfs_fs_devices attributes */
+struct btrfs_fs_devs_attr {
+	struct kobj_attribute kobj_attr;
+};
+
+static ssize_t btrfs_fs_devs_attr_show(struct kobject *kobj,
+				       struct kobj_attribute *a, char *buf);
+
+static ssize_t btrfs_fs_devs_attr_store(struct kobject *kobj,
+					struct kobj_attribute *a,
+					const char *buf, size_t count);
+
+#define BTRFS_FS_DEV_ATTR(_name)\
+	static struct btrfs_fs_devs_attr btrfs_fs_devs_attr_##_name = {\
+		.kobj_attr = __INIT_KOBJ_ATTR(_name, S_IRUGO,\
+					btrfs_fs_devs_attr_show,\
+					btrfs_fs_devs_attr_store),\
+	}
+
+BTRFS_FS_DEV_ATTR(fsid);
+BTRFS_FS_DEV_ATTR(num_devices);
+BTRFS_FS_DEV_ATTR(open_devices);
+BTRFS_FS_DEV_ATTR(rw_devices);
+BTRFS_FS_DEV_ATTR(missing_devices);
+BTRFS_FS_DEV_ATTR(total_rw_bytes);
+BTRFS_FS_DEV_ATTR(total_devices);
+BTRFS_FS_DEV_ATTR(opened);
+BTRFS_FS_DEV_ATTR(seeding);
+BTRFS_FS_DEV_ATTR(rotating);
+
+#define BTRFS_FS_DEV_ATTR_PTR(_name)\
+	(&btrfs_fs_devs_attr_##_name.kobj_attr.attr)
+
+static struct attribute *btrfs_fs_devs_attrs[] = {
+	BTRFS_FS_DEV_ATTR_PTR(fsid),
+	BTRFS_FS_DEV_ATTR_PTR(num_devices),
+	BTRFS_FS_DEV_ATTR_PTR(open_devices),
+	BTRFS_FS_DEV_ATTR_PTR(rw_devices),
+	BTRFS_FS_DEV_ATTR_PTR(missing_devices),
+	BTRFS_FS_DEV_ATTR_PTR(total_rw_bytes),
+	BTRFS_FS_DEV_ATTR_PTR(total_devices),
+	BTRFS_FS_DEV_ATTR_PTR(opened),
+	BTRFS_FS_DEV_ATTR_PTR(seeding),
+	BTRFS_FS_DEV_ATTR_PTR(rotating),
+	NULL
+};
+
+#define BTRFS_FS_DEVS_GET_ATTR_UUID(attr, name, valprt, buf)\
+	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
+		return btrfs_show_uuid(valprt, buf)
+#define BTRFS_FS_DEVS_GET_ATTR_STR(attr, name, strprt, buf)\
+	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
+		return btrfs_show_str(strprt, buf)
+#define BTRFS_FS_DEVS_GET_ATTR_U64(attr, name, valprt, buf)\
+	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
+		return btrfs_show_u64(valprt, NULL, buf)
+#define BTRFS_FS_DEVS_GET_ATTR_U(attr, name, val, buf)\
+	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
+		return btrfs_show_u(val, buf)
+#define BTRFS_FS_DEVS_GET_ATTR_D(attr, name, val, buf)\
+	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
+		return btrfs_show_d(val, buf)
+
+static ssize_t btrfs_fs_devs_attr_show(struct kobject *kobj,
+				       struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_devices *fs_devs = to_fs_devs(kobj);
+
+	BTRFS_FS_DEVS_GET_ATTR_UUID(&a->attr, fsid, fs_devs->fsid, buf);
+	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, num_devices, &fs_devs->num_devices, buf);
+	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, open_devices, &fs_devs->open_devices, buf);
+	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, rw_devices, &fs_devs->rw_devices, buf);
+	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, missing_devices,
+							&fs_devs->missing_devices, buf);
+	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, total_rw_bytes,
+							&fs_devs->total_rw_bytes, buf);
+	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, total_devices, &fs_devs->total_devices, buf);
+	BTRFS_FS_DEVS_GET_ATTR_D(&a->attr, opened, fs_devs->opened, buf);
+	BTRFS_FS_DEVS_GET_ATTR_D(&a->attr, seeding, fs_devs->seeding, buf);
+	BTRFS_FS_DEVS_GET_ATTR_D(&a->attr, rotating, fs_devs->rotating, buf);
+
+	return 0;
+}
+
+static ssize_t btrfs_fs_devs_attr_store(struct kobject *kobj,
+					struct kobj_attribute *a,
+					const char *buf, size_t count)
+{
+	/*
+	 * we might need some of the parameter to be writable
+	 * but as of now just deny all
+	 */
+	return -EPERM;
+}
+
+
+static umode_t btrfs_sysfs_visible_fs_devs_attr(struct kobject *kobj,
+				     struct attribute *attr, int unused)
+{
+	struct btrfs_fs_devices *fs_devs = to_fs_devs(kobj);
+	struct btrfs_fs_info *fs_info = fs_devs->fs_info;
+
+	/* if device is mounted then all is visible */
+	if (fs_devs->opened && fs_info && !fs_info->closing)
+		return attr->mode|S_IWUSR;
+
+	/* when device is unmounted(ing) show only following set*/
+	if (attr == BTRFS_FS_DEV_ATTR_PTR(num_devices))
+		return attr->mode|S_IWUSR;
+	else if (attr == BTRFS_FS_DEV_ATTR_PTR(total_devices))
+		return attr->mode|S_IWUSR;
+	else if (attr == BTRFS_FS_DEV_ATTR_PTR(opened))
+		return attr->mode|S_IWUSR;
+	else if (attr == BTRFS_FS_DEV_ATTR_PTR(fsid))
+		return attr->mode|S_IWUSR;
+
+	return 0;
+}
+
+static const struct attribute_group btrfs_fs_devs_attr_group = {
+	.attrs = btrfs_fs_devs_attrs,
+	.is_visible = btrfs_sysfs_visible_fs_devs_attr,
+};
+
+void btrfs_sysfs_destroy_fs_devs(struct btrfs_fs_devices *fs_devs)
+{
+	sysfs_remove_group(&fs_devs->super_kobj,
+				&btrfs_fs_devs_attr_group);
+}
+
+int btrfs_sysfs_create_fs_devs(struct btrfs_fs_devices *fs_devs)
+{
+	int rc;
+
+	rc = sysfs_create_group(&fs_devs->super_kobj,
+				&btrfs_fs_devs_attr_group);
+	return rc;
+}
+
+static int btrfs_sysfs_update_fs_devs(struct btrfs_fs_devices *fs_devs)
+{
+	int rc;
+
+	rc = sysfs_update_group(&fs_devs->super_kobj,
+				&btrfs_fs_devs_attr_group);
+
+	return rc;
+}
+
+/**** btrfs_device kobject and attributes ****/
+static ssize_t btrfs_dev_attr_show(struct kobject *kobj,
+			       struct kobj_attribute *a, char *buf);
+static ssize_t btrfs_dev_attr_store(struct kobject *kobj,
+				struct kobj_attribute *a,
+				const char *buf, size_t count);
+
+struct btrfs_dev_attr {
+	struct kobj_attribute kobj_attr;
+};
+
+static void btrfs_release_dev_kobj(struct kobject *kobj)
+{
+	struct btrfs_device *dev = to_btrfs_dev(kobj);
+
+	kfree(dev->dev_kobjp);
+	dev->dev_kobjp = NULL;
+	complete(&dev->dev_kobj_unregister);
+}
+
+static struct kobj_type btrfs_dev_ktype = {
+	.sysfs_ops	= &kobj_sysfs_ops,
+	.release	= btrfs_release_dev_kobj,
+};
+
+static inline struct btrfs_device *to_btrfs_dev(struct kobject *kobj)
+{
+	struct btrfs_device_kobj *dev_kobj;
+
+	if (kobj->ktype != &btrfs_dev_ktype)
+		return NULL;
+
+	dev_kobj = container_of(kobj, struct btrfs_device_kobj, dev_kobj);
+	return dev_kobj->device;
+}
+
+
+#define BTRFS_DEV_ATTR(_name)\
+	static struct btrfs_dev_attr btrfs_dev_attr_##_name = {\
+		.kobj_attr = __INIT_KOBJ_ATTR(_name, S_IRUGO,\
+					btrfs_dev_attr_show,\
+					btrfs_dev_attr_store),\
+	}
+
+BTRFS_DEV_ATTR(uuid);
+BTRFS_DEV_ATTR(name);
+BTRFS_DEV_ATTR(devid);
+BTRFS_DEV_ATTR(dev_root_fsid);
+BTRFS_DEV_ATTR(generation);
+BTRFS_DEV_ATTR(total_bytes);
+BTRFS_DEV_ATTR(dev_totalbytes);
+BTRFS_DEV_ATTR(bytes_used);
+BTRFS_DEV_ATTR(type);
+BTRFS_DEV_ATTR(io_align);
+BTRFS_DEV_ATTR(io_width);
+BTRFS_DEV_ATTR(sector_size);
+BTRFS_DEV_ATTR(writeable);
+BTRFS_DEV_ATTR(in_fs_metadata);
+BTRFS_DEV_ATTR(missing);
+BTRFS_DEV_ATTR(can_discard);
+BTRFS_DEV_ATTR(replace_tgtdev);
+BTRFS_DEV_ATTR(active_pending);
+BTRFS_DEV_ATTR(nobarriers);
+BTRFS_DEV_ATTR(devstats_valid);
+BTRFS_DEV_ATTR(bdev);
+
+#define BTRFS_DEV_ATTR_PTR(_name)\
+		(&btrfs_dev_attr_##_name.kobj_attr.attr)
+
+static struct attribute *btrfs_dev_attrs[] = {
+	BTRFS_DEV_ATTR_PTR(uuid),
+	BTRFS_DEV_ATTR_PTR(name),
+	BTRFS_DEV_ATTR_PTR(devid),
+	BTRFS_DEV_ATTR_PTR(dev_root_fsid),
+	BTRFS_DEV_ATTR_PTR(generation),
+	BTRFS_DEV_ATTR_PTR(total_bytes),
+	BTRFS_DEV_ATTR_PTR(dev_totalbytes),
+	BTRFS_DEV_ATTR_PTR(bytes_used),
+	BTRFS_DEV_ATTR_PTR(type),
+	BTRFS_DEV_ATTR_PTR(io_align),
+	BTRFS_DEV_ATTR_PTR(io_width),
+	BTRFS_DEV_ATTR_PTR(sector_size),
+	BTRFS_DEV_ATTR_PTR(writeable),
+	BTRFS_DEV_ATTR_PTR(in_fs_metadata),
+	BTRFS_DEV_ATTR_PTR(missing),
+	BTRFS_DEV_ATTR_PTR(can_discard),
+	BTRFS_DEV_ATTR_PTR(replace_tgtdev),
+	BTRFS_DEV_ATTR_PTR(active_pending),
+	BTRFS_DEV_ATTR_PTR(nobarriers),
+	BTRFS_DEV_ATTR_PTR(devstats_valid),
+	BTRFS_DEV_ATTR_PTR(bdev),
+	NULL
+};
+
+#define BTRFS_DEV_GET_ATTR_UUID(attr, name, valprt, buf)\
+	if (attr == BTRFS_DEV_ATTR_PTR(name))\
+		return btrfs_show_uuid(valprt, buf)
+#define BTRFS_DEV_GET_ATTR_STR(attr, name, strprt, buf)\
+	if (attr == BTRFS_DEV_ATTR_PTR(name))\
+		return btrfs_show_str(strprt, buf)
+#define BTRFS_DEV_GET_ATTR_U64(attr, name, valprt, buf)\
+	if (attr == BTRFS_DEV_ATTR_PTR(name))\
+		return btrfs_show_u64(valprt, NULL, buf)
+#define BTRFS_DEV_GET_ATTR_U(attr, name, val, buf)\
+	if (attr == BTRFS_DEV_ATTR_PTR(name))\
+		return btrfs_show_u(val, buf)
+#define BTRFS_DEV_GET_ATTR_D(attr, name, val, buf)\
+	if (attr == BTRFS_DEV_ATTR_PTR(name))\
+		return btrfs_show_d(val, buf)
+#define BTRFS_DEV_CHECK_ATTR(attr, name)\
+		attr == BTRFS_DEV_ATTR_PTR(name)
+
+static ssize_t btrfs_dev_attr_show(struct kobject *kobj,
+				       struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_device *dev = to_btrfs_dev(kobj);
+	char bdev_state[10];
+
+	/* Todo: handle the missing device case */
+	BTRFS_DEV_GET_ATTR_STR(&a->attr, name, rcu_str_deref(dev->name), buf);
+	BTRFS_DEV_GET_ATTR_UUID(&a->attr, uuid, dev->uuid, buf);
+	BTRFS_DEV_GET_ATTR_U64(&a->attr, devid, &dev->devid, buf);
+	BTRFS_DEV_GET_ATTR_UUID(&a->attr, dev_root_fsid,
+					dev->dev_root->fs_info->fsid, buf);
+	BTRFS_DEV_GET_ATTR_U64(&a->attr, generation, &dev->generation, buf);
+	BTRFS_DEV_GET_ATTR_U64(&a->attr, total_bytes, &dev->total_bytes, buf);
+	BTRFS_DEV_GET_ATTR_U64(&a->attr, dev_totalbytes, &dev->disk_total_bytes, buf);
+	BTRFS_DEV_GET_ATTR_U64(&a->attr, bytes_used, &dev->bytes_used, buf);
+	BTRFS_DEV_GET_ATTR_U64(&a->attr, type, &dev->type, buf);
+	BTRFS_DEV_GET_ATTR_U(&a->attr, io_align, dev->io_align, buf);
+	BTRFS_DEV_GET_ATTR_U(&a->attr, sector_size, dev->sector_size, buf);
+	BTRFS_DEV_GET_ATTR_D(&a->attr, writeable, dev->writeable, buf);
+	BTRFS_DEV_GET_ATTR_D(&a->attr, in_fs_metadata, dev->in_fs_metadata, buf);
+	BTRFS_DEV_GET_ATTR_D(&a->attr, missing, dev->missing, buf);
+	BTRFS_DEV_GET_ATTR_D(&a->attr, can_discard, dev->can_discard, buf);
+	BTRFS_DEV_GET_ATTR_D(&a->attr, replace_tgtdev,
+						dev->is_tgtdev_for_dev_replace, buf);
+	BTRFS_DEV_GET_ATTR_D(&a->attr, active_pending, dev->running_pending, buf);
+	BTRFS_DEV_GET_ATTR_D(&a->attr, nobarriers, dev->nobarriers, buf);
+	BTRFS_DEV_GET_ATTR_D(&a->attr, devstats_valid, dev->dev_stats_valid, buf);
+	if (dev->bdev)
+		strcpy(bdev_state, "not_null");
+	else
+		strcpy(bdev_state, "null");
+	BTRFS_DEV_GET_ATTR_STR(&a->attr, bdev, bdev_state, buf);
+
+	return 0;
+}
+
+static ssize_t btrfs_dev_attr_store(struct kobject *kobj,
+					struct kobj_attribute *a,
+					const char *buf, size_t count)
+{
+	/*
+	 * we might need some of the parameter to be writable
+	 * but as of now just deny all
+	 */
+	return -EPERM;
+}
+
+static umode_t btrfs_sysfs_visible_dev_attr(struct kobject *kobj,
+				     struct attribute *attr, int unused)
+{
+	struct btrfs_fs_devices *fs_devs;
+	struct btrfs_fs_info *fs_info;
+
+	fs_devs = to_btrfs_dev(kobj)->fs_devices;
+	if (!fs_devs) {
+		BUG_ON(fs_devs == NULL);
+		return 0;
+	}
+	fs_info = fs_devs->fs_info;
+
+	/* if device is mounted then all is visible */
+	if (fs_devs->opened && fs_info && !fs_info->closing)
+		return attr->mode|S_IWUSR;
+
+	/* when device is unmounted  only the below attributes are visible */
+	if (attr == BTRFS_DEV_ATTR_PTR(uuid))
+		return attr->mode|S_IWUSR;
+	if (attr == BTRFS_DEV_ATTR_PTR(name))
+		return attr->mode|S_IWUSR;
+	else if (attr == BTRFS_DEV_ATTR_PTR(devid))
+		return attr->mode|S_IWUSR;
+	else if (attr == BTRFS_DEV_ATTR_PTR(generation))
+		return attr->mode|S_IWUSR;
+
+	return 0;
+}
+
+static const struct attribute_group btrfs_dev_attr_group = {
+	.attrs = btrfs_dev_attrs,
+	.is_visible = btrfs_sysfs_visible_dev_attr,
+};
+
+void btrfs_sysfs_destroy_dev(struct btrfs_device *dev)
+{
+	if (dev->dev_kobjp) {
+		struct kobject *kobj = &dev->dev_kobjp->dev_kobj;
+
+		if (kobj->state_initialized) {
+			sysfs_remove_group(kobj, &btrfs_dev_attr_group);
+			kobject_del(kobj);
+			kobject_put(kobj);
+			wait_for_completion(&dev->dev_kobj_unregister);
+			return;
+		}
+	}
+	pr_warn("Btrfs: sysfs: dev destroy called for non init kobj\n");
+	return;
+}
+
+void btrfs_sysfs_destroy_devs(struct btrfs_fs_devices *fs_devs)
+{
+	struct btrfs_device *dev;
+
+	list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+		btrfs_sysfs_destroy_dev(dev);
+	}
+}
+
+int btrfs_sysfs_create_dev(struct btrfs_device *dev)
+{
+	int rc;
+	struct kobject *kobj;
+
+	if (!dev->dev_kobjp)
+		dev->dev_kobjp = kzalloc(sizeof(struct btrfs_device_kobj),
+								GFP_NOFS);
+	else
+		return -EEXIST;
+
+	if (!dev->dev_kobjp)
+		return -ENOMEM;
+
+	dev->dev_kobjp->device = dev;
+	kobj = &dev->dev_kobjp->dev_kobj;
+
+	init_completion(&dev->dev_kobj_unregister);
+
+	rc = kobject_init_and_add(kobj, &btrfs_dev_ktype,
+			dev->fs_devices->device_dir_kobj, "%pU", dev->uuid);
+	if (!rc)
+		rc = sysfs_create_group(kobj, &btrfs_dev_attr_group);
+
+	return rc;
+}
+
+void btrfs_sysfs_create_devs(struct btrfs_fs_devices *fs_devs)
+{
+	struct btrfs_device *dev;
+
+	list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+		if (btrfs_sysfs_create_dev(dev))
+			printk(KERN_WARNING "BTRFS: create dev sysfs failed\n");
+	}
+}
+
+static int btrfs_sysfs_update_dev(struct btrfs_device *dev)
+{
+	struct kobject *kobj = &dev->dev_kobjp->dev_kobj;
+
+	if (!kobj)
+		return -EINVAL;
+
+	return sysfs_update_group(kobj, &btrfs_dev_attr_group);
+}
+
+static int btrfs_sysfs_update_devs(struct btrfs_fs_devices *fs_devs)
+{
+	int rc;
+	struct btrfs_device *dev;
+
+	list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+		if (!dev->dev_kobjp)
+			continue;
+		rc = btrfs_sysfs_update_dev(dev);
+		if (rc) {
+			pr_warn("BTRFS: update dev sysfs failed\n");
+			return rc;
+		}
+	}
+	return 0;
+}
+
+int btrfs_sysfs_update_vol_attr(struct btrfs_fs_devices *fs_devs, int follow_seed)
+{
+	int rc;
+
+again_for_seeds:
+	rc = btrfs_sysfs_update_fs_devs(fs_devs);
+	rc = btrfs_sysfs_update_devs(fs_devs);
+
+	if (follow_seed && fs_devs->seed) {
+		fs_devs = fs_devs->seed;
+		goto again_for_seeds;
+	}
+
+	return rc;
 }
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 34b9864..facb295 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -75,10 +75,18 @@ int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
                 struct btrfs_device *one_device, int follow_seed);
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
-				struct kobject *parent, int follow_seed);
-int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed);
+					struct kobject *parent);
+int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
 				struct btrfs_fs_devices *seed_devices,
 				struct btrfs_fs_devices *old_devices);
+int btrfs_sysfs_create_dev(struct btrfs_device *dev);
+void btrfs_sysfs_create_devs(struct btrfs_fs_devices *fs_devs);
+void btrfs_sysfs_destroy_dev(struct btrfs_device *dev);
+void btrfs_sysfs_destroy_devs(struct btrfs_fs_devices *fs_devs);
+void btrfs_sysfs_destroy_fs_devs(struct btrfs_fs_devices *fs_devs);
+int btrfs_sysfs_update_vol_attr(struct btrfs_fs_devices *fs_devs, int follow_seed);
+int btrfs_sysfs_create_fs_devs(struct btrfs_fs_devices *fs_devs);
+void btrfs_sysfs_destroy_fs_devs(struct btrfs_fs_devices *fs_devs);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dfb5062..25713ed 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -480,12 +480,14 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 			/* delete the stale */
 			if (fs_devs->num_devices == 1) {
 				btrfs_sysfs_rm_device_link(fs_devs, dev, 0);
+				btrfs_sysfs_destroy_dev(dev);
 				btrfs_sysfs_remove_fsid(fs_devs);
 				list_del(&fs_devs->list);
 				free_fs_devices(fs_devs);
 			} else {
 				fs_devs->num_devices--;
 				btrfs_sysfs_rm_device_link(fs_devs, dev, 0);
+				btrfs_sysfs_destroy_dev(dev);
 				list_del(&dev->dev_list);
 				rcu_string_free(dev->name);
 				kfree(dev);
@@ -523,9 +525,9 @@ static noinline int device_list_add(const char *path,
 		list_add(&fs_devices->list, &fs_uuids);
 
 		device = NULL;
-		if (btrfs_sysfs_add_fsid(fs_devices, NULL, 0))
+		if (btrfs_sysfs_add_fsid(fs_devices, NULL))
 			printk(KERN_WARNING "Btrfs: sysfs add fsid failed\n");
-		if (btrfs_sysfs_add_device(fs_devices, 0))
+		if (btrfs_sysfs_add_device(fs_devices))
 			printk(KERN_WARNING "Btrfs: sysfs add device failed\n");
 	} else {
 		device = __find_device(&fs_devices->devices, devid,
@@ -557,6 +559,10 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
+
+		if (btrfs_sysfs_create_dev(device))
+			pr_warn("Btrfs: sysfs create dev failed\n");
+
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
@@ -791,6 +797,13 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
 		new_device->fs_devices = device->fs_devices;
 
+		if (device->dev_kobjp) {
+			new_device->dev_kobjp = device->dev_kobjp;
+			new_device->dev_kobjp->device = new_device;
+			device->dev_kobjp = NULL;
+		}
+		init_completion(&new_device->dev_kobj_unregister);
+
 		call_rcu(&device->rcu, free_device);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
@@ -1759,6 +1772,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		/* remove sysfs entry */
 		btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device, 0);
 	}
+	btrfs_sysfs_destroy_dev(device);
 
 	call_rcu(&device->rcu, free_device);
 
@@ -2268,6 +2282,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 	/* add sysfs device entry */
 	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device, 0);
+	btrfs_sysfs_create_dev(device);
 
 	/*
 	 * we've got more storage, clear any full flags on the space
@@ -5984,6 +5999,8 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
 	device->missing = 1;
 	fs_devices->missing_devices++;
 
+	btrfs_sysfs_create_dev(device);
+
 	return device;
 }
 
@@ -6201,6 +6218,25 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_root *root,
 
 	fs_devices->seed = root->fs_info->fs_devices->seed;
 	root->fs_info->fs_devices->seed = fs_devices;
+
+	ret = btrfs_sysfs_add_fsid(fs_devices, &root->fs_info->fs_devices->super_kobj);
+	if (!ret || ret == -EEXIST) {
+		if (fs_devices->seed) {
+			if (kobject_move(&fs_devices->seed->super_kobj,
+						&fs_devices->super_kobj))
+				pr_warn("Btrfs: sysfs: kobject move failed during open\n");
+		}
+
+		ret = btrfs_sysfs_add_device(fs_devices);
+		if (ret) {
+			pr_err("BTRFS: failed to init sysfs device dir: %d\n", ret);
+		}
+
+		btrfs_sysfs_create_devs(fs_devices);
+	} else {
+		pr_err("BTRFS: failed to init sysfs fsid: %d\n", ret);
+	}
+
 out:
 	return fs_devices;
 }
@@ -6270,8 +6306,9 @@ static int read_one_dev(struct btrfs_root *root,
 	if (device->fs_devices != root->fs_info->fs_devices) {
 		BUG_ON(device->writeable);
 		if (device->generation !=
-		    btrfs_device_generation(leaf, dev_item))
+		    btrfs_device_generation(leaf, dev_item)) {
 			return -EINVAL;
+		}
 	}
 
 	fill_device_from_item(leaf, dev_item, device);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index e6514c7..5937e9e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -47,6 +47,11 @@ struct btrfs_pending_bios {
 #define btrfs_device_data_ordered_init(device) do { } while (0)
 #endif
 
+struct btrfs_device_kobj {
+	struct kobject dev_kobj;
+	struct btrfs_device *device;
+};
+
 struct btrfs_device {
 	struct list_head dev_list;
 	struct list_head dev_alloc_list;
@@ -150,6 +155,9 @@ struct btrfs_device {
 	/* Counter to record the change of device stats */
 	atomic_t dev_stats_ccnt;
 	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
+
+	struct btrfs_device_kobj *dev_kobjp;
+	struct completion dev_kobj_unregister;
 };
 
 /*
@@ -259,6 +267,8 @@ struct btrfs_fs_devices {
 	struct kobject super_kobj;
 	struct kobject *device_dir_kobj;
 	struct completion kobj_unregister;
+
+	long unsigned int state;
 };
 
 #define BTRFS_BIO_INLINE_CSUM_SIZE	64
-- 
2.0.0.153.g79dcccc

