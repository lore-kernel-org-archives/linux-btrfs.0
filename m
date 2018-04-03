Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753094AbeDCSgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:36:55 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA5ECABC9
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Apr 2018 18:36:53 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 11/16] btrfs: kill btrfs_fs_info::volume_mutex
Date: Tue,  3 Apr 2018 20:34:26 +0200
Message-Id: <773c3cb3c347d102718975831837e8eb7e9f30ad.1522780026.git.dsterba@suse.com>
In-Reply-To: <cover.1522780026.git.dsterba@suse.com>
References: <cover.1522780026.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mutual exclusion of device add/rm and balance was done by the volume
mutex up to version 3.7. The commit 5ac00addc7ac091109 ("Btrfs: disallow
mutually exclusive admin operations from user mode") added a bit that
essentially tracked the same information.

The status bit has an advantage over a mutex that it can be set without
restrictions of function context, so it started to be used in the
mount-time resuming of balance or device replace.

But we don't really need to track the same information in two ways.

1) After the previous cleanups, the main ioctl handlers for
   add/del/resize copy the EXCL_OP bit next to the volume mutex, here
   it's clearly safe.

2) Resuming balance during mount or after rw remount will set only the
   EXCL_OP bit and the volume_mutex is held in the kernel thread that
   calls btrfs_balance.

3) Resuming device replace during mount or after rw remount is done
   after balance and is excluded by the EXCL_OP bit. It does not take
   the volume_mutex at all and completely relies on the EXCL_OP bit.

4) The resuming of balance and dev-replace cannot hapen at the same time
   as the ioctls cannot be started in parallel. Nevertheless, a crafted
   image could trigger that and a warning is printed.

5) Balance is normally excluded by EXCL_OP and also uses own mutex to
   protect against concurrent access to its status data. There's some
   trickery to maintain the right lock nesting in case we need to
   reexamine the status in btrfs_ioctl_balance. The volume_mutex is
   removed and the unlock/lock sequence is left in place as we might
   expect other waiters to proceed.

6) Similar to 5, the unlock/lock sequence is kept in
   btrfs_cancel_balance to allow waiters to continue.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       |  1 -
 fs/btrfs/disk-io.c     |  1 -
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/ioctl.c       | 17 ++++-------------
 fs/btrfs/volumes.c     | 36 ++++++++++--------------------------
 5 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0eb55825862a..011cb9a8a967 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -826,7 +826,6 @@ struct btrfs_fs_info {
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
 	struct mutex chunk_mutex;
-	struct mutex volume_mutex;
 
 	/*
 	 * this is taken to make sure we don't set block groups ro after
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b5e6f7df67..c0482ecea11f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2605,7 +2605,6 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->chunk_mutex);
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
-	mutex_init(&fs_info->volume_mutex);
 	mutex_init(&fs_info->ro_block_group_mutex);
 	init_rwsem(&fs_info->commit_root_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f30548d7e0d2..90d28a3727c6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4122,7 +4122,7 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
  * returns target flags in extended format or 0 if restripe for this
  * chunk_type is not in progress
  *
- * should be called with either volume_mutex or balance_lock held
+ * should be called with balance_lock held
  */
 static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
 {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2f172122b63d..410037281f2a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1470,7 +1470,6 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 	}
 
-	mutex_lock(&fs_info->volume_mutex);
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -1578,7 +1577,6 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 out_free:
 	kfree(vol_args);
 out:
-	mutex_unlock(&fs_info->volume_mutex);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	mnt_drop_write_file(file);
 	return ret;
@@ -2626,7 +2624,6 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
 	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
 		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 
-	mutex_lock(&fs_info->volume_mutex);
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -2641,7 +2638,6 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
 
 	kfree(vol_args);
 out:
-	mutex_unlock(&fs_info->volume_mutex);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	return ret;
 }
@@ -2674,7 +2670,6 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		goto out;
 	}
-	mutex_lock(&fs_info->volume_mutex);
 
 	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID) {
 		ret = btrfs_rm_device(fs_info, NULL, vol_args->devid);
@@ -2682,7 +2677,6 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 		vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
 		ret = btrfs_rm_device(fs_info, vol_args->name, 0);
 	}
-	mutex_unlock(&fs_info->volume_mutex);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 
 	if (!ret) {
@@ -2718,7 +2712,6 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		goto out_drop_write;
 	}
-	mutex_lock(&fs_info->volume_mutex);
 
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
@@ -2733,7 +2726,6 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 		btrfs_info(fs_info, "disk deleted %s", vol_args->name);
 	kfree(vol_args);
 out:
