From: Amit Gud <amitgud@gmail.com>
Subject: [PATCH 1/3] Add ioctl to set per file 'compress' flag
Date: Fri, 12 Jun 2009 18:49:45 -0700
Message-ID: <4A3305B9.30700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "gud@ksu.edu" <gud@ksu.edu>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


An ioctl is needed to set compress flag (i.e. clear
BTRFS_INODE_NOCOMPRESS flag) on per file basis. This patch adds that.

Introduces a generic function to be used by subsequent patches.


Signed-off-by: Amit Gud <gud@ksu.edu>

Index: newformat2/fs/btrfs/ioctl.c
===================================================================
--- newformat2.orig/fs/btrfs/ioctl.c
+++ newformat2/fs/btrfs/ioctl.c
@@ -1240,6 +1240,54 @@ out:
 	return ret;
 }

+/* Ioctl function to set or clear a flag on the file. */
+static long btrfs_ioctl_inode_flag(struct file *file,
+				u32 flag, int set)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct btrfs_inode *ip = BTRFS_I(inode);
+	struct btrfs_root *root = ip->root;
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	if (!is_owner_or_cap(inode))
+		return -EACCES;
+
+	mutex_lock(&inode->i_mutex);
+
+	/* Bail out if already set / cleared. */
+	if (set) {
+		if (ip->flags & flag)
+			goto out_unlock;
+	} else {
+		if (!(ip->flags & flag))
+			goto out_unlock;
+	}
+
+	ret = mnt_want_write(file->f_path.mnt);
+	if (ret)
+		goto out_unlock;
+
+	if (set)
+		ip->flags |= flag;
+	else
+		ip->flags &= ~flag;
+
+	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(!trans);
+
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);
+
+	inode->i_ctime = CURRENT_TIME;
+	btrfs_end_transaction(trans, root);
+
+	mnt_drop_write(file->f_path.mnt);
+ out_unlock:
+	mutex_unlock(&inode->i_mutex);
+	return 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -1278,6 +1326,8 @@ long btrfs_ioctl(struct file *file, unsi
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
+	case BTRFS_IOC_COMPRESS:
+		return btrfs_ioctl_inode_flag(file, BTRFS_INODE_NOCOMPRESS, 0);
 	}

 	return -ENOTTY;
Index: newformat2/fs/btrfs/ioctl.h
===================================================================
--- newformat2.orig/fs/btrfs/ioctl.h
+++ newformat2/fs/btrfs/ioctl.h
@@ -65,5 +65,7 @@ struct btrfs_ioctl_clone_range_args {

 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_COMPRESS _IOW(BTRFS_IOCTL_MAGIC, 15, \
+			   struct btrfs_ioctl_vol_args)

 #endif


-- 
May the source be with you.
http://www.cis.ksu.edu/~gud
