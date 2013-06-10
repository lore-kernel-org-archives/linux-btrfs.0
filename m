Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:61361 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3FJUIN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 16:08:13 -0400
Received: by mail-we0-f180.google.com with SMTP id w56so5291505wes.11
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 13:08:11 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/5] Btrfs-progs: fix closing of devices
Date: Mon, 10 Jun 2013 21:07:55 +0100
Message-Id: <1370894875-26129-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1370893895-24884-2-git-send-email-fdmanana@gmail.com>
References: <1370893895-24884-2-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a device could not be opened in volumes.c:read_one_dev(), a
btrfs_device instance was allocated and added to the list of
devices of the fs - however this device instance had its fd,
name and label fields not initialized. This is problematic in
disk-io.c:close_all_devices() as it tries to close the (invalid)
fd of the device and kfree() its name and label, which point
to random memory locations.

  Thread 1 (Thread 0x7f0a3d2d1740 (LWP 23585)):
  #0  __GI___libc_free (mem=0xa5a5a5a5a5a5a5a5) at malloc.c:2970
  #1  0x000000000042054b in close_all_devices (fs_info=0x1e92bf0) at disk-io.c:1276
  #2  0x0000000000421dcd in close_ctree (root=<optimized out>) at disk-io.c:1336
  #3  0x0000000000418cfa in cmd_check (argc=<optimized out>, argv=<optimized out>) at cmds-check.c:4171
  #4  0x0000000000403ed4 in main (argc=2, argv=0x7fff9a583d28) at btrfs.c:295

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 disk-io.c |    4 ++--
 volumes.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 21b410d..353e0aa 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1267,12 +1267,12 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
 	while (!list_empty(list)) {
 		device = list_entry(list->next, struct btrfs_device, dev_list);
 		list_del_init(&device->dev_list);
-		if (device->fd) {
+		if (device->fd > 0) {
 			fsync(device->fd);
 			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
 				fprintf(stderr, "Warning, could not drop caches\n");
+			close(device->fd);
 		}
-		close(device->fd);
 		kfree(device->name);
 		kfree(device->label);
 		kfree(device);
diff --git a/volumes.c b/volumes.c
index d6f81f8..3f69c37 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1628,10 +1628,9 @@ static int read_one_dev(struct btrfs_root *root,
 	if (!device) {
 		printk("warning devid %llu not found already\n",
 			(unsigned long long)devid);
-		device = kmalloc(sizeof(*device), GFP_NOFS);
+		device = kzalloc(sizeof(*device), GFP_NOFS);
 		if (!device)
 			return -ENOMEM;
-		device->total_ios = 0;
 		list_add(&device->dev_list,
 			 &root->fs_info->fs_devices->devices);
 	}
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
