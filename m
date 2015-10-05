Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17019 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbbJEItY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 04:49:24 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t958nNlT018396
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:49:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t958nNJa008815
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:49:23 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t958nNTr009489
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:49:23 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: create a helper function to read the disk super
Date: Mon,  5 Oct 2015 16:48:08 +0800
Message-Id: <1444034890-9353-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A part of code from btrfs_scan_one_device() is moved to a new
function btrfs_read_disk_super(), so that former function looks
cleaner and moves the code to ensure null terminating label to it as well.
Further there is opportunity to merge various duplicate 
code on read disk super. Earlier attempt on this was highlighted
that there was some issues for which there are multiple versions,
however it was not clear what was issue. So until its worked out
we can keep it in a separate function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 87 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1b2e40f..8f1d175 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -941,6 +941,56 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	return ret;
 }
 
+void btrfs_release_disk_super(struct page *page)
+{
+	kunmap(page);
+	page_cache_release(page);
+}
+
+int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
+		struct page **page, struct btrfs_super_block **disk_super)
+{
+	void *p;
+	pgoff_t index;
+
+	/* make sure our super fits in the device */
+	if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
+		return 1;
+
+	/* make sure our super fits in the page */
+	if (sizeof(**disk_super) > PAGE_CACHE_SIZE)
+		return 1;
+
+	/* make sure our super doesn't straddle pages on disk */
+	index = bytenr >> PAGE_CACHE_SHIFT;
+	if ((bytenr + sizeof(**disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
+		return 1;
+
+	/* pull in the page with our super */
+	*page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
+				   index, GFP_NOFS);
+
+	if (IS_ERR_OR_NULL(*page))
+		return 1;
+
+	p = kmap(*page);
+
+	/* align our pointer to the offset of the super block */
+	*disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
+
+	if (btrfs_super_bytenr(*disk_super) != bytenr ||
+	    btrfs_super_magic(*disk_super) != BTRFS_MAGIC) {
+		btrfs_release_disk_super(*page);
+		return 1;
+	}
+
+	if ((*disk_super)->label[0] &&
+		(*disk_super)->label[BTRFS_LABEL_SIZE - 1])
+		(*disk_super)->label[BTRFS_LABEL_SIZE - 1] = '\0';
+
+	return 0;
+}
+
 /*
  * Look for a btrfs signature on a device. This may be called out of the mount path
  * and we are not allowed to call set_blocksize during the scan. The superblock
@@ -952,13 +1002,11 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct btrfs_super_block *disk_super;
 	struct block_device *bdev;
 	struct page *page;
-	void *p;
 	int ret = -EINVAL;
 	u64 devid;
 	u64 transid;
 	u64 total_devices;
 	u64 bytenr;
-	pgoff_t index;
 
 	/*
 	 * we would like to check all the supers, but that would make
@@ -971,41 +1019,14 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	mutex_lock(&uuid_mutex);
 
 	bdev = blkdev_get_by_path(path, flags, holder);
-
 	if (IS_ERR(bdev)) {
 		ret = PTR_ERR(bdev);
 		goto error;
 	}
 
-	/* make sure our super fits in the device */
-	if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
+	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
 		goto error_bdev_put;
 
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
-
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
@@ -1013,8 +1034,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 	if (ret > 0) {
 		if (disk_super->label[0]) {
-			if (disk_super->label[BTRFS_LABEL_SIZE - 1])
-				disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';
 			printk(KERN_INFO "BTRFS: device label %s ", disk_super->label);
 		} else {
 			printk(KERN_INFO "BTRFS: device fsid %pU ", disk_super->fsid);
@@ -1026,9 +1045,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	if (!ret && fs_devices_ret)
 		(*fs_devices_ret)->total_devices = total_devices;
 
-error_unmap:
-	kunmap(page);
-	page_cache_release(page);
+	btrfs_release_disk_super(page);
 
 error_bdev_put:
 	blkdev_put(bdev, flags);
-- 
2.4.1

