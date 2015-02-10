Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24217 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754844AbbBJK0u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:50 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQ4PR000879
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:04 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH 9/9] btrfs: qgroup: obtain quota status
Date: Tue, 10 Feb 2015 18:23:23 +0800
Message-ID: <1423563803-8996-12-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>

add a function to obtain quota status. Now it can only get
whether quota is enabled. We can extend the function to get
more quota status

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c           |  6 ++++++
 fs/btrfs/qgroup.c          | 14 ++++++++++++++
 fs/btrfs/qgroup.h          |  3 +++
 include/uapi/linux/btrfs.h |  3 +++
 4 files changed, 26 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 658d83d..f6e730b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4572,6 +4572,12 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	case BTRFS_QUOTA_CTL_DISABLE:
 		ret = btrfs_quota_disable(trans, root->fs_info);
 		break;
+	case BTRFS_QUOTA_CTL_STATUS:
+		ret = btrfs_quota_status(trans, root->fs_info, sa);
+		if (!ret)
+			if (copy_to_user(arg, sa, sizeof(*sa)))
+				ret = -EFAULT;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 24c5bb1..b57fe45 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -993,6 +993,20 @@ out:
 	return ret;
 }
 
+int btrfs_quota_status(struct btrfs_trans_handle *trans,
+			struct btrfs_fs_info *fs_info,
+			struct btrfs_ioctl_quota_ctl_args *sa)
+{
+	int ret = 0;
+
+	if (fs_info->quota_enabled)
+		sa->status |= BTRFS_QUOTA_STATUS_QUOTA_ENABLED;
+	else
+		sa->status &= ~BTRFS_QUOTA_STATUS_QUOTA_ENABLED;
+
+	return ret;
+}
+
 static void qgroup_dirty(struct btrfs_fs_info *fs_info,
 			 struct btrfs_qgroup *qgroup)
 {
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index c5242aa..52d8b19 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -62,6 +62,9 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info);
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
+int btrfs_quota_status(struct btrfs_trans_handle *trans,
+			struct btrfs_fs_info *fs_info,
+			struct btrfs_ioctl_quota_ctl_args *sa);
 int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
 void btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info);
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 611e1c5..d4014e6 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -423,6 +423,9 @@ struct btrfs_ioctl_get_dev_stats {
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
 #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
+#define BTRFS_QUOTA_CTL_STATUS  4
+
+#define BTRFS_QUOTA_STATUS_QUOTA_ENABLED 1
 struct btrfs_ioctl_quota_ctl_args {
 	__u64 cmd;
 	__u64 status;
-- 
1.8.4.2

