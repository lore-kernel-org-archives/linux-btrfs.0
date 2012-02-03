From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 1/3] Btrfs-progs: add restriper headers
Date: Fri,  3 Feb 2012 23:49:10 +0200
Message-ID: <1328305752-32160-2-git-send-email-idryomov@gmail.com>
References: <1328305752-32160-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1328305752-32160-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add restriper headers and update print-tree.c

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 ctree.h      |   23 ++++++++++++++++-------
 ioctl.h      |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 print-tree.c |    6 ++++++
 volumes.h    |   31 +++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 7 deletions(-)

diff --git a/ctree.h b/ctree.h
index 54748c8..1c3740c 100644
--- a/ctree.h
+++ b/ctree.h
@@ -61,6 +61,9 @@ struct btrfs_trans_handle;
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
 
 
+/* for storing balance parameters in the root tree */
+#define BTRFS_BALANCE_OBJECTID -4ULL
+
 /* oprhan objectid for tracking unlinked/truncated files */
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
@@ -697,13 +700,17 @@ struct btrfs_csum_item {
 } __attribute__ ((__packed__));
 
 /* tag for the radix tree of block groups in ram */
-#define BTRFS_BLOCK_GROUP_DATA     (1 << 0)
-#define BTRFS_BLOCK_GROUP_SYSTEM   (1 << 1)
-#define BTRFS_BLOCK_GROUP_METADATA (1 << 2)
-#define BTRFS_BLOCK_GROUP_RAID0    (1 << 3)
-#define BTRFS_BLOCK_GROUP_RAID1    (1 << 4)
-#define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
-#define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
+#define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
+#define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
+#define BTRFS_BLOCK_GROUP_METADATA	(1ULL << 2)
+#define BTRFS_BLOCK_GROUP_RAID0		(1ULL << 3)
+#define BTRFS_BLOCK_GROUP_RAID1		(1ULL << 4)
+#define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
+#define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
+#define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
+
+/* used in struct btrfs_balance_args fields */
+#define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
 
 struct btrfs_block_group_item {
 	__le64 used;
@@ -911,6 +918,8 @@ struct btrfs_root {
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
 
+#define BTRFS_BALANCE_ITEM_KEY	248
+
 /*
  * string items are for debugging.  They just store a short string of
  * data in the FS
diff --git a/ioctl.h b/ioctl.h
index 1ae7537..f2e5d8d 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -91,6 +91,54 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 reserved[124];			/* pad to 1k */
 };
 
+/* balance control ioctl modes */
+#define BTRFS_BALANCE_CTL_PAUSE		1
+#define BTRFS_BALANCE_CTL_CANCEL	2
+#define BTRFS_BALANCE_CTL_RESUME	3
+
+/*
+ * this is packed, because it should be exactly the same as its disk
+ * byte order counterpart (struct btrfs_disk_balance_args)
+ */
+struct btrfs_balance_args {
+	__u64 profiles;
+	__u64 usage;
+	__u64 devid;
+	__u64 pstart;
+	__u64 pend;
+	__u64 vstart;
+	__u64 vend;
+
+	__u64 target;
+
+	__u64 flags;
+
+	__u64 unused[8];
+} __attribute__ ((__packed__));
+
+struct btrfs_balance_progress {
+	__u64 expected;
+	__u64 considered;
+	__u64 completed;
+};
+
+#define BTRFS_BALANCE_STATE_RUNNING	(1ULL << 0)
+#define BTRFS_BALANCE_STATE_PAUSE_REQ	(1ULL << 1)
+#define BTRFS_BALANCE_STATE_CANCEL_REQ	(1ULL << 2)
+
+struct btrfs_ioctl_balance_args {
+	__u64 flags;				/* in/out */
+	__u64 state;				/* out */
+
+	struct btrfs_balance_args data;		/* in/out */
+	struct btrfs_balance_args meta;		/* in/out */
+	struct btrfs_balance_args sys;		/* in/out */
+
+	struct btrfs_balance_progress stat;	/* out */
+
+	__u64 unused[72];			/* pad to 1k */
+};
+
 struct btrfs_ioctl_search_key {
 	/* which root are we searching.  0 is the tree of tree roots */
 	__u64 tree_id;
@@ -273,6 +321,11 @@ struct btrfs_ioctl_logical_ino_args {
 					struct btrfs_ioctl_dev_info_args)
 #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
                                  struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_BALANCE_V2 _IOWR(BTRFS_IOCTL_MAGIC, 32, \
+				   struct btrfs_ioctl_balance_args)
+#define BTRFS_IOC_BALANCE_CTL _IOW(BTRFS_IOCTL_MAGIC, 33, int)
+#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 34, \
+					struct btrfs_ioctl_balance_args)
 #define BTRFS_IOC_INO_PATHS _IOWR(BTRFS_IOCTL_MAGIC, 35, \
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
diff --git a/print-tree.c b/print-tree.c
index 6039699..494ba8b 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -351,6 +351,9 @@ static void print_key_type(u8 type)
 	case BTRFS_DEV_EXTENT_KEY:
 		printf("DEV_EXTENT");
 		break;
+	case BTRFS_BALANCE_ITEM_KEY:
+		printf("BALANCE_ITEM");
+		break;
 	case BTRFS_STRING_ITEM_KEY:
 		printf("STRING_ITEM");
 		break;
@@ -391,6 +394,9 @@ static void print_objectid(unsigned long long objectid, u8 type)
 	case BTRFS_CSUM_TREE_OBJECTID:
 		printf("CSUM_TREE");
 		break;
+	case BTRFS_BALANCE_OBJECTID:
+		printf("BALANCE");
+		break;
 	case BTRFS_ORPHAN_OBJECTID:
 		printf("ORPHAN");
 		break;
diff --git a/volumes.h b/volumes.h
index 7104d36..d7fcef6 100644
--- a/volumes.h
+++ b/volumes.h
@@ -91,6 +91,37 @@ struct btrfs_multi_bio {
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
+/*
+ * Restriper's general type filter
+ */
+#define BTRFS_BALANCE_DATA		(1ULL << 0)
+#define BTRFS_BALANCE_SYSTEM		(1ULL << 1)
+#define BTRFS_BALANCE_METADATA		(1ULL << 2)
+
+#define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
+					 BTRFS_BALANCE_SYSTEM |	    \
+					 BTRFS_BALANCE_METADATA)
+
+#define BTRFS_BALANCE_FORCE		(1ULL << 3)
+#define BTRFS_BALANCE_RESUME		(1ULL << 4)
+
+/*
+ * Balance filters
+ */
+#define BTRFS_BALANCE_ARGS_PROFILES	(1ULL << 0)
+#define BTRFS_BALANCE_ARGS_USAGE	(1ULL << 1)
+#define BTRFS_BALANCE_ARGS_DEVID	(1ULL << 2)
+#define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
+#define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
+
+/*
+ * Profile changing flags.  When SOFT is set we won't relocate chunk if
+ * it already has the target profile (even though it may be
+ * half-filled).
+ */
+#define BTRFS_BALANCE_ARGS_CONVERT	(1ULL << 8)
+#define BTRFS_BALANCE_ARGS_SOFT		(1ULL << 9)
+
 int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   struct btrfs_device *device,
 			   u64 chunk_tree, u64 chunk_objectid,
-- 
1.7.6.3

