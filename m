Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACAF33065D;
	Mon, 15 Jun 2026 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529517; cv=none; b=J0lZQxJ/582hDK8w2E74zvClJ+e1/eZ0ZVpxLwYoYNT3jfLv6PoVOqP+1VHysctaugT7VAQKaUsTJD9sPyrKBABc9Mkf8tbe5N7AO8XwfYY3I9ijB87iZjSKjcN0MOPLWFm83x17pjpvP+6L574GGVQoPD1CgWrFwA57S/vqsi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529517; c=relaxed/simple;
	bh=j2tYKOHliiTcseByFnEMrSNCojE4F/ZyKqcc1k/44fc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WJJLe7rStx04+5pEZR+BXnjYF+G8uMzn8ofEgFn4B6FVszQ0RyiLVdMAnTpiQLVc1u6U7QpMpixQ9R4vz9QK7d88n5CQMZer4SRBchatLWAOUMxnC7wAPtGKwe4tI8NYBFb6QDxiYQAk6fE4KKkfS6e/bQNiyhyayfweA4hV16w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlVE/jVV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlVE/jVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF221F000E9;
	Mon, 15 Jun 2026 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529515;
	bh=CG+uYsm+6cBYc4MaaopSAxa8VTETnS8gpQ0R8EuDOO0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mlVE/jVVaUI2f1buKJfhw23fWUNALpKGJ3j49oR5yOzUBJX3cbU+jTyglUD7tUVKP
	 ZFxP01QxmZKQ85FK9c0/Qu9V8iciSdJFcD7F5fMfuqbrA7bYNYapeicylhds9crPVh
	 bFsToR80Gv6qRevFmHWwxz8WgD9+y45inkVzQ0X7/RHXuWhwC79ilO6eEMSULVU7An
	 BxPwdDCQnk33YaSieOBGznK35aW5Qe0HY1nVto3HbW77gdxehjXek62tDD+oHG6i1x
	 gYhRzf0zBsou5pSTppEiyVY4v8P7oMCPbf5PsKSvchAwhgcMNSSruWMYfwLRoaeE5a
	 NHMMLvEnUFiEQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:18:09 +0200
Subject: [PATCH RFC 6/6] btrfs: deny freezing devices undergoing a replace
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-super-freeze_deny_upstream-v1-6-a6c72b840e7d@kernel.org>
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=10942; i=brauner@kernel.org;
 h=from:subject:message-id; bh=j2tYKOHliiTcseByFnEMrSNCojE4F/ZyKqcc1k/44fc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/54uKMH+cP6DRs+ra7Yr8yz688Jw6rZeKduvj6U+5
 a1t43u2sqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiy90YGfYYiVrlPr14ayXf
 QbfNQtqyOhvrDm578O3jORlDblemvteMDB//FEx/UvItNler015+1wX70i3VMrMzXj0W+fzI/dt
 kVTYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

A device replace opens a target and, on success, frees the source on a live
filesystem from btrfs_dev_replace_finishing() - which cannot fail and also
runs from a kthread on mount resume.  A bdev_freeze() racing the source free
or the target swap-in would freeze the filesystem through a claim that is
being torn down or replaced, leaving nothing for bdev_thaw() to rebalance.

Make both devices unfreezable for the whole replace, with the invariant that
a STARTED replace holds one deny on each device and any other state holds
none.  The target is denied at open (btrfs_open_device_deny_freeze(), undone
on btrfs_init_dev_replace_tgtdev()'s error unwind); the source is denied at
the start of btrfs_dev_replace_start(), before mark_block_group_to_copy() so
every 'leave' unwind sees both denied.

The deny tracks the STARTED state and is dropped whenever the replace leaves
it: btrfs_dev_replace_finishing() re-allows the target it makes a member and
frees the source through btrfs_close_bdev(allow_freeze=true), and its
scrub-error path re-allows both as it cancels.  Its early failures (before
the device swap) keep the replace STARTED and resumable, so both stay denied.
Suspending for unmount re-allows both, so they are reopened freezable at the
next mount where btrfs_resume_dev_replace_async() re-denies them (staying
suspended if a device is frozen right then); a replace cancelled from the
suspended state therefore destroys the target without allowing.
btrfs_close_bdev() and btrfs_destroy_dev_replace_tgtdev() take an allow_freeze
argument to carry this distinction; the unmount path
(btrfs_close_one_device()) passes false.

On resume, a failed kthread_run() re-allows both devices and goes through the
suspend path, resetting the replace to SUSPENDED and finishing the exclusive
operation instead of returning straight away.  The (re)mount still aborts on
that error; routing it through suspend keeps the deny balanced against the
unmount teardown and additionally drops BTRFS_EXCLOP_DEV_REPLACE, closing a
pre-existing leak that was harmless on the failed mount that frees the fs but
would have wedged future exclusive operations after a failed remount-rw.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/dev-replace.c | 65 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/volumes.c     | 18 +++++++++-----
 fs/btrfs/volumes.h     |  3 ++-
 3 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 0112aa6d7ab1..4d6bd6b4b039 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -247,8 +247,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 		return -EINVAL;
 	}
 
