Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28788 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbaDIHJ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 03:09:28 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v9 02/16] Btrfs: introduce dedup tree and relatives
Date: Wed,  9 Apr 2014 15:08:30 +0800
Message-Id: <1397027325-27151-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
References: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparation step for online/inband dedup tree.
It introduces dedup tree and its relatives, including hash driver and
some structures.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h             | 73 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c           | 36 ++++++++++++++++++++++
 fs/btrfs/extent-tree.c       |  2 ++
 include/trace/events/btrfs.h |  3 +-
 4 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2a9d32e..54c29d2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -33,6 +33,7 @@
 #include <asm/kmap_types.h>
 #include <linux/pagemap.h>
 #include <linux/btrfs.h>
+#include <crypto/hash.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
@@ -101,6 +102,9 @@ struct btrfs_ordered_sum;
 /* for storing items that use the BTRFS_UUID_KEY* types */
 #define BTRFS_UUID_TREE_OBJECTID 9ULL
 
+/* dedup tree(experimental) */
+#define BTRFS_DEDUP_TREE_OBJECTID 10ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -523,6 +527,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_DEDUP		(1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
@@ -540,6 +545,7 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
+	 BTRFS_FEATURE_INCOMPAT_DEDUP |			\
 	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
@@ -915,6 +921,51 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+/* dedup */
+enum btrfs_dedup_type {
+	BTRFS_DEDUP_SHA256 = 0,
+	BTRFS_DEDUP_LAST = 1,
+};
+
+static int btrfs_dedup_lens[] = { 4, 0 };
+static int btrfs_dedup_sizes[] = { 32, 0 };	/* 256bit, 32bytes */
+
+struct btrfs_dedup_item {
+	/* disk length of dedup range */
+	__le64 len;
+
+	u8 type;
+	u8 compression;
+	u8 encryption;
+
+	/* spare for later use */
+	__le16 other_encoding;
+
+	/* hash/fingerprints go here */
+} __attribute__ ((__packed__));
+
+struct btrfs_dedup_hash {
+	u64 bytenr;
+	u64 num_bytes;
+
+	/* hash algorithm */
+	int type;
+
+	int compression;
+
+	/* last field is a variable length array of dedup hash */
+	u64 hash[];
+};
+
+static inline int btrfs_dedup_hash_size(int type)
+{
+	WARN_ON((btrfs_dedup_lens[type] * sizeof(u64)) !=
+		 btrfs_dedup_sizes[type]);
+
+	return sizeof(struct btrfs_dedup_hash) + btrfs_dedup_sizes[type];
+}
+
+
 struct btrfs_dev_stats_item {
 	/*
 	 * grow this item struct at the end for future enhancements and keep
@@ -1320,6 +1371,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *dev_root;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *csum_root;
+	struct btrfs_root *dedup_root;
 	struct btrfs_root *quota_root;
 	struct btrfs_root *uuid_root;
 
@@ -1680,6 +1732,14 @@ struct btrfs_fs_info {
 
 	struct semaphore uuid_tree_rescan_sem;
 	unsigned int update_uuid_tree_gen:1;
+
+	/* reference to deduplication algorithm driver via cryptoapi */
+	struct crypto_shash *dedup_driver;
+
+	/* dedup blocksize */
+	u64 dedup_bs;
+
+	int dedup_type;
 };
 
 struct btrfs_subvolume_writers {
@@ -2013,6 +2073,8 @@ struct btrfs_ioctl_defrag_range_args {
  */
 #define BTRFS_STRING_ITEM_KEY	253
 
+#define BTRFS_DEDUP_ITEM_KEY	254
+
 /*
  * Flags for mount options.
  *
@@ -3047,6 +3109,14 @@ static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
 }
 
 
+/* btrfs_dedup_item */
+BTRFS_SETGET_FUNCS(dedup_len, struct btrfs_dedup_item, len, 64);
+BTRFS_SETGET_FUNCS(dedup_compression, struct btrfs_dedup_item, compression, 8);
+BTRFS_SETGET_FUNCS(dedup_encryption, struct btrfs_dedup_item, encryption, 8);
+BTRFS_SETGET_FUNCS(dedup_other_encoding, struct btrfs_dedup_item,
+		   other_encoding, 16);
+BTRFS_SETGET_FUNCS(dedup_type, struct btrfs_dedup_item, type, 8);
+
 /* btrfs_dev_stats_item */
 static inline u64 btrfs_dev_stats_value(struct extent_buffer *eb,
 					struct btrfs_dev_stats_item *ptr,
@@ -3521,6 +3591,8 @@ static inline int btrfs_need_cleaner_sleep(struct btrfs_root *root)
 
 static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 {
+	if (fs_info->dedup_driver)
+		crypto_free_shash(fs_info->dedup_driver);
 	kfree(fs_info->balance_ctl);
 	kfree(fs_info->delayed_root);
 	kfree(fs_info->extent_root);
@@ -3687,6 +3759,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		       struct bio *bio, u64 file_start, int contig);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
+
 /* inode.c */
 struct btrfs_delalloc_work {
 	struct inode *inode;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d9698fd..adc7e90e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -153,6 +153,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_FS_TREE_OBJECTID,		.name_stem = "fs"	},
 	{ .id = BTRFS_CSUM_TREE_OBJECTID,	.name_stem = "csum"	},
 	{ .id = BTRFS_QUOTA_TREE_OBJECTID,	.name_stem = "quota"	},
+	{ .id = BTRFS_DEDUP_TREE_OBJECTID,	.name_stem = "dedup"	},
 	{ .id = BTRFS_TREE_LOG_OBJECTID,	.name_stem = "log"	},
 	{ .id = BTRFS_TREE_RELOC_OBJECTID,	.name_stem = "treloc"	},
 	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	.name_stem = "dreloc"	},
@@ -1622,6 +1623,9 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_UUID_TREE_OBJECTID)
 		return fs_info->uuid_root ? fs_info->uuid_root :
 					    ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_DEDUP_TREE_OBJECTID)
