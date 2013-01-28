Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56922 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab3A1MhX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 07:37:23 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0SCbKw5007440
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 20:37:20 +0800
Message-ID: <5106712D.9070201@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 20:38:05 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC][PATCH 3/3] Btrfs: introduce btrfs_subvolume_{start, end}_write()
 for each subvolume
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we write some data into a file, and set its parent subvolume to be R/O, then
send out this subvolume, we will find the data we wrote before is not sent.

Steps to reproduce:
 # mkfs.btrfs /dev/sdc1
 # mount /dev/sdc1 /mnt
 # btrfs sub create /mnt/vol
 # dd if=/dev/urandom of=/mnt/vol/file0 bs=1M count=10
 # umount /mnt
 # mount /dev/sdc1 /mnt
 # dd if=/dev/urandom of=/mnt/vol/file0 oflag=append conv=nocreat,notrunc bs=1M count=1
 # set /mnt/vol readonly
 # btrfs send /mnt/vol -f file
 # mkfs.btrfs /dev/sdd1
 # mount /dev/sdd1 /tmp
 # btrfs receive /tmp -f file
 # md5sum /mnt/vol/file0
 # md5sum /tmp/vol/file0

The two md5sum numbers are different.

By debugging, we found the dirty pages which were introduced by the second time
of the write were not flush into the disk when we set the subvolume to R/O.

So we must keep track of when those write operations start and when they end,
and then we can determine when writes are able to occur to a subvolume. In order
to implement this function, I introduce btrfs_subvolume_{start, end}_write(),
which is similar to mnt_{want,drop}_write().

These two functions are only used for file write operations. For the other
operations, such as mkdir(), we just use the transaction mechanism, when
we start a transaction, we will check the subvolume is R/O or not.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   18 +++++++++++++++++-
 fs/btrfs/disk-io.c     |   36 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent-tree.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/file.c        |   17 +++++++++++++++++
 fs/btrfs/inode.c       |    8 ++++++++
 fs/btrfs/ioctl.c       |   30 +++++++++++++++++++++++++++---
 fs/btrfs/transaction.c |   11 +++++++++++
 7 files changed, 156 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 547b7b0..b2b5372 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1539,6 +1539,11 @@ struct btrfs_fs_info {
 	atomic_t mutually_exclusive_operation_running;
 };
 
+struct btrfs_subvolume_writers {
+	struct percpu_counter	counter;
+	wait_queue_head_t	wait;
+};
+
 /*
  * in ram representation of the tree.  extent_root is used for all allocations
  * and for the extent tree extent_root root.
@@ -1647,6 +1652,7 @@ struct btrfs_root {
 	int force_cow;
 
 	spinlock_t root_item_lock;
+	struct btrfs_subvolume_writers *subv_writers;
 };
 
 struct btrfs_ioctl_defrag_range_args {
@@ -2510,9 +2516,15 @@ BTRFS_SETGET_STACK_FUNCS(root_stransid, struct btrfs_root_item,
 BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
 			 rtransid, 64);
 
+/*
+ * some function will call this function twice, in order to prevent the
+ * compiler from using the optimizations that might optimize accesses
+ * (just get the value from the register, not from the memory).
+ */
 static inline bool btrfs_root_readonly(struct btrfs_root *root)
 {
-	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) != 0;
+	return (ACCESS_ONCE(root->root_item.flags) &
+		cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) != 0;
 }
 
 /* struct btrfs_root_backup */
@@ -3078,6 +3090,10 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
 int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info);
 int __get_raid_index(u64 flags);
+
+
+int btrfs_subvolume_start_write(struct btrfs_root *root);
+void btrfs_subvolume_end_write(struct btrfs_root *root);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 65f0367..0c31d07 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1150,6 +1150,32 @@ void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	}
 }
 
+static struct btrfs_subvolume_writers *btrfs_alloc_subvolume_writers(void)
+{
+	struct btrfs_subvolume_writers *writers;
+	int ret;
+
+	writers = kmalloc(sizeof(*writers), GFP_NOFS);
+	if (!writers)
+		return ERR_PTR(-ENOMEM);
+
+	ret = percpu_counter_init(&writers->counter, 0);
+	if (ret < 0) {
+		kfree(writers);
+		return ERR_PTR(ret);
+	}
+
+	init_waitqueue_head(&writers->wait);
+	return writers;
+}
+
+static void
+btrfs_free_subvolume_writers(struct btrfs_subvolume_writers *writers)
+{
+	percpu_counter_destroy(&writers->counter);
+	kfree(writers);
+}
+
 static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 			 u32 stripesize, struct btrfs_root *root,
 			 struct btrfs_fs_info *fs_info,
@@ -1485,6 +1511,7 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 					      struct btrfs_key *location)
 {
 	struct btrfs_root *root;
+	struct btrfs_subvolume_writers *writers;
 	int ret;
 
 	if (location->objectid == BTRFS_ROOT_TREE_OBJECTID)
@@ -1512,6 +1539,13 @@ again:
 	if (IS_ERR(root))
 		return root;
 
+	writers = btrfs_alloc_subvolume_writers();
+	if (IS_ERR(writers)) {
+		ret = PTR_ERR(writers);
+		goto fail;
+	}
+	root->subv_writers = writers;
+
 	root->free_ino_ctl = kzalloc(sizeof(*root->free_ino_ctl), GFP_NOFS);
 	root->free_ino_pinned = kzalloc(sizeof(*root->free_ino_pinned),
 					GFP_NOFS);
@@ -3206,6 +3240,8 @@ static void free_fs_root(struct btrfs_root *root)
 	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
 	if (root->anon_dev)
 		free_anon_bdev(root->anon_dev);
+	if (root->subv_writers)
+		btrfs_free_subvolume_writers(root->subv_writers);
 	free_extent_buffer(root->node);
 	free_extent_buffer(root->commit_root);
 	kfree(root->free_ino_ctl);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d133edf..3d2c56b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8181,3 +8181,43 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
 	range->len = trimmed;
 	return ret;
 }
