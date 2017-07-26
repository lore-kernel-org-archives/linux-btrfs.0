Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:38317 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdGZMuK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 08:50:10 -0400
Received: by mail-lf0-f67.google.com with SMTP id y15so6931317lfd.5
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 05:50:09 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2 1/3] Btrfs: heuristic add simple sampling logic
Date: Wed, 26 Jul 2017 15:49:56 +0300
Message-Id: <20170726124958.18837-2-nefelim4ag@gmail.com>
In-Reply-To: <20170726124958.18837-1-nefelim4ag@gmail.com>
References: <20170726124958.18837-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Get small sample from input data and calculate
byte type count for that sample into bucket.
Bucket will store info about which bytes
and how many has been detected in sample

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 24 ++++++++++++++++++++++--
 fs/btrfs/compression.h | 10 ++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 63f54bd2d5bb..ca7cfaad6e2f 100644
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
+			a += BTRFS_HEURISTIC_ITER_OFFSET;
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
index d1f4eee2d0af..e30a9df1937e 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -129,6 +129,16 @@ struct btrfs_compress_op {
 extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;

+struct heuristic_bucket_item {
+       u8  padding;
+       u8  symbol;
+       u16 count;
+};
+
+#define BTRFS_HEURISTIC_READ_SIZE 16
+#define BTRFS_HEURISTIC_ITER_OFFSET 256
+#define BTRFS_HEURISTIC_BUCKET_SIZE 256
+
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);

 #endif
--
2.13.3
