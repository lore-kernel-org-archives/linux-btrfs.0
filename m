From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/3] BTRFS: Add snappy support
Date: Thu, 20 Oct 2011 16:39:00 -0700
Message-ID: <1319153941-26234-2-git-send-email-andi@firstfloor.org>
References: <1319153941-26234-1-git-send-email-andi@firstfloor.org>
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	linux-crypto@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319153941-26234-1-git-send-email-andi@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Andi Kleen <ak@linux.intel.com>

Add support in btrfs for snappy compression.

This is based on the lzo code with minor modifications.
The btrfs glue code could be significantly improved over LZO
by exploiting some snappy features, but hasn't so far.

Open: implement scatter-gather support and get rid of the temporary
buffers.

Some performance numbers (thanks to Jacob Sowles for running them)

bonnie++, Core i7-64bit

    block output rewrite  block input random
       K/sec     K/sec    K/sec       K/sec
None   100%      100%     100%        100%
zlib    +6.3%    +5.4%    +6.6%       +11.6%
lzo    +11.5%    +4.6%    +12.4%      +6.7%
snappy +19.3%    +28.1%   +32.6%      +9.3%

Snappy does extremly well on the 64bit architecture,
outperforming everything else, sometimes with a healthy
margin.

bonnie++, Atom-32bit

    block output rewrite  block input random

       K/sec     K/sec    K/sec       K/sec
None   100%      100%     100%        100%
zlib   -43.1%    -24.2%   -19.0%      +12.0%
lzo    +0.8%     +2.6%    +6.8%       +14.8%
snappy +19.5%    +16.2%   +24.0%      +15.7%

zlib does very poorly on Atom, actually degrading
performance. snappy is generally faster or similar to LZO.
The difference is not as big as on the 64bit CPU though, but
still visible.

bonnie++, files, Core-i7-64bit

sequential create    delete random create delete
           files/sec
None       100%      100%          100%   100%
zlib       +8.3%     +10.5%        +10.3%  +1.4%
lzo        +3.8%     +3.3%         +5.4%   -3.89%
snappy     +23.7%    +37.2%        +21.8%  +23.8%

bonnie++, files, Atom-32bit

sequential create    delete random create delete
           files/sec
None       100%      100%          100%   100%
zlib       +3.0%     +7.9%         +5.2%  +5.1%
lzo        +8.2%     +5.9%         +4.8%  +4.6%
snappy     +3.1%     +8.5%         +5.7%  +1.3%

Creation/Deletion on Atom is a case where snappy loses to LZO,
however the loss is small. On 64bit Core it's a win.

I should add that these benchmarks mainly use 0 filled IO,
however FFSB was also quickly tested with more random data
and the differences were similar. See also the micro benchmarks
in the algorithm description for the behaviour with different
data types.

FFSB, 4 threads, stair case data pattern, Reads MB/s

Core i7-64bit                 Atom-32bit
       MB/s                   MB/s
None   100%                   100%
zlib   +8.0%                  +4.2%
lzo    +9.3%                  +4.8%
snappy +12.4%                 +7.9%

In general snappy is a better replacement for LZO, especially
on 64bit, but even on 32bit.

Cc: chris.mason@oracle.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/btrfs/Kconfig       |    1 +
 fs/btrfs/Makefile      |    3 +-
 fs/btrfs/compression.c |    1 +
 fs/btrfs/compression.h |    1 +
 fs/btrfs/ctree.h       |    9 +-
 fs/btrfs/disk-io.c     |    2 +
 fs/btrfs/ioctl.c       |    4 +
 fs/btrfs/snappy.c      |  435 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/super.c       |    9 +-
 lib/Makefile           |    1 +
 10 files changed, 461 insertions(+), 5 deletions(-)
 create mode 100644 fs/btrfs/snappy.c

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index ecb9fd3..d55df9c 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -6,6 +6,7 @@ config BTRFS_FS
 	select ZLIB_DEFLATE
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
+	select SNAPPY
 	help
 	  Btrfs is a new filesystem with extents, writable snapshotting,
 	  support for multiple devices and many more features.
diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 40e6ac0..7cd86e7 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -7,6 +7,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
-	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o
+	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
+	   snappy.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8ec5d86..b171858 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -729,6 +729,7 @@ static wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES];
 struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
