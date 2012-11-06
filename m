Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:14233 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp2) (RZmta 31.1 OK) with ESMTP id g01bccoA6DKvk3
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/26] Btrfs: remove the block device pointer from the scrub context struct
Date: Tue,  6 Nov 2012 17:38:20 +0100
Message-Id: <6a89c4ce95ebf55b119c9e7560b3e64d03a78305.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

The block device is removed from the scrub context state structure.
The scrub code as it is used for the device replace procedure reads
the source data from whereever it is optimal. The source device might
even be gone (disconnected, for instance due to a hardware failure).
Or the drive can be so faulty so that the device replace procedure
tries to avoid access to the faulty source drive as much as possible,
and only if all other mirrors are damaged, as a last resort, the
source disk is accessed.
The modified scrub code operates as if it would handle the source
drive and thereby generates an exact copy of the source disk on the
target disk, even if the source disk is not present at all. Therefore
the block device pointer to the source disk is removed in the scrub
context struct and moved into the lower level scope of scrub_bio,
fixup and page structures where the block device context is known.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c | 133 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 73 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 29c8aac..822c08a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -67,6 +67,7 @@ struct scrub_page {
 struct scrub_bio {
 	int			index;
 	struct scrub_ctx	*sctx;
+	struct btrfs_device	*dev;
 	struct bio		*bio;
 	int			err;
 	u64			logical;
@@ -93,7 +94,7 @@ struct scrub_block {
 
 struct scrub_ctx {
 	struct scrub_bio	*bios[SCRUB_BIOS_PER_CTX];
-	struct btrfs_device	*dev;
+	struct btrfs_root	*dev_root;
 	int			first_free;
 	int			curr;
 	atomic_t		in_flight;
@@ -117,6 +118,7 @@ struct scrub_ctx {
 
 struct scrub_fixup_nodatasum {
 	struct scrub_ctx	*sctx;
+	struct btrfs_device	*dev;
 	u64			logical;
 	struct btrfs_root	*root;
 	struct btrfs_work	work;
@@ -166,8 +168,8 @@ static void scrub_block_put(struct scrub_block *sblock);
 static int scrub_add_page_to_bio(struct scrub_ctx *sctx,
 				 struct scrub_page *spage);
 static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
-		       u64 physical, u64 flags, u64 gen, int mirror_num,
-		       u8 *csum, int force);
+		       u64 physical, struct btrfs_device *dev, u64 flags,
+		       u64 gen, int mirror_num, u8 *csum, int force);
 static void scrub_bio_end_io(struct bio *bio, int err);
 static void scrub_bio_end_io_worker(struct btrfs_work *work);
 static void scrub_block_complete(struct scrub_block *sblock);
@@ -228,9 +230,9 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev)
 	sctx = kzalloc(sizeof(*sctx), GFP_NOFS);
 	if (!sctx)
 		goto nomem;
-	sctx->dev = dev;
 	sctx->pages_per_bio = pages_per_bio;
 	sctx->curr = -1;
+	sctx->dev_root = dev->dev_root;
 	for (i = 0; i < SCRUB_BIOS_PER_CTX; ++i) {
 		struct scrub_bio *sbio;
 
@@ -345,8 +347,8 @@ err:
 
 static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 {
-	struct btrfs_device *dev = sblock->sctx->dev;
-	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
+	struct btrfs_device *dev;
+	struct btrfs_fs_info *fs_info;
 	struct btrfs_path *path;
 	struct btrfs_key found_key;
 	struct extent_buffer *eb;
@@ -361,15 +363,18 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	const int bufsize = 4096;
 	int ret;
 
+	WARN_ON(sblock->page_count < 1);
+	dev = sblock->pagev[0].dev;
+	fs_info = sblock->sctx->dev_root->fs_info;
+
 	path = btrfs_alloc_path();
 
 	swarn.scratch_buf = kmalloc(bufsize, GFP_NOFS);
 	swarn.msg_buf = kmalloc(bufsize, GFP_NOFS);
-	BUG_ON(sblock->page_count < 1);
 	swarn.sector = (sblock->pagev[0].physical) >> 9;
 	swarn.logical = sblock->pagev[0].logical;
 	swarn.errstr = errstr;
-	swarn.dev = dev;
+	swarn.dev = NULL;
 	swarn.msg_bufsize = bufsize;
 	swarn.scratch_bufsize = bufsize;
 
@@ -405,6 +410,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 		} while (ret != 1);
 	} else {
 		swarn.path = path;
+		swarn.dev = dev;
 		iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, 1,
 					scrub_print_warning_inode, &swarn);
@@ -588,7 +594,7 @@ out:
 		printk_ratelimited_in_rcu(KERN_ERR
 			"btrfs: unable to fixup (nodatasum) error at logical %llu on dev %s\n",
 			(unsigned long long)fixup->logical,
-			rcu_str_deref(sctx->dev->name));
+			rcu_str_deref(fixup->dev->name));
 	}
 
 	btrfs_free_path(path);
@@ -615,6 +621,7 @@ out:
 static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 {
 	struct scrub_ctx *sctx = sblock_to_check->sctx;
+	struct btrfs_device *dev;
 	struct btrfs_fs_info *fs_info;
 	u64 length;
 	u64 logical;
@@ -633,7 +640,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 				      DEFAULT_RATELIMIT_BURST);
 
 	BUG_ON(sblock_to_check->page_count < 1);
-	fs_info = sctx->dev->dev_root->fs_info;
+	fs_info = sctx->dev_root->fs_info;
 	length = sblock_to_check->page_count * PAGE_SIZE;
 	logical = sblock_to_check->pagev[0].logical;
 	generation = sblock_to_check->pagev[0].generation;
@@ -643,6 +650,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 			BTRFS_EXTENT_FLAG_DATA);
 	have_csum = sblock_to_check->pagev[0].have_csum;
 	csum = sblock_to_check->pagev[0].csum;