-	bdev_file = bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
-					   fs_info->sb, &fs_holder_ops);
+	/* Unfreezable for the whole replace; see btrfs_dev_replace_start(). */
+	bdev_file = btrfs_open_device_deny_freeze(device_path, fs_info->sb);
 	if (IS_ERR(bdev_file)) {
 		btrfs_err(fs_info, "target device %s is invalid!", device_path);
 		return PTR_ERR(bdev_file);
@@ -325,7 +325,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	return 0;
 
 error:
-	bdev_fput(bdev_file);
+	/* Undo the open-time freeze deny. */
+	btrfs_release_device_allow_freeze(bdev_file);
 	return ret;
 }
 
@@ -622,6 +623,15 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	if (ret)
 		return ret;
 
+	/* Deny the source before mark, so every 'leave' unwinds both denied. */
+	if (src_device->bdev) {
+		ret = bdev_deny_freeze(src_device->bdev);
+		if (ret) {
+			btrfs_destroy_dev_replace_tgtdev(tgt_device, true);
+			return ret;
+		}
+	}
+
 	ret = mark_block_group_to_copy(fs_info, src_device);
 	if (ret)
 		goto leave;
@@ -706,7 +716,9 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	return ret;
 
 leave:
-	btrfs_destroy_dev_replace_tgtdev(tgt_device);
+	if (src_device->bdev)
+		bdev_allow_freeze(src_device->bdev);
+	btrfs_destroy_dev_replace_tgtdev(tgt_device, true);
 	return ret;
 }
 
@@ -887,6 +899,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 */
 	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
 	if (ret) {
+		/* Stays started/resumable; keep both denied. */
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
 	}
@@ -900,6 +913,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
+			/* Stays started/resumable; keep both denied. */
 			mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 			return PTR_ERR(trans);
 		}
@@ -952,7 +966,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		mutex_unlock(&fs_devices->device_list_mutex);
 		btrfs_rm_dev_replace_blocked(fs_info);
 		if (tgt_device)
-			btrfs_destroy_dev_replace_tgtdev(tgt_device);
+			btrfs_destroy_dev_replace_tgtdev(tgt_device, true);
+		/* The source stays a member; re-allow freezing it. */
+		if (src_device->bdev)
+			bdev_allow_freeze(src_device->bdev);
 		btrfs_rm_dev_replace_unblocked(fs_info);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
@@ -1018,6 +1035,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
+	/* The target is now a member; the source is freed (allow + release). */
+	bdev_allow_freeze(tgt_device->bdev);
 	btrfs_rm_dev_replace_free_srcdev(src_device);
 
 	return 0;
@@ -1146,8 +1165,9 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 			btrfs_dev_name(src_device), src_device->devid,
 			btrfs_dev_name(tgt_device));
 
+		/* A suspended replace never re-denied freezing; do not allow. */
 		if (tgt_device)
-			btrfs_destroy_dev_replace_tgtdev(tgt_device);
+			btrfs_destroy_dev_replace_tgtdev(tgt_device, false);
 		break;
 	default:
 		up_write(&dev_replace->rwsem);
@@ -1177,6 +1197,11 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 		dev_replace->time_stopped = ktime_get_real_seconds();
 		dev_replace->item_needs_writeback = 1;
 		btrfs_info(fs_info, "suspending dev_replace for unmount");
+		/* Reopened freezable next mount; resume re-denies. */
+		if (dev_replace->srcdev && dev_replace->srcdev->bdev)
+			bdev_allow_freeze(dev_replace->srcdev->bdev);
+		if (dev_replace->tgtdev && dev_replace->tgtdev->bdev)
+			bdev_allow_freeze(dev_replace->tgtdev->bdev);
 		break;
 	}
 
