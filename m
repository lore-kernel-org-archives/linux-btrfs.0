From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: fix a bug when opening seed devices
Date: Thu, 13 Oct 2011 00:20:43 +0300
Message-ID: <1318454443-24685-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Initialize fs_info->bdev_holder a bit earlier to be able to pass a
correct holder id to blkdev_get() when opening seed devices with O_EXCL.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 15634d4..d965b85 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -833,6 +833,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 
 		s->s_flags = flags | MS_NOSEC;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
+		btrfs_sb(s)->fs_info->bdev_holder = fs_type;
 		error = btrfs_fill_super(s, fs_devices, data,
 					 flags & MS_SILENT ? 1 : 0);
 		if (error) {
@@ -840,7 +841,6 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 			goto error_free_subvol_name;
 		}
 
-		btrfs_sb(s)->fs_info->bdev_holder = fs_type;
 		s->s_flags |= MS_ACTIVE;
 	}
 
-- 
1.7.5.4

