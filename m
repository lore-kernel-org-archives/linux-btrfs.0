Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33947 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab3CFOxb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2013 09:53:31 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E267C9A0368
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Mar 2013 07:53:30 -0700 (MST)
Date: Wed, 6 Mar 2013 09:53:28 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Chris Mason <clmason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: improve the delayed inode throttling
Message-ID: <20130306145328.GE6904@shiny.masoncoding.com>
References: <20130305154017.GF30680@shiny.masoncoding.com>
 <5136ADCE.9090405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5136ADCE.9090405@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 05, 2013 at 07:45:34PM -0700, Miao Xie wrote:
> 
> We re-queue the node just when there are some delayed items in the current node.
> But if the node still has delayed items after we deal with it, that is to say
> someone is accessing the node. So it is better to release it and deal with it
> later. In this way, we can amass more items and deal with them in batches.

Thanks, I've made this change.

> 
> > +	} else {
> > +		btrfs_release_prepared_delayed_node(delayed_node);
> > +		if (async_work->nr == 0 || total_done < async_work->nr)
> > +			goto again;
> 
> If joining transaction fails, we should end the async handle. And for case
> ->nr == 0 (it means there are too many items, we need flush all), we can
> set ->blocked of the current transaction, in this way, the users can not
> insert any delayed item for a while, and will wait until the current
> transation is committed 

This one I've left out for now, the old code didn't block and I'd prefer
that we test that change independently.

V2 below, it also has the break Liu Bo mentioned.

From: Chris Mason <chris.mason@fusionio.com>
Date: Mon, 4 Mar 2013 17:13:31 -0500
Subject: [PATCH] Btrfs: improve the delayed inode throttling

The delayed inode code batches up changes to the btree in hopes of doing
them in bulk.  As the changes build up, processes kick off worker
threads and wait for them to make progress.

The current code kicks off an async work queue item for each delayed
node, which creates a lot of churn.  It also uses a fixed 1 HZ waiting
period for the throttle, which allows us to build a lot of pending
work and can slow down the commit.

This changes us to watch a sequence counter as it is bumped during the
operations.  We kick off fewer work items and have each work item do
more work.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
---
 fs/btrfs/delayed-inode.c | 152 ++++++++++++++++++++++++++++-------------------
 fs/btrfs/delayed-inode.h |   2 +
 2 files changed, 94 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 0b278b1..46f354a 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -22,8 +22,9 @@
 #include "disk-io.h"
 #include "transaction.h"
 
-#define BTRFS_DELAYED_WRITEBACK		400
-#define BTRFS_DELAYED_BACKGROUND	100
+#define BTRFS_DELAYED_WRITEBACK		512
+#define BTRFS_DELAYED_BACKGROUND	128
+#define BTRFS_DELAYED_BATCH		16
 
 static struct kmem_cache *delayed_node_cache;
 
@@ -494,6 +495,15 @@ static int __btrfs_add_delayed_deletion_item(struct btrfs_delayed_node *node,
 					BTRFS_DELAYED_DELETION_ITEM);
 }
 
+static void finish_one_item(struct btrfs_delayed_root *delayed_root)
+{
+	int seq = atomic_inc_return(&delayed_root->items_seq);
+	if ((atomic_dec_return(&delayed_root->items) <
+	    BTRFS_DELAYED_BACKGROUND || seq % BTRFS_DELAYED_BATCH == 0) &&
+	    waitqueue_active(&delayed_root->wait))
+		wake_up(&delayed_root->wait);
+}
+
 static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
 {
 	struct rb_root *root;
@@ -512,10 +522,8 @@ static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
 
 	rb_erase(&delayed_item->rb_node, root);
 	delayed_item->delayed_node->count--;
-	if (atomic_dec_return(&delayed_root->items) <
-	    BTRFS_DELAYED_BACKGROUND &&
-	    waitqueue_active(&delayed_root->wait))
-		wake_up(&delayed_root->wait);
+
+	finish_one_item(delayed_root);
 }
 
 static void btrfs_release_delayed_item(struct btrfs_delayed_item *item)
