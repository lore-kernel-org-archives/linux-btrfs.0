Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34498 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbdGZMuN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 08:50:13 -0400
Received: by mail-lf0-f65.google.com with SMTP id d80so4955927lfg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 05:50:12 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2 3/3] Btrfs: heuristic add byte core set calculation
Date: Wed, 26 Jul 2017 15:49:58 +0300
Message-Id: <20170726124958.18837-4-nefelim4ag@gmail.com>
In-Reply-To: <20170726124958.18837-1-nefelim4ag@gmail.com>
References: <20170726124958.18837-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Calculate byte core set for data sample:
Sort bucket's numbers in decreasing order
Count how many numbers use 90% of sample
If core set are low (<=25%), data are easily compressible
If core set high (>=80%), data are not compressible

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/compression.h |  2 ++
 2 files changed, 59 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1429b11f2c5f..314cbdd8d175 100644
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

@@ -1123,6 +1161,25 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 		goto out;
 	}

+	/* Sort in reverse order */
+	sort(bucket, BTRFS_HEURISTIC_BUCKET_SIZE,
+	     sizeof(struct heuristic_bucket_item), &heuristic_bucket_compare,
+	     NULL);
+
+	core_set_threshold = input_size*90/BTRFS_HEURISTIC_ITER_OFFSET/100;
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
index 03857967815a..0fcd1a485adb 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -139,6 +139,8 @@ struct heuristic_bucket_item {
 #define BTRFS_HEURISTIC_ITER_OFFSET 256
 #define BTRFS_HEURISTIC_BUCKET_SIZE 256
 #define BTRFS_HEURISTIC_BYTE_SET_THRESHOLD 64
+#define BTRFS_HEURISTIC_BYTE_CORE_SET_LOW  BTRFS_HEURISTIC_BYTE_SET_THRESHOLD
+#define BTRFS_HEURISTIC_BYTE_CORE_SET_HIGH 200 // 80%

 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);

--
2.13.3
