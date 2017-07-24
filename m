Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36776 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdGXLhT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 07:37:19 -0400
Received: by mail-lf0-f67.google.com with SMTP id t128so2721299lff.3
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 04:37:19 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 1/3] Btrfs: heuristic add simple sampling logic
Date: Mon, 24 Jul 2017 14:37:06 +0300
Message-Id: <20170724113708.18088-2-nefelim4ag@gmail.com>
In-Reply-To: <20170724113708.18088-1-nefelim4ag@gmail.com>
References: <20170724113708.18088-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Get small sample from input data
and calculate byte type count for that sample

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 24 ++++++++++++++++++++++--
 fs/btrfs/compression.h | 11 +++++++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 63f54bd2d5bb..1501d4fe90cc 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1068,15 +1068,35 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	u64 index = start >> PAGE_SHIFT;
 	u64 end_index = end >> PAGE_SHIFT;
 	struct page *page;
-	int ret = 1;
+	struct heuristic_bucket_item *bucket;
+	int a, b, ret;
+	u8 symbol, *input_data;
+
+	ret = 1;
+
+	bucket = kcalloc(BTRFS_HEURISTIC_BUCKET_SIZE,
+		sizeof(struct heuristic_bucket_item), GFP_NOFS);
+
+	if (!bucket)
+		goto out;
 
 	while (index <= end_index) {
 		page = find_get_page(inode->i_mapping, index);
-		kmap(page);
+		input_data = kmap(page);
+		a = 0;
+		while (a < PAGE_SIZE) {
+			for (b = 0; b < BTRFS_HEURISTIC_READ_SIZE; b++) {
+				symbol = input_data[a+b];
+				bucket[symbol].count++;
+			}
+			a += BTRFS_HEURISTIC_ITERATOR_OFFSET;
+		}
 		kunmap(page);
 		put_page(page);
 		index++;
 	}
 
+out:
+	kfree(bucket);
 	return ret;
 }
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index d1f4eee2d0af..984943e5e1ae 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -129,6 +129,17 @@ struct btrfs_compress_op {
 extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;
 
+struct heuristic_bucket_item {
+       u8  padding;
+       u8  symbol;
+       u16 count;
+};
+
+#define BTRFS_HEURISTIC_READ_SIZE 16
+#define BTRFS_HEURISTIC_READS_PER_PAGE 8*PAGE_SIZE/4096
+#define BTRFS_HEURISTIC_ITERATOR_OFFSET PAGE_SIZE/BTRFS_HEURISTIC_READS_PER_PAGE
+#define BTRFS_HEURISTIC_BUCKET_SIZE 256
+
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
 
 #endif
-- 
2.13.3