+	dev = sblock_to_check->pagev[0].dev;
 
 	/*
 	 * read all mirrors one after the other. This includes to
@@ -682,8 +690,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sctx->stat.read_errors++;
 		sctx->stat.uncorrectable_errors++;
 		spin_unlock(&sctx->stat_lock);
-		btrfs_dev_stat_inc_and_print(sctx->dev,
-					     BTRFS_DEV_STAT_READ_ERRS);
+		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_READ_ERRS);
 		goto out;
 	}
 
@@ -695,8 +702,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sctx->stat.read_errors++;
 		sctx->stat.uncorrectable_errors++;
 		spin_unlock(&sctx->stat_lock);
-		btrfs_dev_stat_inc_and_print(sctx->dev,
-					     BTRFS_DEV_STAT_READ_ERRS);
+		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_READ_ERRS);
 		goto out;
 	}
 	BUG_ON(failed_mirror_index >= BTRFS_MAX_MIRRORS);
@@ -710,8 +716,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sctx->stat.read_errors++;
 		sctx->stat.uncorrectable_errors++;
 		spin_unlock(&sctx->stat_lock);
-		btrfs_dev_stat_inc_and_print(sctx->dev,
-					     BTRFS_DEV_STAT_READ_ERRS);
+		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_READ_ERRS);
 		goto out;
 	}
 
@@ -738,15 +743,14 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		spin_unlock(&sctx->stat_lock);
 		if (__ratelimit(&_rs))
 			scrub_print_warning("i/o error", sblock_to_check);
-		btrfs_dev_stat_inc_and_print(sctx->dev,
-					     BTRFS_DEV_STAT_READ_ERRS);
+		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_READ_ERRS);
 	} else if (sblock_bad->checksum_error) {
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.csum_errors++;
 		spin_unlock(&sctx->stat_lock);
 		if (__ratelimit(&_rs))
 			scrub_print_warning("checksum error", sblock_to_check);
-		btrfs_dev_stat_inc_and_print(sctx->dev,
+		btrfs_dev_stat_inc_and_print(dev,
 					     BTRFS_DEV_STAT_CORRUPTION_ERRS);
 	} else if (sblock_bad->header_error) {
 		spin_lock(&sctx->stat_lock);
@@ -756,10 +760,10 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 			scrub_print_warning("checksum/header error",
 					    sblock_to_check);
 		if (sblock_bad->generation_error)
-			btrfs_dev_stat_inc_and_print(sctx->dev,
+			btrfs_dev_stat_inc_and_print(dev,
 				BTRFS_DEV_STAT_GENERATION_ERRS);
 		else
-			btrfs_dev_stat_inc_and_print(sctx->dev,
+			btrfs_dev_stat_inc_and_print(dev,
 				BTRFS_DEV_STAT_CORRUPTION_ERRS);
 	}
 
@@ -780,6 +784,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		if (!fixup_nodatasum)
 			goto did_not_correct_error;
 		fixup_nodatasum->sctx = sctx;
+		fixup_nodatasum->dev = dev;
 		fixup_nodatasum->logical = logical;
 		fixup_nodatasum->root = fs_info->extent_root;
 		fixup_nodatasum->mirror_num = failed_mirror_index + 1;
@@ -945,7 +950,7 @@ corrected_error:
 			printk_ratelimited_in_rcu(KERN_ERR
 				"btrfs: fixed up error at logical %llu on dev %s\n",
 				(unsigned long long)logical,
-				rcu_str_deref(sctx->dev->name));
+				rcu_str_deref(dev->name));
 		}
 	} else {
 did_not_correct_error:
@@ -955,7 +960,7 @@ did_not_correct_error:
 		printk_ratelimited_in_rcu(KERN_ERR
 			"btrfs: unable to fixup (regular) error at logical %llu on dev %s\n",
 			(unsigned long long)logical,
-			rcu_str_deref(sctx->dev->name));
+			rcu_str_deref(dev->name));
 	}
 
 out:
@@ -1266,7 +1271,7 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	void *buffer;
 	u32 crc = ~(u32)0;
 	int fail = 0;
-	struct btrfs_root *root = sctx->dev->dev_root;
+	struct btrfs_root *root = sctx->dev_root;
 	u64 len;
 	int index;
 
@@ -1306,7 +1311,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 {
 	struct scrub_ctx *sctx = sblock->sctx;
 	struct btrfs_header *h;
-	struct btrfs_root *root = sctx->dev->dev_root;
+	struct btrfs_root *root = sctx->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
 	u8 on_disk_csum[BTRFS_CSUM_SIZE];
@@ -1378,7 +1383,7 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 {
 	struct btrfs_super_block *s;
 	struct scrub_ctx *sctx = sblock->sctx;
-	struct btrfs_root *root = sctx->dev->dev_root;
+	struct btrfs_root *root = sctx->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
 	u8 on_disk_csum[BTRFS_CSUM_SIZE];
@@ -1442,10 +1447,10 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 		++sctx->stat.super_errors;
 		spin_unlock(&sctx->stat_lock);
 		if (fail_cor)
-			btrfs_dev_stat_inc_and_print(sctx->dev,
+			btrfs_dev_stat_inc_and_print(sblock->pagev[0].dev,
 				BTRFS_DEV_STAT_CORRUPTION_ERRS);
 		else
-			btrfs_dev_stat_inc_and_print(sctx->dev,
+			btrfs_dev_stat_inc_and_print(sblock->pagev[0].dev,
 				BTRFS_DEV_STAT_GENERATION_ERRS);
 	}
 
@@ -1513,6 +1518,7 @@ again:
 
 		sbio->physical = spage->physical;
 		sbio->logical = spage->logical;
+		sbio->dev = spage->dev;
 		bio = sbio->bio;
 		if (!bio) {
 			bio = bio_alloc(GFP_NOFS, sctx->pages_per_bio);
@@ -1523,13 +1529,14 @@ again:
 
 		bio->bi_private = sbio;
 		bio->bi_end_io = scrub_bio_end_io;
-		bio->bi_bdev = sctx->dev->bdev;
-		bio->bi_sector = spage->physical >> 9;
+		bio->bi_bdev = sbio->dev->bdev;
+		bio->bi_sector = sbio->physical >> 9;
 		sbio->err = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical ||
 		   sbio->logical + sbio->page_count * PAGE_SIZE !=
-		   spage->logical) {
+		   spage->logical ||
+		   sbio->dev != spage->dev) {
 		scrub_submit(sctx);
 		goto again;
 	}
@@ -1556,8 +1563,8 @@ again:
 }
 
 static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
-		       u64 physical, u64 flags, u64 gen, int mirror_num,
-		       u8 *csum, int force)
+		       u64 physical, struct btrfs_device *dev, u64 flags,
+		       u64 gen, int mirror_num, u8 *csum, int force)
 {
 	struct scrub_block *sblock;
 	int index;
@@ -1593,7 +1600,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			return -ENOMEM;
 		}
 		spage->sblock = sblock;
-		spage->dev = sctx->dev;
+		spage->dev = dev;
 		spage->flags = flags;
 		spage->generation = gen;
 		spage->logical = logical;
@@ -1634,8 +1641,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 static void scrub_bio_end_io(struct bio *bio, int err)
 {
 	struct scrub_bio *sbio = bio->bi_private;
-	struct scrub_ctx *sctx = sbio->sctx;
-	struct btrfs_fs_info *fs_info = sctx->dev->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
 
 	sbio->err = err;
 	sbio->bio = bio;
@@ -1728,7 +1734,8 @@ static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u64 len,
 
 /* scrub extent tries to collect up to 64 kB for each bio */
 static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
