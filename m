Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbaJBQum (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:50:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 32CF6AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:50:41 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 13/14] btrfs: new define for the inline extent data start
Date: Thu,  2 Oct 2014 18:50:40 +0200
Message-Id: <7ec20afbcb7b257aec82ea5d66e6b0b7499abaca.1412264873.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use a common definition for the inline data start so we don't have to
open-code it and introduce bugs like "Btrfs: fix wrong max inline data
size limit" fixed.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c |  3 +--
 fs/btrfs/ctree.h | 16 ++++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 39021bf2df9a..533657c508e2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4625,8 +4625,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 				ptr = btrfs_item_ptr_offset(leaf, slot);
 				memmove_extent_buffer(leaf, ptr,
 				      (unsigned long)fi,
-				      offsetof(struct btrfs_file_extent_item,
-						 disk_bytenr));
+				      BTRFS_FILE_EXTENT_INLINE_DATA_START);
 			}
 		}
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dd79ba7ee3ea..bae025a20e63 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -385,9 +385,11 @@ struct btrfs_header {
 				     sizeof(struct btrfs_key_ptr))
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
 #define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->nodesize))
+#define BTRFS_FILE_EXTENT_INLINE_DATA_START		\
+		(offsetof(struct btrfs_file_extent_item, disk_bytenr))
 #define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
 					sizeof(struct btrfs_item) - \
-					offsetof(struct btrfs_file_extent_item, disk_bytenr))
+					BTRFS_FILE_EXTENT_INLINE_DATA_START)
 #define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r) - \
 				 sizeof(struct btrfs_item) -\
 				 sizeof(struct btrfs_dir_item))
@@ -896,6 +898,8 @@ struct btrfs_file_extent_item {
 	/*
 	 * disk space consumed by the extent, checksum blocks are included
 	 * in these numbers
+	 *
+	 * At this offset in the structure, the inline extent data start.
 	 */
 	__le64 disk_bytenr;
 	__le64 disk_num_bytes;
@@ -3043,14 +3047,12 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_extent_compression,
 static inline unsigned long
 btrfs_file_extent_inline_start(struct btrfs_file_extent_item *e)
 {
-	unsigned long offset = (unsigned long)e;
-	offset += offsetof(struct btrfs_file_extent_item, disk_bytenr);
-	return offset;
+	return (unsigned long)e + BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
 
 static inline u32 btrfs_file_extent_calc_inline_size(u32 datasize)
 {
-	return offsetof(struct btrfs_file_extent_item, disk_bytenr) + datasize;
+	return BTRFS_FILE_EXTENT_INLINE_DATA_START + datasize;
 }
 
 BTRFS_SETGET_FUNCS(file_extent_disk_bytenr, struct btrfs_file_extent_item,
@@ -3080,9 +3082,7 @@ BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
 static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
 						    struct btrfs_item *e)
 {
-	unsigned long offset;
-	offset = offsetof(struct btrfs_file_extent_item, disk_bytenr);
-	return btrfs_item_size(eb, e) - offset;
+	return btrfs_item_size(eb, e) - BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
 
 /* this returns the number of file bytes represented by the inline item.
-- 
1.8.4.5

