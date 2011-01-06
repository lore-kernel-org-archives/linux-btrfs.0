From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: forced readonly mounts on errors
Date: Thu, 06 Jan 2011 19:30:25 +0800
Message-ID: <4D25A7D1.7050602@cn.fujitsu.com>
References: <4D24160C.6070900@cn.fujitsu.com> <4D252E42.5060803@cn.fujitsu.com> <4D258BC7.8040105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D258BC7.8040105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


This patch comes from "Forced readonly mounts on errors" ideas.

As we know, this is the first step in being more fault tolerant of disk
corruptions instead of just using BUG() statements.

The major content:
- add a framework for generating errors that should result in filesystems
  going readonly.
- keep FS state in disk super block.
- make sure that all of resource will be freed and released at umount time.
- make sure that after FS is forced readonly on error, there will be no more
  disk change before FS is corrected. For this, we should stop write operation.

After this patch is applied, the conversion from BUG() to such a framework can
happen incrementally.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   24 +++
 fs/btrfs/disk-io.c     |  389 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/disk-io.h     |    1 +
 fs/btrfs/extent-tree.c |   11 ++
 fs/btrfs/file.c        |   11 ++
 fs/btrfs/super.c       |   88 +++++++++++
 fs/btrfs/transaction.c |    3 +
 7 files changed, 525 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index af52f6d..63c35f8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -294,6 +294,14 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
 #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
+
+/*
+ * File system states
+ */
+
+/* Errors detected */
+#define BTRFS_SUPER_FLAG_ERROR		(1ULL << 2)
+
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
 
