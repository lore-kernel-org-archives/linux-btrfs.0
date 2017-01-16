Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:6749 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbdAPCZV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jan 2017 21:25:21 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 781574052BC5
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jan 2017 10:23:10 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: raid56: Remove unused variant in lock_stripe_add
Date: Mon, 16 Jan 2017 10:23:06 +0800
Message-Id: <20170116022306.32446-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Variant 'walk' in lock_stripe_add() is never used.
Remove it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 453eefdcb591..b8ffd9ea7499 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -693,11 +693,9 @@ static noinline int lock_stripe_add(struct btrfs_raid_bio *rbio)
 	struct btrfs_raid_bio *freeit = NULL;
 	struct btrfs_raid_bio *cache_drop = NULL;
 	int ret = 0;
-	int walk = 0;
 
 	spin_lock_irqsave(&h->lock, flags);
 	list_for_each_entry(cur, &h->hash_list, hash_list) {
-		walk++;
 		if (cur->bbio->raid_map[0] == rbio->bbio->raid_map[0]) {
 			spin_lock(&cur->bio_list_lock);
 
-- 
2.11.0



