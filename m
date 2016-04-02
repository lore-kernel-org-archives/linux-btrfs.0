Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23952 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415AbcDBBbc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 21:31:32 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: yauhen.kharuzhy@zavadatar.com, dsterba@suse.cz
Subject: [PATCH 13/13] btrfs: check for failed device and hot replace
Date: Sat,  2 Apr 2016 09:30:51 +0800
Message-Id: <1459560651-14809-14-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch checks for failed device and kicks out auto
replace, if when user decided to disable auto replace
it can be done by future sysfs or future ioctl interface
to set fs_info->no_auto_replace parameter to 1.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/disk-io.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 47e9cd9dd29a..67bb36bb82ee 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1862,6 +1862,8 @@ struct btrfs_fs_info {
 	struct list_head pinned_chunks;
 
 	int creating_free_space_tree;
+
+	int no_auto_replace;
 };
 
 struct btrfs_subvolume_writers {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b523e56b34e9..f205e7e94948 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1869,6 +1869,38 @@ sleep:
 	return 0;
 }
 
+static int btrfs_recuperate(struct btrfs_root *root)
+{
+	int ret;
+	int found = 0;
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *fs_devices;
+
+	fs_devices = root->fs_info->fs_devices;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	rcu_read_lock();
+	list_for_each_entry_rcu(device,
+			&fs_devices->devices, dev_list) {
+		if (device->failed) {
+			found = 1;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	/*
+	 * We are using the replace code which should be interrupt-able
+	 * during unmount, and as of now there is no user land stop
+	 * request that we support and this will run until its complete
+	 */
+	if (found && !root->fs_info->no_auto_replace)
+		ret = btrfs_auto_replace_start(root, device);
+
+	return ret;
+}
+
 /*
  * returns:
  * < 0 : Check didn't run, std error
@@ -1944,6 +1976,8 @@ static int health_kthread(void *arg)
 		/* Check devices health */
 		btrfs_update_devices_health(root);
 
+		btrfs_recuperate(root);
+
 		mutex_unlock(&root->fs_info->health_mutex);
 
 sleep:
-- 
2.7.0

