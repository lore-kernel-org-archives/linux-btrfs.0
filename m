Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751140AbdFBQ7q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 12:59:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 02D02ABBD
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Jun 2017 16:59:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/8] btrfs: remove redundant parameters from btrfs_bio_alloc
Date: Fri,  2 Jun 2017 18:58:44 +0200
Message-Id: <174c51230cae682e9f6c2c237833da89a1d2b6ab.1496422340.git.dsterba@suse.com>
In-Reply-To: <cover.1496422340.git.dsterba@suse.com>
References: <cover.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass gfp_flags=GFP_NOFS and nr_vecs=BIO_MAX_PAGES.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 2 +-
 fs/btrfs/extent_io.c   | 9 +++------
 fs/btrfs/extent_io.h   | 4 +---
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ba511dd454d5..7ad0a1c4be68 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -56,7 +56,7 @@ static inline int compressed_bio_size(struct btrfs_fs_info *fs_info,
 static struct bio *compressed_bio_alloc(struct block_device *bdev,
 					u64 first_byte, gfp_t gfp_flags)
 {
-	return btrfs_bio_alloc(bdev, first_byte >> 9, BIO_MAX_PAGES, gfp_flags);
+	return btrfs_bio_alloc(bdev, first_byte >> 9);
 }
 
 static int check_compressed_csum(struct btrfs_inode *inode,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a8f135286fa5..5730b4e747f1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2658,14 +2658,12 @@ static void end_bio_extent_readpage(struct bio *bio)
  * never fail.  We're returning a bio right now but you can call btrfs_io_bio
  * for the appropriate container_of magic
  */
-struct bio *
-btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
-		gfp_t gfp_flags)
+struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_sector)
 {
 	struct btrfs_io_bio *btrfs_bio;
 	struct bio *bio;
 
-	bio = bio_alloc_bioset(gfp_flags, nr_vecs, btrfs_bioset);
+	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, btrfs_bioset);
 	bio->bi_bdev = bdev;
 	bio->bi_iter.bi_sector = first_sector;
 	btrfs_bio = btrfs_io_bio(bio);
@@ -2800,8 +2798,7 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 		}
 	}
 
-	bio = btrfs_bio_alloc(bdev, sector, BIO_MAX_PAGES,
-			GFP_NOFS | __GFP_HIGH);
+	bio = btrfs_bio_alloc(bdev, sector);
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4fe643a5aeaf..fb7a938ecbc9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -462,9 +462,7 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 				 u64 delalloc_end, struct page *locked_page,
 				 unsigned bits_to_clear,
 				 unsigned long page_ops);
-struct bio *
-btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
-		gfp_t gfp_flags);
+struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_sector);
 struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs);
 struct bio *btrfs_bio_clone(struct bio *bio);
 struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size);
-- 
2.12.0

