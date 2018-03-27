Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58014 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbeC0SvB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 14:51:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1A211AC98
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 18:51:00 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/6] btrfs: split dev-replace locking helpers for read and write
Date: Tue, 27 Mar 2018 20:48:34 +0200
Message-Id: <fa89307bf75e358eb94651f3f79ab5192e4a4184.1522176187.git.dsterba@suse.com>
In-Reply-To: <cover.1522176187.git.dsterba@suse.com>
References: <cover.1522176187.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current calls are unclear in what way btrfs_dev_replace_lock takes
the locks, so drop the argument, split the helpers and use similar
naming as for read and write locks.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 98 +++++++++++++++++++++++++-------------------------
 fs/btrfs/dev-replace.h |  6 ++--
 fs/btrfs/reada.c       | 10 +++---
 fs/btrfs/scrub.c       | 14 ++++----
 fs/btrfs/volumes.c     | 18 +++++-----
 5 files changed, 74 insertions(+), 72 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 7efbc4d1128b..91d0815dd514 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -200,13 +200,13 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	struct btrfs_dev_replace_item *ptr;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
-	btrfs_dev_replace_lock(dev_replace, 0);
+	btrfs_dev_replace_read_lock(dev_replace);
 	if (!dev_replace->is_valid ||
 	    !dev_replace->item_needs_writeback) {
-		btrfs_dev_replace_unlock(dev_replace, 0);
+		btrfs_dev_replace_read_unlock(dev_replace);
 		return 0;
 	}
-	btrfs_dev_replace_unlock(dev_replace, 0);
+	btrfs_dev_replace_read_unlock(dev_replace);
 
 	key.objectid = 0;
 	key.type = BTRFS_DEV_REPLACE_KEY;
@@ -264,7 +264,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	ptr = btrfs_item_ptr(eb, path->slots[0],
 			     struct btrfs_dev_replace_item);
 
-	btrfs_dev_replace_lock(dev_replace, 1);
+	btrfs_dev_replace_write_lock(dev_replace);
 	if (dev_replace->srcdev)
 		btrfs_set_dev_replace_src_devid(eb, ptr,
 			dev_replace->srcdev->devid);
@@ -287,7 +287,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	btrfs_set_dev_replace_cursor_right(eb, ptr,
 		dev_replace->cursor_right);
 	dev_replace->item_needs_writeback = 0;
-	btrfs_dev_replace_unlock(dev_replace, 1);
+	btrfs_dev_replace_write_unlock(dev_replace);
 
 	btrfs_mark_buffer_dirty(eb);
 
@@ -352,7 +352,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		return PTR_ERR(trans);
 	}
 
-	btrfs_dev_replace_lock(dev_replace, 1);
+	btrfs_dev_replace_write_lock(dev_replace);
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
@@ -390,7 +390,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	dev_replace->item_needs_writeback = 1;
 	atomic64_set(&dev_replace->num_write_errors, 0);
 	atomic64_set(&dev_replace->num_uncorrectable_read_errors, 0);
-	btrfs_dev_replace_unlock(dev_replace, 1);
+	btrfs_dev_replace_write_unlock(dev_replace);
 
 	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
 	if (ret)
@@ -402,7 +402,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		btrfs_dev_replace_lock(dev_replace, 1);
+		btrfs_dev_replace_write_lock(dev_replace);
 		goto leave;
 	}
 
@@ -426,7 +426,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 leave:
 	dev_replace->srcdev = NULL;
 	dev_replace->tgtdev = NULL;
-	btrfs_dev_replace_unlock(dev_replace, 1);
+	btrfs_dev_replace_write_unlock(dev_replace);
 	btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 	return ret;
 }
@@ -493,18 +493,18 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	/* don't allow cancel or unmount to disturb the finishing procedure */
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
 
