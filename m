Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723Ab2EYDJv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 23:09:51 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Asias He <asias@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 2/2] block: Drop dead function blk_abort_queue()
Date: Fri, 25 May 2012 11:10:22 +0800
Message-Id: <1337915422-24988-2-git-send-email-asias@redhat.com>
In-Reply-To: <1337915422-24988-1-git-send-email-asias@redhat.com>
References: <1337915422-24988-1-git-send-email-asias@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is only used by btrfs code in btrfs_abort_devices()
(seems in a wrong way). However, btrfs_abort_devices() is not used
anywhere. Let's remove the dead code to avoid any confusion.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org
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
index 4d4ac24..dcd9738 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -809,7 +809,6 @@ extern bool __blk_end_request_err(struct request *rq, int error);
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
-extern void blk_abort_queue(struct request_queue *);
 extern void blk_unprep_request(struct request *);
 
 /*
-- 
1.7.10.2

