Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7878EC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35D332083F
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35D332083F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbeLEOXS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:23:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:46002 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727278AbeLEOXQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 09:23:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DCB19AD4B
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 14:23:12 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/3] btrfs: use offset_in_page instead of open-coding it
Date:   Wed,  5 Dec 2018 15:23:03 +0100
Message-Id: <20181205142305.15361-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205142305.15361-1-jthumshirn@suse.de>
References: <20181205142305.15361-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Constructs like 'var & (PAGE_SIZE - 1)' or 'var & ~PAGE_MASK' can denote an
offset into a page.

So replace them by the offset_in_page() macro instead of open-coding it if
they're not used as an alignment check.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/check-integrity.c | 12 +++++------
 fs/btrfs/compression.c     |  2 +-
 fs/btrfs/extent_io.c       | 53 +++++++++++++++++++++-------------------------
 fs/btrfs/file.c            |  4 ++--
 fs/btrfs/inode.c           |  7 +++---
 fs/btrfs/send.c            |  2 +-
 fs/btrfs/volumes.c         |  2 +-
 7 files changed, 38 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 781cae168d2a..d319c3020c09 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1202,24 +1202,24 @@ static void btrfsic_read_from_block_data(
 	void *dstv, u32 offset, size_t len)
 {
 	size_t cur;
-	size_t offset_in_page;
+	size_t pgoff;
 	char *kaddr;
 	char *dst = (char *)dstv;
-	size_t start_offset = block_ctx->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(block_ctx->start);
 	unsigned long i = (start_offset + offset) >> PAGE_SHIFT;
 
 	WARN_ON(offset + len > block_ctx->len);
-	offset_in_page = (start_offset + offset) & (PAGE_SIZE - 1);
+	pgoff = offset_in_page(start_offset + offset);
 
 	while (len > 0) {
-		cur = min(len, ((size_t)PAGE_SIZE - offset_in_page));
+		cur = min(len, ((size_t)PAGE_SIZE - pgoff));
 		BUG_ON(i >= DIV_ROUND_UP(block_ctx->len, PAGE_SIZE));
 		kaddr = block_ctx->datav[i];
-		memcpy(dst, kaddr + offset_in_page, cur);
+		memcpy(dst, kaddr + pgoff, cur);
 
 		dst += cur;
 		len -= cur;
-		offset_in_page = 0;
+		pgoff = 0;
 		i++;
 	}
 }
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index dba59ae914b8..2ab5591449f2 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -477,7 +477,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 
 		if (page->index == end_index) {
 			char *userpage;
-			size_t zero_offset = isize & (PAGE_SIZE - 1);
+			size_t zero_offset = offset_in_page(isize);
 
 			if (zero_offset) {
 				int zeros;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b2769e92b556..e365c5272e6b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2585,7 +2585,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 			unsigned off;
 
 			/* Zero out the end if this page straddles i_size */
-			off = i_size & (PAGE_SIZE-1);
+			off = offset_in_page(i_size);
 			if (page->index == end_index && off)
 				zero_user_segment(page, off, PAGE_SIZE);
 			SetPageUptodate(page);
@@ -2888,7 +2888,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 
 	if (page->index == last_byte >> PAGE_SHIFT) {
 		char *userpage;
-		size_t zero_offset = last_byte & (PAGE_SIZE - 1);
+		size_t zero_offset = offset_in_page(last_byte);
 
 		if (zero_offset) {
 			iosize = PAGE_SIZE - zero_offset;
@@ -3432,7 +3432,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 	ClearPageError(page);
 
-	pg_offset = i_size & (PAGE_SIZE - 1);
+	pg_offset = offset_in_page(i_size);
 	if (page->index > end_index ||
 	   (page->index == end_index && !pg_offset)) {
 		page->mapping->a_ops->invalidatepage(page, 0, PAGE_SIZE);
@@ -5307,7 +5307,7 @@ void read_extent_buffer(const struct extent_buffer *eb, void *dstv,
 	struct page *page;
 	char *kaddr;
 	char *dst = (char *)dstv;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(eb->start);
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 
 	if (start + len > eb->len) {
@@ -5317,7 +5317,7 @@ void read_extent_buffer(const struct extent_buffer *eb, void *dstv,
 		return;
 	}
 
-	offset = (start_offset + start) & (PAGE_SIZE - 1);
+	offset = offset_in_page(start_offset + start);
 
 	while (len > 0) {
 		page = eb->pages[i];
@@ -5342,14 +5342,14 @@ int read_extent_buffer_to_user(const struct extent_buffer *eb,
 	struct page *page;
 	char *kaddr;
 	char __user *dst = (char __user *)dstv;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(eb->start);
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 	int ret = 0;
 
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
 
-	offset = (start_offset + start) & (PAGE_SIZE - 1);
+	offset = offset_in_page(start_offset + start);
 
 	while (len > 0) {
 		page = eb->pages[i];
@@ -5383,7 +5383,7 @@ int map_private_extent_buffer(const struct extent_buffer *eb,
 	size_t offset;
 	char *kaddr;
 	struct page *p;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(eb->start);
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 	unsigned long end_i = (start_offset + start + min_len - 1) >>
 		PAGE_SHIFT;
@@ -5420,14 +5420,14 @@ int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 	struct page *page;
 	char *kaddr;
 	char *ptr = (char *)ptrv;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(eb->start);
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 	int ret = 0;
 
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
 
-	offset = (start_offset + start) & (PAGE_SIZE - 1);
+	offset = offset_in_page(start_offset + start);
 
 	while (len > 0) {
 		page = eb->pages[i];
@@ -5476,13 +5476,13 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 	struct page *page;
 	char *kaddr;
 	char *src = (char *)srcv;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(eb->start);
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
 
-	offset = (start_offset + start) & (PAGE_SIZE - 1);
+	offset = offset_in_page(start_offset + start);
 
 	while (len > 0) {
 		page = eb->pages[i];
@@ -5506,13 +5506,13 @@ void memzero_extent_buffer(struct extent_buffer *eb, unsigned long start,
 	size_t offset;
 	struct page *page;
 	char *kaddr;
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(eb->start);
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 
 	WARN_ON(start > eb->len);
 	WARN_ON(start + len > eb->start + eb->len);
 
-	offset = (start_offset + start) & (PAGE_SIZE - 1);
+	offset = offset_in_page(start_offset + start);
 
 	while (len > 0) {
 		page = eb->pages[i];
@@ -5551,13 +5551,12 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	size_t offset;
 	struct page *page;
 	char *kaddr;
-	size_t start_offset = dst->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(dst->start);
 	unsigned long i = (start_offset + dst_offset) >> PAGE_SHIFT;
 
 	WARN_ON(src->len != dst_len);
 
-	offset = (start_offset + dst_offset) &
-		(PAGE_SIZE - 1);
+	offset = offset_in_page(start_offset + dst_offset);
 
 	while (len > 0) {
 		page = dst->pages[i];
@@ -5593,7 +5592,7 @@ static inline void eb_bitmap_offset(struct extent_buffer *eb,
 				    unsigned long *page_index,
 				    size_t *page_offset)
 {
-	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(eb->start);
 	size_t byte_offset = BIT_BYTE(nr);
 	size_t offset;
 
@@ -5605,7 +5604,7 @@ static inline void eb_bitmap_offset(struct extent_buffer *eb,
 	offset = start_offset + start + byte_offset;
 
 	*page_index = offset >> PAGE_SHIFT;
-	*page_offset = offset & (PAGE_SIZE - 1);
+	*page_offset = offset_in_page(offset);
 }
 
 /**
@@ -5747,7 +5746,7 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	size_t cur;
 	size_t dst_off_in_page;
 	size_t src_off_in_page;
-	size_t start_offset = dst->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(dst->start);
 	unsigned long dst_i;
 	unsigned long src_i;
 
@@ -5765,10 +5764,8 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	}
 
 	while (len > 0) {
-		dst_off_in_page = (start_offset + dst_offset) &
-			(PAGE_SIZE - 1);
-		src_off_in_page = (start_offset + src_offset) &
-			(PAGE_SIZE - 1);
+		dst_off_in_page = offset_in_page(start_offset + dst_offset);
+		src_off_in_page = offset_in_page(start_offset + src_offset);
 
 		dst_i = (start_offset + dst_offset) >> PAGE_SHIFT;
 		src_i = (start_offset + src_offset) >> PAGE_SHIFT;
@@ -5796,7 +5793,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	size_t src_off_in_page;
 	unsigned long dst_end = dst_offset + len - 1;
 	unsigned long src_end = src_offset + len - 1;
-	size_t start_offset = dst->start & ((u64)PAGE_SIZE - 1);
+	size_t start_offset = offset_in_page(dst->start);
 	unsigned long dst_i;
 	unsigned long src_i;
 
@@ -5820,10 +5817,8 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 		dst_i = (start_offset + dst_end) >> PAGE_SHIFT;
 		src_i = (start_offset + src_end) >> PAGE_SHIFT;
 
-		dst_off_in_page = (start_offset + dst_end) &
-			(PAGE_SIZE - 1);
-		src_off_in_page = (start_offset + src_end) &
-			(PAGE_SIZE - 1);
+		dst_off_in_page = offset_in_page(start_offset + dst_end);
+		src_off_in_page = offset_in_page(start_offset + src_end);
 
 		cur = min_t(unsigned long, len, src_off_in_page + 1);
 		cur = min(cur, dst_off_in_page + 1);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3835bb8c146d..81aae230d1a5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -399,7 +399,7 @@ static noinline int btrfs_copy_from_user(loff_t pos, size_t write_bytes,
 	size_t copied = 0;
 	size_t total_copied = 0;
 	int pg = 0;
-	int offset = pos & (PAGE_SIZE - 1);
+	int offset = offset_in_page(pos);
 
 	while (write_bytes > 0) {
 		size_t count = min_t(size_t,
@@ -1611,7 +1611,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		return -ENOMEM;
 
 	while (iov_iter_count(i) > 0) {
-		size_t offset = pos & (PAGE_SIZE - 1);
+		size_t offset = offset_in_page(pos);
 		size_t sector_offset;
 		size_t write_bytes = min(iov_iter_count(i),
 					 nrptrs * (size_t)PAGE_SIZE -
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d54bdef16d8d..bc0564c384de 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -230,7 +230,7 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 				     start >> PAGE_SHIFT);
 		btrfs_set_file_extent_compression(leaf, ei, 0);
 		kaddr = kmap_atomic(page);
-		offset = start & (PAGE_SIZE - 1);
+		offset = offset_in_page(start);
 		write_extent_buffer(leaf, kaddr + offset, ptr, size);
 		kunmap_atomic(kaddr);
 		put_page(page);
@@ -539,8 +539,7 @@ static noinline void compress_file_range(struct inode *inode,
 					   &total_compressed);
 
 		if (!ret) {
-			unsigned long offset = total_compressed &
-				(PAGE_SIZE - 1);
+			unsigned long offset = offset_in_page(total_compressed);
 			struct page *page = pages[nr_pages - 1];
 			char *kaddr;
 
@@ -8878,7 +8877,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 
 	/* page is wholly or partially inside EOF */
 	if (page_start + PAGE_SIZE > size)
-		zero_start = size & ~PAGE_MASK;
+		zero_start = offset_in_page(size);
 	else
 		zero_start = PAGE_SIZE;
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5be83b5a1b43..9df4c0b0e789 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4775,7 +4775,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 	struct btrfs_key key;
 	pgoff_t index = offset >> PAGE_SHIFT;
 	pgoff_t last_index;
-	unsigned pg_offset = offset & ~PAGE_MASK;
+	unsigned pg_offset = offset_in_page(offset);
 	ssize_t ret = 0;
 
 	key.objectid = sctx->cur_ino;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d49baad64fe6..bb0430b2a8ba 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1436,7 +1436,7 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	p = kmap(*page);
 
 	/* align our pointer to the offset of the super block */
-	*disk_super = p + (bytenr & ~PAGE_MASK);
+	*disk_super = p + offset_in_page(bytenr);
 
 	if (btrfs_super_bytenr(*disk_super) != bytenr ||
 	    btrfs_super_magic(*disk_super) != BTRFS_MAGIC) {
-- 
2.16.4

