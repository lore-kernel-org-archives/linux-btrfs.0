From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix possible panic on unmount
Date: Fri, 13 Nov 2009 12:06:52 -0500
Message-ID: <20091113170651.GD26371@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We can race with the unmount of an fs and the stopping of a kthread where we
will free the block group before we're done using it.  The reason for this is
because we do not hold a reference on the block group while its caching, since
the allocator drops its reference once it exits or moves on to the next block
group.  This patch fixes the problem by taking a reference to the block group
before we start caching and dropping it when we're done to make sure all
accesses to the block group are safe.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2a4cdce..197bc1b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -399,6 +399,8 @@ err:
 
 	put_caching_control(caching_ctl);
 	atomic_dec(&block_group->space_info->caching_threads);
+	btrfs_put_block_group(block_group);
+
 	return 0;
 }
 
@@ -439,6 +441,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache)
 	up_write(&fs_info->extent_commit_sem);
 
 	atomic_inc(&cache->space_info->caching_threads);
+	atomic_inc(&cache->count);
 
 	tsk = kthread_run(caching_kthread, cache, "btrfs-cache-%llu\n",
 			  cache->key.objectid);
-- 
1.5.4.3

