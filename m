From: Morey Roof <moreyroof@gmail.com>
Subject: [PATCH] kernel-unstable: Adds label manipulate ioctl
Date: Tue, 12 Aug 2008 15:09:07 -0600
Message-ID: <48A1FBF3.5050608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds two IOCTLs to allow for changing of the label with the 
file system mounted.

Signed-off-by: Morey Roof <moreyroof@gmail.com>
---
diff -r 447f15493ff8 ioctl.c
--- a/ioctl.c	Thu Aug 07 11:19:43 2008 -0400
+++ b/ioctl.c	Tue Aug 12 15:07:03 2008 -0600
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
+		strncpy(root->fs_info->super_copy.label, label_args->name, BTRFS_LABEL_SIZE);
+		btrfs_commit_transaction(trans, root);
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
diff -r 447f15493ff8 ioctl.h
--- a/ioctl.h	Thu Aug 07 11:19:43 2008 -0400
+++ b/ioctl.h	Tue Aug 12 15:07:03 2008 -0600
@@ -19,6 +19,7 @@
 #ifndef __IOCTL_
 #define __IOCTL_
 #include <linux/ioctl.h>
+#include "ctree.h"
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
@@ -26,6 +27,10 @@
 
 struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
+};
+
+struct btrfs_ioctl_label_args {
+	char name[BTRFS_LABEL_SIZE + 1];
 };
 
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
@@ -52,4 +57,10 @@
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)
 
+/* Used to set and get the current volume label */
+#define BTRFS_IOC_SET_LABEL	_IOW(BTRFS_IOCTL_MAGIC, 13, \
+					struct btrfs_ioctl_label_args)
+#define BTRFS_IOC_GET_LABEL	_IOW(BTRFS_IOCTL_MAGIC, 14, \
+					struct btrfs_ioctl_label_args)
+
 #endif