@@ -1056,10 +1064,7 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
 		delayed_node->count--;
 
 		delayed_root = delayed_node->root->fs_info->delayed_root;
-		if (atomic_dec_return(&delayed_root->items) <
-		    BTRFS_DELAYED_BACKGROUND &&
-		    waitqueue_active(&delayed_root->wait))
-			wake_up(&delayed_root->wait);
+		finish_one_item(delayed_root);
 	}
 }
 
@@ -1304,35 +1309,44 @@ void btrfs_remove_delayed_node(struct inode *inode)
 	btrfs_release_delayed_node(delayed_node);
 }
 
-struct btrfs_async_delayed_node {
-	struct btrfs_root *root;
-	struct btrfs_delayed_node *delayed_node;
+struct btrfs_async_delayed_work {
+	struct btrfs_delayed_root *delayed_root;
+	int nr;
 	struct btrfs_work work;
 };
 
-static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
+static void btrfs_async_run_delayed_root(struct btrfs_work *work)
 {
-	struct btrfs_async_delayed_node *async_node;
+	struct btrfs_async_delayed_work *async_work;
+	struct btrfs_delayed_root *delayed_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
 	struct btrfs_delayed_node *delayed_node = NULL;
 	struct btrfs_root *root;
 	struct btrfs_block_rsv *block_rsv;
-	int need_requeue = 0;
+	int total_done = 0;
 
-	async_node = container_of(work, struct btrfs_async_delayed_node, work);
+	async_work = container_of(work, struct btrfs_async_delayed_work, work);
+	delayed_root = async_work->delayed_root;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		goto out;
-	path->leave_spinning = 1;
 
-	delayed_node = async_node->delayed_node;
+again:
+	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND / 2)
+		goto free_path;
+
+	delayed_node = btrfs_first_prepared_delayed_node(delayed_root);
+	if (!delayed_node)
+		goto free_path;
+
+	path->leave_spinning = 1;
 	root = delayed_node->root;
 
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
-		goto free_path;
+		goto release_path;
 
 	block_rsv = trans->block_rsv;
 	trans->block_rsv = &root->fs_info->delayed_block_rsv;
@@ -1363,57 +1377,50 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	 * Task1 will sleep until the transaction is commited.
 	 */
 	mutex_lock(&delayed_node->mutex);
-	if (delayed_node->count)
-		need_requeue = 1;
-	else
-		btrfs_dequeue_delayed_node(root->fs_info->delayed_root,
-					   delayed_node);
+	btrfs_dequeue_delayed_node(root->fs_info->delayed_root, delayed_node);
 	mutex_unlock(&delayed_node->mutex);
 
 	trans->block_rsv = block_rsv;
 	btrfs_end_transaction_dmeta(trans, root);
 	btrfs_btree_balance_dirty_nodelay(root);
+
+release_path:
+	btrfs_release_path(path);
+	total_done++;
+
+	btrfs_release_prepared_delayed_node(delayed_node);
+	if (async_work->nr == 0 || total_done < async_work->nr)
+		goto again;
+
 free_path:
 	btrfs_free_path(path);
 out:
-	if (need_requeue)
-		btrfs_requeue_work(&async_node->work);
-	else {
-		btrfs_release_prepared_delayed_node(delayed_node);
-		kfree(async_node);
-	}
+	wake_up(&delayed_root->wait);
+	kfree(async_work);
 }
 
+
 static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
