Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22268 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752179AbdECN3e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 09:29:34 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v43DTWpx017339
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 3 May 2017 13:29:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v43DTWju030000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 3 May 2017 13:29:32 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v43DTUiV022096
        for <linux-btrfs@vger.kernel.org>; Wed, 3 May 2017 13:29:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2 v7] btrfs: check device for critical errors and mark failed
Date: Wed,  3 May 2017 21:34:57 +0800
Message-Id: <20170503133457.9901-3-anand.jain@oracle.com>
In-Reply-To: <20170503133457.9901-1-anand.jain@oracle.com>
References: <20170503133457.9901-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Write and Flush errors are considered as critical errors,
upon which the device will be brought offline and marked as
failed. Write and Flush errors are identified using device
error statistics. This is monitored using a kthread
btrfs_health.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
V7:
 . Now out of its set.
 . Removed:
 Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
 Tested-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>

V6: Fix the case where the fail monitor would clash with user initated
    device operation.

 fs/btrfs/ctree.h   |   2 ++
 fs/btrfs/disk-io.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c |   1 +
 fs/btrfs/volumes.h |   4 +++
 4 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c4115901d906..db519f0ebcb0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -814,6 +814,7 @@ struct btrfs_fs_info {
 	struct mutex tree_log_mutex;
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
+	struct mutex health_mutex;
 	struct mutex chunk_mutex;
 	struct mutex volume_mutex;
 
@@ -931,6 +932,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *extent_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
+	struct task_struct *health_kthread;
 	int thread_pool_size;
 
 	struct kobject *space_info_kobj;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index efdd16294e60..9f16c7d2c191 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1936,6 +1936,93 @@ static int cleaner_kthread(void *arg)
 	return 0;
 }
 
+/*
+ * returns:
+ * < 0 : Check didn't run, std error
+ *   0 : No errors found
+ * > 0 : # of devices having fatal errors
+ */
+static int btrfs_update_devices_health(struct btrfs_root *root)
+{
+	int ret = 0;
+	struct btrfs_device *device;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	if (btrfs_fs_closing(fs_info))
+		return -EBUSY;
+
+	/* mark disk(s) with write or flush error(s) as failed */
+	mutex_lock(&fs_info->volume_mutex);
+	list_for_each_entry_rcu(device,
+			&fs_info->fs_devices->devices, dev_list) {
+		int c_err;
+
+		if (device->failed) {
+			ret++;
+			continue;
+		}
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
+			btrfs_crit_in_rcu(fs_info,
+				"fatal error on device %s",
+					rcu_str_deref(device->name));
+			btrfs_device_enforce_state(device, "failed");
+			ret ++;
+		}
+	}
+	mutex_unlock(&fs_info->volume_mutex);
+
+	return ret;
+}
+
+/*
+ * Devices health maintenance kthread, gets woken-up by transaction
+ * kthread, once sysfs is ready, this should publish the report
+ * through sysfs so that user land scripts and invoke actions.
+ */
+static int health_kthread(void *arg)
+{
+	struct btrfs_root *root = arg;
+
+	do {
+		if (btrfs_need_cleaner_sleep(root->fs_info))
+			goto sleep;
+
+		if (!mutex_trylock(&root->fs_info->health_mutex))
+			goto sleep;
+
+		if (btrfs_need_cleaner_sleep(root->fs_info)) {
+			mutex_unlock(&root->fs_info->health_mutex);
+			goto sleep;
+		}
+
+		/* Check devices health */
+		btrfs_update_devices_health(root);
+
+		mutex_unlock(&root->fs_info->health_mutex);
+
+sleep:
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!kthread_should_stop())
+			schedule();
+		__set_current_state(TASK_RUNNING);
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
 static int transaction_kthread(void *arg)
 {
 	struct btrfs_root *root = arg;
@@ -1983,6 +2070,7 @@ static int transaction_kthread(void *arg)
 			btrfs_end_transaction(trans);
 		}
 sleep:
+		wake_up_process(fs_info->health_kthread);
 		wake_up_process(fs_info->cleaner_kthread);
 		mutex_unlock(&fs_info->transaction_kthread_mutex);
 
@@ -2738,6 +2826,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->chunk_mutex);
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
+	mutex_init(&fs_info->health_mutex);
 	mutex_init(&fs_info->volume_mutex);
 	mutex_init(&fs_info->ro_block_group_mutex);
 	init_rwsem(&fs_info->commit_root_sem);
@@ -3074,11 +3163,16 @@ int open_ctree(struct super_block *sb,
 	if (IS_ERR(fs_info->cleaner_kthread))
 		goto fail_sysfs;
 
+	fs_info->health_kthread = kthread_run(health_kthread, tree_root,
+					       "btrfs-health");
+	if (IS_ERR(fs_info->health_kthread))
+		goto fail_cleaner;
+
 	fs_info->transaction_kthread = kthread_run(transaction_kthread,
 						   tree_root,
 						   "btrfs-transaction");
 	if (IS_ERR(fs_info->transaction_kthread))
-		goto fail_cleaner;
+		goto fail_health;
 
 	if (!btrfs_test_opt(fs_info, SSD) &&
 	    !btrfs_test_opt(fs_info, NOSSD) &&
@@ -3249,6 +3343,10 @@ int open_ctree(struct super_block *sb,
 	kthread_stop(fs_info->transaction_kthread);
 	btrfs_cleanup_transaction(fs_info);
 	btrfs_free_fs_roots(fs_info);
+
+fail_health:
+	kthread_stop(fs_info->health_kthread);
+
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -4022,6 +4120,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
+	kthread_stop(fs_info->health_kthread);
 
 	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 609ed3d924c3..e0ca956a2994 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -246,6 +246,7 @@ static struct btrfs_device *__alloc_device(void)
 	spin_lock_init(&dev->reada_lock);
 	atomic_set(&dev->reada_in_flight, 0);
 	atomic_set(&dev->dev_stats_ccnt, 0);
+	atomic_set(&dev->new_critical_errs, 0);
 	btrfs_device_data_ordered_init(dev);
 	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 10818974ed07..9bb248b3fa0e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -163,6 +163,7 @@ struct btrfs_device {
 	/* Counter to record the change of device stats */
 	atomic_t dev_stats_ccnt;
 	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
+	atomic_t new_critical_errs;
 };
 
 /*
@@ -511,6 +512,9 @@ static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 	atomic_inc(dev->dev_stat_values + index);
 	smp_mb__before_atomic();
 	atomic_inc(&dev->dev_stats_ccnt);
+	if (index == BTRFS_DEV_STAT_WRITE_ERRS ||
+		index == BTRFS_DEV_STAT_FLUSH_ERRS)
+		atomic_inc(&dev->new_critical_errs);
 }
 
 static inline int btrfs_dev_stat_read(struct btrfs_device *dev,
-- 
2.10.0

