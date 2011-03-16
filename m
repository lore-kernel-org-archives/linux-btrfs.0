From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/7] Btrfs: Cache free inode numbers in memory
Date: Wed, 16 Mar 2011 16:50:29 +0800
Message-ID: <4D8079D5.4080101@cn.fujitsu.com>
References: <4D807977.1040506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D807977.1040506@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs stores the highest objectid of the fs tree, and it always
returns (highest+1) inode number when we create a file, so inode numbers
won't be reclaimed when we delete files, so we'll run out of inode numbers
as we keep create/delete files in 32bits machines.

This fixes it, and it works similarly to how we cache free space in block
cgroups.

We start a kernel thread to read the file tree. By scanning inode items,
we know which chunks of inode numbers are free, and we cache them in
an rb-tree.

Because we are searching the commit root, we have to carefully handle the
cross-transaction case.

The rb-tree is a hybrid extent+bitmap tree, so if we have too many small
chunks of inode numbers, we'll use bitmaps. Initially we allow 16K ram
of extents, and a bitmap will be used if we exceed this threshold. The
extents threshold is adjusted in runtime.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h            |   15 +-
 fs/btrfs/disk-io.c          |   18 +++
 fs/btrfs/free-space-cache.c |   95 ++++++++++---
 fs/btrfs/free-space-cache.h |   16 ++-
 fs/btrfs/inode-map.c        |  341 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/inode-map.h        |   11 ++
 fs/btrfs/inode.c            |   42 ++++--
 fs/btrfs/ioctl.c            |    4 +-
 fs/btrfs/relocation.c       |    3 +-
 fs/btrfs/transaction.c      |    7 +-
 10 files changed, 499 insertions(+), 53 deletions(-)
 create mode 100644 fs/btrfs/inode-map.h

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2a1e36e..40f38f7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1101,6 +1101,15 @@ struct btrfs_root {
 	spinlock_t accounting_lock;
 	struct btrfs_block_rsv *block_rsv;
 
+	/* free ino cache stuff */
+	struct mutex fs_commit_mutex;
+	struct btrfs_free_space_ctl *free_ino_ctl;
+	enum btrfs_caching_type cached;
+	spinlock_t cache_lock;
+	wait_queue_head_t cache_wait;
+	struct btrfs_free_space_ctl *free_ino_pinned;
+	u64 cache_progress;
+
 	struct mutex log_mutex;
 	wait_queue_head_t log_writer_wait;
 	wait_queue_head_t log_commit_wait[2];
@@ -2395,12 +2404,6 @@ int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, u64 offset);
 int btrfs_find_orphan_item(struct btrfs_root *root, u64 offset);
 
-/* inode-map.c */
-int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *fs_root,
-			     u64 dirid, u64 *objectid);
-int btrfs_find_highest_inode(struct btrfs_root *fs_root, u64 *objectid);
-
 /* inode-item.c */
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e1ea3e..5c92066 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -40,6 +40,7 @@
 #include "locking.h"
 #include "tree-log.h"
 #include "free-space-cache.h"
+#include "inode-map.h"
 
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
@@ -1233,6 +1234,19 @@ again:
 	if (IS_ERR(root))
 		return root;
 
+	root->free_ino_ctl = kzalloc(sizeof(*root->free_ino_ctl), GFP_NOFS);
+	if (!root->free_ino_ctl)
+		goto fail;
+	root->free_ino_pinned = kzalloc(sizeof(*root->free_ino_pinned),
+					GFP_NOFS);
+	if (!root->free_ino_pinned)
+		goto fail;
+
+	btrfs_init_free_ino_ctl(root);
+	mutex_init(&root->fs_commit_mutex);
+	spin_lock_init(&root->cache_lock);
+	init_waitqueue_head(&root->cache_wait);
+
 	set_anon_super(&root->anon_super, NULL);
 
 	if (btrfs_root_refs(&root->root_item) == 0) {
@@ -2381,6 +2395,8 @@ int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 	if (btrfs_root_refs(&root->root_item) == 0)
 		synchronize_srcu(&fs_info->subvol_srcu);
 
+	__btrfs_remove_free_space_cache(root->free_ino_pinned);
+	__btrfs_remove_free_space_cache(root->free_ino_ctl);
 	free_fs_root(root);
 	return 0;
 }
