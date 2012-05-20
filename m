Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:33914 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab2ETQGi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:38 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 23/24] Btrfs: add qgroup ioctls
Date: Sun, 20 May 2012 18:06:34 +0200
Message-Id: <1676dda8ab5874980dafde71cef0291bad79c488.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Ioctls to control the qgroup feature like adding and
removing qgroups and assigning qgroups.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ioctl.c |  185 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   27 ++++++++
 2 files changed, 212 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7f3a913..869c335 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3342,6 +3342,183 @@ out:
 	return ret;
 }
 
+static long btrfs_ioctl_quota_ctl(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_quota_ctl_args *sa;
+	struct btrfs_trans_handle *trans = NULL;
+	int ret;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
+		trans = btrfs_start_transaction(root, 2);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
+	}
+
+	switch (sa->cmd) {
+	case BTRFS_QUOTA_CTL_ENABLE:
+		ret = btrfs_quota_enable(trans, root->fs_info);
+		break;
+	case BTRFS_QUOTA_CTL_DISABLE:
+		ret = btrfs_quota_disable(trans, root->fs_info);
+		break;
+	case BTRFS_QUOTA_CTL_RESCAN:
+		ret = btrfs_quota_rescan(root->fs_info);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (copy_to_user(arg, sa, sizeof(*sa)))
+		ret = -EFAULT;
+
+	if (trans) {
+		err = btrfs_commit_transaction(trans, root);
+		if (err && !ret)
+			ret = err;
+	}
+
+out:
+	kfree(sa);
+	return ret;
+}
+
+static long btrfs_ioctl_qgroup_assign(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_qgroup_assign_args *sa;
+	struct btrfs_trans_handle *trans;
+	int ret;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	/* FIXME: check if the IDs really exist */
+	if (sa->assign) {
+		ret = btrfs_add_qgroup_relation(trans, root->fs_info,
+						sa->src, sa->dst);
+	} else {
+		ret = btrfs_del_qgroup_relation(trans, root->fs_info,
+						sa->src, sa->dst);
+	}
+
+	err = btrfs_end_transaction(trans, root);
+	if (err && !ret)
+		ret = err;
+
+out:
+	kfree(sa);
+	return ret;
+}
+
+static long btrfs_ioctl_qgroup_create(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_qgroup_create_args *sa;
+	struct btrfs_trans_handle *trans;
+	int ret;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	/* FIXME: check if the IDs really exist */
+	if (sa->create) {
+		ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid,
+					  NULL);
+	} else {
+		ret = btrfs_remove_qgroup(trans, root->fs_info, sa->qgroupid);
+	}
+
+	err = btrfs_end_transaction(trans, root);
+	if (err && !ret)
+		ret = err;
+
+out:
+	kfree(sa);
+	return ret;
+}
+
+static long btrfs_ioctl_qgroup_limit(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_qgroup_limit_args *sa;
+	struct btrfs_trans_handle *trans;
+	int ret;
+	int err;
+	u64 qgroupid;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	qgroupid = sa->qgroupid;
+	if (!qgroupid) {
+		/* take the current subvol as qgroup */
+		qgroupid = root->root_key.objectid;
+	}
+
+	/* FIXME: check if the IDs really exist */
+	ret = btrfs_limit_qgroup(trans, root->fs_info, qgroupid, &sa->lim);
+
+	err = btrfs_end_transaction(trans, root);
+	if (err && !ret)
+		ret = err;
+
+out:
+	kfree(sa);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -3424,6 +3601,14 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_balance_ctl(root, arg);
 	case BTRFS_IOC_BALANCE_PROGRESS:
 		return btrfs_ioctl_balance_progress(root, argp);
+	case BTRFS_IOC_QUOTA_CTL:
+		return btrfs_ioctl_quota_ctl(root, argp);
+	case BTRFS_IOC_QGROUP_ASSIGN:
+		return btrfs_ioctl_qgroup_assign(root, argp);
+	case BTRFS_IOC_QGROUP_CREATE:
+		return btrfs_ioctl_qgroup_create(root, argp);
+	case BTRFS_IOC_QGROUP_LIMIT:
+		return btrfs_ioctl_qgroup_limit(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 44c34a5..f7002c8 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -290,6 +290,25 @@ struct btrfs_ioctl_logical_ino_args {
 	__u64				inodes;
 };
 
+#define BTRFS_QUOTA_CTL_ENABLE	1
+#define BTRFS_QUOTA_CTL_DISABLE	2
+#define BTRFS_QUOTA_CTL_RESCAN	3
+struct btrfs_ioctl_quota_ctl_args {
+	__u64 cmd;
+	__u64 status;
+};
+
+struct btrfs_ioctl_qgroup_assign_args {
+	__u64 assign;
+	__u64 src;
+	__u64 dst;
+};
+
+struct btrfs_ioctl_qgroup_create_args {
+	__u64 create;
+	__u64 qgroupid;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -355,4 +374,12 @@ struct btrfs_ioctl_logical_ino_args {
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
 
+#define BTRFS_IOC_QUOTA_CTL _IOWR(BTRFS_IOCTL_MAGIC, 40, \
+			       struct btrfs_ioctl_quota_ctl_args)
+#define BTRFS_IOC_QGROUP_ASSIGN _IOW(BTRFS_IOCTL_MAGIC, 41, \
+			       struct btrfs_ioctl_qgroup_assign_args)
+#define BTRFS_IOC_QGROUP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 42, \
+			       struct btrfs_ioctl_qgroup_create_args)
+#define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
+			       struct btrfs_ioctl_qgroup_limit_args)
 #endif
-- 
1.7.3.4

