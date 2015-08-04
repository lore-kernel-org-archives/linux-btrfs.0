Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31718 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbbHDOon (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 10:44:43 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t74EigAw018501
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t74Eigc1027091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:42 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t74EiGBQ019528
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:22 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 3/3] Btrfs: introduce function to handle device offline
Date: Tue,  4 Aug 2015 22:43:53 +0800
Message-Id: <1438699433-1581-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
References: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

RFC:

Btrfs should offline the device in the following context as below..
1) to report that device has failed per the IO errors
2) identify the target for the (hot) replacement
3) avoid further commit error reported against the failing device and
4) fix the bug which would unmount btrfs (in some systemd config)
   when one of the device goes missing in a multi device btrfs.
   which sounds good for single device btrfs but not when fault
   tolerance is more than 0.

So as of now, this patch will provide a handle to offline a device,
when requested it would bring the device offline if the conditions
are right (that is mount degraded option is set or failure tolerance
is more than total missing devices) or panic/bug (per user config).

The consumer of this handle device offline as of now is sysfs
interface '/sys/fs/btrfs/<fsid>/device/<uuid>/missing'
The write feature for this interface is also added in this patch.
This interface plus systemd changes I hope fix to 4th reason
(as above) for this patch.

This patch is for the review as of now.

    Thanks

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c   |  20 +++++++++-
 fs/btrfs/volumes.c | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |   7 ++++
 3 files changed, 139 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index d7f6aab..31d3d65 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -656,7 +656,8 @@ int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
 	if (!fs_devices->device_dir_kobj)
 		return -EINVAL;
 
-	if (one_device && one_device->bdev) {
+	if (one_device && (one_device->bdev ||
+		one_device->dev_state == BTRFS_DEV_STATE_OFFLINED)) {
 		disk = one_device->bdev->bd_part;
 		disk_kobj = &part_to_dev(disk)->kobj;
 
@@ -1268,6 +1269,23 @@ static ssize_t btrfs_dev_attr_store(struct kobject *kobj,
 	 * we might need some of the parameter to be writable
 	 * but as of now just deny all
 	 */
+	int ret;
+	unsigned long val;
+	struct btrfs_device *dev = to_btrfs_dev(kobj);
+
+	ret = kstrtoul(skip_spaces(buf), 0, &val);
+	if (ret)
+		return ret;
+
+	if (BTRFS_DEV_CHECK_ATTR(&a->attr, missing)) {
+		if (val != 0 && val != 1)
+			return -EINVAL;
+		if (val == dev->missing)
+			return -EINVAL;
+		btrfs_put_dev_offline(dev);
+		return count;
+	}
+
 	return -EPERM;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5fa73f4..56d92f0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -769,6 +769,28 @@ static void free_device(struct rcu_head *head)
 	schedule_work(&device->rcu_work);
 }
 
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
 static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device, *tmp;
@@ -6887,3 +6909,94 @@ void btrfs_close_one_device(struct btrfs_device *device)
 	call_rcu(&device->rcu, free_device);
 }
 
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
+void __btrfs_put_dev_offline(struct btrfs_device *device)
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
+	device->missing = 1;
+	fs_devices->missing_devices++;
+
+	device->dev_state = BTRFS_DEV_STATE_OFFLINED;
+
+	rcu_barrier();
+
+	unlock_chunks(fs_devices->fs_info->fs_root);
+	mutex_unlock(&fs_devices->device_list_mutex);
+}
+
+void btrfs_put_dev_offline(struct btrfs_device *dev)
+{
+	bool degrade_option;
+	u64 tolerated_fail;
+	u64 rw_devices;
+	u64 missing;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_fs_devices *fs_devices;
+
+	fs_devices = dev->fs_devices;
+	fs_info = fs_devices->fs_info;
+	missing = fs_devices->missing_devices;
+	tolerated_fail = fs_info->num_tolerated_disk_barrier_failures;
+	rw_devices = fs_devices->rw_devices;
+	degrade_option = btrfs_test_opt(fs_info->dev_root, DEGRADED);
+
+	/* todo: support seed later */
+	if (fs_devices->seeding)
+		return;
+
+	if (dev->missing || !dev->bdev)
+		return;
+
+	btrfs_warn(fs_info, "device %s offline requested",
+					rcu_str_deref(dev->name));
+	btrfs_info(fs_info,
+		"num_devices %llu, rw_devices %llu, -o degraded %s, pool profile tolerates %llu failure",
+		fs_devices->num_devices, rw_devices,
+		degrade_option ? "set":"unset", tolerated_fail);
+
+	if ((rw_devices > 1) &&
+		(degrade_option || tolerated_fail > missing)) {
+		btrfs_sysfs_rm_device_link(fs_devices, dev, 0);
+		__btrfs_put_dev_offline(dev);
+		return;
+	}
+
+	if (degrade_option)
+		btrfs_panic(fs_info, -EIO, "critically low rw devices\n");
+	else
+		btrfs_panic(fs_info, -EIO,
+			"critically low rw devices, try -o degraded\n");
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b2ec90f..1b49925 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -52,6 +52,10 @@ struct btrfs_device_kobj {
 	struct btrfs_device *device;
 };
 
+#define BTRFS_DEV_STATE_ONLINE		1
+#define BTRFS_DEV_STATE_MISSING		2
+#define BTRFS_DEV_STATE_OFFLINED	3
+
 struct btrfs_device {
 	struct list_head dev_list;
 	struct list_head dev_alloc_list;
@@ -158,6 +162,8 @@ struct btrfs_device {
 
 	struct btrfs_device_kobj *dev_kobjp;
 	struct completion dev_kobj_unregister;
+
+	unsigned long dev_state;
 };
 
 /*
@@ -561,5 +567,6 @@ struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_close_one_device(struct btrfs_device *device);
+void btrfs_put_dev_offline(struct btrfs_device *dev);
 
 #endif
-- 
2.4.1

