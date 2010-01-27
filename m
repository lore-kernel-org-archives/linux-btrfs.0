From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check return value of open_bdev_exclusive properly
Date: Tue, 26 Jan 2010 21:09:00 -0500
Message-ID: <20100127020859.GB11767@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hit this problem while testing RAID1 failure stuff.  open_bdev_exclusive returns
ERR_PTR(), not NULL.  So change the return value properly.  This is important if
you accidently specify a device that doesn't exist when trying to add a new
device to an array, you will panic the box dereferencing bdev.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/volumes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 68fe767..605ea5b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1434,8 +1434,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		return -EINVAL;
 
 	bdev = open_bdev_exclusive(device_path, 0, root->fs_info->bdev_holder);
-	if (!bdev)
-		return -EIO;
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
 
 	if (root->fs_info->fs_devices->seeding) {
 		seeding_dev = 1;
-- 
1.5.4.3

