Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966291AbeF2I5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:57:06 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 219EAAD66
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:57:05 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 11/14] btrfs: raid56: use new helper for async_scrub_parity
Date: Fri, 29 Jun 2018 10:57:03 +0200
Message-Id: <5debd1098fce6c869693efafb2fc454447df209e.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index f9b349171d61..339cce0878d1 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -170,7 +170,7 @@ static int alloc_rbio_pages(struct btrfs_raid_bio *rbio);
 
 static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 					 int need_check);
-static void async_scrub_parity(struct btrfs_raid_bio *rbio);
+static void scrub_parity_work(struct btrfs_work *work);
 
 static void start_async_work(struct btrfs_raid_bio *rbio, btrfs_func_t work_func)
 {
@@ -812,7 +812,7 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 				start_async_work(next, rmw_work);
 			} else if (next->operation == BTRFS_RBIO_PARITY_SCRUB) {
 				steal_rbio(rbio, next);
-				async_scrub_parity(next);
+				start_async_work(next, scrub_parity_work);
 			}
 
 			goto done_nolock;
@@ -2703,18 +2703,10 @@ static void scrub_parity_work(struct btrfs_work *work)
 	raid56_parity_scrub_stripe(rbio);
 }
 
-static void async_scrub_parity(struct btrfs_raid_bio *rbio)
-{
-	btrfs_init_work(&rbio->work, btrfs_rmw_helper,
-			scrub_parity_work, NULL, NULL);
-
-	btrfs_queue_work(rbio->fs_info->rmw_workers, &rbio->work);
-}
-
 void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio)
 {
 	if (!lock_stripe_add(rbio))
-		async_scrub_parity(rbio);
+		start_async_work(rbio, scrub_parity_work);
 }
 
 /* The following code is used for dev replace of a missing RAID 5/6 device. */
-- 
2.17.1

