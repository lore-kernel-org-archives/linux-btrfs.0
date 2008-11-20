From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs-progs: add support for compat flags
Date: Thu, 20 Nov 2008 13:53:58 -0500
Message-ID: <20081120185357.GD3013@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch updates btrfs-progs with the disk format changes for the
compatability flags.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff --git a/ctree.h b/ctree.h
index a58f757..bce36e3 100644
--- a/ctree.h
+++ b/ctree.h
@@ -289,6 +289,9 @@ struct btrfs_super_block {
 	__le32 stripesize;
 	__le32 sys_chunk_array_size;
 	__le64 chunk_root_generation;
+	__le64 compat_flags;
+	__le64 compat_ro_flags;
+	__le64 incompat_flags;
 	u8 root_level;
 	u8 chunk_root_level;
 	u8 log_root_level;
@@ -298,6 +301,14 @@ struct btrfs_super_block {
 } __attribute__ ((__packed__));
 
 /*
+ * Compat flags that we support.  If any incompat flags are set other than the
+ * ones specified below then we will fail to mount
+ */
+#define BTRFS_FEATURE_COMPAT_SUPP	0x0
+#define BTRFS_FEATURE_COMPAT_RO_SUPP	0x0
+#define BTRFS_FEATURE_INCOMPAT_SUPP	0x0
+
+/*
  * A leaf is full of items. offset and size tell us where to find
  * the item in the leaf (relative to the start of the data area)
  */
@@ -412,8 +423,7 @@ struct btrfs_inode_item {
 	__le32 gid;
 	__le32 mode;
 	__le64 rdev;
-	__le16 flags;
-	__le16 compat_flags;
+	__le64 flags;
 
 	struct btrfs_timespec atime;
 	struct btrfs_timespec ctime;
@@ -437,7 +447,7 @@ struct btrfs_root_item {
 	__le64 byte_limit;
 	__le64 bytes_used;
 	__le64 last_snapshot;
-	__le32 flags;
+	__le64 flags;
 	__le32 refs;
 	struct btrfs_disk_key drop_progress;
 	u8 drop_level;
@@ -915,9 +925,7 @@ BTRFS_SETGET_FUNCS(inode_uid, struct btrfs_inode_item, uid, 32);
 BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
-BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 16);
-BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item,
-		   compat_flags, 16);
+BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
 
 BTRFS_SETGET_STACK_FUNCS(stack_inode_generation,
 			 struct btrfs_inode_item, generation, 64);
@@ -938,9 +946,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_mode,
 BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev,
 			 struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_flags,
-			 struct btrfs_inode_item, flags, 16);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_compat_flags,
-			 struct btrfs_inode_item, compat_flags, 16);
+			 struct btrfs_inode_item, flags, 64);
 
 static inline struct btrfs_timespec *
 btrfs_inode_atime(struct btrfs_inode_item *inode_item)
@@ -1298,7 +1304,7 @@ BTRFS_SETGET_STACK_FUNCS(root_bytenr, struct btrfs_root_item, bytenr, 64);
 BTRFS_SETGET_STACK_FUNCS(root_level, struct btrfs_root_item, level, 8);
 BTRFS_SETGET_STACK_FUNCS(root_dirid, struct btrfs_root_item, root_dirid, 64);
 BTRFS_SETGET_STACK_FUNCS(root_refs, struct btrfs_root_item, refs, 32);
-BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 32);
+BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
 BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
@@ -1341,6 +1347,12 @@ BTRFS_SETGET_STACK_FUNCS(super_root_dir, struct btrfs_super_block,
 			 root_dir_objectid, 64);
 BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct btrfs_super_block,
 			 num_devices, 64);
+BTRFS_SETGET_STACK_FUNCS(super_compat_flags, struct btrfs_super_block,
+			 compat_flags, 64);
+BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block,
+			 compat_flags, 64);
+BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
+			 incompat_flags, 64);
 
 static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
 {
