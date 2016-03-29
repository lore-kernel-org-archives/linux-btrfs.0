Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbcC2OWy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:22:54 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 06/12] btrfs: introduce device dynamic state transition to offline or failed
Date: Tue, 29 Mar 2016 22:22:23 +0800
Message-Id: <1459261349-32206-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Need device forced offline/failed feature for the following reasons,
1) a. it can be reported that device has failed when it does
   b. close the device when it goes offline so that blocklayer can
      cleanup
2) identify the candidate for the auto replace
3) avoid further commit error reported against the failing device and
4) a device in the multi device btrfs may go offline from the system
   (but as of now in in some system config btrfs gets unmounted in this
    context, which is not a correct behavior)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 137 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  14 ++++++
 2 files changed, 151 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dff2deaf88d3..a662701d4f22 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7092,3 +7092,140 @@ out:
 	read_unlock(&map_tree->map_tree.lock);
 	return ret;
 }
+
+static void __close_device(struct work_struct *work)
+{
+	struct btrfs_device *device;
+
+	device = container_of(work, struct btrfs_device, rcu_work);
+
+	if (device->bdev)
+		blkdev_put(device->bdev, device->mode);
+
+	device->bdev = NULL;
+}
+
+static void close_device(struct rcu_head *head)
+{
+	struct btrfs_device *device;
+
+	device = container_of(head, struct btrfs_device, rcu);
+
+	INIT_WORK(&device->rcu_work, __close_device);
+	schedule_work(&device->rcu_work);
+}
+
+void btrfs_close_one_device_dont_free(struct btrfs_device *device)
+{
+	struct btrfs_fs_devices *fs_devices = device->fs_devices;
+
+	if (device->bdev)
+		fs_devices->open_devices--;
+
+	if (device->writeable &&
+	    device->devid != BTRFS_DEV_REPLACE_DEVID) {
+		list_del_init(&device->dev_alloc_list);
+		fs_devices->rw_devices--;
+	}
+
+	device->writeable = 0;
+
+	call_rcu(&device->rcu, close_device);
+}
+
+void force_device_close(struct btrfs_device *device)
+{
+	struct btrfs_device *next_device;
+	struct btrfs_fs_devices *fs_devices;
+
+	fs_devices = device->fs_devices;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	lock_chunks(fs_devices->fs_info->fs_root);
+
+	next_device = list_entry(fs_devices->devices.next,
+					struct btrfs_device, dev_list);
+	if (device->bdev == fs_devices->fs_info->sb->s_bdev)
+		fs_devices->fs_info->sb->s_bdev = next_device->bdev;
+
+	if (device->bdev == fs_devices->latest_bdev)
+		fs_devices->latest_bdev = next_device->bdev;
+
+	btrfs_close_one_device_dont_free(device);
+
+	/*
+	 * TODO: works for now, but its better to keep the state of
+	 * missing and offline different, and update rest of the
+	 * places where we check for only missing and not for failed
+	 * or offline as of now.
+	 */
+	device->missing = 1;
+	fs_devices->missing_devices++;
+	device->writeable = 0;
+
+	rcu_barrier();
+
+	unlock_chunks(fs_devices->fs_info->fs_root);
+	mutex_unlock(&fs_devices->device_list_mutex);
+}
+
+void btrfs_force_device_close(struct btrfs_device *dev, char *why)
+{
+	bool degrade_option;
+	int tolerated_fail;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_fs_devices *fs_devices;
+
+	fs_devices = dev->fs_devices;
+	fs_info = fs_devices->fs_info;
+	degrade_option = btrfs_test_opt(fs_info->fs_root, DEGRADED);
+
+	/* todo: support seed later */
+	if (fs_devices->seeding)
+		return;
+
+	/* this shouldn't be called if device is already missing */
+	if (dev->missing || !dev->bdev)
+		return;
+
+	if (dev->offline || dev->failed)
+		return;
+
+	/* Only RW device is requested to force close let FS handle it*/
+	if (fs_devices->rw_devices == 1) {
+		btrfs_std_error(fs_info, -EIO,
+			"force offline last RW device");
+		return;
+	}
+
+	if (!strcmp(why, "offline"))
+		dev->offline = 1;
+	else if (!strcmp(why, "failed"))
+		dev->failed = 1;
+	else
+		return;
+
+	btrfs_sysfs_rm_device_link(fs_devices, dev);
+
+	force_device_close(dev);
+
+	tolerated_fail = btrfs_check_degradable(fs_info,
+						fs_info->sb->s_flags);
+	if (tolerated_fail > 0) {
+		btrfs_warn_in_rcu(fs_info, "device %s %s, chunks degraded",
+					rcu_str_deref(dev->name), why);
+	} else if(tolerated_fail < 0) {
+		btrfs_warn_in_rcu(fs_info,
+		"device %s %s, chunks failed",
+			rcu_str_deref(dev->name), why);
+		btrfs_std_error(fs_info, -EIO, "devices below critical level");
+	} else {
+		btrfs_warn_in_rcu(fs_info,
+			"device %s %s, No chunks are degraded",
+			rcu_str_deref(dev->name), why);
+	}
+	btrfs_info_in_rcu(fs_info,
+		"num_devices %llu rw_devices %llu degraded-option: %s",
+		fs_devices->num_devices, fs_devices->rw_devices,
+		degrade_option ? "set":"unset");
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 48ced5cc09e4..ccc716b3c419 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -72,7 +72,20 @@ struct btrfs_device {
 
 	int writeable;
 	int in_fs_metadata;
+	/* missing: device wasn't found at the time of mount */
+	/* fixme: correct usage of missing_devices and missing */
 	int missing;
+	/* failed: device confirmed to have experienced critical io failure */
+	int failed;
+	/*
+	 * offline: system or user or block layer transport has removed
+	 * offlined the device which was once present and without going
+	 * through unmount. Implies an intriem communication break down
+	 * and not necessarily a candidate for the device replace. And
+	 * device might be online after user intervention or after
+	 * block transport layer error recovery.
+	 */
+	int offline;
 	int can_discard;
 	int is_tgtdev_for_dev_replace;
 
@@ -571,5 +584,6 @@ struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags);
+void btrfs_force_device_close(struct btrfs_device *dev, char *why);
 
 #endif
-- 
2.7.0

