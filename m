Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47121 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3BOWKw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 17:10:52 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 712D99A0687
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2013 15:10:51 -0700 (MST)
Date: Fri, 15 Feb 2013 17:10:48 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] btrfs: access superblock via pagecache in scan_one_device
Message-ID: <20130215221048.GE28851@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Linus, this is the patch I mentioned earlier.  Once this passes testing
I'll send this in a real pull request, but I wanted to close the loop on
the other email thread.

I think this should either be in an rc or sent to stable.  This btrfs
bug isn't new and if I've missed something stupid here it could mean
people won't be able to mount multi-device btrfs.

In other words, I wouldn't ask for a new rc just for this, but if you're
making a new rc I'd love to put this in.

-chris

commit 6f60cbd3ae442cb35861bb522f388db123d42ec1
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Feb 15 11:31:02 2013 -0700

    btrfs: access superblock via pagecache in scan_one_device
    
    btrfs_scan_one_device is calling set_blocksize() which can race
    with a concurrent process making dirty page cache pages.  It can end up
    dropping dirty page cache pages on the floor, which isn't very nice when
    someone is just running btrfs dev scan to find filesystems on the
    box.
    
    Now that udev is registering btrfs devices as it discovers them, we can
    actually end up racing with our own mkfs program too.  When this
    happens, we drop some of the important blocks written by mkfs.
    
    This commit changes scan_one_device to read the super out of the page
    cache instead of trying to use bread.  This way we don't have to care
    about the blocksize of the device.
    
    This also drops the invalidate_bdev() call.  It wasn't very polite to
    invalidate during the scan either.  mkfs is putting the super into the
    page cache, there's no reason to invalidate at this point.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5cbb7f4..5349e17 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -792,26 +792,77 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	return ret;
 }
 
+/*
+ * Look for a btrfs signature on a device. This may be called out of the mount path
+ * and we are not allowed to call set_blocksize during the scan. The superblock
+ * is read via pagecache
+ */
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret)
 {
 	struct btrfs_super_block *disk_super;
 	struct block_device *bdev;
-	struct buffer_head *bh;
-	int ret;
+	struct page *page;
+	void *p;
+	int ret = -EINVAL;
 	u64 devid;
 	u64 transid;
 	u64 total_devices;
+	u64 bytenr;
+	pgoff_t index;
 
+	/*
+	 * we would like to check all the supers, but that would make
+	 * a btrfs mount succeed after a mkfs from a different FS.
+	 * So, we need to add a special mount option to scan for
+	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
+	 */
+	bytenr = btrfs_sb_offset(0);
 	flags |= FMODE_EXCL;
 	mutex_lock(&uuid_mutex);
-	ret = btrfs_get_bdev_and_sb(path, flags, holder, 0, &bdev, &bh);
-	if (ret)
+
+	bdev = blkdev_get_by_path(path, flags, holder);
+
+	if (IS_ERR(bdev)) {
+		ret = PTR_ERR(bdev);
+		printk(KERN_INFO "btrfs: open %s failed\n", path);
 		goto error;
-	disk_super = (struct btrfs_super_block *)bh->b_data;
+	}
+
+	/* make sure our super fits in the device */
+	if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
+		goto error_bdev_put;
+
+	/* make sure our super fits in the page */
+	if (sizeof(*disk_super) > PAGE_CACHE_SIZE)
+		goto error_bdev_put;
+
+	/* make sure our super doesn't straddle pages on disk */
+	index = bytenr >> PAGE_CACHE_SHIFT;
+	if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
+		goto error_bdev_put;
+
+	/* pull in the page with our super */
+	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
+				   index, GFP_NOFS);
+
+	if (IS_ERR_OR_NULL(page))
+		goto error_bdev_put;
+
+	p = kmap(page);
+
+	/* align our pointer to the offset of the super block */
+	disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
+
+	if (btrfs_super_bytenr(disk_super) != bytenr ||
+	    strncmp((char *)(&disk_super->magic), BTRFS_MAGIC,
+		    sizeof(disk_super->magic)))
+		goto error_unmap;
+
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
+
 	if (disk_super->label[0]) {
 		if (disk_super->label[BTRFS_LABEL_SIZE - 1])
 			disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';
@@ -819,12 +870,19 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	} else {
 		printk(KERN_INFO "device fsid %pU ", disk_super->fsid);
 	}
+
 	printk(KERN_CONT "devid %llu transid %llu %s\n",
 	       (unsigned long long)devid, (unsigned long long)transid, path);
+
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 	if (!ret && fs_devices_ret)
 		(*fs_devices_ret)->total_devices = total_devices;
-	brelse(bh);
+
+error_unmap:
+	kunmap(page);
+	page_cache_release(page);
+
+error_bdev_put:
 	blkdev_put(bdev, flags);
 error:
 	mutex_unlock(&uuid_mutex);
