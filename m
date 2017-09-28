Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38297 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753336AbdI1Odx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 10:33:53 -0400
Received: by mail-wr0-f196.google.com with SMTP id p37so2234019wrb.5
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:33:53 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v8 3/6] Btrfs: implement heuristic sampling logic
Date: Thu, 28 Sep 2017 17:33:38 +0300
Message-Id: <20170928143341.24491-4-nefelim4ag@gmail.com>
In-Reply-To: <20170928143341.24491-1-nefelim4ag@gmail.com>
References: <20170928143341.24491-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copy sample data from input data range to sample buffer
then calculate byte type count for that sample into bucket.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 71 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1715655d050e..e2419639ae7f 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -725,7 +725,6 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 #define MAX_SAMPLE_SIZE (BTRFS_MAX_UNCOMPRESSED * \
 			  SAMPLING_READ_SIZE / SAMPLING_INTERVAL)

-
 struct bucket_item {
 	u32 count;
 };
@@ -733,6 +732,7 @@ struct bucket_item {
 struct heuristic_ws {
 	/* Partial copy of input data */
 	u8 *sample;
+	u32 sample_size;
 	/* Bucket store counter for each byte type */
 	struct bucket_item *bucket;
 	struct list_head list;
@@ -1200,6 +1200,57 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 	return 1;
 }

+static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
+				     struct heuristic_ws *ws)
+{
+	struct page *page;
+	u64 index, index_end;
+	u32 i, curr_sample_pos;
+	u8 *in_data;
+
+	/*
+	 * Compression only handle first 128kb of input range
+	 * And just shift over range in loop for compressing it.
+	 * Let's do the same.
+	 *
+	 * MAX_SAMPLE_SIZE - calculated in assume that heuristic will process
+	 * not more then BTRFS_MAX_UNCOMPRESSED at run
+	 */
+	if (end - start > BTRFS_MAX_UNCOMPRESSED)
+		end = start + BTRFS_MAX_UNCOMPRESSED;
+
+	index = start >> PAGE_SHIFT;
+	index_end = end >> PAGE_SHIFT;
+
+	/* Don't miss unaligned end */
+	if (!IS_ALIGNED(end, PAGE_SIZE))
+		index_end++;
+
+	curr_sample_pos = 0;
+	while (index < index_end) {
+		page = find_get_page(inode->i_mapping, index);
+		in_data = kmap(page);
+		/* Handle case where start unaligned to PAGE_SIZE */
+		i = start % PAGE_SIZE;
+		while (i < PAGE_SIZE - SAMPLING_READ_SIZE) {
+			/* Don't sample mem trash from last page */
+			if (start > end - SAMPLING_READ_SIZE)
+				break;
+			memcpy(&ws->sample[curr_sample_pos],
+			       &in_data[i], SAMPLING_READ_SIZE);
+			i += SAMPLING_INTERVAL;
+			start += SAMPLING_INTERVAL;
+			curr_sample_pos += SAMPLING_READ_SIZE;
+		}
+		kunmap(page);
+		put_page(page);
+
+		index++;
+	}
+
+	ws->sample_size = curr_sample_pos;
+}
+
 /*
  * Compression heuristic.
  *
@@ -1219,19 +1270,19 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
 	struct list_head *ws_list = __find_workspace(0, true);
 	struct heuristic_ws *ws;
-	u64 index = start >> PAGE_SHIFT;
-	u64 end_index = end >> PAGE_SHIFT;
-	struct page *page;
+	u32 i;
+	u8 byte;
 	int ret = 1;

 	ws = list_entry(ws_list, struct heuristic_ws, list);

-	while (index <= end_index) {
-		page = find_get_page(inode->i_mapping, index);
-		kmap(page);
-		kunmap(page);
-		put_page(page);
-		index++;
+	heuristic_collect_sample(inode, start, end, ws);
+
+	memset(ws->bucket, 0, sizeof(*ws->bucket)*BUCKET_SIZE);
+
+	for (i = 0; i < ws->sample_size; i++) {
+		byte = ws->sample[i];
+		ws->bucket[byte].count++;
 	}

 	__free_workspace(0, ws_list, true);
--
2.14.2