-	btrfs_dev_replace_lock(dev_replace, 0);
+	btrfs_dev_replace_read_lock(dev_replace);
 	/* was the operation canceled, or is it finished? */
 	if (dev_replace->replace_state !=
 	    BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
-		btrfs_dev_replace_unlock(dev_replace, 0);
+		btrfs_dev_replace_read_unlock(dev_replace);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return 0;
 	}
 
 	tgt_device = dev_replace->tgtdev;
 	src_device = dev_replace->srcdev;
-	btrfs_dev_replace_unlock(dev_replace, 0);
+	btrfs_dev_replace_read_unlock(dev_replace);
 
 	/*
 	 * flush all outstanding I/O and inode extent mappings before the
@@ -529,7 +529,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	/* keep away write_all_supers() during the finishing procedure */
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
-	btrfs_dev_replace_lock(dev_replace, 1);
+	btrfs_dev_replace_write_lock(dev_replace);
 	dev_replace->replace_state =
 		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
 			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
@@ -549,7 +549,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				 btrfs_dev_name(src_device),
 				 src_device->devid,
 				 rcu_str_deref(tgt_device->name), scrub_ret);
-		btrfs_dev_replace_unlock(dev_replace, 1);
+		btrfs_dev_replace_write_unlock(dev_replace);
 		mutex_unlock(&fs_info->chunk_mutex);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		mutex_unlock(&uuid_mutex);
@@ -586,7 +586,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
 	fs_info->fs_devices->rw_devices++;
 
-	btrfs_dev_replace_unlock(dev_replace, 1);
+	btrfs_dev_replace_write_unlock(dev_replace);
 
 	btrfs_rm_dev_replace_blocked(fs_info);
 
@@ -679,7 +679,7 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
-	btrfs_dev_replace_lock(dev_replace, 0);
+	btrfs_dev_replace_read_lock(dev_replace);
 	/* even if !dev_replace_is_valid, the values are good enough for
 	 * the replace_status ioctl */
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
@@ -691,7 +691,7 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 	args->status.num_uncorrectable_read_errors =
 		atomic64_read(&dev_replace->num_uncorrectable_read_errors);
 	args->status.progress_1000 = btrfs_dev_replace_progress(fs_info);
-	btrfs_dev_replace_unlock(dev_replace, 0);
+	btrfs_dev_replace_read_unlock(dev_replace);
 }
 
 int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info,
@@ -714,13 +714,13 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		return -EROFS;
 
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
-	btrfs_dev_replace_lock(dev_replace, 1);
+	btrfs_dev_replace_write_lock(dev_replace);
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
 		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED;
-		btrfs_dev_replace_unlock(dev_replace, 1);
+		btrfs_dev_replace_write_unlock(dev_replace);
 		goto leave;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
@@ -733,7 +733,7 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;
 	dev_replace->time_stopped = get_seconds();
 	dev_replace->item_needs_writeback = 1;
-	btrfs_dev_replace_unlock(dev_replace, 1);
+	btrfs_dev_replace_write_unlock(dev_replace);
 	btrfs_scrub_cancel(fs_info);
 
 	trans = btrfs_start_transaction(root, 0);
@@ -756,7 +756,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
-	btrfs_dev_replace_lock(dev_replace, 1);
+	btrfs_dev_replace_write_lock(dev_replace);
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
@@ -772,7 +772,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 		break;
 	}
 
-	btrfs_dev_replace_unlock(dev_replace, 1);
+	btrfs_dev_replace_write_unlock(dev_replace);
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 }
 
@@ -782,12 +782,12 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 	struct task_struct *task;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
-	btrfs_dev_replace_lock(dev_replace, 1);
+	btrfs_dev_replace_write_lock(dev_replace);
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
-		btrfs_dev_replace_unlock(dev_replace, 1);
+		btrfs_dev_replace_write_unlock(dev_replace);
 		return 0;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 		break;
@@ -801,10 +801,10 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 			   "cannot continue dev_replace, tgtdev is missing");
 		btrfs_info(fs_info,
 			   "you may cancel the operation after 'mount -o degraded'");
