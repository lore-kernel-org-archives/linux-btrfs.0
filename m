Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60966 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbcKYI2d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 03:28:33 -0500
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 3/8] btrfs: don't access the bio directly in the direct I/O code
Date: Fri, 25 Nov 2016 09:07:48 +0100
Message-Id: <1480061273-5722-4-git-send-email-hch@lst.de>
In-Reply-To: <1480061273-5722-1-git-send-email-hch@lst.de>
References: <1480061273-5722-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just use bio_for_each_segment_all to iterate over all segments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 147df4c..3f09cb6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8394,7 +8394,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *bio;
 	struct bio *orig_bio = dip->orig_bio;
-	struct bio_vec *bvec = orig_bio->bi_io_vec;
+	struct bio_vec *bvec;
 	u64 start_sector = orig_bio->bi_iter.bi_sector;
 	u64 file_offset = dip->logical_offset;
 	u64 submit_len = 0;
@@ -8403,7 +8403,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	int async_submit = 0;
 	int nr_sectors;
 	int ret;
-	int i;
+	int i, j;
 
 	map_length = orig_bio->bi_iter.bi_size;
 	ret = btrfs_map_block(root->fs_info, btrfs_op(orig_bio),
@@ -8433,7 +8433,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	btrfs_io_bio(bio)->logical = file_offset;
 	atomic_inc(&dip->pending_bios);
 
-	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
+	bio_for_each_segment_all(bvec, orig_bio, j) {
 		nr_sectors = BTRFS_BYTES_TO_BLKS(root->fs_info, bvec->bv_len);
 		i = 0;
 next_block:
@@ -8487,7 +8487,6 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 				i++;
 				goto next_block;
 			}
-			bvec++;
 		}
 	}
 
-- 
2.1.4

