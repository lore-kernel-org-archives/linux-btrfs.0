Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4549 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763AbbDIEgZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 00:36:25 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t394ZGjQ019932
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Apr 2015 12:35:16 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 6/9] btrfs: Fix NO_SPACE bug caused by delayed-iput
Date: Thu, 9 Apr 2015 12:34:41 +0800
Message-ID: <581e0ffa1ce1dd6345519e7953bf4e895bda35ae.1428554023.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1428554022.git.zhaolei@cn.fujitsu.com>
References: <cover.1428554022.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Steps to reproduce:
  while true; do
    dd if=/dev/zero of=/btrfs_dir/file count=[fs_size * 75%]
    rm /btrfs_dir/file
    sync
  done

  And we'll see dd failed because btrfs return NO_SPACE.

Reason:
  Normally, btrfs_commit_transaction() call btrfs_run_delayed_iputs()
  in end to free fs space for next write, but sometimes it hadn't
  done work on time, because btrfs-cleaner thread get delayed-iputs
  from list before, but do iput() after next write.

  This is log:
  [ 2569.050776] comm=btrfs-cleaner func=btrfs_evict_inode() begin

  [ 2569.084280] comm=sync func=btrfs_commit_transaction() call btrfs_run_delayed_iputs()
  [ 2569.085418] comm=sync func=btrfs_commit_transaction() done btrfs_run_delayed_iputs()
  [ 2569.087554] comm=sync func=btrfs_commit_transaction() end

  [ 2569.191081] comm=dd begin
  [ 2569.790112] comm=dd func=__btrfs_buffered_write() ret=-28

  [ 2569.847479] comm=btrfs-cleaner func=add_pinned_bytes() 0 + 32677888 = 32677888
  [ 2569.849530] comm=btrfs-cleaner func=add_pinned_bytes() 32677888 + 23834624 = 56512512
  ...
  [ 2569.903893] comm=btrfs-cleaner func=add_pinned_bytes() 943976448 + 21762048 = 965738496
  [ 2569.908270] comm=btrfs-cleaner func=btrfs_evict_inode() end

Fix:
  Make btrfs_commit_transaction() wait current running btrfs-cleaner's
  delayed-iputs() done in end.

Test:
  Use script similar to above(more complex),
  before patch:
    7 failed in 100 * 20 loop.
  after patch:
    0 failed in 100 * 20 loop.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 1 +
 fs/btrfs/disk-io.c     | 3 ++-
 fs/btrfs/extent-tree.c | 6 ++++++
 fs/btrfs/inode.c       | 4 ++++
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f9c89ca..54d4d78 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1513,6 +1513,7 @@ struct btrfs_fs_info {
 
 	spinlock_t delayed_iput_lock;
 	struct list_head delayed_iputs;
+	struct rw_semaphore delayed_iput_sem;
 
 	/* this protects tree_mod_seq_list */
 	spinlock_t tree_mod_seq_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 639f266..6867471 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2241,11 +2241,12 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->qgroup_op_lock);
 	spin_lock_init(&fs_info->buffer_lock);
 	spin_lock_init(&fs_info->unused_bgs_lock);
-	mutex_init(&fs_info->unused_bg_unpin_mutex);
 	rwlock_init(&fs_info->tree_mod_log_lock);
+	mutex_init(&fs_info->unused_bg_unpin_mutex);
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
 	seqlock_init(&fs_info->profiles_lock);
+	init_rwsem(&fs_info->delayed_iput_sem);
 
 	init_completion(&fs_info->kobj_unregister);
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 203ac63..6fd7dca 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3732,6 +3732,12 @@ commit_trans:
 				ret = btrfs_commit_transaction(trans, root);
 				if (ret)
 					return ret;
+				/*
+				 * make sure that all running delayed iput are
+				 * done
+				 */
+				down_write(&root->fs_info->delayed_iput_sem);
+				up_write(&root->fs_info->delayed_iput_sem);
 				goto again;
 			} else {
 				btrfs_end_transaction(trans, root);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d2e732d..34d10be 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3110,6 +3110,8 @@ void btrfs_run_delayed_iputs(struct btrfs_root *root)
 	if (empty)
 		return;
 
+	down_read(&fs_info->delayed_iput_sem);
+
 	spin_lock(&fs_info->delayed_iput_lock);
 	list_splice_init(&fs_info->delayed_iputs, &list);
 	spin_unlock(&fs_info->delayed_iput_lock);
@@ -3120,6 +3122,8 @@ void btrfs_run_delayed_iputs(struct btrfs_root *root)
 		iput(delayed->inode);
 		kfree(delayed);
 	}
+
+	up_read(&root->fs_info->delayed_iput_sem);
 }
 
 /*
-- 
1.8.5.1

