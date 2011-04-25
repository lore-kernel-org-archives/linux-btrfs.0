From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: [PATCH 3/5] Added support for an additional ioctl.
Date: Mon, 25 Apr 2011 15:47:59 +0200
Message-ID: <1303739282-1675-4-git-send-email-philipp.andreas@gmail.com>
References: <1303733730-sup-9388@think>
 <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com>
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	chris.mason@oracle.com, dcrmorgado@gmail.com, lizf@cn.fujitsu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Added BTRFS_IOC_SNAP_CREATE_V2 and struct btrfs_ioctl_vol_args_v2 as
defined in fs/btrfs/ioctl.h in the kernel sources.

Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 ioctl.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index 776d7a9..358f814 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -30,6 +30,17 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+#define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+#define BTRFS_SUBVOL_NAME_MAX 4039
+
+struct btrfs_ioctl_vol_args_v2 {
+	__s64 fd;
+	__u64 transid;
+	__u64 flags;
+	__u64 unused[4];
+	char name[BTRFS_SUBVOL_NAME_MAX + 1];
+};
+
 struct btrfs_ioctl_search_key {
 	/* which root are we searching.  0 is the tree of tree roots */
 	__u64 tree_id;
@@ -132,6 +143,7 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+/* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -169,4 +181,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
+				   struct btrfs_ioctl_vol_args_v2)
 #endif
-- 
1.7.4.1

