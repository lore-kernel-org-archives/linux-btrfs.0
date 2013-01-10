Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56745 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3AJMml (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 07:42:41 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0ACgcuO022015
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 20:42:38 +0800
Message-ID: <50EEB764.4010405@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 20:43:16 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/11] Btrfs: use atomic for btrfs_fs_info->generation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info->generation is a 64bit variant, we might get a wrong number on
the 32bit machines if there is no lock or other methods to protect it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.c             | 7 ++++---
 fs/btrfs/ctree.h             | 2 +-
 fs/btrfs/disk-io.c           | 8 ++++----
 fs/btrfs/file.c              | 6 ++++--
 fs/btrfs/inode.c             | 5 +++--
 fs/btrfs/qgroup.c            | 2 +-
 fs/btrfs/transaction.c       | 4 ++--
 include/trace/events/btrfs.h | 3 ++-
 8 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c7b67cf..dd57ce2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1365,10 +1365,11 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		       (unsigned long long)
 		       root->fs_info->running_transaction->transid);
 
-	if (trans->transid != root->fs_info->generation)
+	if (trans->transid != atomic64_read(&root->fs_info->generation))
 		WARN(1, KERN_CRIT "trans %llu running %llu\n",
 		       (unsigned long long)trans->transid,
-		       (unsigned long long)root->fs_info->generation);
+		       (unsigned long long)atomic64_read(
+		       &root->fs_info->generation));
 
 	if (!should_cow_block(trans, root, buf)) {
 		*cow_ret = buf;
@@ -1465,7 +1466,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		return 0;
 
 	WARN_ON(trans->transaction != root->fs_info->running_transaction);
-	WARN_ON(trans->transid != root->fs_info->generation);
+	WARN_ON(trans->transid != atomic64_read(&root->fs_info->generation));
 
 	parent_nritems = btrfs_header_nritems(parent);
 	blocksize = btrfs_level_size(root, parent_level - 1);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 547b7b0..c3edb22 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1278,7 +1278,7 @@ struct btrfs_fs_info {
 
 	struct btrfs_block_rsv empty_block_rsv;
 
-	u64 generation;
+	atomic64_t generation;
 	u64 last_trans_committed;
 
 	/*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4438aac..2d69541 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1200,7 +1200,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
 	memset(&root->root_kobj, 0, sizeof(root->root_kobj));
-	root->defrag_trans_start = fs_info->generation;
+	root->defrag_trans_start = atomic64_read(&fs_info->generation);
 	init_completion(&root->kobj_unregister);
 	root->defrag_running = 0;
 	root->root_key.objectid = objectid;
@@ -2501,7 +2501,7 @@ retry_root_backup:
 		fs_info->pending_quota_state = 1;
 	}
 
-	fs_info->generation = generation;
+	atomic64_set(&fs_info->generation, generation);
 	fs_info->last_trans_committed = generation;
 
 	ret = btrfs_recover_balance(fs_info);
@@ -3436,12 +3436,12 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	int was_dirty;
 
 	btrfs_assert_tree_locked(buf);
-	if (transid != root->fs_info->generation)
+	if (transid != atomic64_read(&root->fs_info->generation))
 		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
 		       "found %llu running %llu\n",
 			(unsigned long long)buf->start,
 			(unsigned long long)transid,
-			(unsigned long long)root->fs_info->generation);
+			(u64)atomic64_read(&root->fs_info->generation));
 	was_dirty = set_extent_buffer_dirty(buf);
 	if (!was_dirty) {
 		spin_lock(&root->fs_info->delalloc_lock);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 20452c1..024246b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1588,7 +1588,8 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	 * otherwise subsequent syncs to a file that's been synced in this
 	 * transaction will appear to have already occured.
 	 */
-	BTRFS_I(inode)->last_trans = root->fs_info->generation + 1;
+	BTRFS_I(inode)->last_trans = atomic64_read(&root->fs_info->generation) +
+				     1;
 	BTRFS_I(inode)->last_sub_trans = root->log_transid;
 	if (num_written > 0 || num_written == -EIOCBQUEUED) {
 		err = generic_write_sync(file, pos, num_written);
@@ -1679,7 +1680,8 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * syncing
 	 */
 	smp_mb();
-	if (btrfs_inode_in_log(inode, root->fs_info->generation) ||
+	if (btrfs_inode_in_log(inode,
+	    atomic64_read(&root->fs_info->generation)) ||
 	    BTRFS_I(inode)->last_trans <=
 	    root->fs_info->last_trans_committed) {
 		BTRFS_I(inode)->last_trans = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2a2b5e1..aadb0db 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2632,7 +2632,8 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	 * idea about which extents were modified before we were evicted from
 	 * cache.
 	 */
-	if (BTRFS_I(inode)->last_trans == root->fs_info->generation)
+	if (BTRFS_I(inode)->last_trans ==
+	    atomic64_read(&root->fs_info->generation))
 		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 			&BTRFS_I(inode)->runtime_flags);
 
@@ -6852,7 +6853,7 @@ again:
 	set_page_dirty(page);
 	SetPageUptodate(page);
 
-	BTRFS_I(inode)->last_trans = root->fs_info->generation;
+	BTRFS_I(inode)->last_trans = atomic64_read(&root->fs_info->generation);
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index fe9d02c..8bed26b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -290,7 +290,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 				goto out;
 			}
 			if (btrfs_qgroup_status_generation(l, ptr) !=
-			    fs_info->generation) {
+			    atomic64_read(&fs_info->generation)) {
 				flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 				printk(KERN_ERR
 					"btrfs: qgroup generation mismatch, "
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 87fac9a..e7992ca 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -161,8 +161,8 @@ loop:
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
 	extent_io_tree_init(&cur_trans->dirty_pages,
 			     fs_info->btree_inode->i_mapping);
-	fs_info->generation++;
-	cur_trans->transid = fs_info->generation;
+	atomic64_inc(&fs_info->generation);
+	cur_trans->transid = atomic64_read(&fs_info->generation);
 	fs_info->running_transaction = cur_trans;
 	cur_trans->aborted = 0;
 	spin_unlock(&fs_info->trans_lock);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index ea546a4..09dc72f 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -71,7 +71,8 @@ TRACE_EVENT(btrfs_transaction_commit,
 	),
 
 	TP_fast_assign(
-		__entry->generation	= root->fs_info->generation;
+		__entry->generation	=
+				atomic64_read(&root->fs_info->generation);
 		__entry->root_objectid	= root->root_key.objectid;
 	),
 
-- 
1.7.11.7
