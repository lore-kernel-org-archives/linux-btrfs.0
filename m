Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16789 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755478AbaICNeH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:07 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DY1Dw006635
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/18] Btrfs: cleanup unused num_can_discard in fs_devices
Date: Wed, 3 Sep 2014 21:35:30 +0800
Message-ID: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The member variants - num_can_discard - of fs_devices structure
are set, but no one use them to do anything. so remove them.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 16 ++--------------
 fs/btrfs/volumes.h |  1 -
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e9676a4..483fc6d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -720,8 +720,6 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 			fs_devices->rw_devices--;
 		}
 
-		if (device->can_discard)
-			fs_devices->num_can_discard--;
 		if (device->missing)
 			fs_devices->missing_devices--;
 
@@ -828,10 +826,8 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		}
 
 		q = bdev_get_queue(bdev);
-		if (blk_queue_discard(q)) {
+		if (blk_queue_discard(q))
 			device->can_discard = 1;
-			fs_devices->num_can_discard++;
-		}
 
 		device->bdev = bdev;
 		device->in_fs_metadata = 0;
@@ -1835,8 +1831,7 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 		if (!fs_devices->seeding)
 			fs_devices->rw_devices++;
 	}
-	if (srcdev->can_discard)
-		fs_devices->num_can_discard--;
+
 	if (srcdev->bdev) {
 		fs_devices->open_devices--;
 
@@ -1886,8 +1881,6 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 		fs_info->fs_devices->open_devices--;
 	}
 	fs_info->fs_devices->num_devices--;
-	if (tgtdev->can_discard)
-		fs_info->fs_devices->num_can_discard++;
 
 	next_device = list_entry(fs_info->fs_devices->devices.next,
 				 struct btrfs_device, dev_list);
@@ -2008,7 +2001,6 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	fs_devices->num_devices = 0;
 	fs_devices->open_devices = 0;
 	fs_devices->missing_devices = 0;
-	fs_devices->num_can_discard = 0;
 	fs_devices->rotating = 0;
 	fs_devices->seed = seed_devices;
 
@@ -2200,8 +2192,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	root->fs_info->fs_devices->open_devices++;
 	root->fs_info->fs_devices->rw_devices++;
 	root->fs_info->fs_devices->total_devices++;
-	if (device->can_discard)
-		root->fs_info->fs_devices->num_can_discard++;
 	root->fs_info->fs_devices->total_rw_bytes += device->total_bytes;
 
 	spin_lock(&root->fs_info->free_chunk_lock);
@@ -2371,8 +2361,6 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 	list_add(&device->dev_list, &fs_info->fs_devices->devices);
 	fs_info->fs_devices->num_devices++;
 	fs_info->fs_devices->open_devices++;
-	if (device->can_discard)
-		fs_info->fs_devices->num_can_discard++;
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	*device_out = device;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index e894ac6..37f8bff 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -124,7 +124,6 @@ struct btrfs_fs_devices {
 	u64 rw_devices;
 	u64 missing_devices;
 	u64 total_rw_bytes;
-	u64 num_can_discard;
 	u64 total_devices;
 	struct block_device *latest_bdev;
 
-- 
1.9.3

