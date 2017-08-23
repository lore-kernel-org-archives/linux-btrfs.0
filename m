Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38002 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752789AbdHWA1N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 20:27:13 -0400
Received: by mail-wm0-f65.google.com with SMTP id y206so678324wmd.5
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 17:27:12 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v5 5/6] Btrfs: heuristic add byte set calculation
Date: Wed, 23 Aug 2017 03:26:49 +0300
Message-Id: <20170823002650.3133-6-nefelim4ag@gmail.com>
In-Reply-To: <20170823002650.3133-1-nefelim4ag@gmail.com>
References: <20170823002650.3133-1-nefelim4ag@gmail.com>
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
index 4557ea1db373..953428fde305 100644
--- a/fs/btrfs/heuristic.c
+++ b/fs/btrfs/heuristic.c
@@ -31,6 +31,7 @@
  */
 #define MAX_INPUT_PAGES ((BTRFS_MAX_UNCOMPRESSED >> PAGE_SHIFT)+1)
 #define MAX_SAMPLE_SIZE (MAX_INPUT_PAGES*PAGE_SIZE*READ_SIZE/ITER_SHIFT)
+#define BYTE_SET_THRESHOLD 64

 struct bucket_item {
 	u32 count;
@@ -73,6 +74,27 @@ static struct list_head *heuristic_alloc_workspace(void)
 	return ERR_PTR(-ENOMEM);
 }

+static int byte_set_size(const struct workspace *workspace)
+{
+	int a = 0;
+	int byte_set_size = 0;
+
+	for (; a < BYTE_SET_THRESHOLD; a++) {
+		if (workspace->bucket[a].count > 0)
+			byte_set_size++;
+	}
+
+	for (; a < BUCKET_SIZE; a++) {
+		if (workspace->bucket[a].count > 0) {
+			byte_set_size++;
+			if (byte_set_size > BYTE_SET_THRESHOLD)
+				return byte_set_size;
+		}
+	}
+
+	return byte_set_size;
+}
+
 static bool sample_zeroed(struct workspace *workspace)
 {
 	u32 i;
@@ -135,6 +157,10 @@ static int heuristic(struct list_head *ws, struct inode *inode,
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
