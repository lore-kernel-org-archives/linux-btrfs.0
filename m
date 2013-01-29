Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29397 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3A2DZi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 22:25:38 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: mitch.harder@sabayonlinux.org, dsterba@suse.cz
Subject: [PATCH v2] Btrfs: fix race between snapshot deletion and getting inode
Date: Tue, 29 Jan 2013 11:22:10 +0800
Message-Id: <1359429730-16729-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While running snapshot testscript created by Mitch and David,
the race between autodefrag and snapshot deletion can lead to
corruption of dead_root list so that we can get crash on
btrfs_clean_old_snapshots().

And besides autodefrag, scrub also does the same thing, ie. read
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
v1->v2: Address nice cleanup comments from David Sterba.

 fs/btrfs/file.c  |   22 ++++++++++++++++++----
 fs/btrfs/scrub.c |   25 ++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 841cfe3..38ffd28 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -293,15 +293,24 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	struct btrfs_ioctl_defrag_range_args range;
 	int num_defrag;
+	int index;
+	int ret;
 
 	/* get the inode */
 	key.objectid = defrag->root;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 	key.offset = (u64)-1;
+
+	index = srcu_read_lock(&fs_info->subvol_srcu);
+
 	inode_root = btrfs_read_fs_root_no_name(fs_info, &key);
 	if (IS_ERR(inode_root)) {
-		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-		return PTR_ERR(inode_root);
+		ret = PTR_ERR(inode_root);
+		goto cleanup;
+	}
+	if (btrfs_root_refs(&inode_root->root_item) == 0) {
+		ret = -ENOENT;
+		goto cleanup;
 	}
 
 	key.objectid = defrag->ino;
@@ -309,9 +318,10 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 	key.offset = 0;
 	inode = btrfs_iget(fs_info->sb, &key, inode_root, NULL);
 	if (IS_ERR(inode)) {
-		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-		return PTR_ERR(inode);
+		ret = PTR_ERR(inode);
+		goto cleanup;
 	}
+	srcu_read_unlock(&fs_info->subvol_srcu, index);
 
 	/* do a chunk of defrag */
 	clear_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
@@ -346,6 +356,10 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 
 	iput(inode);
 	return 0;
+cleanup:
+	srcu_read_unlock(&fs_info->subvol_srcu, index);
+	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index bdbb94f..67783e0 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -580,20 +580,29 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 	int corrected = 0;
 	struct btrfs_key key;
 	struct inode *inode = NULL;
+	struct btrfs_fs_info *fs_info;
 	u64 end = offset + PAGE_SIZE - 1;
 	struct btrfs_root *local_root;
+	int srcu_index;
 
 	key.objectid = root;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
-	local_root = btrfs_read_fs_root_no_name(fixup->root->fs_info, &key);
-	if (IS_ERR(local_root))
+
+	fs_info = fixup->root->fs_info;
+	srcu_index = srcu_read_lock(&fs_info->subvol_srcu);
+
+	local_root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(local_root)) {
+		srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
 		return PTR_ERR(local_root);
+	}
 
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.objectid = inum;
 	key.offset = 0;
-	inode = btrfs_iget(fixup->root->fs_info->sb, &key, local_root, NULL);
+	inode = btrfs_iget(fs_info->sb, &key, local_root, NULL);
+	srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
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
+	int srcu_index;
 
 	key.objectid = root;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
+
+	srcu_index = srcu_read_lock(&fs_info->subvol_srcu);
+
 	local_root = btrfs_read_fs_root_no_name(fs_info, &key);
-	if (IS_ERR(local_root))
+	if (IS_ERR(local_root)) {
+		srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
 		return PTR_ERR(local_root);
+	}
 
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.objectid = inum;
 	key.offset = 0;
 	inode = btrfs_iget(fs_info->sb, &key, local_root, NULL);
+	srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
-- 
1.7.7.6

