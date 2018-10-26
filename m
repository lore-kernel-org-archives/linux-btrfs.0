Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BD5ECDE44
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 16:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BA002085B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 16:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUKgTG8G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BA002085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbeJ0AxG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 20:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbeJ0AxF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 20:53:05 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D74C20883
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 16:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540570525;
        bh=ftOPoItQtIcHR5YxYR8veQqxumgmju+oApz8vBUPxDU=;
        h=From:To:Subject:Date:From;
        b=BUKgTG8GtkZc/4mnDk0r2Rza8xm7ZWnAZPLP7+B9xNsjP924n+v6AF3z2FNb9snK5
         JAB6zyhu2q1NUgR3C0Mtg9Oreg1dc1moIrj6vmkmpleFQdFFx6plV//fw+5810dvM+
         35OIed4i1uxfmfYunYXhJlqlRHLCa8IALnsub6lk=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove no longer used stuff for tracking pending ordered extents
Date:   Fri, 26 Oct 2018 17:15:21 +0100
Message-Id: <20181026161521.7336-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Tracking pending ordered extents per transaction was introduced in commit
50d9aa99bd35 ("Btrfs: make sure logged extents complete in the current
transaction V3") and later updated in commit 161c3549b45a ("Btrfs: change
how we wait for pending ordered extents").

However now that on fsync we always wait for ordered extents to complete
before logging, done in commit 5636cf7d6dc8 ("btrfs: remove the logged
extents infrastructure"), we no longer need the stuff to track for pending
ordered extents, which was not completely removed in the mentioned commit.
So remove the remaining of the pending ordered extents infrastructure.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ordered-data.c | 30 ------------------------------
 fs/btrfs/ordered-data.h |  2 --
 fs/btrfs/transaction.c  | 11 -----------
 fs/btrfs/transaction.h  |  2 --
 4 files changed, 45 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 0c4ef208b8b9..6fde2b2741ef 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -460,7 +460,6 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
 	struct btrfs_root *root = btrfs_inode->root;
 	struct rb_node *node;
-	bool dec_pending_ordered = false;
 
 	/* This is paired with btrfs_add_ordered_extent. */
 	spin_lock(&btrfs_inode->lock);
@@ -477,37 +476,8 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	if (tree->last == node)
 		tree->last = NULL;
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
-	if (test_and_clear_bit(BTRFS_ORDERED_PENDING, &entry->flags))
-		dec_pending_ordered = true;
 	spin_unlock_irq(&tree->lock);
 
-	/*
-	 * The current running transaction is waiting on us, we need to let it
-	 * know that we're complete and wake it up.
-	 */
-	if (dec_pending_ordered) {
-		struct btrfs_transaction *trans;
-
-		/*
-		 * The checks for trans are just a formality, it should be set,
-		 * but if it isn't we don't want to deref/assert under the spin
-		 * lock, so be nice and check if trans is set, but ASSERT() so
-		 * if it isn't set a developer will notice.
-		 */
-		spin_lock(&fs_info->trans_lock);
-		trans = fs_info->running_transaction;
-		if (trans)
-			refcount_inc(&trans->use_count);
-		spin_unlock(&fs_info->trans_lock);
-
-		ASSERT(trans);
-		if (trans) {
-			if (atomic_dec_and_test(&trans->pending_ordered))
-				wake_up(&trans->pending_wait);
-			btrfs_put_transaction(trans);
-		}
-	}
-
 	spin_lock(&root->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
 	root->nr_ordered_extents--;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 02d813aaa261..b10e6765d88f 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -56,8 +56,6 @@ struct btrfs_ordered_sum {
 				       * the isize. */
 #define BTRFS_ORDERED_TRUNCATED 8 /* Set when we have to truncate an extent */
 
-#define BTRFS_ORDERED_PENDING 9 /* We are waiting for this ordered extent to
-				  * complete in the current transaction. */
 #define BTRFS_ORDERED_REGULAR 10 /* Regular IO for COW */
 
 struct btrfs_ordered_extent {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3b84f5015029..2fe6c2b1d94b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -232,14 +232,12 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	extwriter_counter_init(cur_trans, type);
 	init_waitqueue_head(&cur_trans->writer_wait);
 	init_waitqueue_head(&cur_trans->commit_wait);
-	init_waitqueue_head(&cur_trans->pending_wait);
 	cur_trans->state = TRANS_STATE_RUNNING;
 	/*
 	 * One for this trans handle, one so it will live on until we
 	 * commit the transaction.
 	 */
 	refcount_set(&cur_trans->use_count, 2);
-	atomic_set(&cur_trans->pending_ordered, 0);
 	cur_trans->flags = 0;
 	cur_trans->start_time = ktime_get_seconds();
 
@@ -1908,13 +1906,6 @@ static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
 		btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 }
 
-static inline void
-btrfs_wait_pending_ordered(struct btrfs_transaction *cur_trans)
-{
-	wait_event(cur_trans->pending_wait,
-		   atomic_read(&cur_trans->pending_ordered) == 0);
-}
-
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
@@ -2049,8 +2040,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	btrfs_wait_delalloc_flush(fs_info);
 
-	btrfs_wait_pending_ordered(cur_trans);
-
 	btrfs_scrub_pause(fs_info);
 	/*
 	 * Ok now we need to make sure to block out any other joins while we
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 4cbb1b55387d..703d5116a2fc 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -39,7 +39,6 @@ struct btrfs_transaction {
 	 */
 	atomic_t num_writers;
 	refcount_t use_count;
-	atomic_t pending_ordered;
 
 	unsigned long flags;
 
@@ -51,7 +50,6 @@ struct btrfs_transaction {
 	time64_t start_time;
 	wait_queue_head_t writer_wait;
 	wait_queue_head_t commit_wait;
-	wait_queue_head_t pending_wait;
 	struct list_head pending_snapshots;
 	struct list_head pending_chunks;
 	struct list_head switch_commits;
-- 
2.11.0

