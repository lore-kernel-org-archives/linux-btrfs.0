Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22657 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932823AbaICNex (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:53 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYnBW006744
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] Btrfs: restructure btrfs_get_bdev_and_sb and pick up some code used later
Date: Wed, 3 Sep 2014 21:36:32 +0800
Message-ID: <1409751393-5403-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some code in btrfs_get_bdev_and_sb will be re-used by the other function later,
so restructure btrfs_get_bdev_and_sb and pick up those code to make a new
function.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 66 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bcb19d5..9d52fd8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -193,42 +193,47 @@ static noinline struct btrfs_fs_devices *find_fsid(u8 *fsid)
 	return NULL;
 }
 
+static int __btrfs_get_sb(struct block_device *bdev, int flush,
+			  struct buffer_head **bh)
+{
+	int ret;
+
+	if (flush)
+		filemap_write_and_wait(bdev->bd_inode->i_mapping);
+
+	ret = set_blocksize(bdev, 4096);
+	if (ret)
+		return ret;
+
+	invalidate_bdev(bdev);
+	*bh = btrfs_read_dev_super(bdev);
+	if (!*bh)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int
-btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
-		      int flush, struct block_device **bdev,
-		      struct buffer_head **bh)
+btrfs_get_bdev_and_sb_by_path(const char *device_path, fmode_t flags,
+			      void *holder, int flush,
+			      struct block_device **bdev,
+			      struct buffer_head **bh)
 {
 	int ret;
 
 	*bdev = blkdev_get_by_path(device_path, flags, holder);
-
 	if (IS_ERR(*bdev)) {
-		ret = PTR_ERR(*bdev);
 		printk(KERN_INFO "BTRFS: open %s failed\n", device_path);
-		goto error;
+		return PTR_ERR(*bdev);
 	}
 
-	if (flush)
-		filemap_write_and_wait((*bdev)->bd_inode->i_mapping);
-	ret = set_blocksize(*bdev, 4096);
+	ret = __btrfs_get_sb(*bdev, flush, bh);
 	if (ret) {
 		blkdev_put(*bdev, flags);
-		goto error;
-	}
-	invalidate_bdev(*bdev);
-	*bh = btrfs_read_dev_super(*bdev);
-	if (!*bh) {
-		ret = -EINVAL;
-		blkdev_put(*bdev, flags);
-		goto error;
+		return ret;
 	}
 
 	return 0;
-
-error:
-	*bdev = NULL;
-	*bh = NULL;
-	return ret;
 }
 
 static void requeue_list(struct btrfs_pending_bios *pending_bios,
@@ -806,8 +811,8 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		/* Just open everything we can; ignore failures here */
-		if (btrfs_get_bdev_and_sb(device->name->str, flags, holder, 1,
-					    &bdev, &bh))
+		if (btrfs_get_bdev_and_sb_by_path(device->name->str, flags,
+						  holder, 1, &bdev, &bh))
 			continue;
 
 		disk_super = (struct btrfs_super_block *)bh->b_data;
@@ -1629,10 +1634,10 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 			goto out;
 		}
 	} else {
-		ret = btrfs_get_bdev_and_sb(device_path,
-					    FMODE_WRITE | FMODE_EXCL,
-					    root->fs_info->bdev_holder, 0,
-					    &bdev, &bh);
+		ret = btrfs_get_bdev_and_sb_by_path(device_path,
+						    FMODE_WRITE | FMODE_EXCL,
+						    root->fs_info->bdev_holder,
+						    0, &bdev, &bh);
 		if (ret)
 			goto out;
 		disk_super = (struct btrfs_super_block *)bh->b_data;
@@ -1906,8 +1911,9 @@ static int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
 	struct buffer_head *bh;
 
 	*device = NULL;
-	ret = btrfs_get_bdev_and_sb(device_path, FMODE_READ,
-				    root->fs_info->bdev_holder, 0, &bdev, &bh);
+	ret = btrfs_get_bdev_and_sb_by_path(device_path, FMODE_READ,
+					    root->fs_info->bdev_holder, 0,
+					    &bdev, &bh);
 	if (ret)
 		return ret;
 	disk_super = (struct btrfs_super_block *)bh->b_data;
-- 
1.9.3