@@ -1050,6 +1058,9 @@ struct btrfs_fs_info {
 	unsigned metadata_ratio;
 
 	void *bdev_holder;
+
+	/* filesystem state */
+	u64 fs_state;
 };
 
 /*
@@ -2188,6 +2199,11 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 int btrfs_set_block_group_rw(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
+int btrfs_error_unpin_extent_range(struct btrfs_root *root,
+				   u64 start, u64 end);
+int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
+			       u64 num_bytes);
+
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
@@ -2541,6 +2557,14 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 /* super.c */
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
+		     unsigned int line, int errno);
+
+#define btrfs_std_error(fs_info, errno)				\
+do {								\
+	if ((errno))						\
+		__btrfs_std_error((fs_info), __func__, __LINE__, (errno));\
+} while (0)
 
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a5d2249..4f70256 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -44,6 +44,20 @@
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
+static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				    int read_only);
+static int btrfs_destroy_ordered_operations(struct btrfs_root *root);
+static int btrfs_destroy_ordered_extents(struct btrfs_root *root);
+static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
+				      struct btrfs_root *root);
+static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
+static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
+static int btrfs_destroy_marked_extents(struct btrfs_root *root,
+					struct extent_io_tree *dirty_pages,
+					int mark);
+static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
+				       struct extent_io_tree *pinned_extents);
+static int btrfs_cleanup_transaction(struct btrfs_root *root);
 
 /*
  * end_io_wq structs are used to do processing in task context when an IO is
@@ -1727,6 +1741,11 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (!btrfs_super_root(disk_super))
 		goto fail_iput;
 
+	/* check FS state, whether FS is broken. */
+	fs_info->fs_state |= btrfs_super_flags(disk_super);
+
+	btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
+
 	ret = btrfs_parse_options(tree_root, options);
 	if (ret) {
 		err = ret;
@@ -1957,7 +1976,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
-	if (btrfs_super_log_root(disk_super) != 0) {
+	/* do not make disk changes in broken FS */
+	if (btrfs_super_log_root(disk_super) != 0 &&
+	    !(fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)) {
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
 		if (fs_devices->rw_devices == 0) {
@@ -2453,8 +2474,28 @@ int close_ctree(struct btrfs_root *root)
 	smp_mb();
 
 	btrfs_put_block_group_cache(fs_info);
+
+	/*
+	 * Here come 2 situations when btrfs is broken to flip readonly:
+	 *
+	 * 1. when btrfs flips readonly somewhere else before
+	 * btrfs_commit_super, sb->s_flags has MS_RDONLY flag,
+	 * and btrfs will skip to write sb directly to keep
+	 * ERROR state on disk.
+	 *
+	 * 2. when btrfs flips readonly just in btrfs_commit_super,
+	 * and in such case, btrfs cannnot write sb via btrfs_commit_super,
+	 * and since fs_state has been set BTRFS_SUPER_FLAG_ERROR flag,
+	 * btrfs will cleanup all FS resources first and write sb then.
+	 */
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
-		ret =  btrfs_commit_super(root);
+		ret = btrfs_commit_super(root);
+		if (ret)
+			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
+	}
+
+	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		ret = btrfs_error_commit_super(root);
 		if (ret)
 			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
 	}
@@ -2630,6 +2671,350 @@ out:
 	return 0;
 }
 
+static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+			      int read_only)
+{
+	if (read_only)
+		return;
+
+	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
+		printk(KERN_WARNING "warning: mount fs with errors, "
+		       "running btrfsck is recommended\n");
+}
+
+int btrfs_error_commit_super(struct btrfs_root *root)
+{
+	int ret;
+
+	mutex_lock(&root->fs_info->cleaner_mutex);
+	btrfs_run_delayed_iputs(root);
+	mutex_unlock(&root->fs_info->cleaner_mutex);
+
+	down_write(&root->fs_info->cleanup_work_sem);
+	up_write(&root->fs_info->cleanup_work_sem);
+
+	/* cleanup FS via transaction */
+	btrfs_cleanup_transaction(root);
+
+	ret = write_ctree_super(NULL, root, 0);
+
+	return ret;
+}
+
+static int btrfs_destroy_ordered_operations(struct btrfs_root *root)
+{
+	struct btrfs_inode *btrfs_inode;
+	struct list_head splice;
+
+	INIT_LIST_HEAD(&splice);
+
+	mutex_lock(&root->fs_info->ordered_operations_mutex);
+	spin_lock(&root->fs_info->ordered_extent_lock);
+
+	list_splice_init(&root->fs_info->ordered_operations, &splice);
+	while (!list_empty(&splice)) {
+		btrfs_inode = list_entry(splice.next, struct btrfs_inode,
+					 ordered_operations);
+
+		list_del_init(&btrfs_inode->ordered_operations);
+
+		btrfs_invalidate_inodes(btrfs_inode->root);
+	}
+
+	spin_unlock(&root->fs_info->ordered_extent_lock);
+	mutex_unlock(&root->fs_info->ordered_operations_mutex);
+
+	return 0;
+}
+
+static int btrfs_destroy_ordered_extents(struct btrfs_root *root)
+{
+	struct list_head splice;
+	struct btrfs_ordered_extent *ordered;
+	struct inode *inode;
+
+	INIT_LIST_HEAD(&splice);
+
+	spin_lock(&root->fs_info->ordered_extent_lock);
+
+	list_splice_init(&root->fs_info->ordered_extents, &splice);
+	while (!list_empty(&splice)) {
+		ordered = list_entry(splice.next, struct btrfs_ordered_extent,
+				     root_extent_list);
+
+		list_del_init(&ordered->root_extent_list);
+		atomic_inc(&ordered->refs);
+
+		/* the inode may be getting freed (in sys_unlink path). */
+		inode = igrab(ordered->inode);
+
+		spin_unlock(&root->fs_info->ordered_extent_lock);
+		if (inode)
+			iput(inode);
+
+		atomic_set(&ordered->refs, 1);
+		btrfs_put_ordered_extent(ordered);
+
+		spin_lock(&root->fs_info->ordered_extent_lock);
+	}
+
+	spin_unlock(&root->fs_info->ordered_extent_lock);
+
+	return 0;
+}
+
+static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
+				      struct btrfs_root *root)
+{
+	struct rb_node *node;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_node *ref;
+	int ret = 0;
+
+	delayed_refs = &trans->delayed_refs;
+
+	spin_lock(&delayed_refs->lock);
+	if (delayed_refs->num_entries == 0) {
+		printk(KERN_INFO "delayed_refs has NO entry\n");
+		return ret;
+	}
+
+	node = rb_first(&delayed_refs->root);
+	while (node) {
+		ref = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
+		node = rb_next(node);
+
+		ref->in_tree = 0;
+		rb_erase(&ref->rb_node, &delayed_refs->root);
+		delayed_refs->num_entries--;
+
+		atomic_set(&ref->refs, 1);
+		if (btrfs_delayed_ref_is_head(ref)) {
+			struct btrfs_delayed_ref_head *head;
+
+			head = btrfs_delayed_node_to_head(ref);
+			mutex_lock(&head->mutex);
+			kfree(head->extent_op);
+			delayed_refs->num_heads--;
+			if (list_empty(&head->cluster))
+				delayed_refs->num_heads_ready--;
+			list_del_init(&head->cluster);
+			mutex_unlock(&head->mutex);
+		}
+
+		spin_unlock(&delayed_refs->lock);
+		btrfs_put_delayed_ref(ref);
+
+		cond_resched();
+		spin_lock(&delayed_refs->lock);
+	}
+
+	spin_unlock(&delayed_refs->lock);
+
+	return ret;
+}
+
+static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
+{
+	struct btrfs_pending_snapshot *snapshot;
+	struct list_head splice;
+
+	INIT_LIST_HEAD(&splice);
+
+	list_splice_init(&t->pending_snapshots, &splice);
+
+	while (!list_empty(&splice)) {
+		snapshot = list_entry(splice.next,
+				      struct btrfs_pending_snapshot,
+				      list);
+
+		list_del_init(&snapshot->list);
+
+		kfree(snapshot);
+	}
+
+	return 0;
+}
+
+static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
+{
+	struct btrfs_inode *btrfs_inode;
+	struct list_head splice;
+
+	INIT_LIST_HEAD(&splice);
+
+	list_splice_init(&root->fs_info->delalloc_inodes, &splice);
+
+	spin_lock(&root->fs_info->delalloc_lock);
+
+	while (!list_empty(&splice)) {
+		btrfs_inode = list_entry(splice.next, struct btrfs_inode,
+				    delalloc_inodes);
+
+		list_del_init(&btrfs_inode->delalloc_inodes);
+
+		btrfs_invalidate_inodes(btrfs_inode->root);
+	}
+
+	spin_unlock(&root->fs_info->delalloc_lock);
+
+	return 0;
+}
+
+static int btrfs_destroy_marked_extents(struct btrfs_root *root,
+					struct extent_io_tree *dirty_pages,
+					int mark)
+{
+	int ret;
+	struct page *page;
+	struct inode *btree_inode = root->fs_info->btree_inode;
+	struct extent_buffer *eb;
+	u64 start = 0;
+	u64 end;
+	u64 offset;
+	unsigned long index;
+
+	while (1) {
+		ret = find_first_extent_bit(dirty_pages, start, &start, &end,
+					    mark);
+		if (ret)
+			break;
+
+		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
+		while (start <= end) {
+			index = start >> PAGE_CACHE_SHIFT;
+			start = (u64)(index + 1) << PAGE_CACHE_SHIFT;
+			page = find_get_page(btree_inode->i_mapping, index);
+			if (!page)
+				continue;
+			offset = page_offset(page);
+
+			spin_lock(&dirty_pages->buffer_lock);
+			eb = radix_tree_lookup(
+			     &(&BTRFS_I(page->mapping->host)->io_tree)->buffer,
+					       offset >> PAGE_CACHE_SHIFT);
+			spin_unlock(&dirty_pages->buffer_lock);
+			if (eb) {
+				ret = test_and_clear_bit(EXTENT_BUFFER_DIRTY,
+							 &eb->bflags);
+				atomic_set(&eb->refs, 1);
+			}
+			if (PageWriteback(page))
+				end_page_writeback(page);
+
+			lock_page(page);
+			if (PageDirty(page)) {
+				clear_page_dirty_for_io(page);
+				spin_lock_irq(&page->mapping->tree_lock);
+				radix_tree_tag_clear(&page->mapping->page_tree,
+							page_index(page),
+							PAGECACHE_TAG_DIRTY);
+				spin_unlock_irq(&page->mapping->tree_lock);
+			}
+
+			page->mapping->a_ops->invalidatepage(page, 0);
+			unlock_page(page);
+		}
+	}
+
+	return ret;
+}
+
+static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
+				       struct extent_io_tree *pinned_extents)
+{
+	struct extent_io_tree *unpin;
+	u64 start;
+	u64 end;
+	int ret;
+
+	unpin = pinned_extents;
+	while (1) {
+		ret = find_first_extent_bit(unpin, 0, &start, &end,
+					    EXTENT_DIRTY);
+		if (ret)
+			break;
+
+		/* opt_discard */
+		ret = btrfs_error_discard_extent(root, start, end + 1 - start);
+
+		clear_extent_dirty(unpin, start, end, GFP_NOFS);
+		btrfs_error_unpin_extent_range(root, start, end);
+		cond_resched();
+	}
+
+	return 0;
+}
+
+static int btrfs_cleanup_transaction(struct btrfs_root *root)
+{
+	struct btrfs_transaction *t;
+	LIST_HEAD(list);
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	mutex_lock(&root->fs_info->transaction_kthread_mutex);
+
+	list_splice_init(&root->fs_info->trans_list, &list);
+	while (!list_empty(&list)) {
+		t = list_entry(list.next, struct btrfs_transaction, list);
+		if (!t)
+			break;
+
+		btrfs_destroy_ordered_operations(root);
+
+		btrfs_destroy_ordered_extents(root);
+
+		btrfs_destroy_delayed_refs(t, root);
+
+		btrfs_block_rsv_release(root,
+					&root->fs_info->trans_block_rsv,
+					t->dirty_pages.dirty_bytes);
+
+		/* FIXME: cleanup wait for commit */
+		t->in_commit = 1;
+		t->blocked = 1;
+		if (waitqueue_active(&root->fs_info->transaction_blocked_wait))
+			wake_up(&root->fs_info->transaction_blocked_wait);
+
+		t->blocked = 0;
+		if (waitqueue_active(&root->fs_info->transaction_wait))
+			wake_up(&root->fs_info->transaction_wait);
+		mutex_unlock(&root->fs_info->trans_mutex);
+
+		mutex_lock(&root->fs_info->trans_mutex);
+		t->commit_done = 1;
+		if (waitqueue_active(&t->commit_wait))
+			wake_up(&t->commit_wait);
+		mutex_unlock(&root->fs_info->trans_mutex);
+
+		mutex_lock(&root->fs_info->trans_mutex);
+
+		btrfs_destroy_pending_snapshots(t);
+
+		btrfs_destroy_delalloc_inodes(root);
+
+		spin_lock(&root->fs_info->new_trans_lock);
+		root->fs_info->running_transaction = NULL;
+		spin_unlock(&root->fs_info->new_trans_lock);
+
+		btrfs_destroy_marked_extents(root, &t->dirty_pages,
+					     EXTENT_DIRTY);
+
+		btrfs_destroy_pinned_extent(root,
+					    root->fs_info->pinned_extents);
+
+		t->use_count = 0;
+		list_del_init(&t->list);
+		memset(t, 0, sizeof(*t));
+		kmem_cache_free(btrfs_transaction_cachep, t);
+	}
+
+	mutex_unlock(&root->fs_info->transaction_kthread_mutex);
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	return 0;
+}
+
 static struct extent_io_ops btree_extent_io_ops = {
 	.write_cache_pages_lock_hook = btree_lock_page_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 88e825a..07b20dc 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -52,6 +52,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_commit_super(struct btrfs_root *root);
+int btrfs_error_commit_super(struct btrfs_root *root);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize);
 struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7e5162e..73a3c3f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8585,3 +8585,14 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+int btrfs_error_unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
