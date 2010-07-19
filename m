From: Matt Lupfer <mlupfer@gmail.com>
Subject: [PATCH] Btrfs: checkpatch fixes in various files
Date: Mon, 19 Jul 2010 14:53:31 -0500
Message-ID: <1279569211-21657-1-git-send-email-mrlupfer@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, Matt Lupfer <mrlupfer@us.ibm.com>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Matt Lupfer <mrlupfer@us.ibm.com>

Fixes innocuous style issues identified by the checkpatch stript.

Signed-off-by: Matt Lupfer <mrlupfer@us.ibm.com>
Reviewed-by: Ben Chociej <bcchocie@us.ibm.com>
Reviewed-by: Conor Scott <crscott@us.ibm.com>
Reviewed-by: Steve French <sfrench@us.ibm.com>
---
 fs/btrfs/async-thread.c     |    2 +-
 fs/btrfs/disk-io.c          |    4 ++--
 fs/btrfs/export.c           |    3 ++-
 fs/btrfs/extent-tree.c      |    8 ++++----
 fs/btrfs/extent_io.h        |    4 ++--
 fs/btrfs/extent_map.h       |    8 ++++----
 fs/btrfs/free-space-cache.c |   20 +++++++++-----------
 fs/btrfs/inode.c            |   27 +++++++++++++++------------
 fs/btrfs/ioctl.c            |   19 +++++++++++--------
 fs/btrfs/locking.c          |    4 ++--
 fs/btrfs/ordered-data.c     |    3 +--
 fs/btrfs/ordered-data.h     |    7 ++++---
 fs/btrfs/tree-log.c         |    4 ++--
 fs/btrfs/tree-log.h         |    3 ++-
 fs/btrfs/volumes.c          |    4 ++--
 15 files changed, 63 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..e142da3 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -260,7 +260,7 @@ static struct btrfs_work *get_next_work(struct btrfs_worker_thread *worker,
 	struct btrfs_work *work = NULL;
 	struct list_head *cur = NULL;
 
-	if(!list_empty(prio_head))
+	if (!list_empty(prio_head))
 		cur = prio_head->next;
 
 	smp_mb();
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..4513eaf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -243,8 +243,8 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 				       "failed on %llu wanted %X found %X "
 				       "level %d\n",
 				       root->fs_info->sb->s_id,
-				       (unsigned long long)buf->start, val, found,
-				       btrfs_header_level(buf));
+				       (unsigned long long)buf->start, val,
+				       found, btrfs_header_level(buf));
 			}
 			if (result != (char *)&inline_result)
 				kfree(result);
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 951ef09..e7e5463 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -223,7 +223,8 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
-	dentry = d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root, NULL));
+	dentry = d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root,
+		NULL));
 	if (!IS_ERR(dentry))
 		dentry->d_op = &btrfs_dentry_operations;
 	return dentry;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a46b64d..1298500 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4578,9 +4578,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 			empty_cluster = 64 * 1024;
 	}
 
-	if ((data & BTRFS_BLOCK_GROUP_DATA) && btrfs_test_opt(root, SSD)) {
+	if ((data & BTRFS_BLOCK_GROUP_DATA) && btrfs_test_opt(root, SSD))
 		last_ptr = &root->fs_info->data_alloc_cluster;
-	}
 
 	if (last_ptr) {
 		spin_lock(&last_ptr->lock);
@@ -4642,7 +4641,8 @@ have_block_group:
 		if (unlikely(block_group->cached == BTRFS_CACHE_NO)) {
 			u64 free_percent;
 
-			free_percent = btrfs_block_group_used(&block_group->item);
+			free_percent = btrfs_block_group_used(
+				&block_group->item);
 			free_percent *= 100;
 			free_percent = div64_u64(free_percent,
 						 block_group->key.offset);
@@ -7862,7 +7862,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 
 	release_global_block_rsv(info);
 
-	while(!list_empty(&info->space_info)) {
+	while (!list_empty(&info->space_info)) {
 		space_info = list_entry(info->space_info.next,
 					struct btrfs_space_info,
 					list);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5691c7b..2ebfef0 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -184,8 +184,8 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		      int bits, gfp_t mask);
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, int wake, int delete, struct extent_state **cached,
-		     gfp_t mask);
+		     int bits, int wake, int delete,
+		     struct extent_state **cached, gfp_t mask);
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		    int bits, gfp_t mask);
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index ab6d74b..2dc41dc 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -3,10 +3,10 @@
 
 #include <linux/rbtree.h>
 
