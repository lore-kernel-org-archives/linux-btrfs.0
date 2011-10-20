From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use the global reserve when truncating the free space cache inode
Date: Thu, 20 Oct 2011 09:31:17 -0400
Message-ID: <1319117477-5073-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We no longer use the orphan block rsv for holding the reservation for truncating
the inode, so instead use the global block rsv and check to make sure it has
enough space for us to truncate the space.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index de205d5..95ada1c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -198,14 +198,24 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 				    struct inode *inode)
 {
 	struct btrfs_block_rsv *rsv;
+	u64 needed_bytes;
 	loff_t oldsize;
 	int ret = 0;
 
 	rsv = trans->block_rsv;
-	trans->block_rsv = root->orphan_block_rsv;
-	ret = btrfs_block_rsv_check(root, root->orphan_block_rsv, 5);
-	if (ret)
-		return ret;
+	trans->block_rsv = &root->fs_info->global_block_rsv;
+
+	/* 1 for slack space, 1 for updating the inode */
+	needed_bytes = btrfs_calc_trunc_metadata_size(root, 1) +
+		btrfs_calc_trans_metadata_size(root, 1);
+
+	spin_lock(&trans->block_rsv->lock);
+	if (trans->block_rsv->reserved < needed_bytes) {
+		spin_unlock(&trans->block_rsv->lock);
+		trans->block_rsv = rsv;
+		return -ENOSPC;
+	}
+	spin_unlock(&trans->block_rsv->lock);
 
 	oldsize = i_size_read(inode);
 	btrfs_i_size_write(inode, 0);
@@ -218,13 +228,15 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	ret = btrfs_truncate_inode_items(trans, root, inode,
 					 0, BTRFS_EXTENT_DATA_KEY);
 
-	trans->block_rsv = rsv;
 	if (ret) {
+		trans->block_rsv = rsv;
 		WARN_ON(1);
 		return ret;
 	}
 
 	ret = btrfs_update_inode(trans, root, inode);
+	trans->block_rsv = rsv;
+
 	return ret;
 }
 
-- 
1.7.5.2