+	&btrfs_snappy_compress,
 };
 
 int __init btrfs_init_compress(void)
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index a12059f..971a425 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -79,5 +79,6 @@ struct btrfs_compress_op {
 
 extern struct btrfs_compress_op btrfs_zlib_compress;
 extern struct btrfs_compress_op btrfs_lzo_compress;
+extern struct btrfs_compress_op btrfs_snappy_compress;
 
 #endif
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 03912c5..7ebdae3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -415,6 +415,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
 #define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
+#define BTRFS_FEATURE_INCOMPAT_COMPRESS_SNAPPY	(1ULL << 4)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -422,7 +423,8 @@ struct btrfs_super_block {
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
-	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_SNAPPY)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -578,8 +580,9 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
-	BTRFS_COMPRESS_LAST  = 3,
+	BTRFS_COMPRESS_SNAPPY = 3,
+	BTRFS_COMPRESS_TYPES = 3,
+	BTRFS_COMPRESS_LAST  = 4,
 };
 
 struct btrfs_inode_item {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b3ac6..4c04228 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1808,6 +1808,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
 	if (tree_root->fs_info->compress_type & BTRFS_COMPRESS_LZO)
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
+	if (tree_root->fs_info->compress_type & BTRFS_COMPRESS_SNAPPY)
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_SNAPPY;
 	btrfs_set_super_incompat_flags(disk_super, features);
 
 	features = btrfs_super_compat_ro_flags(disk_super) &
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 538f65a..3f15175 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1133,6 +1133,10 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
 		btrfs_set_super_incompat_flags(disk_super, features);
 	}
+	if (range->compress_type == BTRFS_COMPRESS_SNAPPY) {
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_SNAPPY;
+		btrfs_set_super_incompat_flags(disk_super, features);
+	}
 
 	if (!file)
 		kfree(ra);
