Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34885 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdGAQ4R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Jul 2017 12:56:17 -0400
Received: by mail-wr0-f196.google.com with SMTP id z45so41534555wrb.2
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Jul 2017 09:56:16 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [RFC PATCH v4 2/2] Btrfs: add heuristic method for make decision compress or not compress
Date: Sat,  1 Jul 2017 19:56:02 +0300
Message-Id: <20170701165602.31189-3-nefelim4ag@gmail.com>
In-Reply-To: <20170701165602.31189-1-nefelim4ag@gmail.com>
References: <20170701165602.31189-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a heuristic computation before compression,
for avoiding load resource heavy compression workspace,
if data are probably can't be compressed

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/Makefile    |   2 +-
 fs/btrfs/heuristic.c | 336 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/heuristic.h |  14 +++
 fs/btrfs/inode.c     |  36 +++---
 4 files changed, 373 insertions(+), 15 deletions(-)
 create mode 100644 fs/btrfs/heuristic.c
 create mode 100644 fs/btrfs/heuristic.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 128ce17a80b0..8386095c9032 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o hash.o free-space-tree.o
+	   uuid-tree.o props.o hash.o free-space-tree.o heuristic.o log2_lshift16.o

 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
new file mode 100644
index 000000000000..ff6c8aee324d
--- /dev/null
+++ b/fs/btrfs/heuristic.c
@@ -0,0 +1,336 @@
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/fs.h>
+#include <linux/math64.h>
+#include <linux/pagemap.h>
+#include <linux/highmem.h>
+#include <linux/sort.h>
+#include <linux/slab.h>
+
+#include "heuristic.h"
+/* Precalculated log2 realization */
+#include "log2_lshift16.h"
+
+/* For shannon full integer entropy calculation */
+#define  __BUCKET_SIZE (1 << 8)
+
+struct __bucket_item {
+	u8  padding;
+	u8  symbol;
+	u16 count;
+};
+
+
+/* For sorting */
+static int compare(const void *lhs, const void *rhs)
+{
+	struct __bucket_item *l = (struct __bucket_item *)(lhs);
+	struct __bucket_item *r = (struct __bucket_item *)(rhs);
+
+	return r->count - l->count;
+}
+
+
+/* Fast detect zeroes */
+static inline bool __is_zeroes(const uint8_t *sample,
+	const uint32_t sample_size)
+{
+	size_t a = 0;
+	size_t zero = 0;
+
+	for (; a < sample_size; a += sizeof(size_t)) {
+		if (memcmp(&zero, &sample[a], sizeof(size_t)))
+			return false;
+	}
+
+	return true;
+}
+
+/*
+ * For good compressible data
+ * symbol set size over sample
+ * will be small < 64
+ */
+#define __SYMBSET_HIGH 64
+static u32 __symbset_calc(const struct __bucket_item *bucket)
+{
+	size_t a = 0;
+	u32 symbset_size = 0;
+
+	for (; a < __SYMBSET_HIGH+1; a++) {
+		if (bucket[a].count)
+			symbset_size++;
+	}
+
+	if (symbset_size >= __SYMBSET_HIGH)
+		return symbset_size;
+
+	for (; a <  __BUCKET_SIZE && symbset_size < __SYMBSET_HIGH; a++) {
+		if (bucket[a].count)
+			symbset_size++;
+	}
+
+	return symbset_size;
+}
+
+
+/*
+ * Try calculate coreset size
+ * i.e. how many symbols use 90% of input data
+ * < 50 - good compressible data
+ * > 200 - bad compressible data
+ * For right & fast calculation bucket must be reverse sorted
+ */
+#define __CORESET_LOW 50
+#define __CORESET_HIGH 200
+static u32 __coreset_calc(const struct __bucket_item *bucket,
+	const u32 sum_threshold)
+{
+	u32 a = 0;
+	u32 coreset_sum = 0;
+
+	for (; a < __CORESET_LOW-1; a++)
+		coreset_sum += bucket[a].count;
+
+	if (coreset_sum > sum_threshold)
+		return a;
+
+	for (; a < __CORESET_HIGH+1 && bucket[a].count; a++) {
+		coreset_sum += bucket[a].count;
+		if (coreset_sum > sum_threshold)
+			break;
+	}
+
+	return a;
+}
+
+static u64 __entropy_perc(const struct __bucket_item *bucket,
+	const u32 sample_size)
+{
+	u32 a, entropy_max = LOG2_RET_SHIFT*8;
+	u64 p, entropy_sum = 0;
+
+	for (a = 0; a <  __BUCKET_SIZE && bucket[a].count > 0; a++) {
+		p = bucket[a].count;
+		p = div64_u64(p*LOG2_ARG_SHIFT, sample_size);
+		entropy_sum += -p*log2_lshift16(p);
+	}
+
+	entropy_sum = div64_u64(entropy_sum, LOG2_ARG_SHIFT);
+
+	return div64_u64(entropy_sum*100, entropy_max);
+}
+
+/* Pair distance from random distribution */
+static u32 __random_pairs_distribution(const struct __bucket_item *bucket,
+	const u32 coreset_size, const u8 *sample, u32 sample_size)
+{
+	size_t a, b;
+	u8 pair_a[2], pair_b[2];
+	u16 *pair_c;
+	u32 pairs_count;
+	u64 sum = 0;
+	u64 buf1, buf2;
+
+	for (a = 0; a < coreset_size-1; a++) {
+		pairs_count = 0;
+		pair_a[0] = bucket[a].symbol;
+		pair_a[1] = bucket[a+1].symbol;
+		pair_b[1] = bucket[a].symbol;
+		pair_b[0] = bucket[a+1].symbol;
+		for (b = 0; b < sample_size-1; b++) {
+			pair_c = (u16 *) &sample[b];
+
+			if (pair_c == (u16 *) pair_a)
+				pairs_count++;
+			else if (pair_c == (u16 *) pair_b)
+				pairs_count++;
+		}
+		buf1 = bucket[a].count*bucket[a+1].count;
+		buf1 = div64_u64(buf1*100000, (sample_size*sample_size));
+		buf2 = pairs_count*2*100000;
+		buf2 = div64_u64(pairs_count, sample_size);
+		sum += (buf1 - buf2)*(buf1 - buf2);
+	}
+
+	return sum >> 11;
+}
+
+/*
+ * Algorithm description
+ * 1. Get subset of data for fast computation
+ * 2. Fast detect zeroed blocks
+ * 3. Scan bucket for symbol set
+ *    - symbol set < 64 - data will be easy compressible, return
+ * 4. Try compute coreset size (symbols count that use 90% of input data)
+ *    - reverse sort bucket
+ *    - sum cells until we reach 90% threshold,
+ *      incriment coreset size each time
+ *    - coreset_size < 50  - data will be easy compressible, return
+ *                   > 200 - data will be bad compressible, return
+ *      in general this looks like data compression ratio 0.2 - 0.8
+ * 5. Compute shannon entropy
+ *    - shannon entropy count of bytes and can't count pairs & entropy_calc
+ *      so assume:
+ *        - usage of entropy can lead to false negative
+ *          so for prevent that (in bad) case it's useful to "count" pairs
+ *        - entropy are not to high < 70% easy compressible, return
+ *        - entropy are high < 90%, try count pairs,
+ *          if there is any noticeable amount, compression are possible, return
+ *        - entropy are high > 90%, try count pairs,
+ *          if there is noticeable amount, compression are possible, return
+ */
+
+
+#define READ_SIZE 16
+#define __ENTROPY_LVL_MED 70
+#define __ENTROPY_LVL_HIGH 90
+static enum compression_advice ___btrfs_compress_heuristic(const u8 *sample,
+	const u32 sample_size)
+{
+	enum compression_advice ret = COMPRESS_COST_UNKNOWN;
+	u32 a, coreset_size, entropy_lvl;
+	struct __bucket_item *bucket = NULL;
+
+	if (__is_zeroes(sample, sample_size)) {
+		ret = COMPRESS_COST_EASY;
+		goto out;
+	}
+
+	bucket = kcalloc(__BUCKET_SIZE, sizeof(struct __bucket_item),
+		GFP_NOFS);
+	if (!bucket)
+		goto out;
+
+	for (a = 0; a < sample_size; a++)
+		bucket[sample[a]].count++;
+
+	if (__is_zeroes(sample, sample_size)) {
+		ret = COMPRESS_COST_EASY;
+		goto out;
+	}
+
+	a = __symbset_calc(bucket);
+	if (a < __SYMBSET_HIGH) {
+		ret = COMPRESS_COST_EASY;
+		goto out;
+	}
+
+	/*
+	 * Preset symbols, 0 - cell already set
+	 * For computation __random_pairs_distribution() of symbols pairs
+	 * code must understand which symbols in array and where
+	 */
+	for (a = 1; a <  __BUCKET_SIZE; a++)
+		bucket[a].symbol = a;
+
+	/* Sort in reverse order */
+	sort(bucket, __BUCKET_SIZE, sizeof(struct __bucket_item),
+		&compare, NULL);
+
+	coreset_size = __coreset_calc(bucket, sample_size*90/100);
+
+	if (coreset_size < __CORESET_LOW) {
+		ret = COMPRESS_COST_EASY;
+		goto out;
+	}
+
+	if (coreset_size > __CORESET_HIGH) {
+		ret = COMPRESS_NONE;
+		goto out;
+	}
+
+	/*
+	 * Okay, code can't fast detect data type
+	 * Let's calculate entropy
+	 */
+	entropy_lvl = __entropy_perc(bucket, sample_size);
+	if (entropy_lvl < __ENTROPY_LVL_MED) {
+		ret = COMPRESS_COST_MEDIUM;
+		goto out;
+	}
+
+	a = __random_pairs_distribution(bucket, coreset_size, sample,
+		sample_size);
+	if (entropy_lvl < __ENTROPY_LVL_HIGH) {
+		if (a > 0)
+			ret = COMPRESS_COST_MEDIUM;
+		else
+			ret = COMPRESS_NONE;
+		goto out;
+	} else {
+		if (a > 10)
+			ret = COMPRESS_COST_HARD;
+		else
+			ret = COMPRESS_NONE;
+		goto out;
+	}
+
+out:
+	kfree(bucket);
+	return ret;
+}
+
+enum compression_advice btrfs_compress_heuristic(struct inode *inode,
+	u64 start, u64 end)
+{
+	enum compression_advice ret = COMPRESS_COST_UNKNOWN;
+	u64 input_size = end - start;
+	u64 index = start >> PAGE_SHIFT;
+	u64 end_index = end >> PAGE_SHIFT;
+	struct page *page;
+	u32 a, b, c;
+	u32 offset_count, shift, sample_size;
+	u8 *sample;
+	u8 *input_data;
+
+	/*
+	 * In data: 128K  64K   32K   4K
+	 * Sample:  4096b 3072b 2048b 1024b
+	 * Avoid allocating array bigger then 4kb
+	 */
+	if (input_size >= 96*1024)
+		offset_count = 256;
+	else
+		offset_count = 64 + input_size/512;
+
+	shift = input_size/offset_count;
+	sample_size = offset_count*READ_SIZE;
+
+	/*
+	 * speedup by copy data to sample array +30%
+	 * I think it's because of memcpy optimizations and
+	 * cpu cache hits
+	 */
+	sample = kmalloc(sample_size, GFP_NOFS);
+	if (!sample)
+		goto out;
+
+	/* Read small subset of data 1024b-4096b */
+	a = 0; b = 0;
+	while (index <= end_index) {
+		page = find_get_page(inode->i_mapping, index);
+		input_data = kmap(page);
+		c = 0;
+		while (c < PAGE_SIZE - READ_SIZE) {
+			if (a >= input_size  - READ_SIZE)
+				break;
+			if (b >= sample_size - READ_SIZE)
+				break;
+			memcpy(&sample[b], &input_data[c], READ_SIZE);
+			c += shift;
+			a += shift;
+			b += READ_SIZE;
+		}
+		kunmap(page);
+		put_page(page);
+		index++;
+	}
+
+	ret = ___btrfs_compress_heuristic(sample, sample_size);
+
+out:
+	kfree(sample);
+	return ret;
+}
diff --git a/fs/btrfs/heuristic.h b/fs/btrfs/heuristic.h
new file mode 100644
index 000000000000..3565a6219b2a
--- /dev/null
+++ b/fs/btrfs/heuristic.h
@@ -0,0 +1,14 @@
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+
+enum compression_advice {
+	COMPRESS_NONE,
+	COMPRESS_COST_UNKNOWN,
+	COMPRESS_COST_EASY,
+	COMPRESS_COST_MEDIUM,
+	COMPRESS_COST_HARD
+};
+
+enum compression_advice btrfs_compress_heuristic(struct inode *inode,
+	u64 start, u64 end);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ef3c98c527c1..19654a83da36 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,6 +60,7 @@
 #include "props.h"
 #include "qgroup.h"
 #include "dedupe.h"
