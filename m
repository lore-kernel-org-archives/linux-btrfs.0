From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't split dio bios if we don't have to
Date: Tue,  5 Apr 2011 19:40:51 -0400
Message-ID: <1302046851-2946-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We have been unconditionally allocating a new bio and re-adding all pages from
our original bio to the new bio.  This is needed if our original bio is larger
than our stripe size, but if it is smaller than the stripe size then there is no
need to do this.  So check the map length and if we are under that then go ahead
and submit the original bio.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3476760..8b82309 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5960,13 +5960,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	u32 *csums = dip->csums;
 	int ret = 0;
 
-	bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev, start_sector, GFP_NOFS);
-	if (!bio)
-		return -ENOMEM;
-	bio->bi_private = dip;
-	bio->bi_end_io = btrfs_end_dio_bio;
-	atomic_inc(&dip->pending_bios);
-
 	map_length = orig_bio->bi_size;
 	ret = btrfs_map_block(map_tree, READ, start_sector << 9,
 			      &map_length, NULL, 0);
@@ -5975,6 +5968,18 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 		return -EIO;
 	}
 
+	if (map_length >= orig_bio->bi_size) {
+		bio = orig_bio;
+		goto submit;
+	}
+
+	bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev, start_sector, GFP_NOFS);
+	if (!bio)
+		return -ENOMEM;
+	bio->bi_private = dip;
+	bio->bi_end_io = btrfs_end_dio_bio;
+	atomic_inc(&dip->pending_bios);
+
 	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
 		if (unlikely(map_length < submit_len + bvec->bv_len ||
 		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
@@ -6024,6 +6029,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 		}
 	}
 
+submit:
 	ret = __btrfs_submit_dio_bio(bio, inode, rw, file_offset, skip_sum,
 				     csums);
 	if (!ret)
-- 
1.7.2.3

