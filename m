Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2344 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755026AbcLZGa0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 01:30:26 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 2168241B4BED
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 14:29:47 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 16/19] btrfs-progs: scrub: Introduce function to recover data parity
Date: Mon, 26 Dec 2016 14:29:36 +0800
Message-Id: <20161226062939.5841-17-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce function, recover_from_parities(), to recover data stripes.

It just wraps raid56_recov() with extra check functions to
scrub_full_stripe structure.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 scrub.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/scrub.c b/scrub.c
index 238feb3c..522802c2 100644
--- a/scrub.c
+++ b/scrub.c
@@ -549,3 +549,54 @@ out:
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
2.11.0



