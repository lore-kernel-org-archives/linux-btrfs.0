From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: deal with min_bytes appropriately when looking for a cluster
Date: Fri, 18 Mar 2011 15:30:17 -0400
Message-ID: <1300476617-2183-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We do all this fun stuff with min_bytes, but either don't use it in the case of
just normal extents, or use it completely wrong in the case of bitmaps.  So fix
this for both cases

1) In the extent case, stop looking for space with window_free >= min_bytes
instead of bytes + empty_size.

2) In the bitmap case, we were looking for streches of free space that was at
least min_bytes in size, which was not right at all.  So instead search for
stretches of free space that are at least bytes in size (this will make a
difference when we have > page size blocks) and then only search for min_bytes
amount of free space.

Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f631df8..63776ae 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1910,8 +1910,8 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 
 	i = offset_to_bit(entry->offset, block_group->sectorsize,
 			  max_t(u64, offset, entry->offset));
-	search_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
-	total_bits = bytes_to_bits(bytes, block_group->sectorsize);
+	search_bits = bytes_to_bits(bytes, block_group->sectorsize);
+	total_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
 
 again:
 	found_bits = 0;
@@ -2034,8 +2034,7 @@ again:
 
 		if (entry->bitmap && entry->bytes > bytes + empty_size) {
 			ret = btrfs_bitmap_cluster(block_group, entry, cluster,
-						   offset, bytes + empty_size,
-						   min_bytes);
+						   offset, bytes, min_bytes);
 			if (!ret)
 				goto got_it;
 		}
@@ -2065,7 +2064,7 @@ again:
 
 	while (1) {
 		/* out window is just right, lets fill it */
-		if (window_free >= bytes + empty_size)
+		if (window_free >= min_bytes)
 			break;
 
 		node = rb_next(&last->offset_index);
-- 
1.7.2.3

