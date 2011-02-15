From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: set FMODE_EXCL in btrfs_device->mode
Date: Tue, 15 Feb 2011 20:12:57 +0200
Message-ID: <20110215181257.GA9110@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This fixes a bug introduced in d4d77629, where the device added online
(and therefore initialized via btrfs_init_new_device()) would be left
with the positive bdev->bd_holders after unmount.  Since d4d77629 we no
longer OR FMODE_EXCL explicitly on blkdev_put(), set it in
btrfs_device->mode.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2636a05..a228f63 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1631,7 +1631,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	device->dev_root = root->fs_info->dev_root;
 	device->bdev = bdev;
 	device->in_fs_metadata = 1;
-	device->mode = 0;
+	device->mode = FMODE_EXCL;
 	set_blocksize(device->bdev, 4096);
 
 	if (seeding_dev) {
-- 
1.7.2.3

