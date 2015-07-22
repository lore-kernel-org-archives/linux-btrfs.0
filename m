Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8032 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751836AbbGVFQ0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 01:16:26 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6M5EZkT014206
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 13:14:35 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: Load only necessary csums into list in scrub
Date: Wed, 22 Jul 2015 13:14:47 +0800
Message-ID: <e93ff56830016c5edcbb960584c885b3173090be.1437541968.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

We need not load csum of whole strip in scrub because strip is trimed
before use, it is to say, what we really need to calculate csum is
data between [extent_logical, extent_len).

This patch changed to use above segment for btrfs_lookup_csums_range()
in scrub_stripe()

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 7f56603..d72e8e1 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3251,9 +3251,11 @@ again:
 						   &extent_dev,
 						   &extent_mirror_num);
 
-			ret = btrfs_lookup_csums_range(csum_root, logical,
-						logical + map->stripe_len - 1,
-						&sctx->csum_list, 1);
+			ret = btrfs_lookup_csums_range(csum_root,
+						       extent_logical,
+						       extent_logical +
+						       extent_len - 1,
+						       &sctx->csum_list, 1);
 			if (ret)
 				goto out;
 
-- 
1.8.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
