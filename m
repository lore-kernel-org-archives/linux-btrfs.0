Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27032 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbbDMOgI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:36:08 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t3DEa72J011020
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:36:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t3DEa7Y9017899
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:36:07 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t3DEa7IP032668
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:36:07 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] Btrfs: SB read failure should return EIO for __bread failure
Date: Mon, 13 Apr 2015 22:49:07 +0800
Message-Id: <1428936547-2177-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This will return EIO when __bread() fails to read SB,
instead of EINVAL.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 18 +++++++++++++++---
 fs/btrfs/volumes.c |  8 ++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 53c83c9..f47c643 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2410,8 +2410,8 @@ int open_ctree(struct super_block *sb,
 	 * Read super block and check the signature bytes only
 	 */
 	bh = btrfs_read_dev_super(fs_devices->latest_bdev);
-	if (!bh) {
-		err = -EINVAL;
+	if (IS_ERR(bh)) {
+		err = PTR_ERR(bh);
 		goto fail_alloc;
 	}
 
@@ -3093,6 +3093,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	int i;
 	u64 transid = 0;
 	u64 bytenr;
+	int ret = -EINVAL;
 
 	/* we would like to check all the supers, but that would make
 	 * a btrfs mount succeed after a mkfs from a different FS.
@@ -3106,13 +3107,20 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 			break;
 		bh = __bread(bdev, bytenr / 4096,
 					BTRFS_SUPER_INFO_SIZE);
-		if (!bh)
+		/*
+		 * If we fail to read from the underlaying drivers, as of now
+		 * the best option we have is to mark it EIO.
+		 */
+		if (!bh) {
+			ret = -EIO;
 			continue;
+		}
 
 		super = (struct btrfs_super_block *)bh->b_data;
 		if (btrfs_super_bytenr(super) != bytenr ||
 		    btrfs_super_magic(super) != BTRFS_MAGIC) {
 			brelse(bh);
+			ret = -EINVAL;
 			continue;
 		}
 
@@ -3124,6 +3132,10 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 			brelse(bh);
 		}
 	}
+
+	if (!latest)
+		return ERR_PTR(ret);
+
 	return latest;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0009fde..5536281 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -212,8 +212,8 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
 	}
 	invalidate_bdev(*bdev);
 	*bh = btrfs_read_dev_super(*bdev);
-	if (!*bh) {
-		ret = -EINVAL;
+	if (IS_ERR(*bh)) {
+		ret = PTR_ERR(*bh);
 		blkdev_put(*bdev, flags);
 		goto error;
 	}
@@ -6770,8 +6770,8 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
 	struct btrfs_super_block *disk_super;
 
 	bh = btrfs_read_dev_super(device->bdev);
-	if (!bh)
-		return -EINVAL;
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 	disk_super = (struct btrfs_super_block *)bh->b_data;
 
 	memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-- 
2.0.0.153.g79dcccc

