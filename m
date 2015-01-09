Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65509 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbbAIUgO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 15:36:14 -0500
Received: by mail-pa0-f50.google.com with SMTP id bj1so20473911pad.9
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jan 2015 12:36:14 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH RESEND v8 2/3] btrfs: refactor btrfs_device->name updates
Date: Fri,  9 Jan 2015 12:35:59 -0800
Message-Id: <817c39c5dc35a57c2bdc0ef5584044c0c0a1a33d.1420834567.git.osandov@osandov.com>
In-Reply-To: <cover.1420834567.git.osandov@osandov.com>
References: <cover.1420834567.git.osandov@osandov.com>
In-Reply-To: <cover.1420834567.git.osandov@osandov.com>
References: <cover.1420834567.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The rcu_string API introduced some new sparse errors but also revealed
existing ones. First of all, the name in struct btrfs_device should be
annotated as __rcu to prevent unsafe reads. Additionally, updates should
go through rcu_dereference_protected to make it clear what's going on.
This introduces some helper functions that factor out this
functionality.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/volumes.c | 93 +++++++++++++++++++++++++++++++++++++-----------------
 fs/btrfs/volumes.h |  2 +-
 2 files changed, 65 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2231275..ddd7483 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -53,6 +53,45 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
 DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
 
+/*
+ * Dereference the device name under the uuid_mutex.
+ */
+static inline struct rcu_string *
+btrfs_dev_rcu_protected_name(struct btrfs_device *dev)
+__must_hold(&uuid_mutex)
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
+static inline int btrfs_dev_rename(struct btrfs_device *dev, const char *name)
+__must_hold(&uuid_mutex)
+{
+	struct rcu_string *old_name, *new_name;
+
+	new_name = rcu_string_strdup(name, GFP_NOFS);
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
@@ -104,7 +143,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 		device = list_entry(fs_devices->devices.next,
 				    struct btrfs_device, dev_list);
 		list_del(&device->dev_list);
-		rcu_string_free(device->name);
+		rcu_string_free(btrfs_dev_rcu_only_name(device));
 		kfree(device);
 	}
 	kfree(fs_devices);
@@ -485,12 +524,10 @@ static noinline int device_list_add(const char *path,
 			return PTR_ERR(device);
 		}
 
-		name = rcu_string_strdup(path, GFP_NOFS);
-		if (!name) {
+		if (btrfs_dev_rename(device, path)) {
 			kfree(device);
 			return -ENOMEM;
 		}
-		rcu_assign_pointer(device->name, name);
 
 		mutex_lock(&fs_devices->device_list_mutex);
 		list_add_rcu(&device->dev_list, &fs_devices->devices);
@@ -499,7 +536,11 @@ static noinline int device_list_add(const char *path,
 
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
 		 * 1. If you are here and if the device->name is NULL that
@@ -537,17 +578,15 @@ static noinline int device_list_add(const char *path,
 			return -EEXIST;
 		}
 
-		name = rcu_string_strdup(path, GFP_NOFS);
-		if (!name)
+		if (btrfs_dev_rename(device, path))
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
@@ -584,17 +623,12 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		if (IS_ERR(device))
 			goto error;
 
-		/*
-		 * This is ok to do without rcu read locked because we hold the
-		 * uuid mutex so nothing we touch in here is going to disappear.
-		 */
-		if (orig_dev->name) {
-			name = rcu_string_strdup(orig_dev->name->str, GFP_NOFS);
-			if (!name) {
+		name = btrfs_dev_rcu_protected_name(orig_dev);
+		if (name) {
+			if (btrfs_dev_rename(device, name->str)) {
 				kfree(device);
 				goto error;
 			}
-			rcu_assign_pointer(device->name, name);
 		}
 
 		list_add(&device->dev_list, &fs_devices->devices);
@@ -656,7 +690,7 @@ again:
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;
-		rcu_string_free(device->name);
+		rcu_string_free(btrfs_dev_rcu_only_name(device));
 		kfree(device);
 	}
 
@@ -679,7 +713,7 @@ static void __free_device(struct work_struct *work)
 	if (device->bdev)
 		blkdev_put(device->bdev, device->mode);
 
-	rcu_string_free(device->name);
+	rcu_string_free(btrfs_dev_rcu_only_name(device));
 	kfree(device);
 }
 
@@ -721,11 +755,10 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 						device->uuid);
 		BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
 
-		/* Safe because we are under uuid_mutex */
-		if (device->name) {
-			name = rcu_string_strdup(device->name->str, GFP_NOFS);
-			BUG_ON(!name); /* -ENOMEM */
-			rcu_assign_pointer(new_device->name, name);
+		name = btrfs_dev_rcu_protected_name(device);
+		if (name) {
+			if (btrfs_dev_rename(new_device, name->str))
+				BUG_ON(1); /* -ENOMEM */
 		}
 
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
@@ -784,18 +817,20 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
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
@@ -2142,7 +2177,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
-		rcu_string_free(device->name);
+		rcu_string_free(btrfs_dev_rcu_only_name(device));
 		kfree(device);
 		ret = PTR_ERR(trans);
 		goto error;
@@ -2279,7 +2314,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 error_trans:
 	btrfs_end_transaction(trans, root);
-	rcu_string_free(device->name);
+	rcu_string_free(btrfs_dev_rcu_only_name(device));
 	btrfs_kobj_rm_device(root->fs_info, device);
 	kfree(device);
 error:
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d6fe73c..234fd20 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -54,7 +54,7 @@ struct btrfs_device {
 
 	struct btrfs_root *dev_root;
 
-	struct rcu_string *name;
+	struct rcu_string __rcu *name;
 
 	u64 generation;
 
-- 
2.2.1

