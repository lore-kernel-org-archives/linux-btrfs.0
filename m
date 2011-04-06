From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not use async submit for small DIO io's
Date: Wed,  6 Apr 2011 14:44:06 -0400
Message-ID: <1302115446-3046-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When looking at our DIO performance Chris said that for small IO's doing the
async submit stuff tends to be more overhead than it's worth.  With this on top
of my other fixes I get about a 17-20% speedup doing a sequential dd with 4k
IO's.  Basically if we don't have to split the bio for the map length it's small
enough to be directly submitted, otherwise go back to the async submit.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5144d5c..93ed346 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5955,7 +5955,7 @@ static struct bio *btrfs_dio_bio_alloc(struct block_device *bdev,
 
 static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 					 int rw, u64 file_offset, int skip_sum,
-					 u32 *csums)
+					 u32 *csums, int async_submit)
 {
 	int write = rw & REQ_WRITE;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -5966,13 +5966,24 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 	if (ret)
 		goto err;
 
-	if (write && !skip_sum) {
+	if (skip_sum)
+		goto map;
+
+	if (write && async_submit) {
 		ret = btrfs_wq_submit_bio(root->fs_info,
 				   inode, rw, bio, 0, 0,
 				   file_offset,
 				   __btrfs_submit_bio_start_direct_io,
 				   __btrfs_submit_bio_done);
 		goto err;
+	} else if (write) {
+		/*
+		 * If we aren't doing async submit, calculate the csum of the
+		 * bio now.
+		 */
+		ret = btrfs_csum_one_bio(root, inode, bio, file_offset, 1);
+		if (ret)
+			goto err;
 	} else if (!skip_sum) {
 		ret = btrfs_lookup_bio_sums_dio(root, inode, bio,
 					  file_offset, csums);
@@ -5980,7 +5991,8 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 			goto err;
 	}
 
-	ret = btrfs_map_bio(root, rw, bio, 0, 1);
+map:
+	ret = btrfs_map_bio(root, rw, bio, 0, async_submit);
 err:
 	bio_put(bio);
 	return ret;
@@ -6002,6 +6014,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	int nr_pages = 0;
 	u32 *csums = dip->csums;
 	int ret = 0;
+	int async_submit = 0;
 	int write = rw & REQ_WRITE;
 
 	map_length = orig_bio->bi_size;
@@ -6017,6 +6030,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 		goto submit;
 	}
 
+	async_submit = 1;
 	bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev, start_sector, GFP_NOFS);
 	if (!bio)
 		return -ENOMEM;
@@ -6037,7 +6051,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			atomic_inc(&dip->pending_bios);
 			ret = __btrfs_submit_dio_bio(bio, inode, rw,
 						     file_offset, skip_sum,
-						     csums);
+						     csums, async_submit);
 			if (ret) {
 				bio_put(bio);
 				atomic_dec(&dip->pending_bios);
@@ -6076,7 +6090,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 
 submit:
 	ret = __btrfs_submit_dio_bio(bio, inode, rw, file_offset, skip_sum,
-				     csums);
+				     csums, async_submit);
 	if (!ret)
 		return 0;
 
-- 
1.7.2.3

