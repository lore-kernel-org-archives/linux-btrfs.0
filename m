Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbeICOFl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 10:05:41 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 86B8FAF5D
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Sep 2018 09:46:18 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Make btrfs_find_device_by_path return struct btrfs_device
Date: Mon,  3 Sep 2018 12:46:12 +0300
Message-Id: <20180903094614.2667-2-nborisov@suse.com>
In-Reply-To: <20180903094614.2667-1-nborisov@suse.com>
References: <20180903094614.2667-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently this function returns an error code as well as uses one of
its arguments as a return value for struct btrfs_device. Change the
function so that it returns btrfs_device directly and use the usual
"encode error in pointer" mechanics if something goes wrong. No
functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index da86706123ff..715ea45c6c28 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2096,9 +2096,9 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 	call_rcu(&tgtdev->rcu, free_device_rcu);
 }
 
-static int btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
-				     const char *device_path,
-				     struct btrfs_device **device)
+static struct btrfs_device *
+btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
+			  const char *device_path)
 {
 	int ret = 0;
 	struct btrfs_super_block *disk_super;
@@ -2106,21 +2106,21 @@ static int btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
 	u8 *dev_uuid;
 	struct block_device *bdev;
 	struct buffer_head *bh;
+	struct btrfs_device *device;
 
-	*device = NULL;
 	ret = btrfs_get_bdev_and_sb(device_path, FMODE_READ,
 				    fs_info->bdev_holder, 0, &bdev, &bh);
 	if (ret)
-		return ret;
+		return ERR_PTR(ret);
 	disk_super = (struct btrfs_super_block *)bh->b_data;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	dev_uuid = disk_super->dev_item.uuid;
-	*device = btrfs_find_device(fs_info, devid, dev_uuid, disk_super->fsid);
+	device = btrfs_find_device(fs_info, devid, dev_uuid, disk_super->fsid);
 	brelse(bh);
-	if (!*device)
-		ret = -ENOENT;
+	if (!device)
+		device = ERR_PTR(-ENOENT);
 	blkdev_put(bdev, FMODE_READ);
-	return ret;
+	return device;
 }
 
 int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
@@ -2143,11 +2143,13 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
 
 		if (!*device)
 			return BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
-
-		return 0;
 	} else {
-		return btrfs_find_device_by_path(fs_info, device_path, device);
+		*device = btrfs_find_device_by_path(fs_info, device_path);
+		if (IS_ERR(*device))
+			return PTR_ERR(*device);
 	}
+
+	return 0;
 }
 
 /*
-- 
2.17.1
