Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbeIGThB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:37:01 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D773ACBB
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 11/11] btrfs: dev-replace: open code trivial locking helpers
Date: Fri,  7 Sep 2018 16:55:25 +0200
Message-Id: <58cdb1b0ae9fa90df48fb70e55b1e7edba125bb8.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The dev-replace locking functions are now trivial wrappers around rw
semaphore that can be used directly everywhere. No functional change.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 73 ++++++++++++++++--------------------------
 fs/btrfs/dev-replace.h |  4 ---
 fs/btrfs/reada.c       | 12 +++----
 fs/btrfs/scrub.c       | 15 +++++----
 fs/btrfs/volumes.c     | 14 ++++----
 5 files changed, 48 insertions(+), 70 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e8c2f418b2d7..d61c225b3e83 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -285,13 +285,13 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	struct btrfs_dev_replace_item *ptr;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
-	btrfs_dev_replace_read_lock(dev_replace);
+	down_read(&dev_replace->rwsem);
 	if (!dev_replace->is_valid ||
 	    !dev_replace->item_needs_writeback) {
-		btrfs_dev_replace_read_unlock(dev_replace);
+		up_read(&dev_replace->rwsem);
 		return 0;
 	}
-	btrfs_dev_replace_read_unlock(dev_replace);
+	up_read(&dev_replace->rwsem);
 
 	key.objectid = 0;
 	key.type = BTRFS_DEV_REPLACE_KEY;
@@ -349,7 +349,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	ptr = btrfs_item_ptr(eb, path->slots[0],
 			     struct btrfs_dev_replace_item);
 
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
 	if (dev_replace->srcdev)
 		btrfs_set_dev_replace_src_devid(eb, ptr,
 			dev_replace->srcdev->devid);
@@ -372,7 +372,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	btrfs_set_dev_replace_cursor_right(eb, ptr,
 		dev_replace->cursor_right);
 	dev_replace->item_needs_writeback = 0;
-	btrfs_dev_replace_write_unlock(dev_replace);
+	up_write(&dev_replace->rwsem);
 
 	btrfs_mark_buffer_dirty(eb);
 
@@ -426,7 +426,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	}
 
 	need_unlock = true;
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
@@ -463,7 +463,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	dev_replace->item_needs_writeback = 1;
 	atomic64_set(&dev_replace->num_write_errors, 0);
 	atomic64_set(&dev_replace->num_uncorrectable_read_errors, 0);
-	btrfs_dev_replace_write_unlock(dev_replace);
+	up_write(&dev_replace->rwsem);
 	need_unlock = false;
 
 	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
@@ -500,7 +500,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	dev_replace->srcdev = NULL;
 	dev_replace->tgtdev = NULL;
 	if (need_unlock)
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 	btrfs_destroy_dev_replace_tgtdev(tgt_device);
 	return ret;
 }
@@ -567,18 +567,18 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	/* don't allow cancel or unmount to disturb the finishing procedure */
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
 
-	btrfs_dev_replace_read_lock(dev_replace);
+	down_read(&dev_replace->rwsem);
 	/* was the operation canceled, or is it finished? */
 	if (dev_replace->replace_state !=
 	    BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
-		btrfs_dev_replace_read_unlock(dev_replace);
+		up_read(&dev_replace->rwsem);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return 0;
 	}
 
 	tgt_device = dev_replace->tgtdev;
 	src_device = dev_replace->srcdev;
-	btrfs_dev_replace_read_unlock(dev_replace);
+	up_read(&dev_replace->rwsem);
 
 	/*
 	 * flush all outstanding I/O and inode extent mappings before the
@@ -602,7 +602,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	/* keep away write_all_supers() during the finishing procedure */
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
 	dev_replace->replace_state =
 		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
 			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
@@ -622,7 +622,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				 btrfs_dev_name(src_device),
 				 src_device->devid,
 				 rcu_str_deref(tgt_device->name), scrub_ret);
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 		mutex_unlock(&fs_info->chunk_mutex);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		btrfs_rm_dev_replace_blocked(fs_info);
@@ -658,8 +658,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
 	fs_info->fs_devices->rw_devices++;
 
