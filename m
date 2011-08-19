From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: only reserve space in fallocate if we have to do a preallocate
Date: Fri, 19 Aug 2011 16:27:05 -0400
Message-ID: <1313785625-17265-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Lukas found a problem where if he tries to fallocate over the same region twice
and the first fallocate took up all the space we would fail with ENOSPC.  This
is because we reserve the total space we want to use for fallocate, regardless
of wether or not we will have to actually preallocate.  So instead move the
check into the loop where we actually have to do the preallocate.  Thanks,

Tested-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..4cd3329 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1603,10 +1603,6 @@ static long btrfs_fallocate(struct file *file, int mode,
 			goto out;
 	}
 
-	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start);
-	if (ret)
-		goto out;
-
 	locked_end = alloc_end - 1;
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
@@ -1652,11 +1648,27 @@ static long btrfs_fallocate(struct file *file, int mode,
 		if (em->block_start == EXTENT_MAP_HOLE ||
 		    (cur_offset >= inode->i_size &&
 		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
+
+			/*
+			 * Make sure we have enough space before we do the
+			 * allocation.
+			 */
+			ret = btrfs_check_data_free_space(inode, last_byte -
+							  cur_offset);
+			if (ret) {
+				free_extent_map(em);
+				break;
+			}
+
 			ret = btrfs_prealloc_file_range(inode, mode, cur_offset,
 							last_byte - cur_offset,
 							1 << inode->i_blkbits,
 							offset + len,
 							&alloc_hint);
+
+			/* Let go of our reservation. */
+			btrfs_free_reserved_data_space(inode, last_byte -
+						       cur_offset);
 			if (ret < 0) {
 				free_extent_map(em);
 				break;
@@ -1682,8 +1694,6 @@ static long btrfs_fallocate(struct file *file, int mode,
 	}
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
 			     &cached_state, GFP_NOFS);
-
-	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
-- 
1.7.5.2

