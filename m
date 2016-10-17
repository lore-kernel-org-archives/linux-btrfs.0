Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55698 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1756519AbcJQB2I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 21:28:08 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 6CF1A41B4BCA
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:27:51 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v0.8 11/14] btrfs-progs: check/scrub: Introduce function to recover data parity
Date: Mon, 17 Oct 2016 09:27:40 +0800
Message-Id: <20161017012743.9692-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
References: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce function, recover_from_parities(), to recover data stripes.

However this function only support RAID5 yet, but should be good enough
for the scrub framework.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/check/scrub.c b/check/scrub.c
index d8182d6..c965328 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -58,6 +58,9 @@ struct scrub_full_stripe {
 	/* Missing stripe index */
 	int missing_stripes[2];
 
+	/* Has already been recovered using parities */
+	unsigned int recovered:1;
+
 	struct scrub_stripe stripes[];
 };
 
@@ -467,3 +470,49 @@ out:
 	free(ptrs);
 	return ret;
 }
+
+static int recovery_from_parities(struct btrfs_fs_info *fs_info,
+				  struct btrfs_scrub_progress *scrub_ctx,
+				  struct scrub_full_stripe *fstripe)
+{
+	void **ptrs;
+	int nr_stripes = fstripe->nr_stripes;
+	int corrupted = -1;
+	int stripe_len = BTRFS_STRIPE_LEN;
+	int i;
+	int ret;
+
+	/* No need to recover */
+	if (!fstripe->err_read_stripes && !fstripe->err_csum_dstripes)
+		return 0;
+
+	/* Already recovered once, no more chance */
+	if (fstripe->recovered)
+		return -EINVAL;
+
+	if (fstripe->bg_type == BTRFS_BLOCK_GROUP_RAID6) {
+		/* Need to recover 2 stripes, not supported yet */
+		error("recover data stripes for RAID6 is not support yet");
+		return -ENOTTY;
+	}
+
+	/* Out of repair */
+	if (fstripe->err_read_stripes + fstripe->err_csum_dstripes > 1)
+		return -EINVAL;
+
+	ptrs = malloc(sizeof(void *) * fstripe->nr_stripes);
+	if (!ptrs)
+		return -ENOMEM;
+
+	/* Construct ptrs */
+	for (i = 0; i < nr_stripes; i++)
+		ptrs[i] = fstripe->stripes[i].data;
+	corrupted = fstripe->missing_stripes[0];
+
+	/* Recover the corrupted data csum */
+	ret = raid5_gen_result(nr_stripes, stripe_len, corrupted, ptrs);
+
+	fstripe->recovered = 1;
+	free(ptrs);
+	return ret;
+}
-- 
2.10.0



