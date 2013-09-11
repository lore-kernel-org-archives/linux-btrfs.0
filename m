Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65155 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab3IKIwD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 04:52:03 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8B8pqdc019953
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 16:51:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 8/9] btrfs: Cleanup the old btrfs workqueue
Date: Wed, 11 Sep 2013 16:52:37 +0800
Message-Id: <1378889558-21514-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the patches before implemented the new kernel workqueue based
btrfs_worqueue_struct, the old btrfs workqueue(btrfs_worker) can be
removed without any problem.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/Makefile       |   2 +-
 fs/btrfs/async-thread.c | 714 ------------------------------------------------
 fs/btrfs/async-thread.h | 119 --------
 fs/btrfs/ctree.h        |   3 -
 fs/btrfs/dev-replace.c  |   1 -
 fs/btrfs/disk-io.c      |  24 +-
 fs/btrfs/raid56.c       |   1 -
 fs/btrfs/relocation.c   |   1 -
 fs/btrfs/super.c        |   8 -
 fs/btrfs/volumes.c      |   1 -
 fs/btrfs/volumes.h      |   1 -
 11 files changed, 10 insertions(+), 865 deletions(-)
 delete mode 100644 fs/btrfs/async-thread.c
 delete mode 100644 fs/btrfs/async-thread.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index d7439df..e2162af 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -5,7 +5,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
