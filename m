Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46731 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbcC2OXB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:23:01 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 12/12] btrfs: check device for critical errors and mark failed
Date: Tue, 29 Mar 2016 22:22:29 +0800
Message-Id: <1459261349-32206-13-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Write and Flush errors are considered as critical errors,
upon which the device will be brought offline and marked as
failed. Write and Flush errors are identified using device
error statistics.

Signed-off-by: Anand Jain <anand.jain@oracle.com>

btrfs: check for failed device and hot replace

This patch creates casualty_kthread to check for the failed
devices, and triggers device replace.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h   |   2 +
 fs/btrfs/disk-io.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/disk-io.h |   2 +
 fs/btrfs/volumes.c |   1 +
 fs/btrfs/volumes.h |   4 ++
 5 files changed, 169 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2c185a8e92f0..36f1c29e00a0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1569,6 +1569,7 @@ struct btrfs_fs_info {
 	struct mutex tree_log_mutex;
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
+	struct mutex casualty_mutex;
 	struct mutex chunk_mutex;
 	struct mutex volume_mutex;
 
@@ -1686,6 +1687,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *extent_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
+	struct task_struct *casualty_kthread;
 	int thread_pool_size;
 
 	struct kobject *space_info_kobj;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b99329e37965..650e26e0acda 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1869,6 +1869,153 @@ sleep:
 	return 0;
 }
 
+static int btrfs_check_and_handle_casualty(void *arg)
+{
+	int ret;
+	int found = 0;
+	struct btrfs_device *device;
+	struct btrfs_root *root = arg;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+
+	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
+		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+		return -EBUSY;
+	}
+	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+
+	ret = btrfs_check_devices(fs_devices);
+	if (ret == 1) {
+		/*
+		 * There were some casualties, and if its beyond a
+		 * chunk group can tolerate, then FS will already
+		 * be in readonly, so check that. And that's best
+		 * btrfs could do as of now and no replace will help.
+		 */
+		if (fs_info->sb->s_flags & MS_RDONLY)
+			return -EROFS;
+
+		mutex_lock(&fs_devices->device_list_mutex);
+		rcu_read_lock();
+		list_for_each_entry_rcu(device,
+				&fs_devices->devices, dev_list) {
+			if (device->failed) {
+				found = 1;
+				break;
+			}
+		}
+		rcu_read_unlock();
+		mutex_unlock(&fs_devices->device_list_mutex);
+	}
+
+	/*
+	 * We are using the replace code which should be interrupt-able
+	 * during unmount, and as of now there is no user land stop
+	 * request that we support and this will run until its complete
+	 */
+	if (found)
+		ret = btrfs_auto_replace_start(root, device);
+
+	return ret;
+}
+
+/*
+ * A kthread to check if any auto maintenance be required. This is
+ * multithread safe, and kthread is running only if
+ * fs_info->casualty_kthread is not NULL, fixme: atomic ?
+ */
+static int casualty_kthread(void *arg)
+{
+	int ret;
+	int again;
+	struct btrfs_root *root = arg;
+
+	do {
+		again = 0;
+
+		if (btrfs_need_cleaner_sleep(root))
+			goto sleep;
+
+		if (!mutex_trylock(&root->fs_info->casualty_mutex))
+			goto sleep;
+
+		if (btrfs_need_cleaner_sleep(root)) {
+			mutex_unlock(&root->fs_info->casualty_mutex);
+			goto sleep;
+		}
+
+		ret = btrfs_check_and_handle_casualty(arg);
+		if (ret == -EROFS) {
+			/*
+			 * When checking and fixing the devices, the
+			 * FS may be marked as RO in some situations.
+			 * And on ROFS casualty thread has no work.
+			 * So optimize here, to stop this thread until
+			 * FS is back to RW.
+			 */
+		}
+		mutex_unlock(&root->fs_info->casualty_mutex);
+
+sleep:
+		if (!try_to_freeze() && !again) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (!kthread_should_stop())
+				schedule();
+			__set_current_state(TASK_RUNNING);
+		}
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
+/*
+ * returns:
+ * < 0 : Check didn't run, std error
+ *   0 : No errors found
+ * > 0 : # of devices having fatal errors
+ */
+int btrfs_check_devices(struct btrfs_fs_devices *fs_devices)
+{
+	int ret = 0;
+	struct btrfs_fs_info *fs_info = fs_devices->fs_info;
+	struct btrfs_device *device;
+
+	if (btrfs_fs_closing(fs_info))
+		return -EBUSY;
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
+			btrfs_crit_in_rcu(fs_info,
+				"Fatal error on device %s",
+					rcu_str_deref(device->name));
+
+			/* force close and mark device as failed */
+			btrfs_force_device_close(device, "failed");
+			ret = 1;
+		}
+	}
+	mutex_unlock(&fs_info->volume_mutex);
+
+	return ret;
+}
+
 static int transaction_kthread(void *arg)
 {
 	struct btrfs_root *root = arg;
@@ -1915,6 +2062,7 @@ static int transaction_kthread(void *arg)
 			btrfs_end_transaction(trans, root);
 		}
 sleep:
+		wake_up_process(root->fs_info->casualty_kthread);
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
 
@@ -2663,6 +2811,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->chunk_mutex);
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
+	mutex_init(&fs_info->casualty_mutex);
 	mutex_init(&fs_info->volume_mutex);
 	mutex_init(&fs_info->ro_block_group_mutex);
 	init_rwsem(&fs_info->commit_root_sem);
@@ -3005,11 +3154,16 @@ retry_root_backup:
 	if (IS_ERR(fs_info->cleaner_kthread))
 		goto fail_sysfs;
 
+	fs_info->casualty_kthread = kthread_run(casualty_kthread, tree_root,
+					       "btrfs-casualty");
+	if (IS_ERR(fs_info->casualty_kthread))
+		goto fail_cleaner;
+
 	fs_info->transaction_kthread = kthread_run(transaction_kthread,
 						   tree_root,
 						   "btrfs-transaction");
 	if (IS_ERR(fs_info->transaction_kthread))
-		goto fail_cleaner;
+		goto fail_casualty;
 
 	if (!btrfs_test_opt(tree_root, SSD) &&
 	    !btrfs_test_opt(tree_root, NOSSD) &&
@@ -3173,6 +3327,10 @@ fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
 	btrfs_cleanup_transaction(fs_info->tree_root);
 	btrfs_free_fs_roots(fs_info);
+
+fail_casualty:
+	kthread_stop(fs_info->casualty_kthread);
+
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -3828,6 +3986,7 @@ void close_ctree(struct btrfs_root *root)
 
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
+	kthread_stop(fs_info->casualty_kthread);
 
 	fs_info->closing = 2;
 	smp_mb();
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index dd155621f95f..0a58b0c2bc46 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -156,4 +156,6 @@ static inline void btrfs_set_buffer_lockdep_class(u64 objectid,
 {
 }
 #endif
+
+int btrfs_check_devices(struct btrfs_fs_devices *fs_devices);
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 308fcb55f2a1..95a530af8145 100644
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
index b9c04fdf7166..9fc4c1734ba7 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -167,6 +167,7 @@ struct btrfs_device {
 	/* Counter to record the change of device stats */
 	atomic_t dev_stats_ccnt;
 	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
+	atomic_t new_critical_errs;
 };
 
 /*
@@ -535,6 +536,9 @@ static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
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

