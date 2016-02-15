Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbcBOReE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 12:34:04 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 01/15] btrfs: create a helper function to read the disk super
Date: Mon, 15 Feb 2016 18:33:59 +0100
Message-Id: <7870f31d036002d5880b65ff8cc745a01619af1b.1455556900.git.dsterba@suse.com>
In-Reply-To: <cover.1455556900.git.dsterba@suse.com>
References: <cover.1455556900.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

A part of code from btrfs_scan_one_device() is moved to a new function
btrfs_read_disk_super(), so that former function looks cleaner. (In this
process it also moves the code which ensures null terminating label). So
this creates easy opportunity to merge various duplicate codes on read
disk super. Earlier attempt to merge duplicate codes highlighted that
there were some issues for which there are duplicate codes (to read disk
super), however it was not clear what was the issue. So until we figure
that out, its better to keep them in a separate functions.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
[ use GFP_KERNEL ]
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 87 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 366b335946fa..fa119ea8c74b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -987,6 +987,56 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
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
+				   index, GFP_KERNEL);
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
@@ -998,13 +1048,11 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
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
@@ -1017,41 +1065,14 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	mutex_lock(&uuid_mutex);
 
 	bdev = blkdev_get_by_path(path, flags, holder);
-
 	if (IS_ERR(bdev)) {
 		ret = PTR_ERR(bdev);
 		goto error;
 	}
 
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
+	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
 		goto error_bdev_put;
 
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
@@ -1059,8 +1080,6 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 	if (ret > 0) {
 		if (disk_super->label[0]) {
-			if (disk_super->label[BTRFS_LABEL_SIZE - 1])
-				disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';
 			printk(KERN_INFO "BTRFS: device label %s ", disk_super->label);
 		} else {
 			printk(KERN_INFO "BTRFS: device fsid %pU ", disk_super->fsid);
@@ -1072,9 +1091,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	if (!ret && fs_devices_ret)
 		(*fs_devices_ret)->total_devices = total_devices;
 
-error_unmap:
-	kunmap(page);
-	page_cache_release(page);
+	btrfs_release_disk_super(page);
 
 error_bdev_put:
 	blkdev_put(bdev, flags);
-- 
2.7.1

