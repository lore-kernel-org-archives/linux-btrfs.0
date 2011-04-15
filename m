From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/3] fs: remove FS_COW_FL
Date: Fri, 15 Apr 2011 11:02:49 +0800
Message-ID: <4DA7B559.8060800@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

FS_COW_FL and FS_NOCOW_FL were newly introduced to control per file
COW in btrfs, but FS_NOCOW_FL is sufficient.

The fact is we don't have corresponding BTRFS_INODE_COW flag.

COW is default, and FS_NOCOW_FL can be used to switch off COW for
a single file.

If we mount btrfs with nodatacow, a newly created file will be set with
the FS_NOCOW_FL flag. So to turn on COW for it, we can just clear the
FS_NOCOW_FL flag.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c   |   15 ++++++---------
 include/linux/fs.h |    1 -
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f580a3a..3240dd9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -144,16 +144,13 @@ static int check_flags(unsigned int flags)
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
 		      FS_SYNC_FL | FS_DIRSYNC_FL | \
-		      FS_NOCOMP_FL | FS_COMPR_FL | \
-		      FS_NOCOW_FL | FS_COW_FL))
+		      FS_NOCOMP_FL | FS_COMPR_FL |
+		      FS_NOCOW_FL))
 		return -EOPNOTSUPP;
 
 	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))
 		return -EINVAL;
 
-	if ((flags & FS_NOCOW_FL) && (flags & FS_COW_FL))
-		return -EINVAL;
-
 	return 0;
 }
 
@@ -218,6 +215,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		ip->flags |= BTRFS_INODE_DIRSYNC;
 	else
 		ip->flags &= ~BTRFS_INODE_DIRSYNC;
+	if (flags & FS_NOCOW_FL)
+		ip->flags |= BTRFS_INODE_NODATACOW;
+	else
+		ip->flags &= ~BTRFS_INODE_NODATACOW;
 
 	/*
 	 * The COMPRESS flag can only be changed by users, while the NOCOMPRESS
@@ -231,10 +232,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		ip->flags |= BTRFS_INODE_COMPRESS;
 		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
 	}
-	if (flags & FS_NOCOW_FL)
-		ip->flags |= BTRFS_INODE_NODATACOW;
-	else if (flags & FS_COW_FL)
-		ip->flags &= ~BTRFS_INODE_NODATACOW;
 
 	trans = btrfs_join_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index de9dd81..56a4141 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -365,7 +365,6 @@ struct inodes_stat_t {
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
 #define FS_NOCOW_FL			0x00800000 /* Do not cow file */
-#define FS_COW_FL			0x02000000 /* Cow file */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
 
 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
-- 
1.7.3.1
