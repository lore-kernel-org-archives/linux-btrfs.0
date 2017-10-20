Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53324 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751791AbdJTPLI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 11:11:08 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, mathieu.desnoyers@efficios.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Fix memory barriers usage with device stats counters
Date: Fri, 20 Oct 2017 18:10:57 +0300
Message-Id: <1508512259-16867-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit addc3fa74e5b ("Btrfs: Fix the problem that the dirty flag of dev stats is cleared")
reworked the way device stats changes are tracked. A new atomic dev_stats_ccnt
counter was introduced which is incremented every time any of the device stats
counters are changed. This serves as a flag whether there are any pending stats
changes. However, this patch only partially implemented the correct memory
barriers necessary:

- It only ordered the stores to the counters but not the reads e.g. btrfs_run_dev_stats
- It completely omitted any comments documenting the intended design and how
the memory barriers pair with each-other

This patch provides the necessary comments as well as adds a missing smp_rmb in
btrfs_run_dev_stats. Furthermore since dev_stats_cnt is only a snapshot at best
there was no point in reading the counter twice - once in btrfs_dev_stats_dirty
and then again when assigning stats_cnt. Just collapse both reads into 1.

Fixes: addc3fa74e5b ("Btrfs: Fix the problem that the dirty flag of dev stats is cleared")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 16 ++++++++++++++--
 fs/btrfs/volumes.h | 12 ++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4de498817e8a..b6ab8c53477f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7084,10 +7084,22 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
-		if (!device->dev_stats_valid || !btrfs_dev_stats_dirty(device))
+		stats_cnt = atomic_read(&device->dev_stats_ccnt);
+		if (!device->dev_stats_valid || stats_cnt == 0)
 			continue;
 
-		stats_cnt = atomic_read(&device->dev_stats_ccnt);
+
+		/*
+		 * There is a LOAD-LOAD control dependency between the value of
+		 * dev_stats_ccnt and updating the on-disk values which requires
+		 * reading the in-memory counters. Such control dependencies
+		 * require explicit read memory barriers.
+		 *
+		 * This memory barriers pairs with smp_mb__before_atomic in
+		 * btrfs_dev_stat_inc/btrfs_dev_stat_read_and_reset/btrfs_dev_stat_set
+		 */
+		smp_rmb();
+
 		ret = update_dev_stat_item(trans, fs_info, device);
 		if (!ret)
 			atomic_sub(stats_cnt, &device->dev_stats_ccnt);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6108fdfec67f..c5dd48eb7b3d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -498,6 +498,12 @@ static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
 {
 	atomic_inc(dev->dev_stat_values + index);
+	/*
+	 * This memory barrier orders stores updating statistics before stores
+	 * updating dev_stats_ccnt.
+	 *
+	 * It pairs with smp_rmb() in btrfs_run_dev_stats().
+	 */
 	smp_mb__before_atomic();
 	atomic_inc(&dev->dev_stats_ccnt);
 }
@@ -523,6 +529,12 @@ static inline void btrfs_dev_stat_set(struct btrfs_device *dev,
 				      int index, unsigned long val)
 {
 	atomic_set(dev->dev_stat_values + index, val);
+	/*
+	 * This memory barrier orders stores updating statistics before stores
+	 * updating dev_stats_ccnt.
+	 *
+	 * It pairs with smp_rmb() in btrfs_run_dev_stats().
+	 */
 	smp_mb__before_atomic();
 	atomic_inc(&dev->dev_stats_ccnt);
 }
-- 
2.7.4

