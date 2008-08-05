From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] nodatacow fix
Date: Tue, 05 Aug 2008 22:15:12 +0800
Message-ID: <48986070.9010900@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch adapts nodatacow code for the new data ordered code. Ordered
extents are used in all cases. It avoid writepage_start_hook kicking off
nodatacow IO contiguously. This patch also makes btrfs wait for ordered
extents before creating snapshots. It's important for nodatcow IO since
creating snapshots invalidates the results of reference checking.

Regards
YZ
--- 
diff -r b1c27a6f049b ctree.h
--- a/ctree.h	Mon Aug 04 23:23:47 2008 -0400
+++ b/ctree.h	Tue Aug 05 13:24:56 2008 +0800
@@ -1403,7 +1403,8 @@ static inline struct dentry *fdentry(str
 }
 
 /* extent-tree.c */
-int btrfs_cross_ref_exists(struct btrfs_root *root,
+int btrfs_cross_ref_exists(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
 			   struct btrfs_key *key, u64 bytenr);
 int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root);
diff -r b1c27a6f049b extent-tree.c
--- a/extent-tree.c	Mon Aug 04 23:23:47 2008 -0400
+++ b/extent-tree.c	Tue Aug 05 13:24:56 2008 +0800
@@ -893,10 +893,10 @@ out:
 	return ret;
 }
 