-	btrfs_dev_replace_write_unlock(dev_replace);
-
+	up_write(&dev_replace->rwsem);
 	btrfs_rm_dev_replace_blocked(fs_info);
 
 	btrfs_rm_dev_replace_remove_srcdev(src_device);
@@ -756,7 +755,7 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
-	btrfs_dev_replace_read_lock(dev_replace);
+	down_read(&dev_replace->rwsem);
 	/* even if !dev_replace_is_valid, the values are good enough for
 	 * the replace_status ioctl */
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
@@ -768,7 +767,7 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 	args->status.num_uncorrectable_read_errors =
 		atomic64_read(&dev_replace->num_uncorrectable_read_errors);
 	args->status.progress_1000 = btrfs_dev_replace_progress(fs_info);
-	btrfs_dev_replace_read_unlock(dev_replace);
+	up_read(&dev_replace->rwsem);
 }
 
 int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
@@ -785,13 +784,13 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		return -EROFS;
 
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
 		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED;
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 		goto leave;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
@@ -805,7 +804,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;
 	dev_replace->time_stopped = ktime_get_real_seconds();
 	dev_replace->item_needs_writeback = 1;
-	btrfs_dev_replace_write_unlock(dev_replace);
+	up_write(&dev_replace->rwsem);
 	btrfs_scrub_cancel(fs_info);
 
 	trans = btrfs_start_transaction(root, 0);
@@ -834,7 +833,8 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
+
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
@@ -850,7 +850,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 		break;
 	}
 
-	btrfs_dev_replace_write_unlock(dev_replace);
+	up_write(&dev_replace->rwsem);
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 }
 
@@ -860,12 +860,13 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 	struct task_struct *task;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
+
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 		return 0;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 		break;
@@ -879,10 +880,10 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 			   "cannot continue dev_replace, tgtdev is missing");
 		btrfs_info(fs_info,
 			   "you may cancel the operation after 'mount -o degraded'");
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 		return 0;
 	}
-	btrfs_dev_replace_write_unlock(dev_replace);
+	up_write(&dev_replace->rwsem);
 
 	/*
 	 * This could collide with a paused balance, but the exclusive op logic
@@ -953,26 +954,6 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 	return 1;
 }
 
-void btrfs_dev_replace_read_lock(struct btrfs_dev_replace *dev_replace)
-{
-	down_read(&dev_replace->rwsem);
-}
-
-void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace)
-{
-	up_read(&dev_replace->rwsem);
-}
-
-void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace)
-{
-	down_write(&dev_replace->rwsem);
-}
-
-void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace)
-{
-	up_write(&dev_replace->rwsem);
-}
-
 void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
 {
 	percpu_counter_inc(&fs_info->dev_replace.bio_counter);
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index eec7289c2618..f81cb16e8e56 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -22,9 +22,5 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
 void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info);
 int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info);
 int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace);
-void btrfs_dev_replace_read_lock(struct btrfs_dev_replace *dev_replace);
-void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace);
-void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace);
-void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace);
 
 #endif
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 6c4fdd98582d..96002e6e2346 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -377,10 +377,10 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 	}
 
 	/* insert extent in reada_tree + all per-device trees, all or nothing */
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
+	down_read(&fs_info->dev_replace.rwsem);
 	ret = radix_tree_preload(GFP_KERNEL);
 	if (ret) {
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+		up_read(&fs_info->dev_replace.rwsem);
 		goto error;
 	}
 
@@ -391,13 +391,13 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 		re_exist->refcnt++;
 		spin_unlock(&fs_info->reada_lock);
 		radix_tree_preload_end();
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+		up_read(&fs_info->dev_replace.rwsem);
 		goto error;
 	}
 	if (ret) {
 		spin_unlock(&fs_info->reada_lock);
 		radix_tree_preload_end();
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+		up_read(&fs_info->dev_replace.rwsem);
 		goto error;
 	}
 	radix_tree_preload_end();
