Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34768 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753803AbdG2NhI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 09:37:08 -0400
Received: by mail-wm0-f66.google.com with SMTP id x64so6130817wmg.1
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jul 2017 06:37:08 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v3 2/3] Btrfs: heuristic add byte set calculation
Date: Sat, 29 Jul 2017 16:36:54 +0300
Message-Id: <20170729133655.31260-3-nefelim4ag@gmail.com>
In-Reply-To: <20170729133655.31260-1-nefelim4ag@gmail.com>
References: <20170729133655.31260-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Calculate byte set size for data sample:
Calculate how many unique bytes has been in sample
By count all bytes in bucket with count > 0
If byte set low (~25%), data are easily compressible

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 27 +++++++++++++++++++++++++++
 fs/btrfs/compression.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ca7cfaad6e2f..1429b11f2c5f 100644
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
index e30a9df1937e..03857967815a 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -138,6 +138,7 @@ struct heuristic_bucket_item {
 #define BTRFS_HEURISTIC_READ_SIZE 16
 #define BTRFS_HEURISTIC_ITER_OFFSET 256
 #define BTRFS_HEURISTIC_BUCKET_SIZE 256
+#define BTRFS_HEURISTIC_BYTE_SET_THRESHOLD 64

 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);

--
2.13.3
