Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B77BC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 20:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F062205C9
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 20:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9j8ZNAu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F062205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbeK0HCg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 02:02:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:32898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbeK0HCg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 02:02:36 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB63A205C9
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 20:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543262841;
        bh=Bl7uWHQ2F7Xghc9N2H/l6At5Mk2jBWj0m2MLAETXEJQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=t9j8ZNAuTeNjA8no7XCOO6zNuc8m2Gk8DmZ3hDc06wJrBagvxXFaCgCKWI4+hkhFE
         2KNlShSMYRbmms3ec56eyLQiWnWk4peiF6H4e67Fl9mLclnS2Mvn8pNoKm5ZSx9AOJ
         WyQF2iYcYfaupuhzpwr8xGeTNV4eWetvBL27LIQQ=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5] Btrfs: fix deadlock with memory reclaim during scrub
Date:   Mon, 26 Nov 2018 20:07:17 +0000
Message-Id: <20181126200717.4546-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181123134543.20199-1-fdmanana@kernel.org>
References: <20181123134543.20199-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When a transaction commit starts, it attempts to pause scrub and it blocks
until the scrub is paused. So while the transaction is blocked waiting for
scrub to pause, we can not do memory allocation with GFP_KERNEL from scrub,
otherwise we risk getting into a deadlock with reclaim.

Checking for scrub pause requests is done early at the beginning of the
while loop of scrub_stripe() and later in the loop, scrub_extent() and
scrub_raid56_parity() are called, which in turn call scrub_pages() and
scrub_pages_for_parity() respectively. These last two functions do memory
allocations using GFP_KERNEL. Same problem could happen while scrubbing
the super blocks, since it calls scrub_pages().

We also can not have any of the worker tasks, created by the scrub task,
doing GFP_KERNEL allocations, because before pausing, the scrub task waits
for all the worker tasks to complete (also done at scrub_stripe()).

So make sure GFP_NOFS is used for the memory allocations because at any
time a scrub pause request can happen from another task that started to
commit a transaction.

Fixes: 58c4e173847a ("btrfs: scrub: use GFP_KERNEL on the submission path")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Make using GFP_NOFS unconditionial. Previous version was racy, as pausing
requests migth happen just after we checked for them.

V3: Use memalloc_nofs_save() just like V1 did.

V4: Similar problem happened for raid56, which was previously missed, so
    deal with it as well as the case for scrub_supers().

V5: Make sure worker tasks, created by scrub, also don't do GFP_KERNEL
    allocations, because in order to pause, the scrub task waits for all
    the workers to complete first.

 fs/btrfs/scrub.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 3be1456b5116..392f8a7f65ab 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -322,6 +322,7 @@ static struct full_stripe_lock *insert_full_stripe_lock(
 	struct rb_node *parent = NULL;
 	struct full_stripe_lock *entry;
 	struct full_stripe_lock *ret;
+	unsigned int nofs_flag;
 
 	lockdep_assert_held(&locks_root->lock);
 
@@ -339,8 +340,17 @@ static struct full_stripe_lock *insert_full_stripe_lock(
 		}
 	}
 
-	/* Insert new lock */
+	/*
+	 * Insert new lock.
+	 *
+	 * We must use GFP_NOFS because the scrub task might be waiting for a
+	 * worker task executing this function and in turn a transaction commit
+	 * might be waiting the scrub task to pause (which needs to wait for all
+	 * the worker tasks to complete before pausing).
+	 */
+	nofs_flag = memalloc_nofs_save();
 	ret = kmalloc(sizeof(*ret), GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 	ret->logical = fstripe_logical;
@@ -1622,8 +1632,19 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 	mutex_lock(&sctx->wr_lock);
 again:
 	if (!sctx->wr_curr_bio) {
+		unsigned int nofs_flag;
+
+		/*
+		 * We must use GFP_NOFS because the scrub task might be waiting
+		 * for a worker task executing this function and in turn a
+		 * transaction commit might be waiting the scrub task to pause
+		 * (which needs to wait for all the worker tasks to complete
+		 * before pausing).
+		 */
+		nofs_flag = memalloc_nofs_save();
 		sctx->wr_curr_bio = kzalloc(sizeof(*sctx->wr_curr_bio),
 					      GFP_KERNEL);
+		memalloc_nofs_restore(nofs_flag);
 		if (!sctx->wr_curr_bio) {
 			mutex_unlock(&sctx->wr_lock);
 			return -ENOMEM;
@@ -3779,6 +3800,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	struct scrub_ctx *sctx;
 	int ret;
 	struct btrfs_device *dev;
+	unsigned int nofs_flag;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EINVAL;
@@ -3882,6 +3904,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	atomic_inc(&fs_info->scrubs_running);
 	mutex_unlock(&fs_info->scrub_lock);
 
+	/*
+	 * In order to avoid deadlock with reclaim when there is a transaction
+	 * trying to pause scrub, make sure we use GFP_NOFS for all the
+	 * allocations done at btrfs_scrub_pages() and scrub_pages_for_parity()
+	 * invoked by our callees. The pausing request is done when the
+	 * transaction commit starts, and it blocks the transaction until scrub
+	 * is paused (done at specific points at scrub_stripe() or right above
+	 * before incrementing fs_info->scrubs_running).
+	 */
+	nofs_flag = memalloc_nofs_save();
 	if (!is_dev_replace) {
 		/*
 		 * by holding device list mutex, we can
@@ -3895,6 +3927,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (!ret)
 		ret = scrub_enumerate_chunks(sctx, dev, start, end,
 					     is_dev_replace);
+	memalloc_nofs_restore(nofs_flag);
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->bios_in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
-- 
2.11.0

