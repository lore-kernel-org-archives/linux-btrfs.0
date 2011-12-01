From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: forced readonly when orphan_del fails
Date: Thu, 01 Dec 2011 19:21:22 +0900
Message-ID: <201112011021.AA00039@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In the case where the orphan_del fails, and cannot return
error to the caller, the filesystem turns to readonly instead
of BUG_ON().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8ad26b1..464e79e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1960,7 +1960,10 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 	    btrfs_root_refs(&root->root_item) > 0) {
 		ret = btrfs_del_orphan_item(trans, root->fs_info->tree_root,
 					    root->root_key.objectid);
-		BUG_ON(ret);
+		if (ret) {
+			btrfs_std_error(root->fs_info, ret);
+			return;
+		}
 		root->orphan_item_inserted = 0;
 	}
 
@@ -3532,7 +3535,8 @@ void btrfs_evict_inode(struct inode *inode)
 	if (ret == 0) {
 		trans->block_rsv = root->orphan_block_rsv;
 		ret = btrfs_orphan_del(trans, inode);
-		BUG_ON(ret);
+		if (ret)
+			btrfs_std_error(root->fs_info, ret);
 	}
 
 	trans->block_rsv = &root->fs_info->trans_block_rsv;

