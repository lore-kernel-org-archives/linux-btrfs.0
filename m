Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:52154 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966063Ab3HHUBe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 16:01:34 -0400
Received: by mail-we0-f173.google.com with SMTP id x55so2949375wes.32
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Aug 2013 13:01:33 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sbehrens@giantdisaster.de, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix race between removing a dev and writing sbs
Date: Thu,  8 Aug 2013 21:00:52 +0100
Message-Id: <1375992052-17706-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since all code paths that update the number of devices in the
super copy (fs_info->super_copy) first lock the device list
(fs_info->fs_devices->device_list_mutex), and write_all_supers()
also needs to lock the devices list mutex, make write_all_supers()
read the number of devices from the super copy after it locks
the device list mutex (and before unlocking it of course).

The only code path that doesn't lock the device list mutex
before updating the number of devices in the super copy is
disk-io.c:next_root_backup(), called by open_ctree() during
mount time where concurrency issues can't happen.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/disk-io.c |    2 +-
 fs/btrfs/volumes.c |   11 ++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 254cdc8..c4b24c7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3313,7 +3313,6 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	int total_errors = 0;
 	u64 flags;
 
-	max_errors = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
 	do_barriers = !btrfs_test_opt(root, NOBARRIER);
 	backup_super_roots(root->fs_info);
 
@@ -3322,6 +3321,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	head = &root->fs_info->fs_devices->devices;
+	max_errors = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
 
 	if (do_barriers) {
 		ret = barrier_all_devices(root->fs_info);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 090f57c..eddf386 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1568,11 +1568,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (ret)
 		goto error_undo;
 
-	/*
-	 * TODO: the superblock still includes this device in its num_devices
-	 * counter although write_all_supers() is not locked out. This
-	 * could give a filesystem state which requires a degraded mount.
-	 */
 	ret = btrfs_rm_dev_item(root->fs_info->chunk_root, device);
 	if (ret)
 		goto error_undo;
@@ -1588,7 +1583,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	/*
 	 * the device list mutex makes sure that we don't change
 	 * the device list while someone else is writing out all
-	 * the device supers.
+	 * the device supers. Whoever is writing all supers, should
+	 * lock the device list mutex before getting the number of
+	 * devices in the super block (super_copy).
 	 */
 
 	cur_devices = device->fs_devices;
@@ -1612,10 +1609,10 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		device->fs_devices->open_devices--;
 
 	call_rcu(&device->rcu, free_device);
-	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	num_devices = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
 	btrfs_set_super_num_devices(root->fs_info->super_copy, num_devices);
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	if (cur_devices->open_devices == 0) {
 		struct btrfs_fs_devices *fs_devices;
-- 
1.7.9.5

