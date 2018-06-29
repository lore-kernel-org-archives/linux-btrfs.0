Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34044 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966291AbeF2I5D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:57:03 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E756DAD66
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:57:01 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/14] btrfs: raid56: use new helper for async_read_rebuild
Date: Fri, 29 Jun 2018 10:57:00 +0200
Message-Id: <913cbb6dcb7c86ad67a1d9b2b16c20acc7ddaf45.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 96a7d3445623..f9b349171d61 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -162,7 +162,6 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio);
 static noinline void finish_rmw(struct btrfs_raid_bio *rbio);
 static void rmw_work(struct btrfs_work *work);
 static void read_rebuild_work(struct btrfs_work *work);
-static void async_read_rebuild(struct btrfs_raid_bio *rbio);
 static int fail_bio_stripe(struct btrfs_raid_bio *rbio, struct bio *bio);
 static int fail_rbio_index(struct btrfs_raid_bio *rbio, int failed);
 static void __free_raid_bio(struct btrfs_raid_bio *rbio);
@@ -804,10 +803,10 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 			spin_unlock_irqrestore(&h->lock, flags);
 
 			if (next->operation == BTRFS_RBIO_READ_REBUILD)
-				async_read_rebuild(next);
+				start_async_work(next, read_rebuild_work);
 			else if (next->operation == BTRFS_RBIO_REBUILD_MISSING) {
 				steal_rbio(rbio, next);
-				async_read_rebuild(next);
+				start_async_work(next, read_rebuild_work);
 			} else if (next->operation == BTRFS_RBIO_WRITE) {
 				steal_rbio(rbio, next);
 				start_async_work(next, rmw_work);
@@ -1500,14 +1499,6 @@ static void raid_rmw_end_io(struct bio *bio)
 	rbio_orig_end_io(rbio, BLK_STS_IOERR);
 }
 
-static void async_read_rebuild(struct btrfs_raid_bio *rbio)
-{
-	btrfs_init_work(&rbio->work, btrfs_rmw_helper,
-			read_rebuild_work, NULL, NULL);
-
-	btrfs_queue_work(rbio->fs_info->rmw_workers, &rbio->work);
-}
-
 /*
  * the stripe must be locked by the caller.  It will
  * unlock after all the writes are done
@@ -2765,5 +2756,5 @@ raid56_alloc_missing_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio)
 {
 	if (!lock_stripe_add(rbio))
-		async_read_rebuild(rbio);
+		start_async_work(rbio, read_rebuild_work);
 }
-- 
2.17.1

