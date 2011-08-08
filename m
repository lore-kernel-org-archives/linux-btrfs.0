From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: set i_size properly when fallocating and we already have an extent
Date: Mon,  8 Aug 2011 12:24:03 -0400
Message-ID: <1312820643-12478-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

xfstests exposed a problem with preallocate when it fallocates a range that
already has an extent.  We don't set the new i_size properly because we see that
we already have an extent.  This isn't right and we should update i_size if the
space already exists.  With this patch we now pass xfstests 075.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 658d669..5f8264a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1638,11 +1638,15 @@ static long btrfs_fallocate(struct file *file, int mode,
 
 	cur_offset = alloc_start;
 	while (1) {
+		u64 actual_end;
+
 		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
 				      alloc_end - cur_offset, 0);
 		BUG_ON(IS_ERR_OR_NULL(em));
 		last_byte = min(extent_map_end(em), alloc_end);
+		actual_end = min_t(u64, extent_map_end(em), offset + len);
 		last_byte = (last_byte + mask) & ~mask;
+
 		if (em->block_start == EXTENT_MAP_HOLE ||
 		    (cur_offset >= inode->i_size &&
 		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
@@ -1655,6 +1659,16 @@ static long btrfs_fallocate(struct file *file, int mode,
 				free_extent_map(em);
 				break;
 			}
+		} else if (actual_end > inode->i_size &&
+			   !(mode & FALLOC_FL_KEEP_SIZE)) {
+			/*
+			 * We didn't need to allocate any more space, but we
+			 * still extended the size of the file so we need to
+			 * update i_size.
+			 */
+			inode->i_ctime = CURRENT_TIME;
+			i_size_write(inode, actual_end);
+			btrfs_ordered_update_i_size(inode, actual_end, NULL);
 		}
 		free_extent_map(em);
 
-- 
1.7.5.2