@@ -439,13 +439,13 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 			}
 			radix_tree_delete(&fs_info->reada_tree, index);
 			spin_unlock(&fs_info->reada_lock);
-			btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+			up_read(&fs_info->dev_replace.rwsem);
 			goto error;
 		}
 		have_zone = 1;
 	}
 	spin_unlock(&fs_info->reada_lock);
-	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+	up_read(&fs_info->dev_replace.rwsem);
 
 	if (!have_zone)
 		goto error;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 902819d3cf41..4936cc65dca0 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3596,11 +3596,12 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			break;
 		}
 
-		btrfs_dev_replace_write_lock(&fs_info->dev_replace);
+		down_write(&fs_info->dev_replace.rwsem);
 		dev_replace->cursor_right = found_key.offset + length;
 		dev_replace->cursor_left = found_key.offset;
 		dev_replace->item_needs_writeback = 1;
-		btrfs_dev_replace_write_unlock(&fs_info->dev_replace);
+		up_write(&dev_replace->rwsem);
+
 		ret = scrub_chunk(sctx, scrub_dev, chunk_offset, length,
 				  found_key.offset, cache);
 
@@ -3636,10 +3637,10 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		scrub_pause_off(fs_info);
 
-		btrfs_dev_replace_write_lock(&fs_info->dev_replace);
+		down_write(&fs_info->dev_replace.rwsem);
 		dev_replace->cursor_left = dev_replace->cursor_right;
 		dev_replace->item_needs_writeback = 1;
-		btrfs_dev_replace_write_unlock(&fs_info->dev_replace);
+		up_write(&fs_info->dev_replace.rwsem);
 
 		if (ro_set)
 			btrfs_dec_block_group_ro(cache);
@@ -3838,16 +3839,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -EIO;
 	}
 
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
+	down_read(&fs_info->dev_replace.rwsem);
 	if (dev->scrub_ctx ||
 	    (!is_dev_replace &&
 	     btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+		up_read(&fs_info->dev_replace.rwsem);
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		return -EINPROGRESS;
 	}
-	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+	up_read(&fs_info->dev_replace.rwsem);
 
 	ret = scrub_workers_get(fs_info, is_dev_replace);
 	if (ret) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d1f83529ac80..bde2992c3713 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1862,12 +1862,12 @@ static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
 {
 	u64 num_devices = fs_info->fs_devices->num_devices;
 
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
+	down_read(&fs_info->dev_replace.rwsem);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
 		ASSERT(num_devices > 1);
 		num_devices--;
 	}
-	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+	up_read(&fs_info->dev_replace.rwsem);
 
 	return num_devices;
 }
@@ -5122,11 +5122,11 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 		ret = 1;
 	free_extent_map(em);
 
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
+	down_read(&fs_info->dev_replace.rwsem);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace) &&
 	    fs_info->dev_replace.tgtdev)
 		ret++;
-	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+	up_read(&fs_info->dev_replace.rwsem);
 
 	return ret;
 }
@@ -5704,14 +5704,14 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	if (!bbio_ret)
 		goto out;
 
-	btrfs_dev_replace_read_lock(dev_replace);
+	down_read(&dev_replace->rwsem);
 	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(dev_replace);
 	/*
 	 * Hold the semaphore for read during the whole operation, write is
 	 * requested at commit time but must wait.
 	 */
 	if (!dev_replace_is_ongoing)
-		btrfs_dev_replace_read_unlock(dev_replace);
+		up_read(&dev_replace->rwsem);
 
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
 	    !need_full_stripe(op) && dev_replace->tgtdev != NULL) {
@@ -5908,7 +5908,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	if (dev_replace_is_ongoing) {
 		lockdep_assert_held(&dev_replace->rwsem);
 		/* Unlock and let waiting writers proceed */
-		btrfs_dev_replace_read_unlock(dev_replace);
+		up_read(&dev_replace->rwsem);
 	}
 	free_extent_map(em);
 	return ret;
-- 
2.18.0
