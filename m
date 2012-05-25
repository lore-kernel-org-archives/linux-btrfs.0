Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:47890 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab2EYOGM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 10:06:12 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by ysabell.rzone.de (Postfix) with ESMTP id AAD973D6
	for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 16:06:10 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 1/3] Btrfs: add device counters for detected IO and checksum errors
Date: Fri, 25 May 2012 16:06:08 +0200
Message-Id: <1337954770-10086-2-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1337954770-10086-1-git-send-email-sbehrens@giantdisaster.de>
References: <1337954770-10086-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The goal is to detect when drives start to get an increased error rate,
when drives should be replaced soon. Therefore statistic counters are
added that count IO errors (read, write and flush). Additionally, the
software detected errors like checksum errors and corrupted blocks are
counted.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c   |   13 ++++---
 fs/btrfs/extent_io.c |   18 ++++++++--
 fs/btrfs/ioctl.h     |   19 ++++++++++
 fs/btrfs/scrub.c     |   65 +++++++++++++++++++++++++---------
 fs/btrfs/volumes.c   |   94 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h   |   45 ++++++++++++++++++++++++
 6 files changed, 230 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a7ffc88..da4d33f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2556,18 +2556,19 @@ recovery_tree_root:
 
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
+		btrfs_dev_stat_inc_and_print(device, BTRFS_DEV_STAT_WRITE_ERRS);
 	}
 	unlock_buffer(bh);
 	put_bh(bh);
@@ -2682,6 +2683,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			set_buffer_uptodate(bh);
 			lock_buffer(bh);
 			bh->b_end_io = btrfs_end_buffer_write_sync;
+			bh->b_private = device;
 		}
 
 		/*
@@ -2740,6 +2742,9 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 		}
 		if (!bio_flagged(bio, BIO_UPTODATE)) {
 			ret = -EIO;
+			if (!bio_flagged(bio, BIO_EOPNOTSUPP))
+				btrfs_dev_stat_inc_and_print(device,
+					BTRFS_DEV_STAT_FLUSH_ERRS);
 		}
 
 		/* drop the reference from the wait == 0 run */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2fb52c2..55f72f8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1923,6 +1923,7 @@ int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
 		/* try to remap that extent elsewhere? */
 		bio_put(bio);
+		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
 		return -EIO;
 	}
 
@@ -2347,10 +2348,23 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
 							      state, mirror);
-			if (ret)
+			if (ret) {
+				/* no IO indicated but software detected errors
+				 * in the block, either checksum errors or
+				 * issues with the contents */
+				struct btrfs_root *root =
+					BTRFS_I(page->mapping->host)->root;
+				struct btrfs_device *device;
+
 				uptodate = 0;
-			else
+				device = btrfs_find_device_for_logical(
+						root, start, mirror);
+				if (device)
+					btrfs_dev_stat_inc_and_print(device,
+						BTRFS_DEV_STAT_CORRUPTION_ERRS);
+			} else {
 				clean_io_failure(start, page);
+			}
 		}
 
 		if (!uptodate && tree->ops && tree->ops->readpage_io_failed_hook) {
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 086e6bd..5bf05e2 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -266,6 +266,25 @@ struct btrfs_ioctl_logical_ino_args {
 	__u64				inodes;
 };
 
+enum btrfs_dev_stat_values {
+	/* disk I/O failure stats */
+	BTRFS_DEV_STAT_WRITE_ERRS, /* EIO or EREMOTEIO from lower layers */
+	BTRFS_DEV_STAT_READ_ERRS, /* EIO or EREMOTEIO from lower layers */
+	BTRFS_DEV_STAT_FLUSH_ERRS, /* EIO or EREMOTEIO from lower layers */
+
+	/* stats for indirect indications for I/O failures */
+	BTRFS_DEV_STAT_CORRUPTION_ERRS, /* checksum error, bytenr error or
+					 * contents is illegal: this is an
+					 * indication that the block was damaged
+					 * during read or write, or written to
+					 * wrong location or read from wrong
+					 * location */
+	BTRFS_DEV_STAT_GENERATION_ERRS, /* an indication that blocks have not
+					 * been written */
+
+	BTRFS_DEV_STAT_VALUES_MAX
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 7e487be..5e58416 100644
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
 
@@ -675,6 +676,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sdev->stat.read_errors++;
 		sdev->stat.uncorrectable_errors++;
 		spin_unlock(&sdev->stat_lock);
+		btrfs_dev_stat_inc_and_print(sdev->dev,
+					     BTRFS_DEV_STAT_READ_ERRS);
 		goto out;
 	}
 
@@ -686,6 +689,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sdev->stat.read_errors++;
 		sdev->stat.uncorrectable_errors++;
 		spin_unlock(&sdev->stat_lock);
+		btrfs_dev_stat_inc_and_print(sdev->dev,
+					     BTRFS_DEV_STAT_READ_ERRS);
 		goto out;
 	}
 	BUG_ON(failed_mirror_index >= BTRFS_MAX_MIRRORS);
