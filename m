Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45493 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaGPViP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 17:38:15 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v2 2/2] btrfs: use the new VFS super_block_dev
Date: Wed, 16 Jul 2014 14:37:58 -0700
Message-Id: <1405546678-7846-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1405546678-7846-1-git-send-email-mcgrof@do-not-panic.com>
References: <1405546678-7846-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Use the new VFS layer struct super_block_dev instead of carrying
the anonymous bdev's on our own. This makes the VFS layer aware of
all of our anonymous dev's on the super block.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 fs/btrfs/ctree.h   | 7 ++-----
 fs/btrfs/disk-io.c | 6 ++----
 fs/btrfs/inode.c   | 2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index be91397..0ece396 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1846,11 +1846,8 @@ struct btrfs_root {
 	 * protected by inode_lock
 	 */
 	struct radix_tree_root delayed_nodes_tree;
-	/*
-	 * right now this just gets used so that a root has its own devid
-	 * for stat.  It may be used for more later
-	 */
-	dev_t anon_dev;
+
+	struct super_block_dev sbdev;
 
 	spinlock_t root_item_lock;
 	atomic_t refs;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8bb4aa1..1a6aa8d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1269,7 +1269,6 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 		root->defrag_trans_start = 0;
 	init_completion(&root->kobj_unregister);
 	root->root_key.objectid = objectid;
-	root->anon_dev = 0;
 
 	spin_lock_init(&root->root_item_lock);
 }
@@ -1572,7 +1571,7 @@ int btrfs_init_fs_root(struct btrfs_root *root)
 	spin_lock_init(&root->cache_lock);
 	init_waitqueue_head(&root->cache_wait);
 
-	ret = get_anon_bdev(&root->anon_dev);
+	ret = insert_anon_sbdev(root->fs_info->sb, &root->sbdev);
 	if (ret)
 		goto free_writers;
 	return 0;
@@ -3529,8 +3528,7 @@ static void free_fs_root(struct btrfs_root *root)
 	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
 	btrfs_free_block_rsv(root, root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
-	if (root->anon_dev)
-		free_anon_bdev(root->anon_dev);
+	remove_anon_sbdev(&root->sbdev);
 	if (root->subv_writers)
 		btrfs_free_subvolume_writers(root->subv_writers);
 	free_extent_buffer(root->node);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..0e8f604 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8277,7 +8277,7 @@ static int btrfs_getattr(struct vfsmount *mnt,
 	u32 blocksize = inode->i_sb->s_blocksize;
 
 	generic_fillattr(inode, stat);
-	stat->dev = BTRFS_I(inode)->root->anon_dev;
+	stat->dev = BTRFS_I(inode)->root->sbdev.anon_dev;
 	stat->blksize = PAGE_CACHE_SIZE;
 
 	spin_lock(&BTRFS_I(inode)->lock);
-- 
2.0.1

