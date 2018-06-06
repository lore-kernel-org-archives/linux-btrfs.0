Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932279AbeFFH1Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 03:27:25 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 553BEAD8D
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jun 2018 07:27:24 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs-progs: check/lowmem: Prepare check_file_extent() to handle repair
Date: Wed,  6 Jun 2018 15:27:15 +0800
Message-Id: <20180606072717.28854-5-wqu@suse.com>
In-Reply-To: <20180606072717.28854-1-wqu@suse.com>
References: <20180606072717.28854-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current check_file_extent() doesn't support later repair work, since it
doesn't accept btrfs_path structure as parameter, thus it can't modify
btrfs trees, or later check will still use the old and wrong path.

Use btrfs_path to replace btrfs_key, extent_buffer and slot parameters,
so we can modify @path directly for repair, and reduce the number of
parameters for check_file_extent().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index b3198fffa250..3280591396bd 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1740,18 +1740,18 @@ static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
  * check and update the last offset of the file extent.
  *
  * @root:	the root of fs/file tree.
- * @fkey:	the key of the file extent.
  * @nodatasum:	INODE_NODATASUM feature.
  * @size:	the sum of all EXTENT_DATA items size for this inode.
  * @end:	the offset of the last extent.
  *
  * Return 0 if no error occurred.
  */
-static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
-			     struct extent_buffer *node, int slot,
+static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 			     unsigned int nodatasum, u64 *size, u64 *end)
 {
 	struct btrfs_file_extent_item *fi;
+	struct btrfs_key fkey;
+	struct extent_buffer *node = path->nodes[0];
 	u64 disk_bytenr;
 	u64 disk_num_bytes;
 	u64 extent_num_bytes;
@@ -1763,10 +1763,12 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
 	unsigned int extent_type;
 	unsigned int is_hole;
+	int slot = path->slots[0];
 	int compressed = 0;
 	int ret;
 	int err = 0;
 
+	btrfs_item_key_to_cpu(node, &fkey, slot);
 	fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
 
 	/* Check inline extent */
@@ -1781,23 +1783,23 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		if (extent_num_bytes == 0) {
 			error(
 		"root %llu EXTENT_DATA[%llu %llu] has empty inline extent",
-				root->objectid, fkey->objectid, fkey->offset);
+				root->objectid, fkey.objectid, fkey.offset);
 			err |= FILE_EXTENT_ERROR;
 		}
 		if (compressed) {
 			if (extent_num_bytes > root->fs_info->sectorsize) {
 				error(
 "root %llu EXTENT_DATA[%llu %llu] too large inline extent ram size, have %llu, max: %u",
-					root->objectid, fkey->objectid,
-					fkey->offset, extent_num_bytes,
+					root->objectid, fkey.objectid,
+					fkey.offset, extent_num_bytes,
 					root->fs_info->sectorsize - 1);
 				err |= FILE_EXTENT_ERROR;
 			}
 			if (item_inline_len > max_inline_extent_size) {
 				error(
 "root %llu EXTENT_DATA[%llu %llu] too large inline extent on-disk size, have %u, max: %u",
-					root->objectid, fkey->objectid,
-					fkey->offset, item_inline_len,
+					root->objectid, fkey.objectid,
+					fkey.offset, item_inline_len,
 					max_inline_extent_size);
 				err |= FILE_EXTENT_ERROR;
 			}
@@ -1805,7 +1807,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 			if (extent_num_bytes > max_inline_extent_size) {
  			error(
  "root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have %llu, max: %u",
- 				root->objectid, fkey->objectid, fkey->offset,
+ 				root->objectid, fkey.objectid, fkey.offset,
  				extent_num_bytes, max_inline_extent_size);
 				err |= FILE_EXTENT_ERROR;
 			}
@@ -1813,7 +1815,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		if (!compressed && extent_num_bytes != item_inline_len) {
 			error(
 		"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
-				root->objectid, fkey->objectid, fkey->offset,
+				root->objectid, fkey.objectid, fkey.offset,
 				extent_num_bytes, item_inline_len);
 			err |= FILE_EXTENT_ERROR;
 		}
@@ -1827,7 +1829,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 			extent_type != BTRFS_FILE_EXTENT_PREALLOC) {
 		err |= FILE_EXTENT_ERROR;
 		error("root %llu EXTENT_DATA[%llu %llu] type bad",
-		      root->objectid, fkey->objectid, fkey->offset);
+		      root->objectid, fkey.objectid, fkey.offset);
 		return err;
 	}
 
@@ -1864,12 +1866,12 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 	if (csum_found > 0 && nodatasum) {
 		err |= ODD_CSUM_ITEM;
 		error("root %llu EXTENT_DATA[%llu %llu] nodatasum shouldn't have datasum",
-		      root->objectid, fkey->objectid, fkey->offset);
+		      root->objectid, fkey.objectid, fkey.offset);
 	} else if (extent_type == BTRFS_FILE_EXTENT_REG && !nodatasum &&
 		   !is_hole && (ret < 0 || csum_found < search_len)) {
 		err |= CSUM_ITEM_MISSING;
 		error("root %llu EXTENT_DATA[%llu %llu] csum missing, have: %llu, expected: %llu",
-		      root->objectid, fkey->objectid, fkey->offset,
+		      root->objectid, fkey.objectid, fkey.offset,
 		      csum_found, search_len);
 	} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC &&
 		   csum_found > 0) {
@@ -1881,22 +1883,22 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 			err |= ODD_CSUM_ITEM;
 			error(
 "root %llu EXTENT_DATA[%llu %llu] prealloc shouldn't have csum, but has: %llu",
-			      root->objectid, fkey->objectid, fkey->offset,
+			      root->objectid, fkey.objectid, fkey.offset,
 			      csum_found);
 		}
 	}
 
 	/* Check EXTENT_DATA hole */
-	if (!no_holes && *end != fkey->offset) {
+	if (!no_holes && *end != fkey.offset) {
 		if (repair)
-			ret = punch_extent_hole(root, fkey->objectid,
-						*end, fkey->offset - *end);
+			ret = punch_extent_hole(root, fkey.objectid,
+						*end, fkey.offset - *end);
 		if (!repair || ret) {
 			err |= FILE_EXTENT_ERROR;
 			error(
 "root %llu EXTENT_DATA[%llu %llu] gap exists, expected: EXTENT_DATA[%llu %llu]",
-				root->objectid, fkey->objectid, fkey->offset,
-				fkey->objectid, *end);
+				root->objectid, fkey.objectid, fkey.offset,
+				fkey.objectid, *end);
 		}
 	}
 
@@ -2374,9 +2376,8 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
 					root->objectid, inode_id, key.objectid,
 					key.offset);
 			}
-			ret = check_file_extent(root, &key, node, slot,
-						nodatasum, &extent_size,
-						&extent_end);
+			ret = check_file_extent(root, path, nodatasum,
+						&extent_size, &extent_end);
 			err |= ret;
 			break;
 		case BTRFS_XATTR_ITEM_KEY:
-- 
2.17.1

