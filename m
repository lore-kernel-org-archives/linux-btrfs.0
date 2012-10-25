Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24930 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759306Ab2JYJ1n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 05:27:43 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9P9ReZQ030439
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 17:27:41 +0800
Message-ID: <50890624.6080903@cn.fujitsu.com>
Date: Thu, 25 Oct 2012 17:28:04 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs: make delalloc inodes be flushed by multi-task
References: <5089045D.8050801@cn.fujitsu.com>
In-Reply-To: <5089045D.8050801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduce a new worker pool named "flush_workers", and if we
want to force all the inode with pending delalloc to the disks, we can
queue those inodes into the work queue of the worker pool, in this way,
those inodes will be flushed by multi-task.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   14 ++++++++
 fs/btrfs/disk-io.c     |    7 ++++
 fs/btrfs/inode.c       |   78 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/relocation.c  |    6 +++-
 fs/btrfs/transaction.c |    6 +++-
 5 files changed, 103 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 34c5a44..cd0c6d6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1333,6 +1333,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers generic_worker;
 	struct btrfs_workers workers;
 	struct btrfs_workers delalloc_workers;
+	struct btrfs_workers flush_workers;
 	struct btrfs_workers endio_workers;
 	struct btrfs_workers endio_meta_workers;
 	struct btrfs_workers endio_meta_write_workers;
@@ -3271,6 +3272,19 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
 /* inode.c */
+struct btrfs_delalloc_work {
+	struct inode *inode;
+	int wait;
+	int delay_iput;
+	struct completion completion;
+	struct list_head list;
+	struct btrfs_work work;
+};
+
+struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
+						    int wait, int delay_iput);
+void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work);
+
 struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
 					   size_t pg_offset, u64 start, u64 len,
 					   int create);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7cda519..bd70c28 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2279,6 +2279,10 @@ int open_ctree(struct super_block *sb,
 			   fs_info->thread_pool_size,
 			   &fs_info->generic_worker);
 
+	btrfs_init_workers(&fs_info->flush_workers, "flush_delalloc",
+			   fs_info->thread_pool_size,
+			   &fs_info->generic_worker);
+
 	btrfs_init_workers(&fs_info->submit_workers, "submit",
 			   min_t(u64, fs_devices->num_devices,
 			   fs_info->thread_pool_size),
@@ -2350,6 +2354,7 @@ int open_ctree(struct super_block *sb,
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
+	ret |= btrfs_start_workers(&fs_info->flush_workers);
 	if (ret) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
@@ -2667,6 +2672,7 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->submit_workers);
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
+	btrfs_stop_workers(&fs_info->flush_workers);
 fail_alloc:
 fail_iput:
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
@@ -3339,6 +3345,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
+	btrfs_stop_workers(&fs_info->flush_workers);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(root, CHECK_INTEGRITY))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f92def2..290cd77 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -71,6 +71,7 @@ static const struct file_operations btrfs_dir_file_operations;
 static struct extent_io_ops btrfs_extent_io_ops;
 
 static struct kmem_cache *btrfs_inode_cachep;
+static struct kmem_cache *btrfs_delalloc_work_cachep;
 struct kmem_cache *btrfs_trans_handle_cachep;
 struct kmem_cache *btrfs_transaction_cachep;
 struct kmem_cache *btrfs_path_cachep;
@@ -7199,6 +7200,8 @@ void btrfs_destroy_cachep(void)
 		kmem_cache_destroy(btrfs_path_cachep);
 	if (btrfs_free_space_cachep)
 		kmem_cache_destroy(btrfs_free_space_cachep);
+	if (btrfs_delalloc_work_cachep)
+		kmem_cache_destroy(btrfs_delalloc_work_cachep);
 }
 
 int btrfs_init_cachep(void)
@@ -7233,6 +7236,13 @@ int btrfs_init_cachep(void)
 	if (!btrfs_free_space_cachep)
 		goto fail;
 
+	btrfs_delalloc_work_cachep = kmem_cache_create("btrfs_delalloc_work",
+			sizeof(struct btrfs_delalloc_work), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+			NULL);
+	if (!btrfs_delalloc_work_cachep)
+		goto fail;
+
 	return 0;
 fail:
 	btrfs_destroy_cachep();
