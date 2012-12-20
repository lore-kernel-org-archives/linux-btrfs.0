Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51894 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2LTIoJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 03:44:09 -0500
Message-ID: <50D2CF98.6010806@oracle.com>
Date: Thu, 20 Dec 2012 16:43:04 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com, miaox@cn.fujitsu.com, kreijack@inwind.it,
        dsterba@suse.cz
Subject: [RFC PATCH v7 1/2] Btrfs: Add a new ioctl to get the label of a mounted
 file system
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50D2CF95.1070905@oracle.com>

With the new ioctl(2) BTRFS_IOC_GET_FSLABEL we can fetch the label of a mounted file system.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Cc: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c |   15 +++++++++++++++
 fs/btrfs/ioctl.h |    2 ++
 2 files changed, 17 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8fcf9a5..6a2488a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3699,6 +3699,19 @@ out:
 	return ret;
 }
 
+static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
+	const char *label = root->fs_info->super_copy->label;
+	int ret;
+
+	mutex_lock(&root->fs_info->volume_mutex);
+	ret = copy_to_user(arg, label, strlen(label));
+	mutex_unlock(&root->fs_info->volume_mutex);
+
+	return ret ? -EFAULT : 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3797,6 +3810,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_qgroup_create(root, argp);
 	case BTRFS_IOC_QGROUP_LIMIT:
 		return btrfs_ioctl_qgroup_limit(root, argp);
+	case BTRFS_IOC_GET_FSLABEL:
+		return btrfs_ioctl_get_fslabel(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 731e287..5b2cbef 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -451,6 +451,8 @@ struct btrfs_ioctl_send_args {
 			       struct btrfs_ioctl_qgroup_create_args)
 #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
 			       struct btrfs_ioctl_qgroup_limit_args)
+#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
+				   char[BTRFS_LABEL_SIZE])
 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
 				      struct btrfs_ioctl_get_dev_stats)
 #endif
-- 
1.7.9.5