-int btrfs_cross_ref_exists(struct btrfs_root *root,
+int btrfs_cross_ref_exists(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
 			   struct btrfs_key *key, u64 bytenr)
 {
-	struct btrfs_trans_handle *trans;
 	struct btrfs_root *old_root;
 	struct btrfs_path *path = NULL;
 	struct extent_buffer *eb;
@@ -908,6 +908,7 @@ int btrfs_cross_ref_exists(struct btrfs_
 	int level;
 	int ret;
 
+	BUG_ON(trans == NULL);
 	BUG_ON(key->type != BTRFS_EXTENT_DATA_KEY);
 	ret = get_reference_status(root, bytenr, 0, key->objectid,
 				   &min_generation, &ref_count);
@@ -917,7 +918,6 @@ int btrfs_cross_ref_exists(struct btrfs_
 	if (ref_count != 1)
 		return 1;
 
-	trans = btrfs_start_transaction(root, 0);
 	old_root = root->dirty_root->root;
 	ref_generation = old_root->root_key.offset;
 
@@ -973,7 +973,6 @@ out:
 out:
 	if (path)
 		btrfs_free_path(path);
-	btrfs_end_transaction(trans, root);
 	return ret;
 }
 
diff -r b1c27a6f049b inode.c
--- a/inode.c	Mon Aug 04 23:23:47 2008 -0400
+++ b/inode.c	Tue Aug 05 13:29:40 2008 +0800
@@ -166,7 +166,7 @@ static int cow_file_range(struct inode *
 
 		cur_alloc_size = ins.offset;
 		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-					       ins.offset);
+					       ins.offset, 0);
 		BUG_ON(ret);
 		if (num_bytes < cur_alloc_size) {
 			printk("num_bytes %Lu cur_alloc %Lu\n", num_bytes,
@@ -187,31 +187,32 @@ static int run_delalloc_nocow(struct ino
 	u64 extent_start;
 	u64 extent_end;
 	u64 bytenr;
-	u64 cow_end;
 	u64 loops = 0;
 	u64 total_fs_bytes;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_group_cache *block_group;
+	struct btrfs_trans_handle *trans;
 	struct extent_buffer *leaf;
 	int found_type;
 	struct btrfs_path *path;
 	struct btrfs_file_extent_item *item;
 	int ret;
-	int err;
+	int err = 0;
 	struct btrfs_key found_key;
 
 	total_fs_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
+	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(!trans);
 again:
 	ret = btrfs_lookup_file_extent(NULL, root, path,
 				       inode->i_ino, start, 0);
 	if (ret < 0) {
-		btrfs_free_path(path);
-		return ret;
-	}
-
-	cow_end = end;
+		err = ret;
+		goto out;
+	}
+
 	if (ret != 0) {
 		if (path->slots[0] == 0)
 			goto not_found;
@@ -244,12 +245,11 @@ again:
 		if (start < extent_start || start >= extent_end)
 			goto not_found;
 
-		cow_end = min(end, extent_end - 1);
 		bytenr = btrfs_file_extent_disk_bytenr(leaf, item);
 		if (bytenr == 0)
 			goto not_found;
 
-		if (btrfs_cross_ref_exists(root, &found_key, bytenr))
+		if (btrfs_cross_ref_exists(trans, root, &found_key, bytenr))
 			goto not_found;
 		/*
 		 * we may be called by the resizer, make sure we're inside
@@ -260,24 +260,32 @@ again:
 		if (!block_group || block_group->ro)
 			goto not_found;
 
+		bytenr += btrfs_file_extent_offset(leaf, item);
+		extent_num_bytes = min(end + 1, extent_end) - start;
+		ret = btrfs_add_ordered_extent(inode, start, bytenr,
+						extent_num_bytes, 1);
+		if (ret) {
+			err = ret;
+			goto out;
+		}
+
+		btrfs_release_path(root, path);
 		start = extent_end;
+		if (start <= end) {
+			loops++;
+			goto again;
+		}
 	} else {
-		goto not_found;
-	}
-loop:
-	if (start > end) {
+not_found:
+		btrfs_end_transaction(trans, root);
 		btrfs_free_path(path);
-		return 0;
-	}
-	btrfs_release_path(root, path);
-	loops++;
-	goto again;
-
-not_found:
-	btrfs_release_path(root, path);
-	cow_file_range(inode, start, end);
-	start = end + 1;
-	goto loop;
+		return cow_file_range(inode, start, end);
+	}
+out:
+	WARN_ON(err);
+	btrfs_end_transaction(trans, root);
+	btrfs_free_path(path);
+	return err;
 }
 
 static int run_delalloc_range(struct inode *inode, u64 start, u64 end)
@@ -382,6 +390,11 @@ int btrfs_submit_bio_hook(struct inode *
 	BUG_ON(ret);
 
 	if (!(rw & (1 << BIO_RW))) {
+		goto mapit;
+	}
+
+	if (btrfs_test_opt(root, NODATASUM) ||
+	    btrfs_test_flag(inode, NODATASUM)) {
 		goto mapit;
 	}
 
@@ -527,6 +540,8 @@ static int btrfs_finish_ordered_io(struc
 
 	ordered_extent = btrfs_lookup_ordered_extent(inode, start);
 	BUG_ON(!ordered_extent);
+	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags))
+		goto nocow;
 
 	lock_extent(io_tree, ordered_extent->file_offset,
 		    ordered_extent->file_offset + ordered_extent->len - 1,
@@ -567,6 +582,7 @@ static int btrfs_finish_ordered_io(struc
 	unlock_extent(io_tree, ordered_extent->file_offset,
 		    ordered_extent->file_offset + ordered_extent->len - 1,
 		    GFP_NOFS);
+nocow:
 	add_pending_csums(trans, inode, ordered_extent->file_offset,
 			  &ordered_extent->list);
 
diff -r b1c27a6f049b ioctl.c
--- a/ioctl.c	Mon Aug 04 23:23:47 2008 -0400
+++ b/ioctl.c	Tue Aug 05 15:12:00 2008 +0800
@@ -36,6 +36,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/version.h>
 #include <linux/xattr.h>
+#include <linux/vmalloc.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff -r b1c27a6f049b ordered-data.c
--- a/ordered-data.c	Mon Aug 04 23:23:47 2008 -0400
+++ b/ordered-data.c	Tue Aug 05 13:24:56 2008 +0800
@@ -152,7 +152,7 @@ static inline struct rb_node *tree_searc
  * inserted.
  */
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
-			     u64 start, u64 len)
+			     u64 start, u64 len, int nocow)
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
@@ -168,6 +168,8 @@ int btrfs_add_ordered_extent(struct inod
 	entry->start = start;
 	entry->len = len;
 	entry->inode = inode;
+	if (nocow)
+		set_bit(BTRFS_ORDERED_NOCOW, &entry->flags);
 
 	/* one ref for the tree */
 	atomic_set(&entry->refs, 1);
diff -r b1c27a6f049b ordered-data.h
--- a/ordered-data.h	Mon Aug 04 23:23:47 2008 -0400
+++ b/ordered-data.h	Tue Aug 05 13:24:56 2008 +0800
@@ -64,6 +64,8 @@ struct btrfs_ordered_sum {
 
 #define BTRFS_ORDERED_COMPLETE 1 /* set when removed from the tree */
 
+#define BTRFS_ORDERED_NOCOW 2 /* set when we want to write in place */
+
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
 	u64 file_offset;
@@ -125,7 +127,7 @@ int btrfs_dec_test_ordered_pending(struc
 int btrfs_dec_test_ordered_pending(struct inode *inode,
 				       u64 file_offset, u64 io_size);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
-			     u64 start, u64 len);
+			     u64 start, u64 len, int nocow);
 int btrfs_add_ordered_sum(struct inode *inode,
 			  struct btrfs_ordered_extent *entry,
 			  struct btrfs_ordered_sum *sum);
diff -r b1c27a6f049b transaction.c
--- a/transaction.c	Mon Aug 04 23:23:47 2008 -0400
+++ b/transaction.c	Tue Aug 05 13:24:56 2008 +0800
@@ -438,6 +438,7 @@ static noinline int add_dirty_roots(stru
 
 				free_extent_buffer(root->commit_root);
 				root->commit_root = NULL;
+				root->dirty_root = NULL;
 
 				spin_lock(&root->list_lock);
 				list_del_init(&dirty->root->dead_list);
@@ -461,6 +462,7 @@ static noinline int add_dirty_roots(stru
 			       sizeof(struct btrfs_disk_key));
 			root->root_item.drop_level = 0;
 			root->commit_root = NULL;
+			root->dirty_root = NULL;
 			root->root_key.offset = root->fs_info->generation;
 			btrfs_set_root_bytenr(&root->root_item,
 					      root->node->start);
@@ -762,7 +764,11 @@ int btrfs_commit_transaction(struct btrf
 	}
 
 	do {
+		int snap_pending = 0;
 		joined = cur_trans->num_joined;
+		if (!list_empty(&trans->transaction->pending_snapshots))
+			snap_pending = 1;
+
 		WARN_ON(cur_trans != trans->transaction);
 		prepare_to_wait(&cur_trans->writer_wait, &wait,
 				TASK_UNINTERRUPTIBLE);
@@ -773,6 +779,11 @@ int btrfs_commit_transaction(struct btrf
 			timeout = 1;
 
 		mutex_unlock(&root->fs_info->trans_mutex);
+
+		if (snap_pending) {
+			ret = btrfs_wait_ordered_extents(root);
+			BUG_ON(ret);
+		}
 
 		schedule_timeout(timeout);
 
