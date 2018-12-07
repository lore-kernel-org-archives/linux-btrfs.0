Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29009C07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 13:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2BEA20837
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 13:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544189019;
	bh=Q0lQcyTQXkU9XJqnPMyvrFSNClreTCjfxQQd32XRUnI=;
	h=From:To:Subject:Date:List-ID:From;
	b=dTxE80llqHfzTdHCtROXU95h/bjiHNyEjqEGTI+ow+JkhojY3Tvi7fk7aI0jVIFHn
	 1V//4NWvcRROmoRS00wmQ5Z2gF0faohxA2gmZGndodQKJAiZQt9u1FfRI9TGrpzDEE
	 WrZuH7RJMoMxkkDtgRJHsPaONuMOc35HQCGi8W3E=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2BEA20837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbeLGNXh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:23:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbeLGNXh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Dec 2018 08:23:37 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A656920837
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Dec 2018 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544189016;
        bh=Q0lQcyTQXkU9XJqnPMyvrFSNClreTCjfxQQd32XRUnI=;
        h=From:To:Subject:Date:From;
        b=MeMh0bjp6pVqMTAJJ7A8mewgpS0Y0+8muHo0k2sfquaCl5zdkgBjKImzuglls6BUh
         PrTXYnyZsDQEg33J+IPLbD259RMPyWdRalZKKIIumzIx3elDFZ7O/XfGghKRnO3x9g
         Dp9h92T+Brr7flF07NIaW/ag27Z4J5fiNMrKaD1A=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: scrub, move setup of nofs contexts higher in the stack
Date:   Fri,  7 Dec 2018 13:23:32 +0000
Message-Id: <20181207132332.31774-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Since scrub workers only do memory allocation with GFP_KERNEL when they
need to perform repair, we can move the recent setup of the nofs context
up to scrub_handle_errored_block() instead of setting it up down the call
chain at insert_full_stripe_lock() and scrub_add_page_to_wr_bio(),
removing some duplicate code and comment. So the only paths for which a
scrub worker can do memory allocations using GFP_KERNEL are the following:

 scrub_bio_end_io_worker()
   scrub_block_complete()
     scrub_handle_errored_block()
       lock_full_stripe()
         insert_full_stripe_lock()
           -> kmalloc with GFP_KERNEL

  scrub_bio_end_io_worker()
    scrub_block_complete()
      scrub_handle_errored_block()
        scrub_write_page_to_dev_replace()
          scrub_add_page_to_wr_bio()
            -> kzalloc with GFP_KERNEL

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

Applies on top of:

  Btrfs: fix deadlock with memory reclaim during scrub

 fs/btrfs/scrub.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index bbd1b36f4918..f996f4064596 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -322,7 +322,6 @@ static struct full_stripe_lock *insert_full_stripe_lock(
 	struct rb_node *parent = NULL;
 	struct full_stripe_lock *entry;
 	struct full_stripe_lock *ret;
-	unsigned int nofs_flag;
 
 	lockdep_assert_held(&locks_root->lock);
 
@@ -342,15 +341,8 @@ static struct full_stripe_lock *insert_full_stripe_lock(
 
 	/*
 	 * Insert new lock.
-	 *
-	 * We must use GFP_NOFS because the scrub task might be waiting for a
-	 * worker task executing this function and in turn a transaction commit
-	 * might be waiting the scrub task to pause (which needs to wait for all
-	 * the worker tasks to complete before pausing).
 	 */
-	nofs_flag = memalloc_nofs_save();
 	ret = kmalloc(sizeof(*ret), GFP_KERNEL);
-	memalloc_nofs_restore(nofs_flag);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 	ret->logical = fstripe_logical;
@@ -842,6 +834,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	int page_num;
 	int success;
 	bool full_stripe_locked;
+	unsigned int nofs_flag;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
@@ -867,6 +860,16 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	dev = sblock_to_check->pagev[0]->dev;
 
 	/*
+	 * We must use GFP_NOFS because the scrub task might be waiting for a
+	 * worker task executing this function and in turn a transaction commit
+	 * might be waiting the scrub task to pause (which needs to wait for all
+	 * the worker tasks to complete before pausing).
+	 * We do allocations in the workers through insert_full_stripe_lock()
+	 * and scrub_add_page_to_wr_bio(), which happens down the call chain of
+	 * this function.
+	 */
+	nofs_flag = memalloc_nofs_save();
+	/*
 	 * For RAID5/6, race can happen for a different device scrub thread.
 	 * For data corruption, Parity and Data threads will both try
 	 * to recovery the data.
@@ -875,6 +878,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	 */
 	ret = lock_full_stripe(fs_info, logical, &full_stripe_locked);
 	if (ret < 0) {
+		memalloc_nofs_restore(nofs_flag);
 		spin_lock(&sctx->stat_lock);
 		if (ret == -ENOMEM)
 			sctx->stat.malloc_errors++;
@@ -914,7 +918,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	 */
 
 	sblocks_for_recheck = kcalloc(BTRFS_MAX_MIRRORS,
-				      sizeof(*sblocks_for_recheck), GFP_NOFS);
+				      sizeof(*sblocks_for_recheck), GFP_KERNEL);
 	if (!sblocks_for_recheck) {
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.malloc_errors++;
@@ -1212,6 +1216,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	}
 
 	ret = unlock_full_stripe(fs_info, logical, full_stripe_locked);
+	memalloc_nofs_restore(nofs_flag);
 	if (ret < 0)
 		return ret;
 	return 0;
@@ -1630,19 +1635,8 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 	mutex_lock(&sctx->wr_lock);
 again:
 	if (!sctx->wr_curr_bio) {
-		unsigned int nofs_flag;
-
-		/*
-		 * We must use GFP_NOFS because the scrub task might be waiting
-		 * for a worker task executing this function and in turn a
-		 * transaction commit might be waiting the scrub task to pause
-		 * (which needs to wait for all the worker tasks to complete
-		 * before pausing).
-		 */
-		nofs_flag = memalloc_nofs_save();
 		sctx->wr_curr_bio = kzalloc(sizeof(*sctx->wr_curr_bio),
 					      GFP_KERNEL);
-		memalloc_nofs_restore(nofs_flag);
 		if (!sctx->wr_curr_bio) {
 			mutex_unlock(&sctx->wr_lock);
 			return -ENOMEM;
-- 
2.11.0

