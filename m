From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/5] btrfs: Extract duplicate decompress code
Date: Mon, 25 Oct 2010 15:13:14 +0800
Message-ID: <4CC52E0A.9070005@cn.fujitsu.com>
References: <4CC52D9A.3030709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CC52D9A.3030709@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add a common function to copy decompressed data from working buffer
to bio pages.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/compression.c |   92 +++++++++++++++++++++++++++++++++++++++
 fs/btrfs/compression.h |    5 ++
 fs/btrfs/lzo.c         |  101 +++-----------------------------------------
 fs/btrfs/zlib.c        |  111 +++++------------------------------------------
 4 files changed, 115 insertions(+), 194 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 84c5490..c7f695b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -927,3 +927,95 @@ void __exit btrfs_exit_compress(void)
 {
     free_workspaces();
 }
+
+/*
+ * Copy uncompressed data from working buffer to pages.
+ *
+ * buf_start is the byte offset we're of the start of our workspace buffer.
+ *
+ * total_out is the last byte of the buffer
+ */
+int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
+			      unsigned long total_out, u64 disk_start,
+			      struct bio_vec *bvec, int vcnt,
+			      unsigned long *page_index,
+			      unsigned long *pg_offset)
+{
+	unsigned long buf_offset;
+	unsigned long current_buf_start;
+	unsigned long start_byte;
+	unsigned long working_bytes = total_out - buf_start;
+	unsigned long bytes;
+	char *kaddr;
+	struct page *page_out = bvec[*page_index].bv_page;
+
+	/*
+	 * start byte is the first byte of the page we're currently
+	 * copying into relative to the start of the compressed data.
+	 */
+	start_byte = page_offset(page_out) - disk_start;
+
+	/* we haven't yet hit data corresponding to this page */
+	if (total_out <= start_byte)
+		return 1;
+
+	/*
+	 * the start of the data we care about is offset into
+	 * the middle of our working buffer
+	 */
+	if (total_out > start_byte && buf_start < start_byte) {
+		buf_offset = start_byte - buf_start;
+		working_bytes -= buf_offset;
+	} else {
+		buf_offset = 0;
+	}
+	current_buf_start = buf_start;
+
+	/* copy bytes from the working buffer into the pages */
+	while (working_bytes > 0) {
+		bytes = min(PAGE_CACHE_SIZE - *pg_offset,
+			    PAGE_CACHE_SIZE - buf_offset);
+		bytes = min(bytes, working_bytes);
+		kaddr = kmap_atomic(page_out, KM_USER0);
+		memcpy(kaddr + *pg_offset, buf + buf_offset, bytes);
+		kunmap_atomic(kaddr, KM_USER0);
+		flush_dcache_page(page_out);
+
+		*pg_offset += bytes;
+		buf_offset += bytes;
+		working_bytes -= bytes;
+		current_buf_start += bytes;
+
+		/* check if we need to pick another page */
+		if (*pg_offset == PAGE_CACHE_SIZE) {
+			(*page_index)++;
+			if (*page_index >= vcnt)
+				return 0;
+
+			page_out = bvec[*page_index].bv_page;
+			*pg_offset = 0;
+			start_byte = page_offset(page_out) - disk_start;
+
+			/*
+			 * make sure our new page is covered by this
+			 * working buffer
+			 */
+			if (total_out <= start_byte)
+				return 1;
+
+			/*
+			 * the next page in the biovec might not be adjacent
+			 * to the last page, but it might still be found
+			 * inside this working buffer. bump our offset pointer
+			 */
+			if (total_out > start_byte &&
+			    current_buf_start < start_byte) {
+				buf_offset = start_byte - buf_start;
+				working_bytes = total_out - start_byte;
+				current_buf_start = buf_start + buf_offset;
+			}
+		}
+	}
+
+	return 1;
+}
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index f7ce217..5100017 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -34,6 +34,11 @@ int btrfs_decompress_biovec(int type, struct page **pages_in, u64 disk_start,
 			    struct bio_vec *bvec, int vcnt, size_t srclen);
 int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 		     unsigned long start_byte, size_t srclen, size_t destlen);
+int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
+			      unsigned long total_out, u64 disk_start,
+			      struct bio_vec *bvec, int vcnt,
+			      unsigned long *page_index,
+			      unsigned long *pg_offset);
 
 int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				  unsigned long len, u64 disk_start,
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 0a518f3..3d91e28 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -249,12 +249,10 @@ static int lzo_decompress_biovec(struct list_head *ws,
 				 size_t srclen)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	int ret = 0;
+	int ret = 0, ret2;
 	char *data_in;
