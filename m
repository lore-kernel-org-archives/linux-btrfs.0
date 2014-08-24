Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34703 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaHXFlc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 01:41:32 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH] fs: btrfs: fix potential overflow
Date: Sat, 23 Aug 2014 22:41:21 -0700
Message-Id: <1408858881-30497-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It looks like this intended to be 64-bit arithmetic, but it's actually
performed as 32-bit. Fix that. (Note that 'increment' was being
initialized twice, so this patch removes one of those.)

Caught by Coverity Scan (CID 1201422).

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
Untested

 fs/btrfs/scrub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b6d198f5181e..b1a8127737b4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2320,26 +2320,26 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	do_div(nstripes, map->stripe_len);
 	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
 		offset = map->stripe_len * num;
-		increment = map->stripe_len * map->num_stripes;
+		increment *= map->num_stripes;
 		mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
 		int factor = map->num_stripes / map->sub_stripes;
 		offset = map->stripe_len * (num / map->sub_stripes);
-		increment = map->stripe_len * factor;
+		increment *= factor;
 		mirror_num = num % map->sub_stripes + 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		increment = map->stripe_len;
+		increment *= 1;
 		mirror_num = num % map->num_stripes + 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		increment = map->stripe_len;
+		increment *= 1;
 		mirror_num = num % map->num_stripes + 1;
 	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
 				BTRFS_BLOCK_GROUP_RAID6)) {
 		get_raid56_logic_offset(physical, num, map, &offset);
-		increment = map->stripe_len * nr_data_stripes(map);
+		increment *= nr_data_stripes(map);
 		mirror_num = 1;
 	} else {
-		increment = map->stripe_len;
+		increment *= 1;
 		mirror_num = 1;
 	}
 
-- 
1.7.9.5

