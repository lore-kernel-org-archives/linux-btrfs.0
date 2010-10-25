From: Sage Weil <sage@newdream.net>
Subject: [PATCH 6/6] Btrfs: allow subvol deletion by owner
Date: Mon, 25 Oct 2010 12:07:42 -0700
Message-ID: <1288033662-21464-7-git-send-email-sage@newdream.net>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
 <1288033662-21464-2-git-send-email-sage@newdream.net>
 <1288033662-21464-3-git-send-email-sage@newdream.net>
 <1288033662-21464-4-git-send-email-sage@newdream.net>
 <1288033662-21464-5-git-send-email-sage@newdream.net>
 <1288033662-21464-6-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288033662-21464-6-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Allow users to delete the snapshots/subvols they own.  When CAP_SYS_ADMIN
is not present, require that

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
 fs/btrfs/ioctl.c    |   27 ++++++++++++++++++++++++---
 security/security.c |    1 +
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9cbda86..90d2871 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1288,9 +1288,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	int ret;
 	int err = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args))
 		return PTR_ERR(vol_args);
@@ -1325,6 +1322,30 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
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
+	if (!capable(CAP_SYS_ADMIN)) {
+		err = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+		if (err)
+			goto out_dput;
+		err = security_inode_rmdir(dir, dentry);
+		if (err)
+			goto out_dput;
+		err = inode_permission(inode, MAY_WRITE | MAY_EXEC);
+		if (err)
+			goto out_dput;
+		err = -EPERM;
+		if (inode->i_uid != current_fsuid() || IS_APPEND(dir) ||
+		    IS_APPEND(inode))
+			goto out_dput;
+	}
+
 	dest = BTRFS_I(inode)->root;
 
 	mutex_lock(&inode->i_mutex);
diff --git a/security/security.c b/security/security.c
index c53949f..1c980ee 100644
--- a/security/security.c
+++ b/security/security.c
@@ -490,6 +490,7 @@ int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
 		return 0;
 	return security_ops->inode_rmdir(dir, dentry);
 }
+EXPORT_SYMBOL_GPL(security_inode_rmdir);
 
 int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
-- 
1.6.6.1