-	mutex_unlock(&fs_info->volume_mutex);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 out_drop_write:
 	mnt_drop_write_file(file);
@@ -4552,7 +4544,6 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 
 again:
 	if (!test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
-		mutex_lock(&fs_info->volume_mutex);
 		mutex_lock(&fs_info->balance_mutex);
 		need_unlock = true;
 		goto locked;
@@ -4569,8 +4560,10 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 		/* this is either (2) or (3) */
 		if (!atomic_read(&fs_info->balance_running)) {
 			mutex_unlock(&fs_info->balance_mutex);
-			if (!mutex_trylock(&fs_info->volume_mutex))
-				goto again;
+			/*
+			 * Lock released to allow other waiters to continue,
+			 * we'll reexamine the status again.
+			 */
 			mutex_lock(&fs_info->balance_mutex);
 
 			if (fs_info->balance_ctl &&
@@ -4581,7 +4574,6 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 			}
 
 			mutex_unlock(&fs_info->balance_mutex);
-			mutex_unlock(&fs_info->volume_mutex);
 			goto again;
 		} else {
 			/* this is (2) */
@@ -4674,7 +4666,6 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	kfree(bargs);
 out_unlock:
 	mutex_unlock(&fs_info->balance_mutex);
-	mutex_unlock(&fs_info->volume_mutex);
 	if (need_unlock)
 		clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 out:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0ae29cd69363..d1e3486343ae 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -179,12 +179,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  * may be used to exclude some operations from running concurrently without any
  * modifications to the list (see write_all_supers)
  *
- * volume_mutex
- * ------------
- * coarse lock owned by a mounted filesystem; used to exclude some operations
- * that cannot run in parallel and affect the higher-level properties of the
- * filesystem like: device add/deleting/resize/replace, or balance
- *
  * balance_mutex
  * -------------
  * protects balance structures (status, state) and context accessed from
@@ -205,10 +199,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  * ============
  *
  * uuid_mutex
- *   volume_mutex
- *     device_list_mutex
- *       chunk_mutex
- *     balance_mutex
+ *   device_list_mutex
+ *     chunk_mutex
+ *   balance_mutex
  */
 
 DEFINE_MUTEX(uuid_mutex);
@@ -3186,9 +3179,8 @@ static void update_balance_args(struct btrfs_balance_control *bctl)
 }
 
 /*
- * Should be called with both balance and volume mutexes held to
- * serialize other volume operations (add_dev/rm_dev/resize) with
- * restriper.  Same goes for reset_balance_state.
+ * Should be called with balance mutex held to protect against checking the
+ * balance status or progress. Same goes for reset_balance_state.
  */
 static void set_balance_control(struct btrfs_balance_control *bctl)
 {
@@ -3765,7 +3757,7 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
 }
 
 /*
- * Should be called with both balance and volume mutexes held
+ * Should be called with balance mutexe held
  */
 int btrfs_balance(struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs)
@@ -3931,16 +3923,12 @@ static int balance_kthread(void *data)
 	struct btrfs_fs_info *fs_info = data;
 	int ret = 0;
 
-	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
-
 	if (fs_info->balance_ctl) {
 		btrfs_info(fs_info, "continuing balance");
 		ret = btrfs_balance(fs_info->balance_ctl, NULL);
 	}
-
 	mutex_unlock(&fs_info->balance_mutex);
-	mutex_unlock(&fs_info->volume_mutex);
 
 	return ret;
 }
@@ -4025,13 +4013,9 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 	btrfs_balance_sys(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->sys, &disk_bargs);
 
-	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
-
 	set_balance_control(bctl);
-
 	mutex_unlock(&fs_info->balance_mutex);
-	mutex_unlock(&fs_info->volume_mutex);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -4088,17 +4072,17 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 			   atomic_read(&fs_info->balance_running) == 0);
 		mutex_lock(&fs_info->balance_mutex);
 	} else {
-		/* reset_balance_state needs volume_mutex */
 		mutex_unlock(&fs_info->balance_mutex);
-		mutex_lock(&fs_info->volume_mutex);
+		/*
+		 * Lock released to allow other waiters to continue, we'll
+		 * reexamine the status again.
+		 */
 		mutex_lock(&fs_info->balance_mutex);
 
 		if (fs_info->balance_ctl) {
 			reset_balance_state(fs_info);
 			clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 		}
-
-		mutex_unlock(&fs_info->volume_mutex);
 	}
 
 	BUG_ON(fs_info->balance_ctl || atomic_read(&fs_info->balance_running));
-- 
2.16.2

