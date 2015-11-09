Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51001 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbbKIK5k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:40 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvdtJ014118
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvcO9004561
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:38 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvcvU018178
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/15] btrfs: Allow barrier_all_devices to do per-chunk device check
Date: Mon,  9 Nov 2015 18:56:18 +0800
Message-Id: <1447066589-3835-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
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
index d54cdcc..958c2a6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3433,8 +3433,6 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
-	int errors_send = 0;
-	int errors_wait = 0;
 	int ret;
 
 	/* send down all the barriers */
@@ -3443,7 +3441,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_send++;
+			dev->err_send = 1;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3451,7 +3449,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 		ret = write_dev_flush(dev, 0);
 		if (ret)
-			errors_send++;
+			dev->err_send = 1;
 	}
 
 	/* wait for all the barriers */
@@ -3459,7 +3457,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_wait++;
+			dev->err_wait = 1;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3467,10 +3465,9 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
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
index cfbdf9a..8acf69b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6844,8 +6844,12 @@ int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags)
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
index c875be9..d9a4579 100644
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
2.4.1

