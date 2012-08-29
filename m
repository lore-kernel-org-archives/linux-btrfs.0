Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:29691 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2H2IoU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 04:44:20 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7T8iGHv022178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 08:44:19 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7T8iFQt003849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 08:44:16 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7T8iFUl006249
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 03:44:15 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: Add get/set label ioctl
Date: Wed, 29 Aug 2012 16:46:00 +0800
Message-Id: <1346229961-635-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h |   10 ++++++++++
 fs/btrfs/ioctl.c |   30 ++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    2 ++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4bab807..eff506f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2583,6 +2583,16 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
 
+static inline char * btrfs_super_label(struct btrfs_super_block *s)
+{
+	return s->label;
+}
+static inline void btrfs_set_super_label(struct btrfs_super_block *s,
+	char *val)
+{
+	memcpy(s->label,val,BTRFS_LABEL_SIZE);
+}
+
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
 	int t = btrfs_super_csum_type(s);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7bb7556..b472942 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3687,6 +3687,32 @@ out:
 	return ret;
 }
 
+static int btrfs_ioctl_get_label(struct btrfs_root *root, void __user *arg)
+{
+	char *label;
+	label = btrfs_super_label(root->fs_info->super_copy);
+	if (copy_to_user(arg, label, BTRFS_LABEL_SIZE))
+		return -EFAULT;
+	return 0;
+}
+
+static int btrfs_ioctl_set_label(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_trans_handle *trans;
+	char label[BTRFS_LABEL_SIZE+1];
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (copy_from_user(label, arg, BTRFS_LABEL_SIZE))
+		return -EFAULT;
+	label[BTRFS_LABEL_SIZE] = '\0';
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_super_label(root->fs_info->super_copy, label);
+	btrfs_commit_transaction(trans, root);
+
+	return 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3785,6 +3811,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_qgroup_create(root, argp);
 	case BTRFS_IOC_QGROUP_LIMIT:
 		return btrfs_ioctl_qgroup_limit(root, argp);
+	case BTRFS_IOC_GET_LABEL:
+		return btrfs_ioctl_get_label(root, argp);
+	case BTRFS_IOC_SET_LABEL:
+		return btrfs_ioctl_set_label(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 731e287..0c60fcb 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -453,4 +453,6 @@ struct btrfs_ioctl_send_args {
 			       struct btrfs_ioctl_qgroup_limit_args)
 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
 				      struct btrfs_ioctl_get_dev_stats)
+#define BTRFS_IOC_GET_LABEL _IOR(BTRFS_IOCTL_MAGIC, 53, __u64)
+#define BTRFS_IOC_SET_LABEL _IOW(BTRFS_IOCTL_MAGIC, 54, __u64)
 #endif
-- 
1.7.1

