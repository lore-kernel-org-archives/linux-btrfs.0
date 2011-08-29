From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: put the block group cache after we commit the super
Date: Mon, 29 Aug 2011 14:06:53 -0400
Message-ID: <1314641213-22327-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In moving some enospc stuff around I noticed that when we unmount we are often
evicting the free space cache inodes before we do our last commit.  This isn't
bad, but it makes us constantly have to re-read the inodes back.  So instead
don't evict the cache until after we do our last commit, this will make things a
little less crappy and makes a future enospc change work properly.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
 
-- 
1.7.5.2

