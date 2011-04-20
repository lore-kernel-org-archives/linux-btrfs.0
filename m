From: Josef Bacik <josef@redhat.com>
Subject: [RFC][PATCH] Btrfs: do io in the task context when fsyncing small files
Date: Wed, 20 Apr 2011 16:29:26 -0400
Message-ID: <1303331366-8958-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a work in progress, and requires that you have include/linux/xlist.h,
you can find it here

http://oss.oracle.com/~mason/xlist.h

This is a rough proof of concept, I am very open to any other suggestions.

One of the things that introduces latency when fsyncing small files is passing
off the io to different threads to be submitted and completed.  When you are
only doing a few pages of IO this switching back and forth starts to hurt.  This
patch will set a flag when we fsync the file so we know we're fsyncing, then if
it's a small amount to fsync we submit in the tasks context and setup
completions on the task.  Then when the io completes the task will run the endio
functions itself.  This gets us a 5-10% boost in performance.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h  |    7 ++++++
 fs/btrfs/ctree.h        |   10 ++++++++
 fs/btrfs/extent_io.c    |    2 +
 fs/btrfs/file.c         |   16 ++++++++++---
 fs/btrfs/inode.c        |   54 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ordered-data.c |   47 +++++++++++++++++++++++++++++++++++++++-
 6 files changed, 128 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 57c3bb2..684ace4 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -71,6 +71,10 @@ struct btrfs_inode {
 	/* the space_info for where this inode's data allocations are done */
 	struct btrfs_space_info *space_info;
 
+	atomic_t outstanding_completions;
+	struct xlist_head completions;
+	wait_queue_head_t wait;
+
 	/* full 64 bit generation number, struct vfs_inode doesn't have a big
 	 * enough field for this.
 	 */
@@ -158,6 +162,9 @@ struct btrfs_inode {
 	 */
 	unsigned force_compress:4;
 
+	/* This inode is in the middle of a synchronous operation */
+	unsigned sync:1;
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b409721..6d7cb0d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -28,6 +28,7 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 #include <linux/kobject.h>
+#include <linux/xlist.h>
 #include <trace/events/btrfs.h>
 #include <asm/kmap_types.h>
 #include "extent_io.h"
@@ -817,6 +818,15 @@ struct btrfs_caching_control {
 	atomic_t count;
 };
 
+struct btrfs_end_io_tsk {
+	struct bio *bio;
+	bio_end_io_t *end_io;
+	void *private;
+	struct inode *inode;
+	int error;
+	struct xlist_head list;
+};
+
 struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20ddb28..4ba8c24 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2236,6 +2236,8 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			if (nr_delalloc == 0) {
 				delalloc_start = delalloc_end + 1;
 				continue;
+			} else if (nr_delalloc > 1024) {
+				BTRFS_I(inode)->sync = 0;
 			}
 			tree->ops->fill_delalloc(inode, page, delalloc_start,
 						 delalloc_end, &page_started,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 70038d5..008399d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1203,15 +1203,19 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct btrfs_trans_handle *trans;
 
 	trace_btrfs_sync_file(file, datasync);
+	mutex_lock(&inode->i_mutex);
 
-	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (ret)
+	BTRFS_I(inode)->sync = 1;
+	ret = filemap_fdatawrite_range(inode->i_mapping, start, end);
+	if (ret) {
+		BTRFS_I(inode)->sync = 0;
+		mutex_unlock(&inode->i_mutex);
 		return ret;
-	mutex_lock(&inode->i_mutex);
+	}
 
 	/* we wait first, since the writeback may change the inode */
 	root->log_batch++;
-	btrfs_wait_ordered_range(inode, 0, (u64)-1);
+	btrfs_wait_ordered_range(inode, start, end);
 	root->log_batch++;
 
 	/*
@@ -1219,6 +1223,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * and see if its already been committed
 	 */
 	if (!BTRFS_I(inode)->last_trans) {
+		BTRFS_I(inode)->sync = 0;
 		mutex_unlock(&inode->i_mutex);
 		goto out;
 	}
@@ -1232,6 +1237,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (BTRFS_I(inode)->last_trans <=
 	    root->fs_info->last_trans_committed) {
 		BTRFS_I(inode)->last_trans = 0;
+		BTRFS_I(inode)->sync = 0;
 		mutex_unlock(&inode->i_mutex);
 		goto out;
 	}
@@ -1245,12 +1251,14 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		BTRFS_I(inode)->sync = 0;
 		mutex_unlock(&inode->i_mutex);
 		goto out;
 	}
 
 	ret = btrfs_log_dentry_safe(trans, root, dentry);
 	if (ret < 0) {
+		BTRFS_I(inode)->sync = 0;
 		mutex_unlock(&inode->i_mutex);
 		goto out;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3217919..51c00aa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -92,6 +92,41 @@ static noinline int cow_file_range(struct inode *inode,
 				   u64 start, u64 end, int *page_started,
 				   unsigned long *nr_written, int unlock);
 
+
+static void end_task_bio(struct bio *bio, int err)
+{
+	struct btrfs_end_io_tsk *end_io_tsk;
+	struct inode *inode;
+
+	end_io_tsk = bio->bi_private;
+	inode = end_io_tsk->inode;
+	end_io_tsk->error = err;
+	xlist_add(&end_io_tsk->list, &end_io_tsk->list,
+		  &BTRFS_I(inode)->completions);
+	atomic_dec(&BTRFS_I(inode)->outstanding_completions);
+	wake_up(&BTRFS_I(inode)->wait);
+}
+
+int btrfs_bio_task_end_io(struct inode *inode, struct bio *bio)
+{
+	struct btrfs_end_io_tsk *end_io_tsk;
+	end_io_tsk = kmalloc(sizeof(*end_io_tsk), GFP_NOFS);
+	if (!end_io_tsk)
+		return -ENOMEM;
+
+	end_io_tsk->private = bio->bi_private;
+	end_io_tsk->end_io = bio->bi_end_io;
+	end_io_tsk->inode = inode;
+	end_io_tsk->error = 0;
+	end_io_tsk->bio = bio;
+	INIT_XLIST_HEAD(&end_io_tsk->list);
+	atomic_inc(&BTRFS_I(inode)->outstanding_completions);
+
+	bio->bi_private = end_io_tsk;
+	bio->bi_end_io = end_task_bio;
+	return 0;
+}
+
 static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
 				     struct inode *inode,  struct inode *dir,
 				     const struct qstr *qstr)
@@ -1454,6 +1489,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 			  u64 bio_offset)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int sync = BTRFS_I(inode)->sync;
 	int ret = 0;
 	int skip_sum;
 
@@ -1461,11 +1497,14 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 
 	if (root == root->fs_info->tree_root)
 		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 2);
