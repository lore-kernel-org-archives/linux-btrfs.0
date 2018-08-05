Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52034 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726121AbeHEMo2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2018 08:44:28 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id BDA4D4B6ADFC
        for <linux-btrfs@vger.kernel.org>; Sun,  5 Aug 2018 18:40:10 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 4/4] btrfs: undelete: Add the btrfs_ioctl_undelete
Date: Sun, 5 Aug 2018 18:40:01 +0800
Message-ID: <20180805104001.5488-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
References: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function will traverse the root from the fs_info->dead_roots and try
to call btrfs_undelete_subvolume() to recover them.

Note: It will lock fs_info->cleaner_mutex to keep the cleaner kthread
from deleting the subvolume which we want to recover.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c           | 83 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  9 +++++
 2 files changed, 92 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7a11c4f8e450..83b9839799d0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1980,6 +1980,87 @@ static int btrfs_undelete_subvolume(const struct path *parent,
 	return ret;
 }
 
+static int btrfs_ioctl_undelete(struct file *file, void __user *argp)
+{
+	struct btrfs_ioctl_undelete_args __user *uarg;
+	struct btrfs_ioctl_undelete_args *args;
+	struct inode *inode = file_inode(file);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_root *root, *tmp;
+	char *name;
+	u64 count = 0;
+	u64 objectid;
+	int err = 0, ret;
+
+	/* copy search header and buffer size */
+	uarg = (struct btrfs_ioctl_undelete_args __user *)argp;
+	args = memdup_user(uarg, sizeof(*args));
+	if (IS_ERR(args))
+		return PTR_ERR(args);
+	args->name[BTRFS_PATH_NAME_MAX] = '\0';
+
+	name = kzalloc(BTRFS_PATH_NAME_MAX + 1, GFP_KERNEL);
+	if (IS_ERR(name)) {
+		err = PTR_ERR(name);
+		goto free_args;
+	}
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto free;
+	}
+
+	err = mnt_want_write_file(file);
+	if (err)
+		goto free;
+
+	/* Lock cleaner_mutex to prevent the cleaner kthread from deleting the
+	 * subvolume we want to recover so that we can perform the next rescue
+	 * in a relaxed manner.
+	 */
+	mutex_lock(&fs_info->cleaner_mutex);
+
+	list_for_each_entry_safe(root, tmp, &fs_info->dead_roots, root_list) {
+		objectid = root->root_key.objectid;
+		snprintf(name, BTRFS_PATH_NAME_MAX, "%s%llu", args->name,
+				objectid);
+		ret = btrfs_undelete_subvolume(&file->f_path, root, name,
+					       strlen(name));
+		if (ret)
+			continue;
+
+		/*
+		 * Feel free to remove this root from dead_root list since we
+		 * have recover it successfully.
+		 */
+		spin_lock(&fs_info->trans_lock);
+		list_del_init(&root->root_list);
+		spin_unlock(&fs_info->trans_lock);
+
+		if ((count + 1) * sizeof(objectid) > args->buf_size)
+			continue;
+
+		/* copy the subvolume id to user space */
+		ret = copy_to_user(&uarg->buf[count], &objectid,
+				   sizeof(objectid));
+		if (ret)
+			err = -EFAULT;
+		count++;
+	}
+
+	mutex_unlock(&fs_info->cleaner_mutex);
+	mnt_drop_write_file(file);
+
+	/* copy the count to user space */
+	if (copy_to_user(&uarg->count, &count, sizeof(count)))
+		err = -EFAULT;
+free:
+	kfree(name);
+free_args:
+	kfree(args);
+	return err;
+}
+
 static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 						void __user *arg)
 {
@@ -6089,6 +6170,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_subvol_rootref(file, argp);
 	case BTRFS_IOC_INO_LOOKUP_USER:
 		return btrfs_ioctl_ino_lookup_user(file, argp);
+	case BTRFS_IOC_SUBVOL_UNDELETE:
+		return btrfs_ioctl_undelete(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..25d030687b27 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -816,6 +816,13 @@ struct btrfs_ioctl_get_subvol_rootref_args {
 		__u8 align[7];
 };
 
+struct btrfs_ioctl_undelete_args {
+	char name[BTRFS_PATH_NAME_MAX + 1];	/* in - subvolume name prefix */
+	__u64 buf_size;				/* in - size of buffer */
+	__u64 count;		/* out - store number of recoverd subvolumes */
+	__u64 buf[0];		/* out - store ids of recoverd subolumes */
+};
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
@@ -940,5 +947,7 @@ enum btrfs_err_code {
 				struct btrfs_ioctl_get_subvol_rootref_args)
 #define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 62, \
 				struct btrfs_ioctl_ino_lookup_user_args)
+#define BTRFS_IOC_SUBVOL_UNDELETE _IOWR(BTRFS_IOCTL_MAGIC, 63, \
+					struct btrfs_ioctl_undelete_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.18.0



