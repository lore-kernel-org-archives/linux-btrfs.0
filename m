From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v1 2/3] scrub ioctls
Date: Sat, 12 Mar 2011 19:31:34 +0100
Message-ID: <b58428371473e52a6f2a8c3a2385cb748b3ad31a.1299954564.git.list.btrfs@jan-o-sch.net>
References: <cover.1299954564.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1299954564.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1299954564.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

- scrub structs added
- ioctls for scrub
- BTRFS_FSID_SIZE moved

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 ctree.h |    2 +-
 ioctl.h |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/ctree.h b/ctree.h
index b79e238..577365e 100644
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
index 776d7a9..0d7dd18 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -23,13 +23,70 @@
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
-#define BTRFS_PATH_NAME_MAX 4087
 
+/* this should be 4k */
+#define BTRFS_PATH_NAME_MAX 4087
 struct btrfs_ioctl_vol_args {
 	__s64 fd;
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+#define BTRFS_FSID_SIZE 16
+#define BTRFS_UUID_SIZE 16
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
+};
+
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
@@ -169,4 +226,13 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
+                             struct btrfs_ioctl_scrub_args)
+#define BTRFS_IOC_SCRUB_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
+#define BTRFS_IOC_SCRUB_PROGRESS _IOWR(BTRFS_IOCTL_MAGIC, 29, \
+                             struct btrfs_ioctl_scrub_args)
+#define BTRFS_IOC_DEV_INFO _IOWR(BTRFS_IOCTL_MAGIC, 30, \
+                                 struct btrfs_ioctl_dev_info_args)
+#define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
+                                 struct btrfs_ioctl_fs_info_args)
 #endif
-- 
1.7.3.4

