Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752450AbdEPRLl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 196BBAD25
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:35 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 06/10] btrfs: scrub: use bool for flush_all_writes
Date: Tue, 16 May 2017 19:10:38 +0200
Message-Id: <0d4dcd2dd113cdff9141336e583ab5afacfeee6f.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

flush_all_writes is an atomic but does not use the semantics at all,
it's just on/off indicator, we can use bool.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2c1d344c8edd..8caf775fee0a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -182,8 +182,8 @@ struct scrub_ctx {
 
 	struct scrub_bio        *wr_curr_bio;
 	struct mutex            wr_lock;
-	atomic_t                flush_all_writes;
 	struct btrfs_device     *wr_tgtdev;
+	bool                    flush_all_writes;
 
 	/*
 	 * statistics
@@ -718,7 +718,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	if (is_dev_replace) {
 		WARN_ON(!dev->bdev);
 		sctx->wr_tgtdev = dev;
-		atomic_set(&sctx->flush_all_writes, 0);
+		sctx->flush_all_writes = false;
 	}
 
 	return sctx;
@@ -2410,8 +2410,7 @@ static void scrub_missing_raid56_worker(struct btrfs_work *work)
 
 	scrub_block_put(sblock);
 
-	if (sctx->is_dev_replace &&
-	    atomic_read(&sctx->flush_all_writes)) {
+	if (sctx->is_dev_replace && sctx->flush_all_writes) {
 		mutex_lock(&sctx->wr_lock);
 		scrub_wr_submit(sctx);
 		mutex_unlock(&sctx->wr_lock);
@@ -2618,8 +2617,7 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work)
 	sctx->first_free = sbio->index;
 	spin_unlock(&sctx->list_lock);
 
-	if (sctx->is_dev_replace &&
-	    atomic_read(&sctx->flush_all_writes)) {
+	if (sctx->is_dev_replace && sctx->flush_all_writes) {
 		mutex_lock(&sctx->wr_lock);
 		scrub_wr_submit(sctx);
 		mutex_unlock(&sctx->wr_lock);
@@ -3454,14 +3452,14 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		 */
 		if (atomic_read(&fs_info->scrub_pause_req)) {
 			/* push queued extents */
-			atomic_set(&sctx->flush_all_writes, 1);
+			sctx->flush_all_writes = true;
 			scrub_submit(sctx);
 			mutex_lock(&sctx->wr_lock);
 			scrub_wr_submit(sctx);
 			mutex_unlock(&sctx->wr_lock);
 			wait_event(sctx->list_wait,
 				   atomic_read(&sctx->bios_in_flight) == 0);
-			atomic_set(&sctx->flush_all_writes, 0);
+			sctx->flush_all_writes = false;
 			scrub_blocked_if_needed(fs_info);
 		}
 
@@ -3907,7 +3905,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 * write requests are really completed when bios_in_flight
 		 * changes to 0.
 		 */
-		atomic_set(&sctx->flush_all_writes, 1);
+		sctx->flush_all_writes = true;
 		scrub_submit(sctx);
 		mutex_lock(&sctx->wr_lock);
 		scrub_wr_submit(sctx);
@@ -3925,7 +3923,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 */
 		wait_event(sctx->list_wait,
 			   atomic_read(&sctx->workers_pending) == 0);
-		atomic_set(&sctx->flush_all_writes, 0);
+		sctx->flush_all_writes = false;
 
 		scrub_pause_off(fs_info);
 
-- 
2.12.0

