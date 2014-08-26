Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63742 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbaHZGr3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 02:47:29 -0400
Date: Mon, 25 Aug 2014 23:47:25 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2] fs: btrfs: fix potential overflow
Message-ID: <20140826064725.GE3246@norris-Latitude-E6410>
References: <1408858881-30497-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1408858881-30497-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It looks like this intended to be 64-bit arithmetic, but it's actually
performed as 32-bit. Fix that. (Note that 'increment' was being
initialized twice, so this patch removes one of those.)

Caught by Coverity Scan (CID 1201422).

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
v2: remove useless multiplication-by-one

Untested

 fs/btrfs/scrub.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b6d198f5181e..e38933ebf97f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2320,26 +2320,23 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
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
 		mirror_num = num % map->num_stripes + 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		increment = map->stripe_len;
 		mirror_num = num % map->num_stripes + 1;
 	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
 				BTRFS_BLOCK_GROUP_RAID6)) {
 		get_raid56_logic_offset(physical, num, map, &offset);
-		increment = map->stripe_len * nr_data_stripes(map);
+		increment *= nr_data_stripes(map);
 		mirror_num = 1;
 	} else {
-		increment = map->stripe_len;
 		mirror_num = 1;
 	}
 
-- 
1.9.1