-	unsigned long page_bytes_left;
 	unsigned long page_in_index = 0;
 	unsigned long page_out_index = 0;
-	struct page *page_out;
 	unsigned long total_pages_in = (srclen + PAGE_CACHE_SIZE - 1) /
 					PAGE_CACHE_SIZE;
 	unsigned long buf_start;
@@ -262,9 +260,6 @@ static int lzo_decompress_biovec(struct list_head *ws,
 	unsigned long bytes;
 	unsigned long working_bytes;
 	unsigned long pg_offset;
-	unsigned long start_byte;
-	unsigned long current_buf_start;
-	char *kaddr;
 
 	size_t in_len;
 	size_t out_len;
@@ -284,8 +279,6 @@ static int lzo_decompress_biovec(struct list_head *ws,
 	in_page_bytes_left = PAGE_CACHE_SIZE - LZO_LEN;
 
 	tot_out = 0;
-	page_out = bvec[0].bv_page;
-	page_bytes_left = PAGE_CACHE_SIZE;
 	pg_offset = 0;
 
 	while (tot_in < tot_len) {
@@ -348,97 +341,15 @@ cont:
 			break;
 		}
 
-		/*
-		 * buf start is the byte offset we're of the start of
-		 * our workspace buffer
-		 */
 		buf_start = tot_out;
-
-		/* tot_out is the last byte of the workspace buffer */
 		tot_out += out_len;
 
-		working_bytes = tot_out - buf_start;
-
-		/*
-		 * start_byte is the first byte of the page we're currently
-		 * copying into relative to the start of the compressed data.
-		 */
-		start_byte = page_offset(page_out) - disk_start;
-
-		if (working_bytes == 0) {
-			/* we didn't make progress in this inflate
-			 * call, we're done
-			 */
+		ret2 = btrfs_decompress_buf2page(workspace->buf, buf_start,
+						 tot_out, disk_start,
+						 bvec, vcnt,
+						 &page_out_index, &pg_offset);
+		if (ret2 == 0)
 			break;
-		}
-
-		/* we haven't yet hit data corresponding to this page */
-		if (tot_out <= start_byte)
-			continue;
-
-		/*
-		 * the start of the data we care about is offset into
-		 * the middle of our working buffer
-		 */
-		if (tot_out > start_byte && buf_start < start_byte) {
-			buf_offset = start_byte - buf_start;
-			working_bytes -= buf_offset;
-		} else {
-			buf_offset = 0;
-		}
-		current_buf_start = buf_start;
-
-		/* copy bytes from the working buffer into the pages */
-		while (working_bytes > 0) {
-			bytes = min(PAGE_CACHE_SIZE - pg_offset,
-				    PAGE_CACHE_SIZE - buf_offset);
-			bytes = min(bytes, working_bytes);
-			kaddr = kmap_atomic(page_out, KM_USER0);
-			memcpy(kaddr + pg_offset, workspace->buf + buf_offset,
-			       bytes);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(page_out);
-
-			pg_offset += bytes;
-			page_bytes_left -= bytes;
-			buf_offset += bytes;
-			working_bytes -= bytes;
-			current_buf_start += bytes;
-
-			/* check if we need to pick another page */
-			if (page_bytes_left == 0) {
-				page_out_index++;
-				if (page_out_index >= vcnt) {
-					ret = 0;
-					goto done;
-				}
-
-				page_out = bvec[page_out_index].bv_page;
-				pg_offset = 0;
-				page_bytes_left = PAGE_CACHE_SIZE;
-				start_byte = page_offset(page_out) - disk_start;
-
-				/*
-				 * make sure our new page is covered by this
-				 * working buffer
-				 */
-				if (tot_out <= start_byte)
-					break;
-
-				/* the next page in the biovec might not
-				 * be adjacent to the last page, but it
-				 * might still be found inside this working
-				 * buffer.  bump our offset pointer
-				 */
-				if (tot_out > start_byte &&
-				    current_buf_start < start_byte) {
-					buf_offset = start_byte - buf_start;
-					working_bytes = tot_out - start_byte;
-					current_buf_start = buf_start +
-						buf_offset;
-				}
-			}
-		}
 	}
 done:
 	if (data_in)
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 3d8c501..4053472 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -210,24 +210,16 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 				  size_t srclen)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	int ret = 0;
+	int ret = 0, ret2;
 	int wbits = MAX_WBITS;
 	char *data_in;
 	size_t total_out = 0;
-	unsigned long page_bytes_left;
 	unsigned long page_in_index = 0;
 	unsigned long page_out_index = 0;