+
+/*
+ * btrfs_subvolume_{start,end}_write() is similar to sb_{start,end}_write(),
+ * they are used to prevent the some tasks writing data after the subvolume
+ * is set to readonly.
+ *
+ * Though other operations such as mkdir/create/rmdir and so on have the same
+ * problem, we need not use these two functions to fix it, just check the flag
+ * of subvolume when starting transaction.
+ */
+void btrfs_subvolume_end_write(struct btrfs_root *root)
+{
+	percpu_counter_dec(&root->subv_writers->counter);
+	/*
+	 * Make sure counter is updated before we wake up
+	 * waiters in subvolume_setflags().
+	 */
+	smp_mb();
+	if (waitqueue_active(&root->subv_writers->wait))
+		wake_up(&root->subv_writers->wait);
+}
+
+int btrfs_subvolume_start_write(struct btrfs_root *root)
+{
+	if (unlikely(btrfs_root_readonly(root)))
+		return 0;
+
+	percpu_counter_inc(&root->subv_writers->counter);
+	/*
+	 * Make sure counter is updated before we check for readonly.
+	 * subvolume_set_flags() first sets READONLY flag and then check
+	 * the counter.
+	 */
+	smp_mb();
+	if (unlikely(btrfs_root_readonly(root))) {
+		btrfs_subvolume_end_write(root);
+		return 0;
+	}
+	return 1;
+}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 370ed5b..3632f45 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -293,6 +293,7 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	struct btrfs_ioctl_defrag_range_args range;
 	int num_defrag;
+	int ret;
 
 	/* get the inode */
 	key.objectid = defrag->root;
@@ -320,8 +321,17 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 	range.start = defrag->last_offset;
 
 	sb_start_write(fs_info->sb);
+	ret = btrfs_subvolume_start_write(inode_root);
+	if (!ret) {
+		sb_end_write(fs_info->sb);
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+		iput(inode);
+		return -EROFS;
+	}
+
 	num_defrag = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
 				       BTRFS_DEFRAG_BATCH);
+	btrfs_subvolume_end_write(inode_root);
 	sb_end_write(fs_info->sb);
 	/*
 	 * if we filled the whole defrag batch, there
@@ -1497,6 +1507,11 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 
 	sb_start_write(inode->i_sb);
+	err = btrfs_subvolume_start_write(root);
+	if (!err) {
+		err = -EROFS;
+		goto ro_subv;
+	}
 
 	mutex_lock(&inode->i_mutex);
 
@@ -1599,6 +1614,8 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	if (sync)
 		atomic_dec(&BTRFS_I(inode)->sync_writers);
 out:
+	btrfs_subvolume_end_write(root);
+ro_subv:
 	sb_end_write(inode->i_sb);
 	current->backing_dev_info = NULL;
 	return num_written ? num_written : err;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 67ed24a..97f4c30 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6765,6 +6765,12 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	u64 page_end;
 
 	sb_start_pagefault(inode->i_sb);
+	ret = btrfs_subvolume_start_write(root);
+	if (!ret) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_ro_subv;
+	}
+
 	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 	if (!ret) {
 		ret = file_update_time(vma->vm_file);
@@ -6864,6 +6870,8 @@ out_unlock:
 out:
 	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
 out_noreserve:
+	btrfs_subvolume_end_write(root);
+out_ro_subv:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7624212..4ec2dc7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1595,6 +1595,23 @@ static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 	return ret;
 }
 
+static void btrfs_subvolume_wait_write(struct btrfs_root *root)
+{
+	s64 writers;
+	DEFINE_WAIT(wait);
+
+	do {
+		prepare_to_wait(&root->subv_writers->wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+
+		writers = percpu_counter_sum(&root->subv_writers->counter);
+		if (writers)
+			schedule();
+
+		finish_wait(&root->subv_writers->wait, &wait);
+	} while (writers);
+}
+
 static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 					      void __user *arg)
 {
@@ -1641,14 +1658,21 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_drop_sem;
 
 	root_flags = btrfs_root_flags(&root->root_item);
-	if (flags & BTRFS_SUBVOL_RDONLY)
+	if (flags & BTRFS_SUBVOL_RDONLY) {
 		btrfs_set_root_flags(&root->root_item,
 				     root_flags | BTRFS_ROOT_SUBVOL_RDONLY);
-	else
+		smp_wmb();
+		btrfs_subvolume_wait_write(root);
+		ret = btrfs_start_delalloc_inodes(root, 0);
+		if (ret)
+			goto out_reset;
+		btrfs_wait_ordered_extents(root, 0);
+	} else {
 		btrfs_set_root_flags(&root->root_item,
 				     root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
+	}
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root->fs_info->tree_root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_reset;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 194d0b5..118a9bf 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -389,6 +389,17 @@ again:
 	INIT_LIST_HEAD(&h->qgroup_ref_list);
 	INIT_LIST_HEAD(&h->new_bgs);
 
+	/*
+	 * The case which can enter this branch is very rare, so we need
+	 * not add the same check at the beginning of this function to
+	 * make the task end more early.
+	 */
+	if (unlikely(type == TRANS_START && btrfs_root_readonly(root))) {
+		btrfs_end_transaction(h, root);
+		ret = -EROFS;
+		goto alloc_fail;
+	}
+
 	smp_mb();
 	if (cur_trans->blocked && may_wait_transaction(root, type)) {
 		btrfs_commit_transaction(h, root);
-- 
1.6.5.2
