Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751250AbdFBQ7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 12:59:51 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5CE9CABB1
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Jun 2017 16:59:50 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 8/8] btrfs: pass bytes to btrfs_bio_alloc
Date: Fri,  2 Jun 2017 18:58:50 +0200
Message-Id: <30426258414b98794cb7de68df1440a75b868e56.1496422340.git.dsterba@suse.com>
In-Reply-To: <cover.1496422340.git.dsterba@suse.com>
References: <cover.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Most callers of btrfs_bio_alloc convert from bytes to sectors. Hide that
in the helper and simplify the logic in the callsers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 8 ++++----
 fs/btrfs/extent_io.c   | 6 +++---
 fs/btrfs/extent_io.h   | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2df080c4ece0..fd6508bcff77 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -305,7 +305,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 
 	bdev = fs_info->fs_devices->latest_bdev;
 
-	bio = btrfs_bio_alloc(bdev, first_byte >> 9);
+	bio = btrfs_bio_alloc(bdev, first_byte);
 	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	bio->bi_private = cb;
 	bio->bi_end_io = end_compressed_bio_write;
@@ -352,7 +352,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 
 			bio_put(bio);
 
-			bio = btrfs_bio_alloc(bdev, first_byte >> 9);
+			bio = btrfs_bio_alloc(bdev, first_byte);
 			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 			bio->bi_private = cb;
 			bio->bi_end_io = end_compressed_bio_write;
@@ -595,7 +595,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	/* include any pages we added in add_ra-bio_pages */
 	cb->len = bio->bi_iter.bi_size;
 
-	comp_bio = btrfs_bio_alloc(bdev, cur_disk_byte >> 9);
+	comp_bio = btrfs_bio_alloc(bdev, cur_disk_byte);
 	bio_set_op_attrs (comp_bio, REQ_OP_READ, 0);
 	comp_bio->bi_private = cb;
 	comp_bio->bi_end_io = end_compressed_bio_read;
@@ -646,7 +646,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 			bio_put(comp_bio);
 
-			comp_bio = btrfs_bio_alloc(bdev, cur_disk_byte >> 9);
+			comp_bio = btrfs_bio_alloc(bdev, cur_disk_byte);
 			bio_set_op_attrs(comp_bio, REQ_OP_READ, 0);
 			comp_bio->bi_private = cb;
 			comp_bio->bi_end_io = end_compressed_bio_read;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5730b4e747f1..cb4754e57ace 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2658,14 +2658,14 @@ static void end_bio_extent_readpage(struct bio *bio)
  * never fail.  We're returning a bio right now but you can call btrfs_io_bio
  * for the appropriate container_of magic
  */
-struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_sector)
+struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_byte)
 {
 	struct btrfs_io_bio *btrfs_bio;
 	struct bio *bio;
 
 	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, btrfs_bioset);
 	bio->bi_bdev = bdev;
-	bio->bi_iter.bi_sector = first_sector;
+	bio->bi_iter.bi_sector = first_byte >> 9;
 	btrfs_bio = btrfs_io_bio(bio);
 	btrfs_bio->csum = NULL;
 	btrfs_bio->csum_allocated = NULL;
@@ -2798,7 +2798,7 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 		}
 	}
 
-	bio = btrfs_bio_alloc(bdev, sector);
+	bio = btrfs_bio_alloc(bdev, sector << 9);
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index fb7a938ecbc9..8071e3977614 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -462,7 +462,7 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 				 u64 delalloc_end, struct page *locked_page,
 				 unsigned bits_to_clear,
 				 unsigned long page_ops);
-struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_sector);
+struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_byte);
 struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs);
 struct bio *btrfs_bio_clone(struct bio *bio);
 struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size);
-- 
2.12.0

