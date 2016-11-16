Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41707 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbcKPMwY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:52:24 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6zhP-0005Qr-KH
        for linux-btrfs@vger.kernel.org; Wed, 16 Nov 2016 12:52:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/9] btrfs: use bio iterators for the decompression handlers
Date: Wed, 16 Nov 2016 13:52:08 +0100
Message-Id: <1479300736-9724-2-git-send-email-hch@lst.de>
In-Reply-To: <1479300736-9724-1-git-send-email-hch@lst.de>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pass the full bio to the decompression routines and use bio iterators
to iterate over the data in the bio.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/compression.c | 122 +++++++++++++++++--------------------------------
 fs/btrfs/compression.h |  12 ++---
 fs/btrfs/lzo.c         |  17 ++-----
 fs/btrfs/zlib.c        |  15 ++----
 4 files changed, 54 insertions(+), 112 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d4d8b7e..12a631d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -81,9 +81,9 @@ struct compressed_bio {
 	u32 sums;
 };
 
-static int btrfs_decompress_biovec(int type, struct page **pages_in,
-				   u64 disk_start, struct bio_vec *bvec,
-				   int vcnt, size_t srclen);
+static int btrfs_decompress_bio(int type, struct page **pages_in,
+				   u64 disk_start, struct bio *orig_bio,
+				   size_t srclen);
 
 static inline int compressed_bio_size(struct btrfs_root *root,
 				      unsigned long disk_size)
@@ -175,11 +175,10 @@ static void end_compressed_bio_read(struct bio *bio)
 	/* ok, we're the last bio for this extent, lets start
 	 * the decompression.
 	 */
