Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31111 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbbIYGou (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 02:44:50 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t8P6inig014789
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 06:44:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t8P6imQM000999
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 06:44:49 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t8P6imRE009599
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 06:44:48 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] Btrfs: consolidate btrfs_error() to btrfs_std_error()
Date: Fri, 25 Sep 2015 14:43:01 +0800
Message-Id: <1443163381-12332-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_error() and btrfs_std_error() does the same thing
and calls _btrfs_std_error(), so consolidate them together.
And the main motivation is that btrfs_error() is closely
named with btrfs_err(), one handles error action the other
is to log the error, so don't closely name them.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Suggested-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c       |  6 +++---
 fs/btrfs/ctree.h       |  9 +--------
 fs/btrfs/disk-io.c     |  8 ++++----
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/inode-item.c  |  2 +-
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/relocation.c  |  2 +-
 fs/btrfs/root-tree.c   |  4 ++--
 fs/btrfs/transaction.c |  2 +-
 fs/btrfs/tree-log.c    |  8 ++++----
 fs/btrfs/volumes.c     | 14 +++++++-------
 11 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5f745ea..1063315 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1011,7 +1011,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			return ret;
 		if (refs == 0) {
 			ret = -EROFS;
-			btrfs_std_error(root->fs_info, ret);
+			btrfs_std_error(root->fs_info, ret, NULL);
 			return ret;
 		}
 	} else {
@@ -1927,7 +1927,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		child = read_node_slot(root, mid, 0);
 		if (!child) {
 			ret = -EROFS;
-			btrfs_std_error(root->fs_info, ret);
+			btrfs_std_error(root->fs_info, ret, NULL);
 			goto enospc;
 		}
 
@@ -2030,7 +2030,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		 */
 		if (!left) {
 			ret = -EROFS;
-			btrfs_std_error(root->fs_info, ret);
+			btrfs_std_error(root->fs_info, ret, NULL);
 			goto enospc;
 		}
 		wret = balance_node_right(trans, root, mid, left);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4484063..a86051e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4127,14 +4127,7 @@ do {								\
 				  __LINE__, (errno));		\
 } while (0)
 
