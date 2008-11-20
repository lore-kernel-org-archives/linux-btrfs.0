From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: pass void __user * to btrfs_ioctl_clone_range
Date: Thu, 20 Nov 2008 19:48:42 +0100
Message-ID: <20081120184842.GB21069@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Cleans the code up a little and also avoids a sparse warning due to the
incorrect cast in the current version of the code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/fs/btrfs/ioctl.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/ioctl.c	2008-11-20 19:44:35.000000000 +0100
+++ btrfs-unstable/fs/btrfs/ioctl.c	2008-11-20 19:46:16.000000000 +0100
@@ -1034,11 +1034,11 @@ out_fput:
 	return ret;
 }
 
-static long btrfs_ioctl_clone_range(struct file *file, unsigned long argptr)
+static long btrfs_ioctl_clone_range(struct file *file, void __user *argp)
 {
 	struct btrfs_ioctl_clone_range_args args;
 
-	if (copy_from_user(&args, (void *)argptr, sizeof(args)))
+	if (copy_from_user(&args, argp, sizeof(args)))
 		return -EFAULT;
 	return btrfs_ioctl_clone(file, args.src_fd, args.src_offset,
 				 args.src_length, args.dest_offset);
@@ -1136,7 +1136,7 @@ long btrfs_ioctl(struct file *file, unsi
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
-		return btrfs_ioctl_clone_range(file, arg);
+		return btrfs_ioctl_clone_range(file, argp);
 	case BTRFS_IOC_TRANS_START:
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
