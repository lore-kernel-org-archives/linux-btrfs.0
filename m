Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965908AbcJ1Ccn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:32:43 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 16/19] btrfs-progs: check/scrub: Introduce function to recover data parity
Date: Fri, 28 Oct 2016 10:31:52 +0800
Message-Id: <20161028023155.27336-17-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
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
index 7aeda88..7a8b783 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -495,3 +495,52 @@ out:
 	free(ptrs);
 	return ret;
 }
+
+/*
+ * Return >0 if out of repair
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
2.10.1



