Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34826 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751361AbeAELR3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:29 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [v6 12/16] btrfs-progs: scrub: Introduce helper to write a full stripe
Date: Fri, 5 Jan 2018 19:01:20 +0800
Message-ID: <1515150084-17231-13-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce a internal helper, write_full_stripe() to calculate P/Q and
write the whole full stripe.

This is useful to recover RAID56 stripes.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 scrub.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/scrub.c b/scrub.c
index d88c52e1..83f02a95 100644
--- a/scrub.c
+++ b/scrub.c
@@ -869,3 +869,47 @@ static int recover_from_parities(struct btrfs_fs_info *fs_info,
 	free(ptrs);
 	return ret;
 }
+
+/*
+ * Helper to write a full stripe to disk
+ * P/Q will be re-calculated.
+ */
+static int write_full_stripe(struct scrub_full_stripe *fstripe)
+{
+	void **ptrs;
+	int nr_stripes = fstripe->nr_stripes;
+	int stripe_len = BTRFS_STRIPE_LEN;
+	int i;
+	int ret = 0;
+
+	ptrs = malloc(sizeof(void *) * fstripe->nr_stripes);
+	if (!ptrs)
+		return -ENOMEM;
+
+	for (i = 0; i < fstripe->nr_stripes; i++)
+		ptrs[i] = fstripe->stripes[i].data;
+
+	if (fstripe->bg_type & BTRFS_BLOCK_GROUP_RAID6) {
+		raid6_gen_syndrome(nr_stripes, stripe_len, ptrs);
+	} else {
+		ret = raid5_gen_result(nr_stripes, stripe_len, nr_stripes - 1,
+					ptrs);
+		if (ret < 0)
+			goto out;
+	}
+
+	for (i = 0; i < fstripe->nr_stripes; i++) {
+		struct scrub_stripe *stripe = &fstripe->stripes[i];
+
+		ret = pwrite(stripe->fd, stripe->data, fstripe->stripe_len,
+			     stripe->physical);
+		if (ret != fstripe->stripe_len) {
+			ret = -EIO;
+			goto out;
+		}
+	}
+out:
+	free(ptrs);
+	return ret;
+
+}
-- 
2.14.3



