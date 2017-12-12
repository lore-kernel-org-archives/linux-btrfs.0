Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33695 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752303AbdLLU5f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 15:57:35 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: nefelim4ag@gmail.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: heuristic: call get4bits directly
Date: Tue, 12 Dec 2017 21:55:34 +0100
Message-Id: <fe07839584f2925246cfd6674049b0606ff7716a.1513111931.git.dsterba@suse.com>
In-Reply-To: <cover.1513111931.git.dsterba@suse.com>
References: <cover.1513111931.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As it's a single instance and local to the file, we don't need to pass
it as an argument.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 935acabc0ea7..208334aa6c6e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1319,11 +1319,9 @@ static u8 get4bits(u64 num, int shift) {
  * @array_buf - buffer array to store sorting results
  *              must be equal in size to @array
  * @num       - array size
- * @get4bits  - function to get 4 bits from number at specified offset
  */
 static void radix_sort(struct bucket_item *array, struct bucket_item *array_buf,
-		       int num,
-		       u8 (*get4bits)(u64 num, int shift))
+		       int num)
 {
 	u64 max_num;
 	u64 buf_num;
@@ -1427,7 +1425,7 @@ static int byte_core_set_size(struct heuristic_ws *ws)
 	struct bucket_item *bucket = ws->bucket;
 
 	/* Sort in reverse order */
-	radix_sort(ws->bucket, ws->bucket_b, BUCKET_SIZE, get4bits);
+	radix_sort(ws->bucket, ws->bucket_b, BUCKET_SIZE);
 
 	for (i = 0; i < BYTE_CORE_SET_LOW; i++)
 		coreset_sum += bucket[i].count;
-- 
2.15.1

