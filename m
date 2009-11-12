From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 10/12] Btrfs: Add delayed iput
Date: Thu, 12 Nov 2009 17:36:34 +0800
Message-ID: <4AFBD722.1020809@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

iput() can trigger new transactions if we are dropping the
final reference, so calling it in btrfs_commit_transaction
may end up deadlock. This patch adds delayed iput to avoid
the issue.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
---
 fs/btrfs/ctree.h        |    7 +++++-
 fs/btrfs/disk-io.c      |    3 ++
 fs/btrfs/extent-tree.c  |    8 +++---
 fs/btrfs/inode.c        |   55 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ordered-data.c |   10 ++++++--
 fs/btrfs/ordered-data.h |    3 +-
 fs/btrfs/relocation.c   |    4 +-
 fs/btrfs/super.c        |    4 +-
 fs/btrfs/transaction.c  |   13 ++++++++--
 9 files changed, 89 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 368175b..f98c06c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -872,6 +872,9 @@ struct btrfs_fs_info {
 	struct list_head dead_roots;
 	struct list_head caching_block_groups;
 
+	spinlock_t delayed_iput_lock;
+	struct list_head delayed_iputs;
+
 	atomic_t nr_async_submits;
 	atomic_t async_submit_draining;
 	atomic_t nr_async_bios;
@@ -2301,7 +2304,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       struct inode *inode, u64 new_size,
 			       u32 min_type);
 
-int btrfs_start_delalloc_inodes(struct btrfs_root *root);
+int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end);
 int btrfs_writepages(struct address_space *mapping,
 		     struct writeback_control *wbc);
@@ -2341,6 +2344,8 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
 void btrfs_orphan_cleanup(struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t size);
 int btrfs_invalidate_inodes(struct btrfs_root *root);
+void btrfs_add_delayed_iput(struct inode *inode);
+void btrfs_run_delayed_iputs(struct btrfs_root *root);
 extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e2ebc47..20a03e0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1477,6 +1477,7 @@ static int cleaner_kthread(void *arg)
 
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
 		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
+			btrfs_run_delayed_iputs(root);
 			btrfs_clean_old_snapshots(root);
 			mutex_unlock(&root->fs_info->cleaner_mutex);
 		}
@@ -1606,6 +1607,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
 	INIT_LIST_HEAD(&fs_info->trans_list);
 	INIT_LIST_HEAD(&fs_info->dead_roots);
+	INIT_LIST_HEAD(&fs_info->delayed_iputs);
 	INIT_LIST_HEAD(&fs_info->hashers);
 	INIT_LIST_HEAD(&fs_info->delalloc_inodes);
 	INIT_LIST_HEAD(&fs_info->ordered_operations);
@@ -2386,6 +2388,7 @@ int btrfs_commit_super(struct btrfs_root *root)
 	int ret;
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
+	btrfs_run_delayed_iputs(root);
 	btrfs_clean_old_snapshots(root);
 	mutex_unlock(&root->fs_info->cleaner_mutex);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 30df7fd..51fdaa6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2879,9 +2879,9 @@ static noinline void flush_delalloc_async(struct btrfs_work *work)
 	root = async->root;
 	info = async->info;
 
-	btrfs_start_delalloc_inodes(root);
+	btrfs_start_delalloc_inodes(root, 0);
 	wake_up(&info->flush_wait);
-	btrfs_wait_ordered_extents(root, 0);
+	btrfs_wait_ordered_extents(root, 0, 0);
 
 	spin_lock(&info->lock);
 	info->flushing = 0;
@@ -2955,8 +2955,8 @@ static void flush_delalloc(struct btrfs_root *root,
 	return;
 
 flush:
-	btrfs_start_delalloc_inodes(root);
-	btrfs_wait_ordered_extents(root, 0);
+	btrfs_start_delalloc_inodes(root, 0);
+	btrfs_wait_ordered_extents(root, 0, 0);
 
 	spin_lock(&info->lock);
 	info->flushing = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 15c90cc..2ab1f7a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2017,6 +2017,54 @@ zeroit:
 	return -EIO;
 }
 
+struct delayed_iput {
+	struct list_head list;
+	struct inode *inode;
+};
+
+void btrfs_add_delayed_iput(struct inode *inode)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct delayed_iput *delayed;
+
+	if (atomic_add_unless(&inode->i_count, -1, 1))
+		return;
+
+	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
+	delayed->inode = inode;
+
+	spin_lock(&fs_info->delayed_iput_lock);
+	list_add_tail(&delayed->list, &fs_info->delayed_iputs);
+	spin_unlock(&fs_info->delayed_iput_lock);
+}
+
+void btrfs_run_delayed_iputs(struct btrfs_root *root)
+{
+	LIST_HEAD(list);
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct delayed_iput *delayed;
+	int empty;
+
+	spin_lock(&fs_info->delayed_iput_lock);
+	empty = list_empty(&fs_info->delayed_iputs);
+	spin_unlock(&fs_info->delayed_iput_lock);
+	if (empty)
+		return;
+
+	down_read(&root->fs_info->cleanup_work_sem);
+	spin_lock(&fs_info->delayed_iput_lock);
+	list_splice_init(&fs_info->delayed_iputs, &list);
+	spin_unlock(&fs_info->delayed_iput_lock);
+
+	while (!list_empty(&list)) {
+		delayed = list_entry(list.next, struct delayed_iput, list);
+		list_del(&delayed->list);
+		iput(delayed->inode);
+		kfree(delayed);
+	}
+	up_read(&root->fs_info->cleanup_work_sem);
+}
+
 /*
  * This creates an orphan entry for the given inode in case something goes
  * wrong in the middle of an unlink/truncate.
@@ -5563,7 +5611,7 @@ out_fail:
  * some fairly slow code that needs optimization. This walks the list
  * of all the inodes with pending delalloc and forces them to disk.
  */
