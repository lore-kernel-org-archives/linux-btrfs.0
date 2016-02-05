Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23014 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbcBEBY6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:24:58 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v6 10/19] btrfs: dedup: Add basic tree structure for on-disk dedup method
Date: Fri,  5 Feb 2016 09:22:30 +0800
Message-Id: <1454635359-10013-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
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
 fs/btrfs/ctree.h             | 67 +++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/dedup.h             |  5 ++++
 fs/btrfs/disk-io.c           |  1 +
 include/trace/events/btrfs.h |  3 +-
 4 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7de2ddb..8c04920 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -100,6 +100,9 @@ struct btrfs_ordered_sum;
 /* tracks free space in block groups. */
 #define BTRFS_FREE_SPACE_TREE_OBJECTID 10ULL
 
+/* on-disk dedup tree (EXPERIMENTAL) */
+#define BTRFS_DEDUP_TREE_OBJECTID 11ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -505,6 +508,7 @@ struct btrfs_super_block {
  * ones specified below then we will fail to mount
  */
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
+#define BTRFS_FEATURE_COMPAT_RO_DEDUP		(1ULL << 1)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
@@ -534,7 +538,8 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
 
 #define BTRFS_FEATURE_COMPAT_RO_SUPP			\
-	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)
+	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
+	 BTRFS_FEATURE_COMPAT_RO_DEDUP)
 
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
@@ -964,6 +969,46 @@ struct btrfs_csum_item {
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
@@ -2167,6 +2212,13 @@ struct btrfs_ioctl_defrag_range_args {
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
@@ -3229,6 +3281,19 @@ static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
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
index 83a7512..4f681bb 100644
--- a/fs/btrfs/dedup.h
+++ b/fs/btrfs/dedup.h
@@ -58,6 +58,8 @@ struct btrfs_dedup_hash {
 	u8 hash[];
 };
 
+struct btrfs_root;
+
 struct btrfs_dedup_info {
 	/* dedup blocksize */
 	u64 blocksize;
@@ -73,6 +75,9 @@ struct btrfs_dedup_info {
 	struct list_head lru_list;
 	u64 limit_nr;
 	u64 current_nr;
+
+	/* for persist data like dedup-hash and dedup status */
+	struct btrfs_root *dedup_root;
 };
 
 struct btrfs_trans_handle;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d1d59ad..5ecffd7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -183,6 +183,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	.name_stem = "dreloc"	},
 	{ .id = BTRFS_UUID_TREE_OBJECTID,	.name_stem = "uuid"	},
 	{ .id = BTRFS_FREE_SPACE_TREE_OBJECTID,	.name_stem = "free-space" },
+	{ .id = BTRFS_DEDUP_TREE_OBJECTID,	.name_stem = "dedup"	},
 	{ .id = 0,				.name_stem = "tree"	},
 };
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d866f21..44d5e0f 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -47,12 +47,13 @@ struct btrfs_qgroup_operation;
 		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
 		{ BTRFS_UUID_TREE_OBJECTID,	"UUID_TREE"	},	\
 		{ BTRFS_FREE_SPACE_TREE_OBJECTID, "FREE_SPACE_TREE" },	\
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
2.7.0



