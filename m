Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:46222 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab3HLLd0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 07:33:26 -0400
Received: by mail-la0-f43.google.com with SMTP id ep20so4633110lab.16
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 04:33:25 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH 3/4] Btrfs: add alloc_fs_devices and switch to it
Date: Mon, 12 Aug 2013 14:33:03 +0300
Message-Id: <1376307184-7175-4-git-send-email-idryomov@gmail.com>
In-Reply-To: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
References: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the spirit of btrfs_alloc_device, add a helper for allocating and
doing some common initialization of btrfs_fs_devices struct.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   71 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fe52704..af17b17 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -62,6 +62,48 @@ static void unlock_chunks(struct btrfs_root *root)
 	mutex_unlock(&root->fs_info->chunk_mutex);
 }
 
+static struct btrfs_fs_devices *__alloc_fs_devices(void)
+{
+	struct btrfs_fs_devices *fs_devs;
+
+	fs_devs = kzalloc(sizeof(*fs_devs), GFP_NOFS);
+	if (!fs_devs)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&fs_devs->device_list_mutex);
+
+	INIT_LIST_HEAD(&fs_devs->devices);
+	INIT_LIST_HEAD(&fs_devs->alloc_list);
+	INIT_LIST_HEAD(&fs_devs->list);
+
+	return fs_devs;
+}
+
+/**
+ * alloc_fs_devices - allocate struct btrfs_fs_devices
+ * @fsid:	a pointer to UUID for this FS.  If NULL a new UUID is
+ *		generated.
+ *
+ * Return: a pointer to a new &struct btrfs_fs_devices on success;
+ * ERR_PTR() on error.  Returned struct is not linked onto any lists and
+ * can be destroyed with kfree() right away.
+ */
+static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
+{
+	struct btrfs_fs_devices *fs_devs;
+
+	fs_devs = __alloc_fs_devices();
+	if (IS_ERR(fs_devs))
+		return fs_devs;
+
+	if (fsid)
+		memcpy(fs_devs->fsid, fsid, BTRFS_FSID_SIZE);
+	else
+		generate_random_uuid(fs_devs->fsid);
+
+	return fs_devs;
+}
+
 static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
@@ -416,16 +458,14 @@ static noinline int device_list_add(const char *path,
 
 	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
-		fs_devices = kzalloc(sizeof(*fs_devices), GFP_NOFS);
-		if (!fs_devices)
-			return -ENOMEM;
-		INIT_LIST_HEAD(&fs_devices->devices);
-		INIT_LIST_HEAD(&fs_devices->alloc_list);
+		fs_devices = alloc_fs_devices(disk_super->fsid);
+		if (IS_ERR(fs_devices))
+			return PTR_ERR(fs_devices);
+
 		list_add(&fs_devices->list, &fs_uuids);
-		memcpy(fs_devices->fsid, disk_super->fsid, BTRFS_FSID_SIZE);
 		fs_devices->latest_devid = devid;
 		fs_devices->latest_trans = found_transid;
-		mutex_init(&fs_devices->device_list_mutex);
+
 		device = NULL;
 	} else {
 		device = __find_device(&fs_devices->devices, devid,
@@ -481,18 +521,13 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	struct btrfs_device *device;
 	struct btrfs_device *orig_dev;
 
-	fs_devices = kzalloc(sizeof(*fs_devices), GFP_NOFS);
-	if (!fs_devices)
-		return ERR_PTR(-ENOMEM);
+	fs_devices = alloc_fs_devices(orig->fsid);
+	if (IS_ERR(fs_devices))
+		return fs_devices;
 
-	INIT_LIST_HEAD(&fs_devices->devices);
-	INIT_LIST_HEAD(&fs_devices->alloc_list);
-	INIT_LIST_HEAD(&fs_devices->list);
-	mutex_init(&fs_devices->device_list_mutex);
 	fs_devices->latest_devid = orig->latest_devid;
 	fs_devices->latest_trans = orig->latest_trans;
 	fs_devices->total_devices = orig->total_devices;
-	memcpy(fs_devices->fsid, orig->fsid, sizeof(fs_devices->fsid));
 
 	/* We have held the volume lock, it is safe to get the devices. */
 	list_for_each_entry(orig_dev, &orig->devices, dev_list) {
@@ -1794,9 +1829,9 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	if (!fs_devices->seeding)
 		return -EINVAL;
 
-	seed_devices = kzalloc(sizeof(*fs_devices), GFP_NOFS);
-	if (!seed_devices)
-		return -ENOMEM;
+	seed_devices = __alloc_fs_devices();
+	if (IS_ERR(seed_devices))
+		return PTR_ERR(seed_devices);
 
 	old_devices = clone_fs_devices(fs_devices);
 	if (IS_ERR(old_devices)) {
-- 
1.7.10.4

