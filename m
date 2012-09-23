Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1973 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab2IWKIv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 06:08:51 -0400
Message-ID: <505EDFB5.7040902@cn.fujitsu.com>
Date: Sun, 23 Sep 2012 18:08:53 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] Btrfs: fix trans block rsv regression
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com> <1347613087-3489-2-git-send-email-bo.li.liu@oracle.com> <20120914124159.GI12994@localhost.localdomain> <50532AB0.2020701@oracle.com> <50532B7D.5060906@oracle.com>
In-Reply-To: <50532B7D.5060906@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 14 Sep 2012 21:05:01 +0800, Liu Bo wrote:
> On 09/14/2012 09:01 PM, Liu Bo wrote:
>> On 09/14/2012 08:41 PM, Josef Bacik wrote:
>>> On Fri, Sep 14, 2012 at 02:58:04AM -0600, Liu Bo wrote:
>>>> In some workloads we have nested joining transaction operations,
>>>> eg.
>>>>   run_delalloc_nocow
>>>>       btrfs_join_transaction
>>>>       cow_file_range
>>>>          btrfs_join_transaction
>>>>
>>>> it can be a serious bug since each trans handler has only two
>>>> block_rsv, orig_rsv and block_rsv, which means we may lose our
>>>> first block_rsv after two joining transaction operations:
>>>>
>>>> 1) btrfs_start_transaction
>>>>       trans->block_rsv = A
>>>>
>>>> 2) btrfs_join_transaction
>>>>       trans->orig_rsv = trans->block_rsv; ---> orig_rsv is now A
>>>>       trans->block_rsv = B
>>>>
>>>> 3) btrfs_join_transaction
>>>>       trans->orig_rsv = trans->block_rsv; ---> orig_rsv is now B
>>>>       trans->block_rsv = C
>>>>    ...
>>>>
>>>
>>> I'd like to see the actual stack trace where this happens, because I don't think
>>> it can happen.  And if it is we need to look at that specific case and adjust it
>>> as necessary and not add a bunch of kmallocs just to track the block_rsv,
>>> because frankly it's not that big of a deal, it was just put into place in case
>>> somebody wasn't expecting a call they made to start another transaction and
>>> reset the block_rsv, which I don't actually think happens anywhere.  So NAK on
>>> this patch, give me more information so I can figure out the right way to deal
>>> with this.  Thanks,
>>>
>>
>> Fine, please run xfstests 068 till it hits a BUG_ON inside either btrfs_delete_delayed_dir_index or
>> btrfs_insert_delayed_dir_index.
>>
>> What I saw is that the orig_rsv and block_rsv is both delalloc_block_rsv, which is already lack of space.
>>
> 
> and trans->use_count has been 3.

Hi, Liu

Do you still look into this problem?  I think the following patch can help you.
This patch was made to improve btrfs_run_ordered_operations(), I found it can fix
the problem that you pointed out in this mail.

Thanks
Miao