-	struct page *page_out;
 	unsigned long total_pages_in = (srclen + PAGE_CACHE_SIZE - 1) /
 					PAGE_CACHE_SIZE;
 	unsigned long buf_start;
-	unsigned long buf_offset;
-	unsigned long bytes;
-	unsigned long working_bytes;
 	unsigned long pg_offset;
-	unsigned long start_byte;
-	unsigned long current_buf_start;
-	char *kaddr;
 
 	data_in = kmap(pages_in[page_in_index]);
 	workspace->inf_strm.next_in = data_in;
@@ -237,8 +229,6 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 	workspace->inf_strm.total_out = 0;
 	workspace->inf_strm.next_out = workspace->buf;
 	workspace->inf_strm.avail_out = PAGE_CACHE_SIZE;
-	page_out = bvec[page_out_index].bv_page;
-	page_bytes_left = PAGE_CACHE_SIZE;
 	pg_offset = 0;
 
 	/* If it's deflate, and it's got no preset dictionary, then
@@ -260,100 +250,23 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 		ret = zlib_inflate(&workspace->inf_strm, Z_NO_FLUSH);
 		if (ret != Z_OK && ret != Z_STREAM_END)
 			break;
-		/*
-		 * buf start is the byte offset we're of the start of
-		 * our workspace buffer
-		 */
-		buf_start = total_out;
 
-		/* total_out is the last byte of the workspace buffer */
+		buf_start = total_out;
 		total_out = workspace->inf_strm.total_out;
 
-		working_bytes = total_out - buf_start;
-
-		/*
-		 * start byte is the first byte of the page we're currently
-		 * copying into relative to the start of the compressed data.
-		 */
-		start_byte = page_offset(page_out) - disk_start;
-
-		if (working_bytes == 0) {
-			/* we didn't make progress in this inflate
-			 * call, we're done
-			 */
-			if (ret != Z_STREAM_END)
-				ret = -1;
+		/* we didn't make progress in this inflate call, we're done */
+		if (buf_start == total_out)
 			break;
-		}
 
-		/* we haven't yet hit data corresponding to this page */
-		if (total_out <= start_byte)
-			goto next;
-
-		/*
-		 * the start of the data we care about is offset into
-		 * the middle of our working buffer
-		 */
-		if (total_out > start_byte && buf_start < start_byte) {
-			buf_offset = start_byte - buf_start;
-			working_bytes -= buf_offset;
-		} else {
-			buf_offset = 0;
-		}
-		current_buf_start = buf_start;
-
-		/* copy bytes from the working buffer into the pages */
-		while (working_bytes > 0) {
-			bytes = min(PAGE_CACHE_SIZE - pg_offset,
-				    PAGE_CACHE_SIZE - buf_offset);
-			bytes = min(bytes, working_bytes);
-			kaddr = kmap_atomic(page_out, KM_USER0);
-			memcpy(kaddr + pg_offset, workspace->buf + buf_offset,
-			       bytes);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(page_out);
-
-			pg_offset += bytes;
-			page_bytes_left -= bytes;
-			buf_offset += bytes;
-			working_bytes -= bytes;
-			current_buf_start += bytes;
-
-			/* check if we need to pick another page */
-			if (page_bytes_left == 0) {
-				page_out_index++;
-				if (page_out_index >= vcnt) {
-					ret = 0;
-					goto done;
-				}
-
-				page_out = bvec[page_out_index].bv_page;
-				pg_offset = 0;
-				page_bytes_left = PAGE_CACHE_SIZE;
-				start_byte = page_offset(page_out) - disk_start;
-
-				/*
-				 * make sure our new page is covered by this
-				 * working buffer
-				 */
-				if (total_out <= start_byte)
-					goto next;
-
-				/* the next page in the biovec might not
-				 * be adjacent to the last page, but it
-				 * might still be found inside this working
-				 * buffer.  bump our offset pointer
-				 */
-				if (total_out > start_byte &&
-				    current_buf_start < start_byte) {
-					buf_offset = start_byte - buf_start;
-					working_bytes = total_out - start_byte;
-					current_buf_start = buf_start +
-						buf_offset;
-				}
-			}
+		ret2 = btrfs_decompress_buf2page(workspace->buf, buf_start,
+						 total_out, disk_start,
+						 bvec, vcnt,
+						 &page_out_index, &pg_offset);
+		if (ret2 == 0) {
+			ret = 0;
+			goto done;
 		}
-next:
+
 		workspace->inf_strm.next_out = workspace->buf;
 		workspace->inf_strm.avail_out = PAGE_CACHE_SIZE;
 
-- 
1.7.0.1

