From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Various small fixes.
Date: Tue, 05 Aug 2008 11:18:46 +0800
Message-ID: <4897C696.7040602@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This trivial patch contains two locking fixes and a off by one fix.

Regards
YZ
---
diff -r 77cbca2f7ae4 ordered-data.c
--- a/ordered-data.c	Mon Aug 04 10:41:27 2008 -0400
+++ b/ordered-data.c	Mon Aug 04 10:17:36 2008 +0800
@@ -548,7 +550,7 @@ int btrfs_ordered_update_i_size(struct i
 		 */
 		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
 		if (test->file_offset > entry_end(ordered)) {
-			i_size_test = test->file_offset - 1;
+			i_size_test = test->file_offset;
 		}
 	} else {
 		i_size_test = i_size_read(inode);
@@ -561,7 +563,7 @@ int btrfs_ordered_update_i_size(struct i
 	 * disk_i_size to the end of the region.
 	 */
 	if (i_size_test > entry_end(ordered) &&
-	    !test_range_bit(io_tree, entry_end(ordered), i_size_test,
+	    !test_range_bit(io_tree, entry_end(ordered), i_size_test - 1,
 			   EXTENT_DELALLOC, 0)) {
 		new_i_size = min_t(u64, i_size_test, i_size_read(inode));
 	}
diff -r 77cbca2f7ae4 root-tree.c
--- a/root-tree.c	Mon Aug 04 10:41:27 2008 -0400
+++ b/root-tree.c	Thu Jul 31 09:47:57 2008 +0800
@@ -209,8 +209,7 @@ again:
 			goto err;
 		}
 
-		ret = btrfs_add_dead_root(dead_root, latest,
-					  &root->fs_info->dead_roots);
+		ret = btrfs_add_dead_root(dead_root, latest);
 		if (ret)
 			goto err;
 		goto again;
diff -r 77cbca2f7ae4 super.c
--- a/super.c	Mon Aug 04 10:41:27 2008 -0400
+++ b/super.c	Thu Jul 31 11:05:19 2008 +0800
@@ -449,7 +449,9 @@ static int btrfs_get_sb(struct file_syst
 		s->s_flags |= MS_ACTIVE;
 	}
 
+	mutex_lock(&s->s_root->d_inode->i_mutex);
 	root = lookup_one_len(subvol_name, s->s_root, strlen(subvol_name));
+	mutex_unlock(&s->s_root->d_inode->i_mutex);
 	if (IS_ERR(root)) {
 		up_write(&s->s_umount);
 		deactivate_super(s);
diff -r 77cbca2f7ae4 transaction.c
--- a/transaction.c	Mon Aug 04 10:41:27 2008 -0400
+++ b/transaction.c	Tue Aug 05 08:29:47 2008 +0800
@@ -389,9 +389,7 @@ int btrfs_commit_tree_roots(struct btrfs
 	return 0;
 }
 
-int btrfs_add_dead_root(struct btrfs_root *root,
-			struct btrfs_root *latest,
-			struct list_head *dead_list)
+int btrfs_add_dead_root(struct btrfs_root *root, struct btrfs_root *latest)
 {
 	struct btrfs_dirty_root *dirty;
 
@@ -400,7 +398,10 @@ int btrfs_add_dead_root(struct btrfs_roo
 		return -ENOMEM;
 	dirty->root = root;
 	dirty->latest_root = latest;
-	list_add(&dirty->list, dead_list);
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	list_add(&dirty->list, &latest->fs_info->dead_roots);
+	mutex_unlock(&root->fs_info->trans_mutex);
 	return 0;
 }
 
diff -r 77cbca2f7ae4 transaction.h
--- a/transaction.h	Mon Aug 04 10:41:27 2008 -0400
+++ b/transaction.h	Tue Aug 05 08:29:47 2008 +0800
@@ -90,8 +90,7 @@ int btrfs_commit_tree_roots(struct btrfs
 int btrfs_commit_tree_roots(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
 
-int btrfs_add_dead_root(struct btrfs_root *root, struct btrfs_root *latest,
-			struct list_head *dead_list);
+int btrfs_add_dead_root(struct btrfs_root *root, struct btrfs_root *latest);
 int btrfs_defrag_root(struct btrfs_root *root, int cacheonly);
 int btrfs_clean_old_snapshots(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