-#define EXTENT_MAP_LAST_BYTE (u64)-4
-#define EXTENT_MAP_HOLE (u64)-3
-#define EXTENT_MAP_INLINE (u64)-2
-#define EXTENT_MAP_DELALLOC (u64)-1
+#define EXTENT_MAP_LAST_BYTE ((u64)-4)
+#define EXTENT_MAP_HOLE ((u64)-3)
+#define EXTENT_MAP_INLINE ((u64)-2)
+#define EXTENT_MAP_DELALLOC ((u64)-1)
 
 /* bits for the flags field */
 #define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free it */
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f488fac..73fc7b0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -418,9 +418,9 @@ static void add_new_bitmap(struct btrfs_block_group_cache *block_group,
 	recalculate_thresholds(block_group);
 }
 
-static noinline int remove_from_bitmap(struct btrfs_block_group_cache *block_group,
-			      struct btrfs_free_space *bitmap_info,
-			      u64 *offset, u64 *bytes)
+static noinline int remove_from_bitmap(struct btrfs_block_group_cache
+			      *block_group, struct btrfs_free_space
+			      *bitmap_info, u64 *offset, u64 *bytes)
 {
 	u64 end;
 	u64 search_start, search_bytes;
@@ -597,11 +597,9 @@ new_bitmap:
 	}
 
 out:
-	if (info) {
-		if (info->bitmap)
-			kfree(info->bitmap);
-		kfree(info);
-	}
+	if (info)
+		kfree(info->bitmap);
+	kfree(info);
 
 	return ret;
 }
@@ -904,8 +902,8 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 	while ((node = rb_last(&block_group->free_space_offset)) != NULL) {
 		info = rb_entry(node, struct btrfs_free_space, offset_index);
 		unlink_free_space(block_group, info);
-		if (info->bitmap)
-			kfree(info->bitmap);
+
+		kfree(info->bitmap);
 		kfree(info);
 		if (need_resched()) {
 			spin_unlock(&block_group->tree_lock);
@@ -1073,7 +1071,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 
 	entry = rb_entry(node, struct btrfs_free_space, offset_index);
 
-	while(1) {
+	while (1) {
 		if (entry->bytes < bytes || entry->offset < min_start) {
 			struct rb_node *node;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f08427c..3be0df0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5733,8 +5733,8 @@ free_ordered:
 	bio_endio(bio, ret);
 }
 
-static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
+static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb
+			*iocb, const struct iovec *iov, loff_t offset,
 			unsigned long nr_segs)
 {
 	int seg;
@@ -5752,7 +5752,7 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 		addr = (unsigned long)iov[seg].iov_base;
 		size = iov[seg].iov_len;
 		end += size;
-		if ((addr & blocksize_mask) || (size & blocksize_mask)) 
+		if ((addr & blocksize_mask) || (size & blocksize_mask))
 			goto out;
 	}
 	retval = 0;
@@ -5799,8 +5799,8 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 						     lockend - lockstart + 1);
 		if (!ordered)
 			break;
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     &cached_state, GFP_NOFS);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockend, &cached_state, GFP_NOFS);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 		cond_resched();
@@ -5812,9 +5812,9 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (writing) {
 		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
-		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     EXTENT_DELALLOC, 0, NULL, &cached_state,
-				     GFP_NOFS);
+		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockend, EXTENT_DELALLOC, 0, NULL,
+				     &cached_state, GFP_NOFS);
 		if (ret) {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 					 lockend, EXTENT_LOCKED | write_bits,
@@ -6093,7 +6093,8 @@ again:
 	BTRFS_I(inode)->last_trans = root->fs_info->generation;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 
-	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
+	unlock_extent_cached(io_tree, page_start, page_end, &cached_state,
+		GFP_NOFS);
 
 out_unlock:
 	if (!ret)
@@ -6376,7 +6377,8 @@ int btrfs_init_cachep(void)
 	if (!btrfs_inode_cachep)
 		goto fail;
 
-	btrfs_trans_handle_cachep = kmem_cache_create("btrfs_trans_handle_cache",
+	btrfs_trans_handle_cachep = kmem_cache_create(
+			"btrfs_trans_handle_cache",
 			sizeof(struct btrfs_trans_handle), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_trans_handle_cachep)
@@ -6791,7 +6793,7 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  BTRFS_FILE_EXTENT_PREALLOC);
 		BUG_ON(ret);
 		btrfs_drop_extent_cache(inode, cur_offset,
-					cur_offset + ins.offset -1, 0);
+					cur_offset + ins.offset - 1, 0);
 
 		num_bytes -= ins.offset;
 		cur_offset += ins.offset;
