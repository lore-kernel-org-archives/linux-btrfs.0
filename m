Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24333 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933516AbdGTG5A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 02:57:00 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v6 12/15] btrfs-progs: scrub: Introduce helper to write a full stripe
Date: Thu, 20 Jul 2017 14:56:05 +0800
Message-ID: <20170720065608.27563-13-gujx@cn.fujitsu.com>
In-Reply-To: <20170720065608.27563-1-gujx@cn.fujitsu.com>
References: <20170720065608.27563-1-gujx@cn.fujitsu.com>
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
index fb14487..cc285d4 100644
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
2.9.4



