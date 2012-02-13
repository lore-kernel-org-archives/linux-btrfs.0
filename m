From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/4] btrfs: lz4: add wrapper functions and enable it
Date: Mon, 13 Feb 2012 20:05:37 +0100
Message-ID: <1329159937-23976-4-git-send-email-dsterba@suse.cz>
References: <20120213190325.GJ15350@twin.jikos.cz>
 <1329159937-23976-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1329159937-23976-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/Makefile      |    2 +-
 fs/btrfs/compression.c |    1 +
 fs/btrfs/compression.h |    1 +
 fs/btrfs/lz4_wrapper.c |  429 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/lzo.c         |    2 +
 fs/btrfs/super.c       |    3 -
 6 files changed, 434 insertions(+), 4 deletions(-)
 create mode 100644 fs/btrfs/lz4_wrapper.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 11f8c4e..7bb7497 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -8,7 +8,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
-	   reada.o backref.o ulist.o snappy.o lz4.o
+	   reada.o backref.o ulist.o snappy.o lz4.o lz4_wrapper.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index f85f7fd..93b481e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -731,6 +731,7 @@ struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
 	&btrfs_snappy_compress,
+	&btrfs_lz4_compress,
 };
 
 int __init btrfs_init_compress(void)
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 971a425..d8e8e73 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -80,5 +80,6 @@ struct btrfs_compress_op {
 extern struct btrfs_compress_op btrfs_zlib_compress;
 extern struct btrfs_compress_op btrfs_lzo_compress;
 extern struct btrfs_compress_op btrfs_snappy_compress;
+extern struct btrfs_compress_op btrfs_lz4_compress;
 
 #endif
diff --git a/fs/btrfs/lz4_wrapper.c b/fs/btrfs/lz4_wrapper.c
new file mode 100644
index 0000000..bff9b1b
--- /dev/null
+++ b/fs/btrfs/lz4_wrapper.c
@@ -0,0 +1,429 @@
+/*
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/pagemap.h>
+#include <linux/bio.h>
+#include "lz4.h"
+#include "compression.h"
+
+#define LZ4_LEN		4
+#define LZ4_CHUNK_SIZE	(4096)
+#define LZ4_MAX_WORKBUF	2*LZ4_CHUNK_SIZE
+
+struct workspace {
+	void *mem;	/* work memory for compression */
+	void *buf;	/* where compressed data goes */
+	void *cbuf;	/* where decompressed data goes */
+	struct list_head list;
+};
+
+static void lz4_free_workspace(struct list_head *ws)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+
+	vfree(workspace->buf);
+	vfree(workspace->cbuf);
+	vfree(workspace->mem);
+	kfree(workspace);
+}
+
+static struct list_head *lz4_alloc_workspace(void)
+{
+	struct workspace *workspace;
+
+	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
+	if (!workspace)
+		return ERR_PTR(-ENOMEM);
+
+	workspace->mem = vmalloc(LZ4_context64k_size());
+	workspace->buf = vmalloc(LZ4_MAX_WORKBUF);
+	workspace->cbuf = vmalloc(LZ4_MAX_WORKBUF);
+	if (!workspace->mem || !workspace->buf || !workspace->cbuf)
+		goto fail;
+
+	INIT_LIST_HEAD(&workspace->list);
+
+	return &workspace->list;
+fail:
+	lz4_free_workspace(&workspace->list);
+	return ERR_PTR(-ENOMEM);
+}
+
+static inline void write_compress_length(char *buf, size_t len)
+{
+	__le32 dlen;
+
+	dlen = cpu_to_le32(len);
+	memcpy(buf, &dlen, LZ4_LEN);
+}
+
+static inline size_t read_compress_length(char *buf)
+{
+	__le32 dlen;
+
+	memcpy(&dlen, buf, LZ4_LEN);
+	return le32_to_cpu(dlen);
+}
+
+static int lz4_compress_pages(struct list_head *ws,
+			      struct address_space *mapping,
+			      u64 start, unsigned long len,
+			      struct page **pages,
+			      unsigned long nr_dest_pages,
+			      unsigned long *out_pages,
+			      unsigned long *total_in,
+			      unsigned long *total_out,
+			      unsigned long max_out)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	int ret = 0;
+	char *data_in;
+	char *cpage_out;
+	int nr_pages = 0;
+	struct page *in_page = NULL;
+	struct page *out_page = NULL;
+	unsigned long bytes_left;
+
+	size_t in_len;
+	size_t out_len;
+	char *buf;
+	unsigned long tot_in = 0;
+	unsigned long tot_out = 0;
+	unsigned long pg_bytes_left;
+	unsigned long out_offset;
+	unsigned long bytes;
+
+	*out_pages = 0;
+	*total_out = 0;
+	*total_in = 0;
+
+	in_page = find_get_page(mapping, start >> PAGE_CACHE_SHIFT);
+	data_in = kmap(in_page);
+
+	/*
+	 * store the size of all chunks of compressed data in
+	 * the first 4 bytes
+	 */
+	out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+	if (out_page == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	cpage_out = kmap(out_page);
+	out_offset = LZ4_LEN;
+	tot_out = LZ4_LEN;
+	pages[0] = out_page;
+	nr_pages = 1;
+	pg_bytes_left = PAGE_CACHE_SIZE - LZ4_LEN;
+
+	/* compress at most one page of data each time */
+	in_len = min(len, PAGE_CACHE_SIZE);
+	while (tot_in < len) {
+		out_len = LZ4_compress64kCtx(&workspace->mem, data_in,
+				workspace->cbuf, in_len);
+		if (out_len <= 0) {
+			printk(KERN_DEBUG
+				"btrfs: lz4 compress in loop returned %d\n",
+			       ret);
+			ret = -1;
+			goto out;
+		}
+
+		/* store the size of this chunk of compressed data */
+		write_compress_length(cpage_out + out_offset, out_len);
+		tot_out += LZ4_LEN;
+		out_offset += LZ4_LEN;
+		pg_bytes_left -= LZ4_LEN;
+
+		tot_in += in_len;
+		tot_out += out_len;
+
+		/* copy bytes from the working buffer into the pages */
+		buf = workspace->cbuf;
+		while (out_len) {
+			bytes = min_t(unsigned long, pg_bytes_left, out_len);
+
+			memcpy(cpage_out + out_offset, buf, bytes);
+
+			out_len -= bytes;
+			pg_bytes_left -= bytes;
+			buf += bytes;
+			out_offset += bytes;
+
+			/*
+			 * we need another page for writing out.
+			 *
+			 * Note if there's less than 4 bytes left, we just
+			 * skip to a new page.
+			 */
+			if ((out_len == 0 && pg_bytes_left < LZ4_LEN) ||
+			    pg_bytes_left == 0) {
+				if (pg_bytes_left) {
+					memset(cpage_out + out_offset, 0,
+					       pg_bytes_left);
+					tot_out += pg_bytes_left;
+				}
+
+				/* we're done, don't allocate new page */
+				if (out_len == 0 && tot_in >= len)
+					break;
+
+				kunmap(out_page);
+				if (nr_pages == nr_dest_pages) {
+					out_page = NULL;
+					ret = -1;
+					goto out;
+				}
+
+				out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+				if (out_page == NULL) {
+					ret = -ENOMEM;
+					goto out;
+				}
+				cpage_out = kmap(out_page);
+				pages[nr_pages++] = out_page;
+
+				pg_bytes_left = PAGE_CACHE_SIZE;
+				out_offset = 0;
+			}
+		}
+
+		/* we're making it bigger, give up */
+		if (tot_in > 8192 && tot_in < tot_out)
+			goto out;
+
+		/* we're all done */
+		if (tot_in >= len)
+			break;
+
+		if (tot_out > max_out)
+			break;
+
+		bytes_left = len - tot_in;
+		kunmap(in_page);
+		page_cache_release(in_page);
+
+		start += PAGE_CACHE_SIZE;
+		in_page = find_get_page(mapping, start >> PAGE_CACHE_SHIFT);
+		data_in = kmap(in_page);
+		in_len = min(bytes_left, PAGE_CACHE_SIZE);
+	}
+
+	if (tot_out > tot_in)
+		goto out;
+
+	/* store the size of all chunks of compressed data */
+	cpage_out = kmap(pages[0]);
+	write_compress_length(cpage_out, tot_out);
+
+	kunmap(pages[0]);
+
+	ret = 0;
+	*total_out = tot_out;
+	*total_in = tot_in;
+out:
+	*out_pages = nr_pages;
+	if (out_page)
+		kunmap(out_page);
+
+	if (in_page) {
+		kunmap(in_page);
+		page_cache_release(in_page);
+	}
+
+	return ret;
+}
+
+static int lz4_decompress_biovec(struct list_head *ws,
+				 struct page **pages_in,
+				 u64 disk_start,
+				 struct bio_vec *bvec,
+				 int vcnt,
+				 size_t srclen)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	int ret = 0, ret2;
+	char *data_in;
+	unsigned long page_in_index = 0;
+	unsigned long page_out_index = 0;
+	unsigned long total_pages_in = (srclen + PAGE_CACHE_SIZE - 1) /
+					PAGE_CACHE_SIZE;
+	unsigned long buf_start;
+	unsigned long buf_offset = 0;
+	unsigned long bytes;
+	unsigned long working_bytes;
+	unsigned long pg_offset;
+
+	size_t in_len;
+	size_t out_len;
+	unsigned long in_offset;
+	unsigned long in_page_bytes_left;
+	unsigned long tot_in;
+	unsigned long tot_out;
+	unsigned long tot_len;
+	char *buf;
+	bool may_late_unmap, need_unmap;
+
+	data_in = kmap(pages_in[0]);
+	tot_len = read_compress_length(data_in);
+
+	tot_in = LZ4_LEN;
+	in_offset = LZ4_LEN;
+	tot_len = min_t(size_t, srclen, tot_len);
+	in_page_bytes_left = PAGE_CACHE_SIZE - LZ4_LEN;
+
+	tot_out = 0;
+	pg_offset = 0;
+
+	while (tot_in < tot_len) {
+		in_len = read_compress_length(data_in + in_offset);
+		in_page_bytes_left -= LZ4_LEN;
+		in_offset += LZ4_LEN;
+		tot_in += LZ4_LEN;
+
+		tot_in += in_len;
+		working_bytes = in_len;
+		may_late_unmap = need_unmap = false;
+
+		/* fast path: avoid using the working buffer */
+		if (in_page_bytes_left >= in_len) {
+			buf = data_in + in_offset;
+			bytes = in_len;
+			may_late_unmap = true;
+			goto cont;
+		}
+
+		/* copy bytes from the pages into the working buffer */
+		buf = workspace->cbuf;
+		buf_offset = 0;
+		while (working_bytes) {
+			bytes = min(working_bytes, in_page_bytes_left);
+
+			memcpy(buf + buf_offset, data_in + in_offset, bytes);
+			buf_offset += bytes;
+cont:
+			working_bytes -= bytes;
+			in_page_bytes_left -= bytes;
+			in_offset += bytes;
+
+			/* check if we need to pick another page */
+			if ((working_bytes == 0 && in_page_bytes_left < LZ4_LEN)
+			    || in_page_bytes_left == 0) {
+				tot_in += in_page_bytes_left;
+
+				if (working_bytes == 0 && tot_in >= tot_len)
+					break;
+
+				if (page_in_index + 1 >= total_pages_in) {
+					ret = -1;
+					goto done;
+				}
+
+				if (may_late_unmap)
+					need_unmap = true;
+				else
+					kunmap(pages_in[page_in_index]);
+
+				data_in = kmap(pages_in[++page_in_index]);
+
+				in_page_bytes_left = PAGE_CACHE_SIZE;
+				in_offset = 0;
+			}
+		}
+
+		out_len = LZ4_uncompress_unknownOutputSize(buf, workspace->buf,
+				in_len, LZ4_CHUNK_SIZE);
+		if (need_unmap)
+			kunmap(pages_in[page_in_index - 1]);
+		if (out_len < 0) {
+			printk(KERN_WARNING "btrfs: lz4 decompress failed\n");
+			ret = -1;
+			break;
+		}
+
+		buf_start = tot_out;
+		tot_out += out_len;
+
+		ret2 = btrfs_decompress_buf2page(workspace->buf, buf_start,
+						 tot_out, disk_start,
+						 bvec, vcnt,
+						 &page_out_index, &pg_offset);
+		if (ret2 == 0)
+			break;
+	}
+done:
+	kunmap(pages_in[page_in_index]);
+	return ret;
+}
+
+static int lz4_decompress(struct list_head *ws, unsigned char *data_in,
+			  struct page *dest_page,
+			  unsigned long start_byte,
+			  size_t srclen, size_t destlen)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	size_t in_len;
+	size_t out_len;
+	size_t tot_len;
+	int ret = 0;
+	char *kaddr;
+	unsigned long bytes;
+
+	BUG_ON(srclen < LZ4_LEN);
+
+	tot_len = read_compress_length(data_in);
+	data_in += LZ4_LEN;
+
+	in_len = read_compress_length(data_in);
+	data_in += LZ4_LEN;
+
+	out_len = LZ4_uncompress_unknownOutputSize(data_in, workspace->buf,
+			in_len, LZ4_CHUNK_SIZE);
+	if (out_len < 0) {
+		printk(KERN_WARNING "btrfs: lz4 decompress failed\n");
+		ret = -1;
+		goto out;
+	}
+
+	if (out_len < start_byte) {
+		ret = -1;
+		goto out;
+	}
+
+	bytes = min_t(unsigned long, destlen, out_len - start_byte);
+
+	kaddr = kmap_atomic(dest_page, KM_USER0);
+	memcpy(kaddr, workspace->buf + start_byte, bytes);
+	kunmap_atomic(kaddr, KM_USER0);
+out:
+	return ret;
+}
+
+struct btrfs_compress_op btrfs_lz4_compress = {
+	.alloc_workspace	= lz4_alloc_workspace,
+	.free_workspace		= lz4_free_workspace,
+	.compress_pages		= lz4_compress_pages,
+	.decompress_biovec	= lz4_decompress_biovec,
+	.decompress		= lz4_decompress,
+};
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index a178f5e..3be72d3 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+/* Based on lzo.c wrapper */
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b65c94b..68c980e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -290,9 +290,6 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			} else if (strcmp(args[0].from, "lz4") == 0) {
 				compress_type = "lz4";
 				info->compress_type = BTRFS_COMPRESS_LZ4;
-				/* remove when implemented */
-				ret = -EINVAL;
-				goto out;
 			} else {
 				ret = -EINVAL;
 				goto out;
-- 
1.7.8

