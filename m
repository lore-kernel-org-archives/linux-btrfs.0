Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60451 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932644AbaICNex (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:53 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYm5S006741
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:48 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] Btrfs: restructure btrfs_scan_one_device
Date: Wed, 3 Sep 2014 21:36:31 +0800
Message-ID: <1409751393-5403-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some code in btrfs_scan_one_device will be re-used by the other function later,
so restructure btrfs_scan_one_device and pick up those code to make a new
function.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 57 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 740a4f9..bcb19d5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -885,24 +885,18 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	return ret;
 }
 
-/*
- * Look for a btrfs signature on a device. This may be called out of the mount path
- * and we are not allowed to call set_blocksize during the scan. The superblock
- * is read via pagecache
- */
-int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
-			  struct btrfs_fs_devices **fs_devices_ret)
+static int __scan_device(struct block_device *bdev, const char *path,
+			 struct btrfs_fs_devices **fs_devices_ret)
 {
 	struct btrfs_super_block *disk_super;
-	struct block_device *bdev;
 	struct page *page;
 	void *p;
-	int ret = -EINVAL;
 	u64 devid;
 	u64 transid;
 	u64 total_devices;
 	u64 bytenr;
 	pgoff_t index;
+	int ret;
 
 	/*
 	 * we would like to check all the supers, but that would make
@@ -911,38 +905,30 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
 	bytenr = btrfs_sb_offset(0);
-	flags |= FMODE_EXCL;
-	mutex_lock(&uuid_mutex);
-
-	bdev = blkdev_get_by_path(path, flags, holder);
-
-	if (IS_ERR(bdev)) {
-		ret = PTR_ERR(bdev);
-		goto error;
-	}
 
 	/* make sure our super fits in the device */
 	if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
-		goto error_bdev_put;
+		return -EINVAL;
 
 	/* make sure our super fits in the page */
 	if (sizeof(*disk_super) > PAGE_CACHE_SIZE)
-		goto error_bdev_put;
+		return -EINVAL;
 
 	/* make sure our super doesn't straddle pages on disk */
 	index = bytenr >> PAGE_CACHE_SHIFT;
 	if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
-		goto error_bdev_put;
+		return -EINVAL;
 
 	/* pull in the page with our super */
 	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
 				   index, GFP_NOFS);
 
 	if (IS_ERR_OR_NULL(page))
-		goto error_bdev_put;
+		return -ENOMEM;
 
-	p = kmap(page);
+	ret = -EINVAL;
 
+	p = kmap(page);
 	/* align our pointer to the offset of the super block */
 	disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
 
@@ -974,7 +960,30 @@ error_unmap:
 	kunmap(page);
 	page_cache_release(page);
 
-error_bdev_put:
+	return ret;
+}
+
+/*
+ * Look for a btrfs signature on a device. This may be called out of the mount path
+ * and we are not allowed to call set_blocksize during the scan. The superblock
+ * is read via pagecache
+ */
+int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
+			  struct btrfs_fs_devices **fs_devices_ret)
+{
+	struct block_device *bdev;
+	int ret;
+
+	flags |= FMODE_EXCL;
+
+	mutex_lock(&uuid_mutex);
+	bdev = blkdev_get_by_path(path, flags, holder);
+	if (IS_ERR(bdev)) {
+		ret = PTR_ERR(bdev);
+		goto error;
+	}
+
+	ret = __scan_device(bdev, path, fs_devices_ret);
 	blkdev_put(bdev, flags);
 error:
 	mutex_unlock(&uuid_mutex);
-- 
1.9.3

