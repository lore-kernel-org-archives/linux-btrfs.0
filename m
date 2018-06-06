Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932208AbeFFH1X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 03:27:23 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C5EA8AD8D
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jun 2018 07:27:21 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs-progs: Get rid of the confusing btrfs_file_extent_inline_len()
Date: Wed,  6 Jun 2018 15:27:13 +0800
Message-Id: <20180606072717.28854-3-wqu@suse.com>
In-Reply-To: <20180606072717.28854-1-wqu@suse.com>
References: <20180606072717.28854-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
If one uncompressed inline extent has incorrect ram_bytes, neither btrfs
check nor dump-tree could detect such corruption.

[CAUSE]
Every caller tries to read inline extent ram_bytes is using
btrfs_file_extent_inline_len(), other than directly calling
btrfs_file_extent_ram_bytes().

For compressed extent, it's just calling btrfs_file_extent_ram_bytes().
However for uncompressed extent, it falls back to
btrfs_file_extent_inline_item_len(), makes us unable to detect anything
wrong in ram_bytes.

[FIX]
Just get rid of such confusing btrfs_file_extent_inline_len() function.

Reported-by: Steve Leung <sjleung@shaw.ca>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c        |  2 +-
 check/mode-lowmem.c |  2 +-
 cmds-restore.c      |  2 +-
 ctree.h             | 22 ----------------------
 file.c              |  3 +--
 print-tree.c        |  4 ++--
 6 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/check/main.c b/check/main.c
index 235db373a86c..52ef181add61 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1472,7 +1472,7 @@ static int process_file_extent(struct btrfs_root *root,
 		u8 compression = btrfs_file_extent_compression(eb, fi);
 		struct btrfs_item *item = btrfs_item_nr(slot);
 
-		num_bytes = btrfs_file_extent_inline_len(eb, slot, fi);
+		num_bytes = btrfs_file_extent_ram_bytes(eb, fi);
 		if (num_bytes == 0)
 			rec->errors |= I_ERR_BAD_FILE_EXTENT;
 		if (compression) {
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index c42dfcc50352..b3198fffa250 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1776,7 +1776,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		u32 item_inline_len;
 
 		item_inline_len = btrfs_file_extent_inline_item_len(node, e);
-		extent_num_bytes = btrfs_file_extent_inline_len(node, slot, fi);
+		extent_num_bytes = btrfs_file_extent_ram_bytes(node, fi);
 		compressed = btrfs_file_extent_compression(node, fi);
 		if (extent_num_bytes == 0) {
 			error(
diff --git a/cmds-restore.c b/cmds-restore.c
index 29a329a397c2..9542221fd265 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -302,7 +302,7 @@ static int copy_one_inline(struct btrfs_root *root, int fd,
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 	ptr = btrfs_file_extent_inline_start(fi);
-	len = btrfs_file_extent_inline_len(leaf, path->slots[0], fi);
+	len = btrfs_file_extent_ram_bytes(leaf, fi);
 	inline_item_len = btrfs_file_extent_inline_item_len(leaf, btrfs_item_nr(path->slots[0]));
 	read_extent_buffer(leaf, buf, ptr, inline_item_len);
 
diff --git a/ctree.h b/ctree.h
index de4b1b7e6416..04a77550c715 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2443,28 +2443,6 @@ static inline u32 btrfs_search_header_len(struct btrfs_ioctl_search_header *sh)
 	return get_unaligned_32(&sh->len);
 }
 
-/* this returns the number of file bytes represented by the inline item.
- * If an item is compressed, this is the uncompressed size
- */
-static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
-					       int slot,
-					       struct btrfs_file_extent_item *fi)
-{
-	/*
-	 * return the space used on disk if this item isn't
-	 * compressed or encoded
-	 */
-	if (btrfs_file_extent_compression(eb, fi) == 0 &&
-	    btrfs_file_extent_encryption(eb, fi) == 0 &&
-	    btrfs_file_extent_other_encoding(eb, fi) == 0) {
-		return btrfs_file_extent_inline_item_len(eb,
-							 btrfs_item_nr(slot));
-	}
-
-	/* otherwise use the ram bytes field */
-	return btrfs_file_extent_ram_bytes(eb, fi);
-}
-
 #define btrfs_fs_incompat(fs_info, opt) \
 	__btrfs_fs_incompat((fs_info), BTRFS_FEATURE_INCOMPAT_##opt)
 
diff --git a/file.c b/file.c
index f5e645c47bda..056be1045814 100644
--- a/file.c
+++ b/file.c
@@ -255,8 +255,7 @@ int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 		/* Inline extent, one inode should only one inline extent */
 		if (btrfs_file_extent_type(leaf, fi) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
-			extent_len = btrfs_file_extent_inline_len(leaf, slot,
-								  fi);
+			extent_len = btrfs_file_extent_ram_bytes(leaf, fi);
 			if (extent_start + extent_len <= start)
 				goto next;
 			read_extent_buffer(leaf, dest,
diff --git a/print-tree.c b/print-tree.c
index dfa7bb6b676f..a09ecfbb28f0 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -357,9 +357,9 @@ static void print_file_extent_item(struct extent_buffer *eb,
 			extent_type, file_extent_type_to_str(extent_type));
 
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-		printf("\t\tinline extent data size %u ram_bytes %u compression %hhu (%s)\n",
+		printf("\t\tinline extent data size %u ram_bytes %llu compression %hhu (%s)\n",
 				btrfs_file_extent_inline_item_len(eb, item),
-				btrfs_file_extent_inline_len(eb, slot, fi),
+				btrfs_file_extent_ram_bytes(eb, fi),
 				btrfs_file_extent_compression(eb, fi),
 				compress_str);
 		return;
-- 
2.17.1

