Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17129 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932717AbdCXCAp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 22:00:45 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <bo.li.liu@oracle.com>
Subject: [PATCH v2 5/5] btrfs: raid56: Use bio_counter to protect scrub
Date: Fri, 24 Mar 2017 10:00:27 +0800
Message-ID: <20170324020027.21228-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
References: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlike other place calling btrfs_map_block(), in raid56 scrub, we don't
use bio_counter to protect from race against dev replace.

This patch will use bio_counter to protect from the beginning of calling
btrfs_map_sblock(), until rbio endio.

Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 2 ++
 fs/btrfs/scrub.c  | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 1571bf26dc07..3a083165400f 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2642,6 +2642,7 @@ static void async_scrub_parity(struct btrfs_raid_bio *rbio)
 
 void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio)
 {
+	rbio->generic_bio_cnt = 1;
 	if (!lock_stripe_add(rbio))
 		async_scrub_parity(rbio);
 }
@@ -2694,6 +2695,7 @@ static void async_missing_raid56(struct btrfs_raid_bio *rbio)
 
 void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio)
 {
+	rbio->generic_bio_cnt = 1;
 	if (!lock_stripe_add(rbio))
 		async_missing_raid56(rbio);
 }
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2a5458004279..265387bf3af8 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2379,6 +2379,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	int ret;
 	int i;
 
+	btrfs_bio_counter_inc_blocked(fs_info);
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
 			&length, &bbio, 0, 1);
 	if (ret || !bbio || !bbio->raid_map)
@@ -2423,6 +2424,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 rbio_out:
 	bio_put(bio);
 bbio_out:
+	btrfs_bio_counter_dec(fs_info);
 	btrfs_put_bbio(bbio);
 	spin_lock(&sctx->stat_lock);
 	sctx->stat.malloc_errors++;
@@ -2966,6 +2968,8 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 		goto out;
 
 	length = sparity->logic_end - sparity->logic_start;
+
+	btrfs_bio_counter_inc_blocked(fs_info);
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_WRITE, sparity->logic_start,
 			       &length, &bbio, 0, 1);
 	if (ret || !bbio || !bbio->raid_map)
@@ -2993,6 +2997,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 rbio_out:
 	bio_put(bio);
 bbio_out:
+	btrfs_bio_counter_dec(fs_info);
 	btrfs_put_bbio(bbio);
 	bitmap_or(sparity->ebitmap, sparity->ebitmap, sparity->dbitmap,
 		  sparity->nsectors);
-- 
2.12.1



