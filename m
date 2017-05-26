Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:35737 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944932AbdEZUoo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 16:44:44 -0400
Received: by mail-it0-f41.google.com with SMTP id c15so2983149ith.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 13:44:43 -0700 (PDT)
Date: Fri, 26 May 2017 20:44:41 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, mkh@rqc.ru
Subject: [PATCH v2 2/4] btrfs: Add new ioctl uapis for qgroup creation /
 removal
Message-ID: <20170526204439.GA18200@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170526204414.GA18176@ircssh-2.c.rugged-nimbus-611.internal>

This patch introduces two new ioctls to create, and remove qgroups. These
offer a somewhat more intuitive set of operations with the opportunity
to add flags that gate to unintentional manipulation of qgroups.

The create qgroup ioctl has a a new semantic which level-0 qgroups cannot
be created unless a matching subvolume ID is created.

The delete qgroup ioctl has the new semantic that it will not let you
delete a currently utilized (referenced by a subvolume) level-0
qgroup unless you pass the BTRFS_QGROUP_NO_SUBVOL_CHECK flag.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/ioctl.c           | 100 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.c          |  76 +++++++++++++++++++++++++++++++---
 fs/btrfs/qgroup.h          |   6 ++-
 include/uapi/linux/btrfs.h |  22 ++++++++++
 4 files changed, 195 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e176375..78c8321 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4922,6 +4922,98 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	return ret;
 }
 
+static long btrfs_ioctl_qgroup_create_v2(struct file *file, void __user *arg)
+{
+	struct btrfs_ioctl_qgroup_create_args_v2 create_args;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_root *root;
+	struct inode *inode;
+	int ret;
+	int err;
+
+	inode = file_inode(file);
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
+	ret = btrfs_create_qgroup(trans, fs_info, create_args.qgroupid, 1);
+	err = btrfs_end_transaction(trans);
+
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
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_root *root;
+	struct inode *inode;
+	int check;
+	int ret;
+	int err;
+
+	inode = file_inode(file);
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
+	check = !(remove_args.flags & BTRFS_QGROUP_NO_SUBVOL_CHECK);
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
+	ret = btrfs_remove_qgroup(trans, fs_info, remove_args.qgroupid, check);
+	err = btrfs_end_transaction(trans);
+
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
@@ -4958,9 +5050,9 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 
 	/* FIXME: check if the IDs really exist */
 	if (sa->create) {
-		ret = btrfs_create_qgroup(trans, fs_info, sa->qgroupid);
+		ret = btrfs_create_qgroup(trans, fs_info, sa->qgroupid, 0);
 	} else {
-		ret = btrfs_remove_qgroup(trans, fs_info, sa->qgroupid);
+		ret = btrfs_remove_qgroup(trans, fs_info, sa->qgroupid, 0);
 	}
 
 	err = btrfs_end_transaction(trans);
@@ -5632,6 +5724,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_features(file, argp);
 	case BTRFS_IOC_SET_FEATURES:
 		return btrfs_ioctl_set_features(file, argp);
+	case BTRFS_IOC_QGROUP_CREATE_V2:
+		return btrfs_ioctl_qgroup_create_v2(file, argp);
+	case BTRFS_IOC_QGROUP_REMOVE_V2:
+		return btrfs_ioctl_qgroup_remove_v2(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d39ffcc..ba8a6ee 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1247,8 +1247,51 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * Meant to only operate on level-0 qroupid.
+ *
+ * It returns 1 if a matching subvolume is found; 0 if none is found.
+ * < 0 if there is an error.
+ */
+static int btrfs_subvolume_exists(struct btrfs_fs_info *fs_info, u64 qgroupid)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int err, ret = 0;
+
+	if (qgroupid == BTRFS_FS_TREE_OBJECTID)
+		return 1;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = qgroupid;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
+	key.offset = 0;
+
+	err = btrfs_search_slot_for_read(fs_info->tree_root, &key, path, 1, 0);
+	if (err == 1)
+		goto out;
+
+	if (err) {
+		ret = err;
+		goto out;
+	}
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if (key.objectid != qgroupid || key.type != BTRFS_ROOT_BACKREF_KEY)
+		goto out;
+
+	ret = 1;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid)
+			struct btrfs_fs_info *fs_info, u64 qgroupid,
+			int check_subvol_exists)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -1260,12 +1303,23 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 		ret = -EINVAL;
 		goto out;
 	}
+
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
 	if (qgroup) {
 		ret = -EEXIST;
 		goto out;
 	}
 
+	if (check_subvol_exists && btrfs_qgroup_level(qgroupid) == 0) {
+		ret = btrfs_subvolume_exists(fs_info, qgroupid);
+		if (ret < 0)
+			goto out;
+		if (!ret) {
+			ret = -ENOENT;
+			goto out;
+		}
+	}
+
 	ret = add_qgroup_item(trans, quota_root, qgroupid);
 	if (ret)
 		goto out;
@@ -1282,7 +1336,8 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid)
+			struct btrfs_fs_info *fs_info, u64 qgroupid,
+			int check_subvol_exists)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -1300,13 +1355,24 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 	if (!qgroup) {
 		ret = -ENOENT;
 		goto out;
-	} else {
-		/* check if there are no children of this qgroup */
-		if (!list_empty(&qgroup->members)) {
+	}
+
+	if (check_subvol_exists && btrfs_qgroup_level(qgroupid) == 0) {
+		ret = btrfs_subvolume_exists(fs_info, qgroupid);
+		if (ret < 0)
+			goto out;
+		if (ret) {
 			ret = -EBUSY;
 			goto out;
 		}
 	}
+
+	/* check if there are no children of this qgroup */
+	if (!list_empty(&qgroup->members)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
 
 	if (ret && ret != -ENOENT)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index fe04d3f..8702d74 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -125,9 +125,11 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid);
+			struct btrfs_fs_info *fs_info, u64 qgroupid,
+			int check_subvol_exists);
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info, u64 qgroupid);
+			struct btrfs_fs_info *fs_info, u64 qgroupid,
+			int check_subvol_exists);
 int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 qgroupid,
 		       struct btrfs_qgroup_limit *limit);
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index a456e53..c073854 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -653,6 +653,24 @@ struct btrfs_ioctl_qgroup_create_args {
 	__u64 create;
 	__u64 qgroupid;
 };
+
+struct btrfs_ioctl_qgroup_create_args_v2 {
+	__u64 qgroupid;
+	__u64 flags;
+	__u64 reserved[16];
+};
+
+/*
+ * Allows for the deletion of qgroups even if they are associated with active
+ * volumes.
+ */
+#define BTRFS_QGROUP_NO_SUBVOL_CHECK	(1ULL << 0)
+struct btrfs_ioctl_qgroup_remove_args_v2 {
+	__u64 qgroupid;
+	__u64 flags;
+	__u64 reserved[16];
+};
+
 struct btrfs_ioctl_timespec {
 	__u64 sec;
 	__u32 nsec;
@@ -818,5 +836,9 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_QGROUP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 59, \
+					struct btrfs_ioctl_qgroup_create_args_v2)
+#define BTRFS_IOC_QGROUP_REMOVE_V2 _IOW(BTRFS_IOCTL_MAGIC, 60, \
+					struct btrfs_ioctl_qgroup_remove_args_v2)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.9.3

