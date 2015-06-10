Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45454 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744AbbFJLr5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 07:47:57 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5ABkLHE022592
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2015 19:46:21 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: Update out-of-date "skip parity stripe" comment
Date: Wed, 10 Jun 2015 19:45:48 +0800
Message-ID: <f3a491939f803f9a391619aad209b6e1c000bbd8.1433936721.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Because btrfs support scrub raid56 parity stripe now.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a13f91a..5ee5630 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3202,12 +3202,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	 */
 	ret = 0;
 	while (physical < physical_end) {
-		/* for raid56, we skip parity stripe */
 		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
 			ret = get_raid56_logic_offset(physical, num,
 					map, &logical, &stripe_logical);
 			logical += base;
 			if (ret) {
+				/* it is parity strip */
 				stripe_logical += base;
 				stripe_end = stripe_logical + increment - 1;
 				ret = scrub_raid56_parity(sctx, map, scrub_dev,
-- 
1.8.5.1