@@ -2394,6 +2410,8 @@ static void free_fs_root(struct btrfs_root *root)
 	}
 	free_extent_buffer(root->node);
 	free_extent_buffer(root->commit_root);
+	kfree(root->free_ino_ctl);
+	kfree(root->free_ino_pinned);
 	kfree(root->name);
 	kfree(root);
 }
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 8799208..e0dbb3a 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -24,6 +24,7 @@
 #include "free-space-cache.h"
 #include "transaction.h"
 #include "disk-io.h"
+#include "inode-map.h"
 
 #define BITS_PER_BITMAP		(PAGE_CACHE_SIZE * 8)
 #define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
@@ -102,7 +103,7 @@ int create_free_space_inode(struct btrfs_root *root,
 	u64 objectid;
 	int ret;
 
-	ret = btrfs_find_free_objectid(trans, root, 0, &objectid);
+	ret = btrfs_find_free_objectid(root, &objectid);
 	if (ret < 0)
 		return ret;
 
@@ -1409,10 +1410,9 @@ bool try_merge_free_space(struct btrfs_free_space_ctl *ctl,
 	return merged;
 }
 
-int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
-			 u64 offset, u64 bytes)
+int __btrfs_add_free_space(struct btrfs_free_space_ctl *ctl,
+			   u64 offset, u64 bytes)
 {
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *info;
 	int ret = 0;
 
@@ -1666,11 +1666,29 @@ out:
 	return 0;
 }
 
-void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
+void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl)
 {
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *info;
 	struct rb_node *node;
+
+	spin_lock(&ctl->tree_lock);
+	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
+		info = rb_entry(node, struct btrfs_free_space, offset_index);
+		unlink_free_space(ctl, info);
+		kfree(info->bitmap);
+		kfree(info);
+		if (need_resched()) {
+			spin_unlock(&ctl->tree_lock);
+			cond_resched();
+			spin_lock(&ctl->tree_lock);
+		}
+	}
+	spin_unlock(&ctl->tree_lock);
+}
+
+void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
+{
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_cluster *cluster;
 	struct list_head *head;
 
@@ -1688,21 +1706,9 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 			spin_lock(&ctl->tree_lock);
 		}
 	}
-
-	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
-		info = rb_entry(node, struct btrfs_free_space, offset_index);
-		unlink_free_space(ctl, info);
-		if (info->bitmap)
-			kfree(info->bitmap);
-		kfree(info);
-		if (need_resched()) {
-			spin_unlock(&ctl->tree_lock);
-			cond_resched();
-			spin_lock(&ctl->tree_lock);
-		}
-	}
-
 	spin_unlock(&ctl->tree_lock);
+
+	__btrfs_remove_free_space_cache(ctl);
 }
 
 u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
@@ -2164,3 +2170,52 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 	cluster->block_group = NULL;
 }
 
+/*
+ * Find the left-most item in the cache tree, and then return the
+ * smallest inode number in the item.
+ *
+ * Note: the returned inode number may not be the smallest one in
+ * the tree, if the left-most item is a bitmap.
+ */
+u64 btrfs_find_ino_for_alloc(struct btrfs_root *fs_root)
+{
+	struct btrfs_free_space_ctl *ctl = fs_root->free_ino_ctl;
+	struct btrfs_free_space *entry = NULL;
+	u64 ino = 0;
+
+	spin_lock(&ctl->tree_lock);
+
+	if (RB_EMPTY_ROOT(&ctl->free_space_offset))
+		goto out;
+
+	entry = rb_entry(rb_first(&ctl->free_space_offset),
+			 struct btrfs_free_space, offset_index);
+
+	if (!entry->bitmap) {
+		ino = entry->offset;
+
+		unlink_free_space(ctl, entry);
+		entry->offset++;
+		entry->bytes--;
+		if (!entry->bytes)
+			kfree(entry);
+		else
+			link_free_space(ctl, entry);
+	} else {
+		u64 offset = 0;
+		u64 count = 1;
+		int ret;
+
+		ret = search_bitmap(ctl, entry, &offset, &count);
+		BUG_ON(ret);
+
+		ino = offset;
+		bitmap_clear_bits(ctl, entry, offset, 1);
+		if (entry->bytes == 0)
+			free_bitmap(ctl, entry);
+	}
+out:
+	spin_unlock(&ctl->tree_lock);
+
+	return ino;
+}
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 322b7e0..282eeda 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -64,15 +64,25 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 			  struct btrfs_trans_handle *trans,
 			  struct btrfs_block_group_cache *block_group,
 			  struct btrfs_path *path);
