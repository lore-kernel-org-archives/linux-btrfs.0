Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43181 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2LQLWT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 06:22:19 -0500
Message-ID: <50CF0063.3060503@oracle.com>
Date: Mon, 17 Dec 2012 19:22:11 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com, miaox@cn.fujitsu.com
Subject: [RFC PATCH V5 2/2] Btrfs: Add a new ioctl to change the label of
 a mounted file system
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50CF0053.4050906@oracle.com>

Introduce a new ioctl BTRFS_IOC_SET_FSLABEL to change the label of a mounted file system.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>

---
 fs/btrfs/ioctl.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    2 ++
 2 files changed, 42 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6a2488a..0186651 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3712,6 +3712,44 @@ static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
 	return ret ? -EFAULT : 0;
 }
 
+static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
+	struct btrfs_super_block *super_block = root->fs_info->super_copy;
+	char label[BTRFS_LABEL_SIZE];
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(label, arg, sizeof(label)))
+		return -EFAULT;
+
+	if (strlen(label) > BTRFS_LABEL_SIZE - 1)
+		return -EINVAL;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	mutex_lock(&root->fs_info->volume_mutex);
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_unlock;
+	}
+
+	label[BTRFS_LABEL_SIZE - 1] = '\0';
+	strcpy(super_block->label, label);
+	btrfs_end_transaction(trans, root);
+
+out_unlock:
+	mutex_unlock(&root->fs_info->volume_mutex);
+	mnt_drop_write_file(file);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3812,6 +3850,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_qgroup_limit(root, argp);
 	case BTRFS_IOC_GET_FSLABEL:
 		return btrfs_ioctl_get_fslabel(file, argp);
+	case BTRFS_IOC_SET_FSLABEL:
+		return btrfs_ioctl_set_fslabel(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 5b2cbef..2abe239 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -453,6 +453,8 @@ struct btrfs_ioctl_send_args {
 			       struct btrfs_ioctl_qgroup_limit_args)
 #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
 				   char[BTRFS_LABEL_SIZE])
+#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
+				   char[BTRFS_LABEL_SIZE])
 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
 				      struct btrfs_ioctl_get_dev_stats)
 #endif
-- 
1.7.9.5
