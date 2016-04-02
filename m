Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48415 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbcDBBbQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 21:31:16 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: yauhen.kharuzhy@zavadatar.com, dsterba@suse.cz
Subject: [PATCH 04/13] btrfs: Allow barrier_all_devices to do per-chunk device check
Date: Sat,  2 Apr 2016 09:30:42 +0800
Message-Id: <1459560651-14809-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
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
index bfea0f8f6a87..85e26d62c089 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3491,8 +3491,6 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
-	int errors_send = 0;
-	int errors_wait = 0;
 	int ret;
 
 	/* send down all the barriers */
@@ -3501,7 +3499,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_send++;
+			dev->err_send = 1;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3509,7 +3507,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 		ret = write_dev_flush(dev, 0);
 		if (ret)
-			errors_send++;
+			dev->err_send = 1;
 	}
 
 	/* wait for all the barriers */
@@ -3517,7 +3515,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_wait++;
+			dev->err_wait = 1;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3525,10 +3523,9 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
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
index dd3dc53a302a..a840d78ba127 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7081,8 +7081,12 @@ int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags)
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
index 351431a3f5aa..48ced5cc09e4 100644
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

