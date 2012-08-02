Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:36411 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab2HBNZO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 09:25:14 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id kMG2FEd5fNjr0vZL (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2012 07:25:13 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: barrier before waitqueue_active V2
Date: Thu, 2 Aug 2012 09:30:16 -0400
Message-ID: <1343914216-2766-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need a barrir before calling waitqueue_active otherwise we will miss
wakeups.  So in places that do atomic_dec(); then atomic_read() use
atomic_dec_return() which imply a memory barrier (see memory-barriers.txt)
and then add an explicit memory barrier everywhere else that need them.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: changed atomic_dec/atomic_read combos to atomic_dec_return() for the
implied barrier.
 fs/btrfs/compression.c   |    1 +
 fs/btrfs/delayed-inode.c |    7 +++----
 fs/btrfs/delayed-ref.c   |   18 ++++++++++++------
 fs/btrfs/disk-io.c       |    7 ++++---
 fs/btrfs/inode.c         |    4 +---
 fs/btrfs/volumes.c       |    3 +--
 6 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 86eff48..43d1c5a 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -818,6 +818,7 @@ static void free_workspace(int type, struct list_head *workspace)
 	btrfs_compress_op[idx]->free_workspace(workspace);
 	atomic_dec(alloc_workspace);
 wake:
+	smp_mb();
 	if (waitqueue_active(workspace_wait))
 		wake_up(workspace_wait);
 }
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 335605c..ee2050c 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -512,8 +512,8 @@ static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
 
 	rb_erase(&delayed_item->rb_node, root);
 	delayed_item->delayed_node->count--;
-	atomic_dec(&delayed_root->items);
-	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND &&
+	if (atomic_dec_return(&delayed_root->items) <
+	    BTRFS_DELAYED_BACKGROUND &&
 	    waitqueue_active(&delayed_root->wait))
 		wake_up(&delayed_root->wait);
 }
@@ -1055,8 +1055,7 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
 		delayed_node->count--;
 
 		delayed_root = delayed_node->root->fs_info->delayed_root;
-		atomic_dec(&delayed_root->items);
-		if (atomic_read(&delayed_root->items) <
+		if (atomic_dec_return(&delayed_root->items) <
 		    BTRFS_DELAYED_BACKGROUND &&
 		    waitqueue_active(&delayed_root->wait))
 			wake_up(&delayed_root->wait);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index da7419e..858ef02 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -662,9 +662,12 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, level, action,
 				   for_cow);
-	if (!need_ref_seq(for_cow, ref_root) &&
-	    waitqueue_active(&fs_info->tree_mod_seq_wait))
-		wake_up(&fs_info->tree_mod_seq_wait);
+	if (!need_ref_seq(for_cow, ref_root)) {
+		smp_mb();
+		if (waitqueue_active(&fs_info->tree_mod_seq_wait))
+			wake_up(&fs_info->tree_mod_seq_wait);
+	}
+
 	spin_unlock(&delayed_refs->lock);
 	if (need_ref_seq(for_cow, ref_root))
 		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
@@ -713,9 +716,11 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action, for_cow);
-	if (!need_ref_seq(for_cow, ref_root) &&
-	    waitqueue_active(&fs_info->tree_mod_seq_wait))
-		wake_up(&fs_info->tree_mod_seq_wait);
+	if (!need_ref_seq(for_cow, ref_root)) {
+		smp_mb();
+		if (waitqueue_active(&fs_info->tree_mod_seq_wait))
+			wake_up(&fs_info->tree_mod_seq_wait);
+	}
 	spin_unlock(&delayed_refs->lock);
 	if (need_ref_seq(for_cow, ref_root))
 		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
@@ -744,6 +749,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
 				   extent_op->is_data);
 
+	smp_mb();
 	if (waitqueue_active(&fs_info->tree_mod_seq_wait))
 		wake_up(&fs_info->tree_mod_seq_wait);
 	spin_unlock(&delayed_refs->lock);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 502b20c..2ed81c8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -754,9 +754,7 @@ static void run_one_async_done(struct btrfs_work *work)
 	limit = btrfs_async_submit_limit(fs_info);
 	limit = limit * 2 / 3;
 
-	atomic_dec(&fs_info->nr_async_submits);
-
-	if (atomic_read(&fs_info->nr_async_submits) < limit &&
+	if (atomic_dec_return(&fs_info->nr_async_submits) < limit &&
 	    waitqueue_active(&fs_info->async_submit_wait))
 		wake_up(&fs_info->async_submit_wait);
 
@@ -3785,14 +3783,17 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 		/* FIXME: cleanup wait for commit */
 		t->in_commit = 1;
 		t->blocked = 1;
+		smp_mb();
 		if (waitqueue_active(&root->fs_info->transaction_blocked_wait))
 			wake_up(&root->fs_info->transaction_blocked_wait);
 
 		t->blocked = 0;
+		smp_mb();
 		if (waitqueue_active(&root->fs_info->transaction_wait))
 			wake_up(&root->fs_info->transaction_wait);
 
 		t->commit_done = 1;
+		smp_mb();
 		if (waitqueue_active(&t->commit_wait))
 			wake_up(&t->commit_wait);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b82ae2..f2096c2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1007,9 +1007,7 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 	nr_pages = (async_cow->end - async_cow->start + PAGE_CACHE_SIZE) >>
 		PAGE_CACHE_SHIFT;
 
-	atomic_sub(nr_pages, &root->fs_info->async_delalloc_pages);
-
-	if (atomic_read(&root->fs_info->async_delalloc_pages) <
+	if (atomic_sub_return(nr_pages, &root->fs_info->async_delalloc_pages) <
 	    5 * 1024 * 1024 &&
 	    waitqueue_active(&root->fs_info->async_submit_wait))
 		wake_up(&root->fs_info->async_submit_wait);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b8708f9..3821302 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -227,9 +227,8 @@ loop_lock:
 		cur = pending;
 		pending = pending->bi_next;
 		cur->bi_next = NULL;
-		atomic_dec(&fs_info->nr_async_bios);
 
-		if (atomic_read(&fs_info->nr_async_bios) < limit &&
+		if (atomic_dec_return(&fs_info->nr_async_bios) < limit &&
 		    waitqueue_active(&fs_info->async_submit_wait))
 			wake_up(&fs_info->async_submit_wait);
 
-- 
1.7.7.6

