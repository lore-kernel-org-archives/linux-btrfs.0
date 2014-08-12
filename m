Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21852 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaHLHpa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 03:45:30 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Chris Mason <clm@fb.com>, miaox@cn.fujitsu.com,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Marc MERLIN <marc@merlins.org>,
        =?UTF-8?q?Torbj=C3=B8rn?= <lists@skagestad.org>
Subject: [PATCH] Btrfs: fix task hang under heavy compressed write
Date: Tue, 12 Aug 2014 15:44:59 +0800
Message-Id: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been reported and discussed for a long time, and this hang occurs in
both 3.15 and 3.16.

Btrfs now migrates to use kernel workqueue, but it introduces this hang problem.

Btrfs has a kind of work queued as an ordered way, which means that its
ordered_func() must be processed in the way of FIFO, so it usually looks like --

normal_work_helper(arg)
    work = container_of(arg, struct btrfs_work, normal_work);

    work->func() <---- (we name it work X)
    for ordered_work in wq->ordered_list
            ordered_work->ordered_func()
            ordered_work->ordered_free()

The hang is a rare case, first when we find free space, we get an uncached block
group, then we go to read its free space cache inode for free space information,
so it will

file a readahead request
    btrfs_readpages()
         for page that is not in page cache
                __do_readpage()
                     submit_extent_page()
                           btrfs_submit_bio_hook()
                                 btrfs_bio_wq_end_io()
                                 submit_bio()
                                 end_workqueue_bio() <--(ret by the 1st endio)
                                      queue a work(named work Y) for the 2nd
                                      also the real endio()

So the hang occurs when work Y's work_struct and work X's work_struct happens
to share the same address.

A bit more explanation,

A,B,C -- struct btrfs_work
arg   -- struct work_struct

kthread:
worker_thread()
    pick up a work_struct from @worklist
    process_one_work(arg)
	worker->current_work = arg;  <-- arg is A->normal_work
	worker->current_func(arg)
		normal_work_helper(arg)
		     A = container_of(arg, struct btrfs_work, normal_work);

		     A->func()
		     A->ordered_func()
		     A->ordered_free()  <-- A gets freed

		     B->ordered_func()
			  submit_compressed_extents()
			      find_free_extent()
				  load_free_space_inode()
				      ...   <-- (the above readhead stack)
				      end_workqueue_bio()
					   btrfs_queue_work(work C)
		     B->ordered_free()

As if work A has a high priority in wq->ordered_list and there are more ordered
works queued after it, such as B->ordered_func(), its memory could have been
freed before normal_work_helper() returns, which means that kernel workqueue
code worker_thread() still has worker->current_work pointer to be work
A->normal_work's, ie. arg's address.

Meanwhile, work C is allocated after work A is freed, work C->normal_work
and work A->normal_work are likely to share the same address(I confirmed this
with ftrace output, so I'm not just guessing, it's rare though).

When another kthread picks up work C->normal_work to process, and finds our
kthread is processing it(see find_worker_executing_work()), it'll think
work C as a collision and skip then, which ends up nobody processing work C.

So the situation is that our kthread is waiting forever on work C.

The key point is that they shouldn't have the same address, so this defers
->ordered_free() and does a batched free to avoid that.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/async-thread.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 5a201d8..2ac01b3 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -195,6 +195,7 @@ static void run_ordered_work(struct __btrfs_workqueue *wq)
 	struct btrfs_work *work;
 	spinlock_t *lock = &wq->list_lock;
 	unsigned long flags;
+	LIST_HEAD(free_list);
 
 	while (1) {
 		spin_lock_irqsave(lock, flags);
@@ -219,17 +220,24 @@ static void run_ordered_work(struct __btrfs_workqueue *wq)
 
 		/* now take the lock again and drop our item from the list */
 		spin_lock_irqsave(lock, flags);
-		list_del(&work->ordered_list);
+		list_move_tail(&work->ordered_list, &free_list);
 		spin_unlock_irqrestore(lock, flags);
 
 		/*
 		 * we don't want to call the ordered free functions
 		 * with the lock held though
 		 */
+	}
+	spin_unlock_irqrestore(lock, flags);
+
+	while (!list_empty(&free_list)) {
+		work = list_entry(free_list.next, struct btrfs_work,
+				  ordered_list);
+
+		list_del(&work->ordered_list);
 		work->ordered_free(work);
 		trace_btrfs_all_work_done(work);
 	}
-	spin_unlock_irqrestore(lock, flags);
 }
 
 static void normal_work_helper(struct work_struct *arg)
-- 
1.8.1.4

