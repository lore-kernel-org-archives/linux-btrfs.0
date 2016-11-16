Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41770 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbcKPMwh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:52:37 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6zhc-0005SR-1V
        for linux-btrfs@vger.kernel.org; Wed, 16 Nov 2016 12:52:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9] btrfs: use bi_size
Date: Wed, 16 Nov 2016 13:52:12 +0100
Message-Id: <1479300736-9724-6-git-send-email-hch@lst.de>
In-Reply-To: <1479300736-9724-1-git-send-email-hch@lst.de>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of using bi_vcnt to calculate it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/compression.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 12a631d..8618ac3 100644
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

