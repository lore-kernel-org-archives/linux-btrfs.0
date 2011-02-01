From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 2/7] pulled current kernel version of ioctl.h
Date: Tue,  1 Feb 2011 14:54:45 +0100
Message-ID: <1296568490-13264-3-git-send-email-list.btrfs@jan-o-sch.net>
References: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
Cc: chris.mason@oracle.com, sensille@gmx.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 ioctl.h |   53 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index 776d7a9..b66cc29 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -23,13 +23,33 @@
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
-#define BTRFS_PATH_NAME_MAX 4087
 
+/* this should be 4k */
+#define BTRFS_PATH_NAME_MAX 4087
 struct btrfs_ioctl_vol_args {
 	__s64 fd;
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+#define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
+#define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+
+#define BTRFS_SUBVOL_NAME_MAX 4039
+struct btrfs_ioctl_vol_args_v2 {
+	__s64 fd;
+	__u64 transid;
+	__u64 flags;
+	__u64 unused[4];
+	char name[BTRFS_SUBVOL_NAME_MAX + 1];
+};
+
+#define BTRFS_INO_LOOKUP_PATH_MAX 4080
+struct btrfs_ioctl_ino_lookup_args {
+	__u64 treeid;
+	__u64 objectid;
+	char name[BTRFS_INO_LOOKUP_PATH_MAX];
+};
+
 struct btrfs_ioctl_search_key {
 	/* which root are we searching.  0 is the tree of tree roots */
 	__u64 tree_id;
@@ -85,11 +105,10 @@ struct btrfs_ioctl_search_args {
 	char buf[BTRFS_SEARCH_ARGS_BUFSIZE];
 };
 
-#define BTRFS_INO_LOOKUP_PATH_MAX 4080
-struct btrfs_ioctl_ino_lookup_args {
-	__u64 treeid;
-	__u64 objectid;
-	char name[BTRFS_INO_LOOKUP_PATH_MAX];
+struct btrfs_ioctl_clone_range_args {
+  __s64 src_fd;
+  __u64 src_offset, src_length;
+  __u64 dest_offset;
 };
 
 /* flags for the defrag range ioctl */
@@ -116,8 +135,15 @@ struct btrfs_ioctl_defrag_range_args {
 	 */
 	__u32 extent_thresh;
 
+	/*
+	 * which compression method to use if turning on compression
+	 * for this defrag operation.  If unspecified, zlib will
+	 * be used
+	 */
+	__u32 compress_type;
+
 	/* spare for later */
-	__u32 unused[5];
+	__u32 unused[4];
 };
 
 struct btrfs_ioctl_space_info {
@@ -155,11 +181,14 @@ struct btrfs_ioctl_space_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)
-/* 13 is for CLONE_RANGE */
+
+#define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
+				  struct btrfs_ioctl_clone_range_args)
+
 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
-				   struct btrfs_ioctl_vol_args)
+				struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG_RANGE _IOW(BTRFS_IOCTL_MAGIC, 16, \
 				struct btrfs_ioctl_defrag_range_args)
 #define BTRFS_IOC_TREE_SEARCH _IOWR(BTRFS_IOCTL_MAGIC, 17, \
@@ -169,4 +198,10 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
+#define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
+#define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
+				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
+#define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
 #endif
-- 
1.7.2.2

