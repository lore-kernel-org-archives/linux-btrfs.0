Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46515 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932817AbdLRJIZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 04:08:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBI96jmY022562
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 09:08:24 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2exa2xr7jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 09:08:24 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBI98Njf006403
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 09:08:23 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBI98NOY032529
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 09:08:23 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: factor btrfs_check_rw_degradable() to check given device
Date: Mon, 18 Dec 2017 17:08:59 +0800
Message-Id: <20171218090859.8141-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update btrfs_check_rw_degradable() to check against the given
device if its lost.

We can use this function to know if the volume is going to be
in degraded mode OR failed state, when the given device fails.
Which is needed when we are handling the device failed state.

A preparatory patch does not affect the flow as such.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 4 ++--
 fs/btrfs/super.c   | 2 +-
 fs/btrfs/volumes.c | 8 ++++++--
 fs/btrfs/volumes.h | 4 ++--
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 55bc6c846671..5604f5e1873e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2904,7 +2904,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_sysfs;
 	}
 
-	if (!sb_rdonly(sb) && !btrfs_check_rw_degradable(fs_info)) {
+	if (!sb_rdonly(sb) && !btrfs_check_rw_degradable(fs_info, NULL)) {
 		btrfs_warn(fs_info,
 		"writeable mount is not allowed due to too many missing devices");
 		goto fail_sysfs;
@@ -3423,7 +3423,7 @@ static blk_status_t wait_dev_flush(struct btrfs_device *device)
 
 static int check_barrier_error(struct btrfs_fs_info *fs_info)
 {
-	if (!btrfs_check_rw_degradable(fs_info))
+	if (!btrfs_check_rw_degradable(fs_info, NULL))
 		return -EIO;
 	return 0;
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f8129ebad963..cb6d62cf83ec 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1855,7 +1855,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 		}
 
-		if (!btrfs_check_rw_degradable(fs_info)) {
+		if (!btrfs_check_rw_degradable(fs_info, NULL)) {
 			btrfs_warn(fs_info,
 				"too many missing devices, writeable remount is not allowed");
 			ret = -EACCES;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b881fc2b2225..9c4868d6fd9a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6923,7 +6923,8 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
  * Return true if all chunks meet the minimal RW mount requirements.
  * Return false if any chunk doesn't meet the minimal RW mount requirements.
  */
-bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
+bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
+					struct btrfs_device *failing_dev)
 {
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct extent_map *em;
@@ -6955,9 +6956,12 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
 			    test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) ||
 			    dev->last_flush_error)
 				missing++;
+			else if (failing_dev && failing_dev == dev)
+				missing++;
 		}
 		if (missing > max_tolerated) {
-			btrfs_warn(fs_info,
+			if (!failing_dev)
+				btrfs_warn(fs_info,
 	"chunk %llu missing %d devices, max tolerance is %d for writeable mount",
 				   em->start, missing, max_tolerated);
 			free_extent_map(em);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c7484da44ca4..e707fb39b2d4 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -555,7 +555,7 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_fs_info *fs_info,
 struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
-
-bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
+bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
+					struct btrfs_device *failing_dev);
 
 #endif
-- 
2.15.0

