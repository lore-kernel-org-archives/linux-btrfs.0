Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63995 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3HLT5K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 15:57:10 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so5865555wes.19
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 12:57:08 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix race conditions in BTRFS_IOC_FS_INFO ioctl
Date: Mon, 12 Aug 2013 20:56:58 +0100
Message-Id: <1376337418-11342-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The handler for the ioctl BTRFS_IOC_FS_INFO was reading the
number of devices before acquiring the device list mutex.

This could lead to inconsistent results because the update of
the device list and the number of devices counter (amongst other
counters related to the device list) are updated in volumes.c
while holding the device list mutex - except for 2 places, one
was volumes.c:btrfs_prepare_sprout() and the other was
volumes.c:device_list_add().

For example, if we have 2 devices, with IDs 1 and 2 and then add
a new device, with ID 3, and while adding the device is in progress
an BTRFS_IOC_FS_INFO ioctl arrives, it could return a number of
devices of 2 and a max dev id of 3. This would be incorrect.

Also, this ioctl handler was reading the fsid while it can be
updated concurrently. This can happen when while a new device is
being added and the current filesystem is in seeding mode.
Example:

$ mkfs.btrfs -f /dev/sdb1
$ mkfs.btrfs -f /dev/sdb2
$ btrfstune -S 1 /dev/sdb1
$ mount /dev/sdb1 /mnt/test
$ btrfs device add /dev/sdb2 /mnt/test

If during the last step a BTRFS_IOC_FS_INFO ioctl was requested, it
could read an fsid that was never valid (some bits part of the old
fsid and others part of the new fsid). Also, it could read a number
of devices that doesn't match the number of devices in the list and
the max device id, as explained before.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c   |    2 +-
 fs/btrfs/volumes.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2312c0f..8484de3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2405,10 +2405,10 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 	if (!fi_args)
 		return -ENOMEM;
 
+	mutex_lock(&fs_devices->device_list_mutex);
 	fi_args->num_devices = fs_devices->num_devices;
 	memcpy(&fi_args->fsid, root->fs_info->fsid, sizeof(fi_args->fsid));
 
-	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
 		if (device->devid > fi_args->max_id)
 			fi_args->max_id = device->devid;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 44abd15..4f465fc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -444,10 +444,10 @@ static noinline int device_list_add(const char *path,
 
 		mutex_lock(&fs_devices->device_list_mutex);
 		list_add_rcu(&device->dev_list, &fs_devices->devices);
+		fs_devices->num_devices++;
 		mutex_unlock(&fs_devices->device_list_mutex);
 
 		device->fs_devices = fs_devices;
-		fs_devices->num_devices++;
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name)
@@ -1816,7 +1816,6 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	list_splice_init_rcu(&fs_devices->devices, &seed_devices->devices,
 			      synchronize_rcu);
-	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	list_splice_init(&fs_devices->alloc_list, &seed_devices->alloc_list);
 	list_for_each_entry(device, &seed_devices->devices, dev_list) {
@@ -1832,6 +1831,8 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	generate_random_uuid(fs_devices->fsid);
 	memcpy(root->fs_info->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+
 	super_flags = btrfs_super_flags(disk_super) &
 		      ~BTRFS_SUPER_FLAG_SEEDING;
 	btrfs_set_super_flags(disk_super, super_flags);
-- 
1.7.9.5

