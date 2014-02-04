Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19027 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbaBDRhz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 12:37:55 -0500
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s14HOdW8023300
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Feb 2014 09:37:55 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1hu04ds02q-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 09:37:54 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: introduce commit_root_sem to protect commit roots
Date: Tue, 4 Feb 2014 12:37:51 -0500
Message-ID: <1391535471-12289-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs send uses the commit roots to avoid locking and such when sending
snapshots.  The problem with this it doesn't lock anything to make sure the
commit roots don't get swapped out from underneath it.  This can cause issues if
you are trying to send a snapshot and then snapshot that snapshot which will
cause us to cow the root and screw everything up.  So add commit_root_sem and
hold it when we're swapping everything out during the commit.  This will make
sure we don't have to hold a transaction open while doing a send and we can
still use our commit roots.  This fixes Wang's reproducer that he turned into an
xfstest.  Thanks,

Reported-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/backref.c     | 14 ++++++++++----
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/disk-io.c     |  1 +
 fs/btrfs/send.c        |  8 ++++++--
 fs/btrfs/transaction.c |  5 +++++
 5 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index aded3ef..e70f181 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1588,18 +1588,24 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 	struct btrfs_key found_key;
 	int search_commit_root = path->search_commit_root;
 
+	if (search_commit_root)
+		down_read(&fs_info->commit_root_sem);
 	ret = extent_from_logical(fs_info, logical, path, &found_key, &flags);
 	btrfs_release_path(path);
 	if (ret < 0)
-		return ret;
-	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
-		return -EINVAL;
+		goto out;
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, search_commit_root,
 					iterate, ctx);
-
+out:
+	if (search_commit_root)
+		up_read(&fs_info->commit_root_sem);
 	return ret;
 }
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 84d4c05..5d927e6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1440,7 +1440,7 @@ struct btrfs_fs_info {
 	struct mutex ordered_extent_flush_mutex;
 
 	struct rw_semaphore extent_commit_sem;
-
+	struct rw_semaphore commit_root_sem;
 	struct rw_semaphore cleanup_work_sem;
 
 	struct rw_semaphore subvol_sem;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7619147..ceb2c2d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2279,6 +2279,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->volume_mutex);
 	init_rwsem(&fs_info->extent_commit_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
+	init_rwsem(&fs_info->commit_root_sem);
 	init_rwsem(&fs_info->subvol_sem);
 	sema_init(&fs_info->uuid_tree_rescan_sem, 1);
 	fs_info->dev_replace.lock_owner = 0;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 04c07ed..1995e6b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1249,13 +1249,17 @@ static int find_extent_clone(struct send_ctx *sctx,
 	}
 	logical = disk_byte + btrfs_file_extent_offset(eb, fi);
 
+	down_read(&sctx->send_root->fs_info->commit_root_sem);
 	ret = extent_from_logical(sctx->send_root->fs_info, disk_byte, tmp_path,
 				  &found_key, &flags);
 	btrfs_release_path(tmp_path);
 
-	if (ret < 0)
+	if (ret < 0) {
+		up_read(&sctx->send_root->fs_info->commit_root_sem);
 		goto out;
+	}
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+		up_read(&sctx->send_root->fs_info->commit_root_sem);
 		ret = -EIO;
 		goto out;
 	}
@@ -1297,7 +1301,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 	ret = iterate_extent_inodes(sctx->send_root->fs_info,
 					found_key.objectid, extent_item_pos, 1,
 					__iterate_backrefs, backref_ctx);
-
+	up_read(&sctx->send_root->fs_info->commit_root_sem);
 	if (ret < 0)
 		goto out;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 34cd831..d888f26 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1819,8 +1819,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	mutex_lock(&root->fs_info->tree_log_mutex);
 
+	down_write(&root->fs_info->commit_root_sem);
 	ret = commit_fs_roots(trans, root);
 	if (ret) {
+		up_write(&root->fs_info->commit_root_sem);
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
@@ -1842,6 +1844,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	ret = commit_cowonly_roots(trans, root);
 	if (ret) {
+		up_write(&root->fs_info->commit_root_sem);
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
@@ -1853,6 +1856,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
 		ret = cur_trans->aborted;
+		up_write(&root->fs_info->commit_root_sem);
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
@@ -1870,6 +1874,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			    root->fs_info->chunk_root->node);
 	switch_commit_root(root->fs_info->chunk_root);
 
+	up_write(&root->fs_info->commit_root_sem);
 	assert_qgroups_uptodate(trans);
 	update_super_roots(root);
 
-- 
1.8.3.1

