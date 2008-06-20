From: Mingming <cmm@us.ibm.com>
Subject: [PATCH] COW and checksumming ioctls
Date: Thu, 19 Jun 2008 17:26:48 -0700
Message-ID: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

COW and checksumming is enabled by default, and could be disable with
mount option.  These new ioctls below let a user application turn on/off
copy-on-write and checksumming on a per file basis.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

diff -r 79b81fd6dd78 ioctl.c
--- a/ioctl.c	Thu Jun 12 14:46:17 2008 -0400
+++ b/ioctl.c	Thu Jun 19 15:59:02 2008 -0700
@@ -471,6 +471,55 @@ static int btrfs_ioctl_defrag(struct fil
 
 	return 0;
 }
+
+static int btrfs_ioctl_disable_datacow(struct file *file)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+
+	if ((inode->i_mode & S_IFMT) == S_IFREG) {
+		mutex_lock(&inode->i_mutex);
+		btrfs_set_flag(inode, NODATACOW);
+		mutex_unlock(&inode->i_mutex);
+	}
+
+	return 0;
+}
+
+static int btrfs_ioctl_enable_datacow(struct file *file)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+
+	if ((inode->i_mode & S_IFMT) == S_IFREG) {
+		mutex_lock(&inode->i_mutex);
+		btrfs_clear_flag(inode, NODATACOW);
+		mutex_unlock(&inode->i_mutex);
+	}
+
+	return 0;
+}
+
+static int btrfs_ioctl_disable_datasum(struct file *file)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+
+	mutex_lock(&inode->i_mutex);
+	btrfs_set_flag(inode, NODATASUM);
+	mutex_unlock(&inode->i_mutex);
+
+	return 0;
+}
+
+static int btrfs_ioctl_enable_datasum(struct file *file)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+
+	mutex_lock(&inode->i_mutex);
+	btrfs_clear_flag(inode, NODATASUM);
+	mutex_unlock(&inode->i_mutex);
+
+	return 0;
+}
+
 
 long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 {
@@ -775,6 +824,14 @@ long btrfs_ioctl(struct file *file, unsi
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
 		return btrfs_ioctl_trans_end(file);
+	case BTRFS_IOC_NODATACOW:
+		return btrfs_ioctl_disable_datacow(file);
+	case BTRFS_IOC_DATACOW:
+		return btrfs_ioctl_enable_datacow(file);
+	case BTRFS_IOC_NODATASUM:
+		return btrfs_ioctl_disable_datasum(file);
+	case BTRFS_IOC_DATASUM:
+		return btrfs_ioctl_enable_datasum(file);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
diff -r 79b81fd6dd78 ioctl.h
--- a/ioctl.h	Thu Jun 12 14:46:17 2008 -0400
+++ b/ioctl.h	Thu Jun 19 15:32:40 2008 -0700
@@ -51,5 +51,8 @@ struct btrfs_ioctl_vol_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)
-
+#define BTRFS_IOC_NODATACOW _IO(BTRFS_IOCTL_MAGIC, 13)
+#define BTRFS_IOC_DATACOW _IO(BTRFS_IOCTL_MAGIC, 14)
+#define BTRFS_IOC_NODATASUM _IO(BTRFS_IOCTL_MAGIC, 15)
+#define BTRFS_IOC_DATASUM _IO(BTRFS_IOCTL_MAGIC, 16)
 #endif


