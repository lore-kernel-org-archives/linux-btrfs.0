From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH] btrfs: change resize ioctl to take device path instead of id
Date: Sun, 11 Dec 2011 22:12:09 -0500
Message-ID: <1323659529-2632-1-git-send-email-psusi@cfl.rr.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The resize ioctl took an optional argument that was a string
representation of the devid which you wish to resize.  For
the sake of consistency with the other ioctls that take a
device argument, I converted this to take a device path instead
of a devid number, and look up the number from the path.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
---
 fs/btrfs/ioctl.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 72d4616..b4a0d46 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1211,13 +1211,32 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	sizestr = vol_args->name;
 	devstr = strchr(sizestr, ':');
 	if (devstr) {
-		char *end;
-		sizestr = devstr + 1;
-		*devstr = '\0';
-		devstr = vol_args->name;
-		devid = simple_strtoull(devstr, &end, 10);
-		printk(KERN_INFO "btrfs: resizing devid %llu\n",
-		       (unsigned long long)devid);
+		struct block_device *bdev;
+		struct btrfs_super_block *disk_super;
+		struct buffer_head *bh;
+
+		*devstr = 0;
+		devstr++;
+		printk(KERN_INFO "btrfs: resizing device %s\n",
+			devstr);
+		bdev = blkdev_get_by_path(devstr, FMODE_READ | FMODE_EXCL,
+					  root->fs_info->bdev_holder);
+		if (IS_ERR(bdev)) {
+			ret = PTR_ERR(bdev);
+			goto out_unlock;
+		}
+
+		set_blocksize(bdev, 4096);
+		bh = btrfs_read_dev_super(bdev);
+		if (!bh) {
+			ret = -EINVAL;
+			blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
+			goto out_unlock;
+		}
+		disk_super = (struct btrfs_super_block *)bh->b_data;
+		devid = btrfs_stack_device_id(&disk_super->dev_item);
+		brelse(bh);
+		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 	}
 	device = btrfs_find_device(root, devid, NULL, NULL);
 	if (!device) {
-- 
1.7.5.4

