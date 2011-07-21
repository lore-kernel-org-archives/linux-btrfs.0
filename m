From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 3/7] btrfs: Don't BUG_ON alloc_path errors in btrfs_truncate_inode_items
Date: Thu, 21 Jul 2011 12:48:29 -0700
Message-ID: <1311277713-7747-4-git-send-email-mfasheh@suse.com>
References: <1311277713-7747-1-git-send-email-mfasheh@suse.com>
 <1311277713-7747-2-git-send-email-mfasheh@suse.com>
 <1311277713-7747-3-git-send-email-mfasheh@suse.com>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311277713-7747-3-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

I moved the path allocation up a few lines to the top of the function so
that we couldn't get into the state where we've dropped delayed items and
the extent cache but fail due to -ENOMEM.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/inode.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8be7d7a..a0faf7d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3172,6 +3172,11 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->reada = -1;
+
 	if (root->ref_cows || root == root->fs_info->tree_root)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 
@@ -3184,10 +3189,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	if (min_type == 0 && root == BTRFS_I(inode)->root)
 		btrfs_kill_delayed_inode_items(inode);
 
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
-	path->reada = -1;
-
 	key.objectid = ino;
 	key.offset = (u64)-1;
 	key.type = (u8)-1;
-- 
1.7.5.3

