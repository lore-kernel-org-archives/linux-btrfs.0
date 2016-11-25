Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753295AbcKYIfI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 03:35:08 -0500
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 5/8] btrfs: use bi_size
Date: Fri, 25 Nov 2016 09:07:50 +0100
Message-Id: <1480061273-5722-6-git-send-email-hch@lst.de>
In-Reply-To: <1480061273-5722-1-git-send-email-hch@lst.de>
References: <1480061273-5722-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of using bi_vcnt to calculate it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/compression.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index fcaa25f..77042a8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -562,7 +562,6 @@ static noinline int add_ra_bio_pages(struct inode *inode,
  *
  * bio->bi_iter.bi_sector points to the compressed extent on disk
  * bio->bi_io_vec points to all of the inode pages
- * bio->bi_vcnt is a count of pages
  *
  * After the compressed pages are read, we copy the bytes into the
  * bio we were passed and then call the bio end_io calls
@@ -574,7 +573,6 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	struct extent_map_tree *em_tree;
 	struct compressed_bio *cb;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	unsigned long uncompressed_len = bio->bi_vcnt * PAGE_SIZE;
 	unsigned long compressed_len;
 	unsigned long nr_pages;
 	unsigned long pg_index;
@@ -619,7 +617,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	free_extent_map(em);
 	em = NULL;
 
-	cb->len = uncompressed_len;
+	cb->len = bio->bi_iter.bi_size;
 	cb->compressed_len = compressed_len;
 	cb->compress_type = extent_compress_type(bio_flags);
 	cb->orig_bio = bio;
@@ -647,8 +645,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	add_ra_bio_pages(inode, em_start + em_len, cb);
 
 	/* include any pages we added in add_ra-bio_pages */
-	uncompressed_len = bio->bi_vcnt * PAGE_SIZE;
-	cb->len = uncompressed_len;
+	cb->len = bio->bi_iter.bi_size;
 
 	comp_bio = compressed_bio_alloc(bdev, cur_disk_byte, GFP_NOFS);
 	if (!comp_bio)
-- 
2.1.4

