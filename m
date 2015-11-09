Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31967 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbbKIK5o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:44 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvhWZ015085
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Avgte030042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:43 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvgdK020383
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/15] btrfs: check device for critical errors and mark failed
Date: Mon,  9 Nov 2015 18:56:22 +0800
Message-Id: <1447066589-3835-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Write and Flush errors are considered as critical errors,
upon which the device will be brought offline and marked as
failed. Write and Flush errors are identified using device
error statistics.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c |  1 +
 fs/btrfs/volumes.h |  4 ++++
 3 files changed, 48 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d10ef2e..38e0385 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1836,6 +1836,47 @@ sleep:
 	return 0;
 }
 
+static void btrfs_check_devices(struct btrfs_fs_devices *fs_devices)
+{
+	struct btrfs_fs_info *fs_info = fs_devices->fs_info;
+	struct btrfs_device *device;
+
+	if (btrfs_fs_closing(fs_info))
+		return;
+
+	/* mark disk(s) with write or flush error(s) as failed */
+	mutex_lock(&fs_info->volume_mutex);
+	list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
+		int c_err;
+
+		/*
+		 * todo: replace target device's write/flush error,
+		 * skip for now
+		 */
+		if (device->is_tgtdev_for_dev_replace)
+			continue;
+
+		if (!device->dev_stats_valid)
+			continue;
+
+		c_err = atomic_read(&device->new_critical_errs);
+		atomic_sub(c_err, &device->new_critical_errs);
+		if (c_err) {
+			rcu_read_lock();
+			btrfs_warn(fs_info,
+				"new write errors on device %s",
+					rcu_str_deref(device->name));
+			rcu_read_unlock();
+
+			/* force close and mark device as failed */
+			btrfs_force_device_close(device, "failed");
+		}
+	}
+	mutex_unlock(&fs_info->volume_mutex);
+
+	return;
+}
+
 static int transaction_kthread(void *arg)
 {
 	struct btrfs_root *root = arg;
@@ -1882,6 +1923,8 @@ static int transaction_kthread(void *arg)
 			btrfs_end_transaction(trans, root);
 		}
 sleep:
+		btrfs_check_devices(root->fs_info->fs_devices);
+
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7492733..b52197b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -157,6 +157,7 @@ static struct btrfs_device *__alloc_device(void)
 	spin_lock_init(&dev->reada_lock);
 	atomic_set(&dev->reada_in_flight, 0);
 	atomic_set(&dev->dev_stats_ccnt, 0);
+	atomic_set(&dev->new_critical_errs, 0);
 	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_WAIT);
 	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_WAIT);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1c6107a..827371e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -167,6 +167,7 @@ struct btrfs_device {
 	/* Counter to record the change of device stats */
 	atomic_t dev_stats_ccnt;
 	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
+	atomic_t new_critical_errs;
 };
 
 /*
@@ -518,6 +519,9 @@ static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 	atomic_inc(dev->dev_stat_values + index);
 	smp_mb__before_atomic();
 	atomic_inc(&dev->dev_stats_ccnt);
+	if (index == BTRFS_DEV_STAT_WRITE_ERRS ||
+		index == BTRFS_DEV_STAT_FLUSH_ERRS)
+		atomic_inc(&dev->new_critical_errs);
 }
 
 static inline int btrfs_dev_stat_read(struct btrfs_device *dev,
-- 
2.4.1

