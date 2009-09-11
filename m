From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix extent entry threshold calculation
Date: Fri, 11 Sep 2009 15:36:12 -0400
Message-ID: <20090911193611.GA7824@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There is a slight problem with the extent entry threshold calculation for the
free space cache.  We only adjust the threshold down as we add bitmaps, but
never actually adjust the threshold up as we add bitmaps.  This means we could
fragment the free space so badly that we end up using all bitmaps to describe
the free space, use all the free space which would result in the bitmaps being
freed, but then go to add free space again as we delete things and immediately
add bitmaps since the extent threshold would still be 0.  Now as we free bitmaps
the extent threshold will be ratcheted up to allow more extent entries to be
added.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/free-space-cache.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4eb2964..5c2caad 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -259,7 +259,9 @@ static int link_free_space(struct btrfs_block_group_cache *block_group,
 
 static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
 {
-	u64 max_bytes, possible_bytes;
+	u64 max_bytes;
+	u64 bitmap_bytes;
+	u64 extent_bytes;
 
 	/*
 	 * The goal is to keep the total amount of memory used per 1gb of space
@@ -269,22 +271,27 @@ static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
 	max_bytes = MAX_CACHE_BYTES_PER_GIG *
 		(div64_u64(block_group->key.offset, 1024 * 1024 * 1024));
 
-	possible_bytes = (block_group->total_bitmaps * PAGE_CACHE_SIZE) +
-		(sizeof(struct btrfs_free_space) *
-		 block_group->extents_thresh);
+	/*
+	 * we want to account for 1 more bitmap than what we have so we can make
+	 * sure we don't go over our overall goal of MAX_CACHE_BYTES_PER_GIG as
+	 * we add more bitmaps.
+	 */
+	bitmap_bytes = (block_group->total_bitmaps + 1) * PAGE_CACHE_SIZE;
 
-	if (possible_bytes > max_bytes) {
-		int extent_bytes = max_bytes -
-			(block_group->total_bitmaps * PAGE_CACHE_SIZE);
+	if (bitmap_bytes >= max_bytes) {
+		block_group->extents_thresh = 0;
+		return;
+	}
 
-		if (extent_bytes <= 0) {
-			block_group->extents_thresh = 0;
-			return;
-		}
+	/*
+	 * we want the extent entry threshold to always be at most 1/2 the maxw
+	 * bytes we can have, or whatever is less than that.
+	 */
+	extent_bytes = max_bytes - bitmap_bytes;
+	extent_bytes = min_t(u64, extent_bytes, div64_u64(max_bytes, 2));
 
-		block_group->extents_thresh = extent_bytes /
-			(sizeof(struct btrfs_free_space));
-	}
+	block_group->extents_thresh =
+		div64_u64(extent_bytes, (sizeof(struct btrfs_free_space)));
 }
 
 static void bitmap_clear_bits(struct btrfs_block_group_cache *block_group,
-- 
1.5.4.3

