From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: turn to readonly when btrfs_join_transaction() fails
Date: Mon, 13 Jun 2011 14:37:32 +0900
Message-ID: <201106130537.AA00024@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs_join_transaction()/btrfs_join_transaction_nolock() fails,
we should call btrfs_std_error() properly for filesystem to readonly.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
This patch is dependent on
 http://marc.info/?l=linux-btrfs&m=130761239706076&w=2
(it is necessary to define btrfs_abort_transaction function)

 fs/btrfs/delayed-inode.c |    4 +++-
 fs/btrfs/disk-io.c       |    8 ++++++--
 fs/btrfs/extent-tree.c   |   17 +++++++++++++----
 fs/btrfs/inode.c         |   14 +++++++++++---
 fs/btrfs/ioctl.c         |    7 ++++++-
 fs/btrfs/relocation.c    |   13 +++++++++----
 fs/btrfs/transaction.c   |    1 +
 7 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 6462c29..f829d6a 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1131,8 +1131,10 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	root = delayed_node->root;
 
 	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		goto free_path;
+	}
 
 	ret = btrfs_insert_delayed_items(trans, path, root, delayed_node);
 	if (!ret)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f68c68..00312c3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2478,14 +2478,18 @@ int btrfs_commit_super(struct btrfs_root *root)
 	up_write(&root->fs_info->cleanup_work_sem);
 
 	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
+	}
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 	/* run commit again to drop the original snapshot */
 	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return PTR_ERR(trans);
+	}
 	btrfs_commit_transaction(trans, root);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b42efc2..2f556b9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3068,8 +3068,10 @@ again:
 alloc:
 			alloc_target = btrfs_get_alloc_profile(root, 1);
 			trans = btrfs_join_transaction(root);
-			if (IS_ERR(trans))
+			if (IS_ERR(trans)) {
+				btrfs_abort_transaction(root, PTR_ERR(trans));
 				return PTR_ERR(trans);
+			}
 
 			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 					     bytes + 2 * 1024 * 1024,
@@ -3104,8 +3106,10 @@ commit_trans:
 		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
 			committed = 1;
 			trans = btrfs_join_transaction(root);
-			if (IS_ERR(trans))
+			if (IS_ERR(trans)) {
+				btrfs_abort_transaction(root, PTR_ERR(trans));
 				return PTR_ERR(trans);
+			}
 			ret = btrfs_commit_transaction(trans, root);
 			if (ret)
 				return ret;
@@ -3483,8 +3487,10 @@ again:
 
 	ret = -ENOSPC;
 	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		goto out;
+	}
 	ret = btrfs_commit_transaction(trans, root);
 	if (!ret) {
 		trans = NULL;
@@ -6568,7 +6574,10 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 	BUG_ON(cache->ro);
 
 	trans = btrfs_join_transaction(root);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
+		return PTR_ERR(trans);
+	}
 
 	alloc_flags = update_block_group_flags(root, cache->flags);
 	if (alloc_flags != cache->flags)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c15636b..bfe6970 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4274,8 +4274,10 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			trans = btrfs_join_transaction_nolock(root);
 		else
 			trans = btrfs_join_transaction(root);
-		if (IS_ERR(trans))
+		if (IS_ERR(trans)) {
+			btrfs_abort_transaction(root, PTR_ERR(trans));
 			return PTR_ERR(trans);
+		}
 		if (nolock)
 			ret = btrfs_end_transaction_nolock(trans, root);
 		else
@@ -5116,8 +5118,11 @@ again:
 				btrfs_release_path(path);
 				trans = btrfs_join_transaction(root);
 
-				if (IS_ERR(trans))
+				if (IS_ERR(trans)) {
+					btrfs_abort_transaction(root,
+								PTR_ERR(trans));
 					return ERR_CAST(trans);
+				}
 				goto again;
 			}
 			map = kmap(page);
@@ -5360,8 +5365,10 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 	}
 
 	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_abort_transaction(root, PTR_ERR(trans));
 		return ERR_CAST(trans);
+	}
 
 	if (start <= BTRFS_I(inode)->disk_i_size && len < 64 * 1024)
 		btrfs_add_inode_defrag(trans, inode);
@@ -5737,6 +5744,7 @@ again:
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		err = -ENOMEM;
+		btrfs_abort_transaction(root, err);
 		goto out;
 	}
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b793d11..1774b42 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -244,7 +244,12 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	}
 
 	trans = btrfs_join_transaction(root);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans)) {
+		mnt_drop_write(file->f_path.mnt);
+		ret = PTR_ERR(trans);
+		btrfs_abort_transaction(root, ret);
+		goto out_unlock;
+	}
 
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f25b10a..db03031 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2160,6 +2160,7 @@ again:
 		if (!err)
 			btrfs_block_rsv_release(rc->extent_root,
 						rc->block_rsv, num_bytes);
+		btrfs_abort_transaction(rc->extent_root, PTR_ERR(trans));
 		return PTR_ERR(trans);
 	}
 
@@ -3243,6 +3244,7 @@ truncate:
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
 		ret = PTR_ERR(trans);
+		btrfs_abort_transaction(root, ret);
 		goto out;
 	}
 
@@ -3840,9 +3842,10 @@ restart:
 
 	/* get rid of pinned extents */
 	trans = btrfs_join_transaction(rc->extent_root);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-	else
+		btrfs_abort_transaction(rc->extent_root, err);
+	} else
 		btrfs_commit_transaction(trans, rc->extent_root);
 out_free:
 	btrfs_free_block_rsv(rc->extent_root, rc->block_rsv);
@@ -4169,6 +4172,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	if (IS_ERR(trans)) {
 		unset_reloc_control(rc);
 		err = PTR_ERR(trans);
+		btrfs_abort_transaction(rc->extent_root, err);
 		goto out_free;
 	}
 
@@ -4200,9 +4204,10 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	unset_reloc_control(rc);
 
 	trans = btrfs_join_transaction(rc->extent_root);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-	else
+		btrfs_abort_transaction(rc->extent_root, err);
+	} else
 		btrfs_commit_transaction(trans, rc->extent_root);
 out_free:
 	kfree(rc);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2b3590b..a20dcbb 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1103,6 +1103,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	if (IS_ERR(ac->newtrans)) {
 		int err = PTR_ERR(ac->newtrans);
 		kfree(ac);
+		btrfs_abort_transaction(root, err);
 		return err;
 	}
 

