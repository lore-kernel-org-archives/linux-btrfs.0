Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38545 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab2LLAWb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 19:22:31 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBC0MTSq003796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:22:30 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBC0MTEb021730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:22:29 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBC0MTwd009568
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2012 18:22:29 -0600
Message-ID: <50C7CE41.9050607@oracle.com>
Date: Wed, 12 Dec 2012 08:22:25 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com
Subject: [PATCH V4 1/2] Btrfs: Add a new ioctl to get the label of a mounted
 filesystem
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50C7CE36.3060603@oracle.com>

Introduce a new ioctl BTRFS_IOC_GET_FSLABEL, which would be used to fetch the label
of a mounted filesystem.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

---
 fs/btrfs/ioctl.c |   14 ++++++++++++++
 fs/btrfs/ioctl.h |    2 ++
 2 files changed, 16 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8fcf9a5..b0a5e17 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3699,6 +3699,18 @@ out:
 	return ret;
 }
 
+static int btrfs_ioctl_get_fslabel(struct btrfs_root *root, void __user *arg)
+{
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
@@ -3797,6 +3809,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_qgroup_create(root, argp);
 	case BTRFS_IOC_QGROUP_LIMIT:
 		return btrfs_ioctl_qgroup_limit(root, argp);
+	case BTRFS_IOC_GET_FSLABEL:
+		return btrfs_ioctl_get_fslabel(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 731e287..98f896f 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -453,4 +453,6 @@ struct btrfs_ioctl_send_args {
 			       struct btrfs_ioctl_qgroup_limit_args)
 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
 				      struct btrfs_ioctl_get_dev_stats)
+#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 53, \
+				   char[BTRFS_LABEL_SIZE])
 #endif
-- 
1.7.9.5
