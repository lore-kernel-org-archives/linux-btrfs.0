Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:33257 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933357Ab2GLJnw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:52 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 14/15] Btrfs: add qgroup ioctls
Date: Thu, 12 Jul 2012 11:43:46 +0200
Message-Id: <5d13a37bd5327220e13329943d1228acfbe5934a.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
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
index 0e92e57..55a7283 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3390,6 +3390,183 @@ out:
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
@@ -3476,6 +3653,14 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_dev_stats(root, argp, 0);
 	case BTRFS_IOC_GET_AND_RESET_DEV_STATS:
 		return btrfs_ioctl_get_dev_stats(root, argp, 1);
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
index a8a2230..9dd50c4 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -319,6 +319,25 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
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
@@ -388,4 +407,12 @@ struct btrfs_ioctl_get_dev_stats {
 #define BTRFS_IOC_GET_AND_RESET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 					struct btrfs_ioctl_get_dev_stats)
 
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

