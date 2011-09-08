From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: reset to appropriate block rsv after orphan operations
Date: Thu, 8 Sep 2011 17:13:07 +0800
Message-ID: <1315473187-30699-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While truncating free space cache, we forget to change trans->block_rsv
back to the original one, but leave it with the orphan_block_rsv, and
then with option inode_cache enable, it leads to countless warnings of
btrfs_alloc_free_block and btrfs_orphan_commit_root:

WARNING: at fs/btrfs/extent-tree.c:5711 btrfs_alloc_free_block+0x180/0x350 [btrfs]()
...
WARNING: at fs/btrfs/inode.c:2193 btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6a265b9..41ac927 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -190,9 +190,11 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 				    struct btrfs_path *path,
 				    struct inode *inode)
 {
+	struct btrfs_block_rsv *rsv;
 	loff_t oldsize;
 	int ret = 0;
 
+	rsv = trans->block_rsv;
 	trans->block_rsv = root->orphan_block_rsv;
 	ret = btrfs_block_rsv_check(trans, root,
 				    root->orphan_block_rsv,
@@ -210,6 +212,8 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	 */
 	ret = btrfs_truncate_inode_items(trans, root, inode,
 					 0, BTRFS_EXTENT_DATA_KEY);
+
+	trans->block_rsv = rsv;
 	if (ret) {
 		WARN_ON(1);
 		return ret;
-- 
1.6.5.2

