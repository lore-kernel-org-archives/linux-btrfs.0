Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34251 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753436AbcKYIhx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 03:37:53 -0500
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 7/8] btrfs: refactor __btrfs_lookup_bio_sums to use bio_for_each_segment_all
Date: Fri, 25 Nov 2016 09:07:52 +0100
Message-Id: <1480061273-5722-8-git-send-email-hch@lst.de>
In-Reply-To: <1480061273-5722-1-git-send-email-hch@lst.de>
References: <1480061273-5722-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rework the loop a little bit to use the generic bio_for_each_segment_all
helper for iterating over the bio.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/file-item.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index fa8aa53..6b8fda3 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -163,7 +163,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				   struct inode *inode, struct bio *bio,
 				   u64 logical_offset, u32 *dst, int dio)
 {
-	struct bio_vec *bvec = bio->bi_io_vec;
+	struct bio_vec *bvec;
 	struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
 	struct btrfs_csum_item *item = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
@@ -176,8 +176,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	u64 page_bytes_left;
 	u32 diff;
 	int nblocks;
-	int bio_index = 0;
-	int count;
+	int count = 0, i;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
@@ -223,8 +222,11 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	if (dio)
 		offset = logical_offset;
 
-	page_bytes_left = bvec->bv_len;
-	while (bio_index < bio->bi_vcnt) {
+	bio_for_each_segment_all(bvec, bio, i) {
+		page_bytes_left = bvec->bv_len;
+		if (count)
+			goto next;
+
 		if (!dio)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
@@ -285,29 +287,17 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 found:
 		csum += count * csum_size;
 		nblocks -= count;
-
+next:
 		while (count--) {
 			disk_bytenr += root->sectorsize;
 			offset += root->sectorsize;
 			page_bytes_left -= root->sectorsize;
-			if (!page_bytes_left) {
-				bio_index++;
-				/*
-				 * make sure we're still inside the
-				 * bio before we update page_bytes_left
-				 */
-				if (bio_index >= bio->bi_vcnt) {
-					WARN_ON_ONCE(count);
-					goto done;
-				}
-				bvec++;
-				page_bytes_left = bvec->bv_len;
-			}
-
+			if (!page_bytes_left)
+				break; /* move to next bio */
 		}
 	}
 
-done:
+	WARN_ON_ONCE(count);
 	btrfs_free_path(path);
 	return 0;
 }
-- 
2.1.4

