Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41872 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaE2JPF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 05:15:05 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: [PATCH] btrfs: print only if scanned device becomes part of the fs_devices
Date: Thu, 29 May 2014 17:18:01 +0800
Message-Id: <1401355081-12817-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

justification:
  a deleted missing disk if reappears would end up with -EBUSY when
  it undergoes btrfs dev scan. But the sys log indicates bringing the
  disk back to the btrfs kernel was successful

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a1cb877..275e4d1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -911,20 +911,21 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
 
-	if (disk_super->label[0]) {
-		if (disk_super->label[BTRFS_LABEL_SIZE - 1])
-			disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';
-		printk(KERN_INFO "BTRFS: device label %s ", disk_super->label);
-	} else {
-		printk(KERN_INFO "BTRFS: device fsid %pU ", disk_super->fsid);
-	}
-
-	printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
-
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
-	if (!ret && fs_devices_ret)
+	if (!ret && fs_devices_ret) {
 		(*fs_devices_ret)->total_devices = total_devices;
 
+		if (disk_super->label[0]) {
+			if (disk_super->label[BTRFS_LABEL_SIZE - 1])
+				disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';
+			printk(KERN_INFO "BTRFS: device label %s ", disk_super->label);
+		} else {
+			printk(KERN_INFO "BTRFS: device fsid %pU ", disk_super->fsid);
+		}
+		printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
+	}
+
+
 error_unmap:
 	kunmap(page);
 	page_cache_release(page);
-- 
1.7.1