-		btrfs_dev_replace_unlock(dev_replace, 1);
+		btrfs_dev_replace_write_unlock(dev_replace);
 		return 0;
 	}
-	btrfs_dev_replace_unlock(dev_replace, 1);
+	btrfs_dev_replace_write_unlock(dev_replace);
 
 	WARN_ON(test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags));
 	task = kthread_run(btrfs_dev_replace_kthread, fs_info, "btrfs-devrepl");
@@ -873,37 +873,37 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 	return 1;
 }
 
-void btrfs_dev_replace_lock(struct btrfs_dev_replace *dev_replace, int rw)
+void btrfs_dev_replace_read_lock(struct btrfs_dev_replace *dev_replace)
 {
-	if (rw == 1) {
-		/* write */
-again:
-		wait_event(dev_replace->read_lock_wq,
-			   atomic_read(&dev_replace->blocking_readers) == 0);
-		write_lock(&dev_replace->lock);
-		if (atomic_read(&dev_replace->blocking_readers)) {
-			write_unlock(&dev_replace->lock);
-			goto again;
-		}
-	} else {
-		read_lock(&dev_replace->lock);
-		atomic_inc(&dev_replace->read_locks);
-	}
+	read_lock(&dev_replace->lock);
+	atomic_inc(&dev_replace->read_locks);
 }
 
-void btrfs_dev_replace_unlock(struct btrfs_dev_replace *dev_replace, int rw)
+void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace)
 {
-	if (rw == 1) {
-		/* write */
-		ASSERT(atomic_read(&dev_replace->blocking_readers) == 0);
+	ASSERT(atomic_read(&dev_replace->read_locks) > 0);
+	atomic_dec(&dev_replace->read_locks);
+	read_unlock(&dev_replace->lock);
+}
+
+void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace)
+{
+again:
+	wait_event(dev_replace->read_lock_wq,
+		   atomic_read(&dev_replace->blocking_readers) == 0);
+	write_lock(&dev_replace->lock);
+	if (atomic_read(&dev_replace->blocking_readers)) {
 		write_unlock(&dev_replace->lock);
-	} else {
-		ASSERT(atomic_read(&dev_replace->read_locks) > 0);
-		atomic_dec(&dev_replace->read_locks);
-		read_unlock(&dev_replace->lock);
+		goto again;
 	}
 }
 
+void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace)
+{
+	ASSERT(atomic_read(&dev_replace->blocking_readers) == 0);
+	write_unlock(&dev_replace->lock);
+}
+
 /* inc blocking cnt and release read lock */
 void btrfs_dev_replace_set_lock_blocking(
 					struct btrfs_dev_replace *dev_replace)
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index f94a76844ae7..6629ff432a1d 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -37,8 +37,10 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info,
 void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info);
 int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info);
 int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace);
-void btrfs_dev_replace_lock(struct btrfs_dev_replace *dev_replace, int rw);
-void btrfs_dev_replace_unlock(struct btrfs_dev_replace *dev_replace, int rw);
+void btrfs_dev_replace_read_lock(struct btrfs_dev_replace *dev_replace);
+void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace);
+void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace);
+void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_set_lock_blocking(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_clear_lock_blocking(
 					struct btrfs_dev_replace *dev_replace);
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index ab852b8e3e37..a52dd12af648 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -395,20 +395,20 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 		goto error;
 
 	/* insert extent in reada_tree + all per-device trees, all or nothing */
-	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	spin_lock(&fs_info->reada_lock);
 	ret = radix_tree_insert(&fs_info->reada_tree, index, re);
 	if (ret == -EEXIST) {
 		re_exist = radix_tree_lookup(&fs_info->reada_tree, index);
 		re_exist->refcnt++;
 		spin_unlock(&fs_info->reada_lock);
-		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		radix_tree_preload_end();
 		goto error;
 	}
 	if (ret) {
 		spin_unlock(&fs_info->reada_lock);
-		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		radix_tree_preload_end();
 		goto error;
 	}
@@ -451,13 +451,13 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 			}
 			radix_tree_delete(&fs_info->reada_tree, index);
 			spin_unlock(&fs_info->reada_lock);