+		return fs_info->dedup_root ? fs_info->dedup_root :
+					     ERR_PTR(-ENOENT);
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root) {
@@ -2072,6 +2076,7 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	free_root_extent_buffers(info->csum_root);
 	free_root_extent_buffers(info->quota_root);
 	free_root_extent_buffers(info->uuid_root);
+	free_root_extent_buffers(info->dedup_root);
 	if (chunk_root)
 		free_root_extent_buffers(info->chunk_root);
 }
@@ -2113,6 +2118,19 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
 	}
 }
 
+static struct crypto_shash *
+btrfs_build_dedup_driver(struct btrfs_fs_info *info)
+{
+	switch (info->dedup_type) {
+	case BTRFS_DEDUP_SHA256:
+		return crypto_alloc_shash("sha256", 0, 0);
+	default:
+		pr_err("btrfs: unrecognized dedup type\n");
+		break;
+	}
+	return ERR_PTR(-EINVAL);
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2135,6 +2153,7 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_root *dev_root;
 	struct btrfs_root *quota_root;
 	struct btrfs_root *uuid_root;
+	struct btrfs_root *dedup_root;
 	struct btrfs_root *log_tree_root;
 	int ret;
 	int err = -EINVAL;
@@ -2235,6 +2254,8 @@ int open_ctree(struct super_block *sb,
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
+	fs_info->dedup_bs = 0;
+	fs_info->dedup_type = BTRFS_DEDUP_SHA256;
 	fs_info->metadata_ratio = 0;
 	fs_info->defrag_inodes = RB_ROOT;
 	fs_info->free_chunk_space = 0;
@@ -2319,6 +2340,14 @@ int open_ctree(struct super_block *sb,
 	fs_info->pinned_extents = &fs_info->freed_extents[0];
 	fs_info->do_barriers = 1;
 
+	fs_info->dedup_driver = btrfs_build_dedup_driver(fs_info);
+	if (IS_ERR(fs_info->dedup_driver)) {
+		pr_info("BTRFS: Cannot load sha256 driver\n");
+		err = PTR_ERR(fs_info->dedup_driver);
+		fs_info->dedup_driver = NULL;
+		goto fail_alloc;
+	}
+
 
 	mutex_init(&fs_info->ordered_operations_mutex);
 	mutex_init(&fs_info->ordered_extent_flush_mutex);
@@ -2726,6 +2755,13 @@ retry_root_backup:
 		    generation != btrfs_super_uuid_tree_generation(disk_super);
 	}
 
+	location.objectid = BTRFS_DEDUP_TREE_OBJECTID;
+	dedup_root = btrfs_read_tree_root(tree_root, &location);
+	if (!IS_ERR(dedup_root)) {
+		dedup_root->track_dirty = 1;
+		fs_info->dedup_root = dedup_root;
+	}
+
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c6b6a6e..06124c1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4703,6 +4703,8 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 	if (fs_info->quota_root)
 		fs_info->quota_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
+	if (fs_info->dedup_root)
+		fs_info->dedup_root->block_rsv = &fs_info->global_block_rsv;
 
 	update_global_block_rsv(fs_info);
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4ee4e30..c5ae213 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -42,6 +42,7 @@ struct __btrfs_workqueue;
 		{ BTRFS_ROOT_TREE_DIR_OBJECTID, "ROOT_TREE_DIR"	},	\
 		{ BTRFS_CSUM_TREE_OBJECTID, 	"CSUM_TREE"	},	\
 		{ BTRFS_TREE_LOG_OBJECTID,	"TREE_LOG"	},	\
+		{ BTRFS_DEDUP_TREE_OBJECTID,	"DEDUP_TREE"	},	\
 		{ BTRFS_QUOTA_TREE_OBJECTID,	"QUOTA_TREE"	},	\
 		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
 		{ BTRFS_UUID_TREE_OBJECTID,	"UUID_RELOC"	},	\
@@ -50,7 +51,7 @@ struct __btrfs_workqueue;
 #define show_root_type(obj)						\
 	obj, ((obj >= BTRFS_DATA_RELOC_TREE_OBJECTID) ||		\
 	      (obj >= BTRFS_ROOT_TREE_OBJECTID &&			\
-	       obj <= BTRFS_QUOTA_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
+	       obj <= BTRFS_DEDUP_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
 
 #define BTRFS_GROUP_FLAGS	\
 	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
-- 
1.8.2.1

