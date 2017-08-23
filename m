Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:35968 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753378AbdHWGqR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 02:46:17 -0400
Received: by mail-pg0-f42.google.com with SMTP id 83so3988528pgb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 23:46:17 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 4/7] Btrfs: refactor btrfs_device->name updates
Date: Tue, 22 Aug 2017 23:46:02 -0700
Message-Id: <df524d6df1a8fdf8d4d20305aad341c4cd968ba2.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The rcu_string API introduced some new sparse errors but also revealed
existing ones. First of all, the name in struct btrfs_device should be
annotated as __rcu to prevent unsafe reads. Additionally, updates should
go through rcu_dereference_protected to make it clear what's going on.
This introduces some helper functions that factor out this
functionality.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/volumes.c | 117 +++++++++++++++++++++++++++++++++++------------------
 fs/btrfs/volumes.h |   2 +-
 2 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4010c35898d8..9b7a8e6257ee 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -152,6 +152,46 @@ struct list_head *btrfs_get_fs_uuids(void)
 	return &fs_uuids;
 }
 
+/*
+ * Dereference the device name under the uuid_mutex.
+ */
+static inline struct rcu_string *
+btrfs_dev_rcu_protected_name(struct btrfs_device *dev)
+	__must_hold(&uuid_mutex)
+{
+	return rcu_dereference_protected(dev->name,
+					 lockdep_is_held(&uuid_mutex));
+}
+
+/*
+ * Use when the caller is the only possible updater.
+ */
+static inline struct rcu_string *
+btrfs_dev_rcu_only_name(struct btrfs_device *dev)
+{
+	return rcu_dereference_protected(dev->name, 1);
+}
+
+/*
+ * Rename a device under the uuid_mutex.
+ */
+static inline int btrfs_dev_rename(struct btrfs_device *dev, const char *name,
+				   gfp_t gfp_mask)
+	__must_hold(&uuid_mutex)
+{
+	struct rcu_string *old_name, *new_name;
+
+	new_name = rcu_string_strdup(name, gfp_mask);
+	if (!new_name)
+		return -ENOMEM;
+
+	old_name = btrfs_dev_rcu_protected_name(dev);
+	rcu_assign_pointer(dev->name, new_name);
+	rcu_string_free(old_name);
+
+	return 0;
+}
+
 static struct btrfs_fs_devices *__alloc_fs_devices(void)
 {
 	struct btrfs_fs_devices *fs_devs;
@@ -203,7 +243,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 		device = list_entry(fs_devices->devices.next,
 				    struct btrfs_device, dev_list);
 		list_del(&device->dev_list);
-		rcu_string_free(device->name);
+		rcu_string_free(btrfs_dev_rcu_only_name(device));
 		kfree(device);
 	}
 	kfree(fs_devices);
@@ -600,7 +640,7 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 			} else {
 				fs_devs->num_devices--;
 				list_del(&dev->dev_list);
-				rcu_string_free(dev->name);
+				rcu_string_free(btrfs_dev_rcu_only_name(dev));
 				kfree(dev);
 			}
 			break;
@@ -651,12 +691,10 @@ static noinline int device_list_add(const char *path,
 			return PTR_ERR(device);
 		}
 
-		name = rcu_string_strdup(path, GFP_NOFS);
-		if (!name) {
+		if (btrfs_dev_rename(device, path, GFP_NOFS)) {
 			kfree(device);
 			return -ENOMEM;
 		}
-		rcu_assign_pointer(device->name, name);
 
 		mutex_lock(&fs_devices->device_list_mutex);
 		list_add_rcu(&device->dev_list, &fs_devices->devices);
@@ -665,13 +703,17 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-	} else if (!device->name || strcmp(device->name->str, path)) {
+	} else {
+		name = btrfs_dev_rcu_protected_name(device);
+		if (name && strcmp(name->str, path) == 0)
+			goto out;
+
 		/*
 		 * When FS is already mounted.
-		 * 1. If you are here and if the device->name is NULL that
-		 *    means this device was missing at time of FS mount.
-		 * 2. If you are here and if the device->name is different
-		 *    from 'path' that means either
+		 * 1. If you are here and if the name is NULL that means this
+		 *    device was missing at time of FS mount.
+		 * 2. If you are here and if the name is different from 'path'
+		 *    that means either
 		 *      a. The same device disappeared and reappeared with
 		 *         different name. or
 		 *      b. The missing-disk-which-was-replaced, has
@@ -703,17 +745,15 @@ static noinline int device_list_add(const char *path,
 			return -EEXIST;
 		}
 
-		name = rcu_string_strdup(path, GFP_NOFS);
-		if (!name)
+		if (btrfs_dev_rename(device, path, GFP_NOFS))
 			return -ENOMEM;
-		rcu_string_free(device->name);
-		rcu_assign_pointer(device->name, name);
 		if (device->missing) {
 			fs_devices->missing_devices--;
 			device->missing = 0;
 		}
 	}
 
+out:
 	/*
 	 * Unmount does not free the btrfs_device struct but would zero
 	 * generation along with most of the other members. So just update
@@ -757,18 +797,12 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		if (IS_ERR(device))
 			goto error;
 
-		/*
-		 * This is ok to do without rcu read locked because we hold the
-		 * uuid mutex so nothing we touch in here is going to disappear.
-		 */
-		if (orig_dev->name) {
-			name = rcu_string_strdup(orig_dev->name->str,
-					GFP_KERNEL);
-			if (!name) {
+		name = btrfs_dev_rcu_protected_name(orig_dev);
+		if (name) {
+			if (btrfs_dev_rename(device, name->str, GFP_KERNEL)) {
 				kfree(device);
 				goto error;
 			}
-			rcu_assign_pointer(device->name, name);
 		}
 
 		list_add(&device->dev_list, &fs_devices->devices);
@@ -829,7 +863,7 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;
-		rcu_string_free(device->name);
+		rcu_string_free(btrfs_dev_rcu_only_name(device));
 		kfree(device);
 	}
 
@@ -848,7 +882,7 @@ static void __free_device(struct work_struct *work)
 	struct btrfs_device *device;
 
 	device = container_of(work, struct btrfs_device, rcu_work);
-	rcu_string_free(device->name);
+	rcu_string_free(btrfs_dev_rcu_only_name(device));
 	bio_put(device->flush_bio);
 	kfree(device);
 }
@@ -896,11 +930,10 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
 					device->uuid);
 	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
 
