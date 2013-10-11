Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43314 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3JKSLS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 14:11:18 -0400
Received: by mail-pa0-f51.google.com with SMTP id kp14so4731416pab.24
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 11:11:18 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com
Subject: [PATCH] Btrfs: avoid unnecessary scrub workers allocation
Date: Sat, 12 Oct 2013 02:11:12 +0800
Message-Id: <1381515072-7563-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

We only allocate scrub workers if we pass all the necessary
checks, for example, there are no operation in progress.

Besides, move mutex lock protection outside of scrub_workers_get()
/scrub_workers_put().

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f21e2df..54e1830 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2784,7 +2784,6 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 {
 	int ret = 0;
 
-	mutex_lock(&fs_info->scrub_lock);
 	if (fs_info->scrub_workers_refcnt == 0) {
 		if (is_dev_replace)
 			btrfs_init_workers(&fs_info->scrub_workers, "scrub", 1,
@@ -2814,21 +2813,17 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 	}
 	++fs_info->scrub_workers_refcnt;
 out:
-	mutex_unlock(&fs_info->scrub_lock);
-
 	return ret;
 }
 
 static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
 {
-	mutex_lock(&fs_info->scrub_lock);
 	if (--fs_info->scrub_workers_refcnt == 0) {
 		btrfs_stop_workers(&fs_info->scrub_workers);
 		btrfs_stop_workers(&fs_info->scrub_wr_completion_workers);
 		btrfs_stop_workers(&fs_info->scrub_nocow_workers);
 	}
 	WARN_ON(fs_info->scrub_workers_refcnt < 0);
-	mutex_unlock(&fs_info->scrub_lock);
 }
 
 int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
@@ -2889,23 +2884,18 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -EINVAL;
 	}
 
-	ret = scrub_workers_get(fs_info, is_dev_replace);
-	if (ret)
-		return ret;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (!dev || (dev->missing && !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		scrub_workers_put(fs_info);
 		return -ENODEV;
 	}
-	mutex_lock(&fs_info->scrub_lock);
 
+	mutex_lock(&fs_info->scrub_lock);
 	if (!dev->in_fs_metadata || dev->is_tgtdev_for_dev_replace) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		scrub_workers_put(fs_info);
 		return -EIO;
 	}
 
@@ -2916,10 +2906,17 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		btrfs_dev_replace_unlock(&fs_info->dev_replace);
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		scrub_workers_put(fs_info);
 		return -EINPROGRESS;
 	}
 	btrfs_dev_replace_unlock(&fs_info->dev_replace);
+
+	ret = scrub_workers_get(fs_info, is_dev_replace);
+	if (ret) {
+		mutex_unlock(&fs_info->scrub_lock);
+		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		return ret;
+	}
+
 	sctx = scrub_setup_ctx(dev, is_dev_replace);
 	if (IS_ERR(sctx)) {
 		mutex_unlock(&fs_info->scrub_lock);
@@ -2955,10 +2952,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	mutex_lock(&fs_info->scrub_lock);
 	dev->scrub_device = NULL;
+	scrub_workers_put(fs_info);
 	mutex_unlock(&fs_info->scrub_lock);
 
 	scrub_free_ctx(sctx);
-	scrub_workers_put(fs_info);
 
 	return ret;
 }
-- 
1.7.11.7

