From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 07/18] Btrfs: reduce memory use in compress/decompress
 workspace.
Date: Sun, 21 Mar 2010 23:24:50 -0400
Message-ID: <4BA6E302.4020601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Compression and decompression can use a single z_stream and
z_stream.workspace memory as the operations always begin from
scratch and do not overlap in one thread's execution.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/zlib.c |  146 ++++++++++++++++++++++++++-----------------------------
 1 files changed, 69 insertions(+), 77 deletions(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 3e2b90e..d7bdce5 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -42,8 +42,7 @@
 #define STREAM_END_SPACE 12
 
 struct workspace {
-	z_stream inf_strm;
-	z_stream def_strm;
+	z_stream z_strm;
 	char *buf;
 	struct list_head list;
 };
@@ -91,16 +90,13 @@ again:
 		goto fail;
 	}
 
-	workspace->def_strm.workspace = vmalloc(zlib_deflate_workspacesize());
-	if (!workspace->def_strm.workspace) {
+	workspace->z_strm.workspace = vmalloc(max(zlib_deflate_workspacesize(),
+						zlib_inflate_workspacesize()));
+	if (!workspace->z_strm.workspace) {
 		ret = -ENOMEM;
 		goto fail;
 	}
-	workspace->inf_strm.workspace = vmalloc(zlib_inflate_workspacesize());
-	if (!workspace->inf_strm.workspace) {
-		ret = -ENOMEM;
-		goto fail_inflate;
-	}
+
 	workspace->buf = kmalloc(PAGE_CACHE_SIZE, GFP_NOFS);
 	if (!workspace->buf) {
 		ret = -ENOMEM;
@@ -109,9 +105,7 @@ again:
 	return workspace;
 
 fail_kmalloc:
-	vfree(workspace->inf_strm.workspace);
-fail_inflate:
-	vfree(workspace->def_strm.workspace);
+	vfree(workspace->z_strm.workspace);
 fail:
 	kfree(workspace);
 	atomic_dec(&alloc_workspace);
@@ -135,8 +129,7 @@ static int free_workspace(struct workspace *workspace)
 		return 0;
 	}
 	spin_unlock(&workspace_lock);
-	vfree(workspace->def_strm.workspace);
-	vfree(workspace->inf_strm.workspace);
+	vfree(workspace->z_strm.workspace);
 	kfree(workspace->buf);
 	kfree(workspace);
 
@@ -156,8 +149,7 @@ static void free_workspaces(void)
 		workspace = list_entry(idle_workspace.next, struct workspace,
 				       list);
 		list_del(&workspace->list);
-		vfree(workspace->def_strm.workspace);
-		vfree(workspace->inf_strm.workspace);
+		vfree(workspace->z_strm.workspace);
 		kfree(workspace->buf);
 		kfree(workspace);
 		atomic_dec(&alloc_workspace);
@@ -211,14 +203,14 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 	if (IS_ERR(workspace))
 		return -1;
 
-	if (Z_OK != zlib_deflateInit(&workspace->def_strm, 3)) {
+	if (Z_OK != zlib_deflateInit(&workspace->z_strm, 3)) {
 		printk(KERN_WARNING "deflateInit failed\n");
 		ret = -1;
 		goto out;
 	}
 
-	workspace->def_strm.total_in = 0;
-	workspace->def_strm.total_out = 0;
+	workspace->z_strm.total_in = 0;
+	workspace->z_strm.total_out = 0;
 
 	in_page = find_get_page(mapping, start >> PAGE_CACHE_SHIFT);
 	data_in = kmap(in_page);
@@ -228,28 +220,28 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 	pages[0] = out_page;
 	nr_pages = 1;
 
-	workspace->def_strm.next_in = data_in;
-	workspace->def_strm.next_out = cpage_out;
-	workspace->def_strm.avail_out = PAGE_CACHE_SIZE;
-	workspace->def_strm.avail_in = min(len, PAGE_CACHE_SIZE);
+	workspace->z_strm.next_in = data_in;
+	workspace->z_strm.next_out = cpage_out;
+	workspace->z_strm.avail_out = PAGE_CACHE_SIZE;
+	workspace->z_strm.avail_in = min(len, PAGE_CACHE_SIZE);
 
 	out_written = 0;
 	in_read = 0;
 
-	while (workspace->def_strm.total_in < len) {
-		ret = zlib_deflate(&workspace->def_strm, Z_SYNC_FLUSH);
+	while (workspace->z_strm.total_in < len) {
+		ret = zlib_deflate(&workspace->z_strm, Z_SYNC_FLUSH);
 		if (ret != Z_OK) {
 			printk(KERN_DEBUG "btrfs deflate in loop returned %d\n",
 			       ret);
-			zlib_deflateEnd(&workspace->def_strm);
+			zlib_deflateEnd(&workspace->z_strm);
 			ret = -1;
 			goto out;
 		}
 
 		/* we're making it bigger, give up */
-		if (workspace->def_strm.total_in > 8192 &&
-		    workspace->def_strm.total_in <
-		    workspace->def_strm.total_out) {
+		if (workspace->z_strm.total_in > 8192 &&
+		    workspace->z_strm.total_in <
+		    workspace->z_strm.total_out) {
 			ret = -1;
 			goto out;
 		}
@@ -257,7 +249,7 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 		 * before the total_in so we will pull in a new page for
 		 * the stream end if required
 		 */
-		if (workspace->def_strm.avail_out == 0) {
+		if (workspace->z_strm.avail_out == 0) {
 			kunmap(out_page);
 			if (nr_pages == nr_dest_pages) {
 				out_page = NULL;
@@ -268,19 +260,19 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 			cpage_out = kmap(out_page);
 			pages[nr_pages] = out_page;
 			nr_pages++;
-			workspace->def_strm.avail_out = PAGE_CACHE_SIZE;
-			workspace->def_strm.next_out = cpage_out;
+			workspace->z_strm.avail_out = PAGE_CACHE_SIZE;
+			workspace->z_strm.next_out = cpage_out;
 		}
 		/* we're all done */
-		if (workspace->def_strm.total_in >= len)
+		if (workspace->z_strm.total_in >= len)
 			break;
 
 		/* we've read in a full page, get a new one */
-		if (workspace->def_strm.avail_in == 0) {
-			if (workspace->def_strm.total_out > max_out)
+		if (workspace->z_strm.avail_in == 0) {
+			if (workspace->z_strm.total_out > max_out)
 				break;
 
-			bytes_left = len - workspace->def_strm.total_in;
+			bytes_left = len - workspace->z_strm.total_in;
 			kunmap(in_page);
 			page_cache_release(in_page);
 
@@ -288,28 +280,28 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 			in_page = find_get_page(mapping,
 						start >> PAGE_CACHE_SHIFT);
 			data_in = kmap(in_page);
-			workspace->def_strm.avail_in = min(bytes_left,
+			workspace->z_strm.avail_in = min(bytes_left,
 							   PAGE_CACHE_SIZE);
-			workspace->def_strm.next_in = data_in;
+			workspace->z_strm.next_in = data_in;
 		}
 	}
-	workspace->def_strm.avail_in = 0;
-	ret = zlib_deflate(&workspace->def_strm, Z_FINISH);
-	zlib_deflateEnd(&workspace->def_strm);
+	workspace->z_strm.avail_in = 0;
+	ret = zlib_deflate(&workspace->z_strm, Z_FINISH);
+	zlib_deflateEnd(&workspace->z_strm);
 
 	if (ret != Z_STREAM_END) {
 		ret = -1;
 		goto out;
 	}
 
-	if (workspace->def_strm.total_out >= workspace->def_strm.total_in) {
+	if (workspace->z_strm.total_out >= workspace->z_strm.total_in) {
 		ret = -1;
 		goto out;
 	}
 
 	ret = 0;
-	*total_out = workspace->def_strm.total_out;
-	*total_in = workspace->def_strm.total_in;
+	*total_out = workspace->z_strm.total_out;
+	*total_in = workspace->z_strm.total_in;
 out:
 	*out_pages = nr_pages;
 	if (out_page)
@@ -370,13 +362,13 @@ int btrfs_zlib_decompress_biovec(struct page **pages_in,
 		return -ENOMEM;
 
 	data_in = kmap(pages_in[page_in_index]);
-	workspace->inf_strm.next_in = data_in;
-	workspace->inf_strm.avail_in = min_t(size_t, srclen, PAGE_CACHE_SIZE);
-	workspace->inf_strm.total_in = 0;
+	workspace->z_strm.next_in = data_in;
+	workspace->z_strm.avail_in = min_t(size_t, srclen, PAGE_CACHE_SIZE);
+	workspace->z_strm.total_in = 0;
 
-	workspace->inf_strm.total_out = 0;
-	workspace->inf_strm.next_out = workspace->buf;
-	workspace->inf_strm.avail_out = PAGE_CACHE_SIZE;
+	workspace->z_strm.total_out = 0;
+	workspace->z_strm.next_out = workspace->buf;
+	workspace->z_strm.avail_out = PAGE_CACHE_SIZE;
 	page_out = bvec[page_out_index].bv_page;
 	page_bytes_left = PAGE_CACHE_SIZE;
 	pg_offset = 0;
@@ -388,17 +380,17 @@ int btrfs_zlib_decompress_biovec(struct page **pages_in,
 	    !(((data_in[0]<<8) + data_in[1]) % 31)) {
 
 		wbits = -((data_in[0] >> 4) + 8);
-		workspace->inf_strm.next_in += 2;
-		workspace->inf_strm.avail_in -= 2;
+		workspace->z_strm.next_in += 2;
+		workspace->z_strm.avail_in -= 2;
 	}
 
-	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
+	if (Z_OK != zlib_inflateInit2(&workspace->z_strm, wbits)) {
 		printk(KERN_WARNING "inflateInit failed\n");
 		ret = -1;
 		goto out;
 	}
-	while (workspace->inf_strm.total_in < srclen) {
-		ret = zlib_inflate(&workspace->inf_strm, Z_NO_FLUSH);
+	while (workspace->z_strm.total_in < srclen) {
+		ret = zlib_inflate(&workspace->z_strm, Z_NO_FLUSH);
 		if (ret != Z_OK && ret != Z_STREAM_END)
 			break;
 		/*
@@ -408,7 +400,7 @@ int btrfs_zlib_decompress_biovec(struct page **pages_in,
 		buf_start = total_out;
 
 		/* total_out is the last byte of the workspace buffer */
-		total_out = workspace->inf_strm.total_out;
+		total_out = workspace->z_strm.total_out;
 
 		working_bytes = total_out - buf_start;
 
@@ -495,10 +487,10 @@ int btrfs_zlib_decompress_biovec(struct page **pages_in,
 			}
 		}
 next:
-		workspace->inf_strm.next_out = workspace->buf;
-		workspace->inf_strm.avail_out = PAGE_CACHE_SIZE;
+		workspace->z_strm.next_out = workspace->buf;
+		workspace->z_strm.avail_out = PAGE_CACHE_SIZE;
 
-		if (workspace->inf_strm.avail_in == 0) {
+		if (workspace->z_strm.avail_in == 0) {
 			unsigned long tmp;
 			kunmap(pages_in[page_in_index]);
 			page_in_index++;
@@ -507,9 +499,9 @@ next:
 				break;
 			}
 			data_in = kmap(pages_in[page_in_index]);
-			workspace->inf_strm.next_in = data_in;
-			tmp = srclen - workspace->inf_strm.total_in;
-			workspace->inf_strm.avail_in = min(tmp,
+			workspace->z_strm.next_in = data_in;
+			tmp = srclen - workspace->z_strm.total_in;
+			workspace->z_strm.avail_in = min(tmp,
 							   PAGE_CACHE_SIZE);
 		}
 	}
@@ -518,7 +510,7 @@ next:
 	else
 		ret = 0;
 done:
-	zlib_inflateEnd(&workspace->inf_strm);
+	zlib_inflateEnd(&workspace->z_strm);
 	if (data_in)
 		kunmap(pages_in[page_in_index]);
 out:
@@ -550,13 +542,13 @@ int btrfs_zlib_decompress(unsigned char *data_in,
 	if (IS_ERR(workspace))
 		return -ENOMEM;
 
-	workspace->inf_strm.next_in = data_in;
-	workspace->inf_strm.avail_in = srclen;
-	workspace->inf_strm.total_in = 0;
+	workspace->z_strm.next_in = data_in;
+	workspace->z_strm.avail_in = srclen;
+	workspace->z_strm.total_in = 0;
 
-	workspace->inf_strm.next_out = workspace->buf;
-	workspace->inf_strm.avail_out = PAGE_CACHE_SIZE;
-	workspace->inf_strm.total_out = 0;
+	workspace->z_strm.next_out = workspace->buf;
+	workspace->z_strm.avail_out = PAGE_CACHE_SIZE;
+	workspace->z_strm.total_out = 0;
 	/* If it's deflate, and it's got no preset dictionary, then
 	   we can tell zlib to skip the adler32 check. */
 	if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
@@ -564,11 +556,11 @@ int btrfs_zlib_decompress(unsigned char *data_in,
 	    !(((data_in[0]<<8) + data_in[1]) % 31)) {
 
 		wbits = -((data_in[0] >> 4) + 8);
-		workspace->inf_strm.next_in += 2;
-		workspace->inf_strm.avail_in -= 2;
+		workspace->z_strm.next_in += 2;
+		workspace->z_strm.avail_in -= 2;
 	}
 
-	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
+	if (Z_OK != zlib_inflateInit2(&workspace->z_strm, wbits)) {
 		printk(KERN_WARNING "inflateInit failed\n");
 		ret = -1;
 		goto out;
@@ -580,12 +572,12 @@ int btrfs_zlib_decompress(unsigned char *data_in,
 		unsigned long bytes;
 		unsigned long pg_offset = 0;
 
-		ret = zlib_inflate(&workspace->inf_strm, Z_NO_FLUSH);
+		ret = zlib_inflate(&workspace->z_strm, Z_NO_FLUSH);
 		if (ret != Z_OK && ret != Z_STREAM_END)
 			break;
 
 		buf_start = total_out;
-		total_out = workspace->inf_strm.total_out;
+		total_out = workspace->z_strm.total_out;
 
 		if (total_out == buf_start) {
 			ret = -1;
@@ -611,8 +603,8 @@ int btrfs_zlib_decompress(unsigned char *data_in,
 		pg_offset += bytes;
 		bytes_left -= bytes;
 next:
-		workspace->inf_strm.next_out = workspace->buf;
-		workspace->inf_strm.avail_out = PAGE_CACHE_SIZE;
+		workspace->z_strm.next_out = workspace->buf;
+		workspace->z_strm.avail_out = PAGE_CACHE_SIZE;
 	}
 
 	if (ret != Z_STREAM_END && bytes_left != 0)
@@ -620,7 +612,7 @@ next:
 	else
 		ret = 0;
 
-	zlib_inflateEnd(&workspace->inf_strm);
+	zlib_inflateEnd(&workspace->z_strm);
 out:
 	free_workspace(workspace);
 	return ret;
-- 
1.6.3.3