-			u64 physical, u64 flags, u64 gen, int mirror_num)
+			u64 physical, struct btrfs_device *dev, u64 flags,
+			u64 gen, int mirror_num)
 {
 	int ret;
 	u8 csum[BTRFS_CSUM_SIZE];
@@ -1762,7 +1769,7 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 			if (have_csum == 0)
 				++sctx->stat.no_csum;
 		}
-		ret = scrub_pages(sctx, logical, l, physical, flags, gen,
+		ret = scrub_pages(sctx, logical, l, physical, dev, flags, gen,
 				  mirror_num, have_csum ? csum : NULL, 0);
 		if (ret)
 			return ret;
@@ -1774,10 +1781,12 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 }
 
 static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
-	struct map_lookup *map, int num, u64 base, u64 length)
+					   struct map_lookup *map,
+					   struct btrfs_device *scrub_dev,
+					   int num, u64 base, u64 length)
 {
 	struct btrfs_path *path;
-	struct btrfs_fs_info *fs_info = sctx->dev->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_root *csum_root = fs_info->csum_root;
 	struct btrfs_extent_item *extent;
@@ -1797,7 +1806,6 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	struct reada_control *reada2;
 	struct btrfs_key key_start;
 	struct btrfs_key key_end;
-
 	u64 increment = map->stripe_len;
 	u64 offset;
 
@@ -2006,7 +2014,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 
 			ret = scrub_extent(sctx, key.objectid, key.offset,
 					   key.objectid - logical + physical,
-					   flags, generation, mirror_num);
+					   scrub_dev, flags, generation,
+					   mirror_num);
 			if (ret)
 				goto out;
 
