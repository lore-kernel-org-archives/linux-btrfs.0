Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:45099 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752367AbdKXEKS (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 23 Nov 2017 23:10:18 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3] btrfs: Cleanup open coded sector and bytes convert
Date: Fri, 24 Nov 2017 12:10:07 +0800
Message-Id: <20171124041008.32656-2-wqu@suse.com>
In-Reply-To: <20171124041008.32656-1-wqu@suse.com>
References: <20171124041008.32656-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/compression.c     |  7 ++++---
 fs/btrfs/extent-tree.c     | 12 ++++++------
 fs/btrfs/extent_io.c       | 20 ++++++++++----------
 fs/btrfs/file-item.c       |  6 +++---
 fs/btrfs/inode.c           | 16 ++++++++--------
 fs/btrfs/raid56.c          |  8 ++++----
 fs/btrfs/scrub.c           | 18 +++++++++---------
 fs/btrfs/volumes.c         |  6 +++---
 9 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 7d5a9b51f0d7..ade257389edc 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1636,7 +1636,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 
 		bio = btrfs_io_bio_alloc(num_pages - i);
 		bio_set_dev(bio, block_ctx->dev->bdev);
-		bio->bi_iter.bi_sector = dev_bytenr >> 9;
+		bio->bi_iter.bi_sector = to_sector(dev_bytenr);
 		bio_set_op_attrs(bio, REQ_OP_READ, 0);
 
 		for (j = i; j < num_pages; j++) {
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 280384bf34f1..3a4e0376fc3c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -136,7 +136,7 @@ static void end_compressed_bio_read(struct bio *bio)
 
 	inode = cb->inode;
 	ret = check_compressed_csum(BTRFS_I(inode), cb,
-				    (u64)bio->bi_iter.bi_sector << 9);
+				    to_bytes(bio->bi_iter.bi_sector));
 	if (ret)
 		goto csum_failed;
 
@@ -480,7 +480,8 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 
 		if (!em || last_offset < em->start ||
 		    (last_offset + PAGE_SIZE > extent_map_end(em)) ||
-		    (em->block_start >> 9) != cb->orig_bio->bi_iter.bi_sector) {
+		    (to_sector(em->block_start)) !=
+				cb->orig_bio->bi_iter.bi_sector) {
 			free_extent_map(em);
 			unlock_extent(tree, last_offset, end);
 			unlock_page(page);
@@ -545,7 +546,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	struct page *page;
 	struct block_device *bdev;
 	struct bio *comp_bio;
-	u64 cur_disk_byte = (u64)bio->bi_iter.bi_sector << 9;
+	u64 cur_disk_byte = to_bytes(bio->bi_iter.bi_sector);
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2d7e86b51d1..84868f29a666 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2064,11 +2064,11 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 {
 	int j, ret = 0;
 	u64 bytes_left, end;
-	u64 aligned_start = ALIGN(start, 1 << 9);
+	u64 aligned_start = ALIGN(start, BI_SECTOR_SIZE);
 
 	if (WARN_ON(start != aligned_start)) {
 		len -= aligned_start - start;
-		len = round_down(len, 1 << 9);
+		len = round_down(len, BI_SECTOR_SIZE);
 		start = aligned_start;
 	}
 
@@ -2106,8 +2106,8 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 		}
 
 		if (size) {
-			ret = blkdev_issue_discard(bdev, start >> 9, size >> 9,
-						   GFP_NOFS, 0);
+			ret = blkdev_issue_discard(bdev, to_sector(start),
+						to_sector(size), GFP_NOFS, 0);
 			if (!ret)
 				*discarded_bytes += size;
 			else if (ret != -EOPNOTSUPP)
@@ -2123,8 +2123,8 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 	}
 
 	if (bytes_left) {
-		ret = blkdev_issue_discard(bdev, start >> 9, bytes_left >> 9,
-					   GFP_NOFS, 0);
+		ret = blkdev_issue_discard(bdev, to_sector(start),
+					   to_sector(bytes_left), GFP_NOFS, 0);
 		if (!ret)
 			*discarded_bytes += bytes_left;
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7fa50e12f18e..5cf8be481a88 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2024,7 +2024,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 		BUG_ON(mirror_num != bbio->mirror_num);
 	}
 
-	sector = bbio->stripes[bbio->mirror_num - 1].physical >> 9;
+	sector = to_sector(bbio->stripes[bbio->mirror_num - 1].physical);
 	bio->bi_iter.bi_sector = sector;
 	dev = bbio->stripes[bbio->mirror_num - 1].dev;
 	btrfs_put_bbio(bbio);
@@ -2334,7 +2334,7 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 
 	bio = btrfs_io_bio_alloc(1);
 	bio->bi_end_io = endio_func;
-	bio->bi_iter.bi_sector = failrec->logical >> 9;
+	bio->bi_iter.bi_sector = to_sector(failrec->logical);
 	bio_set_dev(bio, fs_info->fs_devices->latest_bdev);
 	bio->bi_iter.bi_size = 0;
 	bio->bi_private = data;
@@ -2676,7 +2676,7 @@ struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_byte)
 
 	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, btrfs_bioset);
 	bio_set_dev(bio, bdev);
