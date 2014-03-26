Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbaCZR0k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 13:26:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3F064ACC6
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Mar 2014 17:26:39 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: make device scan less noisy
Date: Wed, 26 Mar 2014 18:26:36 +0100
Message-Id: <1395854796-11028-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Print the message only when the device is seen for the first time.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/volumes.c |   35 ++++++++++++++++++++++++-----------
 1 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bab0b84d8f80..d3694f347afb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -447,6 +447,14 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
+/*
+ * Add new device to list of registered devices
+ *
+ * Returns:
+ * 1   - first time device is seen
+ * 0   - device already known
+ * < 0 - error
+ */
 static noinline int device_list_add(const char *path,
 			   struct btrfs_super_block *disk_super,
 			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
@@ -454,6 +462,7 @@ static noinline int device_list_add(const char *path,
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
 	struct rcu_string *name;
+	int ret = 0;
 	u64 found_transid = btrfs_super_generation(disk_super);
 
 	fs_devices = find_fsid(disk_super->fsid);
@@ -494,6 +503,7 @@ static noinline int device_list_add(const char *path,
 		fs_devices->num_devices++;
 		mutex_unlock(&fs_devices->device_list_mutex);
 
+		ret = 1;
 		device->fs_devices = fs_devices;
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		name = rcu_string_strdup(path, GFP_NOFS);
@@ -512,7 +522,8 @@ static noinline int device_list_add(const char *path,
 		fs_devices->latest_trans = found_transid;
 	}
 	*fs_devices_ret = fs_devices;
-	return 0;
+
+	return ret;
 }
 
 static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
@@ -909,17 +920,19 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
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
+	if (ret > 0) {
+		if (disk_super->label[0]) {
+			if (disk_super->label[BTRFS_LABEL_SIZE - 1])
+				disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';
+			printk(KERN_INFO "BTRFS: device label %s ", disk_super->label);
+		} else {
+			printk(KERN_INFO "BTRFS: device fsid %pU ", disk_super->fsid);
+		}
+
+		printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
+		ret = 0;
+	}
 	if (!ret && fs_devices_ret)
 		(*fs_devices_ret)->total_devices = total_devices;
 
-- 
1.7.9