+#include "heuristic.h"

 struct btrfs_iget_args {
 	struct btrfs_key *location;
@@ -458,16 +459,16 @@ static noinline void compress_file_range(struct inode *inode,
 	unsigned long total_compressed = 0;
 	unsigned long total_in = 0;
 	int i;
-	int will_compress;
+	bool will_compress;
 	int compress_type = fs_info->compress_type;
-	int redirty = 0;
+	bool redirty = false;

 	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
 			SZ_16K);

 	actual_end = min_t(u64, isize, end + 1);
 again:
-	will_compress = 0;
+	will_compress = false;
 	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
 	BUILD_BUG_ON((BTRFS_MAX_COMPRESSED % PAGE_SIZE) != 0);
 	nr_pages = min_t(unsigned long, nr_pages,
@@ -510,15 +511,6 @@ static noinline void compress_file_range(struct inode *inode,
 	 */
 	if (inode_need_compress(inode)) {
 		WARN_ON(pages);
-		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
-		if (!pages) {
-			/* just bail out to the uncompressed code */
-			goto cont;
-		}
-
-		if (BTRFS_I(inode)->force_compress)
-			compress_type = BTRFS_I(inode)->force_compress;
-
 		/*
 		 * we need to call clear_page_dirty_for_io on each
 		 * page in the range.  Otherwise applications with the file
@@ -529,7 +521,23 @@ static noinline void compress_file_range(struct inode *inode,
 		 * dirty again later on.
 		 */
 		extent_range_clear_dirty_for_io(inode, start, end);
-		redirty = 1;
+		redirty = true;
+
+		ret = btrfs_compress_heuristic(inode, start, end);
+
+		/* Heuristic say: dont try compress that */
+		if (!ret)
+			goto cont;
+
+		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
+		if (!pages) {
+			/* just bail out to the uncompressed code */
+			goto cont;
+		}
+
+		if (BTRFS_I(inode)->force_compress)
+			compress_type = BTRFS_I(inode)->force_compress;
+
 		ret = btrfs_compress_pages(compress_type,
 					   inode->i_mapping, start,
 					   pages,
@@ -552,7 +560,7 @@ static noinline void compress_file_range(struct inode *inode,
 				       PAGE_SIZE - offset);
 				kunmap_atomic(kaddr);
 			}
-			will_compress = 1;
+			will_compress = true;
 		}
 	}
 cont:
--
2.13.2
