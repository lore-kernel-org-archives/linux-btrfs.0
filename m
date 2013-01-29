Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3A2KCs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 05:02:48 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0TA2jwQ020203
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 18:02:45 +0800
Message-ID: <51079E6D.8010305@cn.fujitsu.com>
Date: Tue, 29 Jan 2013 18:03:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 03/10] Btrfs: use atomic for fs_info->last_trans_log_full_commit
References: <51079D72.7000301@cn.fujitsu.com>
In-Reply-To: <51079D72.7000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info->last_trans_log_full_commit is a 64bit variant, and it
can be accessed by multi-task, if there is no lock or other methods
to protect it, we might get the wrong number, especially on 32bit
machine.(Even on 64bit machine, it is possible that the compiler
may split a 64bit operation into two 32bit operation.)

For example, Assuming ->last_trans_log_full_commit
is 0x00000000ffffffff at the beginning, then we want set it
to 0x0000000100000000.
	Task0			Task1
	set low 32 bits
				load low 32 bits
				load high 32 bits
	set high 32 bits

The task will get 0, it is a wrong number.

We fix this problem by the atomic operation.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- modify the changelog and make it more clear and stringency.
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c |  3 ++-
 fs/btrfs/inode.c       |  3 ++-
 fs/btrfs/tree-log.c    | 32 +++++++++++++++++++-------------
 4 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 34a60a8..745e7ad 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1285,7 +1285,7 @@ struct btrfs_fs_info {
 	 * this is updated to the current trans every time a full commit
 	 * is required instead of the faster short fsync log commits
 	 */
-	u64 last_trans_log_full_commit;
+	atomic64_t last_trans_log_full_commit;
 	unsigned long mount_opt;
 	unsigned long compress_type:4;
 	u64 max_inline;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 85b8454..ef61a4a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7868,7 +7868,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 	extent_root = root->fs_info->extent_root;
 
-	root->fs_info->last_trans_log_full_commit = trans->transid;
+	atomic64_set(&root->fs_info->last_trans_log_full_commit,
+		     trans->transid);
 
 	cache = kzalloc(sizeof(*cache), GFP_NOFS);
 	if (!cache)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 35c4dda..803be87 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7433,7 +7433,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		/* force full log commit if subvolume involved. */
-		root->fs_info->last_trans_log_full_commit = trans->transid;
+		atomic64_set(&root->fs_info->last_trans_log_full_commit,
+			     trans->transid);
 	} else {
 		ret = btrfs_insert_inode_ref(trans, dest,
 					     new_dentry->d_name.name,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7f42a53..bb7c01b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2227,14 +2227,14 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 				&wait, TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
 
-		if (root->fs_info->last_trans_log_full_commit !=
+		if (atomic64_read(&root->fs_info->last_trans_log_full_commit) !=
 		    trans->transid && root->log_transid < transid + 2 &&
 		    atomic_read(&root->log_commit[index]))
 			schedule();
 
 		finish_wait(&root->log_commit_wait[index], &wait);
 		mutex_lock(&root->log_mutex);
-	} while (root->fs_info->last_trans_log_full_commit !=
+	} while (atomic64_read(&root->fs_info->last_trans_log_full_commit) !=
 		 trans->transid && root->log_transid < transid + 2 &&
 		 atomic_read(&root->log_commit[index]));
 	return 0;
@@ -2244,12 +2244,12 @@ static void wait_for_writer(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
-	while (root->fs_info->last_trans_log_full_commit !=
+	while (atomic64_read(&root->fs_info->last_trans_log_full_commit) !=
 	       trans->transid && atomic_read(&root->log_writers)) {
 		prepare_to_wait(&root->log_writer_wait,
 				&wait, TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
-		if (root->fs_info->last_trans_log_full_commit !=
+		if (atomic64_read(&root->fs_info->last_trans_log_full_commit) !=
 		    trans->transid && atomic_read(&root->log_writers))
 			schedule();
 		mutex_lock(&root->log_mutex);
@@ -2306,7 +2306,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 
 	/* bail out if we need to do a full commit */
-	if (root->fs_info->last_trans_log_full_commit == trans->transid) {
+	if (atomic64_read(&root->fs_info->last_trans_log_full_commit) ==
+	    trans->transid) {
 		ret = -EAGAIN;
 		mutex_unlock(&root->log_mutex);
 		goto out;
@@ -2361,7 +2362,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 			mutex_unlock(&log_root_tree->log_mutex);
 			goto out;
 		}
-		root->fs_info->last_trans_log_full_commit = trans->transid;
+		atomic64_set(&root->fs_info->last_trans_log_full_commit,
+			     trans->transid);
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = -EAGAIN;
@@ -2390,7 +2392,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * now that we've moved on to the tree of log tree roots,
 	 * check the full commit flag again
 	 */
-	if (root->fs_info->last_trans_log_full_commit == trans->transid) {
+	if (atomic64_read(&root->fs_info->last_trans_log_full_commit) ==
+	    trans->transid) {
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = -EAGAIN;
@@ -2614,7 +2617,8 @@ fail:
 out_unlock:
 	mutex_unlock(&BTRFS_I(dir)->log_mutex);
 	if (ret == -ENOSPC) {
-		root->fs_info->last_trans_log_full_commit = trans->transid;
+		atomic64_set(&root->fs_info->last_trans_log_full_commit,
+			     trans->transid);
 		ret = 0;
 	} else if (ret < 0)
 		btrfs_abort_transaction(trans, root, ret);
@@ -2647,7 +2651,8 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 				  dirid, &index);
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
 	if (ret == -ENOSPC) {
-		root->fs_info->last_trans_log_full_commit = trans->transid;
+		atomic64_set(&root->fs_info->last_trans_log_full_commit,
+			     trans->transid);
 		ret = 0;
 	} else if (ret < 0 && ret != -ENOENT)
 		btrfs_abort_transaction(trans, root, ret);
@@ -3708,8 +3713,8 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 			 * make sure any commits to the log are forced
 			 * to be full commits
 			 */
-			root->fs_info->last_trans_log_full_commit =
-				trans->transid;
+			atomic64_set(&root->fs_info->last_trans_log_full_commit,
+				trans->transid);
 			ret = 1;
 			break;
 		}
@@ -3755,7 +3760,7 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		goto end_no_trans;
 	}
 
-	if (root->fs_info->last_trans_log_full_commit >
+	if (atomic64_read(&root->fs_info->last_trans_log_full_commit) >
 	    atomic64_read(&root->fs_info->last_trans_committed)) {
 		ret = 1;
 		goto end_no_trans;
@@ -3825,7 +3830,8 @@ end_trans:
 	dput(old_parent);
 	if (ret < 0) {
 		WARN_ON(ret != -ENOSPC);
-		root->fs_info->last_trans_log_full_commit = trans->transid;
+		atomic64_set(&root->fs_info->last_trans_log_full_commit,
+			     trans->transid);
 		ret = 1;
 	}
 	btrfs_end_log_trans(root);
-- 
1.7.11.7

