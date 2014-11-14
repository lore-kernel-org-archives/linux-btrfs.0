Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2495 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965560AbaKNNt0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 08:49:26 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAEDnBfJ005813
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 21:49:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/9] Btrfs: remove unnecessary code of stripe_index assignment in __btrfs_map_block
Date: Fri, 14 Nov 2014 21:50:54 +0800
Message-ID: <1415973061-8643-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
References: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

stripe_index's value was set again in latter line:
stripe_index = 0;

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
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

