Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34925 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdGZMuM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 08:50:12 -0400
Received: by mail-lf0-f68.google.com with SMTP id w199so4336239lff.2
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 05:50:11 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2 2/3] Btrfs: heuristic add byte set calculation
Date: Wed, 26 Jul 2017 15:49:57 +0300
Message-Id: <20170726124958.18837-3-nefelim4ag@gmail.com>
In-Reply-To: <20170726124958.18837-1-nefelim4ag@gmail.com>
References: <20170726124958.18837-1-nefelim4ag@gmail.com>
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