-	ret = btrfs_decompress_biovec(cb->compress_type,
+	ret = btrfs_decompress_bio(cb->compress_type,
 				      cb->compressed_pages,
 				      cb->start,
-				      cb->orig_bio->bi_io_vec,
-				      cb->orig_bio->bi_vcnt,
+				      cb->orig_bio,
 				      cb->compressed_len);
 csum_failed:
 	if (ret)
@@ -959,9 +958,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
  *
  * disk_start is the starting logical offset of this array in the file
  *
- * bvec is a bio_vec of pages from the file that we want to decompress into
- *
- * vcnt is the count of pages in the biovec
+ * orig_bio contains the pages from the file that we want to decompress into
  *
  * srclen is the number of bytes in pages_in
  *
@@ -970,18 +967,18 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
  * be contiguous.  They all correspond to the range of bytes covered by
  * the compressed extent.
  */
-static int btrfs_decompress_biovec(int type, struct page **pages_in,
-				   u64 disk_start, struct bio_vec *bvec,
-				   int vcnt, size_t srclen)
+static int btrfs_decompress_bio(int type, struct page **pages_in,
+				   u64 disk_start, struct bio *orig_bio,
+				   size_t srclen)
 {
 	struct list_head *workspace;
 	int ret;
 
 	workspace = find_workspace(type);
 
-	ret = btrfs_compress_op[type-1]->decompress_biovec(workspace, pages_in,
-							 disk_start,
-							 bvec, vcnt, srclen);
+	ret = btrfs_compress_op[type-1]->decompress_bio(workspace, pages_in,
+							 disk_start, orig_bio,
+							 srclen);
 	free_workspace(type, workspace);
 	return ret;
 }
@@ -1021,9 +1018,7 @@ void btrfs_exit_compress(void)
  */
 int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 			      unsigned long total_out, u64 disk_start,
-			      struct bio_vec *bvec, int vcnt,
-			      unsigned long *pg_index,
-			      unsigned long *pg_offset)
+			      struct bio *bio)
 {
 	unsigned long buf_offset;
 	unsigned long current_buf_start;
@@ -1031,13 +1026,13 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 	unsigned long working_bytes = total_out - buf_start;
 	unsigned long bytes;
 	char *kaddr;
-	struct page *page_out = bvec[*pg_index].bv_page;
+	struct bio_vec bvec = bio_iter_iovec(bio, bio->bi_iter);
 
 	/*
 	 * start byte is the first byte of the page we're currently
 	 * copying into relative to the start of the compressed data.
 	 */
-	start_byte = page_offset(page_out) - disk_start;
+	start_byte = page_offset(bvec.bv_page) - disk_start;
 
 	/* we haven't yet hit data corresponding to this page */
 	if (total_out <= start_byte)
@@ -1057,80 +1052,45 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 
 	/* copy bytes from the working buffer into the pages */
 	while (working_bytes > 0) {
-		bytes = min(PAGE_SIZE - *pg_offset,
-			    PAGE_SIZE - buf_offset);
+		bytes = min_t(unsigned long, bvec.bv_len,
+				PAGE_SIZE - buf_offset);
 		bytes = min(bytes, working_bytes);
-		kaddr = kmap_atomic(page_out);
-		memcpy(kaddr + *pg_offset, buf + buf_offset, bytes);
+
+		kaddr = kmap_atomic(bvec.bv_page);
+		memcpy(kaddr + bvec.bv_offset, buf + buf_offset, bytes);
 		kunmap_atomic(kaddr);
-		flush_dcache_page(page_out);
+		flush_dcache_page(bvec.bv_page);
 
-		*pg_offset += bytes;
 		buf_offset += bytes;
 		working_bytes -= bytes;
 		current_buf_start += bytes;
 
 		/* check if we need to pick another page */
-		if (*pg_offset == PAGE_SIZE) {
-			(*pg_index)++;
-			if (*pg_index >= vcnt)
-				return 0;
+		bio_advance(bio, bytes);
+		if (!bio->bi_iter.bi_size)
+			return 0;
 
-			page_out = bvec[*pg_index].bv_page;
-			*pg_offset = 0;
-			start_byte = page_offset(page_out) - disk_start;
+		start_byte = page_offset(bvec.bv_page) - disk_start;
 
-			/*
-			 * make sure our new page is covered by this
-			 * working buffer
-			 */
-			if (total_out <= start_byte)
-				return 1;
+		/*
+		 * make sure our new page is covered by this
+		 * working buffer
+		 */
+		if (total_out <= start_byte)
+			return 1;
 
-			/*
-			 * the next page in the biovec might not be adjacent
-			 * to the last page, but it might still be found
-			 * inside this working buffer. bump our offset pointer
-			 */
-			if (total_out > start_byte &&
-			    current_buf_start < start_byte) {
-				buf_offset = start_byte - buf_start;
-				working_bytes = total_out - start_byte;
-				current_buf_start = buf_start + buf_offset;
-			}
+		/*
+		 * the next page in the biovec might not be adjacent
+		 * to the last page, but it might still be found
+		 * inside this working buffer. bump our offset pointer
+		 */
+		if (total_out > start_byte &&
+		    current_buf_start < start_byte) {
+			buf_offset = start_byte - buf_start;
+			working_bytes = total_out - start_byte;
+			current_buf_start = buf_start + buf_offset;
 		}
 	}
 
 	return 1;
 }
-
-/*
- * When uncompressing data, we need to make sure and zero any parts of
- * the biovec that were not filled in by the decompression code.  pg_index
- * and pg_offset indicate the last page and the last offset of that page
- * that have been filled in.  This will zero everything remaining in the
- * biovec.
- */
-void btrfs_clear_biovec_end(struct bio_vec *bvec, int vcnt,
-				   unsigned long pg_index,
-				   unsigned long pg_offset)
-{
-	while (pg_index < vcnt) {
-		struct page *page = bvec[pg_index].bv_page;
-		unsigned long off = bvec[pg_index].bv_offset;
-		unsigned long len = bvec[pg_index].bv_len;
-
-		if (pg_offset < off)
-			pg_offset = off;
-		if (pg_offset < off + len) {
-			unsigned long bytes = off + len - pg_offset;
-			char *kaddr;
-
-			kaddr = kmap_atomic(page);
-			memset(kaddr + pg_offset, 0, bytes);
-			kunmap_atomic(kaddr);
-		}
-		pg_index++;
-		pg_offset = 0;
-	}
-}
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index f49d8b8..0987957 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -34,9 +34,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 		     unsigned long start_byte, size_t srclen, size_t destlen);
 int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 			      unsigned long total_out, u64 disk_start,
-			      struct bio_vec *bvec, int vcnt,
-			      unsigned long *pg_index,
-			      unsigned long *pg_offset);
+			      struct bio *bio);
 
 int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				  unsigned long len, u64 disk_start,
@@ -45,9 +43,6 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				  unsigned long nr_pages);
 int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags);
-void btrfs_clear_biovec_end(struct bio_vec *bvec, int vcnt,
-				   unsigned long pg_index,
-				   unsigned long pg_offset);
 
 enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
@@ -72,11 +67,10 @@ struct btrfs_compress_op {
 			      unsigned long *total_out,
 			      unsigned long max_out);
 
