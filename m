From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: only set cache_generation if we setup the block group
Date: Tue, 13 Dec 2011 16:10:11 -0500
Message-ID: <1323810611-6134-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a problem booting into a new kernel with the old format inodes.
He was panicing in cow_file_range while writing out the inode cache.  This is
because if the block group is not cached we'll just skip writing out the cache,
however if it gets dirtied again in the same transaction and it finished caching
we'd go ahead and write it out, but since we set cache_generation to the transid
we think we've already truncated it and will just carry on, running into
cow_file_range and blowing up.  We need to make sure we only set
cache_generation if we've done the truncate.  The user tested this patch and
verified that the panic no longer occured.  Thanks,

Reported-and-Tested-by: Klaus Bitto <klaus.bitto@gmail.com>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6c37d46..a9771cf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2822,7 +2822,7 @@ out_free:
 	btrfs_release_path(path);
 out:
 	spin_lock(&block_group->lock);
-	if (!ret)
+	if (!ret && dcs == BTRFS_DC_SETUP)
 		block_group->cache_generation = trans->transid;
 	block_group->disk_cache_state = dcs;
 	spin_unlock(&block_group->lock);
-- 
1.7.5.2

