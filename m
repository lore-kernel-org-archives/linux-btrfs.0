Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26785 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaHLOf1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 10:35:27 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7CEZPHZ008271
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 14:35:26 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7CEZOXk021501
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 14:35:25 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7CEZOC7010608
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 14:35:24 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: fix task hang under heavy compressed write
Date: Tue, 12 Aug 2014 22:35:01 +0800
Message-Id: <1407854101-31980-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
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
->ordered_free() to avoid that.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2:
   This changes a bit to not defer all ->ordered_free(), but only defer the work
   that triggers this run_ordered_work().  Actually we don't need to defer other
   ->ordered_free() because their work cannot be this kthread worker's
   @current_work.  We can benefit from it since this can pin less memory during
   the period.

 fs/btrfs/async-thread.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 5a201d8..9fa7e02 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -189,12 +189,14 @@ out:
 	}
 }
 
-static void run_ordered_work(struct __btrfs_workqueue *wq)
+static void run_ordered_work(struct __btrfs_workqueue *wq,
+			     struct btrfs_work *orig)
 {
 	struct list_head *list = &wq->ordered_list;
 	struct btrfs_work *work;
 	spinlock_t *lock = &wq->list_lock;
 	unsigned long flags;
+	bool delay_free = false;
 
 	while (1) {
 		spin_lock_irqsave(lock, flags);
@@ -226,10 +228,19 @@ static void run_ordered_work(struct __btrfs_workqueue *wq)
 		 * we don't want to call the ordered free functions
 		 * with the lock held though
 		 */
-		work->ordered_free(work);
-		trace_btrfs_all_work_done(work);
+		if (work == orig) {
+			delay_free = true;
+		} else {
+			work->ordered_free(work);
+			trace_btrfs_all_work_done(work);
+		}
 	}
 	spin_unlock_irqrestore(lock, flags);
+
+	if (delay_free) {
+		orig->ordered_free(orig);
+		trace_btrfs_all_work_done(orig);
+	}
 }
 
 static void normal_work_helper(struct work_struct *arg)
@@ -256,7 +267,7 @@ static void normal_work_helper(struct work_struct *arg)
 	work->func(work);
 	if (need_order) {
 		set_bit(WORK_DONE_BIT, &work->flags);
-		run_ordered_work(wq);
+		run_ordered_work(wq, work);
 	}
 	if (!need_order)
 		trace_btrfs_all_work_done(work);
-- 
1.8.1.4

