Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58749 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S942187AbcJ1CcY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:32:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 14/19] btrfs-progs: check/scrub: Introduce function to verify parities
Date: Fri, 28 Oct 2016 10:31:50 +0800
Message-Id: <20161028023155.27336-15-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, verify_parities(), to check if parities matches
for full stripe which all data stripes matches with their csum.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/check/scrub.c b/check/scrub.c
index 68a4d6b..7aeda88 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -22,6 +22,7 @@
 #include "disk-io.h"
 #include "utils.h"
 #include "check.h"
+#include "raid56.h"
 
 struct scrub_stripe {
 	/* For P/Q logical start will be BTRFS_RAID5/6_P/Q_STRIPE */
@@ -429,3 +430,68 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+/*
+ * Return 0 for all match
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
2.10.1



