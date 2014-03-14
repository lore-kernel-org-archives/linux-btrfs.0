Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22287 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754593AbaCND2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 23:28:36 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2E3SBq1013853
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 11:28:11 +0800
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: Fix a memleak in btrfs_scan_one_device.
Date: Fri, 14 Mar 2014 03:28:11 +0000
Message-ID: <1394767760-19929-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Valgrind reports memleak in btrfs_scan_one_device() about allocating
btrfs_device but on btrfs_close_devices() they are not reclaimed.

Although not a bug since after btrfs_close_devices() btrfs will exit so
memory will be reclaimed by system anyway, it's better to fix it anyway.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-filesystem.c |  6 ++++++
 volumes.c         | 13 ++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f02e871..c9e27fc 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -651,6 +651,12 @@ devs_only:
 	if (search && !found)
 		ret = 1;
 
+	while (!list_empty(all_uuids)) {
+		fs_devices = list_entry(all_uuids->next,
+					struct btrfs_fs_devices, list);
+		list_del(&fs_devices->list);
+		btrfs_close_devices(fs_devices);
+	}
 out:
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	free_seen_fsid();
diff --git a/volumes.c b/volumes.c
index 8c45851..77ffd32 100644
--- a/volumes.c
+++ b/volumes.c
@@ -160,11 +160,12 @@ static int device_list_add(const char *path,
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_fs_devices *seed_devices;
-	struct list_head *cur;
 	struct btrfs_device *device;
+
 again:
-	list_for_each(cur, &fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	while (!list_empty(&fs_devices->devices)) {
+		device = list_entry(fs_devices->devices.next,
+				    struct btrfs_device, dev_list);
 		if (device->fd != -1) {
 			fsync(device->fd);
 			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
@@ -173,6 +174,11 @@ again:
 			device->fd = -1;
 		}
 		device->writeable = 0;
+		list_del(&device->dev_list);
+		/* free the memory */
+		free(device->name);
+		free(device->label);
+		free(device);
 	}
 
 	seed_devices = fs_devices->seed;
@@ -182,6 +188,7 @@ again:
 		goto again;
 	}
 
+	free(fs_devices);
 	return 0;
 }
 
-- 
1.9.0
