Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52728 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2FWIHz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jun 2012 04:07:55 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3165053obb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jun 2012 01:07:55 -0700 (PDT)
From: Andrew Mahone <andrew.mahone@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andrew Mahone <andrew.mahone@gmail.com>
Subject: [PATCH 3/5] btrfs: lz4: add lz4_wrapper implementing btrfs compression interface
Date: Sat, 23 Jun 2012 04:05:46 -0400
Message-Id: <1340438748-348-4-git-send-email-andrew.mahone@gmail.com>
In-Reply-To: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
References: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Andrew Mahone <andrew.mahone@gmail.com>
---
 fs/btrfs/lz4_wrapper.c | 419 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 419 insertions(+)
 create mode 100644 fs/btrfs/lz4_wrapper.c

diff --git a/fs/btrfs/lz4_wrapper.c b/fs/btrfs/lz4_wrapper.c
new file mode 100644
index 0000000..60854de
--- /dev/null
+++ b/fs/btrfs/lz4_wrapper.c
@@ -0,0 +1,419 @@
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
+#include <linux/highmem.h>
+#include <asm/unaligned.h>
+#include "lz4.h"
+#include "lz4hc.h"
+#include "compression.h"
+
+#define LZ4_HDR_VER     0
+#define LZ4_HDR_LEN	(sizeof(__le32))
+
+struct workspace {
+	void *mem;	/* work memory for compression */
+	void *buf;	/* general-purpose memory for compression */
+	struct list_head list;
+};
+
+static void lz4_free_workspace(struct list_head *ws)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+
+	vfree(workspace->buf);
+	vfree(workspace->mem);
+	kfree(workspace);
+}
+
+static struct list_head *lz4_alloc_workspace_generic(int hi)
+{
+	struct workspace *workspace;
+
+	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
+	if (!workspace)
+		return ERR_PTR(-ENOMEM);
+
+	if (hi)
+		workspace->mem = vmalloc(LZ4_contextHC_size());
+	else
+		workspace->mem = vmalloc(LZ4_context64k_size());
+	workspace->buf = vmalloc(PAGE_CACHE_SIZE);
+	if (!workspace->mem || !workspace->buf)
+		goto fail;
+
+	INIT_LIST_HEAD(&workspace->list);
+
+	return &workspace->list;
+fail:
+	printk(KERN_WARNING "lz4 workspace alloc failed\n");
+	lz4_free_workspace(&workspace->list);
+	return ERR_PTR(-ENOMEM);
+}
+
+static struct list_head *lz4_alloc_workspace(void)
+{
+	return lz4_alloc_workspace_generic(0);
+}
+
+static struct list_head *lz4hc_alloc_workspace(void)
+{
+	return lz4_alloc_workspace_generic(1);
+}
+
+static inline void write_header(char *buf, size_t len, unsigned char ver)
+{
+	__le32 dlen;
+
+	len &= (1<<24) - 1;
+	len |= ver << 24;
+	dlen = cpu_to_le32(len);
+	memcpy(buf, &dlen, LZ4_HDR_LEN);
+}
+
+static inline void read_header(char *buf, size_t *len, unsigned char *ver)
+{
+	__le32 dlen;
+	u32 val;
+
+	memcpy(&dlen, buf, LZ4_HDR_LEN);
+	val = le32_to_cpu(dlen);
+	*len = val & ((1 << 24) -1);
+	*ver = val >> 24;
+}
+
+#define COUNT_PAGES(length)	(PAGE_CACHE_ALIGN((length)) >> PAGE_CACHE_SHIFT)
+
+static int lz4_compress_pages_generic(struct list_head *ws,
+			      struct address_space *mapping,
+			      u64 start, unsigned long len,
+			      struct page **pages,
+			      unsigned long nr_dest_pages,
+			      unsigned long *out_pages,
+			      unsigned long *total_in,
+			      unsigned long *total_out,
+			      unsigned long max_out, int hi)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	int nr_in_pages = PAGE_CACHE_ALIGN(len) >> PAGE_CACHE_SHIFT;
+	/* FIXME: wasteful by 1 page up to 512k */
+	unsigned long nr_out_pages = COUNT_PAGES(LZ4_compressBound(len + LZ4_HDR_LEN));
+	/* Maximum of 1M chunk: 4096 / 2 / 8 * 4096 */
+	struct page **in_vmap = (struct page**)workspace->buf;
+	struct page **out_vmap = (void*)in_vmap + PAGE_CACHE_SIZE / 2;
+	char *data_in;
+	char *data_out;
+	char *data_out_start;
+	int i;
+	int ret;
+	unsigned out_len;
+
+	{static int xxx=0;if(!xxx){xxx=1;printk(KERN_DEBUG "lz4: using vmap, max_out %ld\n", max_out);}}
+
+	ret = find_get_pages_contig(mapping, start >> PAGE_CACHE_SHIFT,
+			nr_in_pages, in_vmap);
+	if (ret != nr_in_pages) {
+		printk(KERN_WARNING "btrfs: failed to find all input pages for lz4 compression\n");
+		return -1;
+	}
+	data_in = vmap(in_vmap, nr_in_pages, VM_MAP, PAGE_KERNEL);
+	if (!data_in) {
+		printk(KERN_WARNING "btrfs: vmap for lz4 compression input buffer failed.\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nr_out_pages; i++) {
+		out_vmap[i] = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+		if (!out_vmap[i]) {
+			vunmap(data_in);
+			printk(KERN_WARNING "btrfs: alloc_page for lz4 compression output buffer failed\n");
+			ret = -ENOMEM;
+			goto free_out_pages;
+		}
+
+	}
+	data_out = vmap(out_vmap, nr_out_pages, VM_MAP, PAGE_KERNEL);
+	if (!data_out) {
+		vunmap(data_in);
+		printk(KERN_WARNING "btrfs: vmap for lz4 compression output buffer failed.\n");
+		ret = -ENOMEM;
+		goto free_out_pages;
+	}
+	data_out_start = data_out + LZ4_HDR_LEN;
+	invalidate_kernel_vmap_range(data_in, nr_in_pages << PAGE_CACHE_SHIFT);
+
+	if (hi) {
+		LZ4_contextHC_init(workspace->mem, data_in);
+		out_len = LZ4_compressHCCtx(workspace->mem, data_in,
+				data_out_start, len);
+		if (out_len < 0) {
+			printk(KERN_ERR "btrfs: lz4 compression HC error\n");
+			ret = -1;
+			flush_kernel_vmap_range(data_out, nr_out_pages << PAGE_CACHE_SHIFT);
+			vunmap(data_in);
+			vunmap(data_out);
+			goto free_out_pages;
+		}
+	} else if (len < 64 * 1024) {
+		out_len = LZ4_compress64kCtx(&workspace->mem, data_in,
+				data_out_start, len);
+		if (out_len < 0) {
+			printk(KERN_ERR "btrfs: lz4 compression 64k error\n");
+			ret = -1;
+			flush_kernel_vmap_range(data_out, nr_out_pages << PAGE_CACHE_SHIFT);
+			vunmap(data_in);
+			vunmap(data_out);
+			goto free_out_pages;
+		}
+	} else {
+		out_len = LZ4_compressCtx(&workspace->mem, data_in,
+				data_out_start, len);
+		if (out_len < 0) {
+			printk(KERN_ERR "btrfs: lz4 compression error\n");
+			ret = -1;
+			flush_kernel_vmap_range(data_out, nr_out_pages << PAGE_CACHE_SHIFT);
+			vunmap(data_in);
+			vunmap(data_out);
+			goto free_out_pages;
+		}
+	}
+
+	write_header(data_out, len, LZ4_HDR_VER);
+
+	*total_out = out_len + LZ4_HDR_LEN;
+	*total_in = len;
+	*out_pages = COUNT_PAGES(*total_out);
+
+	ret = 0;
+	if (*out_pages > nr_dest_pages) {
+		vunmap(data_in);
+		for (i = 0; i < nr_in_pages; i++)
+			page_cache_release(in_vmap[i]);
+		flush_kernel_vmap_range(data_out, nr_out_pages << PAGE_CACHE_SHIFT);
+		vunmap(data_out);
+		ret = -1;
+		goto free_out_pages;
+	}
+
+	vunmap(data_in);
+	for (i = 0; i < nr_in_pages; i++)
+		page_cache_release(in_vmap[i]);
+
+	flush_kernel_vmap_range(data_out, nr_out_pages << PAGE_CACHE_SHIFT);
+	vunmap(data_out);
+	for (i = 0; i < min(*out_pages, nr_dest_pages); i++)
+		pages[i] = out_vmap[i];
+	for (; i < nr_out_pages; i++)
+		__free_pages(out_vmap[i], 0);
+
+	return ret;
+
+free_out_pages:
+	for (i = 0; i < nr_out_pages; i++)
+		if(out_vmap[i])
+			page_cache_release(out_vmap[i]);
+		else
+			break;
+	*out_pages = 0;
+	return ret;
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
+	return lz4_compress_pages_generic(ws, mapping, start, len, pages,
+				nr_dest_pages, out_pages, total_in, total_out,
+				max_out, 0);
+}
+
+static int lz4hc_compress_pages(struct list_head *ws,
+			      struct address_space *mapping,
+			      u64 start, unsigned long len,
+			      struct page **pages,
+			      unsigned long nr_dest_pages,
+			      unsigned long *out_pages,
+			      unsigned long *total_in,
+			      unsigned long *total_out,
+			      unsigned long max_out)
+{
+	return lz4_compress_pages_generic(ws, mapping, start, len, pages,
+				nr_dest_pages, out_pages, total_in, total_out,
+				max_out, 1);
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
+	unsigned long total_pages_in = (srclen + PAGE_CACHE_SIZE - 1) /
+					PAGE_CACHE_SIZE;
+	int ret;
+	size_t orig_len;
+	unsigned char ver;
+
+	struct page **out_vmap = (struct page**)workspace->buf;
+	struct page **extra_pages = workspace->buf + PAGE_CACHE_SIZE / 2;
+	char *data_in_start;
+	char *data_in = NULL;
+	char *data_out = NULL;
+	int i, j, extra_pages_used = 0;
+
+	data_in = vmap(pages_in, total_pages_in, VM_MAP, PAGE_KERNEL);
+	if (!data_in) {
+		printk(KERN_WARNING "btrfs: vmap for lz4 decompression output buffer failed.\n");
+		return -ENOMEM;
+	}
+	invalidate_kernel_vmap_range(data_in, total_pages_in << PAGE_CACHE_SHIFT);
+	data_in_start = data_in + LZ4_HDR_LEN;
+	read_header(data_in, &orig_len, &ver);
+	if (ver != LZ4_HDR_VER) {
+		printk(KERN_ERR "btrfs: invalid lz4 header version %hhu\n", ver);
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	for (i = 0, j = 0; i < COUNT_PAGES(orig_len); i++) {
+		if (j < vcnt && page_offset(bvec[j].bv_page) - disk_start == i << PAGE_CACHE_SHIFT) {
+			out_vmap[i] = bvec[j].bv_page;
+			j++;
+		} else {
+			out_vmap[i] = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+			if (out_vmap[i] == NULL) {
+				printk(KERN_ERR "btrfs: extra page allocation for lz4 decompression "
+					"failed\n");
+				ret = -ENOMEM;
+				goto fail;
+			}
+			extra_pages[extra_pages_used++] = out_vmap[i];
+		}
+	}
+
+	data_out = vmap(out_vmap, COUNT_PAGES(orig_len),
+			VM_MAP, PAGE_KERNEL);
+	if (!data_out) {
+		printk(KERN_WARNING "btrfs: vmap for lz4 decompression output buffer failed.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	ret = LZ4_uncompress(data_in_start, data_out, orig_len);
+	if (ret < 0) {
+		printk(KERN_ERR "btrfs: lz4 decompress error\n");
+		ret = -EIO;
+		goto fail;
+	}
+
+	flush_kernel_vmap_range(data_out, orig_len);
+	vunmap(data_in);
+	vunmap(data_out);
+	for (i = 0; i < extra_pages_used ; i++)
+		__free_page(extra_pages[i]);
+	for (i = 0; i < vcnt; i++)
+		flush_dcache_page(bvec[i].bv_page);
+
+	return 0;
+
+fail:
+	if (data_in)
+		vunmap(data_in);
+	if (data_out)
+		vunmap(data_out);
+	for (i = 0; i < extra_pages_used; i++)
+		__free_page(extra_pages[i]);
+	return ret;
+}
+
+static int lz4_decompress(struct list_head *ws, unsigned char *data_in,
+			  struct page *dest_page,
+			  unsigned long start_byte,
+			  size_t srclen, size_t destlen)
+{
+	size_t out_len;
+	unsigned char ver;
+	int ret = 0;
+	char *kaddr = NULL;
+	unsigned long bytes;
+
+	if (srclen < LZ4_HDR_LEN)
+		return -EIO;
+
+	kaddr = kmap_atomic(dest_page);
+	if (!kaddr) {
+		printk(KERN_ERR "btrfs: kmap_atomic failed in lz4_decompress\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	read_header(data_in, &out_len, &ver);
+	data_in += LZ4_HDR_LEN;
+	if (ver != LZ4_HDR_VER) {
+		printk(KERN_ERR "btrfs: lz4 unknown container version found\n");
+		return -EIO;
+	}
+	ret = LZ4_uncompress(data_in, kaddr, out_len);
+	if (ret < 0) {
+		ret = -EIO;
+		goto out;
+	}
+	else
+		ret = 0;
+
+	if (start_byte) {
+		bytes = min_t(unsigned long, destlen, out_len - start_byte);
+		memmove(kaddr, kaddr + start_byte, bytes);
+	}
+
+out:
+	if (kaddr)
+		kunmap_atomic(kaddr);
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
+
+struct btrfs_compress_op btrfs_lz4hc_compress = {
+	.alloc_workspace	= lz4hc_alloc_workspace,
+	.free_workspace		= lz4_free_workspace,
+	.compress_pages		= lz4hc_compress_pages,
+	.decompress_biovec	= lz4_decompress_biovec,
+	.decompress		= lz4_decompress,
+};
-- 
1.7.11

