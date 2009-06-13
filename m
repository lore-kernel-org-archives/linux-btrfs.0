From: Amit Gud <amitgud@gmail.com>
Subject: [PATCH 2/3] Add ioctl to set per file 'nodatacow' flag
Date: Fri, 12 Jun 2009 18:51:29 -0700
Message-ID: <4A330621.2010000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	"gud@ksu.edu" <gud@ksu.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Add an ioctl to set 'nodatacow' flag on per file basis.


Signed-off-by: Amit Gud <gud@ksu.edu>

Index: newformat2/fs/btrfs/ioctl.h
===================================================================
--- newformat2.orig/fs/btrfs/ioctl.h
+++ newformat2/fs/btrfs/ioctl.h
@@ -67,5 +67,7 @@ struct btrfs_ioctl_clone_range_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_COMPRESS _IOW(BTRFS_IOCTL_MAGIC, 15, \
 			   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_NODATACOW _IOW(BTRFS_IOCTL_MAGIC, 16, \
+			   struct btrfs_ioctl_vol_args)

 #endif
Index: newformat2/fs/btrfs/ioctl.c
===================================================================
--- newformat2.orig/fs/btrfs/ioctl.c
+++ newformat2/fs/btrfs/ioctl.c
@@ -1328,6 +1328,8 @@ long btrfs_ioctl(struct file *file, unsi
 		return 0;
 	case BTRFS_IOC_COMPRESS:
 		return btrfs_ioctl_inode_flag(file, BTRFS_INODE_NOCOMPRESS, 0);
+	case BTRFS_IOC_NODATACOW:
+		return btrfs_ioctl_inode_flag(file, BTRFS_INODE_NODATACOW, 1);
 	}

 	return -ENOTTY;

-- 
May the source be with you.
http://www.cis.ksu.edu/~gud
