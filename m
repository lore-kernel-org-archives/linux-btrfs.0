Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33316 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754836AbdHYJTM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 05:19:12 -0400
Received: by mail-wm0-f65.google.com with SMTP id e67so1976258wmd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 02:19:11 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v7 2/6] Btrfs: heuristic workspace add bucket and sample items
Date: Fri, 25 Aug 2017 12:18:41 +0300
Message-Id: <20170825091845.4120-3-nefelim4ag@gmail.com>
In-Reply-To: <20170825091845.4120-1-nefelim4ag@gmail.com>
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Heuristic workspace:
 - Add bucket for storing byte type counters
 - Add sample array for storing partial copy of
   input data range
 - Add counter for store current sample size to workspace

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/heuristic.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
index 92f9335bafd4..e3924c87af08 100644
--- a/fs/btrfs/heuristic.c
+++ b/fs/btrfs/heuristic.c
@@ -20,13 +20,29 @@
 #include <linux/bio.h>
 #include "compression.h"

+#define READ_SIZE 16
+#define ITER_SHIFT 256
+#define BUCKET_SIZE 256
+#define MAX_SAMPLE_SIZE (BTRFS_MAX_UNCOMPRESSED*READ_SIZE/ITER_SHIFT)
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

@@ -38,9 +54,16 @@ static struct list_head *heuristic_alloc_workspace(void)
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
