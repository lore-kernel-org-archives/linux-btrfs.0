Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46848 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932164AbeENHDP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 03:03:15 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6BC5BAE35
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 07:03:14 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: check/original: Add checks for compressed extent without csum
Date: Mon, 14 May 2018 15:03:09 +0800
Message-Id: <20180514070310.27197-3-wqu@suse.com>
In-Reply-To: <20180514070310.27197-1-wqu@suse.com>
References: <20180514070310.27197-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is one report of compressed extent happens in btrfs, but has no
csum and then leads to possible decompress error screwing up kernel
memory.

Although it's a kernel bug, and won't cause problem until compressed
data get corrupted, let's catch such problem in advance.

This patch will catch any unexpected compressed extent with:

1) 0 or less than expected csum

2) nodatasum flag set in the inode item

This is for original mode.

Reported-by: James Harvey <jamespharvey20@gmail.com>
Issue: #134
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/check/main.c b/check/main.c
index 891a6d797756..db064b27e84b 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1437,6 +1437,7 @@ static int process_file_extent(struct btrfs_root *root,
 	u64 mask = root->fs_info->sectorsize - 1;
 	u32 max_inline_size = min_t(u32, mask,
 				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
+	u8 compression;
 	int extent_type;
 	int ret;
 
@@ -1460,9 +1461,9 @@ static int process_file_extent(struct btrfs_root *root,
 
 	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
 	extent_type = btrfs_file_extent_type(eb, fi);
+	compression = btrfs_file_extent_compression(eb, fi);
 
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-		u8 compression = btrfs_file_extent_compression(eb, fi);
 		struct btrfs_item *item = btrfs_item_nr(slot);
 
 		num_bytes = btrfs_file_extent_inline_len(eb, slot, fi);
@@ -1494,6 +1495,8 @@ static int process_file_extent(struct btrfs_root *root,
 		     btrfs_file_extent_encryption(eb, fi) ||
 		     btrfs_file_extent_other_encoding(eb, fi)))
 			rec->errors |= I_ERR_BAD_FILE_EXTENT;
+		if (compression && rec->nodatasum)
+			rec->errors |= I_ERR_BAD_FILE_EXTENT;
 		if (disk_bytenr > 0)
 			rec->found_size += num_bytes;
 	} else {
@@ -1512,7 +1515,8 @@ static int process_file_extent(struct btrfs_root *root,
 	if (disk_bytenr > 0 &&
 	    btrfs_header_owner(eb) != BTRFS_DATA_RELOC_TREE_OBJECTID) {
 		u64 found;
-		if (btrfs_file_extent_compression(eb, fi))
+
+		if (compression)
 			num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
 		else
 			disk_bytenr += extent_offset;
@@ -1526,6 +1530,8 @@ static int process_file_extent(struct btrfs_root *root,
 				rec->found_csum_item = 1;
 			if (found < num_bytes)
 				rec->some_csum_missing = 1;
+			if (compression && found < num_bytes)
+				rec->errors |= I_ERR_SOME_CSUM_MISSING;
 		} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 			if (found > 0) {
 				ret = check_prealloc_extent_written(root->fs_info,
-- 
2.17.0

