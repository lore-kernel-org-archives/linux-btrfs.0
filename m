Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35648 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbdLEIC0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 03:02:26 -0500
Received: by mail-wr0-f193.google.com with SMTP id g53so20003463wra.2
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Dec 2017 00:02:26 -0800 (PST)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v3] Btrfs: heuristic replace heap sort with radix sort
Date: Tue,  5 Dec 2017 11:02:08 +0300
Message-Id: <20171205080208.24408-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Slowest part of heuristic for now is kernel heap sort()
It's can take up to 55% of runtime on sorting bucket items.

As sorting will always call on most data sets to get correctly
byte_core_set_size, the only way to speed up heuristic, is to
speed up sort on bucket.

Add a general radix_sort function.
Radix sort require 2 buffers, one full size of input array
and one for store counters (jump addresses).

That increase usage per heuristic workspace +1KiB
8KiB + 1KiB -> 8KiB + 2KiB

That is LSD Radix, i use 4 bit as a base for calculating,
to make counters array acceptable small (16 elements * 8 byte).

That Radix sort implementation have several points to adjust,
I added him to make radix sort general usable in kernel,
like heap sort, if needed.

Performance tested in userspace copy of heuristic code,
throughput:
    - average <-> random data: ~3500 MiB/s - heap  sort
    - average <-> random data: ~6000 MiB/s - radix sort

Changes:
  v1 -> v2:
    - Tested on Big Endian
    - Drop most of multiply operations
    - Separately allocate sort buffer

Changes:
  v2 -> v3:
    - Fix uint -> u conversion
    - Reduce stack size, by reduce vars sizes to u32,
      restrict input array size to u32
      Assume that kernel will never try sorting arrays > 2^32
    - Drop max_cell arg (precheck - correctly find max value by it self)

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 135 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 128 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 06ef50712acd..9573f4491367 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -33,7 +33,6 @@
 #include <linux/bit_spinlock.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
-#include <linux/sort.h>
 #include <linux/log2.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -752,6 +751,8 @@ struct heuristic_ws {
 	u32 sample_size;
 	/* Buckets store counters for each byte value */
 	struct bucket_item *bucket;
+	/* Sorting buffer */
+	struct bucket_item *bucket_b;
 	struct list_head list;
 };
 
@@ -763,6 +764,7 @@ static void free_heuristic_ws(struct list_head *ws)
 
 	kvfree(workspace->sample);
 	kfree(workspace->bucket);
+	kfree(workspace->bucket_b);
 	kfree(workspace);
 }
 
@@ -782,6 +784,10 @@ static struct list_head *alloc_heuristic_ws(void)
 	if (!ws->bucket)
 		goto fail;
 
+	ws->bucket_b = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket_b), GFP_KERNEL);
+	if (!ws->bucket_b)
+		goto fail;
+
 	INIT_LIST_HEAD(&ws->list);
 	return &ws->list;
 fail:
@@ -1278,13 +1284,127 @@ static u32 shannon_entropy(struct heuristic_ws *ws)
 	return entropy_sum * 100 / entropy_max;
 }
 
