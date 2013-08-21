Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16843 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3HUNEZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 09:04:25 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7LD4Orv024237
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 13:04:24 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7LD4Nje028559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 13:04:24 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7LD4NYT028553
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 13:04:23 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: introduce BTRFS_IOC_CHECK_DEV_EXCL_OPS ioctl to check dev excl op
Date: Wed, 21 Aug 2013 21:10:42 +0800
Message-Id: <1377090643-23658-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch provides an ioctl to check if the FS is performing
any device exclusive operations like device add remove balance
etc. Basically any operation which will set
fs_info->mutually_exclusive_operation_running to true

This will be necessary for any user cli which has to know
the state before putting long running commands to background.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c           |   10 ++++++++++
 include/uapi/linux/btrfs.h |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 89f346c..3544a90 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4420,6 +4420,14 @@ out_unlock:
 	return ret;
 }
 
+static int btrfs_ioctl_check_dev_excl_op(struct btrfs_root *root,
+		void __user *arg)
+{
+	if (atomic_read(&root->fs_info->mutually_exclusive_operation_running))
+		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
+	return 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -4532,6 +4540,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_fslabel(file, argp);
 	case BTRFS_IOC_FILE_EXTENT_SAME:
 		return btrfs_ioctl_file_extent_same(file, argp);
+	case BTRFS_IOC_CHECK_DEV_EXCL_OPS:
+		return btrfs_ioctl_check_dev_excl_op(root, NULL);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 90d7bd9..a4fa6eb 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -606,5 +606,6 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_CHECK_DEV_EXCL_OPS _IO(BTRFS_IOCTL_MAGIC, 56)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.7.1