@@ -2030,11 +2039,13 @@ out:
 }
 
 static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
-	u64 chunk_tree, u64 chunk_objectid, u64 chunk_offset, u64 length,
-	u64 dev_offset)
+					  struct btrfs_device *scrub_dev,
+					  u64 chunk_tree, u64 chunk_objectid,
+					  u64 chunk_offset, u64 length,
+					  u64 dev_offset)
 {
 	struct btrfs_mapping_tree *map_tree =
-		&sctx->dev->dev_root->fs_info->mapping_tree;
+		&sctx->dev_root->fs_info->mapping_tree;
 	struct map_lookup *map;
 	struct extent_map *em;
 	int i;
@@ -2055,9 +2066,10 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 		goto out;
 
 	for (i = 0; i < map->num_stripes; ++i) {
-		if (map->stripes[i].dev == sctx->dev &&
+		if (map->stripes[i].dev->bdev == scrub_dev->bdev &&
 		    map->stripes[i].physical == dev_offset) {
-			ret = scrub_stripe(sctx, map, i, chunk_offset, length);
+			ret = scrub_stripe(sctx, map, scrub_dev, i,
+					   chunk_offset, length);
 			if (ret)
 				goto out;
 		}
@@ -2069,11 +2081,12 @@ out:
 }
 
 static noinline_for_stack
-int scrub_enumerate_chunks(struct scrub_ctx *sctx, u64 start, u64 end)
+int scrub_enumerate_chunks(struct scrub_ctx *sctx,
+			   struct btrfs_device *scrub_dev, u64 start, u64 end)
 {
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
-	struct btrfs_root *root = sctx->dev->dev_root;
+	struct btrfs_root *root = sctx->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 length;
 	u64 chunk_tree;
@@ -2094,11 +2107,10 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx, u64 start, u64 end)
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
 
-	key.objectid = sctx->dev->devid;
+	key.objectid = scrub_dev->devid;
 	key.offset = 0ull;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 
-
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
@@ -2117,7 +2129,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx, u64 start, u64 end)
 
 		btrfs_item_key_to_cpu(l, &found_key, slot);
 
-		if (found_key.objectid != sctx->dev->devid)
+		if (found_key.objectid != scrub_dev->devid)
 			break;
 
 		if (btrfs_key_type(&found_key) != BTRFS_DEV_EXTENT_KEY)
@@ -2151,7 +2163,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx, u64 start, u64 end)
 			ret = -ENOENT;
 			break;
 		}
