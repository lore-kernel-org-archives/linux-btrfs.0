Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m50-134.163.com ([123.125.50.134]:38160 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbcAMOBv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 09:01:51 -0500
From: Geliang Tang <geliangtang@163.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add lz4 compression support
Date: Wed, 13 Jan 2016 22:01:01 +0800
Message-Id: <b966f4dc11df3ae96e90d8836d2f54b33ca41f2c.1452693396.git.geliangtang@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Like lzo in btrfs, this patch added lz4 compression support so that
users can have a third option.

Usage:

 mount -t btrfs -o compress=lz4 dev /mnt

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 fs/btrfs/Kconfig       |   2 +
 fs/btrfs/Makefile      |   2 +-
 fs/btrfs/compression.c |   1 +
 fs/btrfs/compression.h |   1 +
 fs/btrfs/ctree.h       |   7 +-
 fs/btrfs/disk-io.c     |   2 +
 fs/btrfs/ioctl.c       |   4 +
 fs/btrfs/lz4.c         | 445 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/props.c       |   4 +
 fs/btrfs/super.c       |   9 +
 fs/btrfs/sysfs.c       |   2 +
 11 files changed, 476 insertions(+), 3 deletions(-)
 create mode 100644 fs/btrfs/lz4.c

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 80e9c18..e68cdb3 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -6,6 +6,8 @@ config BTRFS_FS
 	select ZLIB_DEFLATE
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select SRCU
diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 128ce17..b2f8491 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -6,7 +6,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   transaction.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
-	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
+	   export.o tree-log.o free-space-cache.o zlib.o lzo.o lz4.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
 	   uuid-tree.o props.o hash.o free-space-tree.o
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c473c42..b30b205 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -755,6 +755,7 @@ static struct {
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
+	&btrfs_lz4_compress,
 };
 
 void __init btrfs_init_compress(void)
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 13a4dc0..2fa3fb1 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -79,5 +79,6 @@ struct btrfs_compress_op {
 
 extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;
+extern const struct btrfs_compress_op btrfs_lz4_compress;
 
 #endif
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 97ad9bb..732ed43 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -528,6 +528,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZ4	(1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
@@ -545,6 +546,7 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_BIG_METADATA |		\
 	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZ4 |		\
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
@@ -719,8 +721,9 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
-	BTRFS_COMPRESS_LAST  = 3,
+	BTRFS_COMPRESS_LZ4   = 3,
+	BTRFS_COMPRESS_TYPES = 3,
+	BTRFS_COMPRESS_LAST  = 4,
 };
 
 struct btrfs_inode_item {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e99ccd6..68555f9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2766,6 +2766,8 @@ int open_ctree(struct super_block *sb,
 	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
 	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
+	else if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZ4)
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZ4;
 
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 		printk(KERN_INFO "BTRFS: has skinny extents\n");
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2a47a31..7fa2c89 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -325,6 +325,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 		if (root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
 			comp = "lzo";
+		else if (root->fs_info->compress_type == BTRFS_COMPRESS_LZ4)
+			comp = "lz4";
 		else
 			comp = "zlib";
 		ret = btrfs_set_prop(inode, "btrfs.compression",
@@ -1455,6 +1457,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 	if (range->compress_type == BTRFS_COMPRESS_LZO) {
 		btrfs_set_fs_incompat(root->fs_info, COMPRESS_LZO);
+	} else if (range->compress_type == BTRFS_COMPRESS_LZ4) {
+		btrfs_set_fs_incompat(root->fs_info, COMPRESS_LZ4);
 	}
 
 	ret = defrag_count;
diff --git a/fs/btrfs/lz4.c b/fs/btrfs/lz4.c
new file mode 100644
index 0000000..fb90d63
--- /dev/null
+++ b/fs/btrfs/lz4.c
@@ -0,0 +1,445 @@
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
+#include <linux/lz4.h>
+#include "compression.h"
+
+#define LZ4_LEN	4
+
+struct workspace {
+	void *mem;
+	void *buf;	/* where decompressed data goes */
+	void *cbuf;	/* where compressed data goes */
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
+	workspace->mem = vmalloc(LZ4_MEM_COMPRESS);
+	workspace->buf = vmalloc(lz4_compressbound(PAGE_CACHE_SIZE));
+	workspace->cbuf = vmalloc(lz4_compressbound(PAGE_CACHE_SIZE));
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
+	if (!out_page) {
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
+		ret = lz4_compress(data_in, in_len, workspace->cbuf,
+				   &out_len, workspace->mem);
+		if (ret) {
+			pr_debug("BTRFS: deflate in loop returned %d\n",
+			       ret);
+			ret = -EIO;
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
+					ret = -E2BIG;
+					goto out;
+				}
+
+				out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+				if (!out_page) {
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
+		if (tot_in > 8192 && tot_in < tot_out) {
+			ret = -E2BIG;
+			goto out;
+		}
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
+	unsigned long total_pages_in = DIV_ROUND_UP(srclen, PAGE_CACHE_SIZE);
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
+					ret = -EIO;
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
+		out_len = lz4_compressbound(PAGE_CACHE_SIZE);
+		ret = lz4_decompress_unknownoutputsize(buf, in_len,
+						       workspace->buf,
+						       &out_len);
+		if (need_unmap)
+			kunmap(pages_in[page_in_index - 1]);
+		if (ret) {
+			pr_warn("BTRFS: decompress failed\n");
+			ret = -EIO;
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
+	if (!ret)
+		btrfs_clear_biovec_end(bvec, vcnt, page_out_index, pg_offset);
+	return ret;
+}
+
+static int lz4_decompress_btrfs(struct list_head *ws, unsigned char *data_in,
+				struct page *dest_page,
+				unsigned long start_byte,
+				size_t srclen, size_t destlen)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	size_t in_len;
+	size_t out_len;
+	size_t tot_len;
+	int ret = 0;
+	char *kaddr;
+	unsigned long bytes;
+
+	WARN_ON(srclen < LZ4_LEN);
+
+	tot_len = read_compress_length(data_in);
+	data_in += LZ4_LEN;
+
+	in_len = read_compress_length(data_in);
+	data_in += LZ4_LEN;
+
+	out_len = PAGE_CACHE_SIZE;
+	ret = lz4_decompress_unknownoutputsize(data_in, in_len,
+					       workspace->buf, &out_len);
+	if (ret) {
+		pr_warn("BTRFS: decompress failed!\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	if (out_len < start_byte) {
+		ret = -EIO;
+		goto out;
+	}
+
+	/*
+	 * the caller is already checking against PAGE_SIZE, but lets
+	 * move this check closer to the memcpy/memset
+	 */
+	destlen = min_t(unsigned long, destlen, PAGE_SIZE);
+	bytes = min_t(unsigned long, destlen, out_len - start_byte);
+
+	kaddr = kmap_atomic(dest_page);
+	memcpy(kaddr, workspace->buf + start_byte, bytes);
+
+	/*
+	 * btrfs_getblock is doing a zero on the tail of the page too,
+	 * but this will cover anything missing from the decompressed
+	 * data.
+	 */
+	if (bytes < destlen)
+		memset(kaddr + bytes, 0, destlen - bytes);
+	kunmap_atomic(kaddr);
+out:
+	return ret;
+}
+
+const struct btrfs_compress_op btrfs_lz4_compress = {
+	.alloc_workspace	= lz4_alloc_workspace,
+	.free_workspace		= lz4_free_workspace,
+	.compress_pages		= lz4_compress_pages,
+	.decompress_biovec	= lz4_decompress_biovec,
+	.decompress		= lz4_decompress_btrfs,
+};
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index f9e6023..07735d7 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -401,6 +401,8 @@ static int prop_compression_apply(struct inode *inode,
 
 	if (!strncmp("lzo", value, len))
 		type = BTRFS_COMPRESS_LZO;
+	else if (!strncmp("lz4", value, len))
+		type = BTRFS_COMPRESS_LZ4;
 	else if (!strncmp("zlib", value, len))
 		type = BTRFS_COMPRESS_ZLIB;
 	else
@@ -420,6 +422,8 @@ static const char *prop_compression_extract(struct inode *inode)
 		return "zlib";
 	case BTRFS_COMPRESS_LZO:
 		return "lzo";
+	case BTRFS_COMPRESS_LZ4:
+		return "lz4";
 	}
 
 	return NULL;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9b9eab6..ca68243 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -477,6 +477,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
+			} else if (strcmp(args[0].from, "lz4") == 0) {
+				compress_type = "lz4";
+				info->compress_type = BTRFS_COMPRESS_LZ4;
+				btrfs_set_opt(info->mount_opt, COMPRESS);
+				btrfs_clear_opt(info->mount_opt, NODATACOW);
+				btrfs_clear_opt(info->mount_opt, NODATASUM);
+				btrfs_set_fs_incompat(info, COMPRESS_LZ4);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
 				btrfs_clear_opt(info->mount_opt, COMPRESS);
@@ -1172,6 +1179,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (btrfs_test_opt(root, COMPRESS)) {
 		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
 			compress_type = "zlib";
+		else if (info->compress_type == BTRFS_COMPRESS_LZ4)
+			compress_type = "lz4";
 		else
 			compress_type = "lzo";
 		if (btrfs_test_opt(root, FORCE_COMPRESS))
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index e0ac859..f98a0fb 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -197,6 +197,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(mixed_backref, MIXED_BACKREF);
 BTRFS_FEAT_ATTR_INCOMPAT(default_subvol, DEFAULT_SUBVOL);
 BTRFS_FEAT_ATTR_INCOMPAT(mixed_groups, MIXED_GROUPS);
 BTRFS_FEAT_ATTR_INCOMPAT(compress_lzo, COMPRESS_LZO);
+BTRFS_FEAT_ATTR_INCOMPAT(compress_lz4, COMPRESS_LZ4);
 BTRFS_FEAT_ATTR_INCOMPAT(big_metadata, BIG_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(extended_iref, EXTENDED_IREF);
 BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
@@ -208,6 +209,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(default_subvol),
 	BTRFS_FEAT_ATTR_PTR(mixed_groups),
 	BTRFS_FEAT_ATTR_PTR(compress_lzo),
+	BTRFS_FEAT_ATTR_PTR(compress_lz4),
 	BTRFS_FEAT_ATTR_PTR(big_metadata),
 	BTRFS_FEAT_ATTR_PTR(extended_iref),
 	BTRFS_FEAT_ATTR_PTR(raid56),
-- 
2.5.0


