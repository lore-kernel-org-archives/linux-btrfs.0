Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33798 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754565AbdHYJTP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 05:19:15 -0400
Received: by mail-wm0-f68.google.com with SMTP id i76so1965046wme.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 02:19:14 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v7 5/6] Btrfs: heuristic add byte set calculation
Date: Fri, 25 Aug 2017 12:18:44 +0300
Message-Id: <20170825091845.4120-6-nefelim4ag@gmail.com>
In-Reply-To: <20170825091845.4120-1-nefelim4ag@gmail.com>
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Calculate byte set size for data sample:
Calculate how many unique bytes has been in sample
By count all bytes in bucket with count > 0
If byte set low (~25%), data are easily compressible

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index f1fa6e4f1c11..ef723e991576 100644
--- a/fs/btrfs/heuristic.c
+++ b/fs/btrfs/heuristic.c
@@ -24,6 +24,7 @@
 #define ITER_SHIFT 256
 #define BUCKET_SIZE 256
 #define MAX_SAMPLE_SIZE (BTRFS_MAX_UNCOMPRESSED*READ_SIZE/ITER_SHIFT)
+#define BYTE_SET_THRESHOLD 64

 struct bucket_item {
 	u32 count;
@@ -66,6 +67,27 @@ static struct list_head *heuristic_alloc_workspace(void)
 	return ERR_PTR(-ENOMEM);
 }

+static u32 byte_set_size(const struct workspace *ws)
+{
+	u32 a = 0;
+	u32 byte_set_size = 0;
+
+	for (; a < BYTE_SET_THRESHOLD; a++) {
+		if (ws->bucket[a].count > 0)
+			byte_set_size++;
+	}
+
+	for (; a < BUCKET_SIZE; a++) {
+		if (ws->bucket[a].count > 0) {
+			byte_set_size++;
+			if (byte_set_size > BYTE_SET_THRESHOLD)
+				return byte_set_size;
+		}
+	}
+
+	return byte_set_size;
+}
+
 static bool sample_repeated_patterns(struct workspace *ws)
 {
 	u32 i = 0;
@@ -138,6 +160,10 @@ static int heuristic(struct list_head *ws, struct inode *inode,
 		workspace->bucket[byte].count++;
 	}

+	a = byte_set_size(workspace);
+	if (a > BYTE_SET_THRESHOLD)
+		return 2;
+
 	return 1;
 }

--
2.14.1