-/* Compare buckets by size, ascending */
-static int bucket_comp_rev(const void *lv, const void *rv)
+#define RADIX_BASE 4
+#define COUNTERS_SIZE (1 << RADIX_BASE)
+
+static inline u8 get4bits(u64 num, u32 shift) {
+	u8 low4bits;
+	num = num >> shift;
+	/* Reverse order */
+	low4bits = (COUNTERS_SIZE - 1) - (num % COUNTERS_SIZE);
+	return low4bits;
+}
+
+static inline void copy_cell(void *dst, u32 dest_i, void *src, u32 src_i)
+{
+	struct bucket_item *dstv = (struct bucket_item *) dst;
+	struct bucket_item *srcv = (struct bucket_item *) src;
+	dstv[dest_i] = srcv[src_i];
+}
+
+static inline u64 get_num(const void *a, u32 i)
+{
+	struct bucket_item *av = (struct bucket_item *) a;
+	return av[i].count;
+}
+
+/*
+ * Use 4 bits as radix base
+ * Use 16 u32 counters for calculating new possition in buf array
+ *
+ * @array     - array that will be sorted
+ * @array_buf - buffer array to store sorting results
+ *              must be equal in size to @array
+ * @num       - array size
+ * @get_num   - function to extract number from array
+ * @copy_cell - function to copy data from array to array_buf
+ *              and vise versa
+ * @get4bits  - function to get 4 bits from number at specified offset
+ */
+
+static void radix_sort(void *array, void *array_buf, u32 num,
+		       u64 (*get_num)(const void *,  u32 i),
+		       void (*copy_cell)(void *dest, u32 dest_i,
+					 void* src,  u32 src_i),
+		       u8 (*get4bits)(u64 num, u32 shift))
 {
-	const struct bucket_item *l = (const struct bucket_item *)lv;
-	const struct bucket_item *r = (const struct bucket_item *)rv;
+	u64 max_num;
+	u64 buf_num;
+	u32 counters[COUNTERS_SIZE];
+	u32 new_addr;
+	u32 addr;
+	u32 bitlen;
+	u32 shift;
+	int i;
+
+	/*
+	 * Try avoid useless loop iterations
+	 * For small numbers stored in big counters
+	 * example: 48 33 4 ... in 64bit array
+	 */
+	max_num = get_num(array, 0);
+	for (i = 1; i < num; i++) {
+		buf_num = get_num(array, i);
+		if (buf_num > max_num)
+			max_num = buf_num;
+	}
 
-	return r->count - l->count;
+	buf_num = ilog2(max_num);
+	bitlen = ALIGN(buf_num, RADIX_BASE*2);
+
+	shift = 0;
+	while (shift < bitlen) {
+		memset(counters, 0, sizeof(counters));
+
+		for (i = 0; i < num; i++) {
+			buf_num = get_num(array, i);
+			addr = get4bits(buf_num, shift);
+			counters[addr]++;
+		}
+
+		for (i = 1; i < COUNTERS_SIZE; i++) {
+			counters[i] += counters[i-1];
+		}
+
+		for (i = (num - 1); i >= 0; i --) {
+			buf_num = get_num(array, i);
+			addr = get4bits(buf_num, shift);
+			counters[addr]--;
+			new_addr = counters[addr];
+			copy_cell(array_buf, new_addr, array, i);
+		}
+
+		shift += RADIX_BASE;
+
+		/*
+		 * For normal radix, that expected to
+		 * move data from tmp array, to main.
+		 * But that require some CPU time
+		 * Avoid that by doing another sort iteration
+		 * to origin array instead of memcpy()
+		 */
+		memset(counters, 0, sizeof(counters));
+
+		for (i = 0; i < num; i ++) {
+			buf_num = get_num(array_buf, i);
+			addr = get4bits(buf_num, shift);
+			counters[addr]++;
+		}
+
+		for (i = 1; i < COUNTERS_SIZE; i++) {
+			counters[i] += counters[i-1];
+		}
+
+		for (i = (num - 1); i >= 0; i--) {
+			buf_num = get_num(array_buf, i);
+			addr = get4bits(buf_num, shift);
+			counters[addr]--;
+			new_addr = counters[addr];
+			copy_cell(array, new_addr, array_buf, i);
+		}
+
+		shift += RADIX_BASE;
+	}
 }
 
 /*
@@ -1314,7 +1434,8 @@ static int byte_core_set_size(struct heuristic_ws *ws)
 	struct bucket_item *bucket = ws->bucket;
 
 	/* Sort in reverse order */
-	sort(bucket, BUCKET_SIZE, sizeof(*bucket), &bucket_comp_rev, NULL);
+	radix_sort(ws->bucket, ws->bucket_b,
+		   BUCKET_SIZE, get_num, copy_cell, get4bits);
 
 	for (i = 0; i < BYTE_CORE_SET_LOW; i++)
 		coreset_sum += bucket[i].count;
-- 
2.15.1
