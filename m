Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1030640AbeF1TEA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 15:04:00 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: anand.jain@oracle.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] Revert "btrfs: fix a possible umount deadlock"
Date: Thu, 28 Jun 2018 11:48:15 +0300
Message-Id: <1530175695-301-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit 88c14590cdd6 ("btrfs: use RCU in btrfs_show_devname for
device list traversal") btrfs_show_devname no longer takes
device_list_mutex. As such the deadlock that 0ccd05285e7f ("btrfs: fix
a possible umount deadlock") aimed to fix no longer exists. So remove the 
extra code this commit added. No functional changes. 

This reverts commit 0ccd05285e7f5a8e297e1d6dfc41e7c65757d6fa.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Anand, 

I would like to use the opportunity to ask you about the peculiar 
sequence needed to close btrfs devices. Why do we first replace the closed 
device with a copy in btrfs_close_one_device, then dispose of the copied
devices in btrfs_close_devices IFF we had fs_devices->seed not being NULL? 

 fs/btrfs/volumes.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5bd6f3a40f9c..70b0ed2ba4df 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1004,7 +1004,7 @@ static void btrfs_close_bdev(struct btrfs_device *device)
 	blkdev_put(device->bdev, device->mode);
 }
 
-static void btrfs_prepare_close_one_device(struct btrfs_device *device)
+static void btrfs_close_one_device(struct btrfs_device *device)
 {
 	struct btrfs_fs_devices *fs_devices = device->fs_devices;
 	struct btrfs_device *new_device;
@@ -1022,6 +1022,8 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
 	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
 		fs_devices->missing_devices--;
 
+	btrfs_close_bdev(device);
+
 	new_device = btrfs_alloc_device(NULL, &device->devid,
 					device->uuid);
 	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
@@ -1035,39 +1037,23 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
 
 	list_replace_rcu(&device->dev_list, &new_device->dev_list);
 	new_device->fs_devices = device->fs_devices;
+
+	call_rcu(&device->rcu, free_device);
 }
 
 static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device, *tmp;
-	struct list_head pending_put;
-
-	INIT_LIST_HEAD(&pending_put);
 
 	if (--fs_devices->opened > 0)
 		return 0;
 
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list) {
-		btrfs_prepare_close_one_device(device);
-		list_add(&device->dev_list, &pending_put);
+		btrfs_close_one_device(device);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	/*
-	 * btrfs_show_devname() is using the device_list_mutex,
-	 * sometimes call to blkdev_put() leads vfs calling
-	 * into this func. So do put outside of device_list_mutex,
-	 * as of now.
-	 */
-	while (!list_empty(&pending_put)) {
-		device = list_first_entry(&pending_put,
-				struct btrfs_device, dev_list);
-		list_del(&device->dev_list);
-		btrfs_close_bdev(device);
-		call_rcu(&device->rcu, free_device_rcu);
-	}
-
 	WARN_ON(fs_devices->open_devices);
 	WARN_ON(fs_devices->rw_devices);
 	fs_devices->opened = 0;
-- 
2.7.4