@@ -699,6 +704,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sdev->stat.read_errors++;
 		sdev->stat.uncorrectable_errors++;
 		spin_unlock(&sdev->stat_lock);
+		btrfs_dev_stat_inc_and_print(sdev->dev,
+					     BTRFS_DEV_STAT_READ_ERRS);
 		goto out;
 	}
 
@@ -725,12 +732,16 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		spin_unlock(&sdev->stat_lock);
 		if (__ratelimit(&_rs))
 			scrub_print_warning("i/o error", sblock_to_check);
+		btrfs_dev_stat_inc_and_print(sdev->dev,
+					     BTRFS_DEV_STAT_READ_ERRS);
 	} else if (sblock_bad->checksum_error) {
 		spin_lock(&sdev->stat_lock);
 		sdev->stat.csum_errors++;
 		spin_unlock(&sdev->stat_lock);
 		if (__ratelimit(&_rs))
 			scrub_print_warning("checksum error", sblock_to_check);
+		btrfs_dev_stat_inc_and_print(sdev->dev,
+					     BTRFS_DEV_STAT_CORRUPTION_ERRS);
 	} else if (sblock_bad->header_error) {
 		spin_lock(&sdev->stat_lock);
 		sdev->stat.verify_errors++;
@@ -738,6 +749,12 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		if (__ratelimit(&_rs))
 			scrub_print_warning("checksum/header error",
 					    sblock_to_check);
+		if (sblock_bad->generation_error)
+			btrfs_dev_stat_inc_and_print(sdev->dev,
+				BTRFS_DEV_STAT_GENERATION_ERRS);
+		else
+			btrfs_dev_stat_inc_and_print(sdev->dev,
+				BTRFS_DEV_STAT_CORRUPTION_ERRS);
 	}
 
 	if (sdev->readonly)
