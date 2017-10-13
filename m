Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:43840 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752644AbdJMAcr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 20:32:47 -0400
Received: by mail-wm0-f65.google.com with SMTP id m72so26003523wmc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 17:32:46 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [RFC PATCH] Btrfs: heuristic replace heap sort with radix sort
Date: Fri, 13 Oct 2017 03:32:37 +0300
Message-Id: <20171013003237.3061-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Slowest part of heuristic for now is kernel heap sort()
It's can take up to 55% of runtime on sorting bucket items.

As sorting will always call on most data sets to get correctly
byte_core_set_size, the only way to speed up heuristic, is to
speed up sort on bucket.

So, add a general radix_sort function.
Radix sort require 2 buffers, one full size of input array
and one for store counters (jump addresses).

So for buffer array, just allocate BUCKET_SIZE*2 for bucket,
and use free tale as a buffer, to improve data locality.
That increase usage per heuristic workspace +1KiB
8KiB + 1KiB -> 8KiB + 2KiB

That is LSD Radix, i use 4 bit as a base for calculating,
to make counters array acceptable small (16el*8byte).

Not tested on Big.Endian.
I try handle that by some kernel macros.

Performance tested in userspace copy of heuristic code,
throughput:
    - average <-> random data: ~3500 MiB/s      - heap  sort
    - average <-> random data: ~6000 MiB/s +71% - radix sort

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 153 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 141 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 01738b9a8dc7..f320fbb1de17 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -753,6 +753,7 @@ struct heuristic_ws {
 	u32 sample_size;
 	/* Bucket store counter for each byte type */
 	struct bucket_item *bucket;
+	struct bucket_item *bucket_buf;
 	struct list_head list;
 };

@@ -778,10 +779,12 @@ static struct list_head *alloc_heuristic_ws(void){
 	if (!ws->sample)
 		goto fail;

-	ws->bucket = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket), GFP_KERNEL);
+	ws->bucket = kcalloc(BUCKET_SIZE*2, sizeof(*ws->bucket), GFP_KERNEL);
 	if (!ws->bucket)
 		goto fail;

+	ws->bucket_buf = &ws->bucket[BUCKET_SIZE];
+
 	INIT_LIST_HEAD(&ws->list);
 	return &ws->list;
 fail:
@@ -1225,6 +1228,137 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 	return 1;
 }