-	/* Safe because we are under uuid_mutex */
-	if (device->name) {
-		name = rcu_string_strdup(device->name->str, GFP_NOFS);
-		BUG_ON(!name); /* -ENOMEM */
-		rcu_assign_pointer(new_device->name, name);
+	name = btrfs_dev_rcu_protected_name(device);
+	if (name) {
+		if (btrfs_dev_rename(new_device, name->str, GFP_NOFS))
+			BUG_ON(1); /* -ENOMEM */
 	}
 
 	list_replace_rcu(&device->dev_list, &new_device->dev_list);
@@ -987,18 +1020,20 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	u64 devid;
 	int seeding = 1;
 	int ret = 0;
+	struct rcu_string *name;
 
 	flags |= FMODE_EXCL;
 
 	list_for_each_entry(device, head, dev_list) {
 		if (device->bdev)
 			continue;
-		if (!device->name)
+		name = btrfs_dev_rcu_protected_name(device);
+		if (!name)
 			continue;
 
 		/* Just open everything we can; ignore failures here */
-		if (btrfs_get_bdev_and_sb(device->name->str, flags, holder, 1,
-					    &bdev, &bh))
+		if (btrfs_get_bdev_and_sb(name->str, flags, holder, 1, &bdev,
+					  &bh))
 			continue;
 
 		disk_super = (struct btrfs_super_block *)bh->b_data;
@@ -1966,8 +2001,10 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	 * the devices list.  All that's left is to zero out the old
 	 * supers and free the device.
 	 */
-	if (device->writeable)
-		btrfs_scratch_superblocks(device->bdev, device->name->str);
+	if (device->writeable) {
+		btrfs_scratch_superblocks(device->bdev,
+					  btrfs_dev_rcu_protected_name(device)->str);
+	}
 
 	btrfs_close_bdev(device);
 	call_rcu(&device->rcu, free_device);
@@ -2040,7 +2077,8 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 
 	if (srcdev->writeable) {
 		/* zero out the old super if it is writable */
-		btrfs_scratch_superblocks(srcdev->bdev, srcdev->name->str);
+		btrfs_scratch_superblocks(srcdev->bdev,
+					  btrfs_dev_rcu_only_name(srcdev)->str);
 	}
 
 	btrfs_close_bdev(srcdev);
@@ -2099,7 +2137,8 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	 * is already out of device list, so we don't have to hold
 	 * the device_list_mutex lock.
 	 */
-	btrfs_scratch_superblocks(tgtdev->bdev, tgtdev->name->str);
+	btrfs_scratch_superblocks(tgtdev->bdev,
+				  btrfs_dev_rcu_only_name(tgtdev)->str);
 
 	btrfs_close_bdev(tgtdev);
 	call_rcu(&tgtdev->rcu, free_device);
@@ -2383,7 +2422,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
-		rcu_string_free(device->name);
+		rcu_string_free(btrfs_dev_rcu_only_name(device));
 		kfree(device);
 		ret = PTR_ERR(trans);
 		goto error;
@@ -2517,7 +2556,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 error_trans:
 	btrfs_end_transaction(trans);
-	rcu_string_free(device->name);
+	rcu_string_free(btrfs_dev_rcu_only_name(device));
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
 	kfree(device);
 error:
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 93277fc60930..f3b1c77a4fee 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -53,7 +53,7 @@ struct btrfs_device {
 	struct btrfs_fs_devices *fs_devices;
 	struct btrfs_fs_info *fs_info;
 
-	struct rcu_string *name;
+	struct rcu_string __rcu *name;
 
 	u64 generation;
 
-- 
2.14.1

