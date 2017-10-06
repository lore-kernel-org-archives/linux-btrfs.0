Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41083 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751807AbdJFMbp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 08:31:45 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: get rid of sector_t and use u64 offset in submit_extent_page
Date: Fri,  6 Oct 2017 14:30:00 +0200
Message-Id: <9f23652a57d3144c14ceeafacfa5526793d68ffb.1507292872.git.dsterba@suse.com>
In-Reply-To: <cover.1507292872.git.dsterba@suse.com>
References: <cover.1507292872.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The use of sector_t in the callchain of submit_extent_page is not
necessary, we'll pass plain u64 and avoid any con(tro)versions of sector_t.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ea9ab934794b..8d0834ee792b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2761,7 +2761,7 @@ static int merge_bio(struct extent_io_tree *tree, struct page *page,
  */
 static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 			      struct writeback_control *wbc,
-			      struct page *page, sector_t sector,
+			      struct page *page, u64 offset,
 			      size_t size, unsigned long pg_offset,
 			      struct block_device *bdev,
 			      struct bio **bio_ret,
@@ -2776,6 +2776,7 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 	int contig = 0;
 	int old_compressed = prev_bio_flags & EXTENT_BIO_COMPRESSED;
 	size_t page_size = min_t(size_t, size, PAGE_SIZE);
+	sector_t sector = offset >> 9;
 
 	if (bio_ret && *bio_ret) {
 		bio = *bio_ret;
@@ -2801,7 +2802,7 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 		}
 	}
 
-	bio = btrfs_bio_alloc(bdev, sector << 9);
+	bio = btrfs_bio_alloc(bdev, offset);
 	bio_add_page(bio, page, page_size, pg_offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
@@ -2892,7 +2893,6 @@ static int __do_readpage(struct extent_io_tree *tree,
 	u64 last_byte = i_size_read(inode);
 	u64 block_start;
 	u64 cur_end;
-	sector_t sector;
 	struct extent_map *em;
 	struct block_device *bdev;
 	int ret = 0;
@@ -2928,6 +2928,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 	}
 	while (cur <= end) {
 		bool force_bio_submit = false;
+		u64 offset;
 
 		if (cur >= last_byte) {
 			char *userpage;
@@ -2967,9 +2968,9 @@ static int __do_readpage(struct extent_io_tree *tree,
 		iosize = ALIGN(iosize, blocksize);
 		if (this_bio_flag & EXTENT_BIO_COMPRESSED) {
 			disk_io_size = em->block_len;
-			sector = em->block_start >> 9;
+			offset = em->block_start;
 		} else {
-			sector = (em->block_start + extent_offset) >> 9;
+			offset = em->block_start + extent_offset;
 			disk_io_size = iosize;
 		}
 		bdev = em->bdev;
@@ -3062,8 +3063,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 		}
 
 		ret = submit_extent_page(REQ_OP_READ | read_flags, tree, NULL,
-					 page, sector, disk_io_size, pg_offset,
-					 bdev, bio,
+					 page, offset, disk_io_size,
+					 pg_offset, bdev, bio,
 					 end_bio_extent_readpage, mirror_num,
 					 *bio_flags,
 					 this_bio_flag,
@@ -3324,7 +3325,6 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	u64 extent_offset;
 	u64 block_start;
 	u64 iosize;
-	sector_t sector;
 	struct extent_map *em;
 	struct block_device *bdev;
 	size_t pg_offset = 0;
@@ -3367,6 +3367,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 
 	while (cur <= end) {
 		u64 em_end;
+		u64 offset;
 
 		if (cur >= i_size) {
 			if (tree->ops && tree->ops->writepage_end_io_hook)
@@ -3388,7 +3389,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		BUG_ON(end < cur);
 		iosize = min(em_end - cur, end - cur + 1);
 		iosize = ALIGN(iosize, blocksize);
-		sector = (em->block_start + extent_offset) >> 9;
+		offset = em->block_start + extent_offset;
 		bdev = em->bdev;
 		block_start = em->block_start;
 		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
@@ -3431,7 +3432,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		}
 
 		ret = submit_extent_page(REQ_OP_WRITE | write_flags, tree, wbc,
-					 page, sector, iosize, pg_offset,
+					 page, offset, iosize, pg_offset,
 					 bdev, &epd->bio,
 					 end_bio_extent_writepage,
 					 0, 0, 0, false);
@@ -3748,7 +3749,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
 		ret = submit_extent_page(REQ_OP_WRITE | write_flags, tree, wbc,
-					 p, offset >> 9, PAGE_SIZE, 0, bdev,
+					 p, offset, PAGE_SIZE, 0, bdev,
 					 &epd->bio,
 					 end_bio_extent_buffer_writepage,
 					 0, epd->bio_flags, bio_flags, false);
-- 
2.14.0

