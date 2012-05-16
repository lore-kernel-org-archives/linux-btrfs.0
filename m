Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:50804 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab2EPQut (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 12:50:49 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id B5391237
	for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2012 18:50:47 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/3] Btrfs: add device counters for detected IO and checksum errors
Date: Wed, 16 May 2012 18:50:45 +0200
Message-Id: <0072a9fd5bd99859983665e65b695b55cd186097.1337185201.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1337185201.git.sbehrens@giantdisaster.de>
References: <cover.1337185201.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1337185201.git.sbehrens@giantdisaster.de>
References: <cover.1337185201.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The goal is to detect when drives start to get an increased error rate,
when drives should be replaced soon. Therefore statistic counters are
added that count IO errors (read, write and flush). Additionally, the
software detected errors like checksum errors and corrupted blocks are
counted.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c   |   18 ++++++++++---
 fs/btrfs/extent_io.c |   27 +++++++++++++++++--
 fs/btrfs/scrub.c     |   72 +++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.c   |   61 +++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.h   |   21 +++++++++++++++
 5 files changed, 174 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a7ffc88..e123629 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2556,18 +2556,21 @@ recovery_tree_root:
 
 static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
-	char b[BDEVNAME_SIZE];
-
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
+		struct btrfs_device *device = (struct btrfs_device *)
+			bh->b_private;
+
 		printk_ratelimited(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-				       bdevname(bh->b_bdev, b));
+				   "I/O error on %s\n", device->name);
 		/* note, we dont' set_buffer_write_io_error because we have
 		 * our own ways of dealing with the IO errors
 		 */
 		clear_buffer_uptodate(bh);
+		btrfs_device_stat_inc(&device->cnt_write_io_errs);
+		device->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(device);
 	}
 	unlock_buffer(bh);
 	put_bh(bh);
@@ -2682,6 +2685,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			set_buffer_uptodate(bh);
 			lock_buffer(bh);
 			bh->b_end_io = btrfs_end_buffer_write_sync;
+			bh->b_private = device;
 		}
 
 		/*
@@ -2740,6 +2744,12 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 		}
 		if (!bio_flagged(bio, BIO_UPTODATE)) {
 			ret = -EIO;
+			if (!bio_flagged(bio, BIO_EOPNOTSUPP)) {
+				btrfs_device_stat_inc(
+					&device->cnt_flush_io_errs);
+				device->device_stats_dirty = 1;
+				btrfs_device_stat_print_on_error(device);
+			}
 		}
 
 		/* drop the reference from the wait == 0 run */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2fb52c2..6cd9a55 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1923,6 +1923,9 @@ int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
 		/* try to remap that extent elsewhere? */
 		bio_put(bio);
+		btrfs_device_stat_inc(&dev->cnt_write_io_errs);
+		dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(dev);
 		return -EIO;
 	}
 
@@ -2347,10 +2350,30 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
 							      state, mirror);
