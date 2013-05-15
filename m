Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab3EOHsk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:40 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 06/17] Btrfs: introduce grab/put functions for the root of the fs/file tree
Date: Wed, 15 May 2013 15:48:20 +0800
Message-Id: <1368604111-25073-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The grab/put funtions will be used in the next patch, which need grab
the root object and ensure it is not freed. We use reference counter
instead of the srcu lock is to aovid blocking the memory reclaim task,
which invokes synchronize_srcu().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/disk-io.c     |  5 +++--
 fs/btrfs/disk-io.h     | 21 +++++++++++++++++++++
 fs/btrfs/extent-tree.c |  2 +-
 4 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 845b77f..958ce6c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1739,6 +1739,7 @@ struct btrfs_root {
 	int force_cow;
 
 	spinlock_t root_item_lock;
+	atomic_t refs;
 };
 
 struct btrfs_ioctl_defrag_range_args {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 42d6ba2..642c861 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1216,6 +1216,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	atomic_set(&root->log_writers, 0);
 	atomic_set(&root->log_batch, 0);
 	atomic_set(&root->orphan_inodes, 0);
+	atomic_set(&root->refs, 1);
 	root->log_transid = 0;
 	root->last_log_commit = 0;
 	extent_io_tree_init(&root->dirty_log_pages,
@@ -2049,7 +2050,7 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
 		} else {
 			free_extent_buffer(gang[0]->node);
 			free_extent_buffer(gang[0]->commit_root);
-			kfree(gang[0]);
+			btrfs_put_fs_root(gang[0]);
 		}
 	}
 
@@ -3415,7 +3416,7 @@ static void free_fs_root(struct btrfs_root *root)
 	kfree(root->free_ino_ctl);
 	kfree(root->free_ino_pinned);
 	kfree(root->name);
-	kfree(root);
+	btrfs_put_fs_root(root);
 }
 
 void btrfs_free_fs_root(struct btrfs_root *root)
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 534d583..b71acd6e 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -76,6 +76,27 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root);
 void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 				 struct btrfs_root *root);
 void btrfs_free_fs_root(struct btrfs_root *root);
+
+/*
+ * This function is used to grab the root, and avoid it is freed when we
+ * access it. But it doesn't ensure that the tree is not dropped.
+ *
+ * If you want to ensure the whole tree is safe, you should use
+ * 	fs_info->subvol_srcu
+ */
+static inline struct btrfs_root *btrfs_grab_fs_root(struct btrfs_root *root)
+{
+	if (atomic_inc_not_zero(&root->refs))
+		return root;
+	return NULL;
+}
+
+static inline void btrfs_put_fs_root(struct btrfs_root *root)
+{
+	if (atomic_dec_and_test(&root->refs))
+		kfree(root);
+}
+
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 08e42c8..08f9862 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7463,7 +7463,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	} else {
 		free_extent_buffer(root->node);
 		free_extent_buffer(root->commit_root);
-		kfree(root);
+		btrfs_put_fs_root(root);
 	}
 out_end_trans:
 	btrfs_end_transaction_throttle(trans, tree_root);
-- 
1.8.1.4

