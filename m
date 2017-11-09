Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16705 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdKIPpe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 10:45:34 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA9FjXIR006066
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA9FjWho024363
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:33 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA9FjW6D030889
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()
Date: Thu,  9 Nov 2017 23:45:26 +0800
Message-Id: <20171109154526.23181-5-anand.jain@oracle.com>
In-Reply-To: <20171109154526.23181-1-anand.jain@oracle.com>
References: <20171109154526.23181-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes, create btrfs_open_one_device() from
__btrfs_open_devices(). This is a preparatory work to add dynamic
device scan.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 126 +++++++++++++++++++++++++++++------------------------
 1 file changed, 69 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0857b580014d..d24e966ee29f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -601,6 +601,73 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 	}
 }
 
+static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
+			struct btrfs_device *device, fmode_t flags,
+			void *holder)
+{
+	struct request_queue *q;
+	struct block_device *bdev;
+	struct buffer_head *bh;
+	struct btrfs_super_block *disk_super;
+	u64 devid;
+	int ret;
+
+	if (device->bdev)
+		return -EINVAL;
+	if (!device->name)
+		return -EINVAL;
+
+	ret = btrfs_get_bdev_and_sb(device->name->str, flags, holder, 1,
+				    &bdev, &bh);
+	if (ret)
+		return ret;
+
+	disk_super = (struct btrfs_super_block *)bh->b_data;
+	devid = btrfs_stack_device_id(&disk_super->dev_item);
+	if (devid != device->devid)
+		goto error_brelse;
+
+	if (memcmp(device->uuid, disk_super->dev_item.uuid,
+		   BTRFS_UUID_SIZE))
+		goto error_brelse;
+
+	device->generation = btrfs_super_generation(disk_super);
+
+	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
+		device->writeable = 0;
+		fs_devices->seeding = 1;
+	} else {
+		device->writeable = !bdev_read_only(bdev);
+	}
+
+	q = bdev_get_queue(bdev);
+	if (blk_queue_discard(q))
+		device->can_discard = 1;
+	if (!blk_queue_nonrot(q))
+		fs_devices->rotating = 1;
+
+	device->bdev = bdev;
+	device->in_fs_metadata = 0;
+	device->mode = flags;
+
+	fs_devices->open_devices++;
+	if (device->writeable &&
+	    device->devid != BTRFS_DEV_REPLACE_DEVID) {
+		fs_devices->rw_devices++;
+		list_add(&device->dev_alloc_list,
+			 &fs_devices->alloc_list);
+	}
+	brelse(bh);
+
+	return 0;
+
+error_brelse:
+	brelse(bh);
+	blkdev_put(bdev, flags);
+
+	return -EINVAL;
+}
+
 /*
  * Add new device to list of registered devices
  *
@@ -978,69 +1045,14 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	flags |= FMODE_EXCL;
 
 	list_for_each_entry(device, head, dev_list) {
-		struct request_queue *q;
-		struct block_device *bdev;
-		struct buffer_head *bh;
-		struct btrfs_super_block *disk_super;
-		u64 devid;
-
-		if (device->bdev)
-			continue;
-		if (!device->name)
-			continue;
-
 		/* Just open everything we can; ignore failures here */
-		if (btrfs_get_bdev_and_sb(device->name->str, flags, holder, 1,
-					    &bdev, &bh))
+		ret = btrfs_open_one_device(fs_devices, device, flags, holder);
+		if (ret)
 			continue;
 
-		disk_super = (struct btrfs_super_block *)bh->b_data;
-		devid = btrfs_stack_device_id(&disk_super->dev_item);
-		if (devid != device->devid)
-			goto error_brelse;
-
-		if (memcmp(device->uuid, disk_super->dev_item.uuid,
-			   BTRFS_UUID_SIZE))
-			goto error_brelse;
-
-		device->generation = btrfs_super_generation(disk_super);
-
-		if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
-			device->writeable = 0;
-			fs_devices->seeding = 1;
-		} else {
-			device->writeable = !bdev_read_only(bdev);
-		}
-
-		q = bdev_get_queue(bdev);
-		if (blk_queue_discard(q))
-			device->can_discard = 1;
-		if (!blk_queue_nonrot(q))
-			fs_devices->rotating = 1;
-
-		device->bdev = bdev;
-		device->in_fs_metadata = 0;
-		device->mode = flags;
-
-		fs_devices->open_devices++;
-		if (device->writeable &&
-		    device->devid != BTRFS_DEV_REPLACE_DEVID) {
-			fs_devices->rw_devices++;
-			list_add(&device->dev_alloc_list,
-				 &fs_devices->alloc_list);
-		}
-		brelse(bh);
-
 		if (!latest_dev ||
 		    device->generation > latest_dev->generation)
 			latest_dev = device;
-
-		continue;
-
-error_brelse:
-		brelse(bh);
-		blkdev_put(bdev, flags);
-		continue;
 	}
 	if (fs_devices->open_devices == 0) {
 		ret = -EINVAL;
-- 
2.13.1

