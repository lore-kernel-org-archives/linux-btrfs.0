Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751256AbeDRVcG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 17:32:06 -0400
From: Howard McLauchlan <hmclauchlan@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, <kernel-team@fb.com>,
        Howard McLauchlan <hmclauchlan@fb.com>
Subject: [PATCH 2/2] btrfs: optimize free space tree bitmap conversion
Date: Wed, 18 Apr 2018 14:30:59 -0700
Message-ID: <20180418213059.8025-2-hmclauchlan@fb.com>
In-Reply-To: <20180418213059.8025-1-hmclauchlan@fb.com>
References: <20180418213059.8025-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Presently, convert_free_space_to_extents() does a linear scan of the
bitmap. We can speed this up with find_next_{bit,zero_bit}_le().

This patch replaces the linear scan with find_next_{bit,zero_bit}_le().
Testing shows a 20-33% decrease in execution time for
convert_free_space_to_extents().

Suggested-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
---

Since we change bitmap to be unsigned long, we have to do some casting for the
bitmap cursor. In le_bitmap_set() it makes sense to use u8, as we are doing
bit operations. Everywhere else, we're just using it for pointer arithmetic and
not directly accessing it, so char seems more appropriate.

Howard

 fs/btrfs/extent_io.c       |  4 +--
 fs/btrfs/extent_io.h       |  2 +-
 fs/btrfs/free-space-tree.c | 54 ++++++++++++++------------------------
 3 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cf50278f1c59..1d984b0acd66 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5620,9 +5620,9 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	}
 }
 
-void le_bitmap_set(u8 *map, unsigned int start, int len)
+void le_bitmap_set(unsigned long *map, unsigned int start, int len)
 {
-	u8 *p = map + BIT_BYTE(start);
+	u8 *p = ((u8 *)map) + BIT_BYTE(start);
 	const unsigned int size = start + len;
 	int bits_to_set = BITS_PER_BYTE - (start % BITS_PER_BYTE);
 	u8 mask_to_set = BITMAP_FIRST_BYTE_MASK(start);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4b8b072d9594..01261306e5f9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -84,7 +84,7 @@ static inline int le_test_bit(int nr, const u8 *addr)
 	return 1U & (addr[BIT_BYTE(nr)] >> (nr & (BITS_PER_BYTE-1)));
 }
 
-void le_bitmap_set(u8 *map, unsigned int start, int len);
+void le_bitmap_set(unsigned long *map, unsigned int start, int len);
 
 struct extent_state;
 struct btrfs_root;
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 32a0f6cb5594..0ddf96b01a3a 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -138,9 +138,9 @@ static inline u32 free_space_bitmap_size(u64 size, u32 sectorsize)
 	return DIV_ROUND_UP((u32)div_u64(size, sectorsize), BITS_PER_BYTE);
 }
 
-static u8 *alloc_bitmap(u32 bitmap_size)
+static unsigned long *alloc_bitmap(u32 bitmap_size)
 {
-	u8 *ret;
+	unsigned long *ret;
 	unsigned int nofs_flag;
 
 	/*
@@ -166,7 +166,8 @@ int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 	struct btrfs_free_space_info *info;
 	struct btrfs_key key, found_key;
 	struct extent_buffer *leaf;
-	u8 *bitmap, *bitmap_cursor;
+	unsigned long *bitmap;
+	char *bitmap_cursor;
 	u64 start, end;
 	u64 bitmap_range, i;
 	u32 bitmap_size, flags, expected_extent_count;
@@ -255,7 +256,7 @@ int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	bitmap_cursor = bitmap;
+	bitmap_cursor = (char *)bitmap;
 	bitmap_range = fs_info->sectorsize * BTRFS_FREE_SPACE_BITMAP_BITS;
 	i = start;
 	while (i < end) {
@@ -304,13 +305,10 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 	struct btrfs_free_space_info *info;
 	struct btrfs_key key, found_key;
 	struct extent_buffer *leaf;
-	u8 *bitmap;
+	unsigned long *bitmap;
 	u64 start, end;
-	/* Initialize to silence GCC. */
-	u64 extent_start = 0;
-	u64 offset;
 	u32 bitmap_size, flags, expected_extent_count;
-	int prev_bit = 0, bit, bitnr;
+	unsigned long nrbits, start_bit, end_bit;
 	u32 extent_count = 0;
 	int done = 0, nr;
 	int ret;
@@ -348,7 +346,7 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 				break;
 			} else if (found_key.type == BTRFS_FREE_SPACE_BITMAP_KEY) {
 				unsigned long ptr;
-				u8 *bitmap_cursor;
+				char *bitmap_cursor;
 				u32 bitmap_pos, data_size;
 
 				ASSERT(found_key.objectid >= start);
@@ -358,7 +356,7 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 				bitmap_pos = div_u64(found_key.objectid - start,
 						     fs_info->sectorsize *
 						     BITS_PER_BYTE);
-				bitmap_cursor = bitmap + bitmap_pos;
+				bitmap_cursor = ((char *)bitmap) + bitmap_pos;
 				data_size = free_space_bitmap_size(found_key.offset,
 								   fs_info->sectorsize);
 
@@ -392,32 +390,16 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
-	offset = start;
-	bitnr = 0;
-	while (offset < end) {
-		bit = !!le_test_bit(bitnr, bitmap);
-		if (prev_bit == 0 && bit == 1) {
-			extent_start = offset;
-		} else if (prev_bit == 1 && bit == 0) {
-			key.objectid = extent_start;
-			key.type = BTRFS_FREE_SPACE_EXTENT_KEY;
-			key.offset = offset - extent_start;
-
-			ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
-			if (ret)
-				goto out;
-			btrfs_release_path(path);
+	nrbits = div_u64(block_group->key.offset, block_group->fs_info->sectorsize);
+	start_bit = find_next_bit_le(bitmap, nrbits, 0);
 
-			extent_count++;
-		}
-		prev_bit = bit;
-		offset += fs_info->sectorsize;
-		bitnr++;
-	}
-	if (prev_bit == 1) {
-		key.objectid = extent_start;
+	while (start_bit < nrbits) {
+		end_bit = find_next_zero_bit_le(bitmap, nrbits, start_bit);
+		ASSERT(start_bit < end_bit);
+
+		key.objectid = start + start_bit * block_group->fs_info->sectorsize;
 		key.type = BTRFS_FREE_SPACE_EXTENT_KEY;
-		key.offset = end - extent_start;
+		key.offset = (end_bit - start_bit) * block_group->fs_info->sectorsize;
 
 		ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
 		if (ret)
@@ -425,6 +407,8 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		extent_count++;
+
+		start_bit = find_next_bit_le(bitmap, nrbits, end_bit);
 	}
 
 	if (extent_count != expected_extent_count) {
-- 
2.17.0

