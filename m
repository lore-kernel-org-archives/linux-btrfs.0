From: Harshavardhana <harsha@gluster.com>
Subject: [PATCH] fs/btrfs: Avoid possible NULL pointer dereference for fs_devices
Date: Wed,  7 Apr 2010 18:24:04 -0700
Message-ID: <1270689844-8404-1-git-send-email-harsha@gluster.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

loop is never traversed for fs_devices NULL in volumes.c

<snip>
 while (fs_devices) {
 .........
 ....... }
</snip>

Dereferencing happens right after, in this case over NULL pointer. 

Signed-off-by: Harshavardhana <harsha@gluster.com>
---
 fs/btrfs/volumes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b584e9a..e3d2e6b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1261,7 +1261,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 				break;
 			fs_devices = fs_devices->seed;
 		}
-		fs_devices->seed = device->fs_devices->seed;
+                if (fs_devices)
+                        fs_devices->seed = device->fs_devices->seed;
 		device->fs_devices->seed = NULL;
 		__btrfs_close_devices(device->fs_devices);
 		free_fs_devices(device->fs_devices);
-- 
1.6.6.1

