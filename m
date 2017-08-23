Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34239 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbdHWWqA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 18:46:00 -0400
Received: by mail-wr0-f195.google.com with SMTP id f6so529798wra.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 15:45:59 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v6 3/6] Btrfs: implement heuristic sampling logic
Date: Thu, 24 Aug 2017 01:45:42 +0300
Message-Id: <20170823224545.16375-4-nefelim4ag@gmail.com>
In-Reply-To: <20170823224545.16375-1-nefelim4ag@gmail.com>
References: <20170823224545.16375-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copy sample data from input data range to sample buffer
then calculate byte type count for that sample into bucket.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index 9a212674f527..001118f98143 100644
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
+	 */
+	if (end - start > BTRFS_MAX_UNCOMPRESSED)
+		end = start + BTRFS_MAX_UNCOMPRESSED;

 	index = start >> PAGE_SHIFT;
 	index_end = end >> PAGE_SHIFT;
@@ -82,13 +94,37 @@ static int heuristic(struct list_head *ws, struct inode *inode,
 	if(end%PAGE_SIZE == 0)
 		index_end--;

+	b = 0;
 	for (; index <= index_end; index++) {
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
