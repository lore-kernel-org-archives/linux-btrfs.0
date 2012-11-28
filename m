Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22740 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2K1MKi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 07:10:38 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qASCAbLt027101
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2012 12:10:37 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qASCAaiV002157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2012 12:10:37 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qASCAaTL029477
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2012 06:10:36 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] Btrfs: add label to snapshot and subvol
Date: Wed, 28 Nov 2012 20:15:42 +0800
Message-Id: <1354104942-829-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1354040960-31522-2-git-send-email-Anand.Jain@oracle.com>
References: <1354040960-31522-2-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   12 +++++++++-
 fs/btrfs/ioctl.c       |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h       |    2 +
 fs/btrfs/transaction.c |    1 +
 4 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 994d255..039e11c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -383,6 +383,7 @@ struct btrfs_header {
  */
 #define BTRFS_SYSTEM_CHUNK_ARRAY_SIZE 2048
 #define BTRFS_LABEL_SIZE 256
+#define BTRFS_SUBVOL_LABEL_SIZE 32
 
 /*
  * just in case we somehow lose the roots and are not able to mount,
@@ -759,7 +760,8 @@ struct btrfs_root_item {
 	struct btrfs_timespec otime;
 	struct btrfs_timespec stime;
 	struct btrfs_timespec rtime;
-	__le64 reserved[8]; /* for future */
+	char label[BTRFS_SUBVOL_LABEL_SIZE];
+	__le64 reserved[4]; /* for future */
 } __attribute__ ((__packed__));
 
 /*
@@ -2441,6 +2443,14 @@ static inline bool btrfs_root_readonly(struct btrfs_root *root)
 {
 	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) != 0;
 }
+static inline char * btrfs_root_label(struct btrfs_root_item *root_item)
+{
+	return (root_item->label);
+}
+static inline void btrfs_root_set_label(struct btrfs_root_item *root_item, char *val)
+{
+	memcpy(root_item->label, val, BTRFS_SUBVOL_LABEL_SIZE);
+}
 
 /* struct btrfs_root_backup */
 BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e58bd9d..abbac27 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3725,6 +3725,60 @@ static int btrfs_ioctl_set_label(struct btrfs_root *root, void __user *arg)
 	return 0;
 }
 
+static int btrfs_ioctl_subvol_getlabel(struct btrfs_root *root,
+						void __user *arg)
+{
+	char *label;
+
+	spin_lock(&root->root_times_lock);
+	label = btrfs_root_label(&root->root_item);
+	if (copy_to_user(arg, label, BTRFS_SUBVOL_LABEL_SIZE)) {
+		spin_unlock(&root->root_times_lock);
+		return -EFAULT;
+	}
+	spin_unlock(&root->root_times_lock);
+	return 0;
+}
+
+static int btrfs_ioctl_subvol_setlabel(struct file *file,
+						void __user *arg)
+{
+	char label[BTRFS_SUBVOL_LABEL_SIZE+1];
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int ret;
+
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	if (copy_from_user(label, arg, BTRFS_SUBVOL_LABEL_SIZE)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+	spin_lock(&root->root_times_lock);
+	btrfs_root_set_label(&root->root_item, label);
+	spin_unlock(&root->root_times_lock);
+	btrfs_end_transaction(trans, root);
+
+out:
+	mnt_drop_write_file(file);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3827,6 +3881,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_label(root, argp);
 	case BTRFS_IOC_SET_LABEL:
 		return btrfs_ioctl_set_label(root, argp);
+	case BTRFS_IOC_SUBVOL_GETLABEL:
+		return btrfs_ioctl_subvol_getlabel(root, argp);
+	case BTRFS_IOC_SUBVOL_SETLABEL:
+		return btrfs_ioctl_subvol_setlabel(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 0c60fcb..1009a0c 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -455,4 +455,6 @@ struct btrfs_ioctl_send_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_GET_LABEL _IOR(BTRFS_IOCTL_MAGIC, 53, __u64)
 #define BTRFS_IOC_SET_LABEL _IOW(BTRFS_IOCTL_MAGIC, 54, __u64)
+#define BTRFS_IOC_SUBVOL_GETLABEL _IOWR(BTRFS_IOCTL_MAGIC, 55, __u64)
+#define BTRFS_IOC_SUBVOL_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 56, __u64)
 #endif
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04bbfb1..0a3f8b3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1118,6 +1118,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	memset(&new_root_item->rtime, 0, sizeof(new_root_item->rtime));
 	btrfs_set_root_stransid(new_root_item, 0);
 	btrfs_set_root_rtransid(new_root_item, 0);
+	memset(&new_root_item->label, 0, BTRFS_SUBVOL_LABEL_SIZE);
 
 	old = btrfs_lock_root_node(root);
 	ret = btrfs_cow_block(trans, root, old, NULL, 0, &old);
-- 
1.7.1

