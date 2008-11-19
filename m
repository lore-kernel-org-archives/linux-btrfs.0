From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix free space accounting when unpinning extents
Date: Wed, 19 Nov 2008 14:56:55 -0500
Message-ID: <20081119195652.GD16041@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lt73@cs.drexel.edu
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch fixes what I hope is the last early ENOSPC bug left.  I did not know
that pinned extents would merge into one big extent when inserted on to the
pinned extent tree, so I was adding free space to a block group that could
possibly span multiple block groups.  This is a big issue because first that
space doesn't exist in that block group, and second we won't actually use that
space because there are a bunch of other checks to make sure we're allocating
within the constraints of the block group.  This patch fixes the problem by
adding the btrfs_add_free_space to btrfs_update_pinned_extents which makes sure
we are adding the appropriate amount of free space to the appropriate block
group.  Thanks much to Lee Trager for running my myriad of debug patches to help
me track this problem down.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b017e87..e388a37 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2034,6 +2034,8 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 			fs_info->total_pinned -= len;
+			if (cache->cached)
+				btrfs_add_free_space(cache, bytenr, len);
 		}
 		bytenr += len;
 		num -= len;
@@ -2099,7 +2101,6 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	u64 start;
 	u64 end;
 	int ret;
-	struct btrfs_block_group_cache *cache;
 
 	mutex_lock(&root->fs_info->pinned_mutex);
 	while(1) {
@@ -2109,9 +2110,6 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			break;
 		btrfs_update_pinned_extents(root, start, end + 1 - start, 0);
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
-		cache = btrfs_lookup_block_group(root->fs_info, start);
-		if (cache->cached)
-			btrfs_add_free_space(cache, start, end - start + 1);
 		if (need_resched()) {
 			mutex_unlock(&root->fs_info->pinned_mutex);
 			cond_resched();
