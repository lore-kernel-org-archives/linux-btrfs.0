Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:26117 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751527AbeAELR3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:29 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [v6 11/16] btrfs-progs: scrub: Introduce function to recover data parity
Date: Fri, 5 Jan 2018 19:01:19 +0800
Message-ID: <1515150084-17231-12-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce function, recover_from_parities(), to recover data stripes.

It just wraps raid56_recov() with extra check functions to
scrub_full_stripe structure.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 scrub.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/scrub.c b/scrub.c
index 3db82656..d88c52e1 100644
--- a/scrub.c
+++ b/scrub.c
@@ -818,3 +818,54 @@ out:
 	free(ptrs);
 	return ret;
 }
+
+/*
+ * Try to recover data stripe from P or Q stripe
+ *
+ * Return >0 if it can't be require any more.
+ * Return 0 for successful repair or no need to repair at all
+ * Return <0 for fatal error
+ */
+static int recover_from_parities(struct btrfs_fs_info *fs_info,
+				  struct btrfs_scrub_progress *scrub_ctx,
+				  struct scrub_full_stripe *fstripe)
+{
+	void **ptrs;
+	int nr_stripes = fstripe->nr_stripes;
+	int stripe_len = BTRFS_STRIPE_LEN;
+	int max_tolerance;
+	int i;
+	int ret;
+
+	/* No need to recover */
+	if (!fstripe->nr_corrupted_stripes)
+		return 0;
+
+	/* Already recovered once, no more chance */
+	if (fstripe->recovered)
+		return 1;
+
+	if (fstripe->bg_type & BTRFS_BLOCK_GROUP_RAID5)
+		max_tolerance = 1;
+	else
+		max_tolerance = 2;
+
+	/* Out of repair */
+	if (fstripe->nr_corrupted_stripes > max_tolerance)
+		return 1;
+
+	ptrs = malloc(sizeof(void *) * fstripe->nr_stripes);
+	if (!ptrs)
+		return -ENOMEM;
+
+	/* Construct ptrs */
+	for (i = 0; i < nr_stripes; i++)
+		ptrs[i] = fstripe->stripes[i].data;
+
+	ret = raid56_recov(nr_stripes, stripe_len, fstripe->bg_type,
+			fstripe->corrupted_index[0],
+			fstripe->corrupted_index[1], ptrs);
+	fstripe->recovered = 1;
+	free(ptrs);
+	return ret;
+}
-- 
2.14.3