-	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
+	   extent_io.o volumes.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
deleted file mode 100644
index 58b7d14..0000000
--- a/fs/btrfs/async-thread.c
+++ /dev/null
@@ -1,714 +0,0 @@
-/*
- * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/kthread.h>
-#include <linux/slab.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/freezer.h>
-#include "async-thread.h"
-
-#define WORK_QUEUED_BIT 0
-#define WORK_DONE_BIT 1
-#define WORK_ORDER_DONE_BIT 2
-#define WORK_HIGH_PRIO_BIT 3
-
-/*
- * container for the kthread task pointer and the list of pending work
- * One of these is allocated per thread.
- */
-struct btrfs_worker_thread {
-	/* pool we belong to */
-	struct btrfs_workers *workers;
-
-	/* list of struct btrfs_work that are waiting for service */
-	struct list_head pending;
-	struct list_head prio_pending;
-
-	/* list of worker threads from struct btrfs_workers */
-	struct list_head worker_list;
-
-	/* kthread */
-	struct task_struct *task;
-
-	/* number of things on the pending list */
-	atomic_t num_pending;
-
-	/* reference counter for this struct */
-	atomic_t refs;
-
-	unsigned long sequence;
-
-	/* protects the pending list. */
-	spinlock_t lock;
-
-	/* set to non-zero when this thread is already awake and kicking */
-	int working;
-
-	/* are we currently idle */
-	int idle;
-};
-
-static int __btrfs_start_workers(struct btrfs_workers *workers);
-
-/*
- * btrfs_start_workers uses kthread_run, which can block waiting for memory
- * for a very long time.  It will actually throttle on page writeback,
- * and so it may not make progress until after our btrfs worker threads
- * process all of the pending work structs in their queue
- *
- * This means we can't use btrfs_start_workers from inside a btrfs worker
- * thread that is used as part of cleaning dirty memory, which pretty much
- * involves all of the worker threads.
- *
- * Instead we have a helper queue who never has more than one thread
- * where we scheduler thread start operations.  This worker_start struct
- * is used to contain the work and hold a pointer to the queue that needs
- * another worker.
- */
-struct worker_start {
-	struct btrfs_work work;
-	struct btrfs_workers *queue;
-};
-
-static void start_new_worker_func(struct btrfs_work *work)
-{
-	struct worker_start *start;
-	start = container_of(work, struct worker_start, work);
-	__btrfs_start_workers(start->queue);
-	kfree(start);
-}
-
-/*
- * helper function to move a thread onto the idle list after it
- * has finished some requests.
- */
-static void check_idle_worker(struct btrfs_worker_thread *worker)
-{
-	if (!worker->idle && atomic_read(&worker->num_pending) <
-	    worker->workers->idle_thresh / 2) {
-		unsigned long flags;
-		spin_lock_irqsave(&worker->workers->lock, flags);
-		worker->idle = 1;
-
-		/* the list may be empty if the worker is just starting */
-		if (!list_empty(&worker->worker_list)) {
-			list_move(&worker->worker_list,
-				 &worker->workers->idle_list);
-		}
-		spin_unlock_irqrestore(&worker->workers->lock, flags);
-	}
-}
-
-/*
- * helper function to move a thread off the idle list after new
- * pending work is added.
- */
-static void check_busy_worker(struct btrfs_worker_thread *worker)
-{
-	if (worker->idle && atomic_read(&worker->num_pending) >=
-	    worker->workers->idle_thresh) {
-		unsigned long flags;
-		spin_lock_irqsave(&worker->workers->lock, flags);
-		worker->idle = 0;
-
-		if (!list_empty(&worker->worker_list)) {
-			list_move_tail(&worker->worker_list,
-				      &worker->workers->worker_list);
-		}
-		spin_unlock_irqrestore(&worker->workers->lock, flags);
-	}
-}
-
-static void check_pending_worker_creates(struct btrfs_worker_thread *worker)
-{
-	struct btrfs_workers *workers = worker->workers;
-	struct worker_start *start;
-	unsigned long flags;
-
-	rmb();
-	if (!workers->atomic_start_pending)
-		return;
-
-	start = kzalloc(sizeof(*start), GFP_NOFS);
-	if (!start)
-		return;
-
-	start->work.func = start_new_worker_func;
-	start->queue = workers;
-
-	spin_lock_irqsave(&workers->lock, flags);
-	if (!workers->atomic_start_pending)
-		goto out;
-
-	workers->atomic_start_pending = 0;
-	if (workers->num_workers + workers->num_workers_starting >=
-	    workers->max_workers)
-		goto out;
-
-	workers->num_workers_starting += 1;
-	spin_unlock_irqrestore(&workers->lock, flags);
-	btrfs_queue_worker(workers->atomic_worker_start, &start->work);
-	return;
-
-out:
-	kfree(start);
-	spin_unlock_irqrestore(&workers->lock, flags);
-}
-
-static noinline void run_ordered_completions(struct btrfs_workers *workers,
-					    struct btrfs_work *work)
-{
-	if (!workers->ordered)
-		return;
-
-	set_bit(WORK_DONE_BIT, &work->flags);
-
-	spin_lock(&workers->order_lock);
-
-	while (1) {
-		if (!list_empty(&workers->prio_order_list)) {
-			work = list_entry(workers->prio_order_list.next,
-					  struct btrfs_work, order_list);
-		} else if (!list_empty(&workers->order_list)) {
-			work = list_entry(workers->order_list.next,
-					  struct btrfs_work, order_list);
-		} else {
-			break;
-		}
-		if (!test_bit(WORK_DONE_BIT, &work->flags))
-			break;
-
-		/* we are going to call the ordered done function, but
-		 * we leave the work item on the list as a barrier so
-		 * that later work items that are done don't have their
-		 * functions called before this one returns
-		 */
-		if (test_and_set_bit(WORK_ORDER_DONE_BIT, &work->flags))
-			break;
-
-		spin_unlock(&workers->order_lock);
-
-		work->ordered_func(work);
-
-		/* now take the lock again and drop our item from the list */
-		spin_lock(&workers->order_lock);
-		list_del(&work->order_list);
-		spin_unlock(&workers->order_lock);
-
-		/*
-		 * we don't want to call the ordered free functions
-		 * with the lock held though
-		 */
-		work->ordered_free(work);
-		spin_lock(&workers->order_lock);
-	}
-
-	spin_unlock(&workers->order_lock);
-}
-
-static void put_worker(struct btrfs_worker_thread *worker)
-{
-	if (atomic_dec_and_test(&worker->refs))
-		kfree(worker);
-}
-
-static int try_worker_shutdown(struct btrfs_worker_thread *worker)
-{
-	int freeit = 0;
-
-	spin_lock_irq(&worker->lock);
-	spin_lock(&worker->workers->lock);
-	if (worker->workers->num_workers > 1 &&
-	    worker->idle &&
-	    !worker->working &&
-	    !list_empty(&worker->worker_list) &&
-	    list_empty(&worker->prio_pending) &&
-	    list_empty(&worker->pending) &&
-	    atomic_read(&worker->num_pending) == 0) {
-		freeit = 1;
-		list_del_init(&worker->worker_list);
-		worker->workers->num_workers--;
-	}
-	spin_unlock(&worker->workers->lock);
-	spin_unlock_irq(&worker->lock);
-
-	if (freeit)
-		put_worker(worker);
-	return freeit;
-}
-
-static struct btrfs_work *get_next_work(struct btrfs_worker_thread *worker,
-					struct list_head *prio_head,
-					struct list_head *head)
-{
-	struct btrfs_work *work = NULL;
-	struct list_head *cur = NULL;
-
-	if(!list_empty(prio_head))
-		cur = prio_head->next;
-
-	smp_mb();
-	if (!list_empty(&worker->prio_pending))
-		goto refill;
-
-	if (!list_empty(head))
-		cur = head->next;
-
-	if (cur)
-		goto out;
-
-refill:
-	spin_lock_irq(&worker->lock);
-	list_splice_tail_init(&worker->prio_pending, prio_head);
-	list_splice_tail_init(&worker->pending, head);
-
-	if (!list_empty(prio_head))
-		cur = prio_head->next;
-	else if (!list_empty(head))
-		cur = head->next;
-	spin_unlock_irq(&worker->lock);
-
-	if (!cur)
-		goto out_fail;
-
-out:
-	work = list_entry(cur, struct btrfs_work, list);
-
-out_fail:
-	return work;
-}
-
-/*
- * main loop for servicing work items
- */
-static int worker_loop(void *arg)
-{
-	struct btrfs_worker_thread *worker = arg;
-	struct list_head head;
-	struct list_head prio_head;
-	struct btrfs_work *work;
-
-	INIT_LIST_HEAD(&head);
-	INIT_LIST_HEAD(&prio_head);
-
-	do {
-again:
-		while (1) {
-
-
-			work = get_next_work(worker, &prio_head, &head);
-			if (!work)
-				break;
-
-			list_del(&work->list);
-			clear_bit(WORK_QUEUED_BIT, &work->flags);
-
-			work->worker = worker;
-
-			work->func(work);
-
-			atomic_dec(&worker->num_pending);
-			/*
-			 * unless this is an ordered work queue,
-			 * 'work' was probably freed by func above.
-			 */
-			run_ordered_completions(worker->workers, work);
-
-			check_pending_worker_creates(worker);
-			cond_resched();
-		}
-
-		spin_lock_irq(&worker->lock);
-		check_idle_worker(worker);
-
-		if (freezing(current)) {
-			worker->working = 0;
-			spin_unlock_irq(&worker->lock);
-			try_to_freeze();
-		} else {
-			spin_unlock_irq(&worker->lock);
-			if (!kthread_should_stop()) {
-				cpu_relax();
-				/*
-				 * we've dropped the lock, did someone else
-				 * jump_in?
-				 */
-				smp_mb();
-				if (!list_empty(&worker->pending) ||
-				    !list_empty(&worker->prio_pending))
-					continue;
-
-				/*
-				 * this short schedule allows more work to
-				 * come in without the queue functions
-				 * needing to go through wake_up_process()
-				 *
-				 * worker->working is still 1, so nobody
-				 * is going to try and wake us up
-				 */
-				schedule_timeout(1);
-				smp_mb();
-				if (!list_empty(&worker->pending) ||
-				    !list_empty(&worker->prio_pending))
-					continue;
-
-				if (kthread_should_stop())
-					break;
-
-				/* still no more work?, sleep for real */
-				spin_lock_irq(&worker->lock);
-				set_current_state(TASK_INTERRUPTIBLE);
-				if (!list_empty(&worker->pending) ||
-				    !list_empty(&worker->prio_pending)) {
-					spin_unlock_irq(&worker->lock);
-					set_current_state(TASK_RUNNING);
-					goto again;
-				}
-
-				/*
-				 * this makes sure we get a wakeup when someone
-				 * adds something new to the queue
-				 */
-				worker->working = 0;
-				spin_unlock_irq(&worker->lock);
-
-				if (!kthread_should_stop()) {
-					schedule_timeout(HZ * 120);
-					if (!worker->working &&
-					    try_worker_shutdown(worker)) {
-						return 0;
-					}
-				}
-			}
-			__set_current_state(TASK_RUNNING);
-		}
-	} while (!kthread_should_stop());
-	return 0;
-}
-
-/*
- * this will wait for all the worker threads to shutdown
- */
-void btrfs_stop_workers(struct btrfs_workers *workers)
-{
-	struct list_head *cur;
-	struct btrfs_worker_thread *worker;
-	int can_stop;
-
-	spin_lock_irq(&workers->lock);
-	list_splice_init(&workers->idle_list, &workers->worker_list);
-	while (!list_empty(&workers->worker_list)) {
-		cur = workers->worker_list.next;
-		worker = list_entry(cur, struct btrfs_worker_thread,
-				    worker_list);
-
-		atomic_inc(&worker->refs);
-		workers->num_workers -= 1;
-		if (!list_empty(&worker->worker_list)) {
-			list_del_init(&worker->worker_list);
-			put_worker(worker);
-			can_stop = 1;
-		} else
-			can_stop = 0;
-		spin_unlock_irq(&workers->lock);
-		if (can_stop)
-			kthread_stop(worker->task);
-		spin_lock_irq(&workers->lock);
-		put_worker(worker);
-	}
-	spin_unlock_irq(&workers->lock);
-}
-
-/*
- * simple init on struct btrfs_workers
- */
-void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
-			struct btrfs_workers *async_helper)
-{
-	workers->num_workers = 0;
-	workers->num_workers_starting = 0;
-	INIT_LIST_HEAD(&workers->worker_list);
-	INIT_LIST_HEAD(&workers->idle_list);
-	INIT_LIST_HEAD(&workers->order_list);
-	INIT_LIST_HEAD(&workers->prio_order_list);
-	spin_lock_init(&workers->lock);
-	spin_lock_init(&workers->order_lock);
-	workers->max_workers = max;
-	workers->idle_thresh = 32;
-	workers->name = name;
-	workers->ordered = 0;
-	workers->atomic_start_pending = 0;
-	workers->atomic_worker_start = async_helper;
-}
-
-/*
- * starts new worker threads.  This does not enforce the max worker
- * count in case you need to temporarily go past it.
- */
-static int __btrfs_start_workers(struct btrfs_workers *workers)
-{
-	struct btrfs_worker_thread *worker;
-	int ret = 0;
-
-	worker = kzalloc(sizeof(*worker), GFP_NOFS);
-	if (!worker) {
-		ret = -ENOMEM;
-		goto fail;
-	}
-
-	INIT_LIST_HEAD(&worker->pending);
-	INIT_LIST_HEAD(&worker->prio_pending);
-	INIT_LIST_HEAD(&worker->worker_list);
-	spin_lock_init(&worker->lock);
-
-	atomic_set(&worker->num_pending, 0);
-	atomic_set(&worker->refs, 1);
-	worker->workers = workers;
-	worker->task = kthread_run(worker_loop, worker,
-				   "btrfs-%s-%d", workers->name,
-				   workers->num_workers + 1);
-	if (IS_ERR(worker->task)) {
-		ret = PTR_ERR(worker->task);
-		kfree(worker);
-		goto fail;
-	}
-	spin_lock_irq(&workers->lock);
-	list_add_tail(&worker->worker_list, &workers->idle_list);
-	worker->idle = 1;
-	workers->num_workers++;
-	workers->num_workers_starting--;
-	WARN_ON(workers->num_workers_starting < 0);
-	spin_unlock_irq(&workers->lock);
-
-	return 0;
-fail:
-	spin_lock_irq(&workers->lock);
-	workers->num_workers_starting--;
-	spin_unlock_irq(&workers->lock);
-	return ret;
-}
-
-int btrfs_start_workers(struct btrfs_workers *workers)
-{
-	spin_lock_irq(&workers->lock);
-	workers->num_workers_starting++;
-	spin_unlock_irq(&workers->lock);
-	return __btrfs_start_workers(workers);
-}
-
-/*
- * run through the list and find a worker thread that doesn't have a lot
- * to do right now.  This can return null if we aren't yet at the thread
- * count limit and all of the threads are busy.
- */
-static struct btrfs_worker_thread *next_worker(struct btrfs_workers *workers)
-{
-	struct btrfs_worker_thread *worker;
-	struct list_head *next;
-	int enforce_min;
-
-	enforce_min = (workers->num_workers + workers->num_workers_starting) <
-		workers->max_workers;
-
-	/*
-	 * if we find an idle thread, don't move it to the end of the
-	 * idle list.  This improves the chance that the next submission
-	 * will reuse the same thread, and maybe catch it while it is still
-	 * working
-	 */
-	if (!list_empty(&workers->idle_list)) {
-		next = workers->idle_list.next;
-		worker = list_entry(next, struct btrfs_worker_thread,
-				    worker_list);
-		return worker;
-	}
-	if (enforce_min || list_empty(&workers->worker_list))
-		return NULL;
-
-	/*
-	 * if we pick a busy task, move the task to the end of the list.
-	 * hopefully this will keep things somewhat evenly balanced.
-	 * Do the move in batches based on the sequence number.  This groups
-	 * requests submitted at roughly the same time onto the same worker.
-	 */
-	next = workers->worker_list.next;
-	worker = list_entry(next, struct btrfs_worker_thread, worker_list);
-	worker->sequence++;
-
-	if (worker->sequence % workers->idle_thresh == 0)
-		list_move_tail(next, &workers->worker_list);
-	return worker;
-}
-
-/*
- * selects a worker thread to take the next job.  This will either find
- * an idle worker, start a new worker up to the max count, or just return
- * one of the existing busy workers.
- */
-static struct btrfs_worker_thread *find_worker(struct btrfs_workers *workers)
-{
-	struct btrfs_worker_thread *worker;
-	unsigned long flags;
-	struct list_head *fallback;
-	int ret;
-
-	spin_lock_irqsave(&workers->lock, flags);
-again:
-	worker = next_worker(workers);
-
-	if (!worker) {
-		if (workers->num_workers + workers->num_workers_starting >=
-		    workers->max_workers) {
-			goto fallback;
-		} else if (workers->atomic_worker_start) {
-			workers->atomic_start_pending = 1;
-			goto fallback;
-		} else {
-			workers->num_workers_starting++;
-			spin_unlock_irqrestore(&workers->lock, flags);
-			/* we're below the limit, start another worker */
-			ret = __btrfs_start_workers(workers);
-			spin_lock_irqsave(&workers->lock, flags);
-			if (ret)
-				goto fallback;
-			goto again;
-		}
-	}
-	goto found;
-
-fallback:
-	fallback = NULL;
-	/*
-	 * we have failed to find any workers, just
-	 * return the first one we can find.
-	 */
-	if (!list_empty(&workers->worker_list))
-		fallback = workers->worker_list.next;
-	if (!list_empty(&workers->idle_list))
-		fallback = workers->idle_list.next;
-	BUG_ON(!fallback);
-	worker = list_entry(fallback,
-		  struct btrfs_worker_thread, worker_list);
-found:
-	/*
-	 * this makes sure the worker doesn't exit before it is placed
-	 * onto a busy/idle list
-	 */
-	atomic_inc(&worker->num_pending);
-	spin_unlock_irqrestore(&workers->lock, flags);
-	return worker;
-}
-
-/*
- * btrfs_requeue_work just puts the work item back on the tail of the list
- * it was taken from.  It is intended for use with long running work functions
- * that make some progress and want to give the cpu up for others.
- */
-void btrfs_requeue_work(struct btrfs_work *work)
-{
-	struct btrfs_worker_thread *worker = work->worker;
-	unsigned long flags;
-	int wake = 0;
-
-	if (test_and_set_bit(WORK_QUEUED_BIT, &work->flags))
-		return;
-
-	spin_lock_irqsave(&worker->lock, flags);
-	if (test_bit(WORK_HIGH_PRIO_BIT, &work->flags))
-		list_add_tail(&work->list, &worker->prio_pending);
-	else
-		list_add_tail(&work->list, &worker->pending);
-	atomic_inc(&worker->num_pending);
-
-	/* by definition we're busy, take ourselves off the idle
-	 * list
-	 */
-	if (worker->idle) {
-		spin_lock(&worker->workers->lock);
-		worker->idle = 0;
-		list_move_tail(&worker->worker_list,
-			      &worker->workers->worker_list);
-		spin_unlock(&worker->workers->lock);
-	}
-	if (!worker->working) {
-		wake = 1;
-		worker->working = 1;
-	}
-
-	if (wake)
-		wake_up_process(worker->task);
-	spin_unlock_irqrestore(&worker->lock, flags);
-}
-
-void btrfs_set_work_high_prio(struct btrfs_work *work)
-{
-	set_bit(WORK_HIGH_PRIO_BIT, &work->flags);
-}
-
-/*
- * places a struct btrfs_work into the pending queue of one of the kthreads
- */
-void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work)
-{
-	struct btrfs_worker_thread *worker;
-	unsigned long flags;
-	int wake = 0;
-
-	/* don't requeue something already on a list */
-	if (test_and_set_bit(WORK_QUEUED_BIT, &work->flags))
-		return;
-
-	worker = find_worker(workers);
-	if (workers->ordered) {
-		/*
-		 * you're not allowed to do ordered queues from an
-		 * interrupt handler
-		 */
-		spin_lock(&workers->order_lock);
-		if (test_bit(WORK_HIGH_PRIO_BIT, &work->flags)) {
-			list_add_tail(&work->order_list,
-				      &workers->prio_order_list);
-		} else {
-			list_add_tail(&work->order_list, &workers->order_list);
-		}
-		spin_unlock(&workers->order_lock);
-	} else {
-		INIT_LIST_HEAD(&work->order_list);
-	}
-
-	spin_lock_irqsave(&worker->lock, flags);
-
-	if (test_bit(WORK_HIGH_PRIO_BIT, &work->flags))
-		list_add_tail(&work->list, &worker->prio_pending);
-	else
-		list_add_tail(&work->list, &worker->pending);
-	check_busy_worker(worker);
-
-	/*
-	 * avoid calling into wake_up_process if this thread has already
-	 * been kicked
-	 */
-	if (!worker->working)
-		wake = 1;
-	worker->working = 1;
-
-	if (wake)
-		wake_up_process(worker->task);
-	spin_unlock_irqrestore(&worker->lock, flags);
-}
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
deleted file mode 100644
index 063698b..0000000
--- a/fs/btrfs/async-thread.h
+++ /dev/null
@@ -1,119 +0,0 @@
-/*
- * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef __BTRFS_ASYNC_THREAD_
-#define __BTRFS_ASYNC_THREAD_
-
-struct btrfs_worker_thread;
-
-/*
- * This is similar to a workqueue, but it is meant to spread the operations
- * across all available cpus instead of just the CPU that was used to
- * queue the work.  There is also some batching introduced to try and
- * cut down on context switches.
- *
- * By default threads are added on demand up to 2 * the number of cpus.
- * Changing struct btrfs_workers->max_workers is one way to prevent
- * demand creation of kthreads.
- *
- * the basic model of these worker threads is to embed a btrfs_work
- * structure in your own data struct, and use container_of in a
- * work function to get back to your data struct.
- */
-struct btrfs_work {
-	/*
-	 * func should be set to the function you want called
-	 * your work struct is passed as the only arg
-	 *
-	 * ordered_func must be set for work sent to an ordered work queue,
-	 * and it is called to complete a given work item in the same
-	 * order they were sent to the queue.
-	 */
-	void (*func)(struct btrfs_work *work);
-	void (*ordered_func)(struct btrfs_work *work);
-	void (*ordered_free)(struct btrfs_work *work);
-
-	/*
-	 * flags should be set to zero.  It is used to make sure the
-	 * struct is only inserted once into the list.
-	 */
-	unsigned long flags;
-
-	/* don't touch these */
-	struct btrfs_worker_thread *worker;
-	struct list_head list;
-	struct list_head order_list;
-};
-
-struct btrfs_workers {
-	/* current number of running workers */
-	int num_workers;
-
-	int num_workers_starting;
-
-	/* max number of workers allowed.  changed by btrfs_start_workers */
-	int max_workers;
-
-	/* once a worker has this many requests or fewer, it is idle */
-	int idle_thresh;
-
-	/* force completions in the order they were queued */
-	int ordered;
-
-	/* more workers required, but in an interrupt handler */
-	int atomic_start_pending;
-
-	/*
-	 * are we allowed to sleep while starting workers or are we required
-	 * to start them at a later time?  If we can't sleep, this indicates
-	 * which queue we need to use to schedule thread creation.
-	 */
-	struct btrfs_workers *atomic_worker_start;
-
-	/* list with all the work threads.  The workers on the idle thread
-	 * may be actively servicing jobs, but they haven't yet hit the
-	 * idle thresh limit above.
-	 */
-	struct list_head worker_list;
-	struct list_head idle_list;
-
-	/*
-	 * when operating in ordered mode, this maintains the list
-	 * of work items waiting for completion
-	 */
-	struct list_head order_list;
-	struct list_head prio_order_list;
-
-	/* lock for finding the next worker thread to queue on */
-	spinlock_t lock;
-
-	/* lock for the ordered lists */
-	spinlock_t order_lock;
-
-	/* extra name for this worker, used for current->name */
-	char *name;
-};
-
-void btrfs_queue_worker(struct btrfs_workers *workers, struct btrfs_work *work);
-int btrfs_start_workers(struct btrfs_workers *workers);
-void btrfs_stop_workers(struct btrfs_workers *workers);
-void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
-			struct btrfs_workers *async_starter);
-void btrfs_requeue_work(struct btrfs_work *work);
-void btrfs_set_work_high_prio(struct btrfs_work *work);
-#endif
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0cf4320..399e85b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -34,7 +34,6 @@
 #include <linux/btrfs.h>
 #include "extent_io.h"
 #include "extent_map.h"