+#define RADIX_BASE 4
+#define COUNTERS_SIZE (1 << RADIX_BASE)
+
+static inline u8 get4bits(u64 num, int shift) {
+	u8 low4bits;
+	num = num >> shift;
+	/* Reverse order */
+	low4bits = (COUNTERS_SIZE - 1) - (num % COUNTERS_SIZE);
+	return low4bits;
+}
+
+static inline void copy_cell(void *dst, const void *src)
+{
+	struct bucket_item *dstv = (struct bucket_item *) dst;
+	struct bucket_item *srcv = (struct bucket_item *) src;
+	*dstv = *srcv;
+}
+
+static inline u64 get_num(const void *a)
+{
+	struct bucket_item *av = (struct bucket_item *) a;
+	return cpu_to_le32(av->count);
+}
+
+/*
+ * Kernel compatible radix sort implementation
+ * Use 4 bits as radix base
+ * Use 16 64bit counters for calculating new possition in buf array
+ * Tested only on Little Endian
+ *
+ * @array     - array that will be sorted
+ * @array_buf - buffer array to store sorting results
+ *              must be equal in size to @array
+ * @num       - array size
+ * @size      - item size
+ * @max_cell  - Link to element with maximum possible value
+ *              that can be used to cap radix sort iterations
+ *              if we know maximum value before call sort
+ * @get_num   - function to extract number from array
+ * @copy_cell - function to copy data from array to array_buf
+ *              and vise versa
+ * @get4bits  - function to get 4 bits from number at specified offset
+ */
+static void radix_sort(void *array, void *array_buf,
+		       int num, int size,
+		       const void *max_cell,
+		       u64 (*get_num)(const void *),
+		       void (*copy_cell)(void *dest, const void* src),
+		       u8 (*get4bits)(u64 num, int shift))
+{
+	u64 max_num;
+	u64 buf_num;
+	u64 counters[COUNTERS_SIZE];
+	u64 new_addr;
+	s64 i;
+	int addr;
+	int bitlen;
+	int shift;
+
+	/*
+	 * Try avoid useless loop iterations
+	 * For small numbers stored in big counters
+	 * example: 48 33 4 ... in 64bit array
+	 */
+	if (!max_cell) {
+		max_num = get_num(array);
+		for (i = 0 + size; i < num*size; i += size) {
+			buf_num = get_num(array + i);
+			if (le64_to_cpu(buf_num) > le64_to_cpu(max_num))
+				max_num = buf_num;
+		}
+	} else {
+		max_num = get_num(max_cell);
+	}
+
+	buf_num = ilog2(le64_to_cpu(max_num));
+	bitlen = ALIGN(buf_num, RADIX_BASE*2);
+
+	shift = 0;
+	while (shift < bitlen) {
+		memset(counters, 0, sizeof(counters));
+
+		for (i = 0; i < num*size; i += size) {
+			buf_num = get_num(array + i);
+			addr = get4bits(buf_num, shift);
+			counters[addr]++;
+		}
+
+		for (i = 1; i < COUNTERS_SIZE; i++)
+			counters[i] += counters[i-1];
+
+		for (i = (num - 1) * size; i >= 0; i -= size) {
+			buf_num = get_num(array + i);
+			addr = get4bits(buf_num, shift);
+			counters[addr]--;
+			new_addr = counters[addr];
+			copy_cell(array_buf + (new_addr*size), array + i);
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
+		for (i = 0; i < num*size; i += size) {
+			buf_num = get_num(array_buf + i);
+			addr = get4bits(buf_num, shift);
+			counters[addr]++;
+		}
+
+		for (i = 1; i < COUNTERS_SIZE; i++)
+			counters[i] += counters[i-1];
+
+		for (i = (num - 1) * size; i >= 0; i -= size) {
+			buf_num = get_num(array_buf + i);
+			addr = get4bits(buf_num, shift);
+			counters[addr]--;
+			new_addr = counters[addr];
+			copy_cell(array + (new_addr*size), array_buf + i);
+		}
+
+		shift += RADIX_BASE;
+	}
+}
+
 /*
  * Shannon Entropy calculation
  *
@@ -1280,15 +1414,6 @@ static u32 shannon_entropy(struct heuristic_ws *ws)
 	return entropy_sum * 100 / entropy_max;
 }

-/* Compare buckets by size, ascending */
-static inline int bucket_comp_rev(const void *lv, const void *rv)
-{
-	const struct bucket_item *l = (struct bucket_item *)(lv);
-	const struct bucket_item *r = (struct bucket_item *)(rv);
-
-	return r->count - l->count;
-}
-
 /*
  * Byte Core set size
  * How many bytes use 90% of sample
@@ -1317,9 +1442,13 @@ static int byte_core_set_size(struct heuristic_ws *ws)
 	u32 coreset_sum = 0;
 	u32 core_set_threshold = ws->sample_size * 90 / 100;
 	struct bucket_item *bucket = ws->bucket;
+	struct bucket_item max_cell;

-	/* Sort in reverse order */
-	sort(bucket, BUCKET_SIZE, sizeof(*bucket), &bucket_comp_rev, NULL);
+	max_cell.count = MAX_SAMPLE_SIZE;
+	radix_sort(bucket, ws->bucket_buf,
+		   BUCKET_SIZE, sizeof(*bucket),
+		   &max_cell,
+		   get_num, copy_cell, get4bits);

 	for (i = 0; i < BYTE_CORE_SET_LOW; i++)
 		coreset_sum += bucket[i].count;
--
2.14.2
