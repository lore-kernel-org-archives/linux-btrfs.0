Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35132 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753335AbdI1Odz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 10:33:55 -0400
Received: by mail-wr0-f194.google.com with SMTP id n64so2244532wrb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:33:55 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v8 6/6] Btrfs: heuristic add byte core set calculation
Date: Thu, 28 Sep 2017 17:33:41 +0300
Message-Id: <20170928143341.24491-7-nefelim4ag@gmail.com>
In-Reply-To: <20170928143341.24491-1-nefelim4ag@gmail.com>
References: <20170928143341.24491-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Calculate byte core set for data sample:
Sort bucket's numbers in decreasing order
Count how many numbers use 90% of sample
If core set are low (<=25%), data are easily compressible
If core set high (>=80%), data are not compressible

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 83daf2f9d051..1aa04ae214a7 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -33,6 +33,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
+#include <linux/sort.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -1201,6 +1202,62 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 }


+/* Compare buckets by size, ascending */
+static inline int bucket_comp_rev(const void *lv, const void *rv)
+{
+	const struct bucket_item *l = (struct bucket_item *)(lv);
+	const struct bucket_item *r = (struct bucket_item *)(rv);
+
+	return r->count - l->count;
+}
+
+/*
+ * Byte Core set size
+ * How many bytes use 90% of sample
+ *
+ * Several type of structure d binary data have in general
+ * nearly all types of bytes, but distribution can be Uniform
+ * where in bucket all byte types will have the nearly same count
+ * (ex. Encrypted data)
+ * and as ex. Normal (Gaussian), where count of bytes will be not so linear
+ * in that case data can be compressible, probably compressible, and
+ * not compressible, so assume:
+ *
+ * @BYTE_CORE_SET_LOW - main part of byte types repeated frequently
+ *                      compression algo can easy fix that
+ * @BYTE_CORE_SET_HIGH - data have Uniform distribution and with high
+ *                       probability not compressible
+ *
+ */
+
+#define BYTE_CORE_SET_LOW  64
+#define BYTE_CORE_SET_HIGH 200
+
+static int byte_core_set_size(struct heuristic_ws *ws)
+{
+	u32 i;
+	u32 coreset_sum = 0;
+	u32 core_set_threshold = ws->sample_size * 90 / 100;
+	struct bucket_item *bucket = ws->bucket;
+
+	/* Sort in reverse order */
+	sort(bucket, BUCKET_SIZE, sizeof(*bucket), &bucket_comp_rev, NULL);
+
+	for (i = 0; i < BYTE_CORE_SET_LOW; i++)
+		coreset_sum += bucket[i].count;
+
+	if (coreset_sum > core_set_threshold)
+		return i;
+
+	for (; i < BYTE_CORE_SET_HIGH && bucket[i].count > 0; i++) {
+		coreset_sum += bucket[i].count;
+		if (coreset_sum > core_set_threshold)
+			break;
+	}
+
+	return i;
+}
+
 /*
  * Count byte types in bucket
  * That heuristic can detect text like data (configs, xml, json, html & etc)
@@ -1348,6 +1405,17 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 		goto out;
 	}

+	i = byte_core_set_size(ws);
+	if (i <= BYTE_CORE_SET_LOW) {
+		ret = 3;
+		goto out;
+	}
+
+	if (i >= BYTE_CORE_SET_HIGH) {
+		ret = 0;
+		goto out;
+	}
+
 out:
 	__free_workspace(0, ws_list, true);
 	return ret;
--
2.14.2
