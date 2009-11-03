From: Rui Miguel Silva <rmfrfs@gmail.com>
Subject: [PATCH]] Btrfs: fix destroy snapshot to get the right parent dentry
Date: Tue, 3 Nov 2009 16:10:56 +0000
Message-ID: <20091103161054.GA13781@gentoo-vm.octal.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In snapshot destroy the dentry used for parent was the snapshot dentry
itself. Remove d_invalidate since always return EBUSY, making possible
to remove a snapshot using the btrfsctl -D option.

Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
---
 fs/btrfs/ioctl.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cdbb054..fe6ac9a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -741,7 +741,7 @@ out:
 static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 					     void __user *arg)
 {
-	struct dentry *parent = fdentry(file);
+	struct dentry *parent = file->f_path.dentry->d_parent;
 	struct dentry *dentry;
 	struct inode *dir = parent->d_inode;
 	struct inode *inode;
@@ -793,9 +793,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	dest = BTRFS_I(inode)->root;
 
 	mutex_lock(&inode->i_mutex);
-	err = d_invalidate(dentry);
-	if (err)
-		goto out_unlock;
 
 	down_write(&root->fs_info->subvol_sem);
 
@@ -827,7 +824,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	inode->i_flags |= S_DEAD;
 out_up_write:
 	up_write(&root->fs_info->subvol_sem);
-out_unlock:
+
 	mutex_unlock(&inode->i_mutex);
 	if (!err) {
 		shrink_dcache_sb(root->fs_info->sb);
-- 
1.6.5.1

