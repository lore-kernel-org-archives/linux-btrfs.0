Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4420 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758707AbaGXDfj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:39 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3ZZFK017397
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:35:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/10] Btrfs: make the device lock and its protected data in the same cacheline
Date: Thu, 24 Jul 2014 11:37:10 +0800
Message-ID: <1406173035-29478-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The lock in btrfs_device structure was far away from its protected data, it would
make CPU load the cache line twice when we accessed them, move them together.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.h | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2aaa00c..6fcc8ea 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -36,30 +36,31 @@ struct btrfs_device {
 	struct list_head dev_list;
 	struct list_head dev_alloc_list;
 	struct btrfs_fs_devices *fs_devices;
+
 	struct btrfs_root *dev_root;
 
+	struct rcu_string *name;
+
+	u64 generation;
+
+	spinlock_t io_lock ____cacheline_aligned;
+	int running_pending;
 	/* regular prio bios */
 	struct btrfs_pending_bios pending_bios;
 	/* WRITE_SYNC bios */
 	struct btrfs_pending_bios pending_sync_bios;
 
-	u64 generation;
-	int running_pending;
+	struct block_device *bdev;
+
+	/* the mode sent to blkdev_get */
+	fmode_t mode;
+
 	int writeable;
 	int in_fs_metadata;
 	int missing;
 	int can_discard;
 	int is_tgtdev_for_dev_replace;
 
-	spinlock_t io_lock;
-	/* the mode sent to blkdev_get */
-	fmode_t mode;
-
-	struct block_device *bdev;
-
-
-	struct rcu_string *name;
-
 	/* the internal btrfs device id */
 	u64 devid;
 
@@ -83,7 +84,6 @@ struct btrfs_device {
 	/* minimal io size for this device */
 	u32 sector_size;
 
-
 	/* physical drive uuid (or lvm uuid) */
 	u8 uuid[BTRFS_UUID_SIZE];
 
@@ -107,7 +107,6 @@ struct btrfs_device {
 	struct radix_tree_root reada_zones;
 	struct radix_tree_root reada_extents;
 
-
 	/* disk I/O failure stats. For detailed description refer to
 	 * enum btrfs_dev_stat_values in ioctl.h */
 	int dev_stats_valid;
-- 
1.9.3

