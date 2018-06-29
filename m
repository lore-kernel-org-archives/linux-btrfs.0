Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966221AbeF2I5A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:57:00 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AA12BAD66
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:59 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 09/14] btrfs: raid56: use new helper for async_rmw_stripe
Date: Fri, 29 Jun 2018 10:56:58 +0200
Message-Id: <5517fa2c3be29eb257e46802c8befb892fc508be.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index f30d847baf07..96a7d3445623 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -162,7 +162,6 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio);
 static noinline void finish_rmw(struct btrfs_raid_bio *rbio);
 static void rmw_work(struct btrfs_work *work);
 static void read_rebuild_work(struct btrfs_work *work);
-static void async_rmw_stripe(struct btrfs_raid_bio *rbio);
 static void async_read_rebuild(struct btrfs_raid_bio *rbio);
 static int fail_bio_stripe(struct btrfs_raid_bio *rbio, struct bio *bio);
 static int fail_rbio_index(struct btrfs_raid_bio *rbio, int failed);
@@ -811,7 +810,7 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 				async_read_rebuild(next);
 			} else if (next->operation == BTRFS_RBIO_WRITE) {
 				steal_rbio(rbio, next);
-				async_rmw_stripe(next);
+				start_async_work(next, rmw_work);
 			} else if (next->operation == BTRFS_RBIO_PARITY_SCRUB) {
 				steal_rbio(rbio, next);
 				async_scrub_parity(next);
@@ -1501,12 +1500,6 @@ static void raid_rmw_end_io(struct bio *bio)
 	rbio_orig_end_io(rbio, BLK_STS_IOERR);
 }
 
-static void async_rmw_stripe(struct btrfs_raid_bio *rbio)
-{
-	btrfs_init_work(&rbio->work, btrfs_rmw_helper, rmw_work, NULL, NULL);
-	btrfs_queue_work(rbio->fs_info->rmw_workers, &rbio->work);
-}
-
 static void async_read_rebuild(struct btrfs_raid_bio *rbio)
 {
 	btrfs_init_work(&rbio->work, btrfs_rmw_helper,
@@ -1645,7 +1638,7 @@ static int partial_stripe_write(struct btrfs_raid_bio *rbio)
 
 	ret = lock_stripe_add(rbio);
 	if (ret == 0)
-		async_rmw_stripe(rbio);
+		start_async_work(rbio, rmw_work);
 	return 0;
 }
 
-- 
2.17.1

