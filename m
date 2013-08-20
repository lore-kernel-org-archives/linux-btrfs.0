Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:43628 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3HTLUb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 10/12] Btrfs: PAGE_CACHE_SIZE is already unsigned long
Date: Tue, 20 Aug 2013 13:20:16 +0200
Message-Id: <1376997618-13573-11-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

PAGE_CACHE_SIZE == PAGE_SIZE is "unsigned long" everywhere, so there's no
need to cast it to "unsigned long".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/check-integrity.c |    9 ++++-----
 fs/btrfs/extent_io.c       |   18 +++++++++---------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 4bf75bb..2fe6f31 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1232,8 +1232,7 @@ static void btrfsic_read_from_block_data(
 	unsigned long i = (start_offset + offset) >> PAGE_CACHE_SHIFT;
 
 	WARN_ON(offset + len > block_ctx->len);
-	offset_in_page = (start_offset + offset) &
-			 ((unsigned long)PAGE_CACHE_SIZE - 1);
+	offset_in_page = (start_offset + offset) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
 		cur = min(len, ((size_t)PAGE_CACHE_SIZE - offset_in_page));
@@ -3113,19 +3112,19 @@ int btrfsic_mount(struct btrfs_root *root,
 	if (root->nodesize & ((u64)PAGE_CACHE_SIZE - 1)) {
 		printk(KERN_INFO
 		       "btrfsic: cannot handle nodesize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
-		       root->nodesize, (unsigned long)PAGE_CACHE_SIZE);
+		       root->nodesize, PAGE_CACHE_SIZE);
 		return -1;
 	}
 	if (root->leafsize & ((u64)PAGE_CACHE_SIZE - 1)) {
 		printk(KERN_INFO
 		       "btrfsic: cannot handle leafsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
-		       root->leafsize, (unsigned long)PAGE_CACHE_SIZE);
+		       root->leafsize, PAGE_CACHE_SIZE);
 		return -1;
 	}
 	if (root->sectorsize & ((u64)PAGE_CACHE_SIZE - 1)) {
 		printk(KERN_INFO
 		       "btrfsic: cannot handle sectorsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
-		       root->sectorsize, (unsigned long)PAGE_CACHE_SIZE);
+		       root->sectorsize, PAGE_CACHE_SIZE);
 		return -1;
 	}
 	state = kzalloc(sizeof(*state), GFP_NOFS);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 454edd5..38acc94 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4763,7 +4763,7 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
 
-	offset = (start_offset + start) & ((unsigned long)PAGE_CACHE_SIZE - 1);
+	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
 		page = extent_buffer_page(eb, i);
@@ -4833,7 +4833,7 @@ int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
 
-	offset = (start_offset + start) & ((unsigned long)PAGE_CACHE_SIZE - 1);
+	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
 		page = extent_buffer_page(eb, i);
@@ -4867,7 +4867,7 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
 
-	offset = (start_offset + start) & ((unsigned long)PAGE_CACHE_SIZE - 1);
+	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
 		page = extent_buffer_page(eb, i);
@@ -4897,7 +4897,7 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
 
-	offset = (start_offset + start) & ((unsigned long)PAGE_CACHE_SIZE - 1);
+	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
 		page = extent_buffer_page(eb, i);
@@ -4928,7 +4928,7 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	WARN_ON(src->len != dst_len);
 
 	offset = (start_offset + dst_offset) &
-		((unsigned long)PAGE_CACHE_SIZE - 1);
+		(PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
 		page = extent_buffer_page(dst, i);
@@ -5014,9 +5014,9 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 
 	while (len > 0) {
 		dst_off_in_page = (start_offset + dst_offset) &
-			((unsigned long)PAGE_CACHE_SIZE - 1);
+			(PAGE_CACHE_SIZE - 1);
 		src_off_in_page = (start_offset + src_offset) &
-			((unsigned long)PAGE_CACHE_SIZE - 1);
+			(PAGE_CACHE_SIZE - 1);
 
 		dst_i = (start_offset + dst_offset) >> PAGE_CACHE_SHIFT;
 		src_i = (start_offset + src_offset) >> PAGE_CACHE_SHIFT;
@@ -5067,9 +5067,9 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 		src_i = (start_offset + src_end) >> PAGE_CACHE_SHIFT;
 
 		dst_off_in_page = (start_offset + dst_end) &
-			((unsigned long)PAGE_CACHE_SIZE - 1);
+			(PAGE_CACHE_SIZE - 1);
 		src_off_in_page = (start_offset + src_end) &
-			((unsigned long)PAGE_CACHE_SIZE - 1);
+			(PAGE_CACHE_SIZE - 1);
 
 		cur = min_t(unsigned long, len, src_off_in_page + 1);
 		cur = min(cur, dst_off_in_page + 1);
-- 
1.7.9.5

