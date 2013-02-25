Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31932 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3BYFbx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 00:31:53 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1P5VqH1005712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 05:31:53 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1P5Vp7c013188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 05:31:52 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1P5VpJ1020236
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Feb 2013 23:31:51 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4] Btrfs: ability to add label to snapshot and subvol
Date: Mon, 25 Feb 2013 13:31:45 +0800
Message-Id: <1361770305-1206-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1361770305-1206-1-git-send-email-anand.jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
 <1361770305-1206-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Generally snapshots are machine generated, so at any point in time
if a sysadmin looks at a list of snapshots there should be some
info about the snapshots to indicate purpose of it being created.
With this patch and along with the corresponding btrfs-progs patch
a 32byte info can be added to the snapshots/subvol.

Further, ioctl is preferred over the attribute to write the label
since btrfs-progs is not only the application which might be
interacting with the subvol to write the label, for example
btrfs-gui might as well write the label, so that needs an
additional efforts to maintain a consistent keyword across the
applications is difficult in the long run.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h           | 12 +++++++++-
 fs/btrfs/ioctl.c           | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c     |  1 +
 include/uapi/linux/btrfs.h |  2 ++
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1679051..6b527bc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -392,6 +392,7 @@ struct btrfs_header {
  */
 #define BTRFS_SYSTEM_CHUNK_ARRAY_SIZE 2048
 #define BTRFS_LABEL_SIZE 256
+#define BTRFS_SUBVOL_LABEL_SIZE 32
 
 /*
  * just in case we somehow lose the roots and are not able to mount,
@@ -769,7 +770,8 @@ struct btrfs_root_item {
 	struct btrfs_timespec otime;
 	struct btrfs_timespec stime;
 	struct btrfs_timespec rtime;
-	__le64 reserved[8]; /* for future */
+	char label[BTRFS_SUBVOL_LABEL_SIZE];
+	__le64 reserved[4]; /* for future */
 } __attribute__ ((__packed__));
 
 /*
@@ -2546,6 +2548,14 @@ static inline bool btrfs_root_readonly(struct btrfs_root *root)
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
index 2bbbed5..211b319 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3982,6 +3982,60 @@ out_unlock:
 	return ret;
 }
 
+static int btrfs_ioctl_subvol_getlabel(struct btrfs_root *root,
+						void __user *arg)
+{
+	char *label;
+
+	spin_lock(&root->root_item_lock);
+	label = btrfs_root_label(&root->root_item);
+	if (copy_to_user(arg, label, BTRFS_SUBVOL_LABEL_SIZE)) {
+		spin_unlock(&root->root_item_lock);
+		return -EFAULT;
+	}
+	spin_unlock(&root->root_item_lock);
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
+	spin_lock(&root->root_item_lock);
+	btrfs_root_set_label(&root->root_item, label);
+	spin_unlock(&root->root_item_lock);
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
@@ -4086,6 +4140,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(file, argp);
 	case BTRFS_IOC_SET_FSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+	case BTRFS_IOC_SUBVOL_GETLABEL:
+		return btrfs_ioctl_subvol_getlabel(root, argp);
+	case BTRFS_IOC_SUBVOL_SETLABEL:
+		return btrfs_ioctl_subvol_setlabel(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 955204c..955097e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1181,6 +1181,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	memset(&new_root_item->rtime, 0, sizeof(new_root_item->rtime));
 	btrfs_set_root_stransid(new_root_item, 0);
 	btrfs_set_root_rtransid(new_root_item, 0);
+	memset(&new_root_item->label, 0, BTRFS_SUBVOL_LABEL_SIZE);
 
 	old = btrfs_lock_root_node(root);
 	ret = btrfs_cow_block(trans, root, old, NULL, 0, &old);
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index fa3a5f9..38d0f56 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -510,5 +510,7 @@ struct btrfs_ioctl_send_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_SUBVOL_GETLABEL _IOWR(BTRFS_IOCTL_MAGIC, 55, __u64)
+#define BTRFS_IOC_SUBVOL_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 56, __u64)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.8.1.227.g44fe835

