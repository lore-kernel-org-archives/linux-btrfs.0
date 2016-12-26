Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2344 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752754AbcLZGaN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 01:30:13 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 0CF3341B4BE6
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 14:29:45 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 14/19] btrfs-progs: scrub: Introduce function to verify parities
Date: Mon, 26 Dec 2016 14:29:34 +0800
Message-Id: <20161226062939.5841-15-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, verify_parities(), to check if parities matches
for full stripe which all data stripes matches with their csum.

Caller should fill the scrub_full_stripe structure properly before
calling this function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 scrub.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/scrub.c b/scrub.c
index 15a1955c..238feb3c 100644
--- a/scrub.c
+++ b/scrub.c
@@ -25,6 +25,7 @@
 #include "volumes.h"
 #include "disk-io.h"
 #include "utils.h"
+#include "kernel-lib/raid56.h"
 
 /*
  * For parity based profile(RAID56)
@@ -480,3 +481,71 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+/*
+ * Verify parities for RAID56
+ * Caller must fill @fstripe before calling this function
+ *
+ * Return 0 for parities matches.
+ * Return >0 for P or Q mismatch
+ * Return <0 for fatal error
+ */
+static int verify_parities(struct btrfs_fs_info *fs_info,
+			   struct btrfs_scrub_progress *scrub_ctx,
+			   struct scrub_full_stripe *fstripe)
+{
+	void **ptrs;
+	void *ondisk_p = NULL;
+	void *ondisk_q = NULL;
+	void *buf_p;
+	void *buf_q;
+	int nr_stripes = fstripe->nr_stripes;
+	int stripe_len = BTRFS_STRIPE_LEN;
+	int i;
+	int ret = 0;
+
+	ptrs = malloc(sizeof(void *) * fstripe->nr_stripes);
+	buf_p = malloc(fstripe->stripe_len);
+	buf_q = malloc(fstripe->stripe_len);
+	if (!ptrs || !buf_p || !buf_q) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < fstripe->nr_stripes; i++) {
+		struct scrub_stripe *stripe = &fstripe->stripes[i];
+
+		if (stripe->logical == BTRFS_RAID5_P_STRIPE) {
+			ondisk_p = stripe->data;
+			ptrs[i] = buf_p;
+			continue;
+		} else if (stripe->logical == BTRFS_RAID6_Q_STRIPE) {
+			ondisk_q = stripe->data;
+			ptrs[i] = buf_q;
+			continue;
+		} else {
+			ptrs[i] = stripe->data;
+			continue;
+		}
+	}
+	/* RAID6 */
+	if (ondisk_q) {
+		raid6_gen_syndrome(nr_stripes, stripe_len, ptrs);
+
+		if (memcmp(ondisk_q, ptrs[nr_stripes - 1], stripe_len) != 0 ||
+		    memcmp(ondisk_p, ptrs[nr_stripes - 2], stripe_len))
+			ret = 1;
+	} else {
+		ret = raid5_gen_result(nr_stripes, stripe_len, nr_stripes - 1,
+					ptrs);
+		if (ret < 0)
+			goto out;
+		if (memcmp(ondisk_p, ptrs[nr_stripes - 1], stripe_len) != 0)
+			ret = 1;
+	}
+out:
+	free(buf_p);
+	free(buf_q);
+	free(ptrs);
+	return ret;
+}
-- 
2.11.0