-			btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+			btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 			goto error;
 		}
 		have_zone = 1;
 	}
 	spin_unlock(&fs_info->reada_lock);
-	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 
 	if (!have_zone)
 		goto error;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9cfbccdeacf3..f500b37f3f00 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3885,11 +3885,11 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			break;
 		}
 
-		btrfs_dev_replace_lock(&fs_info->dev_replace, 1);
+		btrfs_dev_replace_write_lock(&fs_info->dev_replace);
 		dev_replace->cursor_right = found_key.offset + length;
 		dev_replace->cursor_left = found_key.offset;
 		dev_replace->item_needs_writeback = 1;
-		btrfs_dev_replace_unlock(&fs_info->dev_replace, 1);
+		btrfs_dev_replace_write_unlock(&fs_info->dev_replace);
 		ret = scrub_chunk(sctx, scrub_dev, chunk_offset, length,
 				  found_key.offset, cache, is_dev_replace);
 
@@ -3925,10 +3925,10 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		scrub_pause_off(fs_info);
 
-		btrfs_dev_replace_lock(&fs_info->dev_replace, 1);
+		btrfs_dev_replace_write_lock(&fs_info->dev_replace);
 		dev_replace->cursor_left = dev_replace->cursor_right;
 		dev_replace->item_needs_writeback = 1;
-		btrfs_dev_replace_unlock(&fs_info->dev_replace, 1);
+		btrfs_dev_replace_write_unlock(&fs_info->dev_replace);
 
 		if (ro_set)
 			btrfs_dec_block_group_ro(cache);
@@ -4144,16 +4144,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -EIO;
 	}
 
-	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (dev->scrub_ctx ||
 	    (!is_dev_replace &&
 	     btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
-		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		return -EINPROGRESS;
 	}
-	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 
 	ret = scrub_workers_get(fs_info, is_dev_replace);
 	if (ret) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 350c12f1f19e..991e62a48090 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1916,12 +1916,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	mutex_lock(&uuid_mutex);
 
 	num_devices = fs_info->fs_devices->num_devices;
-	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
 		WARN_ON(num_devices < 1);
 		num_devices--;
 	}
-	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 
 	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
 	if (ret)
@@ -3892,12 +3892,12 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	}
 
 	num_devices = fs_info->fs_devices->num_devices;
-	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
 		BUG_ON(num_devices < 1);
 		num_devices--;
 	}
-	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE | BTRFS_BLOCK_GROUP_DUP;
 	if (num_devices > 1)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
@@ -5209,11 +5209,11 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 		ret = 1;
 	free_extent_map(em);
 
-	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace) &&
 	    fs_info->dev_replace.tgtdev)
 		ret++;
-	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
+	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 
 	return ret;
 }
@@ -5779,10 +5779,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	if (!bbio_ret)
 		goto out;
 
-	btrfs_dev_replace_lock(dev_replace, 0);
+	btrfs_dev_replace_read_lock(dev_replace);
 	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(dev_replace);
 	if (!dev_replace_is_ongoing)
-		btrfs_dev_replace_unlock(dev_replace, 0);
+		btrfs_dev_replace_read_unlock(dev_replace);
 	else
 		btrfs_dev_replace_set_lock_blocking(dev_replace);
 
@@ -5984,7 +5984,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 out:
 	if (dev_replace_is_ongoing) {
 		btrfs_dev_replace_clear_lock_blocking(dev_replace);
-		btrfs_dev_replace_unlock(dev_replace, 0);
+		btrfs_dev_replace_read_unlock(dev_replace);
 	}
 	free_extent_map(em);
 	return ret;
-- 
2.16.2

