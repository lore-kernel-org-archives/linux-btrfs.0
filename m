Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44061 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935001AbcCPIoU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 04:44:20 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH] btrfs: rename btrfs_std_error() to btrfs_handle_fs_error()
Date: Wed, 16 Mar 2016 16:43:06 +0800
Message-Id: <1458117788-840-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
References: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_std_error() handles errors, puts FS into readonly mode
(as of now). So its good idea to rename it to btrfs_handle_fs_error().
So that bugs like
  btrfs: pass the error code to the btrfs_std_error and log ret
(in the ML) may be avoided.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.c       |  6 +++---
 fs/btrfs/ctree.h       |  6 +++---
 fs/btrfs/disk-io.c     |  8 ++++----
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/inode-item.c  |  2 +-
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/relocation.c  |  2 +-
 fs/btrfs/root-tree.c   |  4 ++--
 fs/btrfs/super.c       |  6 +++---
 fs/btrfs/transaction.c |  2 +-
 fs/btrfs/tree-log.c    |  8 ++++----
 fs/btrfs/volumes.c     | 14 +++++++-------
 12 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 769e0ff1b4ce..b12d0815a754 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1011,7 +1011,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			return ret;
 		if (refs == 0) {
 			ret = -EROFS;
-			btrfs_std_error(root->fs_info, ret, NULL);
+			btrfs_handle_fs_error(root->fs_info, ret, NULL);
 			return ret;
 		}
 	} else {
@@ -1927,7 +1927,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		child = read_node_slot(root, mid, 0);
 		if (!child) {
 			ret = -EROFS;
-			btrfs_std_error(root->fs_info, ret, NULL);
+			btrfs_handle_fs_error(root->fs_info, ret, NULL);
 			goto enospc;
 		}
 
@@ -2030,7 +2030,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		 */
 		if (!left) {
 			ret = -EROFS;
-			btrfs_std_error(root->fs_info, ret, NULL);
+			btrfs_handle_fs_error(root->fs_info, ret, NULL);
 			goto enospc;
 		}
 		wret = balance_node_right(trans, root, mid, left);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c9fb7b9ca8a4..d6ae2d324080 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4286,7 +4286,7 @@ static inline void assfail(char *expr, char *file, int line)
 #define btrfs_assert()
 __printf(5, 6)
 __cold
-void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
+void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function,
 		     unsigned int line, int errno, const char *fmt, ...);
 
 const char *btrfs_decode_error(int errno);
@@ -4429,9 +4429,9 @@ do {								\
 				  __LINE__, (errno));		\
 } while (0)
 