-		ret = scrub_chunk(sctx, chunk_tree, chunk_objectid,
+		ret = scrub_chunk(sctx, scrub_dev, chunk_tree, chunk_objectid,
 				  chunk_offset, length, found_key.offset);
 		btrfs_put_block_group(cache);
 		if (ret)
@@ -2170,14 +2182,14 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx, u64 start, u64 end)
 	return ret < 0 ? ret : 0;
 }
 
-static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx)
+static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
+					   struct btrfs_device *scrub_dev)
 {
 	int	i;
 	u64	bytenr;
 	u64	gen;
 	int	ret;
-	struct btrfs_device *device = sctx->dev;
-	struct btrfs_root *root = device->dev_root;
+	struct btrfs_root *root = sctx->dev_root;
 
 	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
 		return -EIO;
@@ -2186,11 +2198,12 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx)
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > scrub_dev->total_bytes)
 			break;
 
 		ret = scrub_pages(sctx, bytenr, BTRFS_SUPER_INFO_SIZE, bytenr,
-				     BTRFS_EXTENT_FLAG_SUPER, gen, i, NULL, 1);
+				  scrub_dev, BTRFS_EXTENT_FLAG_SUPER, gen, i,
+				  NULL, 1);
 		if (ret)
 			return ret;
 	}
@@ -2317,11 +2330,11 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	down_read(&fs_info->scrub_super_lock);
-	ret = scrub_supers(sctx);
+	ret = scrub_supers(sctx, dev);
 	up_read(&fs_info->scrub_super_lock);
 
 	if (!ret)
-		ret = scrub_enumerate_chunks(sctx, start, end);
+		ret = scrub_enumerate_chunks(sctx, dev, start, end);
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
-- 
1.8.0

