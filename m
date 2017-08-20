Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35672 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753328AbdHTSL1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 14:11:27 -0400
Received: by mail-wr0-f196.google.com with SMTP id p8so11484040wrf.2
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Aug 2017 11:11:27 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v4 1/3] Btrfs: heuristic add simple sampling logic
Date: Sun, 20 Aug 2017 21:11:14 +0300
Message-Id: <20170820181116.5131-2-nefelim4ag@gmail.com>
In-Reply-To: <20170820181116.5131-1-nefelim4ag@gmail.com>
References: <20170820181116.5131-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Get small sample from input data and calculate
byte type count for that sample into bucket.
Bucket will store info about which bytes
and how many has been detected in sample

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 24 ++++++++++++++++++++++--
 fs/btrfs/compression.h |  8 ++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 883ecc58fd0d..c078c8d8c034 100644
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
index 3b1b0ac15fdc..e0421705b80b 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -128,6 +128,14 @@ struct btrfs_compress_op {
 extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;

+struct heuristic_bucket_item {
+	u32 count;
+};
+
+#define BTRFS_HEURISTIC_READ_SIZE 16
+#define BTRFS_HEURISTIC_ITER_OFFSET 256
+#define BTRFS_HEURISTIC_BUCKET_SIZE 256
+
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);

 #endif
--
2.14.1
