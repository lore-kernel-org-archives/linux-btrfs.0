From: David Woodhouse <dwmw2@infradead.org>
Subject: First attempt at writing RAID[56] parity stripes
Date: Mon, 13 Jul 2009 11:05:13 +0100
Message-ID: <1247479513.19180.41.camel@macbook.infradead.org>
References: <1247323186.17045.15.camel@macbook.infradead.org>
	 <1247477428.19180.28.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247477428.19180.28.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a fairly crap hack. Even if the file system _does_ want to write
a full stripe-set at a time, the merge_bio_hook logic will prevent it
from doing so, and ensure that we always have to read the other stripes
to recreate the parity -- with all the concurrency issues that involves.

The raid_hack_mutex is a brute-force approach which isn't even really
sufficient to fix the RAID5 'write hole' problem, but does protect us
against simultaneous writes to different data stripes in the same set.

This hack serves two purposes:
 - It does actually write parity (and RAID6 syndrome) blocks so that I
   can implement and test the recovery.
 - It will hopefully offend someone more clueful about the higher layers
   of the filesystem, provoking them to help me with the task of
   ensuring that we only ever write full stripe-sets (or at least that we can
   waste the remaining free space in the stripe-set, if we can't manage that).

So hopefully most of this code can go away in the end -- although some
of it may be cannibalised to handle rebuilding after a disk replacement.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 fs/btrfs/Kconfig   |    1 +
 fs/btrfs/volumes.c |  321 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 316 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 7bb3c02..4703325 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -4,6 +4,7 @@ config BTRFS_FS
 	select LIBCRC32C
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
+	select MD_RAID6_PQ
 	help
 	  Btrfs is a new filesystem with extents, writable snapshotting,
 	  support for multiple devices and many more features.
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 55facd3..1f509ab 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -21,6 +21,7 @@
 #include <linux/blkdev.h>
 #include <linux/random.h>
 #include <linux/iocontext.h>
+#include <linux/raid/pq.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
@@ -61,6 +62,12 @@ static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_device *device);
 static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
+static int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
+				 int async, struct btrfs_multi_bio *multi,
+				 u64 *raid_map, u64 stripe_len, int mirror_num);
+static int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
+			       int async, struct btrfs_multi_bio *multi,
+			       u64 *raid_map, u64 stripe_len);
 
 #define RAID5_P_STRIPE ((u64)-1)
 #define RAID6_Q_STRIPE ((u64)-2)
@@ -3052,6 +3059,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	u64 logical = (u64)bio->bi_sector << 9;
 	u64 length = 0;
 	u64 map_length;
+	u64 *raid_map = NULL;
 	struct btrfs_multi_bio *multi = NULL;
 	int ret;
 	int dev_nr = 0;
@@ -3061,10 +3069,25 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	map_tree = &root->fs_info->mapping_tree;
 	map_length = length;
 
-	ret = btrfs_map_block(map_tree, rw, logical, &map_length, &multi,
-			      mirror_num);
+	ret = __btrfs_map_block(map_tree, rw, logical, &map_length, &multi,
+				mirror_num, NULL, &raid_map);
 	BUG_ON(ret);
 
+	multi->end_io = first_bio->bi_end_io;
+	multi->private = first_bio->bi_private;
+	multi->orig_bio = first_bio;
+	atomic_set(&multi->stripes_pending, multi->num_stripes);
+
+	if (raid_map) {
+		if (rw == READ)
+			return raid56_parity_recover(root, bio, async_submit,
+						     multi, raid_map, map_length,
+						     mirror_num);
+		else
+			return raid56_parity_write(root, bio, async_submit, multi,
+						   raid_map, map_length);
+	}
+
 	total_devs = multi->num_stripes;
 	if (map_length < length) {
 		printk(KERN_CRIT "mapping failed logical %llu bio len %llu "
@@ -3073,10 +3096,6 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		       (unsigned long long)map_length);
 		BUG();
 	}
