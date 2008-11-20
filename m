From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: clean up btrfs_ioctl a little bit
Date: Thu, 20 Nov 2008 19:47:36 +0100
Message-ID: <20081120184736.GA21069@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Provide a void __user *argp pointer so that we can avoid duplicating
the cast for various sub-command calls.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/fs/btrfs/ioctl.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/ioctl.c	2008-11-20 19:43:00.000000000 +0100
+++ btrfs-unstable/fs/btrfs/ioctl.c	2008-11-20 19:46:51.000000000 +0100
@@ -1116,20 +1116,21 @@ long btrfs_ioctl(struct file *file, unsi
 		cmd, unsigned long arg)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
+	void __user *argp = (void __user *)arg;
 
 	switch (cmd) {
 	case BTRFS_IOC_SNAP_CREATE:
-		return btrfs_ioctl_snap_create(file, (void __user *)arg, 0);
+		return btrfs_ioctl_snap_create(file, argp, 0);
 	case BTRFS_IOC_SUBVOL_CREATE:
-		return btrfs_ioctl_snap_create(file, (void __user *)arg, 1);
+		return btrfs_ioctl_snap_create(file, argp, 1);
 	case BTRFS_IOC_DEFRAG:
 		return btrfs_ioctl_defrag(file);
 	case BTRFS_IOC_RESIZE:
-		return btrfs_ioctl_resize(root, (void __user *)arg);
+		return btrfs_ioctl_resize(root, argp);
 	case BTRFS_IOC_ADD_DEV:
-		return btrfs_ioctl_add_dev(root, (void __user *)arg);
+		return btrfs_ioctl_add_dev(root, argp);
 	case BTRFS_IOC_RM_DEV:
-		return btrfs_ioctl_rm_dev(root, (void __user *)arg);
+		return btrfs_ioctl_rm_dev(root, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_balance(root->fs_info->dev_root);
 	case BTRFS_IOC_CLONE:
