Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758711AbcC3H4z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 03:56:55 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v9 14/19] btrfs: dedupe: Add basic tree structure for on-disk dedupe method
Date: Wed, 30 Mar 2016 15:56:09 +0800
Message-Id: <1459324574-28063-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1459324574-28063-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1459324574-28063-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new tree, dedupe tree to record on-disk dedupe hash.
As a persist hash storage instead of in-memeory only implement.

Unlike Liu Bo's implement, in this version we won't do hack for
bytenr -> hash search, but add a new type, DEDUP_BYTENR_ITEM for such
search case, just like in-memory backend.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h             | 62 +++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/dedupe.h            |  5 ++++
 fs/btrfs/disk-io.c           |  6 +++++
 fs/btrfs/relocation.c        |  3 ++-
 include/trace/events/btrfs.h |  3 ++-
 5 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0e8933c..b19c1f1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -100,6 +100,9 @@ struct btrfs_ordered_sum;
 /* tracks free space in block groups. */
 #define BTRFS_FREE_SPACE_TREE_OBJECTID 10ULL
 
+/* on-disk dedupe tree (EXPERIMENTAL) */
+#define BTRFS_DEDUPE_TREE_OBJECTID 11ULL
+
 /* device stats in the device tree */
 #define BTRFS_DEV_STATS_OBJECTID 0ULL
 
@@ -538,7 +541,8 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
 
 #define BTRFS_FEATURE_COMPAT_RO_SUPP			\
-	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)
+	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
+	 BTRFS_FEATURE_COMPAT_RO_DEDUPE)
 
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
@@ -960,6 +964,42 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+/*
+ * Objectid: 0
+ * Type: BTRFS_DEDUPE_STATUS_ITEM_KEY
+ * Offset: 0
+ */
+struct btrfs_dedupe_status_item {
+	__le64 blocksize;
+	__le64 limit_nr;
+	__le16 hash_type;
+	__le16 backend;
+} __attribute__ ((__packed__));
+
+/*
+ * Objectid: Last 64 bit of the hash
+ * Type: BTRFS_DEDUPE_HASH_ITEM_KEY
+ * Offset: Bytenr of the hash
+ *
+ * Used for hash <-> bytenr search
+ */
+struct btrfs_dedupe_hash_item {
+	/* length of dedupe range */
+	__le32 len;
+
+	/* Hash follows */
+} __attribute__ ((__packed__));
+
+/*
+ * Objectid: bytenr
+ * Type: BTRFS_DEDUPE_BYTENR_ITEM_KEY
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
@@ -2168,6 +2208,13 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_CHUNK_ITEM_KEY	228
 
 /*
+ * Dedup item and status
+ */
+#define BTRFS_DEDUPE_STATUS_ITEM_KEY	230
+#define BTRFS_DEDUPE_HASH_ITEM_KEY	231
+#define BTRFS_DEDUPE_BYTENR_ITEM_KEY	232
+
+/*
  * Records the overall state of the qgroups.
  * There's only one instance of this key present,
  * (0, BTRFS_QGROUP_STATUS_KEY, 0)
@@ -3265,6 +3312,19 @@ static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
 	return offsetof(struct btrfs_leaf, items);
 }
 
+/* btrfs_dedupe_status */
+BTRFS_SETGET_FUNCS(dedupe_status_blocksize, struct btrfs_dedupe_status_item,
+		   blocksize, 64);
+BTRFS_SETGET_FUNCS(dedupe_status_limit, struct btrfs_dedupe_status_item,
+		   limit_nr, 64);
+BTRFS_SETGET_FUNCS(dedupe_status_hash_type, struct btrfs_dedupe_status_item,
+		   hash_type, 16);
+BTRFS_SETGET_FUNCS(dedupe_status_backend, struct btrfs_dedupe_status_item,
+		   backend, 16);
+
+/* btrfs_dedupe_hash_item */
+BTRFS_SETGET_FUNCS(dedupe_hash_len, struct btrfs_dedupe_hash_item, len, 32);
+
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_bytenr,
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index f5d2b45..1ac1bcb 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -60,6 +60,8 @@ struct btrfs_dedupe_hash {
 	u8 hash[];
 };
 
+struct btrfs_root;
+
 struct btrfs_dedupe_info {
 	/* dedupe blocksize */
 	u64 blocksize;
@@ -75,6 +77,9 @@ struct btrfs_dedupe_info {
 	struct list_head lru_list;
 	u64 limit_nr;
 	u64 current_nr;
+
+	/* for persist data like dedup-hash and dedupe status */
+	struct btrfs_root *dedupe_root;
 };
 
 struct btrfs_trans_handle;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ed6a6fd..c7eda03 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -184,6 +184,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	.name_stem = "dreloc"	},
 	{ .id = BTRFS_UUID_TREE_OBJECTID,	.name_stem = "uuid"	},
 	{ .id = BTRFS_FREE_SPACE_TREE_OBJECTID,	.name_stem = "free-space" },
+	{ .id = BTRFS_DEDUPE_TREE_OBJECTID,	.name_stem = "dedupe"	},
 	{ .id = 0,				.name_stem = "tree"	},
 };
 
@@ -1678,6 +1679,11 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
 		return fs_info->free_space_root ? fs_info->free_space_root :
 						  ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_DEDUPE_TREE_OBJECTID) {
+		if (fs_info->dedupe_enabled && fs_info->dedupe_info)
+			return fs_info->dedupe_info->dedupe_root;
+		return ERR_PTR(-ENOENT);
+	}
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 33183ce..f3be969 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -577,7 +577,8 @@ static int is_cowonly_root(u64 root_objectid)
 	    root_objectid == BTRFS_CSUM_TREE_OBJECTID ||
 	    root_objectid == BTRFS_UUID_TREE_OBJECTID ||
 	    root_objectid == BTRFS_QUOTA_TREE_OBJECTID ||
-	    root_objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
+	    root_objectid == BTRFS_FREE_SPACE_TREE_OBJECTID ||
+	    root_objectid == BTRFS_DEDUPE_TREE_OBJECTID)
 		return 1;
 	return 0;
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d866f21..2c3d48a 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -47,12 +47,13 @@ struct btrfs_qgroup_operation;
 		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
 		{ BTRFS_UUID_TREE_OBJECTID,	"UUID_TREE"	},	\
 		{ BTRFS_FREE_SPACE_TREE_OBJECTID, "FREE_SPACE_TREE" },	\
+		{ BTRFS_DEDUPE_TREE_OBJECTID,	"DEDUPE_TREE"	},	\
 		{ BTRFS_DATA_RELOC_TREE_OBJECTID, "DATA_RELOC_TREE" })
 
 #define show_root_type(obj)						\
 	obj, ((obj >= BTRFS_DATA_RELOC_TREE_OBJECTID) ||		\
 	      (obj >= BTRFS_ROOT_TREE_OBJECTID &&			\
-	       obj <= BTRFS_QUOTA_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
+	       obj <= BTRFS_DEDUPE_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
 
 #define BTRFS_GROUP_FLAGS	\
 	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
-- 
2.7.4



