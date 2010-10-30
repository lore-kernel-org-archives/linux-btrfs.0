From: Sage Weil <sage@newdream.net>
Subject: [PATCH 1/3] update ioctl.h from 2.6.37-rc1
Date: Sat, 30 Oct 2010 10:56:04 -0700
Message-ID: <1288461366-26914-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Sage Weil <sage@newdream.net>
---
 ioctl.h |   39 ++++++++++++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index 776d7a9..5a03317 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -23,13 +23,28 @@
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
-#define BTRFS_PATH_NAME_MAX 4087
 
+/* this should be 4k */
+#define BTRFS_PATH_NAME_MAX 4087
 struct btrfs_ioctl_vol_args {
 	__s64 fd;
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+#define BTRFS_SNAPSHOT_NAME_MAX 4079
+struct btrfs_ioctl_async_vol_args {
+	__s64 fd;
+	__u64 transid;
+	char name[BTRFS_SNAPSHOT_NAME_MAX + 1];
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
@@ -72,7 +87,7 @@ struct btrfs_ioctl_search_header {
 	__u64 offset;
 	__u32 type;
 	__u32 len;
-} __attribute__((may_alias));
+};
 
 #define BTRFS_SEARCH_ARGS_BUFSIZE (4096 - sizeof(struct btrfs_ioctl_search_key))
 /*
@@ -85,11 +100,10 @@ struct btrfs_ioctl_search_args {
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
@@ -155,11 +169,14 @@ struct btrfs_ioctl_space_args {
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
@@ -169,4 +186,8 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
+#define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
+#define BTRFS_IOC_SNAP_CREATE_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 23, \
+				   struct btrfs_ioctl_async_vol_args)
 #endif
-- 
1.7.1

