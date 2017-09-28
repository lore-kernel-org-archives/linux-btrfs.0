Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:46899 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753335AbdI1Odw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 10:33:52 -0400
Received: by mail-wm0-f65.google.com with SMTP id m72so2753575wmc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:33:52 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v8 2/6] Btrfs: heuristic workspace add bucket and sample items, macros
Date: Thu, 28 Sep 2017 17:33:37 +0300
Message-Id: <20170928143341.24491-3-nefelim4ag@gmail.com>
In-Reply-To: <20170928143341.24491-1-nefelim4ag@gmail.com>
References: <20170928143341.24491-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added macros:
 - For future sampling algo
 - For bucket size

Heuristic workspace:
 - Add bucket for storing byte type counters
 - Add sample array for storing partial copy of
   input data range
 - Add counter for store current sample size to workspace

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c3624e8e3919..1715655d050e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -691,7 +691,50 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 }


+/*
+ * Heuristic use systematic sampling to collect data from
+ * input data range, so some constant needed to control algo
+ *
+ * @SAMPLING_READ_SIZE - how many bytes will be copied from on each sample
+ * @SAMPLING_INTERVAL  - period that used to iterate over input data range
+ */
+#define SAMPLING_READ_SIZE 16
+#define SAMPLING_INTERVAL 256
+
+/*
+ * For statistic analize of input data range
+ * consider that data consists from bytes
+ * so this is Galois Field with 256 objects
+ * each object have attribute count, i.e. how many times
+ * that object detected in sample
+ */
+#define BUCKET_SIZE 256
+
+/*
+ * The size of the sample is based on a statistical sampling rule of thumb.
+ * That common to perform sampling tests as long as number of elements in
+ * each cell is at least five.
+ *
+ * Instead of five, for now choose 32 value to obtain more accurate results.
+ * If the data contains the maximum number of symbols, which is 256,
+ * lets obtain a sample size bound of 8192.
+ *
+ * So sample at most 8KB of data per data range: 16 consecutive
+ * bytes from up to 512 locations.
+ */
+#define MAX_SAMPLE_SIZE (BTRFS_MAX_UNCOMPRESSED * \
+			  SAMPLING_READ_SIZE / SAMPLING_INTERVAL)
+
+
+struct bucket_item {
+	u32 count;
+};
+
 struct heuristic_ws {
+	/* Partial copy of input data */
+	u8 *sample;
+	/* Bucket store counter for each byte type */
+	struct bucket_item *bucket;
 	struct list_head list;
 };

@@ -701,6 +744,8 @@ static void free_heuristic_ws(struct list_head *ws)

 	workspace = list_entry(ws, struct heuristic_ws, list);

+	kvfree(workspace->sample);
+	kfree(workspace->bucket);
 	kfree(workspace);
 }

@@ -711,9 +756,19 @@ static struct list_head *alloc_heuristic_ws(void){
 	if (!ws)
 		return ERR_PTR(-ENOMEM);

-	INIT_LIST_HEAD(&ws->list);
+	ws->sample = kvmalloc(MAX_SAMPLE_SIZE, GFP_KERNEL);
+	if (!ws->sample)
+		goto fail;
+
+	ws->bucket = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket), GFP_KERNEL);
+	if (!ws->bucket)
+		goto fail;

+	INIT_LIST_HEAD(&ws->list);
 	return &ws->list;
+fail:
+	free_heuristic_ws(&ws->list);
+	return ERR_PTR(-ENOMEM);
 }

 struct workspaces_list {
--
2.14.2
