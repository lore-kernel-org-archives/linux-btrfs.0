From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 2/3] Btrfs: check return value of btrfs_cow_block()
Date: Tue, 27 Mar 2012 16:11:59 +0200
Message-ID: <103e976616fe9c2a3e40764c979fa1a592274da2.1332852833.git.list.btrfs@jan-o-sch.net>
References: <cover.1332852833.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1332852833.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1332852833.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

The two helper functions commit_cowonly_roots() and
create_pending_snapshot() failed to check the return value from
btrfs_cow_block(), which could at least in theory fail with -ENOSPC from
btrfs_alloc_free_block(). This commit adds the missing checks.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/transaction.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04b77e3..cd220f2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -718,7 +718,8 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 
 	eb = btrfs_lock_root_node(fs_info->tree_root);
-	btrfs_cow_block(trans, fs_info->tree_root, eb, NULL, 0, &eb);
+	ret = btrfs_cow_block(trans, fs_info->tree_root, eb, NULL, 0, &eb);
+	BUG_ON(ret);
 	btrfs_tree_unlock(eb);
 	free_extent_buffer(eb);
 
@@ -949,7 +950,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_set_root_flags(new_root_item, root_flags);
 
 	old = btrfs_lock_root_node(root);
-	btrfs_cow_block(trans, root, old, NULL, 0, &old);
+	ret = btrfs_cow_block(trans, root, old, NULL, 0, &old);
+	BUG_ON(ret);
 	btrfs_set_lock_blocking(old);
 
 	btrfs_copy_root(trans, root, old, &tmp, objectid);
-- 
1.7.3.4

