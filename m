Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17394 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751546AbaKZNDR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 08:03:17 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAQD2u8h015498
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 21:02:56 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 02/11] Btrfs: remove unnecessary code of stripe_index assignment in __btrfs_map_block
Date: Wed, 26 Nov 2014 21:04:42 +0800
Message-ID: <1417007091-11885-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

stripe_index's value was set again in latter line:
stripe_index = 0;

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
Changelog v1 -> v3:
- None.
---
 fs/btrfs/volumes.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 41b0dff..66d5035 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5167,9 +5167,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 			/* push stripe_nr back to the start of the full stripe */
 			stripe_nr = raid56_full_stripe_start;
-			do_div(stripe_nr, stripe_len);
-
-			stripe_index = do_div(stripe_nr, nr_data_stripes(map));
+			do_div(stripe_nr, stripe_len * nr_data_stripes(map));
 
 			/* RAID[56] write or recovery. Return all stripes */
 			num_stripes = map->num_stripes;
-- 
1.9.3

