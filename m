Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54124 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750769AbbGUEYK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 00:24:10 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6L4MJW9021612
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 12:22:19 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: Check cancel and pause in interval of scrub operation
Date: Tue, 21 Jul 2015 12:22:29 +0800
Message-ID: <67a4b66d550b9e39940fbf242bbe901fc3f7671f.1437452532.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Old code checking cancel and pause request inside scrub stripe
operation, like:
  loop() {
    if (parity) {
      scrub_parity_stripe();
      continue;
    }

    check_cancel_and_pause()

    scrub_normal_stripe();
  }

Reason is when introduce raid56 stripe scrub, new code is inserted
simplely to front of loop.

Better to:
  loop() {
    check_cancel_and_pause()

    if (parity)
      scrub_parity_stripe();
    else
      scrub_normal_stripe();
  }

This patch adjusted code place to realize above sequence.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 94db0fa..f8551b9 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3104,22 +3104,6 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	 */
 	ret = 0;
 	while (physical < physical_end) {
-		/* for raid56, we skip parity stripe */
-		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
-			ret = get_raid56_logic_offset(physical, num,
-					map, &logical, &stripe_logical);
-			logical += base;
-			if (ret) {
-				stripe_logical += base;
-				stripe_end = stripe_logical + increment - 1;
-				ret = scrub_raid56_parity(sctx, map, scrub_dev,
-						ppath, stripe_logical,
-						stripe_end);
-				if (ret)
-					goto out;
-				goto skip;
-			}
-		}
 		/*
 		 * canceled?
 		 */
@@ -3144,6 +3128,24 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			scrub_blocked_if_needed(fs_info);
 		}
 
+		/* for raid56, we skip parity stripe */
+		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+			ret = get_raid56_logic_offset(physical, num, map,
+						      &logical,
+						      &stripe_logical);
+			logical += base;
+			if (ret) {
+				stripe_logical += base;
+				stripe_end = stripe_logical + increment - 1;
+				ret = scrub_raid56_parity(sctx, map, scrub_dev,
+							  ppath, stripe_logical,
+							  stripe_end);
+				if (ret)
+					goto out;
+				goto skip;
+			}
+		}
+
 		if (btrfs_fs_incompat(fs_info, SKINNY_METADATA))
 			key.type = BTRFS_METADATA_ITEM_KEY;
 		else
-- 
1.8.5.1

