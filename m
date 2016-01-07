Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46302 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752348AbcAGBIs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:48 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Liu Bo <bo.li.liu@oracle.com>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 11/16] btrfs: dedup: Add basic tree structure for on-disk dedup method
Date: Thu, 7 Jan 2016 09:08:12 +0800
Message-ID: <1452128897-5433-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new tree, dedup tree to record on-disk dedup hash.
As a persist hash storage instead of in-memeory only implement.

Unlike Liu Bo's implement, in this version we won't do hack for
bytenr -> hash search, but add a new type, DEDUP_BYTENR_ITEM for such
search case, just like in-memory backend.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Use special type for bytenr-> hash search, instead of Liu's backref
  hack
v3:
  None
---
 fs/btrfs/ctree.h             | 67 +++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/dedup.h             |  8 ++++++
 fs/btrfs/disk-io.c           |  1 +
 include/trace/events/btrfs.h |  3 +-
 4 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index aa7f5fb..87158ac 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -97,6 +97,9 @@ struct btrfs_dedup_hash;
 /* for storing items that use the BTRFS_UUID_KEY* types */
 #define BTRFS_UUID_TREE_OBJECTID 9ULL
 
+/* on-disk dedup tree (EXPERIMENTAL) */
+#define BTRFS_DEDUP_TREE_OBJECTID 10ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -524,10 +527,12 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
 
+#define BTRFS_FEATURE_COMPAT_RO_DEDUP		(1ULL << 0)
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
-#define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
+#define BTRFS_FEATURE_COMPAT_RO_SUPP		\
+	(BTRFS_FEATURE_COMPAT_RO_DEDUP)
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
 
@@ -955,6 +960,46 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+/*
+ * Objectid: 0
+ * Type: BTRFS_DEDUP_STATUS_ITEM_KEY
+ * Offset: 0
+ */
+struct btrfs_dedup_status_item {
+	__le64 blocksize;
+	__le64 limit_nr;
+	__le16 hash_type;
+	__le16 backend;
+} __attribute__ ((__packed__));
+
+/*
+ * Objectid: Last 64 bit of the hash
+ * Type: BTRFS_DEDUP_HASH_ITEM_KEY
+ * Offset: Bytenr of the hash
+ *
+ * Used for hash <-> bytenr search
+ * XXX: On-disk format not stable yet, see the unsed one
+ */
+struct btrfs_dedup_hash_item {
+	/* on disk length of dedup range */
+	__le64 len;
+
+	/* Spare space */
+	u8 __unused[16];
+
+	/* Hash follows */
+} __attribute__ ((__packed__));
+
+/*
+ * Objectid: bytenr
+ * Type: BTRFS_DEDUP_BYTENR_ITEM_KEY
+ * offset: Last 64 bit of the hash
+ *
+ * Used for bytenr <-> hash search (for free_extent)
+ * all its content is hash.
+ * So no special item struct is needed.
+ */
+
 struct btrfs_dev_stats_item {
 	/*
 	 * grow this item struct at the end for future enhancements and keep
@@ -2101,6 +2146,13 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_CHUNK_ITEM_KEY	228
 
 /*
+ * Dedup item and status
+ */
+#define BTRFS_DEDUP_STATUS_ITEM_KEY	230
+#define BTRFS_DEDUP_HASH_ITEM_KEY	231
+#define BTRFS_DEDUP_BYTENR_ITEM_KEY	232
+
+/*
  * Records the overall state of the qgroups.
  * There's only one instance of this key present,
  * (0, BTRFS_QGROUP_STATUS_KEY, 0)
@@ -3158,6 +3210,19 @@ static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
 	return offsetof(struct btrfs_leaf, items);
 }
 
+/* btrfs_dedup_status */
+BTRFS_SETGET_FUNCS(dedup_status_blocksize, struct btrfs_dedup_status_item,
+		   blocksize, 64);
+BTRFS_SETGET_FUNCS(dedup_status_limit, struct btrfs_dedup_status_item,
+		   limit_nr, 64);
+BTRFS_SETGET_FUNCS(dedup_status_hash_type, struct btrfs_dedup_status_item,
+		   hash_type, 16);
+BTRFS_SETGET_FUNCS(dedup_status_backend, struct btrfs_dedup_status_item,
+		   backend, 16);
+
+/* btrfs_dedup_hash_item */
+BTRFS_SETGET_FUNCS(dedup_hash_len, struct btrfs_dedup_hash_item, len, 64);
+
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_bytenr,
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
index d06d667..990e922 100644
--- a/fs/btrfs/dedup.h
+++ b/fs/btrfs/dedup.h
@@ -54,6 +54,8 @@ struct btrfs_dedup_hash {
 	u8 hash[];
 };
 
+struct btrfs_root;
+
 struct btrfs_dedup_info {
 	/* dedup blocksize */
 	u64 blocksize;
@@ -70,6 +72,12 @@ struct btrfs_dedup_info {
 	spinlock_t lock;
 	u64 limit_nr;
 	u64 current_nr;
+
+	/* for persist data like dedup-hash and dedup status */
+	struct btrfs_root *dedup_root;
+
+	/* on-disk mode only mutex */
+	struct mutex ondisk_lock;
 };
 
 struct btrfs_trans_handle;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b213439..cf9dbff 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -175,6 +175,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_TREE_RELOC_OBJECTID,	.name_stem = "treloc"	},
 	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	.name_stem = "dreloc"	},
 	{ .id = BTRFS_UUID_TREE_OBJECTID,	.name_stem = "uuid"	},
+	{ .id = BTRFS_DEDUP_TREE_OBJECTID,	.name_stem = "dedup"	},
 	{ .id = 0,				.name_stem = "tree"	},
 };
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index b4473da..655b630 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -46,12 +46,13 @@ struct btrfs_qgroup_operation;
 		{ BTRFS_QUOTA_TREE_OBJECTID,	"QUOTA_TREE"	},	\
 		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
 		{ BTRFS_UUID_TREE_OBJECTID,	"UUID_RELOC"	},	\
+		{ BTRFS_DEDUP_TREE_OBJECTID,	"DEDUP_TREE"	},	\
 		{ BTRFS_DATA_RELOC_TREE_OBJECTID, "DATA_RELOC_TREE" })
 
 #define show_root_type(obj)						\
 	obj, ((obj >= BTRFS_DATA_RELOC_TREE_OBJECTID) ||		\
 	      (obj >= BTRFS_ROOT_TREE_OBJECTID &&			\
-	       obj <= BTRFS_QUOTA_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
+	       obj <= BTRFS_DEDUP_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
 
 #define BTRFS_GROUP_FLAGS	\
 	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
-- 
2.6.4



