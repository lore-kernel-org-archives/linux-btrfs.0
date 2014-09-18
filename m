Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45385 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154AbaIREWV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 00:22:21 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8I4MPWS012941
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 12:22:25 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: Add nocow compressed write into prealloc support
Date: Thu, 18 Sep 2014 12:22:16 +0800
Message-ID: <1411014138-20124-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic nocow compressed write into preallocated range support in
mkfs and headers.

Now we can use mkfs to create a btrfs which supports nocow compressed
prealloc write.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 mkfs.c  |  2 ++
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index fa73c4a..ab87133 100644
--- a/ctree.h
+++ b/ctree.h
@@ -473,6 +473,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_COMPPREALLOC	(1ULL << 10)
 
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
@@ -486,7 +487,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_COMPPREALLOC)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -825,6 +827,18 @@ struct btrfs_file_extent_item {
 
 } __attribute__ ((__packed__));
 
+struct __compprealloc_data {
+	/* extent offset where we read data from disk. */
+	__le64 data_offset;
+	/* extent len that we need read into memory. */
+	__le64 data_len;
+
+} __attribute__ ((__packed__));
+
+#define BTRFS_FILE_EXTENT_SIZE_NORMAL (sizeof(struct btrfs_file_extent_item))
+#define BTRFS_FILE_EXTENT_SIZE_MAX (sizeof(struct btrfs_file_extent_item) + \
+				    sizeof(struct __compprealloc_data))
+
 struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
@@ -2146,6 +2160,59 @@ static inline int btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
 	return !!(btrfs_super_incompat_flags(disk_super) & flag);
 }
 
+/* struct __compprealloc_data, don't use them directly!!! */
+BTRFS_SETGET_FUNCS(__compprealloc_data_offset, struct __compprealloc_data,
+		   data_offset, 64);
+BTRFS_SETGET_FUNCS(__compprealloc_data_len, struct __compprealloc_data,
+		   data_len, 64);
+
+/*
+ * functions for appended data after a original structure
+ * unlike kernel part, eb has no member fs_info, so caller should check
+ * the incompatible flag manually
+ */
+#define BTRFS_SETGET_APPEND_FUNCS(name, type, new_type, func, bits,	\
+				  flag, fallback)			\
+static inline u##bits btrfs_##name(struct extent_buffer *eb,		\
+				   int slot, type *s)			\
+{									\
+	if (btrfs_item_size_nr(eb, slot) > sizeof(*s))			\
+		return btrfs_##func(eb, (new_type *)(s + 1));		\
+	return fallback(eb, s);						\
+}									\
+static inline void btrfs_set_##name(struct extent_buffer *eb,		\
+				    int slot, type *s, u##bits val)	\
+{									\
+	if (btrfs_item_size_nr(eb, slot) > sizeof(*s))			\
+		btrfs_set_##func(eb, (new_type *)(s + 1), val);		\
+}									\
+
+/* appended data for btrfs_file_extent_item */
+static inline u64
+data_offset_fallback(struct extent_buffer *eb,
+		     struct btrfs_file_extent_item *fi)
+{
+	return 0;
+}
+BTRFS_SETGET_APPEND_FUNCS(ondemand_file_extent_data_offset,
+			  struct btrfs_file_extent_item,
+			  struct __compprealloc_data,
+			  __compprealloc_data_offset,
+			  64, COMPPREALLOC, data_offset_fallback);
+
+static inline u64
+data_len_fallback(struct extent_buffer *eb,
+		  struct btrfs_file_extent_item *fi)
+{
+	return btrfs_file_extent_disk_num_bytes(eb, fi);
+}
+BTRFS_SETGET_APPEND_FUNCS(ondemand_file_extent_data_len,
+			  struct btrfs_file_extent_item,
+			  struct __compprealloc_data,
+			  __compprealloc_data_len,
+			  64, COMPPREALLOC, data_len_fallback);
+
+
 /* helper function to cast into the data area of the leaf. */
 #define btrfs_item_ptr(leaf, slot, type) \
 	((type *)(btrfs_leaf_data(leaf) + \
diff --git a/mkfs.c b/mkfs.c
index 9de61e1..da1e586 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1163,6 +1163,8 @@ static const struct btrfs_fs_feature {
 		"reduced-size metadata extent refs" },
 	{ "no-holes", BTRFS_FEATURE_INCOMPAT_NO_HOLES,
 		"no explicit hole extents for files" },
+	{ "compressed-prealloc", BTRFS_FEATURE_INCOMPAT_COMPPREALLOC,
+		"alloc nocow compressed write into preallocated space"},
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
-- 
2.1.0

