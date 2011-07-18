From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v3 2/5] btrfs-progs: scrub ioctls
Date: Mon, 18 Jul 2011 14:37:22 +0200
Message-ID: <fa659061910569495fd5685385ba0c087987937c.1310990184.git.list.btrfs@jan-o-sch.net>
References: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

- scrub structs added
- ioctls for scrub
- BTRFS_FSID_SIZE moved

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 ctree.h |    2 +-
 ioctl.h |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/ctree.h b/ctree.h
index 61eb639..6e1b80b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -24,6 +24,7 @@
 #include "radix-tree.h"
 #include "extent-cache.h"
 #include "extent_io.h"
+#include "ioctl.h"
 
 struct btrfs_root;
 struct btrfs_trans_handle;
@@ -250,7 +251,6 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 		sizeof(struct btrfs_stripe) * (num_stripes - 1);
 }
 
-#define BTRFS_FSID_SIZE 16
 #define BTRFS_HEADER_FLAG_WRITTEN		(1ULL << 0)
 #define BTRFS_HEADER_FLAG_RELOC			(1ULL << 1)
 #define BTRFS_SUPER_FLAG_SEEDING		(1ULL << 32)
diff --git a/ioctl.h b/ioctl.h
index 7be1177..11730d2 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -23,8 +23,9 @@
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
-#define BTRFS_PATH_NAME_MAX 4087
 
+/* this should be 4k */
+#define BTRFS_PATH_NAME_MAX 4087
 struct btrfs_ioctl_vol_args {
 	__s64 fd;
 	char name[BTRFS_PATH_NAME_MAX + 1];
@@ -44,6 +45,52 @@ struct btrfs_ioctl_vol_args_v2 {
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
 
+struct btrfs_scrub_progress {
+	__u64 data_extents_scrubbed;
+	__u64 tree_extents_scrubbed;
+	__u64 data_bytes_scrubbed;
+	__u64 tree_bytes_scrubbed;
+	__u64 read_errors;
+	__u64 csum_errors;
+	__u64 verify_errors;
+	__u64 no_csum;
+	__u64 csum_discards;
+	__u64 super_errors;
+	__u64 malloc_errors;
+	__u64 uncorrectable_errors;
+	__u64 corrected_errors;
+	__u64 last_physical;
+	__u64 unverified_errors;
+};
+
+#define BTRFS_SCRUB_READONLY	1
+struct btrfs_ioctl_scrub_args {
+	__u64 devid;				/* in */
+	__u64 start;				/* in */
+	__u64 end;				/* in */
+	__u64 flags;				/* in */
+	struct btrfs_scrub_progress progress;	/* out */
+	/* pad to 1k */
+	__u64 unused[(1024-32-sizeof(struct btrfs_scrub_progress))/8];
+};
+
+#define BTRFS_DEVICE_PATH_NAME_MAX 1024
+struct btrfs_ioctl_dev_info_args {
+	__u64 devid;				/* in/out */
+	__u8 uuid[BTRFS_UUID_SIZE];		/* in/out */
+	__u64 bytes_used;			/* out */
+	__u64 total_bytes;			/* out */
+	__u64 unused[379];			/* pad to 4k */
+	__u8 path[BTRFS_DEVICE_PATH_NAME_MAX];	/* out */
+};
+
+struct btrfs_ioctl_fs_info_args {
+	__u64 max_id;				/* out */
+	__u64 num_devices;			/* out */
+	__u8 fsid[BTRFS_FSID_SIZE];		/* out */
+	__u64 reserved[124];			/* pad to 1k */
+};
+
 struct btrfs_ioctl_search_key {
 	/* which root are we searching.  0 is the tree of tree roots */
 	__u64 tree_id;
@@ -234,6 +281,11 @@ struct btrfs_ioctl_balance_start {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
+				struct btrfs_ioctl_scrub_args)
+#define BTRFS_IOC_SCRUB_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
+#define BTRFS_IOC_SCRUB_PROGRESS _IOWR(BTRFS_IOCTL_MAGIC, 29, \
+					struct btrfs_ioctl_scrub_args)
 #define BTRFS_IOC_DEV_INFO _IOWR(BTRFS_IOCTL_MAGIC, 30, \
                                  struct btrfs_ioctl_dev_info_args)
 #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
-- 
1.7.3.4

