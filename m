Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64930 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752560AbdI1DgZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 23:36:25 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 5/5] btrfs: tree-checker: Enhance output for check_extent_data_item
Date: Thu, 28 Sep 2017 12:36:10 +0900
Message-Id: <20170928033610.16882-6-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170928033610.16882-1-quwenruo.btrfs@gmx.com>
References: <20170928033610.16882-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Output the invalid member name and its bad value, along with its
expected value range or alignment.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/tree-checker.c | 92 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 70 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 52e9ab8c2a79..1324fcae93c0 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -63,6 +63,47 @@ static void generic_err(const struct btrfs_root *root,
 	va_end(args);
 }
 
+/*
+ * Customized reporter for extent data item, since its key objectid and
+ * offset has its own meaning.
+ */
+__printf(4, 5)
+static void file_extent_err(const struct btrfs_root *root,
+			    const struct extent_buffer *eb,
+			    int slot, const char *fmt, ...)
+{
+	struct btrfs_key key;
+	struct va_format vaf;
+	va_list args;
+
+	btrfs_item_key_to_cpu(eb, &key, slot);
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	btrfs_crit(root->fs_info,
+		"corrupt %s root=%llu tree_block=%llu slot=%d ino=%llu file_offset=%llu: %pV",
+		btrfs_header_level(eb) == 0 ? "leaf" : "node",
+		root->objectid, btrfs_header_bytenr(eb), slot,
+		key.objectid, key.offset, &vaf);
+	va_end(args);
+}
+
+/*
+ * Return 0 if the btrfs_file_extent_##name is aligned to @align
+ * Else return 1
+ */
+#define CHECK_FI_ALIGN(root, leaf, slot, fi, name, align)		\
+({									\
+	if (!IS_ALIGNED(btrfs_file_extent_##name(leaf, fi), align))	\
+		file_extent_err(root, leaf, slot,			\
+			"invalid file extent %s, have %llu, should be aligned to %u",\
+			#name, btrfs_file_extent_##name(leaf, fi),	\
+			align);						\
+	(!IS_ALIGNED(btrfs_file_extent_##name(leaf, fi), align));	\
+})
+
 static int check_extent_data_item(struct btrfs_root *root,
 				  struct extent_buffer *leaf,
 				  struct btrfs_key *key, int slot)
@@ -72,15 +113,19 @@ static int check_extent_data_item(struct btrfs_root *root,
 	u32 item_size = btrfs_item_size_nr(leaf, slot);
 
 	if (!IS_ALIGNED(key->offset, sectorsize)) {
-		CORRUPT("unaligned key offset for file extent",
-			leaf, root, slot);
+		file_extent_err(root, leaf, slot,
+			"unaligned key offset, have %llu should be aligned to %u",
+			key->offset, sectorsize);
 		return -EUCLEAN;
 	}
 
 	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 
 	if (btrfs_file_extent_type(leaf, fi) > BTRFS_FILE_EXTENT_TYPES) {
-		CORRUPT("invalid file extent type", leaf, root, slot);
+		file_extent_err(root, leaf, slot,
+			"invalid file extent type, have %u expect range [0, %u]",
+			btrfs_file_extent_type(leaf, fi),
+			BTRFS_FILE_EXTENT_TYPES);
 		return -EUCLEAN;
 	}
 
@@ -89,18 +134,24 @@ static int check_extent_data_item(struct btrfs_root *root,
 	 * and must be caught in open_ctree().
 	 */
 	if (btrfs_file_extent_compression(leaf, fi) > BTRFS_COMPRESS_TYPES) {
-		CORRUPT("invalid file extent compression", leaf, root, slot);
+		file_extent_err(root, leaf, slot,
+			"invalid file extent compression, have %u expect range [0, %u]",
+			btrfs_file_extent_compression(leaf, fi),
+			BTRFS_COMPRESS_TYPES);
 		return -EUCLEAN;
 	}
 	if (btrfs_file_extent_encryption(leaf, fi)) {
-		CORRUPT("invalid file extent encryption", leaf, root, slot);
+		file_extent_err(root, leaf, slot,
+			"invalid file extent encryption, have %u expect 0",
+			btrfs_file_extent_encryption(leaf, fi));
 		return -EUCLEAN;
 	}
 	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
 		/* Inline extent must have 0 as key offset */
 		if (key->offset) {
-			CORRUPT("inline extent has non-zero key offset",
-				leaf, root, slot);
+			file_extent_err(root, leaf, slot,
+				"invalid offset for inline extent, have %llu expect 0",
+				key->offset);
 			return -EUCLEAN;
 		}
 
@@ -112,8 +163,10 @@ static int check_extent_data_item(struct btrfs_root *root,
 		/* Uncompressed inline extent size must match item size */
 		if (item_size != BTRFS_FILE_EXTENT_INLINE_DATA_START +
 		    btrfs_file_extent_ram_bytes(leaf, fi)) {
-			CORRUPT("plaintext inline extent has invalid size",
-				leaf, root, slot);
+			file_extent_err(root, leaf, slot,
+				"invalid uncompressed inline extent size, have %u expect %llu",
+				item_size, BTRFS_FILE_EXTENT_INLINE_DATA_START +
+				btrfs_file_extent_ram_bytes(leaf, fi));
 			return -EUCLEAN;
 		}
 		return 0;
@@ -121,22 +174,17 @@ static int check_extent_data_item(struct btrfs_root *root,
 
 	/* Regular or preallocated extent has fixed item size */
 	if (item_size != sizeof(*fi)) {
-		CORRUPT(
-		"regluar or preallocated extent data item size is invalid",
-			leaf, root, slot);
+		file_extent_err(root, leaf, slot,
+			"invalid extent data item size for reg/prealloc, have %u expect %lu",
+			item_size, sizeof(*fi));
 		return -EUCLEAN;
 	}
-	if (!IS_ALIGNED(btrfs_file_extent_ram_bytes(leaf, fi), sectorsize) ||
-	    !IS_ALIGNED(btrfs_file_extent_disk_bytenr(leaf, fi), sectorsize) ||
-	    !IS_ALIGNED(btrfs_file_extent_disk_num_bytes(leaf, fi), sectorsize) ||
-	    !IS_ALIGNED(btrfs_file_extent_offset(leaf, fi), sectorsize) ||
-	    !IS_ALIGNED(btrfs_file_extent_num_bytes(leaf, fi), sectorsize)) {
-		CORRUPT(
-		"regular or preallocated extent data item has unaligned value",
-			leaf, root, slot);
+	if (CHECK_FI_ALIGN(root, leaf, slot, fi, ram_bytes, sectorsize) ||
+	    CHECK_FI_ALIGN(root, leaf, slot, fi, disk_bytenr, sectorsize) ||
+	    CHECK_FI_ALIGN(root, leaf, slot, fi, disk_num_bytes, sectorsize) ||
+	    CHECK_FI_ALIGN(root, leaf, slot, fi, offset, sectorsize) ||
+	    CHECK_FI_ALIGN(root, leaf, slot, fi, num_bytes, sectorsize))
 		return -EUCLEAN;
-	}
-
 	return 0;
 }
 
-- 
2.14.1

