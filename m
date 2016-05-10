Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18547 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbcEJOJz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:09:55 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 13/13] btrfs: check for failed device and hot replace
Date: Tue, 10 May 2016 22:09:32 +0800
Message-Id: <1462889372-5274-15-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This patch checks for failed device and kicks out auto
replace, if when user decided to disable auto replace
it can be done by future sysfs or future ioctl interface
to set fs_info->no_auto_replace parameter to 1.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Tested-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/disk-io.c | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

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
index 1deb5714cc3a..5c5c51319bec 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1876,6 +1876,39 @@ sleep:
 	return 0;
 }
 
+static int btrfs_recuperate(struct btrfs_root *root)
+{
+	int ret;
+	u64 failed_devid = 0;
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *fs_devices;
+
+	fs_devices = root->fs_info->fs_devices;
+
+	/* fixme: does it need device_list_mutex */
+	mutex_lock(&fs_devices->device_list_mutex);
+	rcu_read_lock();
+	list_for_each_entry_rcu(device,
+			&fs_devices->devices, dev_list) {
+		if (device->failed) {
+			failed_devid = device->devid;
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
+	if (failed_devid && !root->fs_info->no_auto_replace)
+		ret = btrfs_auto_replace_start(root, failed_devid);
+
+	return ret;
+}
+
 /*
  * returns:
  * < 0 : Check didn't run, std error
@@ -1951,6 +1984,8 @@ static int health_kthread(void *arg)
 		/* Check devices health */
 		btrfs_update_devices_health(root);
 
+		btrfs_recuperate(root);
+
 		mutex_unlock(&root->fs_info->health_mutex);
 
 sleep:
-- 
2.7.0

