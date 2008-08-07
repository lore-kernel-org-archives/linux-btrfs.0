From: "Morey Roof" <moreyroof@gmail.com>
Subject: Patch for two new IOCTLs
Date: Thu, 7 Aug 2008 09:52:52 -0600
Message-ID: <91a37e890808070852v2b4b838eifd3d771f38591b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

  This patches add two IOCTLs to set and get labels for a mounted filesystem.

Thanks,

Morey

diff -r b68faa369602 ioctl.c
--- a/ioctl.c	Wed Aug 06 14:41:23 2008 -0600
+++ b/ioctl.c	Thu Aug 07 09:49:52 2008 -0600
@@ -749,6 +749,53 @@
 	return ret;
 }

+long btrfs_ioctl_set_label(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_ioctl_label_args *label_args;
+	int ret = 0;
+
+	label_args = kmalloc(sizeof(*label_args), GFP_NOFS);
+
+	if (!label_args)
+		return -ENOMEM;
+
+	if (copy_from_user(label_args, arg, sizeof(*label_args)))
+	{
+		ret = -EFAULT;
+	} else
+	{
+		/* Everything looks good, so lets do a label change */
+		label_args->name[BTRFS_LABEL_SIZE] = 0x00;
+		trans = btrfs_start_transaction(root, 1);
+   	strncpy(root->fs_info->super_copy.label, label_args->name,
BTRFS_LABEL_SIZE);
+   	btrfs_commit_transaction(trans, root);
+	}
+
+	kfree(label_args);
+	return ret;
+}
+
+long btrfs_ioctl_get_label(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_label_args *label_args;
+	int ret = 0;
+
+	label_args = kmalloc(sizeof(*label_args), GFP_NOFS);
+
+	if (!label_args)
+		return -ENOMEM;
+
+	strncpy(label_args->name, root->fs_info->super_copy.label, BTRFS_LABEL_SIZE);
+	if (copy_to_user(arg, label_args, sizeof(*label_args)))
+	{
+		ret = -EFAULT;
+	}
+
+	kfree(label_args);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -773,6 +820,10 @@
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
 		return btrfs_ioctl_trans_end(file);
+	case BTRFS_IOC_SET_LABEL:
+		return btrfs_ioctl_set_label(root, (void __user *)arg);
+	case BTRFS_IOC_GET_LABEL:
+		return btrfs_ioctl_get_label(root, (void __user *)arg);
 	case BTRFS_IOC_SYNC:
 		btrfs_start_delalloc_inodes(root);
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
diff -r b68faa369602 ioctl.h
--- a/ioctl.h	Wed Aug 06 14:41:23 2008 -0600
+++ b/ioctl.h	Thu Aug 07 09:49:52 2008 -0600
@@ -28,6 +28,10 @@
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };

+struct btrfs_ioctl_label_args {
+	char name[BTRFS_LABEL_SIZE + 1];
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -52,4 +56,10 @@
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)

+/* Used to set and get the current volume label */
+#define BTRFS_IOC_SET_LABEL	_IOW(BTRFS_IOCTL_MAGIC, 13, \
+					struct btrfs_ioctl_label_args)
+#define BTRFS_IOC_GET_LABEL	_IOW(BTRFS_IOCTL_MAGIC, 14, \
+					struct btrfs_ioctl_label_args)
+
 #endif
