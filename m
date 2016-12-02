Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45087 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752143AbcLBFHu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:50 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F507AAD0
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:49 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 07/18] btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere
Date: Fri,  2 Dec 2016 00:07:27 -0500
Message-Id: <1480655258-15400-8-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/disk-io.c         |  4 +--
 fs/btrfs/extent-tree.c     |  2 +-
 fs/btrfs/scrub.c           | 86 +++++++++++++++++++++++-----------------------
 fs/btrfs/volumes.c         | 41 +++++++++++-----------
 fs/btrfs/volumes.h         |  3 +-
 6 files changed, 68 insertions(+), 70 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 270da67..91f6bd9 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -832,7 +832,7 @@ static int btrfsic_process_superblock_dev_mirror(
 		superblock_tmp->never_written = 0;
 		superblock_tmp->mirror_num = 1 + superblock_mirror_num;
 		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
-			btrfs_info_in_rcu(device->dev_root->fs_info,
+			btrfs_info_in_rcu(device->fs_info,
 				"new initial S-block (bdev %p, %s) @%llu (%s/%llu/%d)",
 				     superblock_bdev,
 				     rcu_str_deref(device->name), dev_bytenr,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1db5f03..8384831 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3308,7 +3308,7 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 		struct btrfs_device *device = (struct btrfs_device *)
 			bh->b_private;
 
-		btrfs_warn_rl_in_rcu(device->dev_root->fs_info,
+		btrfs_warn_rl_in_rcu(device->fs_info,
 				"lost page write due to IO error on %s",
 					  rcu_str_deref(device->name));
 		/* note, we don't set_buffer_write_io_error because we have
@@ -3453,7 +3453,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			bh = __getblk(device->bdev, bytenr / 4096,
 				      BTRFS_SUPER_INFO_SIZE);
 			if (!bh) {
-				btrfs_err(device->dev_root->fs_info,
+				btrfs_err(device->fs_info,
 				    "couldn't get super buffer head for bytenr %llu",
 				    bytenr);
 				errors++;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e8b8e30..9e83423 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10853,7 +10853,7 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 	ret = 0;
 
 	while (1) {
-		struct btrfs_fs_info *fs_info = device->dev_root->fs_info;
+		struct btrfs_fs_info *fs_info = device->fs_info;
 		struct btrfs_transaction *trans;
 		u64 bytes;
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 589d792..ed70246 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -171,7 +171,7 @@ struct scrub_wr_ctx {
 
 struct scrub_ctx {
 	struct scrub_bio	*bios[SCRUB_BIOS_PER_SCTX];
-	struct btrfs_root	*dev_root;
+	struct btrfs_fs_info	*fs_info;
 	int			first_free;
 	int			curr;
 	atomic_t		bios_in_flight;
@@ -356,7 +356,7 @@ static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
  */
 static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx)
 {
-	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
 
 	atomic_inc(&sctx->refs);
 	/*
@@ -388,7 +388,7 @@ static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx)
 /* used for workers that require transaction commits */
 static void scrub_pending_trans_workers_dec(struct scrub_ctx *sctx)
 {
-	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
 
 	/*
 	 * see scrub_pending_trans_workers_inc() why we're pretending
@@ -458,7 +458,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 {
 	struct scrub_ctx *sctx;
 	int		i;
-	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = dev->fs_info;
 	int ret;
 
 	sctx = kzalloc(sizeof(*sctx), GFP_KERNEL);
@@ -468,7 +468,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	sctx->is_dev_replace = is_dev_replace;
 	sctx->pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx->curr = -1;
-	sctx->dev_root = dev->dev_root;
+	sctx->fs_info = dev->fs_info;
 	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
 
@@ -489,8 +489,8 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 			sctx->bios[i]->next_free = -1;
 	}
 	sctx->first_free = 0;
-	sctx->nodesize = dev->dev_root->nodesize;
-	sctx->sectorsize = dev->dev_root->sectorsize;
+	sctx->nodesize = dev->fs_info->dev_root->nodesize;
+	sctx->sectorsize = dev->fs_info->dev_root->sectorsize;
 	atomic_set(&sctx->bios_in_flight, 0);
 	atomic_set(&sctx->workers_pending, 0);
 	atomic_set(&sctx->cancel_req, 0);
@@ -524,7 +524,7 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 	struct extent_buffer *eb;
 	struct btrfs_inode_item *inode_item;
 	struct scrub_warning *swarn = warn_ctx;
-	struct btrfs_fs_info *fs_info = swarn->dev->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = swarn->dev->fs_info;
 	struct inode_fs_paths *ipath = NULL;
 	struct btrfs_root *local_root;
 	struct btrfs_key root_key;
@@ -618,7 +618,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 
 	WARN_ON(sblock->page_count < 1);
 	dev = sblock->pagev[0]->dev;
-	fs_info = sblock->sctx->dev_root->fs_info;
+	fs_info = sblock->sctx->fs_info;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -843,10 +843,9 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 		spin_lock(&sctx->stat_lock);
 		++sctx->stat.uncorrectable_errors;
 		spin_unlock(&sctx->stat_lock);
-		btrfs_dev_replace_stats_inc(
-			&sctx->dev_root->fs_info->dev_replace.
-			num_uncorrectable_read_errors);
-		btrfs_err_rl_in_rcu(sctx->dev_root->fs_info,
+		btrfs_dev_replace_stats_inc(&sctx->fs_info->dev_replace.
+						num_uncorrectable_read_errors);
+		btrfs_err_rl_in_rcu(sctx->fs_info,
 		    "unable to fixup (nodatasum) error at logical %llu on dev %s",
 			fixup->logical, rcu_str_deref(fixup->dev->name));
 	}
@@ -898,7 +897,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 				      DEFAULT_RATELIMIT_BURST);
 
 	BUG_ON(sblock_to_check->page_count < 1);
-	fs_info = sctx->dev_root->fs_info;
+	fs_info = sctx->fs_info;
 	if (sblock_to_check->pagev[0]->flags & BTRFS_EXTENT_FLAG_SUPER) {
 		/*
 		 * if we find an error in a super block, we just report it.
@@ -1177,8 +1176,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 			if (scrub_write_page_to_dev_replace(sblock_other,
 							    page_num) != 0) {
 				btrfs_dev_replace_stats_inc(
-					&sctx->dev_root->
-					fs_info->dev_replace.
+					&sctx->fs_info->dev_replace.
 					num_write_errors);
 				success = 0;
 			}
@@ -1302,7 +1300,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 				     struct scrub_block *sblocks_for_recheck)
 {
 	struct scrub_ctx *sctx = original_sblock->sctx;
-	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	u64 length = original_sblock->page_count * PAGE_SIZE;
 	u64 logical = original_sblock->pagev[0]->logical;
 	u64 generation = original_sblock->pagev[0]->generation;
@@ -1574,7 +1572,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		int ret;
 
 		if (!page_bad->dev->bdev) {
-			btrfs_warn_rl(sblock_bad->sctx->dev_root->fs_info,
+			btrfs_warn_rl(sblock_bad->sctx->fs_info,
 				"scrub_repair_page_from_good_copy(bdev == NULL) is unexpected");
 			return -EIO;
 		}
@@ -1596,7 +1594,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 			btrfs_dev_stat_inc_and_print(page_bad->dev,
 				BTRFS_DEV_STAT_WRITE_ERRS);
 			btrfs_dev_replace_stats_inc(
-				&sblock_bad->sctx->dev_root->fs_info->
+				&sblock_bad->sctx->fs_info->
 				dev_replace.num_write_errors);
 			bio_put(bio);
 			return -EIO;
@@ -1624,7 +1622,7 @@ static void scrub_write_block_to_dev_replace(struct scrub_block *sblock)
 		ret = scrub_write_page_to_dev_replace(sblock, page_num);
 		if (ret)
 			btrfs_dev_replace_stats_inc(
-				&sblock->sctx->dev_root->fs_info->dev_replace.
+				&sblock->sctx->fs_info->dev_replace.
 				num_write_errors);
 	}
 }
@@ -1740,7 +1738,7 @@ static void scrub_wr_submit(struct scrub_ctx *sctx)
 static void scrub_wr_bio_end_io(struct bio *bio)
 {
 	struct scrub_bio *sbio = bio->bi_private;
-	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sbio->dev->fs_info;
 
 	sbio->err = bio->bi_error;
 	sbio->bio = bio;
@@ -1759,7 +1757,7 @@ static void scrub_wr_bio_end_io_worker(struct btrfs_work *work)
 	WARN_ON(sbio->page_count > SCRUB_PAGES_PER_WR_BIO);
 	if (sbio->err) {
 		struct btrfs_dev_replace *dev_replace =
-			&sbio->sctx->dev_root->fs_info->dev_replace;
+			&sbio->sctx->fs_info->dev_replace;
 
 		for (i = 0; i < sbio->page_count; i++) {
 			struct scrub_page *spage = sbio->pagev[i];
@@ -1859,7 +1857,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 {
 	struct scrub_ctx *sctx = sblock->sctx;
 	struct btrfs_header *h;
-	struct btrfs_root *root = sctx->dev_root;
+	struct btrfs_root *root = sctx->fs_info->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
 	u8 on_disk_csum[BTRFS_CSUM_SIZE];
@@ -2126,7 +2124,7 @@ static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
 static void scrub_missing_raid56_end_io(struct bio *bio)
 {
 	struct scrub_block *sblock = bio->bi_private;
-	struct btrfs_fs_info *fs_info = sblock->sctx->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sblock->sctx->fs_info;
 
 	if (bio->bi_error)
 		sblock->no_io_error_seen = 0;
@@ -2153,14 +2151,14 @@ static void scrub_missing_raid56_worker(struct btrfs_work *work)
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.read_errors++;
 		spin_unlock(&sctx->stat_lock);
-		btrfs_err_rl_in_rcu(sctx->dev_root->fs_info,
+		btrfs_err_rl_in_rcu(sctx->fs_info,
 			"IO error rebuilding logical %llu for dev %s",
 			logical, rcu_str_deref(dev->name));
 	} else if (sblock->header_error || sblock->checksum_error) {
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.uncorrectable_errors++;
 		spin_unlock(&sctx->stat_lock);
-		btrfs_err_rl_in_rcu(sctx->dev_root->fs_info,
+		btrfs_err_rl_in_rcu(sctx->fs_info,
 			"failed to rebuild valid logical %llu for dev %s",
 			logical, rcu_str_deref(dev->name));
 	} else {
@@ -2182,7 +2180,8 @@ static void scrub_missing_raid56_worker(struct btrfs_work *work)
 static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 {
 	struct scrub_ctx *sctx = sblock->sctx;
-	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
+	struct btrfs_root *dev_root = fs_info->dev_root;
 	u64 length = sblock->page_count * PAGE_SIZE;
 	u64 logical = sblock->pagev[0]->logical;
 	struct btrfs_bio *bbio = NULL;
@@ -2215,7 +2214,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	bio->bi_private = sblock;
 	bio->bi_end_io = scrub_missing_raid56_end_io;
 
-	rbio = raid56_alloc_missing_rbio(sctx->dev_root, bio, bbio, length);
+	rbio = raid56_alloc_missing_rbio(dev_root, bio, bbio, length);
 	if (!rbio)
 		goto rbio_out;
 
@@ -2334,7 +2333,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 static void scrub_bio_end_io(struct bio *bio)
 {
 	struct scrub_bio *sbio = bio->bi_private;
-	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sbio->dev->fs_info;
 
 	sbio->err = bio->bi_error;
 	sbio->bio = bio;
@@ -2391,7 +2390,7 @@ static inline void __scrub_mark_bitmap(struct scrub_parity *sparity,
 {
 	u32 offset;
 	int nsectors;
-	int sectorsize = sparity->sctx->dev_root->sectorsize;
+	int sectorsize = sparity->sctx->fs_info->dev_root->sectorsize;
 
 	if (len >= sparity->stripe_len) {
 		bitmap_set(bitmap, 0, sparity->nsectors);
@@ -2759,13 +2758,14 @@ static void scrub_parity_bio_endio(struct bio *bio)
 
 	btrfs_init_work(&sparity->work, btrfs_scrubparity_helper,
 			scrub_parity_bio_endio_worker, NULL, NULL);
-	btrfs_queue_work(sparity->sctx->dev_root->fs_info->scrub_parity_workers,
+	btrfs_queue_work(sparity->sctx->fs_info->scrub_parity_workers,
 			 &sparity->work);
 }
 
 static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 {
 	struct scrub_ctx *sctx = sparity->sctx;
+	struct btrfs_root *dev_root = sctx->fs_info->dev_root;
 	struct bio *bio;
 	struct btrfs_raid_bio *rbio;
 	struct scrub_page *spage;
@@ -2778,7 +2778,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 		goto out;
 
 	length = sparity->logic_end - sparity->logic_start;
-	ret = btrfs_map_sblock(sctx->dev_root->fs_info, BTRFS_MAP_WRITE,
+	ret = btrfs_map_sblock(sctx->fs_info, BTRFS_MAP_WRITE,
 			       sparity->logic_start,
 			       &length, &bbio, 0, 1);
 	if (ret || !bbio || !bbio->raid_map)
@@ -2792,7 +2792,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 	bio->bi_private = sparity;
 	bio->bi_end_io = scrub_parity_bio_endio;
 
-	rbio = raid56_parity_alloc_scrub_rbio(sctx->dev_root, bio, bbio,
+	rbio = raid56_parity_alloc_scrub_rbio(dev_root, bio, bbio,
 					      length, sparity->scrub_dev,
 					      sparity->dbitmap,
 					      sparity->nsectors);
@@ -2844,7 +2844,7 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 						  u64 logic_start,
 						  u64 logic_end)
 {
-	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_root *csum_root = fs_info->csum_root;
 	struct btrfs_extent_item *extent;
@@ -3069,7 +3069,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					   int is_dev_replace)
 {
 	struct btrfs_path *path, *ppath;
-	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_root *csum_root = fs_info->csum_root;
 	struct btrfs_extent_item *extent;
@@ -3443,8 +3443,8 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 					  struct btrfs_block_group_cache *cache,
 					  int is_dev_replace)
 {
-	struct btrfs_mapping_tree *map_tree =
-		&sctx->dev_root->fs_info->mapping_tree;
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct map_lookup *map;
 	struct extent_map *em;
 	int i;
@@ -3497,7 +3497,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 {
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
-	struct btrfs_root *root = sctx->dev_root;
+	struct btrfs_root *root = sctx->fs_info->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 length;
 	u64 chunk_offset;
@@ -3747,7 +3747,7 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 	u64	bytenr;
 	u64	gen;
 	int	ret;
-	struct btrfs_root *root = sctx->dev_root;
+	struct btrfs_root *root = sctx->fs_info->dev_root;
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
 		return -EIO;
@@ -4123,7 +4123,7 @@ static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			    int mirror_num, u64 physical_for_dev_replace)
 {
 	struct scrub_copy_nocow_ctx *nocow_ctx;
-	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sctx->fs_info;
 
 	nocow_ctx = kzalloc(sizeof(*nocow_ctx), GFP_NOFS);
 	if (!nocow_ctx) {
@@ -4182,7 +4182,7 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 	struct btrfs_root *root;
 	int not_written = 0;
 
-	fs_info = sctx->dev_root->fs_info;
+	fs_info = sctx->fs_info;
 	root = fs_info->extent_root;
 
 	path = btrfs_alloc_path();
@@ -4297,7 +4297,7 @@ static int check_extent_to_block(struct inode *inode, u64 start, u64 len,
 static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 				      struct scrub_copy_nocow_ctx *nocow_ctx)
 {
-	struct btrfs_fs_info *fs_info = nocow_ctx->sctx->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = nocow_ctx->sctx->fs_info;
 	struct btrfs_key key;
 	struct inode *inode;
 	struct page *page;
@@ -4427,7 +4427,7 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	if (!dev)
 		return -EIO;
 	if (!dev->bdev) {
-		btrfs_warn_rl(dev->dev_root->fs_info,
+		btrfs_warn_rl(dev->fs_info,
 			"scrub write_page_nocow(bdev == NULL) is unexpected");
 		return -EIO;
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f336f07..a05e24a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -367,7 +367,7 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 	blk_start_plug(&plug);
 
 	bdi = blk_get_backing_dev_info(device->bdev);
-	fs_info = device->dev_root->fs_info;
+	fs_info = device->fs_info;
 	limit = btrfs_async_submit_limit(fs_info);
 	limit = limit * 2 / 3;
 
@@ -1179,7 +1179,7 @@ int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length)
 {
 	struct btrfs_key key;
-	struct btrfs_root *root = device->dev_root;
+	struct btrfs_root *root = device->fs_info->dev_root;
 	struct btrfs_dev_extent *dev_extent;
 	struct btrfs_path *path;
 	u64 extent_end;
@@ -1262,7 +1262,7 @@ static int contains_pending_extent(struct btrfs_transaction *transaction,
 				   struct btrfs_device *device,
 				   u64 *start, u64 len)
 {
-	struct btrfs_fs_info *fs_info = device->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct extent_map *em;
 	struct list_head *search_list = &fs_info->pinned_chunks;
 	int ret = 0;
@@ -1338,8 +1338,8 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
 			       struct btrfs_device *device, u64 num_bytes,
 			       u64 search_start, u64 *start, u64 *len)
 {
+	struct btrfs_root *root = device->fs_info->dev_root;
 	struct btrfs_key key;
-	struct btrfs_root *root = device->dev_root;
 	struct btrfs_dev_extent *dev_extent;
 	struct btrfs_path *path;
 	u64 hole_size;
@@ -1508,9 +1508,9 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 			  struct btrfs_device *device,
 			  u64 start, u64 *dev_extent_len)
 {
+	struct btrfs_root *root = device->fs_info->dev_root;
 	int ret;
 	struct btrfs_path *path;
-	struct btrfs_root *root = device->dev_root;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct extent_buffer *leaf = NULL;
@@ -1569,7 +1569,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	struct btrfs_path *path;
-	struct btrfs_root *root = device->dev_root;
+	struct btrfs_root *root = device->fs_info->dev_root;
 	struct btrfs_dev_extent *extent;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
@@ -2387,7 +2387,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 	device->total_bytes = i_size_read(bdev->bd_inode);
 	device->disk_total_bytes = device->total_bytes;
 	device->commit_total_bytes = device->total_bytes;
-	device->dev_root = root->fs_info->dev_root;
+	device->fs_info = fs_info;
 	device->bdev = bdev;
 	device->in_fs_metadata = 1;
 	device->is_tgtdev_for_dev_replace = 0;
@@ -2596,7 +2596,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 	ASSERT(list_empty(&srcdev->resized_list));
 	device->commit_total_bytes = srcdev->commit_total_bytes;
 	device->commit_bytes_used = device->bytes_used;
-	device->dev_root = fs_info->dev_root;
+	device->fs_info = fs_info;
 	device->bdev = bdev;
 	device->in_fs_metadata = 1;
 	device->is_tgtdev_for_dev_replace = 1;
@@ -2624,7 +2624,7 @@ void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
 	tgtdev->io_width = fs_info->dev_root->sectorsize;
 	tgtdev->io_align = fs_info->dev_root->sectorsize;
 	tgtdev->sector_size = fs_info->dev_root->sectorsize;
-	tgtdev->dev_root = fs_info->dev_root;
+	tgtdev->fs_info = fs_info;
 	tgtdev->in_fs_metadata = 1;
 }
 
@@ -2638,7 +2638,7 @@ static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 
-	root = device->dev_root->fs_info->chunk_root;
+	root = device->fs_info->chunk_root;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -2679,8 +2679,7 @@ static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size)
 {
-	struct btrfs_super_block *super_copy =
-		device->dev_root->fs_info->super_copy;
+	struct btrfs_super_block *super_copy = device->fs_info->super_copy;
 	struct btrfs_fs_devices *fs_devices;
 	u64 old_total;
 	u64 diff;
@@ -2688,28 +2687,28 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	if (!device->writeable)
 		return -EACCES;
 
-	lock_chunks(device->dev_root);
+	lock_chunks(device->fs_info->dev_root);
 	old_total = btrfs_super_total_bytes(super_copy);
 	diff = new_size - device->total_bytes;
 
 	if (new_size <= device->total_bytes ||
 	    device->is_tgtdev_for_dev_replace) {
-		unlock_chunks(device->dev_root);
+		unlock_chunks(device->fs_info->dev_root);
 		return -EINVAL;
 	}
 
-	fs_devices = device->dev_root->fs_info->fs_devices;
+	fs_devices = device->fs_info->fs_devices;
 
 	btrfs_set_super_total_bytes(super_copy, old_total + diff);
 	device->fs_devices->total_rw_bytes += diff;
 
 	btrfs_device_set_total_bytes(device, new_size);
 	btrfs_device_set_disk_total_bytes(device, new_size);
-	btrfs_clear_space_info_full(device->dev_root->fs_info);
+	btrfs_clear_space_info_full(device->fs_info);
 	if (list_empty(&device->resized_list))
 		list_add_tail(&device->resized_list,
 			      &fs_devices->resized_devices);
-	unlock_chunks(device->dev_root);
+	unlock_chunks(device->fs_info->dev_root);
 
 	return btrfs_update_device(trans, device);
 }
@@ -4357,7 +4356,7 @@ int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info)
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 {
 	struct btrfs_trans_handle *trans;
-	struct btrfs_root *root = device->dev_root;
+	struct btrfs_root *root = device->fs_info->dev_root;
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
 	u64 length;
@@ -6885,7 +6884,7 @@ void btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
 	while (fs_devices) {
 		mutex_lock(&fs_devices->device_list_mutex);
 		list_for_each_entry(device, &fs_devices->devices, dev_list)
-			device->dev_root = fs_info->dev_root;
+			device->fs_info = fs_info;
 		mutex_unlock(&fs_devices->device_list_mutex);
 
 		fs_devices = fs_devices->seed;
@@ -7061,7 +7060,7 @@ static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 {
 	if (!dev->dev_stats_valid)
 		return;
-	btrfs_err_rl_in_rcu(dev->dev_root->fs_info,
+	btrfs_err_rl_in_rcu(dev->fs_info,
 		"bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
 			   rcu_str_deref(dev->name),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
@@ -7081,7 +7080,7 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
 	if (i == BTRFS_DEV_STAT_VALUES_MAX)
 		return; /* all values == 0, suppress message */
 
-	btrfs_info_in_rcu(dev->dev_root->fs_info,
+	btrfs_info_in_rcu(dev->fs_info,
 		"bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
 	       rcu_str_deref(dev->name),
 	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0c8e77b..8592217 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -51,8 +51,7 @@ struct btrfs_device {
 	struct list_head dev_list;
 	struct list_head dev_alloc_list;
 	struct btrfs_fs_devices *fs_devices;
-
-	struct btrfs_root *dev_root;
+	struct btrfs_fs_info *fs_info;
 
 	struct rcu_string *name;
 
-- 
2.7.1

