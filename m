Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36280 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753323AbdHTSL2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 14:11:28 -0400
Received: by mail-wr0-f193.google.com with SMTP id f8so9040499wrf.3
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Aug 2017 11:11:28 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v4 2/3] Btrfs: heuristic add byte set calculation
Date: Sun, 20 Aug 2017 21:11:15 +0300
Message-Id: <20170820181116.5131-3-nefelim4ag@gmail.com>
In-Reply-To: <20170820181116.5131-1-nefelim4ag@gmail.com>
References: <20170820181116.5131-1-nefelim4ag@gmail.com>
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
index c078c8d8c034..fe26a44bcc9b 100644
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
index e0421705b80b..07e3d0652e62 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -135,6 +135,7 @@ struct heuristic_bucket_item {
 #define BTRFS_HEURISTIC_READ_SIZE 16
 #define BTRFS_HEURISTIC_ITER_OFFSET 256
 #define BTRFS_HEURISTIC_BUCKET_SIZE 256
+#define BTRFS_HEURISTIC_BYTE_SET_THRESHOLD 64

 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);

--
2.14.1