-	bio->bi_iter.bi_sector = first_byte >> 9;
+	bio->bi_iter.bi_sector = to_sector(first_byte);
 	btrfs_io_bio_init(btrfs_io_bio(bio));
 	return bio;
 }
@@ -2716,7 +2716,7 @@ struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size)
 	btrfs_bio = btrfs_io_bio(bio);
 	btrfs_io_bio_init(btrfs_bio);
 
-	bio_trim(bio, offset >> 9, size >> 9);
+	bio_trim(bio, to_sector(offset), to_sector(size));
 	btrfs_bio->iter = bio->bi_iter;
 	return bio;
 }
@@ -2802,7 +2802,7 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 		}
 	}
 
-	bio = btrfs_bio_alloc(bdev, (u64)sector << 9);
+	bio = btrfs_bio_alloc(bdev, to_bytes(sector));
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
@@ -2968,9 +2968,9 @@ static int __do_readpage(struct extent_io_tree *tree,
 		iosize = ALIGN(iosize, blocksize);
 		if (this_bio_flag & EXTENT_BIO_COMPRESSED) {
 			disk_io_size = em->block_len;
-			sector = em->block_start >> 9;
+			sector = to_sector(em->block_start);
 		} else {
-			sector = (em->block_start + extent_offset) >> 9;
+			sector = to_sector(em->block_start + extent_offset);
 			disk_io_size = iosize;
 		}
 		bdev = em->bdev;
@@ -3389,7 +3389,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		BUG_ON(end < cur);
 		iosize = min(em_end - cur, end - cur + 1);
 		iosize = ALIGN(iosize, blocksize);
-		sector = (em->block_start + extent_offset) >> 9;
+		sector = to_sector(em->block_start + extent_offset);
 		bdev = em->bdev;
 		block_start = em->block_start;
 		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
@@ -3749,8 +3749,8 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
 		ret = submit_extent_page(REQ_OP_WRITE | write_flags, tree, wbc,
-					 p, offset >> 9, PAGE_SIZE, 0, bdev,
-					 &epd->bio,
+					 p, to_sector(offset), PAGE_SIZE, 0,
+					 bdev, &epd->bio,
 					 end_bio_extent_buffer_writepage,
 					 0, epd->bio_flags, bio_flags, false);
 		epd->bio_flags = bio_flags;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index fdcb41002623..df17cdced256 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -218,7 +218,7 @@ static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio
 		path->skip_locking = 1;
 	}
 
-	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
+	disk_bytenr = to_bytes(bio->bi_iter.bi_sector);
 	if (dio)
 		offset = logical_offset;
 
@@ -461,7 +461,7 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 	else
 		offset = 0; /* shut up gcc */
 
-	sums->bytenr = (u64)bio->bi_iter.bi_sector << 9;
+	sums->bytenr = to_bytes(bio->bi_iter.bi_sector);
 	index = 0;
 
 	bio_for_each_segment(bvec, bio, iter) {
@@ -499,7 +499,7 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 				ordered = btrfs_lookup_ordered_extent(inode,
 								offset);
 				ASSERT(ordered); /* Logic error */
-				sums->bytenr = ((u64)bio->bi_iter.bi_sector << 9)
+				sums->bytenr = to_bytes(bio->bi_iter.bi_sector)
 					+ total_bytes;
 				index = 0;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d94e3f68b9b1..3a8eb49e2c10 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1890,7 +1890,7 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	u64 logical = (u64)bio->bi_iter.bi_sector << 9;
+	u64 logical = to_bytes(bio->bi_iter.bi_sector);
 	u64 length = 0;
 	u64 map_length;
 	int ret;
@@ -8601,8 +8601,8 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 
 	map_length = orig_bio->bi_iter.bi_size;
 	submit_len = map_length;
-	ret = btrfs_map_block(fs_info, btrfs_op(orig_bio), start_sector << 9,
-			      &map_length, NULL, 0);
+	ret = btrfs_map_block(fs_info, btrfs_op(orig_bio),
+			      to_bytes(start_sector), &map_length, NULL, 0);
 	if (ret)
 		return -EIO;
 
@@ -8656,12 +8656,12 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 		}
 
 		clone_offset += clone_len;
