From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix misuse of trans block rsv
Date: Thu, 8 Sep 2011 17:12:43 +0800
Message-ID: <1315473163-30660-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

At the beginning of create_pending_snapshot, trans->block_rsv is set
to pending->block_rsv and is used for snapshot things, however, when
it is done, we do not recover it as will.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7dc36fa..e24b796 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -884,6 +884,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *root = pending->root;
 	struct btrfs_root *parent_root;
+	struct btrfs_block_rsv *rsv;
 	struct inode *parent_inode;
 	struct dentry *parent;
 	struct dentry *dentry;
@@ -895,6 +896,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 objectid;
 	u64 root_flags;
 
+	rsv = trans->block_rsv;
+
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
 		pending->error = -ENOMEM;
@@ -1002,6 +1005,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_orphan_post_snapshot(trans, pending);
 fail:
 	kfree(new_root_item);
+	trans->block_rsv = rsv;
 	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
 	return 0;
 }
-- 
1.6.5.2

