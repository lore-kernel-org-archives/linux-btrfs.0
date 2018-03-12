Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:38052 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751483AbeCLGHk (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 12 Mar 2018 02:07:40 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: check: Fix false alerts on sector sized compressed inline file extent
Date: Mon, 12 Mar 2018 14:07:24 +0800
Message-Id: <20180312060724.32394-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 9d015c984006 ("btrfs-progs: Limit inline extent below page size")
tries to fix the convert problem which we could create large inline file
extent but kernel can't hanle.

This leads the false alert about fsck test case 020.

And after discussion about the problem in the mail list, we still
need to support compressed inline file extent whose ram_bytes can be
sector size.

So instead of embedding the sector size check into
BTRFS_MAX_INLINE_DATA_SIZE(), we still need to manually check ram_bytes
and inline_item_len separately.

This patch reverts the fix in 9d015c984006 ("btrfs-progs: Limit inline
extent below page size") and do it manually in check and convert, so we
won't need to maintain 2 different BTRFS_MAX_INLINE_DATA_SIZE().

Fixes: 9d015c984006 ("btrfs-progs: Limit inline extent below page size")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c          | 25 +++++++++++++++++++++++--
 check/mode-lowmem.c   | 30 +++++++++++++++++++++++++++---
 convert/source-ext2.c |  4 ++--
 ctree.h               | 10 ++--------
 4 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/check/main.c b/check/main.c
index 392195ca324e..c887b139ccdb 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1435,6 +1435,8 @@ static int process_file_extent(struct btrfs_root *root,
 	u64 disk_bytenr = 0;
 	u64 extent_offset = 0;
 	u64 mask = root->fs_info->sectorsize - 1;
+	u32 max_inline_size = min_t(u32, mask,
+				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
 	int extent_type;
 	int ret;
 
@@ -1460,11 +1462,30 @@ static int process_file_extent(struct btrfs_root *root,
 	extent_type = btrfs_file_extent_type(eb, fi);
 
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+		u8 compression = btrfs_file_extent_compression(eb, fi);
+		struct btrfs_item *item = btrfs_item_nr(slot);
+
 		num_bytes = btrfs_file_extent_inline_len(eb, slot, fi);
 		if (num_bytes == 0)
 			rec->errors |= I_ERR_BAD_FILE_EXTENT;
-		if (num_bytes > BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info))
-			rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
+		/*
+		 * Here is the hassle.
+		 * For compressed inline file extent, we allow ram_bytes to
+		 * be as large as sectorsize, and only limit its on-disk
+		 * data size below sectorsize.
+		 * But for uncompressed inline file extent, we limit
+		 * the ram_bytes to below sectorsize.
+		 */
+		if (compression) {
+			if (btrfs_file_extent_inline_item_len(eb, item) >
+			    max_inline_size ||
+			    num_bytes > root->fs_info->sectorsize)
+				rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
+		} else {
+			if (num_bytes > max_inline_size)
+				rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
+		}
+
 		rec->found_size += num_bytes;
 		num_bytes = (num_bytes + mask) & ~mask;
 	} else if (extent_type == BTRFS_FILE_EXTENT_REG ||
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 0c932b343db2..ae81dfb60d7e 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1417,7 +1417,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 	u64 csum_found;		/* In byte size, sectorsize aligned */
 	u64 search_start;	/* Logical range start we search for csum */
 	u64 search_len;		/* Logical range len we search for csum */
-	u32 max_inline_extent_size = BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info);
+	u32 max_inline_extent_size = min_t(u32, root->fs_info->sectorsize - 1,
+				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
 	unsigned int extent_type;
 	unsigned int is_hole;
 	int compressed = 0;
@@ -1441,12 +1442,35 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 				root->objectid, fkey->objectid, fkey->offset);
 			err |= FILE_EXTENT_ERROR;
 		}
-		if (extent_num_bytes > max_inline_extent_size) {
+		/*
+		 * Compressed inline and uncompressed inline has different limit
+		 * on ram_bytes and item size.
+		 */
+		if (compressed) {
+			if (extent_num_bytes > root->fs_info->sectorsize) {
+				error(
+"root %llu EXTENT_DATA[%llu %llu] too large inline extent ram size, have %llu, max: %u",
+					root->objectid, fkey->objectid,
+					fkey->offset, extent_num_bytes,
+					root->fs_info->sectorsize);
+				err |= FILE_EXTENT_ERROR;
+			}
+			if (item_inline_len > max_inline_extent_size) {
+				error(
+"root %llu EXTENT_DATA[%llu %llu] too large inline extent on-disk size, have %u, max: %u",
+					root->objectid, fkey->objectid,
+					fkey->offset, item_inline_len,
+					max_inline_extent_size);
+				err |= FILE_EXTENT_ERROR;
+			}
+		} else {
+			if (extent_num_bytes > max_inline_extent_size) {
 			error(
 "root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have %llu, max: %u",
 				root->objectid, fkey->objectid, fkey->offset,
 				extent_num_bytes, max_inline_extent_size);
-			err |= FILE_EXTENT_ERROR;
+				err |= FILE_EXTENT_ERROR;
+			}
 		}
 		if (!compressed && extent_num_bytes != item_inline_len) {
 			error(
diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index b1492c78693d..2198304a123f 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -310,8 +310,8 @@ static int ext2_create_file_extents(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto fail;
 	if ((convert_flags & CONVERT_FLAG_INLINE_DATA) && data.first_block == 0
-	    && data.num_blocks > 0
-	    && inode_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info)) {
+	    && data.num_blocks > 0 && inode_size < sectorsize &&
+	    inode_size < BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info)) {
 		u64 num_bytes = data.num_blocks * sectorsize;
 		u64 disk_bytenr = data.disk_block * sectorsize;
 		u64 nbytes;
diff --git a/ctree.h b/ctree.h
index 75dffdff2eca..a73c0a0629c9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1206,14 +1206,8 @@ static inline u32 BTRFS_NODEPTRS_PER_BLOCK(const struct btrfs_fs_info *info)
 	(offsetof(struct btrfs_file_extent_item, disk_bytenr))
 static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_fs_info *info)
 {
-	/*
-	 * Inline extent larger than pagesize could lead to kernel unexpected
-	 * error when dropping extents, so we need to limit the inline extent
-	 * size to less than sectorsize.
-	 */
-	return min_t(u32, info->sectorsize - 1,
-		     BTRFS_MAX_ITEM_SIZE(info) -
-		     BTRFS_FILE_EXTENT_INLINE_DATA_START);
+	return BTRFS_MAX_ITEM_SIZE(info) -
+		     BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
 
 static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
-- 
2.16.2