+
 void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group);
-int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
-			 u64 bytenr, u64 size);
+int __btrfs_add_free_space(struct btrfs_free_space_ctl *ctl,
+			   u64 bytenr, u64 size);
+static inline int
+btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+		     u64 bytenr, u64 size)
+{
+	return __btrfs_add_free_space(block_group->free_space_ctl,
+				      bytenr, size);
+}
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			    u64 bytenr, u64 size);
+void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl);
 void btrfs_remove_free_space_cache(struct btrfs_block_group_cache
-				   *block_group);
+				     *block_group);
 u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 			       u64 offset, u64 bytes, u64 empty_size);
+u64 btrfs_find_ino_for_alloc(struct btrfs_root *fs_root);
 void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 			   u64 bytes);
 int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index c56eb59..cfa9f5e 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -16,11 +16,343 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/pagemap.h>
+
 #include "ctree.h"
 #include "disk-io.h"
+#include "free-space-cache.h"
+#include "inode-map.h"
 #include "transaction.h"
 
-int btrfs_find_highest_inode(struct btrfs_root *root, u64 *objectid)
+static int caching_kthread(void *data)
+{
+	struct btrfs_root *root = data;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	u64 last = (u64)-1;
+	int slot;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/* Since the commit root is read-only, we can safely skip locking. */
+	path->skip_locking = 1;
+	path->search_commit_root = 1;
+	path->reada = 2;
+
+	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
+	key.offset = 0;
+	key.type = BTRFS_INODE_ITEM_KEY;
+again:
+	/* need to make sure the commit_root doesn't disappear */
+	mutex_lock(&root->fs_commit_mutex);
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		smp_mb();
+		if (fs_info->closing > 1)
+			goto out;
+
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out;
+			else if (ret > 0)
+				break;
+
+			if (need_resched() ||
+			    btrfs_transaction_in_commit(fs_info)) {
+				leaf = path->nodes[0];
+
+				if (btrfs_header_nritems(leaf) == 0) {
+					WARN_ON(1);
+					break;
+				}
+
+				/*
+				 * Save the key so we can advances forward
+				 * in the next search.
+				 */
+				btrfs_item_key_to_cpu(leaf, &key, 0);
+				btrfs_release_path(root, path);
+				root->cache_progress = last;
+				mutex_unlock(&root->fs_commit_mutex);
+				schedule_timeout(1);
+				goto again;
+			} else
+				continue;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		if (key.type != BTRFS_INODE_ITEM_KEY)
+			goto next;
+
+		if (key.objectid >= BTRFS_LAST_FREE_OBJECTID)
+			break;
+
+		if (last != (u64)-1 && last + 1 != key.objectid) {
+			__btrfs_add_free_space(ctl, last + 1,
+					       key.objectid - last - 1);
+			wake_up(&root->cache_wait);
+		}
+
+		last = key.objectid;
+next:
+		path->slots[0]++;
+	}
+
+	if (last < BTRFS_LAST_FREE_OBJECTID - 1) {
+		__btrfs_add_free_space(ctl, last + 1,
+				       BTRFS_LAST_FREE_OBJECTID - last - 1);
+	}
+
+	spin_lock(&root->cache_lock);
+	root->cached = BTRFS_CACHE_FINISHED;
+	spin_unlock(&root->cache_lock);
+
+	root->cache_progress = (u64)-1;
+	btrfs_unpin_free_ino(root);
+out:
+	wake_up(&root->cache_wait);
+	mutex_unlock(&root->fs_commit_mutex);
+
+	btrfs_free_path(path);
+
+	return ret;
+}
+
+static void start_caching(struct btrfs_root *root)
+{
+	struct task_struct *tsk;
+
+	spin_lock(&root->cache_lock);
+	if (root->cached != BTRFS_CACHE_NO) {
+		spin_unlock(&root->cache_lock);
+		return;
+	}
+
+	root->cached = BTRFS_CACHE_STARTED;
+	spin_unlock(&root->cache_lock);
+
+	tsk = kthread_run(caching_kthread, root, "btrfs-ino-cache-%llu\n",
+			  root->root_key.objectid);
+	BUG_ON(IS_ERR(tsk));
+}
+
+int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid)
+{
+again:
+	*objectid = btrfs_find_ino_for_alloc(root);
+
+	if (*objectid != 0)
+		return 0;
+
+	start_caching(root);
+
+	wait_event(root->cache_wait,
+		   root->cached == BTRFS_CACHE_FINISHED ||
+		   root->free_ino_ctl->free_space > 0);
+
+	if (root->cached == BTRFS_CACHE_FINISHED &&
+	    root->free_ino_ctl->free_space == 0)
+		return -ENOSPC;
+	else
+		goto again;
+}
+
+void btrfs_return_ino(struct btrfs_root *root, u64 objectid)
+{
+	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
+	struct btrfs_free_space_ctl *pinned = root->free_ino_pinned;
+again:
+	if (root->cached == BTRFS_CACHE_FINISHED) {
+		__btrfs_add_free_space(ctl, objectid, 1);
+	} else {
+		/*
+		 * If we are in the process of caching free ino chunks,
+		 * to avoid adding the same inode number to the free_ino
+		 * tree twice due to cross transaction, we'll leave it
+		 * in the pinned tree until a transaction is committed
+		 * or the caching work is done.
+		 */
+
+		mutex_lock(&root->fs_commit_mutex);
+		spin_lock(&root->cache_lock);
+		if (root->cached == BTRFS_CACHE_FINISHED) {
+			spin_unlock(&root->cache_lock);
+			mutex_unlock(&root->fs_commit_mutex);
+			goto again;
+		}
+		spin_unlock(&root->cache_lock);
+
+		start_caching(root);
+
+		if (objectid <= root->cache_progress)
+			__btrfs_add_free_space(ctl, objectid, 1);
+		else
+			__btrfs_add_free_space(pinned, objectid, 1);
+
+		mutex_unlock(&root->fs_commit_mutex);
+	}
+}
+
+/*
+ * When a transaction is committed, we'll move those inode numbers which
+ * are smaller than root->cache_progress from pinned tree to free_ino tree,
+ * and others will just be dropped, because the commit root we were
+ * searching has changed.
+ *
+ * Must be called with root->fs_commit_mutex held
+ */
+void btrfs_unpin_free_ino(struct btrfs_root *root)
+{
+	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
+	struct rb_root *rbroot = &root->free_ino_pinned->free_space_offset;
+	struct btrfs_free_space *info;
+	struct rb_node *n;
+	u64 count;
+
+	while (1) {
+		n = rb_first(rbroot);
+		if (!n)
+			break;
+
+		info = rb_entry(n, struct btrfs_free_space, offset_index);
+		BUG_ON(info->bitmap);
+
+		if (info->offset > root->cache_progress)
+			goto free;
+		else if (info->offset + info->bytes > root->cache_progress)
+			count = root->cache_progress - info->offset + 1;
+		else
+			count = info->bytes;
+
+		__btrfs_add_free_space(ctl, info->offset, count);
+free:
+		rb_erase(&info->offset_index, rbroot);
+		kfree(info);
+	}
+}
+
+#define INIT_THRESHOLD	(((1024 * 32) / 2) / sizeof(struct btrfs_free_space))
+#define INODES_PER_BITMAP (PAGE_CACHE_SIZE * 8)
+
+/*
+ * The goal is to keep the memory used by the free_ino tree won't
+ * exceed the memory if we use bitmaps only.
+ */
+static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
+{
+	struct btrfs_free_space *info;
+	struct rb_node *n;
+	int max_ino;
+	int max_bitmaps;
+
+	n = rb_last(&ctl->free_space_offset);
+	if (!n) {
+		ctl->extents_thresh = INIT_THRESHOLD;
+		return;
+	}
+	info = rb_entry(n, struct btrfs_free_space, offset_index);
+
+	/*
+	 * Find the maximum inode number in the filesystem. Note we
+	 * ignore the fact that this can be a bitmap, because we are
+	 * not doing precise calculation.
+	 */
+	max_ino = info->bytes - 1;
+
+	max_bitmaps = ALIGN(max_ino, INODES_PER_BITMAP) / INODES_PER_BITMAP;
+	if (max_bitmaps <= ctl->total_bitmaps) {
+		ctl->extents_thresh = 0;
+		return;
+	}
+
+	ctl->extents_thresh = (max_bitmaps - ctl->total_bitmaps) *
+				PAGE_CACHE_SIZE / sizeof(*info);
+}
+
+/*
+ * We don't fall back to bitmap, if we are below the extents threshold
+ * or this chunk of inode numbers is a big one.
+ */
+static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
+		       struct btrfs_free_space *info)
+{
+	if (ctl->free_extents < ctl->extents_thresh ||
+	    info->bytes > INODES_PER_BITMAP / 10)
+		return false;
+
+	return true;
+}
+
+static struct btrfs_free_space_op free_ino_op = {
+	.recalc_thresholds	= recalculate_thresholds,
+	.use_bitmap		= use_bitmap,
+};
+
+static void pinned_recalc_thresholds(struct btrfs_free_space_ctl *ctl)
+{
+}
+
+static bool pinned_use_bitmap(struct btrfs_free_space_ctl *ctl,
+			      struct btrfs_free_space *info)
+{
+	/*
+	 * We always use extents for two reasons:
+	 *
+	 * - The pinned tree is only used during the process of caching
+	 *   work.
+	 * - Make code simpler. See btrfs_unpin_free_ino().
+	 */
+	return false;
+}
+
+static struct btrfs_free_space_op pinned_free_ino_op = {
+	.recalc_thresholds	= pinned_recalc_thresholds,
+	.use_bitmap		= pinned_use_bitmap,
+};
+
+void btrfs_init_free_ino_ctl(struct btrfs_root *root)
+{
+	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
+	struct btrfs_free_space_ctl *pinned = root->free_ino_pinned;
+
+	spin_lock_init(&ctl->tree_lock);
+	ctl->unit = 1;
+	ctl->start = 0;
+	ctl->private = NULL;
+	ctl->op = &free_ino_op;
+
+	/*
+	 * Initially we allow to use 16K of ram to cache chunks of
+	 * inode numbers before we resort to bitmaps. This is somewhat
+	 * arbitrary, but it will be adjusted in runtime.
+	 */
+	ctl->extents_thresh = INIT_THRESHOLD;
+
+	spin_lock_init(&pinned->tree_lock);
+	pinned->unit = 1;
+	pinned->start = 0;
+	pinned->private = NULL;
+	pinned->extents_thresh = 0;
+	pinned->op = &pinned_free_ino_op;
+}
+
+static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -54,15 +386,14 @@ error:
 	return ret;
 }
 
