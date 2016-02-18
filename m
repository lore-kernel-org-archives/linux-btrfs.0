Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49638 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424672AbcBRIHl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 03:07:41 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH RFC] btrfs-progs: make add and delete path max len consistent
Date: Thu, 18 Feb 2016 16:07:17 +0800
Message-Id: <1455782837-15630-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455782837-15630-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1455782837-15630-1-git-send-email-anand.jain@oracle.com>

Add device ioctl uses BTRFS_PATH_NAME_MAX however delete
uses BTRFS_SUBVOL_NAME_MAX to hold device path. This patch
makes them consistent.

Depends on
  btrfs: make add and device ioctl args path max consistent

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c |  2 +-
 ioctl.h       | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 879ba94d7ea5..be07e34c2af8 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -160,7 +160,7 @@ static int _cmd_device_remove(int argc, char **argv,
 		struct	btrfs_ioctl_vol_args arg;
 		int	res;
 
-		struct btrfs_ioctl_vol_args_v2 argv2 = {0};
+		struct btrfs_ioctl_vol_args_v3 argv2 = {0};
 		int is_devid = 0;
 
 		if (string_is_numerical(argv[i])) {
diff --git a/ioctl.h b/ioctl.h
index 1560dcb4b457..8e444ca374fd 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -92,6 +92,23 @@ struct btrfs_ioctl_vol_args_v2 {
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
@@ -689,7 +706,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
                                   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
-				   struct btrfs_ioctl_vol_args_v2)
+				   struct btrfs_ioctl_vol_args_v3)
 #ifdef __cplusplus
 }
 #endif
-- 
2.7.0