@@ -7443,6 +7453,49 @@ out_notrans:
 	return ret;
 }
 
+static void btrfs_run_delalloc_work(struct btrfs_work *work)
+{
+	struct btrfs_delalloc_work *delalloc_work;
+
+	delalloc_work = container_of(work, struct btrfs_delalloc_work,
+				     work);
+	if (delalloc_work->wait)
+		btrfs_wait_ordered_range(delalloc_work->inode, 0, (u64)-1);
+	else
+		filemap_flush(delalloc_work->inode->i_mapping);
+
+	if (delalloc_work->delay_iput)
+		btrfs_add_delayed_iput(delalloc_work->inode);
+	else
+		iput(delalloc_work->inode);
+	complete(&delalloc_work->completion);
+}
+
+struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
+						    int wait, int delay_iput)
+{
+	struct btrfs_delalloc_work *work;
+
+	work = kmem_cache_zalloc(btrfs_delalloc_work_cachep, GFP_NOFS);
+	if (!work)
+		return NULL;
+
+	init_completion(&work->completion);
+	INIT_LIST_HEAD(&work->list);
+	work->inode = inode;
+	work->wait = wait;
+	work->delay_iput = delay_iput;
+	work->work.func = btrfs_run_delalloc_work;
+
+	return work;
+}
+
+void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work)
+{
+	wait_for_completion(&work->completion);
+	kmem_cache_free(btrfs_delalloc_work_cachep, work);
+}
+
 /*
  * some fairly slow code that needs optimization. This walks the list
  * of all the inodes with pending delalloc and forces them to disk.
@@ -7452,10 +7505,15 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	struct list_head *head = &root->fs_info->delalloc_inodes;
 	struct btrfs_inode *binode;
 	struct inode *inode;
+	struct btrfs_delalloc_work *work, *next;
+	struct list_head works;
+	int ret = 0;
 
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
+	INIT_LIST_HEAD(&works);
+
 	spin_lock(&root->fs_info->delalloc_lock);
 	while (!list_empty(head)) {
 		binode = list_entry(head->next, struct btrfs_inode,
@@ -7465,11 +7523,14 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 			list_del_init(&binode->delalloc_inodes);
 		spin_unlock(&root->fs_info->delalloc_lock);
 		if (inode) {
-			filemap_flush(inode->i_mapping);
-			if (delay_iput)
-				btrfs_add_delayed_iput(inode);
-			else
-				iput(inode);
+			work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
+			if (!work) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			list_add_tail(&work->list, &works);
+			btrfs_queue_worker(&root->fs_info->flush_workers,
+					   &work->work);
 		}
 		cond_resched();
 		spin_lock(&root->fs_info->delalloc_lock);
@@ -7488,7 +7549,12 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 		    atomic_read(&root->fs_info->async_delalloc_pages) == 0));
 	}
 	atomic_dec(&root->fs_info->async_submit_draining);
-	return 0;
+out:
+	list_for_each_entry_safe(work, next, &works, list) {
+		list_del_init(&work->list);
+		btrfs_wait_and_free_delalloc_work(work);
+	}
+	return ret;
 }
 
 static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 776f0aa..5bef816 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4057,7 +4057,11 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	       (unsigned long long)rc->block_group->key.objectid,
 	       (unsigned long long)rc->block_group->flags);
 
-	btrfs_start_delalloc_inodes(fs_info->tree_root, 0);
+	ret = btrfs_start_delalloc_inodes(fs_info->tree_root, 0);
+	if (ret < 0) {
+		err = ret;
+		goto out;
+	}
 	btrfs_wait_ordered_extents(fs_info->tree_root, 0);
 
 	while (1) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 77db875..4aed529 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1499,7 +1499,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		WARN_ON(cur_trans != trans->transaction);
 
 		if (flush_on_commit || snap_pending) {
-			btrfs_start_delalloc_inodes(root, 1);
+			ret = btrfs_start_delalloc_inodes(root, 1);
+			if (ret) {
+				btrfs_abort_transaction(trans, root, ret);
+				goto cleanup_transaction;
+			}
 			btrfs_wait_ordered_extents(root, 1);
 		}
 
-- 
1.6.5.2
