From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: release reservations properly when doing inline extents
Date: Tue,  2 Aug 2011 14:59:49 -0400
Message-ID: <1312311589-16394-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We were only releasing our metadata reservations when doing inline extents,
which isn't correct since we don't need our data reservation either.  So call
btrfs_delalloc_release_space() instead of btrfs_delalloc_release_metadata().
This would have been caught earlier but we don't check for bytes_may_use still
being set on unmount, so add that to the WARN_ON() condition so we can catch
this sort of thing in the future.  This would cause us to leak space and run
into early ENOSPC problems.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    3 ++-
 fs/btrfs/inode.c       |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a3e61eb..d003508 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6915,7 +6915,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 					struct btrfs_space_info,
 					list);
 		if (space_info->bytes_pinned > 0 ||
-		    space_info->bytes_reserved > 0) {
+		    space_info->bytes_reserved > 0 ||
+		    space_info->bytes_may_use > 0) {
 			WARN_ON(1);
 			dump_space_info(space_info, 0, 0);
 		}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 68884ba..e449a1f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -255,7 +255,7 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 				   inline_len, compressed_size,
 				   compress_type, compressed_pages);
 	BUG_ON(ret);
-	btrfs_delalloc_release_metadata(inode, end + 1 - start);
+	btrfs_delalloc_release_space(inode, end + 1 - start);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 	return 0;
 }
-- 
1.7.5.2

