Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbeB0EbO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Feb 2018 23:31:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1R4RFCc188957
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 04:31:13 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2gd0a0g0b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 04:31:13 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1R4VChj004466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 04:31:12 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1R4VCUE002840
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 04:31:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: rename btrfs_close_extra_device to btrfs_free_extra_devids
Date: Tue, 27 Feb 2018 12:32:42 +0800
Message-Id: <20180227043242.26367-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function btrfs_close_extra_devices() is about freeing
extra devids which once belonged to this fsid. So rename it
and add the comment. The _devid suffix is appropriate as this
function won't handle devices which are outside of the fsid
being mounted. No functional change.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 fs/btrfs/volumes.c | 6 +++++-
 fs/btrfs/volumes.h | 2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 798e602c1834..c82f8a471c32 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2758,10 +2758,10 @@ int open_ctree(struct super_block *sb,
 	}
 
 	/*
-	 * keep the device that is marked to be the target device for the
+	 * keep the devid that is marked to be the target device for the
 	 * dev_replace procedure
 	 */
-	btrfs_close_extra_devices(fs_devices, 0);
+	btrfs_free_extra_devids(fs_devices, 0);
 
 	if (!fs_devices->latest_bdev) {
 		btrfs_err(fs_info, "failed to read devices");
@@ -2824,7 +2824,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_block_groups;
 	}
 
-	btrfs_close_extra_devices(fs_devices, 1);
+	btrfs_free_extra_devids(fs_devices, 1);
 
 	ret = btrfs_sysfs_add_fsid(fs_devices, NULL);
 	if (ret) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f0ebf36f02fd..430e5c2e7e1d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -896,7 +896,11 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	return ERR_PTR(-ENOMEM);
 }
 
-void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
+/*
+ * After we have read the system tree and know devids belonging to
+ * this fsid, remove the device which does not belong to this fsid.
+ */
+void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 {
 	struct btrfs_device *device, *next;
 	struct btrfs_device *latest_dev = NULL;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index efe4168def6d..827e9a5c3d9c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -429,7 +429,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
-void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
+void btrfs_free_extra_devid(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
 		struct btrfs_device *device, struct btrfs_device *this_dev);
 int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
-- 
2.15.0

