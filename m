Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3381 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932286AbcJQB2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 21:28:18 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 638CB41B4BC7
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:27:50 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v0.8 09/14] btrfs-progs: check/scrub: Introduce function to verify parities
Date: Mon, 17 Oct 2016 09:27:38 +0800
Message-Id: <20161017012743.9692-10-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
References: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, verify_parities(), to check if parities matches
for full stripe which all data stripes matches with their csum.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/check/scrub.c b/check/scrub.c
index f29effa..d8182d6 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -408,3 +408,62 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
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
+	int ret;
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
+		if (memcmp(ondisk_q, ptrs[nr_stripes - 1], stripe_len) ||
+		    memcmp(ondisk_p, ptrs[nr_stripes - 2], stripe_len))
+			ret = -EIO;
+	} else {
+		ret = raid5_gen_result(nr_stripes, stripe_len, nr_stripes - 1,
+					ptrs);
+		if (ret < 0)
+			goto out;
+		if (memcmp(ondisk_p, ptrs[nr_stripes - 1], stripe_len))
+			ret = -EIO;
+	}
+out:
+	free(buf_p);
+	free(buf_q);
+	free(ptrs);
+	return ret;
+}
-- 
2.10.0