-int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
-			     u64 dirid, u64 *objectid)
+int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
 {
 	int ret;
 	mutex_lock(&root->objectid_mutex);
 
 	if (unlikely(root->highest_objectid < BTRFS_FIRST_FREE_OBJECTID)) {
-		ret = btrfs_find_highest_inode(root, &root->highest_objectid);
+		ret = btrfs_find_highest_objectid(root,
+						  &root->highest_objectid);
 		if (ret)
 			goto out;
 	}
diff --git a/fs/btrfs/inode-map.h b/fs/btrfs/inode-map.h
new file mode 100644
index 0000000..eb91845
--- /dev/null
+++ b/fs/btrfs/inode-map.h
@@ -0,0 +1,11 @@
+#ifndef __BTRFS_INODE_MAP
+#define __BTRFS_INODE_MAP
+
+void btrfs_init_free_ino_ctl(struct btrfs_root *root);
+void btrfs_unpin_free_ino(struct btrfs_root *root);
+void btrfs_return_ino(struct btrfs_root *root, u64 objectid);
+int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid);
+
+int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid);
+
+#endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index db67821..5e48a6d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -50,6 +50,7 @@
 #include "tree-log.h"
 #include "compression.h"
 #include "locking.h"
+#include "inode-map.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -3784,6 +3785,10 @@ void btrfs_evict_inode(struct inode *inode)
 		BUG_ON(ret);
 	}
 
