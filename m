Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38539 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754834AbdHYJTM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 05:19:12 -0400
Received: by mail-wm0-f68.google.com with SMTP id z132so1937374wmg.5
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 02:19:12 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v7 3/6] Btrfs: implement heuristic sampling logic
Date: Fri, 25 Aug 2017 12:18:42 +0300
Message-Id: <20170825091845.4120-4-nefelim4ag@gmail.com>
In-Reply-To: <20170825091845.4120-1-nefelim4ag@gmail.com>
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copy sample data from input data range to sample buffer
then calculate byte type count for that sample into bucket.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index e3924c87af08..5192e51ab81e 100644
--- a/fs/btrfs/heuristic.c
+++ b/fs/btrfs/heuristic.c
@@ -69,8 +69,20 @@ static struct list_head *heuristic_alloc_workspace(void)
 static int heuristic(struct list_head *ws, struct inode *inode,
 		     u64 start, u64 end)
 {
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	struct page *page;
 	u64 index, index_end;
+	u32 a, b;
+	u8 *in_data, *sample = workspace->sample;
+	u8 byte;
+
+	/*
+	 * Compression only handle first 128kb of input range
+	 * And just shift over range in loop for compressing it.
+	 * Let's do the same.
+	*/
+	if (end - start > BTRFS_MAX_UNCOMPRESSED)
+		end = start + BTRFS_MAX_UNCOMPRESSED;

 	index = start >> PAGE_SHIFT;
 	index_end = end >> PAGE_SHIFT;
@@ -79,13 +91,37 @@ static int heuristic(struct list_head *ws, struct inode *inode,
 	if (!IS_ALIGNED(end, PAGE_SIZE))
 		index_end++;

+	b = 0;
 	for (; index < index_end; index++) {
 		page = find_get_page(inode->i_mapping, index);
-		kmap(page);
+		in_data = kmap(page);
+		/* Handle case where start unaligned to PAGE_SIZE */
+		a = start%PAGE_SIZE;
+		while (a < PAGE_SIZE - READ_SIZE) {
+			/* Prevent sample overflow */
+			if (b >= MAX_SAMPLE_SIZE)
+				break;
+			/* Don't sample mem trash from last page */
+			if (start > end - READ_SIZE)
+				break;
+			memcpy(&sample[b], &in_data[a], READ_SIZE);
+			a += ITER_SHIFT;
+			start += ITER_SHIFT;
+			b += READ_SIZE;
+		}
 		kunmap(page);
 		put_page(page);
 	}

+	workspace->sample_size = b;
+
+	memset(workspace->bucket, 0, sizeof(*workspace->bucket)*BUCKET_SIZE);
+
+	for (a = 0; a < workspace->sample_size; a++) {
+		byte = sample[a];
+		workspace->bucket[byte].count++;
+	}
+
 	return 1;
 }

--
2.14.1
