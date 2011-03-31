From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] btrfs: clear __GFP_FS flag in the space cache inode
Date: Thu, 31 Mar 2011 17:43:23 +0800
Message-ID: <4D944CBB.4020906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

the object id of the space cache inode's key is allocated from the relative
root, just like the regular file. So we can't identify space cache inode by
checking the object id of the inode's key, and we have to clear __GFP_FS flag
at the time we look up the space cache inode.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    2 ++
 fs/btrfs/inode.c            |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0037427..13575de 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -81,6 +81,8 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 		return ERR_PTR(-ENOENT);
 	}
 
+	inode->i_mapping->flags &= ~__GFP_FS;
+
 	spin_lock(&block_group->lock);
 	if (!root->fs_info->closing) {
 		block_group->inode = igrab(inode);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 93c28a1..c103fdc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2537,8 +2537,6 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
 
 	alloc_group_block = btrfs_inode_block_group(leaf, inode_item);
-	if (location.objectid == BTRFS_FREE_SPACE_OBJECTID)
-		inode->i_mapping->flags &= ~__GFP_FS;
 
 	/*
 	 * try to precache a NULL acl entry for files that don't have
-- 
1.7.4