Subject: [PATCH] Btrfs: make ordered operations be handled by multi-thread

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h        |    1 +
 fs/btrfs/disk-io.c      |    7 ++++
 fs/btrfs/ordered-data.c |   88 ++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.h |    2 +-
 fs/btrfs/transaction.c  |   18 +++++++--
 5 files changed, 95 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dbb461f..fd7ed9f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1328,6 +1328,7 @@ struct btrfs_fs_info {
 	 */
 	struct btrfs_workers fixup_workers;
 	struct btrfs_workers delayed_workers;
+	struct btrfs_workers ordered_operation_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
 	int thread_pool_size;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7fb7069..e49665f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2317,6 +2317,10 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_workers(&fs_info->readahead_workers, "readahead",
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
+	btrfs_init_workers(&fs_info->ordered_operation_workers,
+			   "ordered-operations",
+			   fs_info->thread_pool_size,
+			   &fs_info->generic_worker);
 
 	/*
 	 * endios are largely parallel and should have a very
@@ -2346,6 +2350,7 @@ int open_ctree(struct super_block *sb,
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
+	ret |= btrfs_start_workers(&fs_info->ordered_operation_workers);
 	if (ret) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
@@ -2649,6 +2654,7 @@ fail_tree_roots:
 
 fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->generic_worker);
+	btrfs_stop_workers(&fs_info->ordered_operation_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
 	btrfs_stop_workers(&fs_info->fixup_workers);
 	btrfs_stop_workers(&fs_info->delalloc_workers);
@@ -3256,6 +3262,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
+	btrfs_stop_workers(&fs_info->ordered_operation_workers);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(root, CHECK_INTEGRITY))
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 4ae1014..a4b1316 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -26,6 +26,7 @@
 #include "extent_io.h"
 
 static struct kmem_cache *btrfs_ordered_extent_cache;
+static struct kmem_cache *btrfs_ordered_operation_work_cache;
 
 static u64 entry_end(struct btrfs_ordered_extent *entry)
 {
@@ -519,6 +520,28 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root,
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 }
 
+struct btrfs_ordered_operation_work {
+	struct inode *inode;
+	struct completion completion;
+	int wait;
+	struct list_head list;
+	struct btrfs_work work;
+};
+
+static void btrfs_run_ordered_operation(struct btrfs_work *work)
+{
+	struct btrfs_ordered_operation_work *ordered_work;
+
+	ordered_work = container_of(work, struct btrfs_ordered_operation_work,
+				    work);
+	if (ordered_work->wait)
+		btrfs_wait_ordered_range(ordered_work->inode, 0, (u64)-1);
+	else
+		filemap_flush(ordered_work->inode->i_mapping);
+	btrfs_add_delayed_iput(ordered_work->inode);
+	complete(&ordered_work->completion);
+}
+
 /*
  * this is used during transaction commit to write all the inodes
  * added to the ordered operation list.  These files must be fully on
@@ -529,13 +552,17 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root,
  * extra check to make sure the ordered operation list really is empty
  * before we return
  */
-void btrfs_run_ordered_operations(struct btrfs_root *root, int wait)
+int btrfs_run_ordered_operations(struct btrfs_root *root, int wait)
 {
 	struct btrfs_inode *btrfs_inode;
 	struct inode *inode;
 	struct list_head splice;
+	struct list_head works;
+	struct btrfs_ordered_operation_work *work, *next;
+	int ret = 0;
 
 	INIT_LIST_HEAD(&splice);
+	INIT_LIST_HEAD(&works);
 
 	mutex_lock(&root->fs_info->ordered_operations_mutex);
 	spin_lock(&root->fs_info->ordered_extent_lock);
@@ -543,6 +570,7 @@ again:
 	list_splice_init(&root->fs_info->ordered_operations, &splice);
 
 	while (!list_empty(&splice)) {
+
 		btrfs_inode = list_entry(splice.next, struct btrfs_inode,
 				   ordered_operations);
 
@@ -559,16 +587,34 @@ again:
 			list_add_tail(&BTRFS_I(inode)->ordered_operations,
 			      &root->fs_info->ordered_operations);
 		}
+
+		if (!inode)
+			continue;
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 
-		if (inode) {
-			if (wait)
-				btrfs_wait_ordered_range(inode, 0, (u64)-1);
-			else
-				filemap_flush(inode->i_mapping);
-			btrfs_add_delayed_iput(inode);
+		work = kmem_cache_zalloc(btrfs_ordered_operation_work_cache,
+					 GFP_NOFS);
+		if (!work) {
+			if (list_empty(&BTRFS_I(inode)->ordered_operations))
+				list_add_tail(&btrfs_inode->ordered_operations,
+					      &splice);
+			spin_lock(&root->fs_info->ordered_extent_lock);
+			list_splice_tail(&splice,
+					 &root->fs_info->ordered_operations);
+			spin_unlock(&root->fs_info->ordered_extent_lock);
+			ret = -ENOMEM;
+			goto out;
 		}
 
+		init_completion(&work->completion);
+		INIT_LIST_HEAD(&work->list);
+		work->inode = inode;
+		work->wait = wait;
+		work->work.func = btrfs_run_ordered_operation;
+		list_add_tail(&work->list, &works);
+		btrfs_queue_worker(&root->fs_info->ordered_operation_workers,
+				   &work->work);
+
 		cond_resched();
 		spin_lock(&root->fs_info->ordered_extent_lock);
 	}
@@ -576,7 +622,14 @@ again:
 		goto again;
 
 	spin_unlock(&root->fs_info->ordered_extent_lock);
+out:
+	list_for_each_entry_safe(work, next, &works, list) {
+		list_del_init(&work->list);
+		wait_for_completion(&work->completion);
+		kmem_cache_free(btrfs_ordered_operation_work_cache, work);
+	}
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
+	return ret;
 }
 
 /*
@@ -944,15 +997,6 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	if (last_mod < root->fs_info->last_trans_committed)
 		return;
 
-	/*
-	 * the transaction is already committing.  Just start the IO and
-	 * don't bother with all of this list nonsense
-	 */
-	if (trans && root->fs_info->running_transaction->blocked) {
-		btrfs_wait_ordered_range(inode, 0, (u64)-1);
-		return;
-	}
-
 	spin_lock(&root->fs_info->ordered_extent_lock);
 	if (list_empty(&BTRFS_I(inode)->ordered_operations)) {
 		list_add_tail(&BTRFS_I(inode)->ordered_operations,
@@ -969,6 +1013,16 @@ int __init ordered_data_init(void)
 				     NULL);
 	if (!btrfs_ordered_extent_cache)
 		return -ENOMEM;
+
+	btrfs_ordered_operation_work_cache = kmem_cache_create(
+				"btrfs_ordered_operation_work",
+				sizeof(struct btrfs_ordered_operation_work), 0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+				NULL);
+	if (!btrfs_ordered_operation_work_cache) {
+		kmem_cache_destroy(btrfs_ordered_extent_cache);
+		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -976,4 +1030,6 @@ void ordered_data_exit(void)
 {
 	if (btrfs_ordered_extent_cache)
 		kmem_cache_destroy(btrfs_ordered_extent_cache);
+	if (btrfs_ordered_operation_work_cache)
+		kmem_cache_destroy(btrfs_ordered_operation_work_cache);
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index d1ddaef..82f9f67 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -186,7 +186,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr, u32 *sum);
-void btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
+int btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
 void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct inode *inode);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 115f054..1538b50 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1362,15 +1362,21 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_transaction *prev_trans = NULL;
 	DEFINE_WAIT(wait);
-	int ret = -EIO;
+	int ret;
 	int should_grow = 0;
 	unsigned long now = get_seconds();
 	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
 
-	btrfs_run_ordered_operations(root, 0);
+	ret = btrfs_run_ordered_operations(root, 0);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto cleanup_transaction;
+	}
 
-	if (cur_trans->aborted)
+	if (cur_trans->aborted) {
+		ret = cur_trans->aborted;
 		goto cleanup_transaction;
+	}
 
 	/* make a pass through all the delayed refs we have so far
 	 * any runnings procs may add more while we are here
@@ -1466,7 +1472,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		 * it here and no for sure that nothing new will be added
 		 * to the list
 		 */
-		btrfs_run_ordered_operations(root, 1);
+		ret = btrfs_run_ordered_operations(root, 1);
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
+			goto cleanup_transaction;
+		}
 
 		prepare_to_wait(&cur_trans->writer_wait, &wait,
 				TASK_UNINTERRUPTIBLE);
-- 
1.7.6.5
