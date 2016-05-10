Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbcEJOCD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:02:03 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 04/13] btrfs: Allow barrier_all_devices to do per-chunk device check
Date: Tue, 10 May 2016 22:01:42 +0800
Message-Id: <1462888911-5227-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
References: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

The last user of num_tolerated_disk_barrier_failures is
barrier_all_devices(). But it's can be easily changed to new per-chunk
degradable check framework.

Now btrfs_device will have two extra members, representing send/wait
error, set at write_dev_flush() time. And then check it in a similar but
more accurate behavior than old code.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 13 +++++--------
 fs/btrfs/volumes.c |  6 +++++-
 fs/btrfs/volumes.h |  4 ++++
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4f91a049fbca..9ad3667f5e71 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3496,8 +3496,6 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
-	int errors_send = 0;
-	int errors_wait = 0;
 	int ret;
 
 	/* send down all the barriers */
@@ -3506,7 +3504,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_send++;
+			dev->err_send = 1;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3514,7 +3512,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 		ret = write_dev_flush(dev, 0);
 		if (ret)
-			errors_send++;
+			dev->err_send = 1;
 	}
 
 	/* wait for all the barriers */
@@ -3522,7 +3520,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_wait++;
+			dev->err_wait = 1;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3530,10 +3528,9 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 		ret = write_dev_flush(dev, 1);
 		if (ret)
-			errors_wait++;
+			dev->err_wait = 1;
 	}
-	if (errors_send > info->num_tolerated_disk_barrier_failures ||
-	    errors_wait > info->num_tolerated_disk_barrier_failures)
+	if (btrfs_check_degradable(info, info->sb->s_flags) < 0)
 		return -EIO;
 	return 0;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f5fa5f88263c..639ae20cc5e6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7105,8 +7105,12 @@ int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags)
 			btrfs_get_num_tolerated_disk_barrier_failures(
 					map->type);
 		for (i = 0; i < map->num_stripes; i++) {
-			if (map->stripes[i].dev->missing)
+			if (map->stripes[i].dev->missing ||
+			    map->stripes[i].dev->err_wait ||
+			    map->stripes[i].dev->err_send)
 				missing++;
+			map->stripes[i].dev->err_wait = 0;
+			map->stripes[i].dev->err_send = 0;
 		}
 		if (missing > max_tolerated) {
 			ret = -EIO;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ae9d552c93bf..101e5db2dd63 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -76,6 +76,10 @@ struct btrfs_device {
 	int can_discard;
 	int is_tgtdev_for_dev_replace;
 
+	/* for barrier_all_devices() check */
+	int err_send;
+	int err_wait;
+
 #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
 	seqcount_t data_seqcount;
 #endif
-- 
2.7.0

