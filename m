Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38872 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752390AbdFMJ0U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:26:20 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/3 v2.1] btrfs: write_dev_flush does not return ENOMEM anymore
Date: Tue, 13 Jun 2017 17:32:29 +0800
Message-Id: <1497346349-1194-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
References: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As commit
 9035b5dbc576 btrfs: btrfs_io_bio_alloc never fails, skip error handling

removed the -ENOMEM return from write_dev_flush()/send-part so no need to
check for the -ENOMEM during send.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2.1: Part of commit log got missed out during send. fix it.
v2: . Add the removal of submit_flush_error in check_barrier_error()
    from 2/2 before to 1/3 here, as its appropriate to be here.
    . Did not split the write and wait part here in this patch.

 fs/btrfs/disk-io.c | 37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f2ffe2c6afb..9fbcfa9ccab7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3505,12 +3505,6 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 
 	if (wait) {
 		bio = device->flush_bio;
-		if (!bio)
-			/*
-			 * This means the alloc has failed with ENOMEM, however
-			 * here we return 0, as its not a device error.
-			 */
-			return 0;
 
 		wait_for_completion(&device->flush_wait);
 
@@ -3548,25 +3542,16 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 
 static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
 {
-	int submit_flush_error = 0;
 	int dev_flush_error = 0;
 	struct btrfs_device *dev;
-	int tolerance;
 
 	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
-		if (!dev->bdev) {
-			submit_flush_error++;
-			dev_flush_error++;
-			continue;
-		}
-		if (dev->last_flush_error == -ENOMEM)
-			submit_flush_error++;
-		if (dev->last_flush_error && dev->last_flush_error != -ENOMEM)
+		if (!dev->bdev || dev->last_flush_error)
 			dev_flush_error++;
 	}
 
-	tolerance = fsdevs->fs_info->num_tolerated_disk_barrier_failures;
-	if (submit_flush_error > tolerance || dev_flush_error > tolerance)
+	if (dev_flush_error >
+		fsdevs->fs_info->num_tolerated_disk_barrier_failures)
 		return -EIO;
 
 	return 0;
@@ -3596,10 +3581,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = write_dev_flush(dev, 0);
-		if (ret)
-			errors_send++;
-		dev->last_flush_error = ret;
+		write_dev_flush(dev, 0);
+		dev->last_flush_error = 0;
 	}
 
 	/* wait for all the barriers */
@@ -3620,16 +3603,6 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		}
 	}
 
-	/*
-	 * Try hard in case of flush. Lets say, in RAID1 we have
-	 * the following situation
-	 *  dev1: EIO dev2: ENOMEM
-	 * this is not a fatal error as we hope to recover from
-	 * ENOMEM in the next attempt to flush.
-	 * But the following is considered as fatal
-	 *  dev1: ENOMEM dev2: ENOMEM
-	 *  dev1: bdev == NULL dev2: ENOMEM
-	 */
 	if (errors_send || errors_wait) {
 		/*
 		 * At some point we need the status of all disks
-- 
2.7.0