@@ -998,8 +1015,8 @@ static int scrub_setup_recheck_block(struct scrub_dev *sdev,
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
@@ -1043,7 +1060,7 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 		struct scrub_page *page = sblock->pagev + page_num;
 		DECLARE_COMPLETION_ONSTACK(complete);
 
-		if (page->bdev == NULL) {
+		if (page->dev->bdev == NULL) {
 			page->io_error = 1;
 			sblock->no_io_error_seen = 0;
 			continue;
@@ -1053,7 +1070,7 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 		bio = bio_alloc(GFP_NOFS, 1);
 		if (!bio)
 			return -EIO;
-		bio->bi_bdev = page->bdev;
+		bio->bi_bdev = page->dev->bdev;
 		bio->bi_sector = page->physical >> 9;
 		bio->bi_end_io = scrub_complete_bio_end_io;
 		bio->bi_private = &complete;
@@ -1102,11 +1119,14 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
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
@@ -1183,7 +1203,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		bio = bio_alloc(GFP_NOFS, 1);
 		if (!bio)
 			return -EIO;
-		bio->bi_bdev = page_bad->bdev;
+		bio->bi_bdev = page_bad->dev->bdev;
 		bio->bi_sector = page_bad->physical >> 9;
 		bio->bi_end_io = scrub_complete_bio_end_io;
 		bio->bi_private = &complete;
@@ -1197,6 +1217,12 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 
 		/* this will also unplug the queue */
 		wait_for_completion(&complete);
+		if (!bio_flagged(bio, BIO_UPTODATE)) {
+			btrfs_dev_stat_inc_and_print(page_bad->dev,
+				BTRFS_DEV_STAT_WRITE_ERRS);
+			bio_put(bio);
+			return -EIO;
+		}
 		bio_put(bio);
 	}
 
@@ -1353,7 +1379,8 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	u64 mapped_size;
 	void *p;
 	u32 crc = ~(u32)0;
-	int fail = 0;
+	int fail_gen = 0;
+	int fail_cor = 0;
 	u64 len;
 	int index;
 
@@ -1364,13 +1391,13 @@ static int scrub_checksum_super(struct scrub_block *sblock)
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
@@ -1395,9 +1422,9 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 
 	btrfs_csum_final(crc, calculated_csum);
 	if (memcmp(calculated_csum, on_disk_csum, sdev->csum_size))
-		++fail;
+		++fail_cor;
 
-	if (fail) {
+	if (fail_cor + fail_gen) {
 		/*
 		 * if we find an error in a super block, we just report it.
 		 * They will get written with the next transaction commit
@@ -1406,9 +1433,15 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 		spin_lock(&sdev->stat_lock);
 		++sdev->stat.super_errors;
 		spin_unlock(&sdev->stat_lock);
+		if (fail_cor)
+			btrfs_dev_stat_inc_and_print(sdev->dev,
+				BTRFS_DEV_STAT_CORRUPTION_ERRS);
+		else
+			btrfs_dev_stat_inc_and_print(sdev->dev,
+				BTRFS_DEV_STAT_GENERATION_ERRS);
 	}
 
-	return fail;
+	return fail_cor + fail_gen;
 }
 
 static void scrub_block_get(struct scrub_block *sblock)
@@ -1552,7 +1585,7 @@ static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
 			return -ENOMEM;
 		}
 		spage->sblock = sblock;
-		spage->bdev = sdev->dev->bdev;
+		spage->dev = sdev->dev;
 		spage->flags = flags;
 		spage->generation = gen;
 		spage->logical = logical;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1411b99..05e05fb 100644
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
@@ -4001,13 +4002,58 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	return 0;
 }
 
+static void *merge_stripe_index_into_bio_private(void *bi_private,
+						 unsigned int stripe_index)
+{
+	/*
+	 * with single, dup, RAID0, RAID1 and RAID10, stripe_index is
+	 * at most 1.
+	 * The alternative solution (instead of stealing bits from the
+	 * pointer) would be to allocate an intermediate structure
+	 * that contains the old private pointer plus the stripe_index.
+	 */
+	BUG_ON((((uintptr_t)bi_private) & 3) != 0);
+	BUG_ON(stripe_index > 3);
+	return (void *)(((uintptr_t)bi_private) | stripe_index);
+}
+
+static struct btrfs_bio *extract_bbio_from_bio_private(void *bi_private)
+{
+	return (struct btrfs_bio *)(((uintptr_t)bi_private) & ~((uintptr_t)3));
+}
+
+static unsigned int extract_stripe_index_from_bio_private(void *bi_private)
+{
+	return (unsigned int)((uintptr_t)bi_private) & 3;
+}
+
 static void btrfs_end_bio(struct bio *bio, int err)
 {
-	struct btrfs_bio *bbio = bio->bi_private;
+	struct btrfs_bio *bbio = extract_bbio_from_bio_private(bio->bi_private);
 	int is_orig_bio = 0;
 
-	if (err)
+	if (err) {
 		atomic_inc(&bbio->error);
+		if (err == -EIO || err == -EREMOTEIO) {
+			unsigned int stripe_index =
+				extract_stripe_index_from_bio_private(
+					bio->bi_private);
+			struct btrfs_device *dev;
+
+			BUG_ON(stripe_index >= bbio->num_stripes);
+			dev = bbio->stripes[stripe_index].dev;
+			if (bio->bi_rw & WRITE)
+				btrfs_dev_stat_inc(dev,
+						   BTRFS_DEV_STAT_WRITE_ERRS);
+			else
+				btrfs_dev_stat_inc(dev,
+						   BTRFS_DEV_STAT_READ_ERRS);
+			if ((bio->bi_rw & WRITE_FLUSH) == WRITE_FLUSH)
+				btrfs_dev_stat_inc(dev,
+						   BTRFS_DEV_STAT_FLUSH_ERRS);
+			btrfs_dev_stat_print_on_error(dev);
+		}
+	}
 
 	if (bio == bbio->orig_bio)
 		is_orig_bio = 1;
@@ -4149,6 +4195,8 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 			bio = first_bio;
 		}
 		bio->bi_private = bbio;
+		bio->bi_private = merge_stripe_index_into_bio_private(
+				bio->bi_private, (unsigned int)dev_nr);
 		bio->bi_end_io = btrfs_end_bio;
 		bio->bi_sector = bbio->stripes[dev_nr].physical >> 9;
 		dev = bbio->stripes[dev_nr].dev;
@@ -4509,6 +4557,28 @@ int btrfs_read_sys_array(struct btrfs_root *root)
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
@@ -4583,3 +4653,23 @@ error:
 	btrfs_free_path(path);
 	return ret;
 }
+
+void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index)
+{
+	btrfs_dev_stat_inc(dev, index);
+	btrfs_dev_stat_print_on_error(dev);
+}
+
+void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
+{
+	printk_ratelimited(KERN_ERR
+			   "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
+			   dev->name,
+			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
+			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
+			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
+			   btrfs_dev_stat_read(dev,
+					       BTRFS_DEV_STAT_CORRUPTION_ERRS),
+			   btrfs_dev_stat_read(dev,
+					       BTRFS_DEV_STAT_GENERATION_ERRS));
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index bb6b03f..193b283 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -22,6 +22,7 @@
 #include <linux/bio.h>
 #include <linux/sort.h>
 #include "async-thread.h"
+#include "ioctl.h"
 
 #define BTRFS_STRIPE_LEN	(64 * 1024)
 
@@ -106,6 +107,10 @@ struct btrfs_device {
 	struct completion flush_wait;
 	int nobarriers;
 
+	/* disk I/O failure stats. For detailed description refer to
+	 * enum btrfs_dev_stat_values in ioctl.h */
+	int dev_stats_dirty; /* counters need to be written to disk */
+	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
 };
 
 struct btrfs_fs_devices {
@@ -281,4 +286,44 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
+						   u64 logical, int mirror_num);
+void btrfs_dev_stat_print_on_error(struct btrfs_device *device);
+void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
+
+static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
+				      int index)
+{
+	atomic_inc(dev->dev_stat_values + index);
+	dev->dev_stats_dirty = 1;
+}
+
+static inline int btrfs_dev_stat_read(struct btrfs_device *dev,
+				      int index)
+{
+	return atomic_read(dev->dev_stat_values + index);
+}
+
+static inline int btrfs_dev_stat_read_and_reset(struct btrfs_device *dev,
+						int index)
+{
+	int ret;
+
+	ret = atomic_xchg(dev->dev_stat_values + index, 0);
+	dev->dev_stats_dirty = 1;
+	return ret;
+}
+
+static inline void btrfs_dev_stat_set(struct btrfs_device *dev,
+				      int index, unsigned long val)
+{
+	atomic_set(dev->dev_stat_values + index, val);
+	dev->dev_stats_dirty = 1;
+}
+
+static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
+					int index)
+{
+	btrfs_dev_stat_set(dev, index, 0);
+}
 #endif
-- 
1.7.10.2

