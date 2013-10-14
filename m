Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31024 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3JNFBI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 01:01:08 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9E517Rs000558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:08 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E516gP029626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:07 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E516gR000184
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:06 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 05/13] Btrfs: introduce dedup tree and relatives
Date: Mon, 14 Oct 2013 12:59:47 +0800
Message-Id: <1381726796-27191-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparation step for online/inband dedup tree.
It introduces dedup tree and its relatives, including hash driver and
some structures.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h             |   73 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c           |   41 +++++++++++++++++++++++
 fs/btrfs/extent-tree.c       |    2 +
 include/trace/events/btrfs.h |    3 +-
 4 files changed, 118 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0506f40..4cc91c5 100644
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
@@ -95,6 +96,9 @@ struct btrfs_ordered_sum;
 /* for storing items that use the BTRFS_UUID_KEY* types */
 #define BTRFS_UUID_TREE_OBJECTID 9ULL
 
+/* dedup tree(experimental) */
+#define BTRFS_DEDUP_TREE_OBJECTID 10ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -515,6 +519,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
+#define BTRFS_FEATURE_INCOMPAT_DEDUP           (1ULL << 9)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -526,6 +531,7 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
+	 BTRFS_FEATURE_INCOMPAT_DEDUP |			\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
 /*
@@ -897,6 +903,51 @@ struct btrfs_csum_item {
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
@@ -1298,6 +1349,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *dev_root;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *csum_root;
+	struct btrfs_root *dedup_root;
 	struct btrfs_root *quota_root;
 	struct btrfs_root *uuid_root;
 
@@ -1650,6 +1702,14 @@ struct btrfs_fs_info {
 
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
 
 /*
@@ -1930,6 +1990,8 @@ struct btrfs_ioctl_defrag_range_args {
 
 #define BTRFS_BALANCE_ITEM_KEY	248
 
+#define BTRFS_DEDUP_ITEM_KEY	251
+
 /*
  * Persistantly stores the io stats in the device tree.
  * One key for all stats, (0, BTRFS_DEV_STATS_KEY, devid).
@@ -2974,6 +3036,14 @@ static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
 	return btrfs_item_size(eb, e) - offset;
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
@@ -3443,6 +3513,8 @@ static inline int btrfs_need_cleaner_sleep(struct btrfs_root *root)
 
 static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 {
+	if (fs_info->dedup_driver)
+		crypto_free_shash(fs_info->dedup_driver);
 	kfree(fs_info->balance_ctl);
 	kfree(fs_info->delayed_root);
 	kfree(fs_info->extent_root);
@@ -3618,6 +3690,7 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 			u64 isize);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
+
 /* inode.c */
 struct btrfs_delalloc_work {
 	struct inode *inode;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 289c09b..27b3739 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -154,6 +154,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_FS_TREE_OBJECTID,		.name_stem = "fs"	},
 	{ .id = BTRFS_CSUM_TREE_OBJECTID,	.name_stem = "csum"	},
 	{ .id = BTRFS_QUOTA_TREE_OBJECTID,	.name_stem = "quota"	},
+	{ .id = BTRFS_DEDUP_TREE_OBJECTID,	.name_stem = "dedup"	},
 	{ .id = BTRFS_TREE_LOG_OBJECTID,	.name_stem = "log"	},
 	{ .id = BTRFS_TREE_RELOC_OBJECTID,	.name_stem = "treloc"	},
 	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	.name_stem = "dreloc"	},
@@ -1583,6 +1584,9 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_UUID_TREE_OBJECTID)
 		return fs_info->uuid_root ? fs_info->uuid_root :
 					    ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_DEDUP_TREE_OBJECTID)
+		return fs_info->dedup_root ? fs_info->dedup_root :
+					     ERR_PTR(-ENOENT);
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root) {
@@ -2050,6 +2054,12 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 		info->uuid_root->node = NULL;
 		info->uuid_root->commit_root = NULL;
 	}
+	if (info->dedup_root) {
+		free_extent_buffer(info->dedup_root->node);
+		free_extent_buffer(info->dedup_root->commit_root);
+		info->dedup_root->node = NULL;
+		info->dedup_root->commit_root = NULL;
+	}
 	if (chunk_root) {
 		free_extent_buffer(info->chunk_root->node);
 		free_extent_buffer(info->chunk_root->commit_root);
@@ -2089,6 +2099,19 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
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
@@ -2111,6 +2134,7 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_root *dev_root;
 	struct btrfs_root *quota_root;
 	struct btrfs_root *uuid_root;
+	struct btrfs_root *dedup_root;
 	struct btrfs_root *log_tree_root;
 	int ret;
 	int err = -EINVAL;
@@ -2200,6 +2224,8 @@ int open_ctree(struct super_block *sb,
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
+	fs_info->dedup_bs = 0;
+	fs_info->dedup_type = BTRFS_DEDUP_SHA256;
 	fs_info->metadata_ratio = 0;
 	fs_info->defrag_inodes = RB_ROOT;
 	fs_info->free_chunk_space = 0;
@@ -2476,6 +2502,14 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	fs_info->dedup_driver = btrfs_build_dedup_driver(fs_info);
+	if (IS_ERR(fs_info->dedup_driver)) {
+		pr_info("BTRFS: Cannot load sha256 driver\n");
+		err = PTR_ERR(fs_info->dedup_driver);
+		fs_info->dedup_driver = NULL;
+		goto fail_alloc;
+	}
+
 	btrfs_init_workers(&fs_info->generic_worker,
 			   "genwork", 1, NULL);
 
@@ -2726,6 +2760,13 @@ retry_root_backup:
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
index 6d92c54..ee97f3a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4706,6 +4706,8 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 	if (fs_info->quota_root)
 		fs_info->quota_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
+	if (fs_info->dedup_root)
+		fs_info->dedup_root->block_rsv = &fs_info->global_block_rsv;
 
 	update_global_block_rsv(fs_info);
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index f18b3b7..7914ee9 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -40,6 +40,7 @@ struct extent_buffer;
 		{ BTRFS_ROOT_TREE_DIR_OBJECTID, "ROOT_TREE_DIR"	},	\
 		{ BTRFS_CSUM_TREE_OBJECTID, 	"CSUM_TREE"	},	\
 		{ BTRFS_TREE_LOG_OBJECTID,	"TREE_LOG"	},	\
+		{ BTRFS_DEDUP_TREE_OBJECTID,	"DEDUP_TREE"	},	\
 		{ BTRFS_QUOTA_TREE_OBJECTID,	"QUOTA_TREE"	},	\
 		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
 		{ BTRFS_UUID_TREE_OBJECTID,	"UUID_RELOC"	},	\
@@ -48,7 +49,7 @@ struct extent_buffer;
 #define show_root_type(obj)						\
 	obj, ((obj >= BTRFS_DATA_RELOC_TREE_OBJECTID) ||		\
 	      (obj >= BTRFS_ROOT_TREE_OBJECTID &&			\
-	       obj <= BTRFS_QUOTA_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
+	       obj <= BTRFS_DEDUP_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
 
 #define BTRFS_GROUP_FLAGS	\
 	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
-- 
1.7.7

