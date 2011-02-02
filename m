From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: exclude super blocks when we read in block groups
Date: Wed,  2 Feb 2011 10:53:47 -0500
Message-ID: <1296662027-8632-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This has been resulting in a BUT_ON(ret) after btrfs_reserve_extent in
btrfs_cow_file_range.  The reason is we don't actually calculate the bytes_super
for a block group until we go to cache it, which means that the space_info can
hand out reservations for space that it doesn't actually have, and we can run
out of data space.  This is also a problem if you are using space caching since
we don't ever calculate bytes_super for the block groups.  So instead everytime
we read a block group call exclude_super_stripes, which calculates the
bytes_super for the block group so it can be left out of the space_info.  Then
whenever caching completes we just call free_excluded_extents so that the super
excluded extents are freed up.  Also if we are unmounting and we hit any block
groups that haven't been cached we still need to call free_excluded_extents to
make sure things are cleaned up properly.  Thanks,

Reported-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 727706a..cdb2080 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -320,11 +320,6 @@ static int caching_kthread(void *data)
 	if (!path)
 		return -ENOMEM;
 
-	exclude_super_stripes(extent_root, block_group);
-	spin_lock(&block_group->space_info->lock);
-	block_group->space_info->bytes_readonly += block_group->bytes_super;
-	spin_unlock(&block_group->space_info->lock);
-
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 
 	/*
@@ -467,8 +462,10 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 			cache->cached = BTRFS_CACHE_NO;
 		}
 		spin_unlock(&cache->lock);
-		if (ret == 1)
+		if (ret == 1) {
+			free_excluded_extents(fs_info->extent_root, cache);
 			return 0;
+		}
 	}
 
 	if (load_cache_only)
@@ -4035,6 +4032,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 	atomic_dec(&BTRFS_I(inode)->outstanding_extents);
+	WARN_ON(atomic_read(&BTRFS_I(inode)->outstanding_extents) < 0);
 
 	reserved_extents = atomic_read(&BTRFS_I(inode)->reserved_extents);
 	do {
@@ -8329,6 +8327,13 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		if (block_group->cached == BTRFS_CACHE_STARTED)
 			wait_block_group_cache_done(block_group);
 
+		/*
+		 * We haven't cached this block group, which means we could
+		 * possibly have excluded extents on this block group.
+		 */
+		if (block_group->cached == BTRFS_CACHE_NO)
+			free_excluded_extents(info->extent_root, block_group);
+
 		btrfs_remove_free_space_cache(block_group);
 		btrfs_put_block_group(block_group);
 
@@ -8444,6 +8449,13 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		cache->sectorsize = root->sectorsize;
 
 		/*
+		 * We need to exclude the super stripes now so that the space
+		 * info has super bytes accounted for, otherwise we'll think
+		 * we have more space than we actually do.
+		 */
+		exclude_super_stripes(root, cache);
+
+		/*
 		 * check for two cases, either we are full, and therefore
 		 * don't need to bother with the caching work since we won't
 		 * find any space, or we are empty, and we can just add all
@@ -8451,12 +8463,10 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		 * time, particularly in the full case.
 		 */
 		if (found_key.offset == btrfs_block_group_used(&cache->item)) {
-			exclude_super_stripes(root, cache);
 			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
 			free_excluded_extents(root, cache);
 		} else if (btrfs_block_group_used(&cache->item) == 0) {
-			exclude_super_stripes(root, cache);
 			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
 			add_new_free_space(cache, root->fs_info,
-- 
1.7.2.3

