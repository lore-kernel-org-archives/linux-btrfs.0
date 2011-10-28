From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: don't try to touch sb->s_bdev
Date: Fri, 28 Oct 2011 19:43:12 +0300
Message-ID: <1319820192-28139-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs uses anon bdevs, this is not needed.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2a4cc7..afd6a1e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1376,8 +1376,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 	next_device = list_entry(root->fs_info->fs_devices->devices.next,
 				 struct btrfs_device, dev_list);
-	if (device->bdev == root->fs_info->sb->s_bdev)
-		root->fs_info->sb->s_bdev = next_device->bdev;
 	if (device->bdev == root->fs_info->fs_devices->latest_bdev)
 		root->fs_info->fs_devices->latest_bdev = next_device->bdev;
 
-- 
1.7.6.3

