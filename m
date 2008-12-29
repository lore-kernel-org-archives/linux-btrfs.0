From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix a memory leak in btrfs_get_sb
Date: Mon, 29 Dec 2008 11:45:05 +0800
Message-ID: <495847C1.1010509@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


subvol_name should be freed if error occurs.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/btrfs/super.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d0e8dce..a53f690 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -429,7 +429,7 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 	error = btrfs_parse_early_options(data, mode, fs_type,
 					  &subvol_name, &fs_devices);
 	if (error)
-		goto error;
+		return error;
 
 	error = btrfs_scan_one_device(dev_name, mode, fs_type, &fs_devices);
 	if (error)
@@ -468,7 +468,7 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 		if (error) {
 			up_write(&s->s_umount);
 			deactivate_super(s);
-			goto error;
+			goto error_free_subvol_name;
 		}
 
 		btrfs_sb(s)->fs_info->bdev_holder = fs_type;
@@ -485,14 +485,14 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 			up_write(&s->s_umount);
 			deactivate_super(s);
 			error = PTR_ERR(root);
-			goto error;
+			goto error_free_subvol_name;
 		}
 		if (!root->d_inode) {
 			dput(root);
 			up_write(&s->s_umount);
 			deactivate_super(s);
 			error = -ENXIO;
-			goto error;
+			goto error_free_subvol_name;
 		}
 	}
 
@@ -508,7 +508,6 @@ error_close_devices:
 	btrfs_close_devices(fs_devices);
 error_free_subvol_name:
 	kfree(subvol_name);
-error:
 	return error;
 }
 
-- 
1.6.0.6


