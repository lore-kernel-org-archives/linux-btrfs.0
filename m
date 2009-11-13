From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] btrfs: fix possible panic on unmount V2.
Date: Fri, 13 Nov 2009 15:12:59 -0500
Message-ID: <20091113201259.GG26371@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Changes since V1:
-Do not kfree directly in btrfs_free_block_groups, just put the last reference
-Instead of open coding atomic_inc(&cache->count), move it into a helper
 function.

We can race with the unmount of an fs and the stopping of a kthread where we
will free the block group before we're done using it.  The reason for this is
because we do not hold a reference on the block group while its caching, since
the allocator drops its reference once it exits or moves on to the next block
group.  This patch fixes the problem by taking a reference to the block group
before we start caching and dropping it when we're done to make sure all
accesses to the block group are safe.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2a4cdce..55132dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -83,6 +83,17 @@ static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
 	return (cache->flags & bits) == bits;
 }
 
+void btrfs_get_block_group(struct btrfs_block_group_cache *cache)
+{
+	atomic_inc(&cache->count);
+}
+
+void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
+{
+	if (atomic_dec_and_test(&cache->count))
+		kfree(cache);
+}
+
 /*
  * this adds the block group to the fs_info rb tree for the block group
  * cache
@@ -156,7 +167,7 @@ block_group_cache_tree_search(struct btrfs_fs_info *info, u64 bytenr,
 		}
 	}
 	if (ret)
-		atomic_inc(&ret->count);
+		btrfs_get_block_group(ret);
 	spin_unlock(&info->block_group_cache_lock);
 
 	return ret;
@@ -399,6 +410,8 @@ err:
 
 	put_caching_control(caching_ctl);
 	atomic_dec(&block_group->space_info->caching_threads);
+	btrfs_put_block_group(block_group);
+
 	return 0;
 }
 
@@ -439,6 +452,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache)
 	up_write(&fs_info->extent_commit_sem);
 
 	atomic_inc(&cache->space_info->caching_threads);
+	btrfs_get_block_group(cache);
 
 	tsk = kthread_run(caching_kthread, cache, "btrfs-cache-%llu\n",
 			  cache->key.objectid);
@@ -478,12 +492,6 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
 	return cache;
 }
 
-void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
-{
-	if (atomic_dec_and_test(&cache->count))
-		kfree(cache);
-}
-
 static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 						  u64 flags)
 {
@@ -2573,7 +2581,7 @@ next_block_group(struct btrfs_root *root,
 	if (node) {
 		cache = rb_entry(node, struct btrfs_block_group_cache,
 				 cache_node);
-		atomic_inc(&cache->count);
+		btrfs_get_block_group(cache);
 	} else
 		cache = NULL;
 	spin_unlock(&root->fs_info->block_group_cache_lock);
@@ -4211,7 +4219,7 @@ search:
 		u64 offset;
 		int cached;
 
-		atomic_inc(&block_group->count);
+		btrfs_get_block_group(block_group);
 		search_start = block_group->key.objectid;
 
 have_block_group:
@@ -4299,7 +4307,7 @@ have_block_group:
 
 				btrfs_put_block_group(block_group);
 				block_group = last_ptr->block_group;
-				atomic_inc(&block_group->count);
+				btrfs_get_block_group(block_group);
 				spin_unlock(&last_ptr->lock);
 				spin_unlock(&last_ptr->refill_lock);
 
@@ -7372,9 +7380,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			wait_block_group_cache_done(block_group);
 
 		btrfs_remove_free_space_cache(block_group);
-
-		WARN_ON(atomic_read(&block_group->count) != 1);
-		kfree(block_group);
+		btrfs_put_block_group(block_group);
 
 		spin_lock(&info->block_group_cache_lock);
 	}
-- 
1.5.4.3

