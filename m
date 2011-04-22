From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 03/12] btrfs: fix dereference before check
Date: Fri, 22 Apr 2011 11:41:24 +0200
Message-ID: <8927a99072750c65ba0c3379d6663913cae8d258.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

The superblock's ->s_fs_info is properly set in btrfs_fill_super, after
a call to open_ctree, which derefereces it before check. Although
tree_root is set via btrfs_set_super, let's be defensive and leave the
check in place.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8f07c86..5e5d07c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1611,7 +1611,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	struct btrfs_root *csum_root = kzalloc(sizeof(struct btrfs_root),
 						 GFP_NOFS);
 	struct btrfs_root *tree_root = btrfs_sb(sb);
-	struct btrfs_fs_info *fs_info = tree_root->fs_info;
+	struct btrfs_fs_info *fs_info = NULL;
 	struct btrfs_root *chunk_root = kzalloc(sizeof(struct btrfs_root),
 						GFP_NOFS);
 	struct btrfs_root *dev_root = kzalloc(sizeof(struct btrfs_root),
@@ -1623,11 +1623,12 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	struct btrfs_super_block *disk_super;
 
-	if (!extent_root || !tree_root || !fs_info ||
+	if (!extent_root || !tree_root || !tree_root->fs_info ||
 	    !chunk_root || !dev_root || !csum_root) {
 		err = -ENOMEM;
 		goto fail;
 	}
+	fs_info = tree_root->fs_info;
 
 	ret = init_srcu_struct(&fs_info->subvol_srcu);
 	if (ret) {
-- 
1.7.5.rc3

