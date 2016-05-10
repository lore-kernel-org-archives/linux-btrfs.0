Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36216 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbcEJOJx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:09:53 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 11/13] btrfs: introduce device dynamic state transition to offline or failed
Date: Tue, 10 May 2016 22:09:30 +0800
Message-Id: <1462889372-5274-13-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This patch provides helper functions to force a device to offline
or failed, and we need this device states for the following reasons,
1) a. it can be reported that device has failed when it does
   b. close the device when it goes offline so that blocklayer can
      cleanup
2) identify the candidate for the auto replace
3) avoid further commit error reported against the failing device and
4) a device in the multi device btrfs may go offline from the system
   (but as of now in in some system config btrfs gets unmounted in this
    context, which is not a correct behavior)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Tested-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
v6: Changes on top of
    btrfs: rename btrfs_std_error to btrfs_handle_fs_error

 fs/btrfs/volumes.c | 131 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  14 ++++++
 2 files changed, 145 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5e13ffbe1fbd..8890cc0f7733 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7197,3 +7197,134 @@ out:
 	free_extent_map(em);
 	return ret;
 }
+
+static void __close_device(struct work_struct *work)
+{
+	struct btrfs_device *device;
+
+	device = container_of(work, struct btrfs_device, rcu_work);
+
+	if (device->closing_bdev)
+		blkdev_put(device->closing_bdev, device->mode);
+
+	device->closing_bdev = NULL;
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
+void device_force_close(struct btrfs_device *device)
+{
+	struct btrfs_fs_devices *fs_devices;
+
+	fs_devices = device->fs_devices;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	mutex_lock(&fs_devices->fs_info->chunk_mutex);
+	spin_lock(&fs_devices->fs_info->free_chunk_lock);
+
+	btrfs_assign_next_active_device(fs_devices->fs_info, device, NULL);
+
+	if (device->bdev)
+		fs_devices->open_devices--;
+
+	if (device->writeable) {
+		list_del_init(&device->dev_alloc_list);
+		fs_devices->rw_devices--;
+	}
+	device->writeable = 0;
+
+	/*
+	 * fixme: works for now, but its better to keep the state of
+	 * missing and offline different, and update rest of the
+	 * places where we check for only missing and not for failed
+	 * or offline as of now.
+	 */
+	device->missing = 1;
+	fs_devices->missing_devices++;
+	device->closing_bdev = device->bdev;
+	device->bdev = NULL;
+
+	call_rcu(&device->rcu, close_device);
+
+	spin_unlock(&fs_devices->fs_info->free_chunk_lock);
+	mutex_unlock(&fs_devices->fs_info->chunk_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	rcu_barrier();
+}
+
+void btrfs_device_enforce_state(struct btrfs_device *dev, char *why)
+{
+	int tolerance;
+	bool degrade_option;
+	char dev_status[10];
+	char chunk_status[25];
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
+		btrfs_handle_fs_error(fs_info, -EIO,
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
+	/*
+	 * Here after, there shouldn't any reason why can't force
+	 * close this device
+	 */
+	btrfs_sysfs_rm_device_link(fs_devices, dev);
+	device_force_close(dev);
+	strcpy(dev_status, "closed");
+
+	tolerance = btrfs_check_degradable(fs_info,
+						fs_info->sb->s_flags);
+	if (tolerance > 0) {
+		strncpy(chunk_status, "chunk(s) degraded", 25);
+	} else if(tolerance < 0) {
+		strncpy(chunk_status, "chunk(s) failed", 25);
+	} else {
+		strncpy(chunk_status, "No chunk(s) are degraded", 25);
+	}
+
+	btrfs_warn_in_rcu(fs_info, "device %s marked %s, %s, %s",
+		rcu_str_deref(dev->name), why, dev_status, chunk_status);
+	btrfs_info_in_rcu(fs_info,
+		"num_devices %llu rw_devices %llu degraded-option: %s",
+		fs_devices->num_devices, fs_devices->rw_devices,
+		degrade_option ? "set":"unset");
+
+	if (tolerance < 0)
+		btrfs_handle_fs_error(fs_info, -EIO, "devices below critical level");
+
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 04b65b56c378..c7d4c658a0c4 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -66,13 +66,26 @@ struct btrfs_device {
 	struct btrfs_pending_bios pending_sync_bios;
 
 	struct block_device *bdev;
+	struct block_device *closing_bdev;
 
 	/* the mode sent to blkdev_get */
 	fmode_t mode;
 
 	int writeable;
 	int in_fs_metadata;
+	/* missing: device wasn't found at the time of mount */
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
 
@@ -534,5 +547,6 @@ struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags);
+void btrfs_device_enforce_state(struct btrfs_device *dev, char *why);
 
 #endif
-- 
2.7.0

