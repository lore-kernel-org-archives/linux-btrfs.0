Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34102 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752770AbdHWA1J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 20:27:09 -0400
Received: by mail-wr0-f193.google.com with SMTP id p14so152865wrg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 17:27:09 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v5 2/6] Btrfs: heuristic workspace add bucket and sample items
Date: Wed, 23 Aug 2017 03:26:46 +0300
Message-Id: <20170823002650.3133-3-nefelim4ag@gmail.com>
In-Reply-To: <20170823002650.3133-1-nefelim4ag@gmail.com>
References: <20170823002650.3133-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Heuristic workspace:
 - Add bucket for storing byte type counters
 - Add sample array for storing partial copy of
   input data range
 - Add counter for store current sample size to workspace

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index 96ae3e9334bc..2c2cadc9dfad 100644
--- a/fs/btrfs/heuristic.c
+++ b/fs/btrfs/heuristic.c
@@ -20,13 +20,36 @@
 #include <linux/bio.h>
 #include "compression.h"

+#define READ_SIZE 16
+#define ITER_SHIFT 256
+#define BUCKET_SIZE 256
+
+/*
+ * While mapping 128KiB range into pages (with 4k PAGE_SIZE as ex),
+ * and iterate that with index <= index_end
+ * code get 0-32 items, that a 33 pages
+ */
+#define MAX_INPUT_PAGES ((BTRFS_MAX_UNCOMPRESSED >> PAGE_SHIFT)+1)
+#define MAX_SAMPLE_SIZE (MAX_INPUT_PAGES*PAGE_SIZE*READ_SIZE/ITER_SHIFT)
+
+struct bucket_item {
+	u32 count;
+};
+
 struct workspace {
+	u8  *sample;
+	/* Partial copy of input data */
+	u32 sample_size;
+	/* Bucket store counter for each byte type */
+	struct bucket_item bucket[BUCKET_SIZE];
 	struct list_head list;
 };

 static void heuristic_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
+
+	kvfree(workspace->sample);
 	kfree(workspace);
 }

@@ -38,9 +61,16 @@ static struct list_head *heuristic_alloc_workspace(void)
 	if (!workspace)
 		return ERR_PTR(-ENOMEM);

+	workspace->sample = kvmalloc(MAX_SAMPLE_SIZE, GFP_KERNEL);
+	if (!workspace->sample)
+		goto fail;
+
 	INIT_LIST_HEAD(&workspace->list);

 	return &workspace->list;
+fail:
+	heuristic_free_workspace(&workspace->list);
+	return ERR_PTR(-ENOMEM);
 }

 static int heuristic(struct list_head *ws, struct inode *inode,
--
2.14.1
