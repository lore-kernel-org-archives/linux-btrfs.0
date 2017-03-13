Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49444 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbdCMHiF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:38:05 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH 3/4] btrfs: cleanup barrier_all_devices() unify dev error count
Date: Mon, 13 Mar 2017 15:42:13 +0800
Message-Id: <20170313074214.24123-4-anand.jain@oracle.com>
In-Reply-To: <20170313074214.24123-1-anand.jain@oracle.com>
References: <20170313074214.24123-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now when counting number of error devices we don't need to count
them separately once during send and wait, as because device error
counted during send is more of static check.

Also kindly note that as of now there is no code which would set
dev->bdev = NULL unless device is missing. However I still kept
bdev == NULL counted towards error device in view of future
enhancements. And as the device_list_mutex is held when
barrier_all_devices() is called, I don't expect a new bdev to null
in between send and wait.

Now in this process I also rename error_wait to dropouts.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ee3e601da511..5719e036048b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3574,8 +3574,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
-	int errors_send = 0;
-	int errors_wait = 0;
+	int dropouts = 0;
 	int ret;
 
 	/* send down all the barriers */
@@ -3583,10 +3582,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 	list_for_each_entry_rcu(dev, head, dev_list) {
 		if (dev->missing)
 			continue;
-		if (!dev->bdev) {
-			errors_send++;
+		if (!dev->bdev)
 			continue;
-		}
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
@@ -3600,7 +3597,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_wait++;
+			dropouts++;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
@@ -3608,10 +3605,9 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 		ret = write_dev_flush(dev, 1);
 		if (ret)
-			errors_wait++;
+			dropouts++;
 	}
-	if (errors_send > info->num_tolerated_disk_barrier_failures ||
-	    errors_wait > info->num_tolerated_disk_barrier_failures)
+	if (dropouts > info->num_tolerated_disk_barrier_failures)
 		return -EIO;
 	return 0;
 }
-- 
2.10.0

