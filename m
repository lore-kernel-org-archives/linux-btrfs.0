Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2FLI2O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 04:28:14 -0400
From: Asias He <asias@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Asias He <asias@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dave@jikos.cz>
Subject: [PATCH v2] block: Drop dead function blk_abort_queue()
Date: Tue, 12 Jun 2012 16:29:02 +0800
Message-Id: <1339489742-1810-1-git-send-email-asias@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function was only used by btrfs code in btrfs_abort_devices()
(seems in a wrong way).

It was removed in commit d07eb9117050c9ed3f78296ebcc06128b52693be,
So, Let's remove the dead code to avoid any confusion.

Changes in v2: update commit log, btrfs_abort_devices() was removed
already.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Cc: David Sterba <dave@jikos.cz>
Signed-off-by: Asias He <asias@redhat.com>
---
 block/blk-timeout.c    |   41 -----------------------------------------
 include/linux/blkdev.h |    1 -
 2 files changed, 42 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 7803548..6e4744c 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -197,44 +197,3 @@ void blk_add_timer(struct request *req)
 		mod_timer(&q->timeout, expiry);
 }
 
-/**
- * blk_abort_queue -- Abort all request on given queue
- * @queue:	pointer to queue
- *
- */
-void blk_abort_queue(struct request_queue *q)
-{
-	unsigned long flags;
-	struct request *rq, *tmp;
-	LIST_HEAD(list);
-
-	/*
-	 * Not a request based block device, nothing to abort
-	 */
-	if (!q->request_fn)
-		return;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-
-	elv_abort_queue(q);
-
-	/*
-	 * Splice entries to local list, to avoid deadlocking if entries
-	 * get readded to the timeout list by error handling
-	 */
-	list_splice_init(&q->timeout_list, &list);
-
-	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
-		blk_abort_request(rq);
-
-	/*
-	 * Occasionally, blk_abort_request() will return without
-	 * deleting the element from the list. Make sure we add those back
-	 * instead of leaving them on the local stack list.
-	 */
-	list_splice(&list, &q->timeout_list);
-
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-}
-EXPORT_SYMBOL_GPL(blk_abort_queue);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba43f40..07954b0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -827,7 +827,6 @@ extern bool __blk_end_request_err(struct request *rq, int error);
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
-extern void blk_abort_queue(struct request_queue *);
 extern void blk_unprep_request(struct request *);
 
 /*
-- 
1.7.10.2

