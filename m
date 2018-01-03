Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51513 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeACIHo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jan 2018 03:07:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w0386jDF026877
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jan 2018 08:07:43 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2f8u9gg0qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jan 2018 08:07:43 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0387g0n010889
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jan 2018 08:07:42 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0387ggc016496
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jan 2018 08:07:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: rename btrfs_device::scrub_device to scrub_ctx
Date: Wed,  3 Jan 2018 16:08:30 +0800
Message-Id: <20180103080830.20971-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_device::scrub_device is not a device which is being scrubbed,
but it holds the scrub context, so rename to reflect the same. No
functional changes here.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/scrub.c   | 14 +++++++-------
 fs/btrfs/volumes.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 8c1508a41f90..692adb02a929 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4125,7 +4125,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	}
 
 	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
-	if (dev->scrub_device ||
+	if (dev->scrub_ctx ||
 	    (!is_dev_replace &&
 	     btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
 		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
@@ -4150,7 +4150,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return PTR_ERR(sctx);
 	}
 	sctx->readonly = readonly;
-	dev->scrub_device = sctx;
+	dev->scrub_ctx = sctx;
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	/*
@@ -4185,7 +4185,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		memcpy(progress, &sctx->stat, sizeof(*progress));
 
 	mutex_lock(&fs_info->scrub_lock);
-	dev->scrub_device = NULL;
+	dev->scrub_ctx = NULL;
 	scrub_workers_put(fs_info);
 	mutex_unlock(&fs_info->scrub_lock);
 
@@ -4242,16 +4242,16 @@ int btrfs_scrub_cancel_dev(struct btrfs_fs_info *fs_info,
 	struct scrub_ctx *sctx;
 
 	mutex_lock(&fs_info->scrub_lock);
-	sctx = dev->scrub_device;
+	sctx = dev->scrub_ctx;
 	if (!sctx) {
 		mutex_unlock(&fs_info->scrub_lock);
 		return -ENOTCONN;
 	}
 	atomic_inc(&sctx->cancel_req);
-	while (dev->scrub_device) {
+	while (dev->scrub_ctx) {
 		mutex_unlock(&fs_info->scrub_lock);
 		wait_event(fs_info->scrub_pause_wait,
-			   dev->scrub_device == NULL);
+			   dev->scrub_ctx == NULL);
 		mutex_lock(&fs_info->scrub_lock);
 	}
 	mutex_unlock(&fs_info->scrub_lock);
@@ -4268,7 +4268,7 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (dev)
-		sctx = dev->scrub_device;
+		sctx = dev->scrub_ctx;
 	if (sctx)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ff940856fb9b..8b504785bf8b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -131,7 +131,7 @@ struct btrfs_device {
 	struct completion flush_wait;
 
 	/* per-device scrub information */
-	struct scrub_ctx *scrub_device;
+	struct scrub_ctx *scrub_ctx;
 
 	struct btrfs_work work;
 	struct rcu_head rcu;
-- 
2.15.0

