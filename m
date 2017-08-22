Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60946 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754712AbdHVHh3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 03:37:29 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs: Add sanity check for EXTENT_DATA when reading out leaf
Date: Tue, 22 Aug 2017 16:37:17 +0900
Message-Id: <20170822073717.13081-4-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170822073717.13081-1-quwenruo.btrfs@gmx.com>
References: <20170822073717.13081-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add extra checker for item with EXTENT_DATA type.
This checks the following thing:
1) Item size
   Plain text inline file extent size must match item size.
   (compressed inline file extent has no info about its on-disk size)
   Regular/preallocated file extent size must be a fixed value.

2) Every member of regular file extent item
   Including alignment for bytenr and offset, possible value for
   compression/encryption/type.

3) Type/compression/encode must be one of the valid values.

This should be the most comprehensive and restrict check in the context
of btrfs_item for EXTENT_DATA.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/disk-io.c              | 88 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs_tree.h |  1 +
 2 files changed, 89 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 59ee7b959bf0..557f9a520e2a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -549,6 +549,83 @@ static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
 		   btrfs_header_level(eb) == 0 ? "leaf" : "node",	\
 		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
 
+static int check_extent_data_item(struct btrfs_root *root,
+				  struct extent_buffer *leaf, int slot)
+{
+	struct btrfs_file_extent_item *fi;
+	u32 sectorsize = root->fs_info->sectorsize;
+	u32 item_size = btrfs_item_size_nr(leaf, slot);
+
+	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+
+	if (btrfs_file_extent_type(leaf, fi) >= BTRFS_FILE_EXTENT_LAST_TYPE) {
+		CORRUPT("invalid file extent type", leaf, root, slot);
+		return -EIO;
+	}
+	if (btrfs_file_extent_compression(leaf, fi) >= BTRFS_COMPRESS_LAST) {
+		CORRUPT("invalid file extent compression", leaf, root, slot);
+		return -EIO;
+	}
+	if (btrfs_file_extent_encryption(leaf, fi)) {
+		CORRUPT("invalid file extent encryption", leaf, root, slot);
+		return -EIO;
+	}
+	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
+		if (btrfs_file_extent_compression(leaf, fi) !=
+		    BTRFS_COMPRESS_NONE)
+			return 0;
+		/* Plaintext inline extent size must match item size */
+		if (item_size != BTRFS_FILE_EXTENT_INLINE_DATA_START +
+		    btrfs_file_extent_ram_bytes(leaf, fi)) {
+			CORRUPT("plaintext inline extent has invalid size",
+				leaf, root, slot);
+			return -EIO;
+		}
+		return 0;
+	}
+
+
+	/* regular or preallocated extent has fixed item size */
+	if (item_size != sizeof(*fi)) {
+		CORRUPT(
+		"regluar or preallocated extent data item size is invalid",
+			leaf, root, slot);
+		return -EIO;
+	}
+	if (!IS_ALIGNED(btrfs_file_extent_ram_bytes(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_disk_bytenr(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_disk_num_bytes(leaf, fi),
+			sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_offset(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_num_bytes(leaf, fi), sectorsize)) {
+		CORRUPT(
+		"regular or preallocated extent data item has unaligned value",
+			leaf, root, slot);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int check_leaf_item(struct btrfs_root *root,
+			   struct extent_buffer *leaf, int slot)
+{
+	struct btrfs_key key;
+	int ret = 0;
+
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	/*
+	 * Considering how overcrowded the code will be inside the switch,
+	 * complex verification is better to moved its own function.
+	 */
+	switch (key.type) {
+	case BTRFS_EXTENT_DATA_KEY:
+		ret = check_extent_data_item(root, leaf, slot);
+		break;
+	}
+	return ret;
+}
+
 static noinline int check_leaf(struct btrfs_root *root,
 			       struct extent_buffer *leaf)
 {
@@ -605,9 +682,13 @@ static noinline int check_leaf(struct btrfs_root *root,
 	 * 1) key order
 	 * 2) item offset and size
 	 *    No overlap, no hole, all inside the leaf.
+	 * 3) item content
+	 *    If possible, do comprehensive sanity check.
+	 *    NOTE: All check must only rely on the item data itself.
 	 */
 	for (slot = 0; slot < nritems; slot++) {
 		u32 item_end_expected;
+		int ret;
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 
@@ -650,6 +731,13 @@ static noinline int check_leaf(struct btrfs_root *root,
 			return -EIO;
 		}
 
+		/*
+		 * Check if the item size and content meets other limitation
+		 */
+		ret = check_leaf_item(root, leaf, slot);
+		if (ret < 0)
+			return ret;
+
 		prev_key.objectid = key.objectid;
 		prev_key.type = key.type;
 		prev_key.offset = key.offset;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 10689e1fdf11..3aadbb74a024 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -732,6 +732,7 @@ struct btrfs_balance_item {
 #define BTRFS_FILE_EXTENT_INLINE 0
 #define BTRFS_FILE_EXTENT_REG 1
 #define BTRFS_FILE_EXTENT_PREALLOC 2
+#define BTRFS_FILE_EXTENT_LAST_TYPE	3
 
 struct btrfs_file_extent_item {
 	/*
-- 
2.14.1

