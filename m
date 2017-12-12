Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33687 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752103AbdLLU5b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 15:57:31 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: nefelim4ag@gmail.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 1/3] btrfs: heuristic: open code get_num callback of radix sort
Date: Tue, 12 Dec 2017 21:55:29 +0100
Message-Id: <cb3d35b57015fbb0f748d4cc11c7d46c2522e4c0.1513111931.git.dsterba@suse.com>
In-Reply-To: <cover.1513111931.git.dsterba@suse.com>
References: <cover.1513111931.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The callback is trivial and we don't need the abstraction for our
purposes. Let's open code it and also make the array types explicit.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 28c3940062b7..37a69d4b04ce 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1318,12 +1318,6 @@ static void copy_cell(void *dst, int dest_i, void *src, int src_i)
 	dstv[dest_i] = srcv[src_i];
 }
 
-static u64 get_num(const void *a, int i)
-{
-	struct bucket_item *av = (struct bucket_item *)a;
-	return av[i].count;
-}
-
 /*
  * Use 4 bits as radix base
  * Use 16 u32 counters for calculating new possition in buf array
@@ -1332,12 +1326,11 @@ static u64 get_num(const void *a, int i)
  * @array_buf - buffer array to store sorting results
  *              must be equal in size to @array
  * @num       - array size
- * @get_num   - function to extract number from array
  * @copy_cell - function to copy data from array to array_buf and vice versa
  * @get4bits  - function to get 4 bits from number at specified offset
  */
-static void radix_sort(void *array, void *array_buf, int num,
-		       u64 (*get_num)(const void *, int i),
+static void radix_sort(struct bucket_item *array, struct bucket_item *array_buf,
+		       int num,
 		       void (*copy_cell)(void *dest, int dest_i,
 					 void* src, int src_i),
 		       u8 (*get4bits)(u64 num, int shift))
@@ -1355,9 +1348,9 @@ static void radix_sort(void *array, void *array_buf, int num,
 	 * Try avoid useless loop iterations for small numbers stored in big
 	 * counters.  Example: 48 33 4 ... in 64bit array
 	 */
-	max_num = get_num(array, 0);
+	max_num = array[0].count;
 	for (i = 1; i < num; i++) {
-		buf_num = get_num(array, i);
+		buf_num = array[i].count;
 		if (buf_num > max_num)
 			max_num = buf_num;
 	}
@@ -1370,7 +1363,7 @@ static void radix_sort(void *array, void *array_buf, int num,
 		memset(counters, 0, sizeof(counters));
 
 		for (i = 0; i < num; i++) {
-			buf_num = get_num(array, i);
+			buf_num = array[i].count;
 			addr = get4bits(buf_num, shift);
 			counters[addr]++;
 		}
@@ -1379,7 +1372,7 @@ static void radix_sort(void *array, void *array_buf, int num,
 			counters[i] += counters[i - 1];
 
 		for (i = num - 1; i >= 0; i--) {
-			buf_num = get_num(array, i);
+			buf_num = array[i].count;
 			addr = get4bits(buf_num, shift);
 			counters[addr]--;
 			new_addr = counters[addr];
@@ -1397,7 +1390,7 @@ static void radix_sort(void *array, void *array_buf, int num,
 		memset(counters, 0, sizeof(counters));
 
 		for (i = 0; i < num; i ++) {
-			buf_num = get_num(array_buf, i);
+			buf_num = array_buf[i].count;
 			addr = get4bits(buf_num, shift);
 			counters[addr]++;
 		}
@@ -1406,7 +1399,7 @@ static void radix_sort(void *array, void *array_buf, int num,
 			counters[i] += counters[i - 1];
 
 		for (i = num - 1; i >= 0; i--) {
-			buf_num = get_num(array_buf, i);
+			buf_num = array_buf[i].count;
 			addr = get4bits(buf_num, shift);
 			counters[addr]--;
 			new_addr = counters[addr];
@@ -1444,7 +1437,7 @@ static int byte_core_set_size(struct heuristic_ws *ws)
 	struct bucket_item *bucket = ws->bucket;
 
 	/* Sort in reverse order */
-	radix_sort(ws->bucket, ws->bucket_b, BUCKET_SIZE, get_num, copy_cell,
+	radix_sort(ws->bucket, ws->bucket_b, BUCKET_SIZE, copy_cell,
 			get4bits);
 
 	for (i = 0; i < BYTE_CORE_SET_LOW; i++)
-- 
2.15.1

