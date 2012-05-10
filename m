From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/2] Btrfs: fix wrong error returned by adding a device
Date: Thu, 10 May 2012 18:10:38 +0800
Message-ID: <1336644639-21595-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Reproduce:
$ mkfs.btrfs /dev/sdb7
$ mount /dev/sdb7 /mnt/btrfs -o ro
$ btrfs dev add /dev/sdb8 /mnt/btrfs
ERROR: error adding the device '/dev/sdb8' - Invalid argument

Since we mount with readonly options, and /dev/sdb7 is not a seeding one,
a readonly notification is preferred.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1411b99..48a06d1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1633,7 +1633,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	int ret = 0;
 
 	if ((sb->s_flags & MS_RDONLY) && !root->fs_info->fs_devices->seeding)
-		return -EINVAL;
+		return -EROFS;
 
 	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
 				  root->fs_info->bdev_holder);
-- 
1.6.5.2

