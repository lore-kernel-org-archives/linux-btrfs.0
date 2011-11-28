From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: check if the to-be-added device is writable
Date: Mon, 28 Nov 2011 16:43:46 +0800
Message-ID: <4ED349C2.1030705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we call ioctl(BTRFS_IOC_ADD_DEV) directly, we'll succeed in adding
a readonly device to a btrfs filesystem, and btrfs will write to
that device, emitting kernel errors:

[ 3109.833692] lost page write due to I/O error on loop2
[ 3109.833720] lost page write due to I/O error on loop2
...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c37433d..0a8c8f8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1611,7 +1611,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if ((sb->s_flags & MS_RDONLY) && !root->fs_info->fs_devices->seeding)
 		return -EINVAL;
 
-	bdev = blkdev_get_by_path(device_path, FMODE_EXCL,
+	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
 				  root->fs_info->bdev_holder);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
-- 1.7.3.1 
