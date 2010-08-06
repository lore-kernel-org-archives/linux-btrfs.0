From: Ulrich Hecht <uli@suse.de>
Subject: [PATCH v3] Btrfs: compressed file size ioctl
Date: Fri,  6 Aug 2010 14:21:44 +0200
Message-ID: <1281097304-27628-1-git-send-email-uli@suse.de>
Cc: uli@suse.de
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Returns a file's size on disk. Based on a patch by Chris Ball, improved
following suggestions by Chris Mason and Miao Xie.

Minimal example:

 #include <sys/ioctl.h>
 #include <fcntl.h>
 #include <stdint.h>
 #include <stdio.h>
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_IOC_COMPR_SIZE   _IOR(BTRFS_IOCTL_MAGIC, 21, uint64_t)
int main(int argc, char **argv)
{
  uint64_t size = -1;
  int d = open(argv[1], O_RDONLY);
  ioctl(d, BTRFS_IOC_COMPR_SIZE, &size);
  printf("%zd\n", size);
  return 0;
}

Signed-off-by: Ulrich Hecht <uli@suse.de>
---
 fs/btrfs/ioctl.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    1 +
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..603da9e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1750,6 +1750,46 @@ out_drop_write:
 	return ret;
 }
 
+static long btrfs_ioctl_compsize(struct file *file, void __user *argp)
+{
+	/* This ioctl returns the compressed size of an inode on disk
+	 * by counting the on-disk space used by all of its extents.
+	 */
+	struct inode *inode = fdentry(file)->d_inode;
+	struct extent_map *em;
+	u64 len = inode->i_size;
+	u64 compressed_size = 0;
+	u64 offset = 0;
+
+	if (S_ISDIR(inode->i_mode))
+		return -EISDIR;
+	
+	lock_extent(&BTRFS_I(inode)->io_tree, 0, len, GFP_NOFS);
+	mutex_lock(&inode->i_mutex);
+
+	/* do any pending delalloc/csum calc on inode, one way or
+	   another, and lock file content */
+	btrfs_wait_ordered_range(inode, 0, (u64)-1);
+
+	while (offset < len) {
+		em = btrfs_get_extent(inode, NULL, 0, offset, 1, 0);
+		BUG_ON(IS_ERR(em) || !em);
+		if (em->block_len != (u64)-1)
+			compressed_size += em->block_len;
+		offset += em->len;
+		free_extent_map(em);
+	}
+
+	mutex_unlock(&inode->i_mutex);
+	unlock_extent(&BTRFS_I(inode)->io_tree, 0, len, GFP_NOFS);
+
+	/* We've succeeded in going through all extents; set the final size. */
+	if (copy_to_user(argp, &compressed_size, sizeof(compressed_size)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static long btrfs_ioctl_clone_range(struct file *file, void __user *argp)
 {
 	struct btrfs_ioctl_clone_range_args args;
@@ -2034,6 +2074,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
+	case BTRFS_IOC_COMPR_SIZE:
+		return btrfs_ioctl_compsize(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 424694a..a01ef1e 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -178,4 +178,5 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_COMPR_SIZE _IOR(BTRFS_IOCTL_MAGIC, 21, u64)
 #endif
-- 
1.7.1

