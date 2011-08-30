From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: put the block group cache after we commit the super V2
Date: Tue, 30 Aug 2011 09:45:23 -0400
Message-ID: <1314711923-7541-1-git-send-email-josef@redhat.com>
References: <1314641213-22327-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314641213-22327-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

In moving some enospc stuff around I noticed that when we unmount we are often
evicting the free space cache inodes before we do our last commit.  This isn't
bad, but it makes us constantly have to re-read the inodes back.  So instead
don't evict the cache until after we do our last commit, this will make things a
little less crappy and makes a future enospc change work properly.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: make lookup_free_space_inode still hold a ref even if we're unmounting.

 fs/btrfs/disk-io.c          |    4 ++--
 fs/btrfs/free-space-cache.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0b5643a..4965a01 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2543,8 +2543,6 @@ int close_ctree(struct btrfs_root *root)
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_run_defrag_inodes(root->fs_info);
 
-	btrfs_put_block_group_cache(fs_info);
-
 	/*
 	 * Here come 2 situations when btrfs is broken to flip readonly:
 	 *
@@ -2570,6 +2568,8 @@ int close_ctree(struct btrfs_root *root)
 			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
 	}
 
+	btrfs_put_block_group_cache(fs_info);
+
 	kthread_stop(root->fs_info->transaction_kthread);
 	kthread_stop(root->fs_info->cleaner_kthread);
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7912380..d56ba54 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -105,7 +105,7 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 		block_group->disk_cache_state = BTRFS_DC_CLEAR;
 	}
 
-	if (!btrfs_fs_closing(root->fs_info)) {
+	if (!block_group->iref) {
 		block_group->inode = igrab(inode);
 		block_group->iref = 1;
 	}
-- 
1.7.5.2

