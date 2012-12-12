Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30177 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2LLDXQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 22:23:16 -0500
Message-ID: <50C7F894.9000709@oracle.com>
Date: Wed, 12 Dec 2012 11:23:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com, miaox@cn.fujitsu.com
Subject: [RESEND PATCH V4 2/2] Btrfs: Add a new ioctl to change the label
 of a mounted filesystem
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50C7CE36.3060603@oracle.com>

Add a new ioctl BTRFS_FS_SETLABEL to change the label of a mounted filesystem.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

---
 fs/btrfs/ioctl.c |   34 ++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    2 ++
 2 files changed, 36 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b0a5e17..ebbf634 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3711,6 +3711,38 @@ static int btrfs_ioctl_get_fslabel(struct btrfs_root *root, void __user *arg)
 	return ret ? -EFAULT : 0;
 }
 
+static int btrfs_ioctl_set_fslabel(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_super_block *super_block = root->fs_info->super_copy;
+	struct btrfs_trans_handle *trans;
+	char label[BTRFS_LABEL_SIZE];
+	int ret = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
+	if (copy_from_user(label, arg, sizeof(label)))
+		return -EFAULT;
+
+	label[BTRFS_LABEL_SIZE - 1] = '\0';
+
+	mutex_lock(&root->fs_info->volume_mutex);
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_unlock;
+	}
+	strcpy(super_block->label, label);
+	btrfs_end_transaction(trans, root);
+
+out_unlock:
+	mutex_unlock(&root->fs_info->volume_mutex);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3811,6 +3843,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_qgroup_limit(root, argp);
 	case BTRFS_IOC_GET_FSLABEL:
 		return btrfs_ioctl_get_fslabel(root, argp);
+	case BTRFS_IOC_SET_FSLABEL:
+		return btrfs_ioctl_set_fslabel(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 98f896f..cc4e657 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -455,4 +455,6 @@ struct btrfs_ioctl_send_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 53, \
 				   char[BTRFS_LABEL_SIZE])
+#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 54, \
+				   char[BTRFS_LABEL_SIZE])
 #endif
-- 
1.7.9.5
