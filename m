Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32865 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbbIATCA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 15:02:00 -0400
Received: by padan5 with SMTP id an5so4696728pad.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 12:01:59 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@fb.com>
Subject: [PATCH 3/6] Btrfs: introduce the free space B-tree on-disk format
Date: Tue,  1 Sep 2015 12:01:38 -0700
Message-Id: <463b9e483192445e2fa0d258a2289f96b31018a3.1441131625.git.osandov@fb.com>
In-Reply-To: <cover.1441131625.git.osandov@fb.com>
References: <cover.1441131625.git.osandov@fb.com>
In-Reply-To: <cover.1441131625.git.osandov@fb.com>
References: <cover.1441131625.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The on-disk format for the free space tree is straightforward. Each
block group is represented in the free space tree by a free space info
item that stores accounting information: whether the free space for this
block group is stored as bitmaps or extents and how many extents of free
space exist for this block group (regardless of which format is being
used in the tree). Extents are (start, FREE_SPACE_EXTENT, length) keys
with no corresponding item, and bitmaps instead have the
FREE_SPACE_BITMAP type and have a bitmap item attached, which is just an
array of bytes.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ctree.h             | 38 ++++++++++++++++++++++++++++++++++++++
 include/trace/events/btrfs.h |  3 ++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 10388ac041b6..34a81a79f5b6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -96,6 +96,9 @@ struct btrfs_ordered_sum;
 /* for storing items that use the BTRFS_UUID_KEY* types */
 #define BTRFS_UUID_TREE_OBJECTID 9ULL
 
+/* tracks free space in block groups. */
+#define BTRFS_FREE_SPACE_TREE_OBJECTID 10ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -500,6 +503,8 @@ struct btrfs_super_block {
  * Compat flags that we support.  If any incompat flags are set other than the
  * ones specified below then we will fail to mount
  */
+#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
+
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
@@ -1061,6 +1066,13 @@ struct btrfs_block_group_item {
 	__le64 flags;
 } __attribute__ ((__packed__));
 
+struct btrfs_free_space_info {
+	__le32 extent_count;
+	__le32 flags;
+} __attribute__ ((__packed__));
+
+#define BTRFS_FREE_SPACE_USING_BITMAPS (1ULL << 0)
+
 #define BTRFS_QGROUP_LEVEL_SHIFT		48
 static inline u64 btrfs_qgroup_level(u64 qgroupid)
 {
@@ -2061,6 +2073,27 @@ struct btrfs_ioctl_defrag_range_args {
  */
 #define BTRFS_BLOCK_GROUP_ITEM_KEY 192
 
+/*
+ * Every block group is represented in the free space tree by a free space info
+ * item, which stores some accounting information. It is keyed on
+ * (block_group_start, FREE_SPACE_INFO, block_group_length).
+ */
+#define BTRFS_FREE_SPACE_INFO_KEY 198
+
+/*
+ * A free space extent tracks an extent of space that is free in a block group.
+ * It is keyed on (start, FREE_SPACE_EXTENT, length).
+ */
+#define BTRFS_FREE_SPACE_EXTENT_KEY 199
+
+/*
+ * When a block group becomes very fragmented, we convert it to use bitmaps
+ * instead of extents. A free space bitmap is keyed on
+ * (start, FREE_SPACE_BITMAP, length); the corresponding item is a bitmap with
+ * (length / sectorsize) bits.
+ */
+#define BTRFS_FREE_SPACE_BITMAP_KEY 200
+
 #define BTRFS_DEV_EXTENT_KEY	204
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
@@ -2461,6 +2494,11 @@ BTRFS_SETGET_FUNCS(disk_block_group_flags,
 BTRFS_SETGET_STACK_FUNCS(block_group_flags,
 			struct btrfs_block_group_item, flags, 64);
 
+/* struct btrfs_free_space_info */
+BTRFS_SETGET_FUNCS(free_space_extent_count, struct btrfs_free_space_info,
+		   extent_count, 32);
+BTRFS_SETGET_FUNCS(free_space_flags, struct btrfs_free_space_info, flags, 32);
+
 /* struct btrfs_inode_ref */
 BTRFS_SETGET_FUNCS(inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
 BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 0b73af9be12f..e6289e62a2a8 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -45,7 +45,8 @@ struct btrfs_qgroup_operation;
 		{ BTRFS_TREE_LOG_OBJECTID,	"TREE_LOG"	},	\
 		{ BTRFS_QUOTA_TREE_OBJECTID,	"QUOTA_TREE"	},	\
 		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
-		{ BTRFS_UUID_TREE_OBJECTID,	"UUID_RELOC"	},	\
+		{ BTRFS_UUID_TREE_OBJECTID,	"UUID_TREE"	},	\
+		{ BTRFS_FREE_SPACE_TREE_OBJECTID, "FREE_SPACE_TREE" },	\
 		{ BTRFS_DATA_RELOC_TREE_OBJECTID, "DATA_RELOC_TREE" })
 
 #define show_root_type(obj)						\
-- 
2.5.1

