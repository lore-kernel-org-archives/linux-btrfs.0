Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934147Ab3FSKUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Jun 2013 06:20:38 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r5JAKaxi030490
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2013 18:20:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix wrong mirror number tuning
Date: Wed, 19 Jun 2013 18:20:17 +0800
Message-Id: <1371637217-5188-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now reading the data from the target device of the replace operation is allowed,
so the mirror number that is greater than the stripes number of a chunk is valid,
we will tune it when we find there is no target device later. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c58bf19..7789598 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4420,9 +4420,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	map = (struct map_lookup *)em->bdev;
 	offset = logical - em->start;
 
-	if (mirror_num > map->num_stripes)
-		mirror_num = 0;
-
 	stripe_len = map->stripe_len;
 	stripe_nr = offset;
 	/*
-- 
1.8.1.4

