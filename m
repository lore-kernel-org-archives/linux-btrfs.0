Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49592 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423915AbcBRIHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 03:07:35 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH RFC] btrfs: make add and device ioctl args path max consistent
Date: Thu, 18 Feb 2016 16:07:16 +0800
Message-Id: <1455782837-15630-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455782837-15630-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1455782837-15630-1-git-send-email-anand.jain@oracle.com>

Add device ioctl uses BTRFS_PATH_NAME_MAX however delete
uses BTRFS_SUBVOL_NAME_MAX for device path.  This patch makes
them consistent.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c           |  2 +-
 include/uapi/linux/btrfs.h | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1f72f8ed38f5..15fc91291c40 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2672,7 +2672,7 @@ out:
 static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 {
 	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
-	struct btrfs_ioctl_vol_args_v2 *vol_args;
+	struct btrfs_ioctl_vol_args_v3 *vol_args;
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 3975e683af72..3d58182b68e8 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -90,6 +90,23 @@ struct btrfs_ioctl_vol_args_v2 {
 	};
 };
 
+struct btrfs_ioctl_vol_args_v3 {
+	__s64 fd;
+	__u64 transid;
+	__u64 flags;
+	union {
+		struct {
+			__u64 size;
+			struct btrfs_qgroup_inherit __user *qgroup_inherit;
+		};
+		__u64 unused[4];
+	};
+	union {
+		char name[BTRFS_PATH_NAME_MAX + 1];
+		u64 devid;
+	};
+};
+
 /*
  * structure to report errors and progress to userspace, either as a
  * result of a finished scrub, a canceled scrub or a progress inquiry
@@ -671,6 +688,6 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
-				   struct btrfs_ioctl_vol_args_v2)
+				   struct btrfs_ioctl_vol_args_v3)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.7.0