-#define btrfs_std_error(fs_info, errno)				\
-do {								\
-	if ((errno))						\
-		__btrfs_std_error((fs_info), __func__,		\
-				   __LINE__, (errno), NULL);	\
-} while (0)
-
-#define btrfs_error(fs_info, errno, fmt, args...)		\
+#define btrfs_std_error(fs_info, errno, fmt, args...)		\
 do {								\
 	__btrfs_std_error((fs_info), __func__, __LINE__,	\
 			  (errno), fmt, ##args);		\
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e0dbe41..18796c9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2377,7 +2377,7 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	/* returns with log_tree_root freed on success */
 	ret = btrfs_recover_log_trees(log_tree_root);
 	if (ret) {
-		btrfs_error(tree_root->fs_info, ret,
+		btrfs_std_error(tree_root->fs_info, ret,
 			    "Failed to recover log tree");
 		free_extent_buffer(log_tree_root->node);
 		kfree(log_tree_root);
@@ -3570,7 +3570,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		if (ret) {
 			mutex_unlock(
 				&root->fs_info->fs_devices->device_list_mutex);
-			btrfs_error(root->fs_info, ret,
+			btrfs_std_error(root->fs_info, ret,
 				    "errors while submitting device barriers.");
 			return ret;
 		}
@@ -3610,7 +3610,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 		/* FUA is masked off if unsupported and can't be the reason */
-		btrfs_error(root->fs_info, -EIO,
+		btrfs_std_error(root->fs_info, -EIO,
 			    "%d errors while writing supers", total_errors);
 		return -EIO;
 	}
@@ -3628,7 +3628,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	}
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 	if (total_errors > max_errors) {
-		btrfs_error(root->fs_info, -EIO,
+		btrfs_std_error(root->fs_info, -EIO,
 			    "%d errors while writing supers", total_errors);
 		return -EIO;
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5411f0a..2d13e08 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8691,7 +8691,7 @@ out:
 	if (!for_reloc && root_dropped == false)
 		btrfs_add_dead_root(root);
 	if (err && err != -EAGAIN)
-		btrfs_std_error(root->fs_info, err);
+		btrfs_std_error(root->fs_info, err, NULL);
 	return err;
 }
 
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index 265e03c..be4d22a 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -157,7 +157,7 @@ static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 	 */
 	if (!btrfs_find_name_in_ext_backref(path, ref_objectid,
 					    name, name_len, &extref)) {
-		btrfs_std_error(root->fs_info, -ENOENT);
+		btrfs_std_error(root->fs_info, -ENOENT, NULL);
 		ret = -EROFS;
 		goto out;
 	}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6c9e58c..f7108c8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4852,7 +4852,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	/* update qgroup status and info */
 	err = btrfs_run_qgroups(trans, root->fs_info);
 	if (err < 0)
-		btrfs_error(root->fs_info, ret,
+		btrfs_std_error(root->fs_info, ret,
 			    "failed to update qgroup status and info\n");
 	err = btrfs_end_transaction(trans, root);
 	if (err && !ret)
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 303babe..58ede0a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2418,7 +2418,7 @@ again:
 	}
 out:
 	if (ret) {
-		btrfs_std_error(root->fs_info, ret);
+		btrfs_std_error(root->fs_info, ret, NULL);
 		if (!list_empty(&reloc_roots))
 			free_reloc_roots(&reloc_roots);
 
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 360a728..6d90851 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -283,7 +283,7 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 			trans = btrfs_join_transaction(tree_root);
 			if (IS_ERR(trans)) {
 				err = PTR_ERR(trans);
-				btrfs_error(tree_root->fs_info, err,
+				btrfs_std_error(tree_root->fs_info, err,
 					    "Failed to start trans to delete "
 					    "orphan item");
 				break;
@@ -292,7 +292,7 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 						    root_key.objectid);
 			btrfs_end_transaction(trans, tree_root);
 			if (err) {
-				btrfs_error(tree_root->fs_info, err,
+				btrfs_std_error(tree_root->fs_info, err,
 					    "Failed to delete root orphan "
 					    "item");
 				break;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8f259b3..86a8759 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2103,7 +2103,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_write_and_wait_transaction(trans, root);
 	if (ret) {
-		btrfs_error(root->fs_info, ret,
+		btrfs_std_error(root->fs_info, ret,
 			    "Error while writing out transaction");
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		goto scrub_continue;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1bbaace..c3f9a9c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5314,7 +5314,7 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 
 	ret = walk_log_tree(trans, log_root_tree, &wc);
 	if (ret) {
-		btrfs_error(fs_info, ret, "Failed to pin buffers while "
+		btrfs_std_error(fs_info, ret, "Failed to pin buffers while "
 			    "recovering log root tree.");
 		goto error;
 	}
@@ -5328,7 +5328,7 @@ again:
 		ret = btrfs_search_slot(NULL, log_root_tree, &key, path, 0, 0);
 
 		if (ret < 0) {
-			btrfs_error(fs_info, ret,
+			btrfs_std_error(fs_info, ret,
 				    "Couldn't find tree log root.");
 			goto error;
 		}
@@ -5346,7 +5346,7 @@ again:
 		log = btrfs_read_fs_root(log_root_tree, &found_key);
 		if (IS_ERR(log)) {
 			ret = PTR_ERR(log);
-			btrfs_error(fs_info, ret,
+			btrfs_std_error(fs_info, ret,
 				    "Couldn't read tree log root.");
 			goto error;
 		}
@@ -5361,7 +5361,7 @@ again:
 			free_extent_buffer(log->node);
 			free_extent_buffer(log->commit_root);
 			kfree(log);
-			btrfs_error(fs_info, ret, "Couldn't read target root "
+			btrfs_std_error(fs_info, ret, "Couldn't read target root "
 				    "for tree log recovery.");
 			goto error;
 		}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9e7a73d..8752a4b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1411,7 +1411,7 @@ again:
 		extent = btrfs_item_ptr(leaf, path->slots[0],
 					struct btrfs_dev_extent);
 	} else {
-		btrfs_error(root->fs_info, ret, "Slot search failed");
+		btrfs_std_error(root->fs_info, ret, "Slot search failed");
 		goto out;
 	}
 
@@ -1419,7 +1419,7 @@ again:
 
 	ret = btrfs_del_item(trans, root, path);
 	if (ret) {
-		btrfs_error(root->fs_info, ret,
+		btrfs_std_error(root->fs_info, ret,
 			    "Failed to remove dev extent item");
 	} else {
 		trans->transaction->have_free_bgs = 1;
@@ -2331,7 +2331,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 		ret = btrfs_relocate_sys_chunks(root);
 		if (ret < 0)
-			btrfs_error(root->fs_info, ret,
+			btrfs_std_error(root->fs_info, ret,
 				    "Failed to relocate sys chunks after "
 				    "device initialization. This can be fixed "
 				    "using the \"btrfs balance\" command.");
@@ -2576,7 +2576,7 @@ static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto out;
 	else if (ret > 0) { /* Logic error or corruption */
-		btrfs_error(root->fs_info, -ENOENT,
+		btrfs_std_error(root->fs_info, -ENOENT,
 			    "Failed lookup while freeing chunk.");
 		ret = -ENOENT;
 		goto out;
@@ -2584,7 +2584,7 @@ static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_del_item(trans, root, path);
 	if (ret < 0)
-		btrfs_error(root->fs_info, ret,
+		btrfs_std_error(root->fs_info, ret,
 			    "Failed to delete chunk item.");
 out:
 	btrfs_free_path(path);
@@ -2769,7 +2769,7 @@ static int btrfs_relocate_chunk(struct btrfs_root *root, u64 chunk_offset)
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		btrfs_std_error(root->fs_info, ret);
+		btrfs_std_error(root->fs_info, ret, NULL);
 		return ret;
 	}
 
@@ -3424,7 +3424,7 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
 	unset_balance_control(fs_info);
 	ret = del_balance_item(fs_info->tree_root);
 	if (ret)
-		btrfs_std_error(fs_info, ret);
+		btrfs_std_error(fs_info, ret, NULL);
 
 	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 }
-- 
2.4.1

