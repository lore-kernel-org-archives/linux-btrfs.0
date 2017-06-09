Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44378 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdFIGqY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 02:46:24 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] btrfs: flush error also accounts for its send error
Date: Fri,  9 Jun 2017 14:52:29 +0800
Message-Id: <20170609065229.8188-3-anand.jain@oracle.com>
In-Reply-To: <20170609065229.8188-1-anand.jain@oracle.com>
References: <20170609065229.8188-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So remove the static check of send error

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d8151839bb3d..682c494dbc7f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3534,14 +3534,11 @@ static int wait_dev_flush(struct btrfs_device *device)
 
 static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
 {
-	int submit_flush_error = 0;
 	int dev_flush_error = 0;
 	struct btrfs_device *dev;
-	int tolerance;
 
 	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
 		if (!dev->bdev) {
-			submit_flush_error++;
 			dev_flush_error++;
 			continue;
 		}
@@ -3549,8 +3546,8 @@ static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
 			dev_flush_error++;
 	}
 
-	tolerance = fsdevs->fs_info->num_tolerated_disk_barrier_failures;
-	if (submit_flush_error > tolerance || dev_flush_error > tolerance)
+	if (dev_flush_error >
+		fsdevs->fs_info->num_tolerated_disk_barrier_failures)
 		return -EIO;
 
 	return 0;
@@ -3564,7 +3561,6 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
-	int errors_send = 0;
 	int errors_wait = 0;
 	int ret;
 
@@ -3573,10 +3569,9 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 	list_for_each_entry_rcu(dev, head, dev_list) {
 		if (dev->missing)
 			continue;
-		if (!dev->bdev) {
-			errors_send++;
+		if (!dev->bdev)
 			continue;
-		}
+
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
@@ -3602,7 +3597,11 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		}
 	}
 
-	if (errors_send || errors_wait) {
+	/*
+	 * By checking errors_wait here it avoids traverse through
+	 * the device loop for normal healthy case
+	 */
+	if (errors_wait) {
 		/*
 		 * At some point we need the status of all disks
 		 * to arrive at the volume status. So error checking
-- 
2.8.3

