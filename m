Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37978 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755820AbbIUCMv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 22:12:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8L2CVAJ003282
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 10:12:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs: Allow barrier_all_devices to do per-chunk device check
Date: Mon, 21 Sep 2015 10:10:42 +0800
Message-ID: <1442801443-5132-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The last user of num_tolerated_disk_barrier_failures is
barrier_all_devices().
But it's can be easily changed to new per-chunk degradable check
framework.

Now btrfs_device will have two extra members, representing send/wait
error, set at write_dev_flush() time.
And then check it in a similar but more accurate behavior than old code.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 13 +++++--------
 fs/btrfs/volumes.c |  6 +++++-
 fs/btrfs/volumes.h |  4 ++++
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d64299f..7cd94e7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3400,8 +3400,6 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
-	int errors_send = 0;
-	int errors_wait = 0;
 	int ret;
 
 	/* send down all the barriers */
@@ -3410,7 +3408,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_send++;
+			dev->err_send = 1;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3418,7 +3416,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 		ret = write_dev_flush(dev, 0);
 		if (ret)
-			errors_send++;
+			dev->err_send = 1;
 	}
 
 	/* wait for all the barriers */
@@ -3426,7 +3424,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_wait++;
+			dev->err_wait = 1;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3434,10 +3432,9 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
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
index f1ef215..88266fa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6945,8 +6945,12 @@ int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags)
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
index fe758df..cd02556 100644
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
2.5.2