@@ -6927,7 +6929,8 @@ static int btrfs_set_page_dirty(struct page *page)
 
 static int btrfs_permission(struct inode *inode, int mask)
 {
-	if ((BTRFS_I(inode)->flags & BTRFS_INODE_READONLY) && (mask & MAY_WRITE))
+	if ((BTRFS_I(inode)->flags & BTRFS_INODE_READONLY) && (mask &
+		MAY_WRITE))
 		return -EACCES;
 	return generic_permission(inode, mask, btrfs_check_acl);
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4dbaf89..2fd0bed 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -677,8 +677,10 @@ loop_unlock:
 		while (atomic_read(&root->fs_info->nr_async_submits) ||
 		      atomic_read(&root->fs_info->async_delalloc_pages)) {
 			wait_event(root->fs_info->async_submit_wait,
-			   (atomic_read(&root->fs_info->nr_async_submits) == 0 &&
-			    atomic_read(&root->fs_info->async_delalloc_pages) == 0));
+			   (atomic_read(&root->fs_info->
+					nr_async_submits) == 0 &&
+			    atomic_read(&root->fs_info->
+					async_delalloc_pages) == 0));
 		}
 		atomic_dec(&root->fs_info->async_submit_draining);
 
@@ -987,7 +989,8 @@ advance_key:
 	else if (key->type < (u8)-1 && key->type < sk->max_type) {
 		key->offset = 0;
 		key->type++;
-	} else if (key->objectid < (u64)-1 && key->objectid < sk->max_objectid) {
+	} else if (key->objectid < (u64)-1 && key->objectid <
+						sk->max_objectid) {
 		key->offset = 0;
 		key->type = 0;
 		key->objectid++;
@@ -1041,7 +1044,7 @@ static noinline int search_ioctl(struct inode *inode,
 
 	path->keep_locks = 1;
 
-	while(1) {
+	while (1) {
 		ret = btrfs_search_forward(root, &key, &max_key, path, 0,
 					   sk->min_transid);
 		if (ret != 0) {
@@ -1108,7 +1111,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	struct btrfs_path *path;
 
 	if (dirid == BTRFS_FIRST_FREE_OBJECTID) {
-		name[0]='\0';
+		name[0] = '\0';
 		return 0;
 	}
 
@@ -1132,7 +1135,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	key.type = BTRFS_INODE_REF_KEY;
 	key.offset = (u64)-1;
 
-	while(1) {
+	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
@@ -1157,7 +1160,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 			goto out;
 
 		*(ptr + len) = '/';
-		read_extent_buffer(l, ptr,(unsigned long)(iref + 1), len);
+		read_extent_buffer(l, ptr, (unsigned long)(iref + 1), len);
 
 		if (key.offset == BTRFS_FIRST_FREE_OBJECTID)
 			break;
@@ -1171,7 +1174,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	if (ptr < name)
 		goto out;
 	memcpy(name, ptr, total_len);
-	name[total_len]='\0';
+	name[total_len] = '\0';
 	ret = 0;
 out:
 	btrfs_free_path(path);
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 6151f2e..f878cd6 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -19,7 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/spinlock.h>
 #include <linux/page-flags.h>
-#include <asm/bug.h>
+#include <linux/bug.h>
 #include "ctree.h"
 #include "extent_io.h"
 #include "locking.h"
@@ -153,7 +153,7 @@ int btrfs_tree_lock(struct extent_buffer *eb)
 	if (!btrfs_spin_on_block(eb))
 		goto sleep;
 
-	while(1) {
+	while (1) {
 		spin_nested(eb);
 
 		/* nobody is blocking, exit with the spinlock held */
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e56c72b..81ad705 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -711,9 +711,8 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	 * if the disk i_size is already at the inode->i_size, or
 	 * this ordered extent is inside the disk i_size, we're done
 	 */
-	if (disk_i_size == i_size || offset <= disk_i_size) {
+	if (disk_i_size == i_size || offset <= disk_i_size)
 		goto out;
-	}
 
 	/*
 	 * we can't update the disk_isize if there are delalloc bytes
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 8ac3654..cd05b79 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -153,14 +153,15 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 void btrfs_start_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry, int wait);
 int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len);
-struct btrfs_ordered_extent *
-btrfs_lookup_first_ordered_extent(struct inode * inode, u64 file_offset);
+struct btrfs_ordered_extent *btrfs_lookup_first_ordered_extent(struct inode
+						*inode, u64 file_offset);
 struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 							u64 file_offset,
 							u64 len);
 int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
-int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr, u32 *sum);
+int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
+				u32 *sum);
 int btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
 int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index fb102a9..2b02076 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2749,7 +2749,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	/* today the code can only do partial logging of directories */
 	if (!S_ISDIR(inode->i_mode))
-	    inode_only = LOG_INODE_ALL;
+		inode_only = LOG_INODE_ALL;
 
 	if (inode_only == LOG_INODE_EXISTS || S_ISDIR(inode->i_mode))
 		max_key.type = BTRFS_XATTR_ITEM_KEY;
@@ -3236,7 +3236,7 @@ int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 			struct inode *inode, struct inode *old_dir,
 			struct dentry *parent)
 {
-	struct btrfs_root * root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	/*
 	 * this will force the logging code to walk the dentry chain
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 3dfae84..7d9b17e 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -19,7 +19,8 @@
 #ifndef __TREE_LOG_
 #define __TREE_LOG_
 
-/* return value for btrfs_log_dentry_safe that means we don't need to log it at all */
+/* return value for btrfs_log_dentry_safe that means we don't need
+ * to log it at all */
 #define BTRFS_NO_LOG_SYNC 256
 
 int btrfs_sync_log(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d6e3af8..a71e605 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -240,8 +240,8 @@ loop_lock:
 		if ((num_run > 32 &&
 		    pending_bios != &device->pending_sync_bios &&
 		    device->pending_sync_bios.head) ||
-		   (num_run > 64 && pending_bios == &device->pending_sync_bios &&
-		    device->pending_bios.head)) {
+		   (num_run > 64 && pending_bios == &device->pending_sync_bios
+		    && device->pending_bios.head)) {
 			spin_lock(&device->io_lock);
 			requeue_list(pending_bios, pending, tail);
 			goto loop_lock;
-- 
1.7.1