-				     struct btrfs_root *root, int all)
+				     struct btrfs_root *root, int nr)
 {
-	struct btrfs_async_delayed_node *async_node;
-	struct btrfs_delayed_node *curr;
-	int count = 0;
+	struct btrfs_async_delayed_work *async_work;
 
-again:
-	curr = btrfs_first_prepared_delayed_node(delayed_root);
-	if (!curr)
+	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
 		return 0;
 
-	async_node = kmalloc(sizeof(*async_node), GFP_NOFS);
-	if (!async_node) {
-		btrfs_release_prepared_delayed_node(curr);
+	async_work = kmalloc(sizeof(*async_work), GFP_NOFS);
+	if (!async_work)
 		return -ENOMEM;
-	}
-
-	async_node->root = root;
-	async_node->delayed_node = curr;
-
-	async_node->work.func = btrfs_async_run_delayed_node_done;
-	async_node->work.flags = 0;
-
-	btrfs_queue_worker(&root->fs_info->delayed_workers, &async_node->work);
-	count++;
 
-	if (all || count < 4)
-		goto again;
+	async_work->delayed_root = delayed_root;
+	async_work->work.func = btrfs_async_run_delayed_root;
+	async_work->work.flags = 0;
+	if (nr)
+		async_work->nr = 0;
+	else
+		async_work->nr = nr;
 
+	btrfs_queue_worker(&root->fs_info->delayed_workers, &async_work->work);
 	return 0;
 }
 
@@ -1424,30 +1431,55 @@ void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
 	WARN_ON(btrfs_first_delayed_node(delayed_root));
 }
 
+static int refs_newer(struct btrfs_delayed_root *delayed_root,
+		      int seq, int count)
+{
+	int val = atomic_read(&delayed_root->items_seq);
+
+	if (val < seq || val >= seq + count)
+		return 1;
+	return 0;
+}
+
 void btrfs_balance_delayed_items(struct btrfs_root *root)
 {
 	struct btrfs_delayed_root *delayed_root;
+	int seq;
 
 	delayed_root = btrfs_get_delayed_root(root);
 
 	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
 		return;
 
+	seq = atomic_read(&delayed_root->items_seq);
+
 	if (atomic_read(&delayed_root->items) >= BTRFS_DELAYED_WRITEBACK) {
 		int ret;
+		DEFINE_WAIT(__wait);
+
 		ret = btrfs_wq_run_delayed_node(delayed_root, root, 1);
 		if (ret)
 			return;
 
-		wait_event_interruptible_timeout(
-				delayed_root->wait,
-				(atomic_read(&delayed_root->items) <
-				 BTRFS_DELAYED_BACKGROUND),
-				HZ);
-		return;
+		while (1) {
+			prepare_to_wait(&delayed_root->wait, &__wait,
+					TASK_INTERRUPTIBLE);
+
+			if (refs_newer(delayed_root, seq,
+				       BTRFS_DELAYED_BATCH) ||
+			    atomic_read(&delayed_root->items) <
+			    BTRFS_DELAYED_BACKGROUND) {
+				break;
+			}
+			if (!signal_pending(current))
+				schedule();
+			else
+				break;
+		}
+		finish_wait(&delayed_root->wait, &__wait);
 	}
 
-	btrfs_wq_run_delayed_node(delayed_root, root, 0);
+	btrfs_wq_run_delayed_node(delayed_root, root, BTRFS_DELAYED_BATCH);
 }
 
 /* Will return 0 or -ENOMEM */
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 78b6ad0..1d5c5f7 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -43,6 +43,7 @@ struct btrfs_delayed_root {
 	 */
 	struct list_head prepare_list;
 	atomic_t items;		/* for delayed items */
+	atomic_t items_seq;	/* for delayed items */
 	int nodes;		/* for delayed nodes */
 	wait_queue_head_t wait;
 };
@@ -86,6 +87,7 @@ static inline void btrfs_init_delayed_root(
 				struct btrfs_delayed_root *delayed_root)
 {
 	atomic_set(&delayed_root->items, 0);
+	atomic_set(&delayed_root->items_seq, 0);
 	delayed_root->nodes = 0;
 	spin_lock_init(&delayed_root->lock);
 	init_waitqueue_head(&delayed_root->wait);
-- 
1.8.1.3

