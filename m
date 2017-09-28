Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35125 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753344AbdI1Odz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 10:33:55 -0400
Received: by mail-wr0-f193.google.com with SMTP id n64so2244480wrb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:33:54 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v8 5/6] Btrfs: heuristic add byte set calculation
Date: Thu, 28 Sep 2017 17:33:40 +0300
Message-Id: <20170928143341.24491-6-nefelim4ag@gmail.com>
In-Reply-To: <20170928143341.24491-1-nefelim4ag@gmail.com>
References: <20170928143341.24491-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Calculate byte set size for data sample:
Calculate how many unique bytes has been in sample
By count all bytes in bucket with count > 0
If byte set low (~25%), data are easily compressible
Otherwise need additional analize

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1cb4df023d5e..83daf2f9d051 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1201,6 +1201,48 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 }


+/*
+ * Count byte types in bucket
+ * That heuristic can detect text like data (configs, xml, json, html & etc)
+ * Because in most text like data byte set are restricted to limit number
+ * of possible characters, and that restriction in most cases
+ * make data easy compressible.
+ *
+ * @BYTE_SET_THRESHOLD - assume that all data with that byte set size:
+ *	less - compressible
+ *	more - need additional analize
+ */
+
+#define BYTE_SET_THRESHOLD 64
+
+static u32 byte_set_size(const struct heuristic_ws *ws)
+{
+	u32 i;
+	u32 byte_set_size = 0;
+
+	for (i = 0; i < BYTE_SET_THRESHOLD; i++) {
+		if (ws->bucket[i].count > 0)
+			byte_set_size++;
+	}
+
+	/*
+	 * Continue collecting count of byte types in bucket
+	 * If byte set size bigger then threshold
+	 * That useless to continue, because for that data type
+	 * detection technique fail
+	 */
+	for (; i < BUCKET_SIZE; i++) {
+		if (ws->bucket[i].count > 0) {
+			byte_set_size++;
+			if (byte_set_size > BYTE_SET_THRESHOLD)
+				return byte_set_size;
+		}
+	}
+
+	return byte_set_size;
+}
+
+
 static bool sample_repeated_patterns(struct heuristic_ws *ws)
 {
 	u32 half_of_sample = ws->sample_size / 2;
@@ -1300,6 +1342,12 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 		ws->bucket[byte].count++;
 	}

+	i = byte_set_size(ws);
+	if (i < BYTE_SET_THRESHOLD) {
+		ret = 2;
+		goto out;
+	}
+
 out:
 	__free_workspace(0, ws_list, true);
 	return ret;
--
2.14.2