-#include "async-thread.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -1476,8 +1475,6 @@ struct btrfs_fs_info {
 	 * A third pool does submit_bio to avoid deadlocking with the other
 	 * two
 	 */
-	struct btrfs_workers generic_worker;
-
 	struct btrfs_workqueue_struct *workers;
 	struct btrfs_workqueue_struct *delalloc_workers;
 	struct workqueue_struct *submit_workers;
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 4253ad5..9323126 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -33,7 +33,6 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "volumes.h"
-#include "async-thread.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
 #include "dev-replace.h"
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 97df233..a61e1fe 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -39,7 +39,6 @@
 #include "btrfs_inode.h"
 #include "volumes.h"
 #include "print-tree.h"
-#include "async-thread.h"
 #include "locking.h"
 #include "tree-log.h"
 #include "free-space-cache.h"
@@ -1984,7 +1983,6 @@ static noinline int next_root_backup(struct btrfs_fs_info *info,
 /* helper to cleanup workers */
 static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 {
-	btrfs_stop_workers(&fs_info->generic_worker);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
 	btrfs_destroy_workqueue(fs_info->workers);
 	destroy_workqueue(fs_info->submit_workers);
@@ -2458,8 +2456,6 @@ int open_ctree(struct super_block *sb,
 	}
 
 	max_active = fs_info->thread_pool_size;
-	btrfs_init_workers(&fs_info->generic_worker,
-			   "genwork", 1, NULL);
 
 	fs_info->workers = btrfs_alloc_workqueue("worker", "worker-ordered",
 						 "worker-high", max_active);
@@ -2497,17 +2493,15 @@ int open_ctree(struct super_block *sb,
 	 * btrfs_start_workers can really only fail because of ENOMEM so just
 	 * return -ENOMEM if any of these fail.
 	 */
-	ret = btrfs_start_workers(&fs_info->generic_worker);
-
-	if (ret || !(fs_info->flush_workers && fs_info->endio_workers &&
-		     fs_info->endio_meta_workers && fs_info->workers &&
-		     fs_info->submit_workers &&
-		     fs_info->endio_raid56_workers &&
-		     fs_info->rmw_workers && fs_info->delalloc_workers &&
-		     fs_info->endio_meta_write_workers &&
-		     fs_info->endio_write_workers &&
-		     fs_info->caching_workers && fs_info->readahead_workers &&
-		     fs_info->fixup_workers && fs_info->delayed_workers)) {
+
+	if (!(fs_info->flush_workers && fs_info->endio_workers &&
+	      fs_info->endio_meta_workers && fs_info->workers &&
+	      fs_info->submit_workers && fs_info->endio_raid56_workers &&
+	      fs_info->rmw_workers && fs_info->delalloc_workers &&
+	      fs_info->endio_meta_write_workers &&
+	      fs_info->endio_write_workers && fs_info->caching_workers &&
+	      fs_info->readahead_workers && fs_info->fixup_workers &&
+	      fs_info->delayed_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 4b7769d..04f3d5e 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -41,7 +41,6 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "raid56.h"
-#include "async-thread.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1209649..16b6db0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -28,7 +28,6 @@
 #include "volumes.h"
 #include "locking.h"
 #include "btrfs_inode.h"
-#include "async-thread.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 402b488..63e653c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1156,13 +1156,6 @@ error_fs_info:
 	return ERR_PTR(error);
 }
 
-static void btrfs_set_max_workers(struct btrfs_workers *workers, int new_limit)
-{
-	spin_lock_irq(&workers->lock);
-	workers->max_workers = new_limit;
-	spin_unlock_irq(&workers->lock);
-}
-
 static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 				     int new_pool_size, int old_pool_size)
 {
@@ -1174,7 +1167,6 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	printk(KERN_INFO "btrfs: resize thread pool %d -> %d\n",
 	       old_pool_size, new_pool_size);
 
-	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->submit_workers, new_pool_size);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cb10e02..69c0661 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -35,7 +35,6 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "raid56.h"
-#include "async-thread.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
 #include "math.h"
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index bd849cc..0efb041 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -22,7 +22,6 @@
 #include <linux/bio.h>
 #include <linux/sort.h>
 #include <linux/btrfs.h>
-#include "async-thread.h"
 
 #define BTRFS_STRIPE_LEN	(64 * 1024)
 
-- 
1.8.4

