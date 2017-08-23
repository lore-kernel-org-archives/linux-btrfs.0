Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35205 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752766AbdHWA1K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 20:27:10 -0400
Received: by mail-wr0-f193.google.com with SMTP id p8so148818wrf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 17:27:10 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v5 3/6] Btrfs: implement heuristic sampling logic
Date: Wed, 23 Aug 2017 03:26:47 +0300
Message-Id: <20170823002650.3133-4-nefelim4ag@gmail.com>
In-Reply-To: <20170823002650.3133-1-nefelim4ag@gmail.com>
References: <20170823002650.3133-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copy sample data from input data range to sample buffer
then calculate byte type count for that sample into bucket.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index 2c2cadc9dfad..5336638a3b7c 100644
--- a/fs/btrfs/heuristic.c
+++ b/fs/btrfs/heuristic.c
@@ -76,20 +76,47 @@ static struct list_head *heuristic_alloc_workspace(void)
 static int heuristic(struct list_head *ws, struct inode *inode,
 		     u64 start, u64 end)
 {
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	struct page *page;
 	u64 index, index_end;
-	u8 *input_data;
+	u8 *in_data;
+	u32 a, b;
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

+	b = 0;
 	for (; index <= index_end; index++) {
 		page = find_get_page(inode->i_mapping, index);
-		input_data = kmap(page);
+		in_data = kmap(page);
+		a = 0;
+		while (a < PAGE_SIZE-READ_SIZE && b < MAX_SAMPLE_SIZE) {
+			memcpy(&workspace->sample[b], &in_data[a], READ_SIZE);
+			a += ITER_SHIFT;
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
+		byte = workspace->sample[a];
+		workspace->bucket[byte].count++;
+	}
+
 	return 1;
 }

--
2.14.1
