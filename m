Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28662 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbcEJOCV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:02:21 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 1/1] btrfs: check device for critical errors and mark failed
Date: Tue, 10 May 2016 22:01:50 +0800
Message-Id: <1462888911-5227-14-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
References: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Write and Flush errors are considered as critical errors,
upon which the device will be brought offline and marked as
failed. Write and Flush errors are identified using device
error statistics. This is monitored using a kthread
btrfs_health.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Tested-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
V6: Fix the case where the fail monitor would clash with user initated
    device operation.

 fs/btrfs/ctree.h   |   2 ++
 fs/btrfs/disk-io.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c |   1 +
 fs/btrfs/volumes.h |   4 +++
 4 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index aa693cfdc9f0..47e9cd9dd29a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1569,6 +1569,7 @@ struct btrfs_fs_info {
 	struct mutex tree_log_mutex;
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
+	struct mutex health_mutex;
 	struct mutex chunk_mutex;
 	struct mutex volume_mutex;
 
@@ -1686,6 +1687,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *extent_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
+	struct task_struct *health_kthread;
 	int thread_pool_size;
 
 	struct kobject *space_info_kobj;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b0648af4951d..8b538443fcd0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1876,6 +1876,93 @@ sleep:
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
+		if (btrfs_need_cleaner_sleep(root))
+			goto sleep;
+
+		if (!mutex_trylock(&root->fs_info->health_mutex))
+			goto sleep;
+
+		if (btrfs_need_cleaner_sleep(root)) {
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
@@ -1922,6 +2009,7 @@ static int transaction_kthread(void *arg)
 			btrfs_end_transaction(trans, root);
 		}
 sleep:
+		wake_up_process(root->fs_info->health_kthread);
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
 
@@ -2668,6 +2756,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->chunk_mutex);
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
+	mutex_init(&fs_info->health_mutex);
 	mutex_init(&fs_info->volume_mutex);
 	mutex_init(&fs_info->ro_block_group_mutex);
 	init_rwsem(&fs_info->commit_root_sem);
@@ -3010,11 +3099,16 @@ retry_root_backup:
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
 
 	if (!btrfs_test_opt(tree_root, SSD) &&
 	    !btrfs_test_opt(tree_root, NOSSD) &&
@@ -3178,6 +3272,10 @@ fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
 	btrfs_cleanup_transaction(fs_info->tree_root);
 	btrfs_free_fs_roots(fs_info);
+
+fail_health:
+	kthread_stop(fs_info->health_kthread);
+
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -3833,6 +3931,7 @@ void close_ctree(struct btrfs_root *root)
 
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
+	kthread_stop(fs_info->health_kthread);
 
 	fs_info->closing = 2;
 	smp_mb();
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1190e048c7c9..c6aeed73c106 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -233,6 +233,7 @@ static struct btrfs_device *__alloc_device(void)
 	spin_lock_init(&dev->reada_lock);
 	atomic_set(&dev->reada_in_flight, 0);
 	atomic_set(&dev->dev_stats_ccnt, 0);
+	atomic_set(&dev->new_critical_errs, 0);
 	btrfs_device_data_ordered_init(dev);
 	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 60eb098d8c76..1ad63ce5d328 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -167,6 +167,7 @@ struct btrfs_device {
 	/* Counter to record the change of device stats */
 	atomic_t dev_stats_ccnt;
 	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
+	atomic_t new_critical_errs;
 };
 
 /*
@@ -537,6 +538,9 @@ static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 	atomic_inc(dev->dev_stat_values + index);
 	smp_mb__before_atomic();
 	atomic_inc(&dev->dev_stats_ccnt);
+	if (index == BTRFS_DEV_STAT_WRITE_ERRS ||
+		index == BTRFS_DEV_STAT_FLUSH_ERRS)
+		atomic_inc(&dev->new_critical_errs);
 }
 
 static inline int btrfs_dev_stat_read(struct btrfs_device *dev,
-- 
2.7.0