-	multi->end_io = first_bio->bi_end_io;
-	multi->private = first_bio->bi_private;
-	multi->orig_bio = first_bio;
-	atomic_set(&multi->stripes_pending, multi->num_stripes);
 
 	while (dev_nr < total_devs) {
 		if (total_devs > 1) {
@@ -3494,3 +3513,293 @@ error:
 	btrfs_free_path(path);
 	return ret;
 }
+
+static DEFINE_MUTEX(raid_hack_mutex);
+
+struct btrfs_raid_multi_bio {
+	struct btrfs_root *root;
+	struct btrfs_multi_bio *multi;
+	u64 *raid_map;
+	struct bio *bio[0];
+};
+
+static void raid_write_end_io(struct bio *bio, int err)
+{
+	struct btrfs_raid_multi_bio *rmult = bio->bi_private;
+	int i, j;
+	int nr_pages = rmult->multi->orig_bio->bi_size >> PAGE_SHIFT;
+
+	if (err)
+		atomic_inc(&rmult->multi->error);
+
+	if (!atomic_dec_and_test(&rmult->multi->stripes_pending))
+		return;
+
+	/* OK, we have read all the stripes we need to. */
+	if (atomic_read(&rmult->multi->error)) {
+		bio_endio(rmult->multi->orig_bio, -EIO);
+		goto cleanup;
+	}
+	
+	rmult->multi->orig_bio->bi_private = rmult->multi->private;
+	rmult->multi->orig_bio->bi_end_io = rmult->multi->end_io;
+	bio_endio(rmult->multi->orig_bio, 0);
+
+ cleanup:
+	for (i = 0; i < rmult->multi->num_stripes; i++) {
+		if (!rmult->bio[i])
+			continue;
+		for (j = 0; j < nr_pages; j++) {
+			__free_page(rmult->bio[i]->bi_io_vec[j].bv_page);
+		}
+		bio_put(rmult->bio[i]);
+	}
+	kfree(rmult->raid_map);
+	kfree(rmult->multi);
+	kfree(rmult);
+	mutex_unlock(&raid_hack_mutex);
+}
+
+static void raid_read_end_io(struct bio *bio, int err)
+{
+	struct btrfs_raid_multi_bio *rmult = bio->bi_private;
+	int nr_pages = rmult->multi->orig_bio->bi_size >> PAGE_SHIFT;
+	int i, j, k;
+	void **pointers;
+	void *q_ptr = NULL, *p_ptr;
+	int dstripe, pstripe, qstripe;
+
+	if (err)
+		atomic_inc(&rmult->multi->error);
+
+	if (!atomic_dec_and_test(&rmult->multi->stripes_pending))
+		return;
+
+	/* OK, we have read all the stripes we need to. */
+	if (atomic_read(&rmult->multi->error)) {
+		bio_endio(rmult->multi->orig_bio, -EIO);
+		goto cleanup;
+	}
+
+	pointers = kmalloc(rmult->multi->num_stripes * sizeof(void *), GFP_ATOMIC);
+	BUG_ON(!pointers); /* FIXME */
+
+	for (i = 0; i < nr_pages; i++) {
+		p_ptr = q_ptr = NULL;
+		k = 0;
+		for (j = 0; j < rmult->multi->num_stripes; j++) {
+			struct bio *bio = rmult->bio[j];
+			if (!bio)
+				bio = rmult->multi->orig_bio;
+
+			/* Is this always a valid assumption? */
+			BUG_ON(bio->bi_io_vec[i].bv_len != PAGE_SIZE);
+			BUG_ON(bio->bi_io_vec[i].bv_offset);
+			
+			/* FIXME: Would be nice to kmap here so that we can allow highmem
+			   pages, but since we're in end_io context it would need to be
+			   kmap_atomic, and there are an arbitrary number of pages... */
+			if (rmult->raid_map[j] == RAID5_P_STRIPE)
+				p_ptr = phys_to_virt(page_to_phys(bio->bi_io_vec[i].bv_page));
+			else if (rmult->raid_map[j] == RAID6_Q_STRIPE)
+				q_ptr = phys_to_virt(page_to_phys(bio->bi_io_vec[i].bv_page));
+			else
+				pointers[k++] = phys_to_virt(page_to_phys(bio->bi_io_vec[i].bv_page));
+		}
+		if (q_ptr) {
+			pointers[k++] = p_ptr;
+			if (q_ptr)
+				pointers[k++] = q_ptr;
+			BUG_ON(k != j);
+
+			raid6_call.gen_syndrome(rmult->multi->num_stripes,
+						PAGE_SIZE, pointers);
+		} else {
+			memset(p_ptr, 0, PAGE_SIZE);
+			for (j = 0; j < PAGE_SIZE; j += sizeof(unsigned long)) {
+				for (k = 0; k < rmult->multi->num_stripes - 1; k++) {
+					*(unsigned long *)(p_ptr + j) ^=
+						*(unsigned long *)(pointers[k] + j);
+				}
+			}
+		}
+		/* kunmap pages here */
+	}
+	kfree(pointers);
+
+	/* Now, submit the P and Q blocks as well as the original write */
+	/* Find which data stripe the original write goes to */
+
+	dstripe = pstripe = qstripe = -1;
+	for (i = 0; i < rmult->multi->num_stripes; i++) {
+		if (!rmult->bio[i])
+			dstripe = i;
+		else if (rmult->raid_map[i] == RAID5_P_STRIPE)
+			pstripe = i;
+		else if (rmult->raid_map[i] == RAID6_Q_STRIPE)
+			qstripe = i;
+	}
+
+	atomic_set(&rmult->multi->stripes_pending, (qstripe == -1)?2:3);
+
+	rmult->bio[pstripe]->bi_sector = rmult->multi->stripes[pstripe].physical >> 9;
+	rmult->bio[pstripe]->bi_private = rmult;
+	rmult->bio[pstripe]->bi_end_io = raid_write_end_io;
+	schedule_bio(rmult->root, rmult->multi->stripes[pstripe].dev, WRITE,
+		     rmult->bio[pstripe]);
+
+	if (qstripe != -1) {
+		rmult->bio[qstripe]->bi_sector = rmult->multi->stripes[qstripe].physical >> 9;
+		rmult->bio[qstripe]->bi_private = rmult;
+		rmult->bio[qstripe]->bi_end_io = raid_write_end_io;
+		schedule_bio(rmult->root, rmult->multi->stripes[qstripe].dev, WRITE,
+			     rmult->bio[qstripe]);
+	}
+
+	rmult->multi->orig_bio->bi_sector = rmult->multi->stripes[dstripe].physical >> 9;
+	rmult->multi->orig_bio->bi_private = rmult;
+	rmult->multi->orig_bio->bi_end_io = raid_write_end_io;
+	schedule_bio(rmult->root, rmult->multi->stripes[dstripe].dev, WRITE,
+		     rmult->multi->orig_bio);
+
+	return;
+
+ cleanup:
+	for (i = 0; i < rmult->multi->num_stripes; i++) {
+		if (!rmult->bio[i])
+			continue;
+		for (j = 0; j < nr_pages; j++) {
+			__free_page(rmult->bio[i]->bi_io_vec[j].bv_page);
+		}
+		bio_put(rmult->bio[i]);
+	}
+	kfree(rmult->raid_map);
+	kfree(rmult->multi);
+	kfree(rmult);
+	mutex_unlock(&raid_hack_mutex);
+}
+
+static struct bio *alloc_raid_stripe_bio(struct btrfs_bio_stripe *stripe,
+					 u64 len)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_NOFS, len >> PAGE_SHIFT?:1);
+	if (!bio)
+		return NULL;
+
+	bio->bi_size = 0;
+	bio->bi_bdev = stripe->dev->bdev;
+	bio->bi_sector = stripe->physical >> 9;
+
+	while (len) {
+		int this = min_t(u64, len, PAGE_SIZE);
+		struct page *page = alloc_page(GFP_NOFS);
+		if (!page || bio_add_page(bio, page, this, 0) < this) {
+			if (page)
+				__free_page(page);
+			/* FIXME free pages attached to it */
+			bio_put(bio);
+			return NULL;
+		}
+		len -= this;
+	}
+	return bio;
+}
+
+static int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
+			       int async, struct btrfs_multi_bio *multi,
+			       u64 *raid_map, u64 stripe_len)
+{
+	int i;
+	int start_ofs, end_ofs;
+	int stripes_to_read = 0;
+	u64 logical = (u64)bio->bi_sector << 9;
+
+	struct btrfs_raid_multi_bio *rmult;
+
+	rmult = kzalloc(sizeof(*rmult) + multi->num_stripes * sizeof(void *),
+			GFP_NOFS);
+	if (!rmult) {
+		kfree(raid_map);
+		kfree(multi);
+		return -ENOMEM;
+	}
+	rmult->multi = multi;
+	rmult->raid_map = raid_map;
+	rmult->root = root;
+
+	/*
+	 * FIXME: the merge_bio_hook logic currently ensures that writes only
+	 * cover one stripe, meaning we _always_ have to read the other data
+	 * stripes to generate the parity (unless we have the minimum number
+	 * of disks. We want to avoid that read/modify/write cycle somehow by
+	 * ensuring that the file system submits writes that cover a full
+	 * stripe-set.
+	 *
+	 * When we achieve that, we'll want to split the original write bio
+	 * into its individual stripes here (which means that the parity
+	 * calculation code doesn't have to be _completely_ rewritten.) 
+	 *
+	 * And we can ditch this mutex too:
+	 */
+	mutex_lock(&raid_hack_mutex);
+
+	/* What subrange of the stripe are we writing? */
+	start_ofs = do_div(logical, stripe_len);
+	end_ofs = start_ofs + bio->bi_size;
+	BUG_ON(end_ofs > stripe_len);
+
+	/* Allocate bios for reading and for the parity and q-stripe writes */
+	logical = (u64)bio->bi_sector << 9;
+	for (i = 0; i < multi->num_stripes; i++) {
+		if (start_ofs) {
+			if (!is_parity_stripe(raid_map[i]))
+				raid_map[i] += start_ofs;
+			multi->stripes[i].physical += start_ofs;
+		}
+		if (raid_map[i] == logical) {
+			/* Set the correct bdev for the original write bio */
+			bio->bi_bdev = multi->stripes[i].dev->bdev;
+		} else {
+			rmult->bio[i] = alloc_raid_stripe_bio(&multi->stripes[i],
+							      bio->bi_size);
+			BUG_ON(!rmult->bio[i]); /* FIXME */
+			rmult->bio[i]->bi_private = rmult;
+
+			if (!is_parity_stripe(raid_map[i]))
+				stripes_to_read++;
+		}
+	}
+	if (!stripes_to_read) {
+		/* Nothing to read -- just calculate parity and write it all */
+		atomic_set(&multi->stripes_pending, 1);
+		bio->bi_private = rmult;
+		raid_read_end_io(bio, 0);
+		return 0;
+	}
+
+	atomic_set(&multi->stripes_pending, stripes_to_read);
+	for (i = 0; i < multi->num_stripes; i++) {
+		if (rmult->bio[i] && !is_parity_stripe(raid_map[i])) {
+			rmult->bio[i]->bi_end_io = raid_read_end_io;
+			if (async)
+				schedule_bio(root, multi->stripes[i].dev, READ, rmult->bio[i]);
+			else
+				submit_bio(READ, rmult->bio[i]);
+		}
+	}
+	return 0;
+}
+
+static int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
+				 int async, struct btrfs_multi_bio *multi,
+				 u64 *raid_map, u64 stripe_len, int mirror_num)
+{
+	WARN_ON(1);
+	kfree(multi);
+	kfree(raid_map);
+	bio_endio(bio, -EIO);
+	return 0;
+}
+
-- 
1.6.2.2


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

