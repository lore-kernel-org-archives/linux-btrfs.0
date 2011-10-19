From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: close all bdevs on mount failure
Date: Thu, 20 Oct 2011 00:06:20 +0300
Message-ID: <1319058380-25181-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix a bug introduced by 20b45077.  We have to return EINVAL on mount
failure, but doing that too early in the sequence leaves all of the
devices opened exclusively.  This also fixes an issue where under some
scenarios only a second mount -o degraded <devices> command would
succeed.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2a4cc7..c8cf706 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -597,10 +597,8 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		set_blocksize(bdev, 4096);
 
 		bh = btrfs_read_dev_super(bdev);
-		if (!bh) {
-			ret = -EINVAL;
+		if (!bh)
 			goto error_close;
-		}
 
 		disk_super = (struct btrfs_super_block *)bh->b_data;
 		devid = btrfs_stack_device_id(&disk_super->dev_item);
@@ -655,7 +653,7 @@ error:
 		continue;
 	}
 	if (fs_devices->open_devices == 0) {
-		ret = -EIO;
+		ret = -EINVAL;
 		goto out;
 	}
 	fs_devices->seeding = seeding;
-- 
1.7.5.4