-int btrfs_start_delalloc_inodes(struct btrfs_root *root)
+int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 {
 	struct list_head *head = &root->fs_info->delalloc_inodes;
 	struct btrfs_inode *binode;
@@ -5582,7 +5630,10 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root)
 		spin_unlock(&root->fs_info->delalloc_lock);
 		if (inode) {
 			filemap_flush(inode->i_mapping);
-			iput(inode);
+			if (delay_iput)
+				btrfs_add_delayed_iput(inode);
+			else
+				iput(inode);
 		}
 		cond_resched();
 		spin_lock(&root->fs_info->delalloc_lock);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5645ebe..c4d3169 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -335,7 +335,8 @@ int btrfs_remove_ordered_extent(struct inode *inode,
  * wait for all the ordered extents in a root.  This is done when balancing
  * space between drives.
  */
-int btrfs_wait_ordered_extents(struct btrfs_root *root, int nocow_only)
+int btrfs_wait_ordered_extents(struct btrfs_root *root,
+			       int nocow_only, int delay_iput)
 {
 	struct list_head splice;
 	struct list_head *cur;
@@ -372,7 +373,10 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nocow_only)
 		if (inode) {
 			btrfs_start_ordered_extent(inode, ordered, 1);
 			btrfs_put_ordered_extent(ordered);
-			iput(inode);
+			if (delay_iput)
+				btrfs_add_delayed_iput(inode);
+			else
+				iput(inode);
 		} else {
 			btrfs_put_ordered_extent(ordered);
 		}
@@ -430,7 +434,7 @@ again:
 				btrfs_wait_ordered_range(inode, 0, (u64)-1);
 			else
 				filemap_flush(inode->i_mapping);
-			iput(inode);
+			btrfs_add_delayed_iput(inode);
 		}
 
 		cond_resched();
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index a080180..e31a7b1 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -157,7 +157,8 @@ int btrfs_wait_on_page_writeback_range(struct address_space *mapping,
 				       pgoff_t start, pgoff_t end);
 int btrfs_fdatawrite_range(struct address_space *mapping, loff_t start,
 			   loff_t end, int sync_mode);
-int btrfs_wait_ordered_extents(struct btrfs_root *root, int nocow_only);
+int btrfs_wait_ordered_extents(struct btrfs_root *root,
+			       int nocow_only, int delay_iput);
 int btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
 int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f2aa53d..a972868 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3541,8 +3541,8 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	       (unsigned long long)rc->block_group->key.objectid,
 	       (unsigned long long)rc->block_group->flags);
 
-	btrfs_start_delalloc_inodes(fs_info->tree_root);
-	btrfs_wait_ordered_extents(fs_info->tree_root, 0);
+	btrfs_start_delalloc_inodes(fs_info->tree_root, 0);
+	btrfs_wait_ordered_extents(fs_info->tree_root, 0, 0);
 
 	while (1) {
 		rc->extents_found = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 939b68f..5104ca1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -405,8 +405,8 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
-	btrfs_start_delalloc_inodes(root);
-	btrfs_wait_ordered_extents(root, 0);
+	btrfs_start_delalloc_inodes(root, 0);
+	btrfs_wait_ordered_extents(root, 0, 0);
 
 	trans = btrfs_start_transaction(root, 1);
 	ret = btrfs_commit_transaction(trans, root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 728e8fe..75b31ca 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -333,6 +333,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	memset(trans, 0, sizeof(*trans));
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 
+	if (throttle)
+		btrfs_run_delayed_iputs(root);
+
 	return 0;
 }
 
@@ -991,11 +994,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		mutex_unlock(&root->fs_info->trans_mutex);
 
 		if (flush_on_commit) {
-			btrfs_start_delalloc_inodes(root);
-			ret = btrfs_wait_ordered_extents(root, 0);
+			btrfs_start_delalloc_inodes(root, 1);
+			ret = btrfs_wait_ordered_extents(root, 0, 1);
 			BUG_ON(ret);
 		} else if (snap_pending) {
-			ret = btrfs_wait_ordered_extents(root, 1);
+			ret = btrfs_wait_ordered_extents(root, 0, 1);
 			BUG_ON(ret);
 		}
 
@@ -1113,6 +1116,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		current->journal_info = NULL;
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
+
+	if (current != root->fs_info->transaction_kthread)
+		btrfs_run_delayed_iputs(root);
+
 	return ret;
 }
 
-- 
1.6.2.5

