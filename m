Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab3GCOAd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:33 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODWt003963
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/12] Btrfs-progs: don't close the file descriptor 0 when closing a device
Date: Wed, 3 Jul 2013 21:25:10 +0800
Message-Id: <1372857920-4678-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we know, the file descriptor 0 is a special number, so we shouldn't
use it to initialize the file descriptor of the devices, or we might
close this special file descriptor by mistake when we close the devices.
"-1" is a better choice.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfs-find-root.c | 5 ++++-
 disk-io.c         | 5 +++--
 volumes.c         | 7 +++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 810d835..3e1396d 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -76,7 +76,10 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
 	list = &fs_info->fs_devices->devices;
 	list_for_each(next, list) {
 		device = list_entry(next, struct btrfs_device, dev_list);
-		close(device->fd);
+		if (device->fd != -1) {
+			close(device->fd);
+			device->fd = -1;
+		}
 	}
 	return 0;
 }
diff --git a/disk-io.c b/disk-io.c
index 9ffe6e4..4003636 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1270,12 +1270,13 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
 	while (!list_empty(list)) {
 		device = list_entry(list->next, struct btrfs_device, dev_list);
 		list_del_init(&device->dev_list);
-		if (device->fd) {
+		if (device->fd != -1) {
 			fsync(device->fd);
 			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
 				fprintf(stderr, "Warning, could not drop caches\n");
+			close(device->fd);
+			device->fd = -1;
 		}
-		close(device->fd);
 		kfree(device->name);
 		kfree(device->label);
 		kfree(device);
diff --git a/volumes.c b/volumes.c
index d6f81f8..b88385b 100644
--- a/volumes.c
+++ b/volumes.c
@@ -116,6 +116,7 @@ static int device_list_add(const char *path,
 			/* we can safely leave the fs_devices entry around */
 			return -ENOMEM;
 		}
+		device->fd = -1;
 		device->devid = devid;
 		memcpy(device->uuid, disk_super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
@@ -161,8 +162,10 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 again:
 	list_for_each(cur, &fs_devices->devices) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		close(device->fd);
-		device->fd = -1;
+		if (device->fd != -1) {
+			close(device->fd);
+			device->fd = -1;
+		}
 		device->writeable = 0;
 	}
 
-- 
1.8.1.4

