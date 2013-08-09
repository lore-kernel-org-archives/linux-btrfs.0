Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54272 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030305Ab3HIOlp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 10:41:45 -0400
Received: by mail-we0-f169.google.com with SMTP id n5so3645406wev.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Aug 2013 07:41:44 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: fix race between removing a dev and writing sbs
Date: Fri,  9 Aug 2013 15:41:36 +0100
Message-Id: <1376059296-8490-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375992052-17706-1-git-send-email-fdmanana@gmail.com>
References: <1375992052-17706-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This change fixes an issue when removing a device and writing
all super blocks run simultaneously. Here's the steps necessary
for the issue to happen:

1) disk-io.c:write_all_supers() gets a number of N devices from the
   super_copy, so it will not panic if it fails to write super blocks
   for N - 1 devices;

2) Then it tries to acquire the device_list_mutex, but blocks because
   volumes.c:btrfs_rm_device() got it first;

3) btrfs_rm_device() removes the device from the list, then unlocks the
   mutex and after the unlock it updates the number of devices in
   super_copy to N - 1.

4) write_all_supers() finally acquires the mutex, iterates over all the
   devices in the list and gets N - 1 errors, that is, it failed to write
   super blocks to all the devices;

5) Because write_all_supers() thinks there are a total of N devices, it
   considers N - 1 errors to be ok, and therefore won't panic.

So this change just makes sure that write_all_supers() reads the number
of devices from super_copy after it acquires the device_list_mutex.
Conversely, it changes btrfs_rm_device() to update the number of devices
in super_copy before it releases the device list mutex.

The code path to add a new device (volumes.c:btrfs_init_new_device),
already has the right behaviour: it updates the number of devices in
super_copy while holding the device_list_mutex.

The only code path that doesn't lock the device list mutex
before updating the number of devices in the super copy is
disk-io.c:next_root_backup(), called by open_ctree() during
mount time where concurrency issues can't happen.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Restored Stefan Behrens's comment as it's about a different issue,
    and updated the commit message to be more detailed.

 fs/btrfs/disk-io.c |    2 +-
 fs/btrfs/volumes.c |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5de9ad7..e70f9c5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3319,7 +3319,6 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	int total_errors = 0;
 	u64 flags;
 
-	max_errors = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
 	do_barriers = !btrfs_test_opt(root, NOBARRIER);
 	backup_super_roots(root->fs_info);
 
@@ -3328,6 +3327,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	head = &root->fs_info->fs_devices->devices;
+	max_errors = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
 
 	if (do_barriers) {
 		ret = barrier_all_devices(root->fs_info);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c74d702..f62f535 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1588,7 +1588,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	/*
 	 * the device list mutex makes sure that we don't change
 	 * the device list while someone else is writing out all
-	 * the device supers.
+	 * the device supers. Whoever is writing all supers, should
+	 * lock the device list mutex before getting the number of
+	 * devices in the super block (super_copy). Conversely,
+	 * whoever updates the number of devices in the super block
+	 * (super_copy) should hold the device list mutex.
 	 */
 
 	cur_devices = device->fs_devices;
@@ -1612,10 +1616,10 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
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