-	else
+	else if (!sync)
 		ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
+	else
+		ret = btrfs_bio_task_end_io(inode, bio);
 	BUG_ON(ret);
 
 	if (!(rw & REQ_WRITE)) {
+		sync = 1;
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {
 			return btrfs_submit_compressed_read(inode, bio,
 						    mirror_num, bio_flags);
@@ -1479,6 +1518,14 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 		/* csum items have already been cloned */
 		if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
 			goto mapit;
+
+		if (sync) {
+			ret = btrfs_csum_one_bio(root, inode, bio, 0, 0);
+			if (ret)
+				return ret;
+			goto mapit;
+		}
+
 		/* we're doing a write, do the async checksumming */
 		return btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
 				   inode, rw, bio, mirror_num,
@@ -1488,7 +1535,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	}
 
 mapit:
-	return btrfs_map_bio(root, rw, bio, mirror_num, 0);
+	return btrfs_map_bio(root, rw, bio, mirror_num, !sync);
 }
 
 /*
@@ -6780,6 +6827,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 
 	atomic_set(&ei->outstanding_extents, 0);
 	atomic_set(&ei->reserved_extents, 0);
+	atomic_set(&ei->outstanding_completions, 0);
 
 	ei->ordered_data_close = 0;
 	ei->orphan_meta_reserved = 0;
@@ -6791,10 +6839,12 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	extent_io_tree_init(&ei->io_tree, &inode->i_data, GFP_NOFS);
 	extent_io_tree_init(&ei->io_failure_tree, &inode->i_data, GFP_NOFS);
 	mutex_init(&ei->log_mutex);
+	init_waitqueue_head(&ei->wait);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
 	INIT_LIST_HEAD(&ei->ordered_operations);
+	INIT_XLIST_HEAD(&ei->completions);
 	RB_CLEAR_NODE(&ei->rb_node);
 
 	return inode;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a1c9404..0c8d8ba 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -601,11 +601,46 @@ void btrfs_start_ordered_extent(struct inode *inode,
 	if (!test_bit(BTRFS_ORDERED_DIRECT, &entry->flags))
 		filemap_fdatawrite_range(inode->i_mapping, start, end);
 	if (wait) {
-		wait_event(entry->wait, test_bit(BTRFS_ORDERED_COMPLETE,
-						 &entry->flags));
+		if (BTRFS_I(inode)->sync)
+			wait_event(BTRFS_I(inode)->wait,
+				   !xlist_empty(&BTRFS_I(inode)->completions));
+		else
+			wait_event(entry->wait,
+				   test_bit(BTRFS_ORDERED_COMPLETE,
+					    &entry->flags));
 	}
 }
 
+void btrfs_run_task_completions(struct inode *inode)
+{
+	struct xlist_head l;
+	struct xlist_head *pos;
+
+	wait_event(BTRFS_I(inode)->wait,
+		   !atomic_read(&BTRFS_I(inode)->outstanding_completions));
+	INIT_XLIST_HEAD(&l);
+again:
+	xlist_splice(&BTRFS_I(inode)->completions, &l);
+	xlist_reverse(&l);
+
+	while ((pos = xlist_del_head_fast(&l)) != NULL) {
+		struct btrfs_end_io_tsk *end_io_tsk;
+		struct bio *bio;
+		int error;
+
+		end_io_tsk = list_entry(pos, struct btrfs_end_io_tsk, list);
+		bio = end_io_tsk->bio;
+		bio->bi_private = end_io_tsk->private;
+		bio->bi_end_io = end_io_tsk->end_io;
+		error = end_io_tsk->error;
+		kfree(end_io_tsk);
+		bio_endio(bio, error);
+	}
+	smp_mb();
+	if (!xlist_empty(&BTRFS_I(inode)->completions))
+		goto again;
+}
+
 /*
  * Used to wait on ordered extents across a large range of bytes.
  */
@@ -624,6 +659,8 @@ int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 			orig_end = INT_LIMIT(loff_t);
 	}
 again:
+	if (BTRFS_I(inode)->sync)
+		goto wait;
 	/* start IO across the range first to instantiate any delalloc
 	 * extents
 	 */
@@ -637,6 +674,12 @@ again:
 
 	filemap_fdatawait_range(inode->i_mapping, start, orig_end);
 
+wait:
+	smp_mb();
+	if (atomic_read(&BTRFS_I(inode)->outstanding_completions) ||
+	    !xlist_empty(&BTRFS_I(inode)->completions))
+		btrfs_run_task_completions(inode);
+
 	end = orig_end;
 	found = 0;
 	while (1) {
-- 
1.7.2.3

