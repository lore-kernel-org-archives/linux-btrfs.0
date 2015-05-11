Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19150 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751705AbbEKAsA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 May 2015 20:48:00 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B0kTW2031696
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 08:46:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: Fix a bug in __btrfs_map_block() always maps wrong stripe for DUP/RAID1
Date: Mon, 11 May 2015 08:45:47 +0800
Message-ID: <1431305148-18953-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In __btrfs_map_block(), stripe_index is always wrong if mirror_num is
given.

For DUP/RAID1 case, if mirror_num is given, e.g. 1, it should return the
second stripe.
But codes consider the mirror_num is start from 1 and always minus 1,
causing even mirror number is given as 1, __btrfs_map_block() will still
map the first stripe not the second.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index 16dbf64..c66c02a 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1397,7 +1397,7 @@ again:
 		if (rw == WRITE)
 			multi->num_stripes = map->num_stripes;
 		else if (mirror_num)
-			stripe_index = mirror_num - 1;
+			stripe_index = mirror_num;
 		else
 			stripe_index = stripe_nr % map->num_stripes;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
@@ -1416,7 +1416,7 @@ again:
 		if (rw == WRITE)
 			multi->num_stripes = map->num_stripes;
 		else if (mirror_num)
-			stripe_index = mirror_num - 1;
+			stripe_index = mirror_num;
 	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
 				BTRFS_BLOCK_GROUP_RAID6)) {
 
-- 
2.4.0

