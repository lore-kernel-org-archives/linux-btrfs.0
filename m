Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33691 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752509AbdLLU5d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 15:57:33 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: nefelim4ag@gmail.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3] btrfs: heuristic: open code copy_call callback of radix sort
Date: Tue, 12 Dec 2017 21:55:32 +0100
Message-Id: <90decd9b5c181d4b7d6759d24ea12d4477893940.1513111931.git.dsterba@suse.com>
In-Reply-To: <cover.1513111931.git.dsterba@suse.com>
References: <cover.1513111931.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The callback is trivial and we don't need the abstraction for our
purposes. Let's open code it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 37a69d4b04ce..935acabc0ea7 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1311,13 +1311,6 @@ static u8 get4bits(u64 num, int shift) {
 	return low4bits;
 }
 
-static void copy_cell(void *dst, int dest_i, void *src, int src_i)
-{
-	struct bucket_item *dstv = (struct bucket_item *)dst;
-	struct bucket_item *srcv = (struct bucket_item *)src;
-	dstv[dest_i] = srcv[src_i];
-}
-
 /*
  * Use 4 bits as radix base
  * Use 16 u32 counters for calculating new possition in buf array
@@ -1326,13 +1319,10 @@ static void copy_cell(void *dst, int dest_i, void *src, int src_i)
  * @array_buf - buffer array to store sorting results
  *              must be equal in size to @array
  * @num       - array size
- * @copy_cell - function to copy data from array to array_buf and vice versa
  * @get4bits  - function to get 4 bits from number at specified offset
  */
 static void radix_sort(struct bucket_item *array, struct bucket_item *array_buf,
 		       int num,
-		       void (*copy_cell)(void *dest, int dest_i,
-					 void* src, int src_i),
 		       u8 (*get4bits)(u64 num, int shift))
 {
 	u64 max_num;
@@ -1376,7 +1366,7 @@ static void radix_sort(struct bucket_item *array, struct bucket_item *array_buf,
 			addr = get4bits(buf_num, shift);
 			counters[addr]--;
 			new_addr = counters[addr];
-			copy_cell(array_buf, new_addr, array, i);
+			array_buf[new_addr] = array[i];
 		}
 
 		shift += RADIX_BASE;
@@ -1403,7 +1393,7 @@ static void radix_sort(struct bucket_item *array, struct bucket_item *array_buf,
 			addr = get4bits(buf_num, shift);
 			counters[addr]--;
 			new_addr = counters[addr];
-			copy_cell(array, new_addr, array_buf, i);
+			array[new_addr] = array_buf[i];
 		}
 
 		shift += RADIX_BASE;
@@ -1437,8 +1427,7 @@ static int byte_core_set_size(struct heuristic_ws *ws)
 	struct bucket_item *bucket = ws->bucket;
 
 	/* Sort in reverse order */
-	radix_sort(ws->bucket, ws->bucket_b, BUCKET_SIZE, copy_cell,
-			get4bits);
+	radix_sort(ws->bucket, ws->bucket_b, BUCKET_SIZE, get4bits);
 
 	for (i = 0; i < BYTE_CORE_SET_LOW; i++)
 		coreset_sum += bucket[i].count;
-- 
2.15.1

