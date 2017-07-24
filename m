Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36777 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753226AbdGXLhU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 07:37:20 -0400
Received: by mail-lf0-f68.google.com with SMTP id t128so2721305lff.3
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 04:37:20 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 2/3] Btrfs: heuristic add byte set calculation
Date: Mon, 24 Jul 2017 14:37:07 +0300
Message-Id: <20170724113708.18088-3-nefelim4ag@gmail.com>
In-Reply-To: <20170724113708.18088-1-nefelim4ag@gmail.com>
References: <20170724113708.18088-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Calculate byte set size for data sample
if byte set low, data are easily compressible

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 27 +++++++++++++++++++++++++++
 fs/btrfs/compression.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1501d4fe90cc..fee7808e3f15 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1048,6 +1048,27 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 	return 1;
 }
 
+static inline int byte_set_size(const struct heuristic_bucket_item *bucket)
+{
+	int a = 0;
+	int byte_set_size = 0;
+
+	for (; a < BTRFS_HEURISTIC_BYTE_SET_THRESHOLD; a++) {
+		if (bucket[a].count > 0)
+			byte_set_size++;
+	}
+
+	for (; a < BTRFS_HEURISTIC_BUCKET_SIZE; a++) {
+		if (bucket[a].count > 0) {
+			byte_set_size++;
+			if (byte_set_size > BTRFS_HEURISTIC_BYTE_SET_THRESHOLD)
+				return byte_set_size;
+		}
+	}
+
+	return byte_set_size;
+}
+
 /*
  * Compression heuristic.
  *
@@ -1096,6 +1117,12 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 		index++;
 	}
 
+	a = byte_set_size(bucket);
+	if (a > BTRFS_HEURISTIC_BYTE_SET_THRESHOLD) {
+		ret = 1;
+		goto out;
+	}
+
 out:
 	kfree(bucket);
 	return ret;
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 984943e5e1ae..6e5b2ce36b52 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -139,6 +139,7 @@ struct heuristic_bucket_item {
 #define BTRFS_HEURISTIC_READS_PER_PAGE 8*PAGE_SIZE/4096
 #define BTRFS_HEURISTIC_ITERATOR_OFFSET PAGE_SIZE/BTRFS_HEURISTIC_READS_PER_PAGE
 #define BTRFS_HEURISTIC_BUCKET_SIZE 256
+#define BTRFS_HEURISTIC_BYTE_SET_THRESHOLD (256/4)
 
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
 
-- 
2.13.3