@@ -1189,6 +1214,7 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 {
 	struct task_struct *task;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
+	int ret = 0;
 
 	down_write(&dev_replace->rwsem);
 
@@ -1232,8 +1258,33 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 		return 0;
 	}
 
+	/* Re-deny for the resumed replace; stay suspended if frozen now. */
+	if (dev_replace->srcdev->bdev &&
+	    bdev_deny_freeze(dev_replace->srcdev->bdev))
+		goto suspend;
+	if (bdev_deny_freeze(dev_replace->tgtdev->bdev)) {
+		if (dev_replace->srcdev->bdev)
+			bdev_allow_freeze(dev_replace->srcdev->bdev);
+		goto suspend;
+	}
+
 	task = kthread_run(btrfs_dev_replace_kthread, fs_info, "btrfs-devrepl");
-	return PTR_ERR_OR_ZERO(task);
+	if (IS_ERR(task)) {
+		bdev_allow_freeze(dev_replace->tgtdev->bdev);
+		if (dev_replace->srcdev->bdev)
+			bdev_allow_freeze(dev_replace->srcdev->bdev);
+		/* Undo the deny and suspend, but still fail the mount. */
+		ret = PTR_ERR(task);
+		goto suspend;
+	}
+	return 0;
+
+suspend:
+	btrfs_exclop_finish(fs_info);
+	down_write(&dev_replace->rwsem);
+	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
+	up_write(&dev_replace->rwsem);
+	return ret;
 }
 
 static int btrfs_dev_replace_kthread(void *data)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4558e018b53b..d9f2cd37a365 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1128,7 +1128,7 @@ void btrfs_release_device_allow_freeze(struct file *bdev_file)
 	bdev_fput(bdev_file);
 }
 
-static void btrfs_close_bdev(struct btrfs_device *device)
+static void btrfs_close_bdev(struct btrfs_device *device, bool allow_freeze)
 {
 	if (!device->bdev)
 		return;
@@ -1138,7 +1138,11 @@ static void btrfs_close_bdev(struct btrfs_device *device)
 		invalidate_bdev(device->bdev);
 	}
 
-	bdev_fput(device->bdev_file);
+	/* @allow_freeze undoes a replace-time deny; unmount-close was never denied. */
+	if (allow_freeze)
+		btrfs_release_device_allow_freeze(device->bdev_file);
+	else
+		bdev_fput(device->bdev_file);
 }
 
 static void btrfs_close_one_device(struct btrfs_device *device)
@@ -1159,7 +1163,7 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 		fs_devices->missing_devices--;
 	}
 
-	btrfs_close_bdev(device);
+	btrfs_close_bdev(device, false);
 	if (device->bdev) {
 		fs_devices->open_devices--;
 		device->bdev = NULL;
@@ -2511,7 +2515,8 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_device *srcdev)
 
 	mutex_lock(&uuid_mutex);
 
-	btrfs_close_bdev(srcdev);
+	/* The source was made unfreezable for the replace; undo it. */
+	btrfs_close_bdev(srcdev, true);
 	synchronize_rcu();
 	btrfs_free_device(srcdev);
 
@@ -2532,7 +2537,8 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_device *srcdev)
 	mutex_unlock(&uuid_mutex);
 }
 
-void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
+void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev,
+				      bool allow_freeze)
 {
 	struct btrfs_fs_devices *fs_devices = tgtdev->fs_info->fs_devices;
 
@@ -2553,7 +2559,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 
 	btrfs_scratch_superblocks(tgtdev->fs_info, tgtdev);
 
-	btrfs_close_bdev(tgtdev);
+	btrfs_close_bdev(tgtdev, allow_freeze);
 	synchronize_rcu();
 	btrfs_free_device(tgtdev);
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 75c7963f5d4c..65de9504d887 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -790,7 +790,8 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_stats(struct btrfs_trans_handle *trans);
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev);
 void btrfs_rm_dev_replace_free_srcdev(struct btrfs_device *srcdev);
-void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev);
+void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev,
+				      bool allow_freeze);
 unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 				    u64 logical);
 u64 btrfs_calc_stripe_length(const struct btrfs_chunk_map *map);

-- 
2.47.3