-	int (*decompress_biovec)(struct list_head *workspace,
+	int (*decompress_bio)(struct list_head *workspace,
 				 struct page **pages_in,
 				 u64 disk_start,
-				 struct bio_vec *bvec,
-				 int vcnt,
+				 struct bio *orig_bio,
 				 size_t srclen);
 
 	int (*decompress)(struct list_head *workspace,
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 48655da..45d2698 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -254,25 +254,21 @@ static int lzo_compress_pages(struct list_head *ws,
 	return ret;
 }
 
-static int lzo_decompress_biovec(struct list_head *ws,
+static int lzo_decompress_bio(struct list_head *ws,
 				 struct page **pages_in,
 				 u64 disk_start,
-				 struct bio_vec *bvec,
-				 int vcnt,
+				 struct bio *orig_bio,
 				 size_t srclen)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	int ret = 0, ret2;
 	char *data_in;
 	unsigned long page_in_index = 0;
-	unsigned long page_out_index = 0;
 	unsigned long total_pages_in = DIV_ROUND_UP(srclen, PAGE_SIZE);
 	unsigned long buf_start;
 	unsigned long buf_offset = 0;
 	unsigned long bytes;
 	unsigned long working_bytes;
-	unsigned long pg_offset;
-
 	size_t in_len;
 	size_t out_len;
 	unsigned long in_offset;
@@ -292,7 +288,6 @@ static int lzo_decompress_biovec(struct list_head *ws,
 	in_page_bytes_left = PAGE_SIZE - LZO_LEN;
 
 	tot_out = 0;
-	pg_offset = 0;
 
 	while (tot_in < tot_len) {
 		in_len = read_compress_length(data_in + in_offset);
@@ -365,16 +360,14 @@ static int lzo_decompress_biovec(struct list_head *ws,
 		tot_out += out_len;
 
 		ret2 = btrfs_decompress_buf2page(workspace->buf, buf_start,
-						 tot_out, disk_start,
-						 bvec, vcnt,
-						 &page_out_index, &pg_offset);
+						 tot_out, disk_start, orig_bio);
 		if (ret2 == 0)
 			break;
 	}
 done:
 	kunmap(pages_in[page_in_index]);
 	if (!ret)
-		btrfs_clear_biovec_end(bvec, vcnt, page_out_index, pg_offset);
+		zero_fill_bio(orig_bio);
 	return ret;
 }
 
@@ -438,6 +431,6 @@ const struct btrfs_compress_op btrfs_lzo_compress = {
 	.alloc_workspace	= lzo_alloc_workspace,
 	.free_workspace		= lzo_free_workspace,
 	.compress_pages		= lzo_compress_pages,
-	.decompress_biovec	= lzo_decompress_biovec,
+	.decompress_bio		= lzo_decompress_bio,
 	.decompress		= lzo_decompress,
 };
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 441b81a..0d5f28e 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -210,10 +210,9 @@ static int zlib_compress_pages(struct list_head *ws,
 	return ret;
 }
 
-static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
+static int zlib_decompress_bio(struct list_head *ws, struct page **pages_in,
 				  u64 disk_start,
-				  struct bio_vec *bvec,
-				  int vcnt,
+				  struct bio *orig_bio,
 				  size_t srclen)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
@@ -222,10 +221,8 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 	char *data_in;
 	size_t total_out = 0;
 	unsigned long page_in_index = 0;
-	unsigned long page_out_index = 0;
 	unsigned long total_pages_in = DIV_ROUND_UP(srclen, PAGE_SIZE);
 	unsigned long buf_start;
-	unsigned long pg_offset;
 
 	data_in = kmap(pages_in[page_in_index]);
 	workspace->strm.next_in = data_in;
@@ -235,7 +232,6 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 	workspace->strm.total_out = 0;
 	workspace->strm.next_out = workspace->buf;
 	workspace->strm.avail_out = PAGE_SIZE;
-	pg_offset = 0;
 
 	/* If it's deflate, and it's got no preset dictionary, then
 	   we can tell zlib to skip the adler32 check. */
@@ -266,8 +262,7 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 
 		ret2 = btrfs_decompress_buf2page(workspace->buf, buf_start,
 						 total_out, disk_start,
-						 bvec, vcnt,
-						 &page_out_index, &pg_offset);
+						 orig_bio);
 		if (ret2 == 0) {
 			ret = 0;
 			goto done;
@@ -300,7 +295,7 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 	if (data_in)
 		kunmap(pages_in[page_in_index]);
 	if (!ret)
-		btrfs_clear_biovec_end(bvec, vcnt, page_out_index, pg_offset);
+		zero_fill_bio(orig_bio);
 	return ret;
 }
 
@@ -407,6 +402,6 @@ const struct btrfs_compress_op btrfs_zlib_compress = {
 	.alloc_workspace	= zlib_alloc_workspace,
 	.free_workspace		= zlib_free_workspace,
 	.compress_pages		= zlib_compress_pages,
-	.decompress_biovec	= zlib_decompress_biovec,
+	.decompress_bio		= zlib_decompress_bio,
 	.decompress		= zlib_decompress,
 };
-- 
2.1.4

