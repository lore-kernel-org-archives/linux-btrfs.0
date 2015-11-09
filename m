Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51029 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbbKIK5m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:42 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9Avftg014158
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Avfv7012018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:41 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvfJ5003490
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/15] btrfs: introduce device dynamic state transition to offline or failed
Date: Mon,  9 Nov 2015 18:56:21 +0800
Message-Id: <1447066589-3835-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
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
 fs/btrfs/volumes.c | 148 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  14 +++++
 2 files changed, 162 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 33ad42e..7492733 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6853,3 +6853,151 @@ out:
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
+void __force_device_close(struct btrfs_device *device)
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
+	 * fixme: works for now, but its better to keep the state
+	 * missing and offline different, and update rest of the
+	 * places where we check for only missing.
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
+	u64 rw_devices;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_fs_devices *fs_devices;
+
+	fs_devices = dev->fs_devices;
+	fs_info = fs_devices->fs_info;
+	tolerated_fail = btrfs_check_degradable(fs_info,
+						fs_info->sb->s_flags);
+	rw_devices = fs_devices->rw_devices;
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
+	/* last standing device is being offlined */
+	if (rw_devices == 1) {
+		btrfs_std_error(fs_info, -EIO, "force offline last RW device");
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
+	rcu_read_lock();
+	btrfs_info(fs_info,
+	"device %s %s num_devices %llu rw_devices %llu degraded %d -o degraded %s",
+		rcu_str_deref(dev->name), why, fs_devices->num_devices,
+		rw_devices, tolerated_fail,
+		degrade_option ? "set":"unset");
+	rcu_read_unlock();
+
+	btrfs_sysfs_rm_device_link(fs_devices, dev, 0);
+
+	__force_device_close(dev);
+	tolerated_fail = btrfs_check_degradable(fs_info,
+						fs_info->sb->s_flags);
+	if (tolerated_fail > 0) {
+		rcu_read_lock();
+		btrfs_warn(fs_info, "device %s %s, chunks degraded",
+					rcu_str_deref(dev->name), why);
+		rcu_read_unlock();
+		return;
+	} else if(tolerated_fail < 0) {
+		rcu_read_lock();
+		btrfs_warn(fs_info,
+			"device %s is %s, device(s) with critical chunk(s) missing",
+			rcu_str_deref(dev->name), why);
+		rcu_read_unlock();
+		btrfs_std_error(fs_info, -EIO, "devices below critical level");
+		return;
+	}
+	rcu_read_lock();
+	btrfs_warn(fs_info, "device %s %s, No chunks are degraded",
+		rcu_str_deref(dev->name), why);
+	rcu_read_unlock();
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d9a4579..1c6107a 100644
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
 
@@ -557,5 +570,6 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_close_one_device(struct btrfs_device *device);
 int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags);
+void btrfs_force_device_close(struct btrfs_device *dev, char *why);
 
 #endif
-- 
2.4.1

