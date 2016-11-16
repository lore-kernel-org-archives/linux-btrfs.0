Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41759 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbcKPMwd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:52:33 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6zhY-0005SB-VT
        for linux-btrfs@vger.kernel.org; Wed, 16 Nov 2016 12:52:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] btrfs: don't access the bio directly in btrfs_csum_one_bio
Date: Wed, 16 Nov 2016 13:52:11 +0100
Message-Id: <1479300736-9724-5-git-send-email-hch@lst.de>
In-Reply-To: <1479300736-9724-1-git-send-email-hch@lst.de>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use bio_for_each_segment_all to iterate over the segments instead.
This requires a bit of reshuffling so that we only lookup up the ordered
item once inside the bio_for_each_segment_all loop.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/file-item.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index d0d571c..fa8aa53 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -447,13 +447,12 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		       struct bio *bio, u64 file_start, int contig)
 {
 	struct btrfs_ordered_sum *sums;
-	struct btrfs_ordered_extent *ordered;
+	struct btrfs_ordered_extent *ordered = NULL;
 	char *data;
-	struct bio_vec *bvec = bio->bi_io_vec;
-	int bio_index = 0;
+	struct bio_vec *bvec;
 	int index;
 	int nr_sectors;
-	int i;
+	int i, j;
 	unsigned long total_bytes = 0;
 	unsigned long this_sum_bytes = 0;
 	u64 offset;
@@ -470,17 +469,20 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	if (contig)
 		offset = file_start;
 	else
-		offset = page_offset(bvec->bv_page) + bvec->bv_offset;
+		offset = 0; /* shut up gcc */
 
-	ordered = btrfs_lookup_ordered_extent(inode, offset);
-	BUG_ON(!ordered); /* Logic error */
 	sums->bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	index = 0;
 
-	while (bio_index < bio->bi_vcnt) {
+	bio_for_each_segment_all(bvec, bio, j) {
 		if (!contig)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
 
+		if (!ordered) {
+			ordered = btrfs_lookup_ordered_extent(inode, offset);
+			BUG_ON(!ordered); /* Logic error */
+		}
+
 		data = kmap_atomic(bvec->bv_page);
 
 		nr_sectors = BTRFS_BYTES_TO_BLKS(root->fs_info,
@@ -529,9 +531,6 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		}
 
 		kunmap_atomic(data);
-
-		bio_index++;
-		bvec++;
 	}
 	this_sum_bytes = 0;
 	btrfs_add_ordered_sum(inode, ordered, sums);
-- 
2.1.4

