Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50622 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaGGSiy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 14:38:54 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s67IcrwA010570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 18:38:53 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s67IcqWp016290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 18:38:53 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s67IcqCc011641
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 18:38:52 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: code optimize use btrfs_get_bdev_and_sb() at btrfs_scan_one_device
Date: Tue,  8 Jul 2014 02:38:37 +0800
Message-Id: <1404758317-7000-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(for review comments pls).

btrfs_scan_one_device() needs SB, instead of doing it from scratch could
use btrfs_get_bdev_and_sb()

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/volumes.c | 51 ++++++---------------------------------------------
 1 file changed, 6 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c166355..94e6131 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1053,14 +1053,11 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 {
 	struct btrfs_super_block *disk_super;
 	struct block_device *bdev;
-	struct page *page;
-	void *p;
 	int ret = -EINVAL;
 	u64 devid;
 	u64 transid;
 	u64 total_devices;
-	u64 bytenr;
-	pgoff_t index;
+	struct buffer_head *bh;
 
 	/*
 	 * we would like to check all the supers, but that would make
@@ -1068,44 +1065,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	 * So, we need to add a special mount option to scan for
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
-	bytenr = btrfs_sb_offset(0);
 	mutex_lock(&uuid_mutex);
 
-	bdev = blkdev_get_by_path(path, flags, holder);
-
-	if (IS_ERR(bdev)) {
-		ret = PTR_ERR(bdev);
+	ret = btrfs_get_bdev_and_sb(path, flags, holder, 0, &bdev, &bh);
+	if (ret)
 		goto error;
-	}
-
-	/* make sure our super fits in the device */
-	if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
-		goto error_bdev_put;
-
-	/* make sure our super fits in the page */
-	if (sizeof(*disk_super) > PAGE_CACHE_SIZE)
-		goto error_bdev_put;
-
-	/* make sure our super doesn't straddle pages on disk */
-	index = bytenr >> PAGE_CACHE_SHIFT;
-	if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
-		goto error_bdev_put;
-
-	/* pull in the page with our super */
-	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
-				   index, GFP_NOFS);
-
-	if (IS_ERR_OR_NULL(page))
-		goto error_bdev_put;
-
-	p = kmap(page);
-
-	/* align our pointer to the offset of the super block */
-	disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
-
-	if (btrfs_super_bytenr(disk_super) != bytenr ||
-	    btrfs_super_magic(disk_super) != BTRFS_MAGIC)
-		goto error_unmap;
+	disk_super = (struct btrfs_super_block *) bh->b_data;
 
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
@@ -1125,13 +1090,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
 	}
 
-
-error_unmap:
-	kunmap(page);
-	page_cache_release(page);
-
-error_bdev_put:
+	brelse(bh);
 	blkdev_put(bdev, flags);
+
 error:
 	mutex_unlock(&uuid_mutex);
 	return ret;
-- 
2.0.0.257.g75cc6c6

