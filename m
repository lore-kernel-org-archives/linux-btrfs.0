Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39438 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932892AbdCaLbx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 07:31:53 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/4 V2] btrfs: cleanup barrier_all_devices() to check dev stat flush error
Date: Fri, 31 Mar 2017 19:36:52 +0800
Message-Id: <20170331113652.727-1-anand.jain@oracle.com>
In-Reply-To: <20170313074214.24123-5-anand.jain@oracle.com>
References: <20170313074214.24123-5-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The objective of this patch is to cleanup barrier_all_devices()
so that the error checking is in a separate loop independent of
of the loop which submits and waits on the device flush requests.

By doing this it helps to further develop patches which would tune
the error-actions as needed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 V2: Now the flush error return is saved and checked instead of the
 checkpoint of the dev_stat method earlier.

 fs/btrfs/disk-io.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f8f534a32c2f..b6d047250ce2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3535,6 +3535,23 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
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
@@ -3572,8 +3589,19 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
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