-			if (ret)
+			if (ret) {
+				/* no IO indicated but software detected errors
+				 * in the block, either checksum errors or
+				 * issues with the contents */
+				int failed_mirror = (int)(uintptr_t)
+						    bio->bi_bdev;
+				struct btrfs_root *root =
+					BTRFS_I(page->mapping->host)->root;
+				struct btrfs_device *device;
+
 				uptodate = 0;
-			else
+				device = btrfs_find_device_for_logical(
+						root, start,
+						(int)failed_mirror);
+				if (device) {
+					btrfs_device_stat_inc(
+						&device->cnt_corruption_errs);
+					device->device_stats_dirty = 1;
+					btrfs_device_stat_print_on_error(
+						device);
+				}
+			} else {
 				clean_io_failure(start, page);
+			}
 		}
 
 		if (!uptodate && tree->ops && tree->ops->readpage_io_failed_hook) {
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 7e487be..2795c94 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -50,7 +50,7 @@ struct scrub_dev;
 struct scrub_page {
 	struct scrub_block	*sblock;
 	struct page		*page;
-	struct block_device	*bdev;
+	struct btrfs_device	*dev;
 	u64			flags;  /* extent flags */
 	u64			generation;
 	u64			logical;
@@ -86,6 +86,7 @@ struct scrub_block {
 		unsigned int	header_error:1;
 		unsigned int	checksum_error:1;
 		unsigned int	no_io_error_seen:1;
+		unsigned int	generation_error:1; /* also sets header_error */
 	};
 };
 
@@ -675,6 +676,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sdev->stat.read_errors++;
 		sdev->stat.uncorrectable_errors++;
 		spin_unlock(&sdev->stat_lock);
+		btrfs_device_stat_inc(&sdev->dev->cnt_read_io_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
 		goto out;
 	}
 
@@ -686,6 +690,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sdev->stat.read_errors++;
 		sdev->stat.uncorrectable_errors++;
 		spin_unlock(&sdev->stat_lock);
+		btrfs_device_stat_inc(&sdev->dev->cnt_read_io_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
 		goto out;
 	}
 	BUG_ON(failed_mirror_index >= BTRFS_MAX_MIRRORS);
@@ -699,6 +706,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sdev->stat.read_errors++;
 		sdev->stat.uncorrectable_errors++;
 		spin_unlock(&sdev->stat_lock);
+		btrfs_device_stat_inc(&sdev->dev->cnt_read_io_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
 		goto out;
 	}
 
@@ -725,12 +735,18 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		spin_unlock(&sdev->stat_lock);
 		if (__ratelimit(&_rs))
 			scrub_print_warning("i/o error", sblock_to_check);
+		btrfs_device_stat_inc(&sdev->dev->cnt_read_io_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
 	} else if (sblock_bad->checksum_error) {
 		spin_lock(&sdev->stat_lock);
 		sdev->stat.csum_errors++;
 		spin_unlock(&sdev->stat_lock);
 		if (__ratelimit(&_rs))
 			scrub_print_warning("checksum error", sblock_to_check);
+		btrfs_device_stat_inc(&sdev->dev->cnt_corruption_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
 	} else if (sblock_bad->header_error) {
 		spin_lock(&sdev->stat_lock);
 		sdev->stat.verify_errors++;
@@ -738,6 +754,12 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		if (__ratelimit(&_rs))
 			scrub_print_warning("checksum/header error",
 					    sblock_to_check);
+		if (sblock_bad->generation_error)
+			btrfs_device_stat_inc(&sdev->dev->cnt_generation_errs);
+		else
+			btrfs_device_stat_inc(&sdev->dev->cnt_corruption_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
 	}
 
 	if (sdev->readonly)
@@ -998,8 +1020,8 @@ static int scrub_setup_recheck_block(struct scrub_dev *sdev,
 			page = sblock->pagev + page_index;
 			page->logical = logical;
 			page->physical = bbio->stripes[mirror_index].physical;
-			/* for missing devices, bdev is NULL */
-			page->bdev = bbio->stripes[mirror_index].dev->bdev;
+			/* for missing devices, dev->bdev is NULL */
+			page->dev = bbio->stripes[mirror_index].dev;
 			page->mirror_num = mirror_index + 1;
 			page->page = alloc_page(GFP_NOFS);
 			if (!page->page) {
@@ -1043,7 +1065,7 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 		struct scrub_page *page = sblock->pagev + page_num;
 		DECLARE_COMPLETION_ONSTACK(complete);
 
-		if (page->bdev == NULL) {
+		if (page->dev->bdev == NULL) {
 			page->io_error = 1;
 			sblock->no_io_error_seen = 0;
 			continue;
@@ -1053,7 +1075,7 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 		bio = bio_alloc(GFP_NOFS, 1);
 		if (!bio)
 			return -EIO;
-		bio->bi_bdev = page->bdev;
+		bio->bi_bdev = page->dev->bdev;
 		bio->bi_sector = page->physical >> 9;
 		bio->bi_end_io = scrub_complete_bio_end_io;
 		bio->bi_private = &complete;
@@ -1102,11 +1124,14 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		h = (struct btrfs_header *)mapped_buffer;
 
 		if (sblock->pagev[0].logical != le64_to_cpu(h->bytenr) ||
-		    generation != le64_to_cpu(h->generation) ||
 		    memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE) ||
 		    memcmp(h->chunk_tree_uuid, fs_info->chunk_tree_uuid,
-			   BTRFS_UUID_SIZE))
+			   BTRFS_UUID_SIZE)) {
 			sblock->header_error = 1;
+		} else if (generation != le64_to_cpu(h->generation)) {
+			sblock->header_error = 1;
+			sblock->generation_error = 1;
+		}
 		csum = h->csum;
 	} else {
 		if (!have_csum)
@@ -1183,7 +1208,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		bio = bio_alloc(GFP_NOFS, 1);
 		if (!bio)
 			return -EIO;
-		bio->bi_bdev = page_bad->bdev;
+		bio->bi_bdev = page_bad->dev->bdev;
 		bio->bi_sector = page_bad->physical >> 9;
 		bio->bi_end_io = scrub_complete_bio_end_io;
 		bio->bi_private = &complete;
@@ -1197,6 +1222,14 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 
 		/* this will also unplug the queue */
 		wait_for_completion(&complete);
+		if (!bio_flagged(bio, BIO_UPTODATE)) {
+			btrfs_device_stat_inc(
+				&page_bad->dev->cnt_write_io_errs);
+			page_bad->dev->device_stats_dirty = 1;
+			btrfs_device_stat_print_on_error(page_bad->dev);
+			bio_put(bio);
+			return -EIO;
+		}
 		bio_put(bio);
 	}
 
@@ -1353,7 +1386,8 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	u64 mapped_size;
 	void *p;
 	u32 crc = ~(u32)0;
-	int fail = 0;
+	int fail_gen = 0;
+	int fail_cor = 0;
 	u64 len;
 	int index;
 
@@ -1364,13 +1398,13 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	memcpy(on_disk_csum, s->csum, sdev->csum_size);
 
 	if (sblock->pagev[0].logical != le64_to_cpu(s->bytenr))
-		++fail;
+		++fail_cor;
 
 	if (sblock->pagev[0].generation != le64_to_cpu(s->generation))
-		++fail;
+		++fail_gen;
 
 	if (memcmp(s->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
-		++fail;
+		++fail_cor;
 
 	len = BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE;
 	mapped_size = PAGE_SIZE - BTRFS_CSUM_SIZE;
@@ -1395,9 +1429,9 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 
 	btrfs_csum_final(crc, calculated_csum);
 	if (memcmp(calculated_csum, on_disk_csum, sdev->csum_size))
-		++fail;
+		++fail_cor;
 
-	if (fail) {
+	if (fail_cor + fail_gen) {
 		/*
 		 * if we find an error in a super block, we just report it.
 		 * They will get written with the next transaction commit
@@ -1406,9 +1440,15 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 		spin_lock(&sdev->stat_lock);
 		++sdev->stat.super_errors;
 		spin_unlock(&sdev->stat_lock);
+		if (fail_cor)
+			btrfs_device_stat_inc(&sdev->dev->cnt_corruption_errs);
+		else
+			btrfs_device_stat_inc(&sdev->dev->cnt_generation_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
 	}
 
-	return fail;
+	return fail_cor + fail_gen;
 }
 
 static void scrub_block_get(struct scrub_block *sblock)
@@ -1552,7 +1592,7 @@ static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
 			return -ENOMEM;
 		}
 		spage->sblock = sblock;
-		spage->bdev = sdev->dev->bdev;
+		spage->dev = sdev->dev;
 		spage->flags = flags;
 		spage->generation = gen;
 		spage->logical = logical;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1411b99..c458c74 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -23,6 +23,7 @@
 #include <linux/random.h>
 #include <linux/iocontext.h>
 #include <linux/capability.h>
+#include <linux/ratelimit.h>
 #include <linux/kthread.h>
 #include <asm/div64.h>
 #include "compat.h"
@@ -4003,11 +4004,28 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 
 static void btrfs_end_bio(struct bio *bio, int err)
 {
-	struct btrfs_bio *bbio = bio->bi_private;
+	struct btrfs_bio *bbio = (struct btrfs_bio *)
+		(((uintptr_t)bio->bi_private) & ~((uintptr_t)3));
 	int is_orig_bio = 0;
 
-	if (err)
+	if (err) {
 		atomic_inc(&bbio->error);
+		if (err == -EIO || err == -EREMOTEIO) {
+			unsigned int dev_nr = ((uintptr_t)bio->bi_private) & 3;
+			struct btrfs_device *dev;
+
+			BUG_ON(dev_nr >= bbio->num_stripes);
+			dev = bbio->stripes[dev_nr].dev;
+			if (bio->bi_rw & WRITE)
+				btrfs_device_stat_inc(&dev->cnt_write_io_errs);
+			else
+				btrfs_device_stat_inc(&dev->cnt_read_io_errs);
+			if ((bio->bi_rw & WRITE_FLUSH) == WRITE_FLUSH)
+				btrfs_device_stat_inc(&dev->cnt_flush_io_errs);
+			dev->device_stats_dirty = 1;
+			btrfs_device_stat_print_on_error(dev);
+		}
+	}
 
 	if (bio == bbio->orig_bio)
 		is_orig_bio = 1;
@@ -4148,7 +4166,9 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		} else {
 			bio = first_bio;
 		}
-		bio->bi_private = bbio;
+		BUG_ON((((uintptr_t)bbio) & 3) != 0);
+		BUG_ON(dev_nr > 3);
+		bio->bi_private = (void *)(((uintptr_t)bbio) | dev_nr);
 		bio->bi_end_io = btrfs_end_bio;
 		bio->bi_sector = bbio->stripes[dev_nr].physical >> 9;
 		dev = bbio->stripes[dev_nr].dev;
@@ -4509,6 +4529,28 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	return ret;
 }
 
+struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
+						   u64 logical, int mirror_num)
+{
+	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	int ret;
+	u64 map_length = 0;
+	struct btrfs_bio *bbio = NULL;
+	struct btrfs_device *device;
+
+	BUG_ON(mirror_num == 0);
+	ret = btrfs_map_block(map_tree, WRITE, logical, &map_length, &bbio,
+			      mirror_num);
+	if (ret) {
+		BUG_ON(bbio != NULL);
+		return NULL;
+	}
+	BUG_ON(mirror_num != bbio->mirror_num);
+	device = bbio->stripes[mirror_num - 1].dev;
+	kfree(bbio);
+	return device;
+}
+
 int btrfs_read_chunk_tree(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
@@ -4583,3 +4625,16 @@ error:
 	btrfs_free_path(path);
 	return ret;
 }
+
+void btrfs_device_stat_print_on_error(struct btrfs_device *device)
+{
+	printk_ratelimited(KERN_ERR
+			   "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
+			   device->name,
+			   btrfs_device_stat_read(&device->cnt_write_io_errs),
+			   btrfs_device_stat_read(&device->cnt_read_io_errs),
+			   btrfs_device_stat_read(&device->cnt_flush_io_errs),
+			   btrfs_device_stat_read(&device->cnt_corruption_errs),
+			   btrfs_device_stat_read(
+				&device->cnt_generation_errs));
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index bb6b03f..08afa6c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -106,6 +106,14 @@ struct btrfs_device {
 	struct completion flush_wait;
 	int nobarriers;
 
+	/* disk I/O failure stats. For detailed description refer to
+	 * struct btrfs_device_stats_item in ctree.h */
+	int device_stats_dirty; /* counters need to be written to disk */
+	atomic_t cnt_write_io_errs;
+	atomic_t cnt_read_io_errs;
+	atomic_t cnt_flush_io_errs;
+	atomic_t cnt_corruption_errs;
+	atomic_t cnt_generation_errs;
 };
 
 struct btrfs_fs_devices {
@@ -281,4 +289,17 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
+						   u64 logical, int mirror_num);
+void btrfs_device_stat_print_on_error(struct btrfs_device *device);
+
+static inline void btrfs_device_stat_inc(atomic_t *cnt)
+{
+	atomic_inc(cnt);
+}
+
+static inline int btrfs_device_stat_read(atomic_t *cnt)
+{
+	return atomic_read(cnt);
+}
 #endif
-- 
1.7.10.2

