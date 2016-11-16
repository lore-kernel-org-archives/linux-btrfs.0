Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41747 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbcKPMwa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:52:30 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6zhV-0005Rn-JF
        for linux-btrfs@vger.kernel.org; Wed, 16 Nov 2016 12:52:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] btrfs: don't access the bio directly in the raid5/6 code
Date: Wed, 16 Nov 2016 13:52:10 +0100
Message-Id: <1479300736-9724-4-git-send-email-hch@lst.de>
In-Reply-To: <1479300736-9724-1-git-send-email-hch@lst.de>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just use bio_for_each_segment_all to iterate over all segments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

