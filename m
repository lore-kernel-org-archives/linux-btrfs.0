From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] add support for compat flags to btrfs
Date: Thu, 20 Nov 2008 13:52:59 -0500
Message-ID: <20081120185259.GC3013@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This adds the necessary disk format stuff for handling compatibility flags in
the future to handle disk format changes.  We have a compat_flags,
compat_ro_flags and incompat_flags set for the super block.  Compat flags will
be to hold the features that are compatible with older versions of btrfs,
compat_ro flags have features that are compatible with older versions of btrfs
if the fs is mounted read only, and incompat_flags has features that are
incompatible with older versions of btrfs.  This also axes the compat_flags
field for the inode and just makes the flags field a 64bit field, and changes
the root item flags field to 64bit.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 166896d..b5af1fc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -305,6 +305,9 @@ struct btrfs_super_block {
 	__le32 stripesize;
 	__le32 sys_chunk_array_size;
 	__le64 chunk_root_generation;
+	__le64 compat_flags;
+	__le64 compat_ro_flags;
+	__le64 incompat_flags;
 	u8 root_level;
 	u8 chunk_root_level;
 	u8 log_root_level;
@@ -314,6 +317,14 @@ struct btrfs_super_block {
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
@@ -433,8 +444,7 @@ struct btrfs_inode_item {
 	__le32 gid;
 	__le32 mode;
 	__le64 rdev;
-	__le16 flags;
-	__le16 compat_flags;
+	__le64 flags;
 
 	struct btrfs_timespec atime;
 	struct btrfs_timespec ctime;
@@ -462,7 +472,7 @@ struct btrfs_root_item {
 	__le64 byte_limit;
 	__le64 bytes_used;
 	__le64 last_snapshot;
-	__le32 flags;
+	__le64 flags;
 	__le32 refs;
 	struct btrfs_disk_key drop_progress;
 	u8 drop_level;
@@ -1116,9 +1126,7 @@ BTRFS_SETGET_FUNCS(inode_uid, struct btrfs_inode_item, uid, 32);
 BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
-BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 16);
-BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item,
-		   compat_flags, 16);
+BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
 
 static inline struct btrfs_timespec *
 btrfs_inode_atime(struct btrfs_inode_item *inode_item)
@@ -1468,7 +1476,7 @@ BTRFS_SETGET_STACK_FUNCS(root_bytenr, struct btrfs_root_item, bytenr, 64);
 BTRFS_SETGET_STACK_FUNCS(root_level, struct btrfs_root_item, level, 8);
 BTRFS_SETGET_STACK_FUNCS(root_dirid, struct btrfs_root_item, root_dirid, 64);
 BTRFS_SETGET_STACK_FUNCS(root_refs, struct btrfs_root_item, refs, 32);
-BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 32);
+BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
 BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
@@ -1510,6 +1518,12 @@ BTRFS_SETGET_STACK_FUNCS(super_root_dir, struct btrfs_super_block,
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
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c8dcb47..58ce2a0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1433,6 +1433,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	u32 blocksize;
 	u32 stripesize;
 	u64 generation;
+	u64 features;
 	struct btrfs_key location;
 	struct buffer_head *bh;
 	struct btrfs_root *extent_root = kzalloc(sizeof(struct btrfs_root),
@@ -1585,6 +1586,26 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 
+	features = btrfs_super_incompat_flags(disk_super) &
+		~BTRFS_FEATURE_INCOMPAT_SUPP;
+	if (features) {
+		printk(KERN_ERR "BTRFS: couldn't mount because of "
+		       "unsupported optional features (%Lx).\n",
+		       features);
+		err = -EINVAL;
+		goto fail_sb_buffer;
+	}
+
+	features = btrfs_super_compat_ro_flags(disk_super) &
+		~BTRFS_FEATURE_COMPAT_RO_SUPP;
+	if (!(sb->s_flags & MS_RDONLY) && features) {
+		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
+		       "unsupported option features (%Lx).\n",
+		       features);
+		err = -EINVAL;
+		goto fail_sb_buffer;
+	}
+
 	/*
 	 * we need to start all the end_io workers up front because the
 	 * queue work function gets called at interrupt time, and so it
