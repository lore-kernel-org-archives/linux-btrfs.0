Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39896 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbdDDKfN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 06:35:13 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: use q which is already obtained from bdev_get_queue
Date: Tue,  4 Apr 2017 18:40:19 +0800
Message-Id: <20170404104019.9270-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have already assigned q from bdev_get_queue() so use it.
And rearrange the code for better view.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1563ae03079b..4de5b2d549bd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1008,14 +1008,13 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		q = bdev_get_queue(bdev);
 		if (blk_queue_discard(q))
 			device->can_discard = 1;
+		if (!blk_queue_nonrot(q))
+			fs_devices->rotating = 1;
 
 		device->bdev = bdev;
 		device->in_fs_metadata = 0;
 		device->mode = flags;
 
-		if (!blk_queue_nonrot(bdev_get_queue(bdev)))
-			fs_devices->rotating = 1;
-
 		fs_devices->open_devices++;
 		if (device->writeable &&
 		    device->devid != BTRFS_DEV_REPLACE_DEVID) {
@@ -2417,7 +2416,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	fs_info->free_chunk_space += device->total_bytes;
 	spin_unlock(&fs_info->free_chunk_lock);
 
-	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
+	if (!blk_queue_nonrot(q))
 		fs_info->fs_devices->rotating = 1;
 
 	tmp = btrfs_super_total_bytes(fs_info->super_copy);
-- 
2.10.0

