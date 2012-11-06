Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:28303 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp2) (RZmta 31.1 OK) with ESMTP id g01bccoA6DKvk4
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/26] Btrfs: cleanup scrub bio and worker wait code
Date: Tue,  6 Nov 2012 17:38:24 +0100
Message-Id: <c535bc872c3ace3a7e050a86adbf20edfd70172f.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

Just move some code into functions to make everything more readable.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c | 106 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 71 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index fcd5bcc..a67b1a1 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2011 STRATO.  All rights reserved.
+ * Copyright (C) 2011, 2012 STRATO.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -104,8 +104,8 @@ struct scrub_ctx {
 	struct btrfs_root	*dev_root;
 	int			first_free;
 	int			curr;
-	atomic_t		in_flight;
-	atomic_t		fixup_cnt;
+	atomic_t		bios_in_flight;
+	atomic_t		workers_pending;
 	spinlock_t		list_lock;
 	wait_queue_head_t	list_wait;
 	u16			csum_size;
@@ -146,6 +146,10 @@ struct scrub_warning {
 };
 
 
+static void scrub_pending_bio_inc(struct scrub_ctx *sctx);
+static void scrub_pending_bio_dec(struct scrub_ctx *sctx);
+static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx);
+static void scrub_pending_trans_workers_dec(struct scrub_ctx *sctx);
 static int scrub_handle_errored_block(struct scrub_block *sblock_to_check);
 static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 				     struct btrfs_mapping_tree *map_tree,
@@ -184,6 +188,59 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work);
 static void scrub_block_complete(struct scrub_block *sblock);
 
 
+static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
+{
+	atomic_inc(&sctx->bios_in_flight);
+}
+
+static void scrub_pending_bio_dec(struct scrub_ctx *sctx)
+{
+	atomic_dec(&sctx->bios_in_flight);
+	wake_up(&sctx->list_wait);
+}
+
+/*
+ * used for workers that require transaction commits (i.e., for the
+ * NOCOW case)
+ */
+static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx)
+{
+	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+
+	/*
+	 * increment scrubs_running to prevent cancel requests from
+	 * completing as long as a worker is running. we must also
+	 * increment scrubs_paused to prevent deadlocking on pause
+	 * requests used for transactions commits (as the worker uses a
+	 * transaction context). it is safe to regard the worker
+	 * as paused for all matters practical. effectively, we only
+	 * avoid cancellation requests from completing.
+	 */
+	mutex_lock(&fs_info->scrub_lock);
+	atomic_inc(&fs_info->scrubs_running);
+	atomic_inc(&fs_info->scrubs_paused);
+	mutex_unlock(&fs_info->scrub_lock);
+	atomic_inc(&sctx->workers_pending);
+}
+
+/* used for workers that require transaction commits */
+static void scrub_pending_trans_workers_dec(struct scrub_ctx *sctx)
+{
+	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+
+	/*
+	 * see scrub_pending_trans_workers_inc() why we're pretending
+	 * to be paused in the scrub counters
+	 */
+	mutex_lock(&fs_info->scrub_lock);
+	atomic_dec(&fs_info->scrubs_running);
+	atomic_dec(&fs_info->scrubs_paused);
+	mutex_unlock(&fs_info->scrub_lock);
+	atomic_dec(&sctx->workers_pending);
+	wake_up(&fs_info->scrub_pause_wait);
+	wake_up(&sctx->list_wait);
+}
+
 static void scrub_free_csums(struct scrub_ctx *sctx)
 {
 	while (!list_empty(&sctx->csum_list)) {
@@ -264,8 +321,8 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev)
 	sctx->nodesize = dev->dev_root->nodesize;
 	sctx->leafsize = dev->dev_root->leafsize;
 	sctx->sectorsize = dev->dev_root->sectorsize;
-	atomic_set(&sctx->in_flight, 0);
-	atomic_set(&sctx->fixup_cnt, 0);
+	atomic_set(&sctx->bios_in_flight, 0);
+	atomic_set(&sctx->workers_pending, 0);
 	atomic_set(&sctx->cancel_req, 0);
 	sctx->csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	INIT_LIST_HEAD(&sctx->csum_list);
@@ -609,14 +666,7 @@ out:
 	btrfs_free_path(path);
 	kfree(fixup);
 
-	/* see caller why we're pretending to be paused in the scrub counters */
-	mutex_lock(&fs_info->scrub_lock);
-	atomic_dec(&fs_info->scrubs_running);
-	atomic_dec(&fs_info->scrubs_paused);
-	mutex_unlock(&fs_info->scrub_lock);
-	atomic_dec(&sctx->fixup_cnt);
-	wake_up(&fs_info->scrub_pause_wait);
-	wake_up(&sctx->list_wait);
+	scrub_pending_trans_workers_dec(sctx);
 }
 
 /*
@@ -789,20 +839,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		fixup_nodatasum->logical = logical;
 		fixup_nodatasum->root = fs_info->extent_root;
 		fixup_nodatasum->mirror_num = failed_mirror_index + 1;
-		/*
-		 * increment scrubs_running to prevent cancel requests from
-		 * completing as long as a fixup worker is running. we must also
-		 * increment scrubs_paused to prevent deadlocking on pause
-		 * requests used for transactions commits (as the worker uses a
-		 * transaction context). it is safe to regard the fixup worker
-		 * as paused for all matters practical. effectively, we only
-		 * avoid cancellation requests from completing.
-		 */
-		mutex_lock(&fs_info->scrub_lock);
-		atomic_inc(&fs_info->scrubs_running);
-		atomic_inc(&fs_info->scrubs_paused);
-		mutex_unlock(&fs_info->scrub_lock);
-		atomic_inc(&sctx->fixup_cnt);
+		scrub_pending_trans_workers_inc(sctx);
 		fixup_nodatasum->work.func = scrub_fixup_nodatasum;
 		btrfs_queue_worker(&fs_info->scrub_workers,
 				   &fixup_nodatasum->work);
