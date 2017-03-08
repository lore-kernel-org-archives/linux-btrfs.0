Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14184 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752181AbdCHCnS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 21:43:18 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <anand.jain@oracle.com>,
        <kilobyte@angband.pl>, <demfloro@demfloro.ru>
Subject: [PATCH v3 5/7] btrfs: Allow barrier_all_devices to do chunk level device check
Date: Wed, 8 Mar 2017 10:41:22 +0800
Message-ID: <20170308024124.16899-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
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
With these 2 new members, btrfs_check_rw_degradable() can check if the
fs is still OK when the fs is committed to disk.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 658b8fab1d39..549045a3e15f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3570,17 +3570,20 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
-	int errors_send = 0;
-	int errors_wait = 0;
+	struct extra_rw_degrade_errors *errors;
 	int ret;
 
+	errors = alloc_extra_rw_degrade_errors(info->fs_devices->num_devices);
+	if (!errors)
+		return -ENOMEM;
+
 	/* send down all the barriers */
 	head = &info->fs_devices->devices;
 	list_for_each_entry_rcu(dev, head, dev_list) {
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_send++;
+			record_extra_rw_degrade_error(errors, dev->devid);
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3588,7 +3591,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 		ret = write_dev_flush(dev, 0);
 		if (ret)
-			errors_send++;
+			record_extra_rw_degrade_error(errors, dev->devid);
 	}
 
 	/* wait for all the barriers */
@@ -3596,7 +3599,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_wait++;
+			record_extra_rw_degrade_error(errors, dev->devid);
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3604,11 +3607,13 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 		ret = write_dev_flush(dev, 1);
 		if (ret)
-			errors_wait++;
+			record_extra_rw_degrade_error(errors, dev->devid);
 	}
-	if (errors_send > info->num_tolerated_disk_barrier_failures ||
-	    errors_wait > info->num_tolerated_disk_barrier_failures)
+	if (!btrfs_check_rw_degradable(info, errors)) {
+		kfree(errors);
 		return -EIO;
+	}
+	kfree(errors);
 	return 0;
 }
 
-- 
2.12.0



