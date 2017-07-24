Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33871 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdGXLhW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 07:37:22 -0400
Received: by mail-lf0-f67.google.com with SMTP id d80so1336490lfg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 04:37:21 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 3/3] Btrfs: heuristic add byte core set calculation
Date: Mon, 24 Jul 2017 14:37:08 +0300
Message-Id: <20170724113708.18088-4-nefelim4ag@gmail.com>
In-Reply-To: <20170724113708.18088-1-nefelim4ag@gmail.com>
References: <20170724113708.18088-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Calculate byte core set for data sample
For low core set, data are easily compressible
For high core set, data are not compressible

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/compression.h |  2 ++
 2 files changed, 62 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index fee7808e3f15..e7f811d20fd8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1069,6 +1069,42 @@ static inline int byte_set_size(const struct heuristic_bucket_item *bucket)
 	return byte_set_size;
 }
 
+/* For bucket sorting */
+static inline int heuristic_bucket_compare(const void *lv, const void *rv)
+{
+	struct heuristic_bucket_item *l = (struct heuristic_bucket_item *)(lv);
+	struct heuristic_bucket_item *r = (struct heuristic_bucket_item *)(rv);
+
+	return r->count - l->count;
+}
+
+/*
+ * Byte Core set size
+ * How many bytes use 90% of sample
+ */
+static inline int byte_core_set_size(struct heuristic_bucket_item *bucket,
+				     u32 core_set_threshold)
+{
+	int a = 0;
+	u32 coreset_sum = 0;
+
+	for (; a < BTRFS_HEURISTIC_BYTE_CORE_SET_LOW; a++)
+		coreset_sum += bucket[a].count;
+
+	if (coreset_sum > core_set_threshold)
+		return a;
+
+	for (; a < BTRFS_HEURISTIC_BYTE_CORE_SET_HIGH; a++) {
+		if (bucket[a].count == 0)
+			break;
+		coreset_sum += bucket[a].count;
+		if (coreset_sum > core_set_threshold)
+			break;
+	}
+
+	return a;
+}
+
 /*
  * Compression heuristic.
  *
@@ -1092,6 +1128,8 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	struct heuristic_bucket_item *bucket;
 	int a, b, ret;
 	u8 symbol, *input_data;
+	u32 core_set_threshold;
+	u64 input_size = start - end;
 
 	ret = 1;
 
@@ -1123,6 +1161,28 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 		goto out;
 	}
 
+	for (a = 1; a <  BTRFS_HEURISTIC_BUCKET_SIZE; a++)
+		bucket[a].symbol = a;
+
+	/* Sort in reverse order */
+	sort(bucket, BTRFS_HEURISTIC_BUCKET_SIZE,
+	     sizeof(struct heuristic_bucket_item), &heuristic_bucket_compare,
+	     NULL);
+
+	core_set_threshold = input_size*90/BTRFS_HEURISTIC_ITERATOR_OFFSET/100;
+	core_set_threshold *= BTRFS_HEURISTIC_READ_SIZE;
+
+	a = byte_core_set_size(bucket, core_set_threshold);
+	if (a <= BTRFS_HEURISTIC_BYTE_CORE_SET_LOW) {
+		ret = 2;
+		goto out;
+	}
+
+	if (a >= BTRFS_HEURISTIC_BYTE_CORE_SET_HIGH) {
+		ret = 0;
+		goto out;
+	}
+
 out:
 	kfree(bucket);
 	return ret;
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 6e5b2ce36b52..f323f464bb13 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -140,6 +140,8 @@ struct heuristic_bucket_item {
 #define BTRFS_HEURISTIC_ITERATOR_OFFSET PAGE_SIZE/BTRFS_HEURISTIC_READS_PER_PAGE
 #define BTRFS_HEURISTIC_BUCKET_SIZE 256
 #define BTRFS_HEURISTIC_BYTE_SET_THRESHOLD (256/4)
+#define BTRFS_HEURISTIC_BYTE_CORE_SET_LOW  (256/5)
+#define BTRFS_HEURISTIC_BYTE_CORE_SET_HIGH (256 - 256/5)
 
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
 
-- 
2.13.3