diff --git a/fs/btrfs/snappy.c b/fs/btrfs/snappy.c
new file mode 100644
index 0000000..a715f9d
--- /dev/null
+++ b/fs/btrfs/snappy.c
@@ -0,0 +1,435 @@
+/*
+ * Copyright (C) 2011 Intel Corporation
+ * Author: Andi Kleen
+ * Copyright (C) 2008 Oracle
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
+/* largely copy'n'pasted from lzo.c Unify? */
+
+/* XXX: could use snappy's fragments to avoid the working buffer?
+ * However it's difficult to kmap multiple buffers.
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
+#include <linux/snappy.h>
+#include "compression.h"
+
+#define SNAPPY_LEN	4
+
+struct workspace {
+	void *buf;	/* where compressed data goes */
+	void *cbuf;	/* where decompressed data goes */
+	struct snappy_env env;
+	struct list_head list;
+};
+
+static void snappy_free_workspace(struct list_head *ws)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+
+	snappy_free_env(&workspace->env);
+	vfree(workspace->buf);
+	vfree(workspace->cbuf);
+	kfree(workspace);
+}
+
+static struct list_head *snappy_alloc_workspace(void)
+{
+	struct workspace *workspace;
+
+	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
+	if (!workspace)
+		return ERR_PTR(-ENOMEM);
+
+	workspace->buf = vmalloc(PAGE_CACHE_SIZE);
+	workspace->cbuf = vmalloc(snappy_max_compressed_length(PAGE_CACHE_SIZE));
+	if (!workspace->buf || !workspace->cbuf)
+		goto fail;
+
+	if (snappy_init_env(&workspace->env) < 0)
+		goto fail;
+
+	INIT_LIST_HEAD(&workspace->list);
+
+	return &workspace->list;
+fail:
+	snappy_free_workspace(&workspace->list);
+	return ERR_PTR(-ENOMEM);
+}
+
+static inline void write_compress_length(char *buf, size_t len)
+{
+	__le32 dlen;
+
+	dlen = cpu_to_le32(len);
+	memcpy(buf, &dlen, SNAPPY_LEN);
+}
+
+static inline size_t read_compress_length(char *buf)
+{
+	__le32 dlen;
+
+	memcpy(&dlen, buf, SNAPPY_LEN);
+	return le32_to_cpu(dlen);
+}
+
+static int snappy_compress_pages(struct list_head *ws,
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
+	out_offset = SNAPPY_LEN;
+	tot_out = SNAPPY_LEN;
+	pages[0] = out_page;
+	nr_pages = 1;
+	pg_bytes_left = PAGE_CACHE_SIZE - SNAPPY_LEN;
+
+	/* compress at most one page of data each time */
+	in_len = min(len, PAGE_CACHE_SIZE);
+	while (tot_in < len) {
+		ret = snappy_compress(&workspace->env,
+				      data_in, in_len, workspace->cbuf,
+				       &out_len);
+		if (ret != 0) {
+			printk(KERN_DEBUG "btrfs uncompression in loop returned %d\n",
+			       ret);
+			ret = -1;
+			goto out;
+		}
+
+		/* store the size of this chunk of compressed data */
+		write_compress_length(cpage_out + out_offset, out_len);
+		tot_out += SNAPPY_LEN;
+		out_offset += SNAPPY_LEN;
+		pg_bytes_left -= SNAPPY_LEN;
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
+			if ((out_len == 0 && pg_bytes_left < SNAPPY_LEN) ||
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
+static int snappy_decompress_biovec(struct list_head *ws,
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
+	tot_in = SNAPPY_LEN;
+	in_offset = SNAPPY_LEN;
+	tot_len = min_t(size_t, srclen, tot_len);
+	in_page_bytes_left = PAGE_CACHE_SIZE - SNAPPY_LEN;
+
+	tot_out = 0;
+	pg_offset = 0;
+
+	while (tot_in < tot_len) {
+		in_len = read_compress_length(data_in + in_offset);
+		in_page_bytes_left -= SNAPPY_LEN;
+		in_offset += SNAPPY_LEN;
+		tot_in += SNAPPY_LEN;
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
+			if ((working_bytes == 0 && 
+                               in_page_bytes_left < SNAPPY_LEN)
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
+		ret = -1;
+		if (snappy_uncompressed_length(buf, in_len, &out_len))
+			ret = snappy_uncompress(buf, in_len, workspace->buf);
+		if (need_unmap)
+			kunmap(pages_in[page_in_index - 1]);
+		if (ret != 0) {
+			printk(KERN_WARNING "btrfs decompress failed\n");
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
+static int btrfs_snappy_decompress(struct list_head *ws, unsigned char *data_in,
+				   struct page *dest_page,
+				   unsigned long start_byte,
+				   size_t srclen, size_t destlen)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	size_t in_len;
+	size_t out_len;
+	int ret = 0;
+	char *kaddr;
+	unsigned long bytes;
+
+	BUG_ON(srclen < SNAPPY_LEN);
+
+	in_len = read_compress_length(data_in);
+	data_in += SNAPPY_LEN;
+
+	ret = -1;
+	if (snappy_uncompressed_length(data_in, in_len, &out_len))
+		ret = snappy_uncompress(data_in, in_len, workspace->buf);
+	if (ret != 0) {
+		printk(KERN_WARNING "btrfs decompress failed!\n");
+		ret = -1;
+		goto out;
+	}
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
+struct btrfs_compress_op btrfs_snappy_compress = {
+	.alloc_workspace	= snappy_alloc_workspace,
+	.free_workspace		= snappy_free_workspace,
+	.compress_pages		= snappy_compress_pages,
+	.decompress_biovec	= snappy_decompress_biovec,
+	.decompress		= btrfs_snappy_decompress,
+};
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 15634d4..d3a2d10 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -267,6 +267,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			} else if (strcmp(args[0].from, "lzo") == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
+			} else if (strcmp(args[0].from, "snappy") == 0) {
+				compress_type = "snappy";
+				info->compress_type = BTRFS_COMPRESS_SNAPPY;
 			} else {
 				ret = -EINVAL;
 				goto out;
@@ -696,8 +699,12 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (btrfs_test_opt(root, COMPRESS)) {
 		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
 			compress_type = "zlib";
-		else
+		else if (info->compress_type == BTRFS_COMPRESS_SNAPPY)
+			compress_type = "snappy";
+		else if (info->compress_type == BTRFS_COMPRESS_LZO)
 			compress_type = "lzo";
+		else
+			compress_type = "?";
 		if (btrfs_test_opt(root, FORCE_COMPRESS))
 			seq_printf(seq, ",compress-force=%s", compress_type);
 		else
diff --git a/lib/Makefile b/lib/Makefile
index e38e580..2fad385 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_AVERAGE) += average.o
 
 obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o
 
+CFLAGS_snappy.o += $(call cc-disable-warning, declaration-after-statement) -DNDEBUG=1
 obj-$(CONFIG_CORDIC) += cordic.o
 
 obj-$(CONFIG_LLIST) += llist.o
-- 
1.7.4.4