+	if (!(root == root->fs_info->tree_root ||
+	      root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID))
+		btrfs_return_ino(root, inode->i_ino);
+
 	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
@@ -4517,6 +4522,12 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
+	/*
+	 * we have to initialize this early, so we can reclaim the inode
+	 * number if we fail afterwards in this function.
+	 */
+	inode->i_ino = objectid;
+
 	if (dir) {
 		ret = btrfs_set_inode_index(dir, index);
 		if (ret) {
@@ -4559,7 +4570,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		goto fail;
 
 	inode_init_owner(inode, dir, mode);
-	inode->i_ino = objectid;
 	inode_set_bytes(inode, 0);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
@@ -4684,10 +4694,6 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
-	if (err)
-		return err;
-
 	/*
 	 * 2 for inode item and ref
 	 * 2 for dir items
@@ -4699,6 +4705,10 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 
 	btrfs_set_trans_block_group(trans, dir);
 
+	err = btrfs_find_free_ino(root, &objectid);
+	if (err)
+		goto out_unlock;
+
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, mode, &index);
@@ -4746,9 +4756,6 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	u64 objectid;
 	u64 index = 0;
 
-	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
-	if (err)
-		return err;
 	/*
 	 * 2 for inode item and ref
 	 * 2 for dir items
@@ -4760,6 +4767,10 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 
 	btrfs_set_trans_block_group(trans, dir);
 
+	err = btrfs_find_free_ino(root, &objectid);
+	if (err)
+		goto out_unlock;
+
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, mode, &index);
@@ -4871,10 +4882,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	u64 index = 0;
 	unsigned long nr = 1;
 
-	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
-	if (err)
-		return err;
-
 	/*
 	 * 2 items for inode and ref
 	 * 2 items for dir items
@@ -4885,6 +4892,10 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, dir);
 
+	err = btrfs_find_free_ino(root, &objectid);
+	if (err)
+		goto out_fail;
+
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, S_IFDIR | mode,
@@ -7079,9 +7090,6 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
 		return -ENAMETOOLONG;
 
-	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
-	if (err)
-		return err;
 	/*
 	 * 2 items for inode item and ref
 	 * 2 items for dir items
@@ -7093,6 +7101,10 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 
 	btrfs_set_trans_block_group(trans, dir);
 
+	err = btrfs_find_free_ino(root, &objectid);
+	if (err)
+		goto out_unlock;
+
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
 				BTRFS_I(dir)->block_group, S_IFLNK|S_IRWXUGO,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5fdb2ab..f679522 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -49,6 +49,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "locking.h"
+#include "inode-map.h"
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
@@ -244,8 +245,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
 
-	ret = btrfs_find_free_objectid(NULL, root->fs_info->tree_root,
-				       0, &objectid);
+	ret = btrfs_find_free_objectid(root->fs_info->tree_root, &objectid);
 	if (ret) {
 		dput(parent);
 		return ret;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 31ade58..a40f596 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -30,6 +30,7 @@
 #include "btrfs_inode.h"
 #include "async-thread.h"
 #include "free-space-cache.h"
+#include "inode-map.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -3891,7 +3892,7 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 	if (IS_ERR(trans))
 		return ERR_CAST(trans);
 
-	err = btrfs_find_free_objectid(trans, root, objectid, &objectid);
+	err = btrfs_find_free_objectid(root, &objectid);
 	if (err)
 		goto out;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3d73c8d..2d0caf8f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -27,6 +27,7 @@
 #include "transaction.h"
 #include "locking.h"
 #include "tree-log.h"
+#include "inode-map.h"
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
@@ -752,7 +753,11 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			btrfs_orphan_commit_root(trans, root);
 
 			if (root->commit_root != root->node) {
+				mutex_lock(&root->fs_commit_mutex);
 				switch_commit_root(root);
+				btrfs_unpin_free_ino(root);
+				mutex_unlock(&root->fs_commit_mutex);
+
 				btrfs_set_root_node(&root->root_item,
 						    root->node);
 			}
@@ -921,7 +926,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	ret = btrfs_find_free_objectid(trans, tree_root, 0, &objectid);
+	ret = btrfs_find_free_objectid(tree_root, &objectid);
 	if (ret) {
 		pending->error = ret;
 		goto fail;
-- 
1.7.3.1