+{
+	return unpin_extent_range(root, start, end);
+}
+
+int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
+			       u64 num_bytes)
+{
+	return btrfs_discard_extent(root, bytenr, num_bytes);
+}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 66836d8..79d8ace 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -890,6 +890,17 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	if (err)
 		goto out;
 
+	/*
+	 * If BTRFS flips readonly due to some impossible error
+	 * (fs_info->fs_state now has BTRFS_SUPER_FLAG_ERROR),
+	 * although we have opened a file as writable, we have
+	 * to stop this write operation to ensure FS consistency.
+	 */
+	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		err = -EROFS;
+		goto out;
+	}
+
 	file_update_time(file);
 	BTRFS_I(inode)->sequence++;
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 61bd79a..01c6c50 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -54,6 +54,94 @@
 
 static const struct super_operations btrfs_super_ops;
 
+static const char *btrfs_decode_error(struct btrfs_fs_info *fs_info, int errno,
+				      char nbuf[16])
+{
+	char *errstr = NULL;
+
+	switch (errno) {
+	case -EIO:
+		errstr = "IO failure";
+		break;
+	case -ENOMEM:
+		errstr = "Out of memory";
+		break;
+	case -EROFS:
+		errstr = "Readonly filesystem";
+		break;
+	default:
+		if (nbuf) {
+			if (snprintf(nbuf, 16, "error %d", -errno) >= 0)
+				errstr = nbuf;
+		}
+		break;
+	}
+
+	return errstr;
+}
+
+static void __save_error_info(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_super_block *disk_super = &fs_info->super_copy;
+
+	fs_info->fs_state = BTRFS_SUPER_FLAG_ERROR;
+	disk_super->flags |= cpu_to_le64(BTRFS_SUPER_FLAG_ERROR);
+
+	mutex_lock(&fs_info->trans_mutex);
+	memcpy(&fs_info->super_for_commit, disk_super,
+	       sizeof(fs_info->super_for_commit));
+	mutex_unlock(&fs_info->trans_mutex);
+}
+
+/* NOTE:
+ *	We move write_super stuff at umount in order to avoid deadlock
+ *	for umount hold all lock.
+ */
+static void save_error_info(struct btrfs_fs_info *fs_info)
+{
+	__save_error_info(fs_info);
+}
+
+/* btrfs handle error by forcing the filesystem readonly */
+static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
+{
+	struct super_block *sb = fs_info->sb;
+
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
+	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		sb->s_flags |= MS_RDONLY;
+		printk(KERN_INFO "btrfs is forced readonly\n");
+	}
+}
+
+/*
+ * __btrfs_std_error decodes expected errors from the caller and
+ * invokes the approciate error response.
+ */
+void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
+		     unsigned int line, int errno)
+{
+	struct super_block *sb = fs_info->sb;
+	char nbuf[16];
+	const char *errstr;
+
+	/*
+	 * Special case: if the error is EROFS, and we're already
+	 * under MS_RDONLY, then it is safe here.
+	 */
+	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
+		return;
+
+	errstr = btrfs_decode_error(fs_info, errno, nbuf);
+	printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: %s\n",
+		sb->s_id, function, line, errstr);
+	save_error_info(fs_info);
+
+	btrfs_handle_error(fs_info);
+}
+
 static void btrfs_put_super(struct super_block *sb)
 {
 	struct btrfs_root *root = btrfs_sb(sb);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f50e931..cd1481c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -181,6 +181,9 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	struct btrfs_trans_handle *h;
 	struct btrfs_transaction *cur_trans;
 	int ret;
+
+	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
+		return ERR_PTR(-EROFS);
 again:
 	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
 	if (!h)
-- 
1.6.5.2