-		start_sector += clone_len >> 9;
+		start_sector += to_sector(clone_len);
 		file_offset += clone_len;
 
 		map_length = submit_len;
 		ret = btrfs_map_block(fs_info, btrfs_op(orig_bio),
-				      start_sector << 9, &map_length, NULL, 0);
+				to_bytes(start_sector), &map_length, NULL, 0);
 		if (ret)
 			goto out_err;
 	} while (submit_len > 0);
@@ -8707,7 +8707,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	dip->inode = inode;
 	dip->logical_offset = file_offset;
 	dip->bytes = dio_bio->bi_iter.bi_size;
-	dip->disk_bytenr = (u64)dio_bio->bi_iter.bi_sector << 9;
+	dip->disk_bytenr = to_bytes(dio_bio->bi_iter.bi_sector);
 	bio->bi_private = dip;
 	dip->orig_bio = bio;
 	dip->dio_bio = dio_bio;
@@ -9697,8 +9697,8 @@ static int btrfs_getattr(const struct path *path, struct kstat *stat,
 	spin_lock(&BTRFS_I(inode)->lock);
 	delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
-	stat->blocks = (ALIGN(inode_get_bytes(inode), blocksize) +
-			ALIGN(delalloc_bytes, blocksize)) >> 9;
+	stat->blocks = to_sector(ALIGN(inode_get_bytes(inode), blocksize) +
+				 ALIGN(delalloc_bytes, blocksize));
 	return 0;
 }
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 24a62224b24b..3dc2da63939b 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1081,7 +1081,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 
 	/* see if we can add this page onto our existing bio */
 	if (last) {
-		last_end = (u64)last->bi_iter.bi_sector << 9;
+		last_end = to_bytes(last->bi_iter.bi_sector);
 		last_end += last->bi_iter.bi_size;
 
 		/*
@@ -1102,7 +1102,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 	bio = btrfs_io_bio_alloc(bio_max_len >> PAGE_SHIFT ?: 1);
 	bio->bi_iter.bi_size = 0;
 	bio_set_dev(bio, stripe->dev->bdev);
-	bio->bi_iter.bi_sector = disk_start >> 9;
+	bio->bi_iter.bi_sector = to_sector(disk_start);
 
 	bio_add_page(bio, page, PAGE_SIZE, 0);
 	bio_list_add(bio_list, bio);
@@ -1147,7 +1147,7 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 		struct bvec_iter iter;
 		int i = 0;
 
-		start = (u64)bio->bi_iter.bi_sector << 9;
+		start = to_bytes(bio->bi_iter.bi_sector);
 		stripe_offset = start - rbio->bbio->raid_map[0];
 		page_index = stripe_offset >> PAGE_SHIFT;
 
@@ -2143,7 +2143,7 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
 	if (rbio->faila == -1) {
 		btrfs_warn(fs_info,
 	"%s could not find the bad stripe in raid56 so that we cannot recover any more (bio has logical %llu len %llu, bbio has map_type %llu)",
-			   __func__, (u64)bio->bi_iter.bi_sector << 9,
+			   __func__, to_bytes(bio->bi_iter.bi_sector),
 			   (u64)bio->bi_iter.bi_size, bbio->map_type);
 		if (generic_io)
 			btrfs_put_bbio(bbio);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e3f6c49e5c4d..bcf031ebe303 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -845,7 +845,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	if (!path)
 		return;
 
-	swarn.sector = (sblock->pagev[0]->physical) >> 9;
+	swarn.sector = to_sector(sblock->pagev[0]->physical);
 	swarn.logical = sblock->pagev[0]->logical;
 	swarn.errstr = errstr;
 	swarn.dev = NULL;
@@ -1694,7 +1694,7 @@ static int scrub_submit_raid56_bio_wait(struct btrfs_fs_info *fs_info,
 
 	init_completion(&done.event);
 	done.status = 0;
-	bio->bi_iter.bi_sector = page->logical >> 9;
+	bio->bi_iter.bi_sector = to_sector(page->logical);
 	bio->bi_private = &done;
 	bio->bi_end_io = scrub_bio_wait_endio;
 
@@ -1747,7 +1747,7 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 				sblock->no_io_error_seen = 0;
 			}
 		} else {
-			bio->bi_iter.bi_sector = page->physical >> 9;
+			bio->bi_iter.bi_sector = to_sector(page->physical);
 			bio_set_op_attrs(bio, REQ_OP_READ, 0);
 
 			if (btrfsic_submit_bio_wait(bio)) {
@@ -1827,7 +1827,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 
 		bio = btrfs_io_bio_alloc(1);
 		bio_set_dev(bio, page_bad->dev->bdev);
-		bio->bi_iter.bi_sector = page_bad->physical >> 9;
+		bio->bi_iter.bi_sector = to_sector(page_bad->physical);
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 		ret = bio_add_page(bio, page_good->page, PAGE_SIZE, 0);
@@ -1922,7 +1922,7 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 		bio->bi_private = sbio;
 		bio->bi_end_io = scrub_wr_bio_end_io;
 		bio_set_dev(bio, sbio->dev->bdev);
-		bio->bi_iter.bi_sector = sbio->physical >> 9;
+		bio->bi_iter.bi_sector = to_sector(sbio->physical);
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 		sbio->status = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
@@ -2322,7 +2322,7 @@ static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
 		bio->bi_private = sbio;
 		bio->bi_end_io = scrub_bio_end_io;
 		bio_set_dev(bio, sbio->dev->bdev);
-		bio->bi_iter.bi_sector = sbio->physical >> 9;
+		bio->bi_iter.bi_sector = to_sector(sbio->physical);
 		bio_set_op_attrs(bio, REQ_OP_READ, 0);
 		sbio->status = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
@@ -2441,7 +2441,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	}
 
 	bio = btrfs_io_bio_alloc(0);
-	bio->bi_iter.bi_sector = logical >> 9;
+	bio->bi_iter.bi_sector = to_sector(logical);
 	bio->bi_private = sblock;
 	bio->bi_end_io = scrub_missing_raid56_end_io;
 
@@ -3022,7 +3022,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 		goto bbio_out;
 
 	bio = btrfs_io_bio_alloc(0);
-	bio->bi_iter.bi_sector = sparity->logic_start >> 9;
+	bio->bi_iter.bi_sector = to_sector(sparity->logic_start);
 	bio->bi_private = sparity;
 	bio->bi_end_io = scrub_parity_bio_endio;
 
@@ -4623,7 +4623,7 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	}
 	bio = btrfs_io_bio_alloc(1);
 	bio->bi_iter.bi_size = 0;
-	bio->bi_iter.bi_sector = physical_for_dev_replace >> 9;
+	bio->bi_iter.bi_sector = to_sector(physical_for_dev_replace);
 	bio_set_dev(bio, dev->bdev);
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
 	ret = bio_add_page(bio, page, PAGE_SIZE, 0);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b39737568c22..b8eab8598ac1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6109,7 +6109,7 @@ static void submit_stripe_bio(struct btrfs_bio *bbio, struct bio *bio,
 	bio->bi_private = bbio;
 	btrfs_io_bio(bio)->stripe_index = dev_nr;
 	bio->bi_end_io = btrfs_end_bio;
-	bio->bi_iter.bi_sector = physical >> 9;
+	bio->bi_iter.bi_sector = to_sector(physical);
 #ifdef DEBUG
 	{
 		struct rcu_string *name;
@@ -6143,7 +6143,7 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 		WARN_ON(bio != bbio->orig_bio);
 
 		btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;
-		bio->bi_iter.bi_sector = logical >> 9;
+		bio->bi_iter.bi_sector = to_sector(logical);
 		bio->bi_status = BLK_STS_IOERR;
 		btrfs_end_bbio(bbio, bio);
 	}
@@ -6154,7 +6154,7 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 {
 	struct btrfs_device *dev;
 	struct bio *first_bio = bio;
-	u64 logical = (u64)bio->bi_iter.bi_sector << 9;
+	u64 logical = to_bytes(bio->bi_iter.bi_sector);
 	u64 length = 0;
 	u64 map_length;
 	int ret;
-- 
2.15.0

