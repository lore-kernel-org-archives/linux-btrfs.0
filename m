Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42372 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753066AbdKOR3g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:29:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3F187ABD9
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 17:29:35 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: move some zstd work data from stack to workspace
Date: Wed, 15 Nov 2017 18:27:39 +0100
Message-Id: <20171115172739.25017-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* ZSTD_inBuffer in_buf
* ZSTD_outBuffer out_buf

are used in all functions to pass the compression parameters and the
local variables consume some space. We can move them to the workspace
and reduce the stack consumption:

zstd.c:zstd_decompress                        -24 (136 -> 112)
zstd.c:zstd_decompress_bio                    -24 (144 -> 120)
zstd.c:zstd_compress_pages                    -24 (264 -> 240)

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/zstd.c | 132 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 67 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 17f2dd8fddb8..01a4eab602a3 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -43,6 +43,8 @@ struct workspace {
 	size_t size;
 	char *buf;
 	struct list_head list;
+	ZSTD_inBuffer in_buf;
+	ZSTD_outBuffer out_buf;
 };
 
 static void zstd_free_workspace(struct list_head *ws)
@@ -94,8 +96,6 @@ static int zstd_compress_pages(struct list_head *ws,
 	int nr_pages = 0;
 	struct page *in_page = NULL;  /* The current page to read */
 	struct page *out_page = NULL; /* The current page to write to */
-	ZSTD_inBuffer in_buf = { NULL, 0, 0 };
-	ZSTD_outBuffer out_buf = { NULL, 0, 0 };
 	unsigned long tot_in = 0;
 	unsigned long tot_out = 0;
 	unsigned long len = *total_out;
@@ -118,9 +118,9 @@ static int zstd_compress_pages(struct list_head *ws,
 
 	/* map in the first page of input data */
 	in_page = find_get_page(mapping, start >> PAGE_SHIFT);
-	in_buf.src = kmap(in_page);
-	in_buf.pos = 0;
-	in_buf.size = min_t(size_t, len, PAGE_SIZE);
+	workspace->in_buf.src = kmap(in_page);
+	workspace->in_buf.pos = 0;
+	workspace->in_buf.size = min_t(size_t, len, PAGE_SIZE);
 
 
 	/* Allocate and map in the output buffer */
@@ -130,14 +130,15 @@ static int zstd_compress_pages(struct list_head *ws,
 		goto out;
 	}
 	pages[nr_pages++] = out_page;
-	out_buf.dst = kmap(out_page);
-	out_buf.pos = 0;
-	out_buf.size = min_t(size_t, max_out, PAGE_SIZE);
+	workspace->out_buf.dst = kmap(out_page);
+	workspace->out_buf.pos = 0;
+	workspace->out_buf.size = min_t(size_t, max_out, PAGE_SIZE);
 
 	while (1) {
 		size_t ret2;
 
-		ret2 = ZSTD_compressStream(stream, &out_buf, &in_buf);
+		ret2 = ZSTD_compressStream(stream, &workspace->out_buf,
+				&workspace->in_buf);
 		if (ZSTD_isError(ret2)) {
 			pr_debug("BTRFS: ZSTD_compressStream returned %d\n",
 					ZSTD_getErrorCode(ret2));
@@ -146,22 +147,22 @@ static int zstd_compress_pages(struct list_head *ws,
 		}
 
 		/* Check to see if we are making it bigger */
-		if (tot_in + in_buf.pos > 8192 &&
-				tot_in + in_buf.pos <
-				tot_out + out_buf.pos) {
+		if (tot_in + workspace->in_buf.pos > 8192 &&
+				tot_in + workspace->in_buf.pos <
+				tot_out + workspace->out_buf.pos) {
 			ret = -E2BIG;
 			goto out;
 		}
 
 		/* We've reached the end of our output range */
-		if (out_buf.pos >= max_out) {
-			tot_out += out_buf.pos;
+		if (workspace->out_buf.pos >= max_out) {
+			tot_out += workspace->out_buf.pos;
 			ret = -E2BIG;
 			goto out;
 		}
 
 		/* Check if we need more output space */
-		if (out_buf.pos == out_buf.size) {
+		if (workspace->out_buf.pos == workspace->out_buf.size) {
 			tot_out += PAGE_SIZE;
 			max_out -= PAGE_SIZE;
 			kunmap(out_page);
@@ -176,19 +177,20 @@ static int zstd_compress_pages(struct list_head *ws,
 				goto out;
 			}
 			pages[nr_pages++] = out_page;
-			out_buf.dst = kmap(out_page);
-			out_buf.pos = 0;
-			out_buf.size = min_t(size_t, max_out, PAGE_SIZE);
+			workspace->out_buf.dst = kmap(out_page);
+			workspace->out_buf.pos = 0;
+			workspace->out_buf.size = min_t(size_t, max_out,
+							PAGE_SIZE);
 		}
 
 		/* We've reached the end of the input */
-		if (in_buf.pos >= len) {
-			tot_in += in_buf.pos;
+		if (workspace->in_buf.pos >= len) {
+			tot_in += workspace->in_buf.pos;
 			break;
 		}
 
 		/* Check if we need more input */
-		if (in_buf.pos == in_buf.size) {
+		if (workspace->in_buf.pos == workspace->in_buf.size) {
 			tot_in += PAGE_SIZE;
 			kunmap(in_page);
 			put_page(in_page);
@@ -196,15 +198,15 @@ static int zstd_compress_pages(struct list_head *ws,
 			start += PAGE_SIZE;
 			len -= PAGE_SIZE;
 			in_page = find_get_page(mapping, start >> PAGE_SHIFT);
-			in_buf.src = kmap(in_page);
-			in_buf.pos = 0;
-			in_buf.size = min_t(size_t, len, PAGE_SIZE);
+			workspace->in_buf.src = kmap(in_page);
+			workspace->in_buf.pos = 0;
+			workspace->in_buf.size = min_t(size_t, len, PAGE_SIZE);
 		}
 	}
 	while (1) {
 		size_t ret2;
 
-		ret2 = ZSTD_endStream(stream, &out_buf);
+		ret2 = ZSTD_endStream(stream, &workspace->out_buf);
 		if (ZSTD_isError(ret2)) {
 			pr_debug("BTRFS: ZSTD_endStream returned %d\n",
 					ZSTD_getErrorCode(ret2));
@@ -212,11 +214,11 @@ static int zstd_compress_pages(struct list_head *ws,
 			goto out;
 		}
 		if (ret2 == 0) {
-			tot_out += out_buf.pos;
+			tot_out += workspace->out_buf.pos;
 			break;
 		}
-		if (out_buf.pos >= max_out) {
-			tot_out += out_buf.pos;
+		if (workspace->out_buf.pos >= max_out) {
+			tot_out += workspace->out_buf.pos;
 			ret = -E2BIG;
 			goto out;
 		}
@@ -235,9 +237,9 @@ static int zstd_compress_pages(struct list_head *ws,
 			goto out;
 		}
 		pages[nr_pages++] = out_page;
-		out_buf.dst = kmap(out_page);
-		out_buf.pos = 0;
-		out_buf.size = min_t(size_t, max_out, PAGE_SIZE);
+		workspace->out_buf.dst = kmap(out_page);
+		workspace->out_buf.pos = 0;
+		workspace->out_buf.size = min_t(size_t, max_out, PAGE_SIZE);
 	}
 
 	if (tot_out >= tot_in) {
@@ -273,8 +275,6 @@ static int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 	unsigned long total_pages_in = DIV_ROUND_UP(srclen, PAGE_SIZE);
 	unsigned long buf_start;
 	unsigned long total_out = 0;
-	ZSTD_inBuffer in_buf = { NULL, 0, 0 };
-	ZSTD_outBuffer out_buf = { NULL, 0, 0 };
 
 	stream = ZSTD_initDStream(
 			ZSTD_BTRFS_MAX_INPUT, workspace->mem, workspace->size);
@@ -284,18 +284,19 @@ static int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 		goto done;
 	}
 
-	in_buf.src = kmap(pages_in[page_in_index]);
-	in_buf.pos = 0;
-	in_buf.size = min_t(size_t, srclen, PAGE_SIZE);
+	workspace->in_buf.src = kmap(pages_in[page_in_index]);
+	workspace->in_buf.pos = 0;
+	workspace->in_buf.size = min_t(size_t, srclen, PAGE_SIZE);
 
-	out_buf.dst = workspace->buf;
-	out_buf.pos = 0;
-	out_buf.size = PAGE_SIZE;
+	workspace->out_buf.dst = workspace->buf;
+	workspace->out_buf.pos = 0;
+	workspace->out_buf.size = PAGE_SIZE;
 
 	while (1) {
 		size_t ret2;
 
-		ret2 = ZSTD_decompressStream(stream, &out_buf, &in_buf);
+		ret2 = ZSTD_decompressStream(stream, &workspace->out_buf,
+				&workspace->in_buf);
 		if (ZSTD_isError(ret2)) {
 			pr_debug("BTRFS: ZSTD_decompressStream returned %d\n",
 					ZSTD_getErrorCode(ret2));
@@ -303,38 +304,38 @@ static int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 			goto done;
 		}
 		buf_start = total_out;
-		total_out += out_buf.pos;
-		out_buf.pos = 0;
+		total_out += workspace->out_buf.pos;
+		workspace->out_buf.pos = 0;
 
-		ret = btrfs_decompress_buf2page(out_buf.dst, buf_start,
-				total_out, disk_start, orig_bio);
+		ret = btrfs_decompress_buf2page(workspace->out_buf.dst,
+				buf_start, total_out, disk_start, orig_bio);
 		if (ret == 0)
 			break;
 
-		if (in_buf.pos >= srclen)
+		if (workspace->in_buf.pos >= srclen)
 			break;
 
 		/* Check if we've hit the end of a frame */
 		if (ret2 == 0)
 			break;
 
-		if (in_buf.pos == in_buf.size) {
+		if (workspace->in_buf.pos == workspace->in_buf.size) {
 			kunmap(pages_in[page_in_index++]);
 			if (page_in_index >= total_pages_in) {
-				in_buf.src = NULL;
+				workspace->in_buf.src = NULL;
 				ret = -EIO;
 				goto done;
 			}
 			srclen -= PAGE_SIZE;
-			in_buf.src = kmap(pages_in[page_in_index]);
-			in_buf.pos = 0;
-			in_buf.size = min_t(size_t, srclen, PAGE_SIZE);
+			workspace->in_buf.src = kmap(pages_in[page_in_index]);
+			workspace->in_buf.pos = 0;
+			workspace->in_buf.size = min_t(size_t, srclen, PAGE_SIZE);
 		}
 	}
 	ret = 0;
 	zero_fill_bio(orig_bio);
 done:
-	if (in_buf.src)
+	if (workspace->in_buf.src)
 		kunmap(pages_in[page_in_index]);
 	return ret;
 }
@@ -348,8 +349,6 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 	ZSTD_DStream *stream;
 	int ret = 0;
 	size_t ret2;
-	ZSTD_inBuffer in_buf = { NULL, 0, 0 };
-	ZSTD_outBuffer out_buf = { NULL, 0, 0 };
 	unsigned long total_out = 0;
 	unsigned long pg_offset = 0;
 	char *kaddr;
@@ -364,16 +363,17 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 
 	destlen = min_t(size_t, destlen, PAGE_SIZE);
 
-	in_buf.src = data_in;
-	in_buf.pos = 0;
-	in_buf.size = srclen;
+	workspace->in_buf.src = data_in;
+	workspace->in_buf.pos = 0;
+	workspace->in_buf.size = srclen;
 
-	out_buf.dst = workspace->buf;
-	out_buf.pos = 0;
-	out_buf.size = PAGE_SIZE;
+	workspace->out_buf.dst = workspace->buf;
+	workspace->out_buf.pos = 0;
+	workspace->out_buf.size = PAGE_SIZE;
 
 	ret2 = 1;
-	while (pg_offset < destlen && in_buf.pos < in_buf.size) {
+	while (pg_offset < destlen
+	       && workspace->in_buf.pos < workspace->in_buf.size) {
 		unsigned long buf_start;
 		unsigned long buf_offset;
 		unsigned long bytes;
@@ -384,7 +384,8 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 			ret = -EIO;
 			goto finish;
 		}
-		ret2 = ZSTD_decompressStream(stream, &out_buf, &in_buf);
+		ret2 = ZSTD_decompressStream(stream, &workspace->out_buf,
+				&workspace->in_buf);
 		if (ZSTD_isError(ret2)) {
 			pr_debug("BTRFS: ZSTD_decompressStream returned %d\n",
 					ZSTD_getErrorCode(ret2));
@@ -393,8 +394,8 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 		}
 
 		buf_start = total_out;
-		total_out += out_buf.pos;
-		out_buf.pos = 0;
+		total_out += workspace->out_buf.pos;
+		workspace->out_buf.pos = 0;
 
 		if (total_out <= start_byte)
 			continue;
@@ -405,10 +406,11 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 			buf_offset = 0;
 
 		bytes = min_t(unsigned long, destlen - pg_offset,
-				out_buf.size - buf_offset);
+				workspace->out_buf.size - buf_offset);
 
 		kaddr = kmap_atomic(dest_page);
-		memcpy(kaddr + pg_offset, out_buf.dst + buf_offset, bytes);
+		memcpy(kaddr + pg_offset, workspace->out_buf.dst + buf_offset,
+				bytes);
 		kunmap_atomic(kaddr);
 
 		pg_offset += bytes;
-- 
2.14.3

