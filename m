Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbaIOP5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 11:57:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 32B6675020
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 15:57:04 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: make free space checker work on non-4k sectorsize filesystems
Date: Mon, 15 Sep 2014 17:57:03 +0200
Message-Id: <1410796623-11550-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value of sector for space cache was hardcoded to 4k, and used to
calculate bitmap sizes.  In kernel, the BITS_PER_BITMAP is derived from
PAGE_CACHE_SIZE which is not available for userspace, that can also deal
with filesystem of varying sectorsize.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 free-space-cache.c | 39 ++++++++++++++++++++++++---------------
 free-space-cache.h |  1 +
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/free-space-cache.c b/free-space-cache.c
index 2440dd80f34f..220449ec7a77 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -25,8 +25,12 @@
 #include "crc32c.h"
 #include "bitops.h"
 
-#define CACHE_SECTORSIZE	4096
-#define BITS_PER_BITMAP		(CACHE_SECTORSIZE * 8)
+/*
+ * Kernel always uses PAGE_CACHE_SIZE for sectorsize, but we don't have
+ * anything like that in userspace and have to get the value from the
+ * filesystem
+ */
+#define BITS_PER_BITMAP(sectorsize)		((sectorsize) * 8)
 #define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
 
 static int link_free_space(struct btrfs_free_space_ctl *ctl,
@@ -48,7 +52,7 @@ static int io_ctl_init(struct io_ctl *io_ctl, u64 size, u64 ino,
 		       struct btrfs_root *root)
 {
 	memset(io_ctl, 0, sizeof(struct io_ctl));
-	io_ctl->num_pages = (size + CACHE_SECTORSIZE - 1) / CACHE_SECTORSIZE;
+	io_ctl->num_pages = (size + root->sectorsize - 1) / root->sectorsize;
 	io_ctl->buffer = kzalloc(size, GFP_NOFS);
 	if (!io_ctl->buffer)
 		return -ENOMEM;
@@ -75,11 +79,11 @@ static void io_ctl_unmap_page(struct io_ctl *io_ctl)
 static void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
 {
 	BUG_ON(io_ctl->index >= io_ctl->num_pages);
-	io_ctl->cur = io_ctl->buffer + (io_ctl->index++ * CACHE_SECTORSIZE);
+	io_ctl->cur = io_ctl->buffer + (io_ctl->index++ * io_ctl->root->sectorsize);
 	io_ctl->orig = io_ctl->cur;
-	io_ctl->size = CACHE_SECTORSIZE;
+	io_ctl->size = io_ctl->root->sectorsize;
 	if (clear)
-		memset(io_ctl->cur, 0, CACHE_SECTORSIZE);
+		memset(io_ctl->cur, 0, io_ctl->root->sectorsize);
 }
 
 static void io_ctl_drop_pages(struct io_ctl *io_ctl)
@@ -203,7 +207,7 @@ static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 	val = *tmp;
 
 	io_ctl_map_page(io_ctl, 0);
-	crc = crc32c(crc, io_ctl->orig + offset, CACHE_SECTORSIZE - offset);
+	crc = crc32c(crc, io_ctl->orig + offset, io_ctl->root->sectorsize - offset);
 	btrfs_csum_final(crc, (char *)&crc);
 	if (val != crc) {
 		printk("btrfs: csum mismatch on free space cache\n");
@@ -250,7 +254,7 @@ static int io_ctl_read_bitmap(struct io_ctl *io_ctl,
 	if (ret)
 		return ret;
 
-	memcpy(entry->bitmap, io_ctl->cur, CACHE_SECTORSIZE);
+	memcpy(entry->bitmap, io_ctl->cur, io_ctl->root->sectorsize);
 	io_ctl_unmap_page(io_ctl);
 
 	return 0;
@@ -375,7 +379,7 @@ static int __load_free_space_cache(struct btrfs_root *root,
 		} else {
 			BUG_ON(!num_bitmaps);
 			num_bitmaps--;
-			e->bitmap = kzalloc(CACHE_SECTORSIZE, GFP_NOFS);
+			e->bitmap = kzalloc(ctl->sectorsize, GFP_NOFS);
 			if (!e->bitmap) {
 				free(e);
 				goto free_cache;
@@ -462,8 +466,9 @@ static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
 {
 	u64 bitmap_start;
 	u64 bytes_per_bitmap;
+	u32 sectorsize = ctl->sectorsize;
 
-	bytes_per_bitmap = BITS_PER_BITMAP * ctl->unit;
+	bytes_per_bitmap = BITS_PER_BITMAP(sectorsize) * ctl->unit;
 	bitmap_start = offset - ctl->start;
 	bitmap_start = bitmap_start / bytes_per_bitmap;
 	bitmap_start *= bytes_per_bitmap;
@@ -532,6 +537,7 @@ tree_search_offset(struct btrfs_free_space_ctl *ctl,
 {
 	struct rb_node *n = ctl->free_space_offset.rb_node;
 	struct btrfs_free_space *entry, *prev = NULL;
+	u32 sectorsize = ctl->sectorsize;
 
 	/* find entry that is closest to the 'offset' */
 	while (1) {
@@ -616,7 +622,7 @@ tree_search_offset(struct btrfs_free_space_ctl *ctl,
 			    prev->offset + prev->bytes > offset)
 				return prev;
 		}
-		if (entry->offset + BITS_PER_BITMAP * ctl->unit > offset)
+		if (entry->offset + BITS_PER_BITMAP(sectorsize) * ctl->unit > offset)
 			return entry;
 	} else if (entry->offset + entry->bytes > offset)
 		return entry;
@@ -626,7 +632,7 @@ tree_search_offset(struct btrfs_free_space_ctl *ctl,
 
 	while (1) {
 		if (entry->bitmap) {
-			if (entry->offset + BITS_PER_BITMAP *
+			if (entry->offset + BITS_PER_BITMAP(sectorsize) *
 			    ctl->unit > offset)
 				break;
 		} else {
@@ -673,14 +679,15 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 	unsigned long found_bits = 0;
 	unsigned long bits, i;
 	unsigned long next_zero;
+	u32 sectorsize = ctl->sectorsize;
 
 	i = offset_to_bit(bitmap_info->offset, ctl->unit,
 			  max_t(u64, *offset, bitmap_info->offset));
 	bits = bytes_to_bits(*bytes, ctl->unit);
 
-	for_each_set_bit_from(i, bitmap_info->bitmap, BITS_PER_BITMAP) {
+	for_each_set_bit_from(i, bitmap_info->bitmap, BITS_PER_BITMAP(sectorsize)) {
 		next_zero = find_next_zero_bit(bitmap_info->bitmap,
-					       BITS_PER_BITMAP, i);
+					       BITS_PER_BITMAP(sectorsize), i);
 		if ((next_zero - i) >= bits) {
 			found_bits = next_zero - i;
 			break;
@@ -767,6 +774,7 @@ int btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group,
 	if (!ctl)
 		return -ENOMEM;
 
+	ctl->sectorsize = sectorsize;
 	ctl->unit = sectorsize;
 	ctl->start = block_group->key.objectid;
 	ctl->private = block_group;
@@ -827,6 +835,7 @@ static void merge_space_tree(struct btrfs_free_space_ctl *ctl)
 	struct btrfs_free_space *e, *prev = NULL;
 	struct rb_node *n;
 	int ret;
+	u32 sectorsize = ctl->sectorsize;
 
 again:
 	prev = NULL;
@@ -836,7 +845,7 @@ again:
 			u64 offset = e->offset, bytes = ctl->unit;
 			u64 end;
 
-			end = e->offset + (u64)(BITS_PER_BITMAP * ctl->unit);
+			end = e->offset + (u64)(BITS_PER_BITMAP(sectorsize) * ctl->unit);
 
 			unlink_free_space(ctl, e);
 			while (!(search_bitmap(ctl, e, &offset, &bytes))) {
diff --git a/free-space-cache.h b/free-space-cache.h
index d28625867f76..ec213da66ccf 100644
--- a/free-space-cache.h
+++ b/free-space-cache.h
@@ -36,6 +36,7 @@ struct btrfs_free_space_ctl {
 	int unit;
 	u64 start;
 	void *private;
+	u32 sectorsize;
 };
 
 int load_free_space_cache(struct btrfs_fs_info *fs_info,
-- 
2.1.0

