Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35735 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdJHNMK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2017 09:12:10 -0400
Received: by mail-lf0-f67.google.com with SMTP id a132so817921lfa.2
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Oct 2017 06:12:09 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2] Btrfs: heuristic add shannon entropy calculation
Date: Sun,  8 Oct 2017 16:11:59 +0300
Message-Id: <20171008131159.31239-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Byte distribution check in heuristic will filter edge data
cases and some time fail to classificate input data

Let's fix that by adding Shannon entropy calculation,
that will cover classification of most other data types.

As Shannon entropy need log2 with some precision to work,
let's use ilog2(N) and for increase precision,
by do ilog2(pow(N, 4))

Shannon entropy slightly changed for avoiding signed numbers
and divisions.

Changes:
  v1 -> v2:
    - Replace log2_lshift4 wiht ilog2
    - To compensate accuracy errors of ilog2
      @ENTROPY_LVL_ACEPTABLE 70 -> 65
      @ENTROPY_LVL_HIGH      85 -> 80
    - Drop usage of u64 from shannon calculation

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 0060bc4ae5f2..8efbce5633b5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
 #include <linux/sort.h>
+#include <linux/log2.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -1224,6 +1225,60 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 	return 1;
 }

+/*
+ * Shannon Entropy calculation
+ *
+ * Pure byte distribution analyze fail to determine
+ * compressiability of data. Try calculate entropy to
+ * estimate the average minimum number of bits needed
+ * to encode a sample data.
+ *
+ * For comfort, use return of percentage of needed bit's,
+ * instead of bit's amaount directly.
+ *
+ * @ENTROPY_LVL_ACEPTABLE - below that threshold sample has low byte
+ * entropy and can be compressible with high probability
+ *
+ * @ENTROPY_LVL_HIGH - data are not compressible with high probability,
+ *
+ * Use of ilog2() decrease precision, so to see ~ correct answer
+ * LVL decreased by 5.
+ */
+
+#define ENTROPY_LVL_ACEPTABLE 65
+#define ENTROPY_LVL_HIGH 80
+
+/*
+ * For increase precision in shannon_entropy calculation
+ * Let's do pow(n, M) to save more digits after comma
+ *
+ * Max int bit lengh 64
+ * ilog2(MAX_SAMPLE_SIZE) -> 13
+ * 13*4 = 52 < 64 -> M = 4
+ * So use pow(n, 4)
+ */
+static inline u32 ilog2_w(u64 n)
+{
+	return ilog2(n * n * n * n);
+}
+
+static u32 shannon_entropy(struct heuristic_ws *ws)
+{
+	const u32 entropy_max = 8*ilog2_w(2);
+	u32 entropy_sum = 0;
+	u32 p, p_base, sz_base;
+	u32 i;
+
+	sz_base = ilog2_w(ws->sample_size);
+	for (i = 0; i < BUCKET_SIZE && ws->bucket[i].count > 0; i++) {
+		p = ws->bucket[i].count;
+		p_base = ilog2_w(p);
+		entropy_sum += p * (sz_base - p_base);
+	}
+
+	entropy_sum /= ws->sample_size;
+	return entropy_sum * 100 / entropy_max;
+}

 /* Compare buckets by size, ascending */
 static inline int bucket_comp_rev(const void *lv, const void *rv)
@@ -1404,7 +1459,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	struct heuristic_ws *ws;
 	u32 i;
 	u8 byte;
-	int ret = 1;
+	int ret = 0;

 	ws = list_entry(ws_list, struct heuristic_ws, list);

@@ -1439,6 +1494,32 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 		goto out;
 	}

+	i = shannon_entropy(ws);
+	if (i <= ENTROPY_LVL_ACEPTABLE) {
+		ret = 4;
+		goto out;
+	}
+
+	/*
+	 * At below entropy levels additional
+	 * analysis needed for show green light to compression
+	 * For now just assume that compression at that level are
+	 * not worth for resources, becuase:
+	 * 1. that possible to defrag data later
+	 * 2. Case where that will really show compressible data are rare
+	 *   ex. 150 byte types, every bucket have counter at level ~54
+	 *   Heuristic will be confused, that can happen when data
+	 *   have some internal repeated patterns abbacbbc..
+	 *   that can be detected only by analize sample for byte pairs
+	 */
+	if (i < ENTROPY_LVL_HIGH) {
+		ret = 5;
+		goto out;
+	} else {
+		ret = 0;
+		goto out;
+	}
+
 out:
 	__free_workspace(0, ws_list, true);
 	return ret;
--
2.14.2
