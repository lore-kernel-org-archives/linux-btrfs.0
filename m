From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use commit root when loading free space cache
Date: Tue, 10 Apr 2012 13:03:34 -0400
Message-ID: <1334077414-2496-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported that booting his box up with btrfs root on 3.4 was way
slower than on 3.3 because I removed the ideal caching code.  It turns out
that we don't load the free space cache if we're in a commit for deadlock
reasons, but since we're reading the cache and it hasn't changed yet we are
safe reading the inode and free space item from the commit root, so do that
and remove all of the deadlock checks so we don't unnecessarily skip loading
the free space cache.  The user reported this fixed the slowness.  Thanks,

Tested-by: Calvin Walton <calvin.walton@kepstin.ca>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c      |    4 +---
 fs/btrfs/free-space-cache.c |    9 ++-------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..4a871f0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -529,9 +529,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	 * allocate blocks for the tree root we can't do the fast caching since
 	 * we likely hold important locks.
 	 */
-	if (trans && (!trans->transaction->in_commit) &&
-	    (root && root != root->fs_info->tree_root) &&
-	    btrfs_test_opt(root, SPACE_CACHE)) {
+	if (fs_info->mount_opt & BTRFS_MOUNT_SPACE_CACHE) {
 		ret = load_free_space_cache(fs_info, cache);
 
 		spin_lock(&cache->lock);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 054707e..baaa518 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -748,13 +748,6 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	u64 used = btrfs_block_group_used(&block_group->item);
 
 	/*
-	 * If we're unmounting then just return, since this does a search on the
-	 * normal root and not the commit root and we could deadlock.
-	 */
-	if (btrfs_fs_closing(fs_info))
-		return 0;
-
-	/*
 	 * If this block group has been marked to be cleared for one reason or
 	 * another then we can't trust the on disk cache, so just return.
 	 */
@@ -768,6 +761,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	path = btrfs_alloc_path();
 	if (!path)
 		return 0;
+	path->search_commit_root = 1;
+	path->skip_locking = 1;
 
 	inode = lookup_free_space_inode(root, block_group, path);
 	if (IS_ERR(inode)) {
-- 
1.7.5.2

