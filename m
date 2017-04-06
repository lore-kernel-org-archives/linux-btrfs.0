Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49843 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbdDFDRt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Apr 2017 23:17:49 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v4 3/7] btrfs: cleanup barrier_all_devices() to check dev stat flush error
Date: Thu,  6 Apr 2017 11:22:49 +0800
Message-Id: <20170406032253.14631-4-anand.jain@oracle.com>
In-Reply-To: <20170406032253.14631-1-anand.jain@oracle.com>
References: <20170406032253.14631-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The objective of this patch is to cleanup barrier_all_devices()
so that the error checking is in a separate loop independent of
of the loop which submits and waits on the device flush requests.

By doing this it helps to further develop patches which would tune
the error-actions as needed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Address Qu review comments viz..
     Add meaningful names, like cp_list (for checkpoint_list head).
     (And actually it does not need a new struct type just to hold
      the head pointer, list node is already named as device_checkpoint).
     Check return value of add_device_checkpoint()
     Check if the device is already added at add_device_checkpoint()
     Rename fini_devices_checkpoint() to rel_devices_checkpoint()
v3: (resent with the correct version (that is 3 not 2) of the patch).
   Dropped for idea of using the BTRFS_DEV_STAT_FLUSH_ERRS, though
   its the right way, but it needs a better infracture to handle that.
   Now the flush error return is saved and checked instead of the
   checkpoint of the dev_stat method earlier.
v4: no change

 fs/btrfs/disk-io.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 420753d37e1a..3c476b118440 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3538,6 +3538,23 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 	return 0;
 }
 
+static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
+{
+	int dropouts = 0;
+	struct btrfs_device *dev;
+
+	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
+		if (!dev->bdev || dev->last_flush_error)
+			dropouts++;
+	}
+
+	if (dropouts >
+		fsdevs->fs_info->num_tolerated_disk_barrier_failures)
+		return -EIO;
+
+	return 0;
+}
+
 /*
  * send an empty flush down to each device in parallel,
  * then wait for them
@@ -3575,8 +3592,19 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (write_dev_flush(dev, 1))
 			dropouts++;
 	}
-	if (dropouts > info->num_tolerated_disk_barrier_failures)
-		return -EIO;
+
+	/*
+	 * A slight optimization, we check for dropouts here which avoids
+	 * a dev list loop when disks are healthy.
+	 */
+	if (dropouts) {
+		/*
+		 * As we need holistic view of the failed disks, so
+		 * error checking is pushed to a separate loop.
+		 */
+		return check_barrier_error(info->fs_devices);
+	}
+
 	return 0;
 }
 
-- 
2.10.0

