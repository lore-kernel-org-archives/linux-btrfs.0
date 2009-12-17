From: jim owens <jowens@hp.com>
Subject: [PATCH] __btrfs_map_block should not set length more than input length.
Date: Thu, 17 Dec 2009 16:42:41 -0500
Message-ID: <4B2AA5D1.7090607@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Returning a value greater than the caller's is ugly and prone
to dangerous future coding mistakes.

Signed-off-by: jim owens <jowens@hp.com>
---
 fs/btrfs/extent-tree.c |    3 ---
 fs/btrfs/inode.c       |    5 ++---
 fs/btrfs/volumes.c     |    9 +++++----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8d1fd6d..86bc625 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1591,9 +1591,6 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 		struct btrfs_bio_stripe *stripe = multi->stripes;
 		int i;
 
-		if (map_length > num_bytes)
-			map_length = num_bytes;
-
 		for (i = 0; i < multi->num_stripes; i++, stripe++) {
 			btrfs_issue_discard(stripe->dev->bdev,
 					    stripe->physical,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ee92801..87bb76f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1386,20 +1386,19 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 	struct btrfs_mapping_tree *map_tree;
 	u64 logical = (u64)bio->bi_sector << 9;
-	u64 length = 0;
+	u64 length = bio->bi_size + size;
 	u64 map_length;
 	int ret;
 
 	if (bio_flags & EXTENT_BIO_COMPRESSED)
 		return 0;
 
-	length = bio->bi_size;
 	map_tree = &root->fs_info->mapping_tree;
 	map_length = length;
 	ret = btrfs_map_block(map_tree, READ, logical,
 			      &map_length, NULL, 0);
 
-	if (map_length < length + size)
+	if (ret || map_length < length)
 		return 1;
 	return 0;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4a0c8e5..e555408 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2697,14 +2697,15 @@ again:
 	/* stripe_offset is the offset of this block in its stripe*/
 	stripe_offset = offset - stripe_offset;
 
+	/* return smaller of input length or remaining contiguous length */
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
 			 BTRFS_BLOCK_GROUP_RAID10)) {
-		/* we limit the length of each bio to what fits in a stripe */
-		*length = min_t(u64, em->len - offset,
-			      map->stripe_len - stripe_offset);
+		/* only the length that fits in one stripe is contiguous */
+		*length = min(*length, min_t(u64, em->len - offset,
+			      map->stripe_len - stripe_offset));
 	} else {
 		/* RAID1, DUP, and simple disk stripes are all contiguous */
-		*length = em->len - offset;
+		*length = min(*length, em->len - offset);
 	}
 
 	if (!multi_ret && !unplug_page)
-- 
1.5.6.3
