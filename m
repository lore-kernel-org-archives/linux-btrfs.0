Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDED7C18DF5
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC08A206BB
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC08A206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbeKTXU1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 18:20:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:44686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728242AbeKTXU1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 18:20:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42A0AAF53
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 12:51:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 43053DA78B; Tue, 20 Nov 2018 13:51:06 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: dev-replace: open code trivial locking helpers
Date:   Tue, 20 Nov 2018 13:51:06 +0100
Message-Id: <5e2f7a124c8adb5f9ef8e05a4c6f9226ac69f242.1542717531.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542717531.git.dsterba@suse.com>
References: <cover.1542717531.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The dev-replace locking functions are now trivial wrappers around rw
semaphore that can be used directly everywhere. No functional change.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 81 ++++++++++++++++--------------------------
 fs/btrfs/dev-replace.h |  4 ---
 fs/btrfs/reada.c       | 12 +++----
 fs/btrfs/scrub.c       | 15 ++++----
 fs/btrfs/volumes.c     | 14 ++++----
 5 files changed, 52 insertions(+), 74 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index a37af7aaca86..9b8ab26deb41 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -284,13 +284,13 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
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
@@ -348,7 +348,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	ptr = btrfs_item_ptr(eb, path->slots[0],
 			     struct btrfs_dev_replace_item);
 
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
 	if (dev_replace->srcdev)
 		btrfs_set_dev_replace_src_devid(eb, ptr,
 			dev_replace->srcdev->devid);
@@ -371,7 +371,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	btrfs_set_dev_replace_cursor_right(eb, ptr,
 		dev_replace->cursor_right);
 	dev_replace->item_needs_writeback = 0;
-	btrfs_dev_replace_write_unlock(dev_replace);
+	up_write(&dev_replace->rwsem);
 
 	btrfs_mark_buffer_dirty(eb);
 
@@ -432,7 +432,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	}
 
 	need_unlock = true;
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
@@ -470,7 +470,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	dev_replace->item_needs_writeback = 1;
 	atomic64_set(&dev_replace->num_write_errors, 0);
 	atomic64_set(&dev_replace->num_uncorrectable_read_errors, 0);
-	btrfs_dev_replace_write_unlock(dev_replace);
+	up_write(&dev_replace->rwsem);
 	need_unlock = false;
 
 	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
@@ -484,7 +484,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		need_unlock = true;
-		btrfs_dev_replace_write_lock(dev_replace);
+		down_write(&dev_replace->rwsem);
 		dev_replace->replace_state =
 			BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED;
 		dev_replace->srcdev = NULL;
@@ -511,7 +511,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 
 leave:
 	if (need_unlock)
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 	btrfs_destroy_dev_replace_tgtdev(tgt_device);
 	return ret;
 }
@@ -579,18 +579,18 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
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
@@ -614,7 +614,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	/* keep away write_all_supers() during the finishing procedure */
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
 	dev_replace->replace_state =
 		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
 			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
@@ -634,7 +634,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				 btrfs_dev_name(src_device),
 				 src_device->devid,
 				 rcu_str_deref(tgt_device->name), scrub_ret);
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 		mutex_unlock(&fs_info->chunk_mutex);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		btrfs_rm_dev_replace_blocked(fs_info);
@@ -670,8 +670,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
 	fs_info->fs_devices->rw_devices++;
 
-	btrfs_dev_replace_write_unlock(dev_replace);
-
+	up_write(&dev_replace->rwsem);
 	btrfs_rm_dev_replace_blocked(fs_info);
 
 	btrfs_rm_dev_replace_remove_srcdev(src_device);
@@ -768,7 +767,7 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
-	btrfs_dev_replace_read_lock(dev_replace);
+	down_read(&dev_replace->rwsem);
 	/* even if !dev_replace_is_valid, the values are good enough for
 	 * the replace_status ioctl */
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
@@ -780,7 +779,7 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 	args->status.num_uncorrectable_read_errors =
 		atomic64_read(&dev_replace->num_uncorrectable_read_errors);
 	args->status.progress_1000 = btrfs_dev_replace_progress(fs_info);
-	btrfs_dev_replace_read_unlock(dev_replace);
+	up_read(&dev_replace->rwsem);
 }
 
 int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
@@ -797,18 +796,18 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
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
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 		tgt_device = dev_replace->tgtdev;
 		src_device = dev_replace->srcdev;
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 		ret = btrfs_scrub_cancel(fs_info);
 		if (ret < 0) {
 			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED;
@@ -839,7 +838,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		dev_replace->time_stopped = ktime_get_real_seconds();
 		dev_replace->item_needs_writeback = 1;
 
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 
 		/* Scrub for replace must not be running in suspended state */
 		ret = btrfs_scrub_cancel(fs_info);
@@ -874,7 +873,8 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
-	btrfs_dev_replace_write_lock(dev_replace);
+	down_write(&dev_replace->rwsem);
+
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
@@ -890,7 +890,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 		break;
 	}
 
-	btrfs_dev_replace_write_unlock(dev_replace);
+	up_write(&dev_replace->rwsem);
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 }
 
@@ -900,12 +900,13 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
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
@@ -921,10 +922,10 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 			   "you may cancel the operation after 'mount -o degraded'");
 		dev_replace->replace_state =
 					BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 		return 0;
 	}
-	btrfs_dev_replace_write_unlock(dev_replace);
+	up_write(&dev_replace->rwsem);
 
 	/*
 	 * This could collide with a paused balance, but the exclusive op logic
@@ -932,10 +933,10 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 	 * dev-replace to start anyway.
 	 */
 	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
-		btrfs_dev_replace_write_lock(dev_replace);
+		down_write(&dev_replace->rwsem);
 		dev_replace->replace_state =
 					BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
-		btrfs_dev_replace_write_unlock(dev_replace);
+		up_write(&dev_replace->rwsem);
 		btrfs_info(fs_info,
 		"cannot resume dev-replace, other exclusive operation running");
 		return 0;
@@ -999,26 +1000,6 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
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
index dd1dcb22c1e3..4aa40bacc6cc 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -19,9 +19,5 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
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
index dc09c6abaf6d..14241e2f3c6f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1898,12 +1898,12 @@ static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
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
@@ -5175,11 +5175,11 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
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
@@ -5757,14 +5757,14 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
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
@@ -5961,7 +5961,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	if (dev_replace_is_ongoing) {
 		lockdep_assert_held(&dev_replace->rwsem);
 		/* Unlock and let waiting writers proceed */
-		btrfs_dev_replace_read_unlock(dev_replace);
+		up_read(&dev_replace->rwsem);
 	}
 	free_extent_map(em);
 	return ret;
-- 
2.19.1

