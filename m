Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39542 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab3HLLdY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 07:33:24 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so4697914lbh.9
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 04:33:23 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH 2/4] Btrfs: add btrfs_alloc_device and switch to it
Date: Mon, 12 Aug 2013 14:33:02 +0300
Message-Id: <1376307184-7175-3-git-send-email-idryomov@gmail.com>
In-Reply-To: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
References: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs_device is allocated ad-hoc in a few different places,
and as a result not all fields are initialized properly.  In particular,
readahead state is only initialized in device_list_add (at scan time),
and not in btrfs_init_new_device (when the new device is added with
'btrfs dev add').  Fix this by adding an allocation helper and switch
everybody but __btrfs_close_devices to it.  (__btrfs_close_devices is
dealt with in a later commit.)

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |  150 ++++++++++++++++++++++++++++++++--------------------
 fs/btrfs/volumes.h |    3 ++
 2 files changed, 96 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ae1bcb0..fe52704 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -101,6 +101,27 @@ void btrfs_cleanup_fs_uuids(void)
 	}
 }
 
+static struct btrfs_device *__alloc_device(void)
+{
+	struct btrfs_device *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_NOFS);
+	if (!dev)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&dev->dev_list);
+	INIT_LIST_HEAD(&dev->dev_alloc_list);
+
+	spin_lock_init(&dev->io_lock);
+
+	spin_lock_init(&dev->reada_lock);
+	atomic_set(&dev->reada_in_flight, 0);
+	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_WAIT);
+	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_WAIT);
+
+	return dev;
+}
+
 static noinline struct btrfs_device *__find_device(struct list_head *head,
 						   u64 devid, u8 *uuid)
 {
@@ -414,17 +435,12 @@ static noinline int device_list_add(const char *path,
 		if (fs_devices->opened)
 			return -EBUSY;
 
-		device = kzalloc(sizeof(*device), GFP_NOFS);
-		if (!device) {
+		device = btrfs_alloc_device(NULL, &devid,
+					    disk_super->dev_item.uuid);
+		if (IS_ERR(device)) {
 			/* we can safely leave the fs_devices entry around */
-			return -ENOMEM;
+			return PTR_ERR(device);
 		}
-		device->devid = devid;
-		device->dev_stats_valid = 0;
-		device->work.func = pending_bios_fn;
-		memcpy(device->uuid, disk_super->dev_item.uuid,
-		       BTRFS_UUID_SIZE);
-		spin_lock_init(&device->io_lock);
 
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name) {
@@ -432,15 +448,6 @@ static noinline int device_list_add(const char *path,
 			return -ENOMEM;
 		}
 		rcu_assign_pointer(device->name, name);
-		INIT_LIST_HEAD(&device->dev_alloc_list);
-
-		/* init readahead state */
-		spin_lock_init(&device->reada_lock);
-		device->reada_curr_zone = NULL;
-		atomic_set(&device->reada_in_flight, 0);
-		device->reada_next = 0;
-		INIT_RADIX_TREE(&device->reada_zones, GFP_NOFS & ~__GFP_WAIT);
-		INIT_RADIX_TREE(&device->reada_extents, GFP_NOFS & ~__GFP_WAIT);
 
 		mutex_lock(&fs_devices->device_list_mutex);
 		list_add_rcu(&device->dev_list, &fs_devices->devices);
@@ -491,8 +498,9 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	list_for_each_entry(orig_dev, &orig->devices, dev_list) {
 		struct rcu_string *name;
 
-		device = kzalloc(sizeof(*device), GFP_NOFS);
-		if (!device)
+		device = btrfs_alloc_device(NULL, &orig_dev->devid,
+					    orig_dev->uuid);
+		if (IS_ERR(device))
 			goto error;
 
 		/*
@@ -506,13 +514,6 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		}
 		rcu_assign_pointer(device->name, name);
 
-		device->devid = orig_dev->devid;
-		device->work.func = pending_bios_fn;
-		memcpy(device->uuid, orig_dev->uuid, sizeof(device->uuid));
-		spin_lock_init(&device->io_lock);
-		INIT_LIST_HEAD(&device->dev_list);
-		INIT_LIST_HEAD(&device->dev_alloc_list);
-
 		list_add(&device->dev_list, &fs_devices->devices);
 		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
@@ -1956,10 +1957,10 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
-	device = kzalloc(sizeof(*device), GFP_NOFS);
-	if (!device) {
+	device = btrfs_alloc_device(root->fs_info, NULL, NULL);
+	if (IS_ERR(device)) {
 		/* we can safely leave the fs_devices entry around */
-		ret = -ENOMEM;
+		ret = PTR_ERR(device);
 		goto error;
 	}
 
@@ -1971,13 +1972,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 	rcu_assign_pointer(device->name, name);
 
-	ret = find_next_devid(root->fs_info, &device->devid);
-	if (ret) {
-		rcu_string_free(device->name);
-		kfree(device);
-		goto error;
-	}
-
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		rcu_string_free(device->name);
@@ -1992,9 +1986,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (blk_queue_discard(q))
 		device->can_discard = 1;
 	device->writeable = 1;
-	device->work.func = pending_bios_fn;
-	generate_random_uuid(device->uuid);
-	spin_lock_init(&device->io_lock);
 	device->generation = trans->transid;
 	device->io_width = root->sectorsize;
 	device->io_align = root->sectorsize;
@@ -2142,9 +2133,9 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 		}
 	}
 
-	device = kzalloc(sizeof(*device), GFP_NOFS);
-	if (!device) {
-		ret = -ENOMEM;
+	device = btrfs_alloc_device(NULL, BTRFS_DEV_REPLACE_DEVID, NULL);
+	if (IS_ERR(device)) {
+		ret = PTR_ERR(device);
 		goto error;
 	}
 
@@ -2161,10 +2152,6 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 		device->can_discard = 1;
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	device->writeable = 1;
-	device->work.func = pending_bios_fn;
-	generate_random_uuid(device->uuid);
-	device->devid = BTRFS_DEV_REPLACE_DEVID;
-	spin_lock_init(&device->io_lock);
 	device->generation = 0;
 	device->io_width = root->sectorsize;
 	device->io_align = root->sectorsize;
@@ -5314,23 +5301,72 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 
-	device = kzalloc(sizeof(*device), GFP_NOFS);
-	if (!device)
+	device = btrfs_alloc_device(NULL, &devid, dev_uuid);
+	if (IS_ERR(device))
 		return NULL;
-	list_add(&device->dev_list,
-		 &fs_devices->devices);
-	device->devid = devid;
-	device->work.func = pending_bios_fn;
+
+	list_add(&device->dev_list, &fs_devices->devices);
 	device->fs_devices = fs_devices;
-	device->missing = 1;
 	fs_devices->num_devices++;
+
+	device->missing = 1;
 	fs_devices->missing_devices++;
-	spin_lock_init(&device->io_lock);
-	INIT_LIST_HEAD(&device->dev_alloc_list);
-	memcpy(device->uuid, dev_uuid, BTRFS_UUID_SIZE);
+
 	return device;
 }
 
+/**
+ * btrfs_alloc_device - allocate struct btrfs_device
+ * @fs_info:	used only for generating a new devid, can be NULL if
+ *		devid is provided (i.e. @devid != NULL).
+ * @devid:	a pointer to devid for this device.  If NULL a new devid
+ *		is generated.
+ * @uuid:	a pointer to UUID for this device.  If NULL a new UUID
+ *		is generated.
+ *
+ * Return: a pointer to a new &struct btrfs_device on success; ERR_PTR()
+ * on error.  Returned struct is not linked onto any lists and can be
+ * destroyed with kfree() right away.
+ */
+struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
+					const u64 *devid,
+					const u8 *uuid)
+{
+	struct btrfs_device *dev;
+	u64 tmp;
+
+	if (!devid && !fs_info) {
+		WARN_ON(1);
+		return ERR_PTR(-EINVAL);
+	}
+
+	dev = __alloc_device();
+	if (IS_ERR(dev))
+		return dev;
+
+	if (devid)
+		tmp = *devid;
+	else {
+		int ret;
+
+		ret = find_next_devid(fs_info, &tmp);
+		if (ret) {
+			kfree(dev);
+			return ERR_PTR(ret);
+		}
+	}
+	dev->devid = tmp;
+
+	if (uuid)
+		memcpy(dev->uuid, uuid, BTRFS_UUID_SIZE);
+	else
+		generate_random_uuid(dev->uuid);
+
+	dev->work.func = pending_bios_fn;
+
+	return dev;
+}
+
 static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8670558..5706cd8 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -298,6 +298,9 @@ void btrfs_close_extra_devices(struct btrfs_fs_info *fs_info,
 int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 					 char *device_path,
 					 struct btrfs_device **device);
+struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
+					const u64 *devid,
+					const u8 *uuid);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
 void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
-- 
1.7.10.4

