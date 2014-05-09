Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:47231 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbaEIVPP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 17:15:15 -0400
Received: from f18.lab.localdomain (lenny.home.zabbo.net [192.168.242.10])
	by tetsuo.zabbo.net (Postfix) with ESMTP id 4A4AE7200275
	for <linux-btrfs@vger.kernel.org>; Fri,  9 May 2014 14:15:14 -0700 (PDT)
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: return errno instead of -1 from compression
Date: Fri,  9 May 2014 17:15:08 -0400
Message-Id: <1399670110-3335-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The compression layer seems to have been built to return -1 and have
callers make up errors that make sense.  This isn't great because there
are different errors that originate down in the compression layer.

Let's return real negative errnos from the compression layer so that
callers can pass on the error without having to guess what happened.
ENOMEM for allocation failure, E2BIG when compression exceeds the
uncompressed input, and EIO for everything else.

This helps a future path return errors from btrfs_decompress().

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/lzo.c  | 14 +++++++-------
 fs/btrfs/zlib.c | 26 +++++++++++++-------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index b47f669..dfad851 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -143,7 +143,7 @@ static int lzo_compress_pages(struct list_head *ws,
 		if (ret != LZO_E_OK) {
 			printk(KERN_DEBUG "BTRFS: deflate in loop returned %d\n",
 			       ret);
-			ret = -1;
+			ret = -EIO;
 			goto out;
 		}
 
@@ -189,7 +189,7 @@ static int lzo_compress_pages(struct list_head *ws,
 				kunmap(out_page);
 				if (nr_pages == nr_dest_pages) {
 					out_page = NULL;
-					ret = -1;
+					ret = -E2BIG;
 					goto out;
 				}
 
@@ -208,7 +208,7 @@ static int lzo_compress_pages(struct list_head *ws,
 
 		/* we're making it bigger, give up */
 		if (tot_in > 8192 && tot_in < tot_out) {
-			ret = -1;
+			ret = -E2BIG;
 			goto out;
 		}
 
@@ -335,7 +335,7 @@ cont:
 					break;
 
 				if (page_in_index + 1 >= total_pages_in) {
-					ret = -1;
+					ret = -EIO;
 					goto done;
 				}
 
@@ -358,7 +358,7 @@ cont:
 			kunmap(pages_in[page_in_index - 1]);
 		if (ret != LZO_E_OK) {
 			printk(KERN_WARNING "BTRFS: decompress failed\n");
-			ret = -1;
+			ret = -EIO;
 			break;
 		}
 
@@ -402,12 +402,12 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	ret = lzo1x_decompress_safe(data_in, in_len, workspace->buf, &out_len);
 	if (ret != LZO_E_OK) {
 		printk(KERN_WARNING "BTRFS: decompress failed!\n");
-		ret = -1;
+		ret = -EIO;
 		goto out;
 	}
 
 	if (out_len < start_byte) {
-		ret = -1;
+		ret = -EIO;
 		goto out;
 	}
 
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 8e57191..4f19631 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -98,7 +98,7 @@ static int zlib_compress_pages(struct list_head *ws,
 
 	if (Z_OK != zlib_deflateInit(&workspace->def_strm, 3)) {
 		printk(KERN_WARNING "BTRFS: deflateInit failed\n");
-		ret = -1;
+		ret = -EIO;
 		goto out;
 	}
 
@@ -110,7 +110,7 @@ static int zlib_compress_pages(struct list_head *ws,
 
 	out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
 	if (out_page == NULL) {
-		ret = -1;
+		ret = -ENOMEM;
 		goto out;
 	}
 	cpage_out = kmap(out_page);
@@ -128,7 +128,7 @@ static int zlib_compress_pages(struct list_head *ws,
 			printk(KERN_DEBUG "BTRFS: deflate in loop returned %d\n",
 			       ret);
 			zlib_deflateEnd(&workspace->def_strm);
-			ret = -1;
+			ret = -EIO;
 			goto out;
 		}
 
@@ -136,7 +136,7 @@ static int zlib_compress_pages(struct list_head *ws,
 		if (workspace->def_strm.total_in > 8192 &&
 		    workspace->def_strm.total_in <
 		    workspace->def_strm.total_out) {
-			ret = -1;
+			ret = -EIO;
 			goto out;
 		}
 		/* we need another page for writing out.  Test this
@@ -147,12 +147,12 @@ static int zlib_compress_pages(struct list_head *ws,
 			kunmap(out_page);
 			if (nr_pages == nr_dest_pages) {
 				out_page = NULL;
-				ret = -1;
+				ret = -E2BIG;
 				goto out;
 			}
 			out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
 			if (out_page == NULL) {
-				ret = -1;
+				ret = -ENOMEM;
 				goto out;
 			}
 			cpage_out = kmap(out_page);
@@ -188,12 +188,12 @@ static int zlib_compress_pages(struct list_head *ws,
 	zlib_deflateEnd(&workspace->def_strm);
 
 	if (ret != Z_STREAM_END) {
-		ret = -1;
+		ret = -EIO;
 		goto out;
 	}
 
 	if (workspace->def_strm.total_out >= workspace->def_strm.total_in) {
-		ret = -1;
+		ret = -E2BIG;
 		goto out;
 	}
 
@@ -253,7 +253,7 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 
 	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
 		printk(KERN_WARNING "BTRFS: inflateInit failed\n");
-		return -1;
+		return -EIO;
 	}
 	while (workspace->inf_strm.total_in < srclen) {
 		ret = zlib_inflate(&workspace->inf_strm, Z_NO_FLUSH);
@@ -295,7 +295,7 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 		}
 	}
 	if (ret != Z_STREAM_END)
-		ret = -1;
+		ret = -EIO;
 	else
 		ret = 0;
 done:
@@ -337,7 +337,7 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 
 	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
 		printk(KERN_WARNING "BTRFS: inflateInit failed\n");
-		return -1;
+		return -EIO;
 	}
 
 	while (bytes_left > 0) {
@@ -354,7 +354,7 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 		total_out = workspace->inf_strm.total_out;
 
 		if (total_out == buf_start) {
-			ret = -1;
+			ret = -EIO;
 			break;
 		}
 
@@ -382,7 +382,7 @@ next:
 	}
 
 	if (ret != Z_STREAM_END && bytes_left != 0)
-		ret = -1;
+		ret = -EIO;
 	else
 		ret = 0;
 
-- 
1.8.1.4

