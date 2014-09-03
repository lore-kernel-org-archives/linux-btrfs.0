Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15896 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932706AbaICNeU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:20 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYHRw006702
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 17/18] Btrfs: move the missing device to its own fs device list
Date: Wed, 3 Sep 2014 21:35:46 +0800
Message-ID: <1409751347-5296-17-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For a missing device, we don't know it belong to which fs before we read its
fsid from the chunk tree. So we add them into the current fs device list at first.
When we get its fsid, we should move them to their own fs device list.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 78 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cc59fcb..b7f093d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5846,10 +5846,10 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 }
 
 static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
+					    struct btrfs_fs_devices *fs_devices,
 					    u64 devid, u8 *dev_uuid)
 {
 	struct btrfs_device *device;
-	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 
 	device = btrfs_alloc_device(NULL, &devid, dev_uuid);
 	if (IS_ERR(device))
@@ -5986,7 +5986,8 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		}
 		if (!map->stripes[i].dev) {
 			map->stripes[i].dev =
-				add_missing_dev(root, devid, uuid);
+				add_missing_dev(root, root->fs_info->fs_devices,
+						devid, uuid);
 			if (!map->stripes[i].dev) {
 				free_extent_map(em);
 				return -EIO;
@@ -6027,7 +6028,8 @@ static void fill_device_from_item(struct extent_buffer *leaf,
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 }
 
-static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
+static struct btrfs_fs_devices *open_seed_devices(struct btrfs_root *root,
+						  u8 *fsid)
 {
 	struct btrfs_fs_devices *fs_devices;
 	int ret;
@@ -6036,49 +6038,56 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
 
 	fs_devices = root->fs_info->fs_devices->seed;
 	while (fs_devices) {
-		if (!memcmp(fs_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
-			ret = 0;
-			goto out;
-		}
+		if (!memcmp(fs_devices->fsid, fsid, BTRFS_UUID_SIZE))
+			return fs_devices;
+
 		fs_devices = fs_devices->seed;
 	}
 
 	fs_devices = find_fsid(fsid);
 	if (!fs_devices) {
-		ret = -ENOENT;
-		goto out;
+		if (!btrfs_test_opt(root, DEGRADED))
+			return ERR_PTR(-ENOENT);
+
+		fs_devices = alloc_fs_devices(fsid);
+		if (IS_ERR(fs_devices))
+			return fs_devices;
+
+		fs_devices->seeding = 1;
+		fs_devices->opened = 1;
+		return fs_devices;
 	}
 
 	fs_devices = clone_fs_devices(fs_devices);
-	if (IS_ERR(fs_devices)) {
-		ret = PTR_ERR(fs_devices);
-		goto out;
-	}
+	if (IS_ERR(fs_devices))
+		return fs_devices;
 
 	ret = __btrfs_open_devices(fs_devices, FMODE_READ,
 				   root->fs_info->bdev_holder);
 	if (ret) {
 		free_fs_devices(fs_devices);
+		fs_devices = ERR_PTR(ret);
 		goto out;
 	}
 
 	if (!fs_devices->seeding) {
 		__btrfs_close_devices(fs_devices);
 		free_fs_devices(fs_devices);
-		ret = -EINVAL;
+		fs_devices = ERR_PTR(-EINVAL);
 		goto out;
 	}
 
 	fs_devices->seed = root->fs_info->fs_devices->seed;
 	root->fs_info->fs_devices->seed = fs_devices;
 out:
-	return ret;
+	return fs_devices;
 }
 
 static int read_one_dev(struct btrfs_root *root,
 			struct extent_buffer *leaf,
 			struct btrfs_dev_item *dev_item)
 {
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	struct btrfs_device *device;
 	u64 devid;
 	int ret;
@@ -6092,31 +6101,48 @@ static int read_one_dev(struct btrfs_root *root,
 			   BTRFS_UUID_SIZE);
 
 	if (memcmp(fs_uuid, root->fs_info->fsid, BTRFS_UUID_SIZE)) {
-		ret = open_seed_devices(root, fs_uuid);
-		if (ret && !(ret == -ENOENT && btrfs_test_opt(root, DEGRADED)))
-			return ret;
+		fs_devices = open_seed_devices(root, fs_uuid);
+		if (IS_ERR(fs_devices))
+			return PTR_ERR(fs_devices);
 	}
 
 	device = btrfs_find_device(root->fs_info, devid, dev_uuid, fs_uuid);
-	if (!device || !device->bdev) {
+	if (!device) {
 		if (!btrfs_test_opt(root, DEGRADED))
 			return -EIO;
 
-		if (!device) {
-			btrfs_warn(root->fs_info, "devid %llu missing", devid);
-			device = add_missing_dev(root, devid, dev_uuid);
-			if (!device)
-				return -ENOMEM;
-		} else if (!device->missing) {
+		btrfs_warn(root->fs_info, "devid %llu missing", devid);
+		device = add_missing_dev(root, fs_devices, devid, dev_uuid);
+		if (!device)
+			return -ENOMEM;
+	} else {
+		if (!device->bdev && !btrfs_test_opt(root, DEGRADED))
+			return -EIO;
+
+		if(!device->bdev && !device->missing) {
 			/*
 			 * this happens when a device that was properly setup
 			 * in the device info lists suddenly goes bad.
 			 * device->bdev is NULL, and so we have to set
 			 * device->missing to one here
 			 */
-			root->fs_info->fs_devices->missing_devices++;
+			device->fs_devices->missing_devices++;
 			device->missing = 1;
 		}
+
+		/* Move the device to its own fs_devices */
+		if (device->fs_devices != fs_devices) {
+			ASSERT(device->missing);
+
+			list_move(&device->dev_list, &fs_devices->devices);
+			device->fs_devices->num_devices--;
+			fs_devices->num_devices++;
+
+			device->fs_devices->missing_devices--;
+			fs_devices->missing_devices++;
+
+			device->fs_devices = fs_devices;
+		}
 	}
 
 	if (device->fs_devices != root->fs_info->fs_devices) {
-- 
1.9.3