@@ -1491,7 +1528,7 @@ static void scrub_submit(struct scrub_ctx *sctx)
 
 	sbio = sctx->bios[sctx->curr];
 	sctx->curr = -1;
-	atomic_inc(&sctx->in_flight);
+	scrub_pending_bio_inc(sctx);
 
 	btrfsic_submit_bio(READ, sbio->bio);
 }
@@ -1692,8 +1729,7 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work)
 	sbio->next_free = sctx->first_free;
 	sctx->first_free = sbio->index;
 	spin_unlock(&sctx->list_lock);
-	atomic_dec(&sctx->in_flight);
-	wake_up(&sctx->list_wait);
+	scrub_pending_bio_dec(sctx);
 }
 
 static void scrub_block_complete(struct scrub_block *sblock)
@@ -1863,7 +1899,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	logical = base + offset;
 
 	wait_event(sctx->list_wait,
-		   atomic_read(&sctx->in_flight) == 0);
+		   atomic_read(&sctx->bios_in_flight) == 0);
 	atomic_inc(&fs_info->scrubs_paused);
 	wake_up(&fs_info->scrub_pause_wait);
 
@@ -1928,7 +1964,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			/* push queued extents */
 			scrub_submit(sctx);
 			wait_event(sctx->list_wait,
-				   atomic_read(&sctx->in_flight) == 0);
+				   atomic_read(&sctx->bios_in_flight) == 0);
 			atomic_inc(&fs_info->scrubs_paused);
 			wake_up(&fs_info->scrub_pause_wait);
 			mutex_lock(&fs_info->scrub_lock);
@@ -2218,7 +2254,7 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 		if (ret)
 			return ret;
 	}
-	wait_event(sctx->list_wait, atomic_read(&sctx->in_flight) == 0);
+	wait_event(sctx->list_wait, atomic_read(&sctx->bios_in_flight) == 0);
 
 	return 0;
 }
@@ -2363,11 +2399,11 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 	if (!ret)
 		ret = scrub_enumerate_chunks(sctx, dev, start, end);
 
-	wait_event(sctx->list_wait, atomic_read(&sctx->in_flight) == 0);
+	wait_event(sctx->list_wait, atomic_read(&sctx->bios_in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
 	wake_up(&fs_info->scrub_pause_wait);
 
-	wait_event(sctx->list_wait, atomic_read(&sctx->fixup_cnt) == 0);
+	wait_event(sctx->list_wait, atomic_read(&sctx->workers_pending) == 0);
 
 	if (progress)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
-- 
1.8.0