-#define btrfs_std_error(fs_info, errno, fmt, args...)		\
+#define btrfs_handle_fs_error(fs_info, errno, fmt, args...)		\
 do {								\
-	__btrfs_std_error((fs_info), __func__, __LINE__,	\
+	__btrfs_handle_fs_error((fs_info), __func__, __LINE__,	\
 			  (errno), fmt, ##args);		\
 } while (0)
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f76b0d96ffdb..b59c98c723f7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2410,7 +2410,7 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	/* returns with log_tree_root freed on success */
 	ret = btrfs_recover_log_trees(log_tree_root);
 	if (ret) {
-		btrfs_std_error(tree_root->fs_info, ret,
+		btrfs_handle_fs_error(tree_root->fs_info, ret,
 			    "Failed to recover log tree");
 		free_extent_buffer(log_tree_root->node);
 		kfree(log_tree_root);
@@ -3631,7 +3631,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		if (ret) {
 			mutex_unlock(
 				&root->fs_info->fs_devices->device_list_mutex);
-			btrfs_std_error(root->fs_info, ret,
+			btrfs_handle_fs_error(root->fs_info, ret,
 				    "errors while submitting device barriers.");
 			return ret;
 		}
@@ -3671,7 +3671,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 		/* FUA is masked off if unsupported and can't be the reason */
-		btrfs_std_error(root->fs_info, -EIO,
+		btrfs_handle_fs_error(root->fs_info, -EIO,
 			    "%d errors while writing supers", total_errors);
 		return -EIO;
 	}
@@ -3689,7 +3689,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	}
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 	if (total_errors > max_errors) {
-		btrfs_std_error(root->fs_info, -EIO,
+		btrfs_handle_fs_error(root->fs_info, -EIO,
 			    "%d errors while writing supers", total_errors);
 		return -EIO;
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2287c7c10be..26c340cb9fee 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9052,7 +9052,7 @@ out:
 	if (!for_reloc && root_dropped == false)
 		btrfs_add_dead_root(root);
 	if (err && err != -EAGAIN)
-		btrfs_std_error(root->fs_info, err, NULL);
+		btrfs_handle_fs_error(root->fs_info, err, NULL);
 	return err;
 }
 
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index be4d22a5022f..b8acc07ac6c2 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -157,7 +157,7 @@ static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 	 */
 	if (!btrfs_find_name_in_ext_backref(path, ref_objectid,
 					    name, name_len, &extref)) {
-		btrfs_std_error(root->fs_info, -ENOENT, NULL);
+		btrfs_handle_fs_error(root->fs_info, -ENOENT, NULL);
 		ret = -EROFS;
 		goto out;
 	}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 49d65c648476..6174e9ac2199 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4830,7 +4830,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	/* update qgroup status and info */
 	err = btrfs_run_qgroups(trans, root->fs_info);
 	if (err < 0)
-		btrfs_std_error(root->fs_info, err,
+		btrfs_handle_fs_error(root->fs_info, err,
 			    "failed to update qgroup status and info\n");
 	err = btrfs_end_transaction(trans, root);
 	if (err && !ret)
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2bd0011450df..7328ecbb090b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2417,7 +2417,7 @@ again:
 	}
 out:
 	if (ret) {
-		btrfs_std_error(root->fs_info, ret, NULL);
+		btrfs_handle_fs_error(root->fs_info, ret, NULL);
 		if (!list_empty(&reloc_roots))
 			free_reloc_roots(&reloc_roots);
 
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 7cf8509deda7..867639010259 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -284,7 +284,7 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 			trans = btrfs_join_transaction(tree_root);
 			if (IS_ERR(trans)) {
 				err = PTR_ERR(trans);
-				btrfs_std_error(tree_root->fs_info, err,
+				btrfs_handle_fs_error(tree_root->fs_info, err,
 					    "Failed to start trans to delete "
 					    "orphan item");
 				break;
@@ -293,7 +293,7 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 						    root_key.objectid);
 			btrfs_end_transaction(trans, tree_root);
 			if (err) {
-				btrfs_std_error(tree_root->fs_info, err,
+				btrfs_handle_fs_error(tree_root->fs_info, err,
 					    "Failed to delete root orphan "
 					    "item");
 				break;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a11823b317ac..637c2272ee4b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -131,11 +131,11 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 }
 
 /*
- * __btrfs_std_error decodes expected errors from the caller and
+ * __btrfs_handle_fs_error decodes expected errors from the caller and
  * invokes the approciate error response.
  */
 __cold
-void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
+void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function,
 		       unsigned int line, int errno, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
@@ -252,7 +252,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 	/* Wake up anybody who may be waiting on this transaction */
 	wake_up(&root->fs_info->transaction_wait);
 	wake_up(&root->fs_info->transaction_blocked_wait);
-	__btrfs_std_error(root->fs_info, function, line, errno, NULL);
+	__btrfs_handle_fs_error(root->fs_info, function, line, errno, NULL);
 }
 /*
  * __btrfs_panic decodes unexpected, fatal errors from the caller,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b6031ce474f7..5d569d7fd5c8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2138,7 +2138,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_write_and_wait_transaction(trans, root);
 	if (ret) {
-		btrfs_std_error(root->fs_info, ret,
+		btrfs_handle_fs_error(root->fs_info, ret,
 			    "Error while writing out transaction");
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		goto scrub_continue;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3c0a24f289a2..698e09cf2c46 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5333,7 +5333,7 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 
 	ret = walk_log_tree(trans, log_root_tree, &wc);
 	if (ret) {
-		btrfs_std_error(fs_info, ret, "Failed to pin buffers while "
+		btrfs_handle_fs_error(fs_info, ret, "Failed to pin buffers while "
 			    "recovering log root tree.");
 		goto error;
 	}
@@ -5347,7 +5347,7 @@ again:
 		ret = btrfs_search_slot(NULL, log_root_tree, &key, path, 0, 0);
 
 		if (ret < 0) {
-			btrfs_std_error(fs_info, ret,
+			btrfs_handle_fs_error(fs_info, ret,
 				    "Couldn't find tree log root.");
 			goto error;
 		}
@@ -5365,7 +5365,7 @@ again:
 		log = btrfs_read_fs_root(log_root_tree, &found_key);
 		if (IS_ERR(log)) {
 			ret = PTR_ERR(log);
-			btrfs_std_error(fs_info, ret,
+			btrfs_handle_fs_error(fs_info, ret,
 				    "Couldn't read tree log root.");
 			goto error;
 		}
@@ -5380,7 +5380,7 @@ again:
 			free_extent_buffer(log->node);
 			free_extent_buffer(log->commit_root);
 			kfree(log);
-			btrfs_std_error(fs_info, ret, "Couldn't read target root "
+			btrfs_handle_fs_error(fs_info, ret, "Couldn't read target root "
 				    "for tree log recovery.");
 			goto error;
 		}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8ca3b0d3f1ef..b686036dd079 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1492,7 +1492,7 @@ again:
 		extent = btrfs_item_ptr(leaf, path->slots[0],
 					struct btrfs_dev_extent);
 	} else {
-		btrfs_std_error(root->fs_info, ret, "Slot search failed");
+		btrfs_handle_fs_error(root->fs_info, ret, "Slot search failed");
 		goto out;
 	}
 
@@ -1500,7 +1500,7 @@ again:
 
 	ret = btrfs_del_item(trans, root, path);
 	if (ret) {
-		btrfs_std_error(root->fs_info, ret,
+		btrfs_handle_fs_error(root->fs_info, ret,
 			    "Failed to remove dev extent item");
 	} else {
 		set_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags);
@@ -2412,7 +2412,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 		ret = btrfs_relocate_sys_chunks(root);
 		if (ret < 0)
-			btrfs_std_error(root->fs_info, ret,
+			btrfs_handle_fs_error(root->fs_info, ret,
 				    "Failed to relocate sys chunks after "
 				    "device initialization. This can be fixed "
 				    "using the \"btrfs balance\" command.");
@@ -2657,7 +2657,7 @@ static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto out;
 	else if (ret > 0) { /* Logic error or corruption */
-		btrfs_std_error(root->fs_info, -ENOENT,
+		btrfs_handle_fs_error(root->fs_info, -ENOENT,
 			    "Failed lookup while freeing chunk.");
 		ret = -ENOENT;
 		goto out;
@@ -2665,7 +2665,7 @@ static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_del_item(trans, root, path);
 	if (ret < 0)
-		btrfs_std_error(root->fs_info, ret,
+		btrfs_handle_fs_error(root->fs_info, ret,
 			    "Failed to delete chunk item.");
 out:
 	btrfs_free_path(path);
@@ -2851,7 +2851,7 @@ static int btrfs_relocate_chunk(struct btrfs_root *root, u64 chunk_offset)
 						     chunk_offset);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		btrfs_std_error(root->fs_info, ret, NULL);
+		btrfs_handle_fs_error(root->fs_info, ret, NULL);
 		return ret;
 	}
 
@@ -3626,7 +3626,7 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
 	unset_balance_control(fs_info);
 	ret = del_balance_item(fs_info->tree_root);
 	if (ret)
-		btrfs_std_error(fs_info, ret, NULL);
+		btrfs_handle_fs_error(fs_info, ret, NULL);
 
 	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 }
-- 
2.7.0

