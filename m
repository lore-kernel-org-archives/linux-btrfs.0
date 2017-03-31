Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32468 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933026AbdCaL2J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 07:28:09 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/4 V2] btrfs: cleanup barrier_all_devices() unify dev error count
Date: Fri, 31 Mar 2017 19:33:10 +0800
Message-Id: <20170331113310.462-1-anand.jain@oracle.com>
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
 V2: As the write_dev_flush with wait=0 is always successful,
 from the previous patch, ret is now removed.

 fs/btrfs/disk-io.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 42bcf98794ec..f8f534a32c2f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3543,19 +3543,15 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
-	int errors_send = 0;
-	int errors_wait = 0;
-	int ret;
+	int dropouts = 0;
 
 	/* send down all the barriers */
 	head = &info->fs_devices->devices;
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
 
@@ -3567,18 +3563,16 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (dev->missing)
 			continue;
 		if (!dev->bdev) {
-			errors_wait++;
+			dropouts++;
 			continue;
 		}
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = write_dev_flush(dev, 1);
-		if (ret)
-			errors_wait++;
+		if (write_dev_flush(dev, 1))
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

