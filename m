Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:43977 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab3EFTPR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 15:15:17 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: add ioctl to wait for qgroup rescan completion
Date: Mon,  6 May 2013 21:14:17 +0200
Message-Id: <1367867657-4630-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_qgroup_wait_for_completion waits until the currently running qgroup
operation completes. It returns immediately when no rescan process is in
progress. This is useful to automate things around the rescan process (e.g.
testing).

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.h           |    2 ++
 fs/btrfs/ioctl.c           |   12 ++++++++++++
 fs/btrfs/qgroup.c          |   21 +++++++++++++++++++++
 include/uapi/linux/btrfs.h |    1 +
 4 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8624f49..39ca0d9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1607,6 +1607,7 @@ struct btrfs_fs_info {
 	struct mutex qgroup_rescan_lock; /* protects the progress item */
 	struct btrfs_key qgroup_rescan_progress;
 	struct btrfs_workers qgroup_rescan_workers;
+	struct completion qgroup_rescan_completion;
 
 	/* filesystem state */
 	unsigned long fs_state;
@@ -3836,6 +3837,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
+int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info);
 int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5e93bb8..9161660 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3937,6 +3937,16 @@ static long btrfs_ioctl_quota_rescan_status(struct file *file, void __user *arg)
 	return ret;
 }
 
+static long btrfs_ioctl_quota_rescan_wait(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return btrfs_qgroup_wait_for_completion(root->fs_info);
+}
+
 static long btrfs_ioctl_set_received_subvol(struct file *file,
 					    void __user *arg)
 {
@@ -4179,6 +4189,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_quota_rescan(file, argp);
 	case BTRFS_IOC_QUOTA_RESCAN_STATUS:
 		return btrfs_ioctl_quota_rescan_status(file, argp);
+	case BTRFS_IOC_QUOTA_RESCAN_WAIT:
+		return btrfs_ioctl_quota_rescan_wait(file, argp);
 	case BTRFS_IOC_DEV_REPLACE:
 		return btrfs_ioctl_dev_replace(root, argp);
 	case BTRFS_IOC_GET_FSLABEL:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9d49c58..ebca17a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2068,6 +2068,8 @@ out:
 	} else {
 		pr_err("btrfs: qgroup scan failed with %d\n", err);
 	}
+
+	complete_all(&fs_info->qgroup_rescan_completion);
 }
 
 static void
@@ -2108,6 +2110,7 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 	fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 	memset(&fs_info->qgroup_rescan_progress, 0,
 		sizeof(fs_info->qgroup_rescan_progress));
+	init_completion(&fs_info->qgroup_rescan_completion);
 
 	/* clear all current qgroup tracking information */
 	for (n = rb_first(&fs_info->qgroup_tree); n; n = rb_next(n)) {
@@ -2124,3 +2127,21 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 
 	return 0;
 }
+
+int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info)
+{
+	int running;
+	int ret = 0;
+
+	mutex_lock(&fs_info->qgroup_rescan_lock);
+	spin_lock(&fs_info->qgroup_lock);
+	running = fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+	spin_unlock(&fs_info->qgroup_lock);
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+
+	if (running)
+		ret = wait_for_completion_interruptible(
+					&fs_info->qgroup_rescan_completion);
+
+	return ret;
+}
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ef0df5..5b683b5 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -530,6 +530,7 @@ struct btrfs_ioctl_send_args {
 			       struct btrfs_ioctl_quota_rescan_args)
 #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
 			       struct btrfs_ioctl_quota_rescan_args)
+#define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
 #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
 				   char[BTRFS_LABEL_SIZE])
 #define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
-- 
1.7.1

