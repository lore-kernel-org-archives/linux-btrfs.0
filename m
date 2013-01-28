Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39519 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3A1LGw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 06:06:52 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] Btrfs: fix race between snapshot deletion and getting inode
Date: Mon, 28 Jan 2013 19:04:02 +0800
Message-Id: <1359371042-5553-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While running snapshot testscript created by Mitch and David,
the race between autodefrag and snapshot deletion can lead to
corruption of dead_root list so that we can get crash on
btrfs_clean_old_snapshots().

And besides autodefrag, scrub also do the same thing, ie. read
root first and get inode.

Here is the story(take autodefrag as an example):
(1) when we delete a snapshot or subvolume, it will set its root's
refs to zero and do a iput() on its own inode, and if this inode happens
to be the only active in-meory one in root's inode rbtree, it will add
itself to the global dead_roots list for later cleanup.

(2) after (1), the autodefrag thread may read another inode for defrag
and the inode is just in the deleted snapshot/subvolume, but all of these
are without checking if the root is still valid(refs > 0).  So the end up
result is adding the deleted snapshot/subvolume's root to the global
dead_roots list AGAIN.

Fortunately, we already have a srcu lock to avoid the race, ie. subvol_srcu.

So all we need to do is to take the lock to protect 'read root and get inode',
since we synchronize to wait for the rcu grace period before adding something
to the global dead_roots list.

Reported-by: Mitch Harder <mitch.harder@sabayonlinux.org>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c  |   12 ++++++++++++
 fs/btrfs/scrub.c |   25 ++++++++++++++++++++-----
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f76b1fd..1cca5c9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -293,21 +293,33 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	struct btrfs_ioctl_defrag_range_args range;
 	int num_defrag;
+	int index;
 
 	/* get the inode */
 	key.objectid = defrag->root;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 	key.offset = (u64)-1;
+
+	index = srcu_read_lock(&fs_info->subvol_srcu);
+
 	inode_root = btrfs_read_fs_root_no_name(fs_info, &key);
 	if (IS_ERR(inode_root)) {
+		srcu_read_unlock(&fs_info->subvol_srcu, index);
 		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
 		return PTR_ERR(inode_root);
 	}
+	if (btrfs_root_refs(&inode_root->root_item) == 0) {
+		srcu_read_unlock(&fs_info->subvol_srcu, index);
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+		return -ENOENT;
+	}
 
 	key.objectid = defrag->ino;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
 	inode = btrfs_iget(fs_info->sb, &key, inode_root, NULL);
+
+	srcu_read_unlock(&fs_info->subvol_srcu, index);
 	if (IS_ERR(inode)) {
 		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
 		return PTR_ERR(inode);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index bdbb94f..e487d54 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -580,20 +580,29 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 	int corrected = 0;
 	struct btrfs_key key;
 	struct inode *inode = NULL;
+	struct btrfs_fs_info *fs_info;
 	u64 end = offset + PAGE_SIZE - 1;
 	struct btrfs_root *local_root;
+	int i_srcu;
 
 	key.objectid = root;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
-	local_root = btrfs_read_fs_root_no_name(fixup->root->fs_info, &key);
-	if (IS_ERR(local_root))
+
+	fs_info = fixup->root->fs_info;
+	i_srcu = srcu_read_lock(&fs_info->subvol_srcu);
+
+	local_root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(local_root)) {
+		srcu_read_unlock(&fs_info->subvol_srcu, i_srcu);
 		return PTR_ERR(local_root);
+	}
 
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.objectid = inum;
 	key.offset = 0;
-	inode = btrfs_iget(fixup->root->fs_info->sb, &key, local_root, NULL);
+	inode = btrfs_iget(fs_info->sb, &key, local_root, NULL);
+	srcu_read_unlock(&fs_info->subvol_srcu, i_srcu);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
@@ -606,7 +615,6 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 	}
 
 	if (PageUptodate(page)) {
-		struct btrfs_fs_info *fs_info;
 		if (PageDirty(page)) {
 			/*
 			 * we need to write the data to the defect sector. the
@@ -3180,18 +3188,25 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 	u64 physical_for_dev_replace;
 	u64 len;
 	struct btrfs_fs_info *fs_info = nocow_ctx->sctx->dev_root->fs_info;
+	int i_srcu;
 
 	key.objectid = root;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
+
+	i_srcu = srcu_read_lock(&fs_info->subvol_srcu);
+
 	local_root = btrfs_read_fs_root_no_name(fs_info, &key);
-	if (IS_ERR(local_root))
+	if (IS_ERR(local_root)) {
+		srcu_read_unlock(&fs_info->subvol_srcu, i_srcu);
 		return PTR_ERR(local_root);
+	}
 
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.objectid = inum;
 	key.offset = 0;
 	inode = btrfs_iget(fs_info->sb, &key, local_root, NULL);
+	srcu_read_unlock(&fs_info->subvol_srcu, i_srcu);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
-- 
1.7.7.6

