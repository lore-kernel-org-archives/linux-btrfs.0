Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23627 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726881AbeIKQ2K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:28:10 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 99AFA4B6AE13
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 19:29:12 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH v2 4/4] btrfs: undelete: Add BTRFS_IOCTL_SUBVOL_UNDELETE ioctl
Date: Tue, 11 Sep 2018 19:29:03 +0800
Message-ID: <20180911112903.25985-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This ioctl will provide user the ability to recover the subvolume of the
given id to the given directory.

Note: It will lock fs_info->cleaner_mutex to keep the cleaner kthread
from deleting the subvolume which we want to recover.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c           | 64 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  7 +++++
 2 files changed, 71 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f088dea53c16..3ddf6e1c117b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1993,6 +1993,68 @@ static int btrfs_undelete_subvolume(struct btrfs_root *root,
 	return ret;
 }
 
+static int btrfs_ioctl_undelete(struct file *file, void __user *argp)
+{
+	struct btrfs_ioctl_subvol_undelete_args *args;
+	struct inode *inode = file_inode(file);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_root *root;
+	int ret = 0;
+
+	if (!S_ISDIR(inode->i_mode))
+		return -ENOTDIR;
+
+	args = memdup_user(argp, sizeof(*args));
+	if (IS_ERR(args))
+		return PTR_ERR(args);
+
+	args->name[BTRFS_PATH_NAME_MAX] = '\0';
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto free;
+	}
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		goto free;
+
+	ret = -ENOENT;
+	spin_lock(&fs_info->trans_lock);
+	list_for_each_entry(root, &fs_info->dead_roots, root_list) {
+		if (root->root_key.objectid == args->subvol_id) {
+			list_del_init(&root->root_list);
+			ret = 0;
+			break;
+		}
+	}
+	spin_unlock(&fs_info->trans_lock);
+	if (ret)
+		goto drop_write;
+
+	/*
+	 * Lock cleaner_mutex to prevent the cleaner kthread from deleting the
+	 * subvolume we want to recover so that we can perform the next rescue
+	 * in a relaxed manner.
+	 */
+	mutex_lock(&fs_info->cleaner_mutex);
+
+	ret = btrfs_undelete_subvolume(root, file->f_path.dentry, args->name,
+				       strlen(args->name));
+	if (ret) {
+		btrfs_add_dead_root(root);
+		goto unlock;
+	}
+
+unlock:
+	mutex_unlock(&fs_info->cleaner_mutex);
+drop_write:
+	mnt_drop_write_file(file);
+free:
+	kfree(args);
+	return ret;
+}
+
 static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 						void __user *arg)
 {
@@ -6118,6 +6180,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_subvol_rootref(file, argp);
 	case BTRFS_IOC_INO_LOOKUP_USER:
 		return btrfs_ioctl_ino_lookup_user(file, argp);
+	case BTRFS_IOC_SUBVOL_UNDELETE:
+		return btrfs_ioctl_undelete(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..e6d3c8e24bb8 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -816,6 +816,11 @@ struct btrfs_ioctl_get_subvol_rootref_args {
 		__u8 align[7];
 };
 
+struct btrfs_ioctl_subvol_undelete_args {
+	__u64 subvol_id;
+	char name[BTRFS_PATH_NAME_MAX + 1];
+};
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
@@ -940,5 +945,7 @@ enum btrfs_err_code {
 				struct btrfs_ioctl_get_subvol_rootref_args)
 #define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 62, \
 				struct btrfs_ioctl_ino_lookup_user_args)
+#define BTRFS_IOC_SUBVOL_UNDELETE _IOWR(BTRFS_IOCTL_MAGIC, 63, \
+				struct btrfs_ioctl_subvol_undelete_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.18.0
