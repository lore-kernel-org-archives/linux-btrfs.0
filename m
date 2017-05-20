Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:32810 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755765AbdETIkJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 04:40:09 -0400
Received: by mail-io0-f180.google.com with SMTP id p24so59135052ioi.0
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 01:40:08 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id b72sm5209502itd.31.2017.05.20.01.40.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 May 2017 01:40:08 -0700 (PDT)
Date: Sat, 20 May 2017 08:40:06 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/8] btrfs: Add new ioctl uapis for qgroup creation / removal
Message-ID: <20170520084005.GA4262@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170520083826.GA4176@ircssh-2.c.rugged-nimbus-611.internal>

This patch ties together the work in the previous patches, to introduce
semantics around the qgroup creation / removal API that are a bit more
intuitive that the current one. It also creates two new args structures
which have reserved space for future expansion, as opposed to single
datastructure for both creation and removal.

The associated semantics are as follows:
1) You cannot create a level 0 qgroup for a subvol which does not exist
   unless you pass in an override flag.
2) You cannot delete a level 0 qgroup which refers to a subvolume, which
   currently exists unless you pass in an override flag.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/ioctl.c           | 98 ++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h | 23 +++++++++++
 2 files changed, 121 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5e20643..7bf34b7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4936,6 +4936,100 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	return ret;
 }
 
+static long btrfs_ioctl_qgroup_create_v2(struct file *file, void __user *arg)
+{
+	struct btrfs_ioctl_qgroup_create_args_v2 create_args;
+	struct inode *inode = file_inode(file);
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_root *root;
+	int check_subvol_exists;
+	int ret, err;
+
+	fs_info = btrfs_sb(inode->i_sb);
+	root = BTRFS_I(inode)->root;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = copy_from_user(&create_args, arg, sizeof(create_args));
+	if (ret)
+		return ret;
+
+	if (!create_args.qgroupid)
+		return -EINVAL;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	check_subvol_exists = !(create_args.flags &
+				BTRFS_QGROUP_CREATE_IGNORE_UNUSED);
+	ret = btrfs_create_qgroup(trans, fs_info, create_args.qgroupid,
+				  check_subvol_exists);
+
+	err = btrfs_end_transaction(trans);
+	if (err && !ret)
+		ret = err;
+
+out:
+	mnt_drop_write_file(file);
+	return ret;
+}
+
+static long btrfs_ioctl_qgroup_remove_v2(struct file *file, void __user *arg)
+{
+	struct btrfs_ioctl_qgroup_remove_args_v2 remove_args;
+	struct inode *inode = file_inode(file);
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_root *root;
+	int check_in_use;
+	int ret, err;
+
+	fs_info = btrfs_sb(inode->i_sb);
+	root = BTRFS_I(inode)->root;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = copy_from_user(&remove_args, arg, sizeof(remove_args));
+	if (ret)
+		return ret;
+
+	if (!remove_args.qgroupid)
+		return -EINVAL;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	check_in_use = !(remove_args.flags &
+			 BTRFS_QGROUP_REMOVE_NO_CHECK_IN_USE);
+	ret = btrfs_remove_qgroup(trans, fs_info, remove_args.qgroupid,
+				  check_in_use);
+
+	err = btrfs_end_transaction(trans);
+	if (err && !ret)
+		ret = err;
+
+out:
+	mnt_drop_write_file(file);
+	return ret;
+}
+
 static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
@@ -5626,6 +5720,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_qgroup_assign(file, argp);
 	case BTRFS_IOC_QGROUP_CREATE:
 		return btrfs_ioctl_qgroup_create(file, argp);
+	case BTRFS_IOC_QGROUP_CREATE_V2:
+		return btrfs_ioctl_qgroup_create_v2(file, argp);
+	case BTRFS_IOC_QGROUP_REMOVE_V2:
+		return btrfs_ioctl_qgroup_remove_v2(file, argp);
 	case BTRFS_IOC_QGROUP_LIMIT:
 		return btrfs_ioctl_qgroup_limit(file, argp);
 	case BTRFS_IOC_QUOTA_RESCAN:
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index a456e53..0a6652d 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -653,6 +653,25 @@ struct btrfs_ioctl_qgroup_create_args {
 	__u64 create;
 	__u64 qgroupid;
 };
+
+/* Allow the user to delete qgroups even if there isn't a subvol with the id */
+#define	BTRFS_QGROUP_CREATE_IGNORE_UNUSED		(1ULL << 0)
+
+struct btrfs_ioctl_qgroup_create_args_v2 {
+	__u64 qgroupid;
+	__u64 flags;
+	__u64 reserved[16];
+};
+
+/* Allow the user to delete qgroups even if they are referenced by a subvol */
+#define	BTRFS_QGROUP_REMOVE_NO_CHECK_IN_USE		(1ULL << 0)
+
+struct btrfs_ioctl_qgroup_remove_args_v2 {
+	__u64 qgroupid;
+	__u64 flags;
+	__u64 reserved[16];
+};
+
 struct btrfs_ioctl_timespec {
 	__u64 sec;
 	__u32 nsec;
@@ -818,5 +837,9 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_QGROUP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 59, \
+			       struct btrfs_ioctl_qgroup_create_args_v2)
+#define BTRFS_IOC_QGROUP_REMOVE_V2 _IOW(BTRFS_IOCTL_MAGIC, 60, \
+			       struct btrfs_ioctl_qgroup_remove_args_v2)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.9.3

