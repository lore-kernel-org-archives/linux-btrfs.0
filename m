Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37373 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753339AbdI1Ody (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 10:33:54 -0400
Received: by mail-wr0-f194.google.com with SMTP id u48so2236406wrf.4
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:33:53 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v8 4/6] Btrfs: heuristic add detection of repeated data patterns
Date: Thu, 28 Sep 2017 17:33:39 +0300
Message-Id: <20170928143341.24491-5-nefelim4ag@gmail.com>
In-Reply-To: <20170928143341.24491-1-nefelim4ag@gmail.com>
References: <20170928143341.24491-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Walk over data sample and use memcmp to detect
repeated data (like zeroed)

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e2419639ae7f..1cb4df023d5e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1200,6 +1200,16 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 	return 1;
 }

+
+static bool sample_repeated_patterns(struct heuristic_ws *ws)
+{
+	u32 half_of_sample = ws->sample_size / 2;
+	u8 *p = ws->sample;
+
+	return !memcmp(&p[0], &p[half_of_sample], half_of_sample);
+}
+
+
 static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 				     struct heuristic_ws *ws)
 {
@@ -1278,6 +1288,11 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)

 	heuristic_collect_sample(inode, start, end, ws);

+	if (sample_repeated_patterns(ws)) {
+		ret = 1;
+		goto out;
+	}
+
 	memset(ws->bucket, 0, sizeof(*ws->bucket)*BUCKET_SIZE);

 	for (i = 0; i < ws->sample_size; i++) {
@@ -1285,7 +1300,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 		ws->bucket[byte].count++;
 	}

+out:
 	__free_workspace(0, ws_list, true);
-
 	return ret;
 }
--
2.14.2
