From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: allow subvol deletion by owner
Date: Tue,  3 Aug 2010 12:48:20 -0700
Message-ID: <1280864900-21067-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Allow users to delete the snapshots/subvols they own.  Instead of
CAP_SYS_ADMIN, require that

 - the user has write and exec permission on the parent directory
 - security_inode_rmdir() doesn't object
 - the user has write and exec permission on the subvol directory
 - the user owns the subvol directory
 - the directory and subvol append flags are not set

This is a bit more strict than the requirements for 'rm -f subvol/*',
which is allowed with just 'wx' on non-owned non-sticky dirs.  It is less
strict than 'rmdir subvol', which has additional requirements if the parent
directory is sticky.  It is less strict than 'rm -rf subvol', which would
require scanning the entire subvol to ensure all content is deletable.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..b31283a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1227,9 +1227,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	int ret;
 	int err = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args))
 		return PTR_ERR(vol_args);
@@ -1264,6 +1261,28 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		goto out_dput;
 	}
 
+	/*
+	 * Allow subvol deletion if we own the subvol and we would
+	 * (approximately) be allowed to rmdir it.  Strictly speaking,
+	 * we could possibly delete everything with fewer permissions,
+	 * or might require more permissions to remove all files
+	 * contained by the subvol, but we aren't trying to mimic
+	 * directory semantics perfectly.
+	 */
+	err = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (err)
+		goto out_dput;
+	err = security_inode_rmdir(dir, dentry);
+	if (err)
+		goto out_dput;
+	err = inode_permission(inode, MAY_WRITE | MAY_EXEC);
+	if (err)
+		goto out_dput;
+	err = -EPERM;
+	if (inode->i_uid != current_fsuid() || IS_APPEND(dir) ||
+	    IS_APPEND(inode))
+		goto out_dput;
+
 	dest = BTRFS_I(inode)->root;
 
 	mutex_lock(&inode->i_mutex);
-- 
1.7.0

