From: jim owens <jowens@hp.com>
Subject: [RFC] Early look at btrfs directIO read code
Date: Mon, 24 Aug 2009 08:19:10 -0400
Message-ID: <4A92853E.8010800@hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020005050001060107010308"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020005050001060107010308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is my still-working-on-it code for btrfs directIO read.

I'm posting it so people can see the progress being made on
the project and can take an early shot at telling me this is
just a bad idea and I'm crazy if they want to, or point out
where I made some stupid mistake with btrfs core functions.

The code is not complete and *NOT* ready for review or testing.

I looked at fs/direct-io.c and the existing btrfs cached-io
routines for a long time and decided I could just not make the
special features of btrfs work well through the common dio code.

My design places all btrfs directIO inside btrfs below the
vfs layer.  Note that my current code is based on the .31
address_space_operations, which Jens is changing.  To avoid
conflicts, I might hook at the file_operations .aio_read which
may make more sense anyway if btrfs is doing its own thing.

Aside from being completely inside btrfs, the unique part of
this design is it is extent based and all the flow is done to
optimize for the way I think btrfs handles extents.

-- what seems to work now (under ideal conditions) ---

   * 1 simple disk volume
   * synchronous reads of uncompressed data extents
   * synchronous reads of uncompressed inline data
   * sparse files

-- what is in the code but completely untested ---

   * multiple disks (btrfs raid)
   * AIO

-- what I intend to do next (in order) ---

   1. compressed data
   2. checksum validation
   3. load-spreading on multiple copies
   4. retry on error with multiple copies
   5. cleanup/refactor

As I find things don't work as I thought, I'm making many code
changes so expect ugly and inconsistent until I finish it all.

A final warning that I have not run any of the test suites
I would normally run before sending code like this out.  So
trying it could produce hard-hangs or filesystem corruption.

jim

[PATCH] small changes to existing files to add direct IO read

---
  fs/btrfs/Makefile |    2 +-
  fs/btrfs/inode.c  |    7 ++-----
  2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index a35eb36..5cbe798 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -7,4 +7,4 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o 
root-tree.o dir-item.o \
  	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
  	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
  	   export.o tree-log.o acl.o free-space-cache.o zlib.o \
-	   compression.o delayed-ref.o relocation.o
+	   compression.o delayed-ref.o relocation.o dio.o
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 272b9b2..835bde3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4308,12 +4308,9 @@ out:
  	return em;
  }

-static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
+extern ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
  			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
-{
-	return -EINVAL;
-}
+			unsigned long nr_segs);

  static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info 
*fieinfo,
  		__u64 start, __u64 len)
-- 
1.5.6.3

=======================
fs/btrfs/dio.c attached
=======================

--------------020005050001060107010308
Content-Type: text/x-csrc;
 name="dio.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dio.c"

/*
 * (c) Copyright Hewlett-Packard Development Company, L.P., 2009
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License v2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 021110-1307, USA.
 */

#include <linux/bitops.h>
#include <linux/slab.h>
#include <linux/bio.h>
#include <linux/mm.h>
#include <linux/gfp.h>
#include <linux/pagemap.h>
#include <linux/page-flags.h>
#include <linux/module.h>
#include <linux/spinlock.h>
#include <linux/blkdev.h>
#include <linux/swap.h>
#include <linux/writeback.h>
#include <linux/pagevec.h>

#include "extent_io.h"
#include "extent_map.h"
#include "compat.h"
#include "ctree.h"
#include "btrfs_inode.h"
#include "volumes.h"

/* FIXME remove when david's patches go in */
#define BTRFS_BLOCK_GROUP_RAID5 (1 << 7)
#define BTRFS_BLOCK_GROUP_RAID6 (1 << 8)
	
/* FIXME struct map_lookup copied from volumes.c, move to volumes.h */
struct map_lookup {
	u64 type;
	int io_align;
	int io_width;
	int stripe_len;
	int sector_size;
	int num_stripes;
	int sub_stripes;
	struct btrfs_bio_stripe stripes[];
};

struct btrfs_dio_dev {
	u64 base;
	u64 physical;
	int vecs;
	struct bio *bio;
	struct block_device *bdev;
};

struct btrfs_diocb {
	/* args passed into btrfs_direct_IO */
	struct kiocb *kiocb;
	const struct iovec *iov;	/* updated current iov */
	u64 start;			/* updated loff_t offset */
	unsigned long nr_segs;		/* updated remaining vectors */
	int rw;

	/* from btrfs_direct_IO */
	u64 end;
	ssize_t return_count;
	struct inode *inode;
	size_t iov_left;		/* bytes remaining in *iov */
	int maxpages;			/* gup limit for **pagelist */

	int maxdevs;			/* space in *devlist */
	struct page **pagelist;
	struct btrfs_dio_dev *devlist;
	u64 stripe_len;
	int copies;
	int parts;
	int skew;

	int compressed;
	int reap_bios;
	int error;

	spinlock_t bio_lock;		/* protects the following */
	int pending_bios;
	int finished_bios;
	struct bio *tail_done_bios;
	struct bio *error_bio;
	struct task_struct *waiter;

	struct btrfs_work work;		/* aio completion handling */
};

static ssize_t btrfs_wait_directIO(struct btrfs_diocb *diocb, int first_error);

static int btrfs_write_directIO(struct btrfs_diocb *diocb);
static int btrfs_read_directIO(struct btrfs_diocb *diocb);
static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
	struct extent_map *lem, u64 data_len);
static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len);
static int btrfs_dio_raid_list(struct btrfs_diocb *diocb,
	struct map_lookup *map);
static int btrfs_dio_read_stripes(struct btrfs_diocb *diocb,
	int first, long rd_stripe, u64 rd_len);
static int btrfs_dio_hole_read(struct btrfs_diocb *diocb, u64 hole_len);
static int btrfs_dio_add_temp_pages(long *dev_left,
	struct btrfs_diocb *diocb, struct btrfs_dio_dev *device);
static int btrfs_dio_add_user_pages(long *dev_left,
	struct btrfs_diocb *diocb, struct btrfs_dio_dev *device);
static int btrfs_dio_new_bio(struct btrfs_diocb *diocb,
	struct btrfs_dio_dev *device);
static void btrfs_dio_submit_bio(struct btrfs_diocb *diocb,
	struct btrfs_dio_dev *device);
static int btrfs_dio_complete_bios(struct btrfs_diocb *diocb);
static int btrfs_dio_copy_to_user(struct btrfs_diocb *diocb, u64 user_len,
	struct extent_buffer *eb, unsigned long inline_start);
static void btrfs_dio_aio_complete(struct btrfs_work *work);


ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
			const struct iovec *iov, loff_t offset,
			unsigned long nr_segs)
{
	int seg;
	ssize_t done;
	unsigned block_mask;
	struct btrfs_diocb *diocb;
	struct inode *inode = kiocb->ki_filp->f_mapping->host;

	/* FIXME ??? s_blocksize is 4096, if we want to allow
	 * programs to read at device sector boundaries, we need
	 * max_sector_size(dev1,dev2,...) stashed somewhere.
	 * however, != 4096 may not be a good idea for writing
	 * so maybe it is better to just say no to 512 byte. 
	 */

	block_mask = inode->i_sb->s_blocksize - 1;

	if (offset & block_mask)
		return -EINVAL;

	/* check memory alignment, blocks cannot straddle pages */
	for (seg = 0; seg < nr_segs; seg++) {
		if ((unsigned long)iov[seg].iov_base & block_mask)
			return -EINVAL;
		if (iov[seg].iov_len & block_mask)
			return -EINVAL;
	}

	/* no write code here so fall back to buffered writes */
	if (rw == WRITE)
		return 0;

	diocb = kzalloc(sizeof(*diocb), GFP_NOFS);
	if (!diocb)
		return -ENOMEM;

	diocb->rw = rw;
	diocb->kiocb = kiocb;
	diocb->iov = iov;
 	diocb->start = offset;
	diocb->return_count = 0;
	diocb->end = offset + kiocb->ki_left - 1;
	diocb->nr_segs = nr_segs;
	diocb->iov_left = iov[0].iov_len;
	diocb->inode = inode;

	diocb->maxpages = 64; /* FIXME ??? from fs/direct_io.c */
	diocb->reap_bios = 64; /* FIXME ??? from fs/direct_io.c */

	spin_lock_init(&diocb->bio_lock);

	/* FIXME if I never resize/free the array, just put in diocb */
	diocb->pagelist = kzalloc(sizeof(**diocb->pagelist) *
				diocb->maxpages, GFP_NOFS);	
	if (!diocb->pagelist)
		done = -ENOMEM;
	else if (diocb->rw == READ)
		done = btrfs_read_directIO(diocb);
	else
		done = btrfs_write_directIO(diocb);

	done = btrfs_wait_directIO(diocb, done);

	if (done != -EIOCBQUEUED) {
		kfree(diocb->pagelist);
		kfree(diocb->devlist);
		kfree(diocb);
	}

	return done;
}

static ssize_t btrfs_wait_directIO(struct btrfs_diocb *diocb, int first_error)
{
	ssize_t ret;
	int err1;
	int err2 = 0;

	/* clean up already done bios even for aio */
	err1 = btrfs_dio_complete_bios(diocb);

	spin_lock_irq(&diocb->bio_lock);

	if (diocb->pending_bios) {
		if (is_sync_kiocb(diocb->kiocb)) {
			diocb->waiter = current;
			__set_current_state(TASK_UNINTERRUPTIBLE);
			spin_unlock_irq(&diocb->bio_lock);
			io_schedule();
			err2 = btrfs_dio_complete_bios(diocb);
		} else {
			/* must have a process context for aio complete */
			diocb->work.func = btrfs_dio_aio_complete;
			btrfs_set_work_high_prio(&diocb->work);
			err2 = -EIOCBQUEUED;
		}
	} else if (diocb->finished_bios) {
		spin_unlock_irq(&diocb->bio_lock);
		err2 = btrfs_dio_complete_bios(diocb);
	} else {
		spin_unlock_irq(&diocb->bio_lock);
	}

	if (err2 == -EIOCBQUEUED) {
		ret = err2;
	} else if (diocb->return_count)
		ret = diocb->return_count;
	else if (first_error)
 		ret = first_error;
	else
		ret = err1 ? err1 : err2;

	return ret;
}

static int btrfs_write_directIO(struct btrfs_diocb *diocb)
{
	return -EPERM; /* FIXME TODO maybe someday */
}

static int btrfs_read_directIO(struct btrfs_diocb *diocb)
{
	struct extent_io_tree *io_tree = &BTRFS_I(diocb->inode)->io_tree;
	u64 data_len;
	int err = 0; 

	/* FIXME if this does not protect against truncate */
	lock_extent(io_tree, diocb->start, diocb->end, GFP_NOFS);
	data_len = i_size_read(diocb->inode);
	if (!data_len || data_len <= diocb->start) {
		err = -EIO; /* FIXME how to report past EOF */
		goto fail;
	}

	if (data_len <= diocb->end) {
		unlock_extent(io_tree, data_len, diocb->end, GFP_NOFS);
		diocb->end = data_len - 1;
	}

	while (diocb->end >= diocb->start) {
		struct extent_map *em;
		u64 len = diocb->end - diocb->start + 1;

		em = btrfs_get_extent(diocb->inode, NULL, 0,
			diocb->start, len, 0);
		if (!em) {
			err = -EIO; /* FIXME what does failure mean */
			goto fail;
		}

		if (em->block_start == EXTENT_MAP_INLINE) {
			data_len = len;
			err = btrfs_dio_inline_read(diocb, &data_len);
		} else {
			data_len = min(len,
				em->len - (diocb->start - em->start));

			if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
					em->block_start == EXTENT_MAP_HOLE)
				err = btrfs_dio_hole_read(diocb, data_len);
			else
				err = btrfs_dio_extent_read(diocb,
					em, data_len);
		}

		free_extent_map(em);
		if (err)
			goto fail;
		unlock_extent(io_tree, diocb->start,
			diocb->start + data_len-1, GFP_NOFS);

		diocb->start += data_len;
	}

	return err;

fail:
	unlock_extent(io_tree, diocb->start, diocb->end, GFP_NOFS);
	return err;
}

/* called with a hard-sector bounded file byte data start/len
 * which covers areas of disk data.  it might not... be contiguous,
 * be on the same device(s), have the same redundancy property.
 * get the extent map per contiguous section and submit bios.
 */
static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
	struct extent_map *lem, u64 data_len)
{
	struct extent_map_tree *em_tree = &BTRFS_I(diocb->inode)->
		root->fs_info->mapping_tree.map_tree;
	u64 data_start = lem->block_start + (diocb->start - lem->start);
	struct extent_map *em;
	int err = -EIO;

	diocb->compressed =
		test_bit(EXTENT_FLAG_COMPRESSED, &lem->flags);

	while (data_len) {
		u64 rd_stripe;
		u64 rd_len;
		u64 first;

		spin_lock(&em_tree->lock);
		em = lookup_extent_mapping(em_tree, data_start, data_len);
		spin_unlock(&em_tree->lock);

		/* em describes 1 contiguous region of same redundancy
		 * that can be on 1 or multiple devices (partitions).
		 * reformat em stripe map info into diocb devlist
		 */
		err = btrfs_dio_raid_list(diocb,
			(struct map_lookup *)em->bdev);
		if (err)
			goto fail;

		rd_stripe = data_start - em->start;
		rd_len = min(data_len, em->len - rd_stripe);
		first = do_div(rd_stripe, diocb->stripe_len);

		/* rd_len is total bytes in all device stripes,
		 * rd_stripe is starting stripe number and
		 * first is begin byte in starting stripe
		 */ 
		err = btrfs_dio_read_stripes(diocb, first,
			rd_stripe, rd_len);
		if (err)
			goto fail;

		free_extent_map(em);
		data_start += rd_len;
		data_len -= rd_len;
	}
	return err;

fail:
	free_extent_map(em);
	return err;
}

static int btrfs_dio_raid_list(struct btrfs_diocb *diocb,
			struct map_lookup *map)
{
	int dvn;
	int parts = map->num_stripes;
	struct btrfs_dio_dev *device;

	if (parts > diocb->maxdevs) {
		kfree(diocb->devlist);
		diocb->devlist = kmalloc(sizeof(*device) *parts, GFP_NOFS);
		if (!diocb->devlist)
			return -ENOMEM;
		diocb->maxdevs = parts;
	}
	for (device = diocb->devlist, dvn = 0;
			dvn < parts; device++, dvn++) { 
		device->base = map->stripes[dvn].physical;
		device->bdev = map->stripes[dvn].dev->bdev;
		device->bio = NULL;
	}

	if (map->type & BTRFS_BLOCK_GROUP_RAID5) {
		diocb->skew = 1;
		diocb->copies = 1;
	} else if (map->type & BTRFS_BLOCK_GROUP_RAID6) {
		diocb->skew = 2;
		diocb->copies = 1;
	} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
		/* FIXME ???? is this correct */
		diocb->skew = 0;
		diocb->copies = map->sub_stripes;
		parts /= map->sub_stripes;
	} else if (!(map->type & BTRFS_BLOCK_GROUP_RAID0)) {
		/* DUP and RAID1 and simple disk */
		diocb->skew = 0;
		diocb->copies = map->num_stripes;
		parts = 1;
	}

	diocb->parts = parts;
	diocb->stripe_len = map->stripe_len;
	return 0;
}

/* build and submit bios for multiple devices that describe a raid set.
 * the io may cover physically contiguous raid stripes on a device that
 * are at non-contiguous file offsets and we want to pack these into
 * as few bios as possible.
 */
static int btrfs_dio_read_stripes(struct btrfs_diocb *diocb,
			int first, long rd_stripe, u64 rd_len)
{
	struct btrfs_dio_dev *device;
	int dvn;
	int err = -EIO;

	while (rd_len) {
		int dvn;
		long dev_left;
		long dev_stripe = rd_stripe;

		if (diocb->parts == 1) {
			dev_left = rd_len;
			dvn = 0;
		} else {
			dev_left = min(rd_len, diocb->stripe_len - first);
			dvn = do_div(dev_stripe,
				diocb->parts - diocb->skew);
			/* dev_stripe is offset on dvn */
			if (diocb->skew) {
				/* raid 5/6 parity stripe rotation */
				u64 tmp = dvn + dev_stripe;
				dvn = do_div(tmp, diocb->parts);
			}
		}	

		device = &diocb->devlist[dvn];
		rd_len -= dev_left;
		device->physical = device->base + dev_stripe *
			diocb->stripe_len + first;

		while (dev_left) {
			if (!device->bio) {
				err = btrfs_dio_new_bio(diocb, device);
				if (err)
					goto bailout;
			}

			if (diocb->compressed)
				err = btrfs_dio_add_temp_pages(&dev_left,
					diocb, device);
			else
				err = btrfs_dio_add_user_pages(&dev_left,
					diocb, device);
			if (err)
				goto bailout;

			if (!device->vecs)
				btrfs_dio_submit_bio(diocb, device);
		}

		first = 0;
		rd_stripe++;
	}

bailout:
	for (dvn = 0; dvn < diocb->maxdevs; dvn++) {
		device = &diocb->devlist[dvn];
		if (device && device->bio)
			btrfs_dio_submit_bio(diocb, device);
	}
	return err;
}

static int btrfs_dio_bio_done(struct btrfs_diocb *diocb, struct bio *bio)
{
	struct bio_vec *bvec = bio->bi_io_vec;
	int bio_err = !test_bit(BIO_UPTODATE, &bio->bi_flags);
	int pn;

	bio->bi_private = NULL;

	if (bio_err) {
		if (bio == diocb->error_bio) {
			char buf[BDEVNAME_SIZE];
			printk(KERN_ERR
				"btrfs directIO error %d on %s\n",
				diocb->error, bdevname(bio->bi_bdev, buf));
		}
		/* FIXME try another copy */

		diocb->return_count = 0; /* FIXME for end of good data */
	}

	for (pn = 0; pn < bio->bi_vcnt; pn++) {
		struct page *page = bvec[pn].bv_page;
		/* FIXME ??? should it be left clean on failure */
		if (bio->bi_rw == READ && !PageCompound(page))
			set_page_dirty_lock(page);
		page_cache_release(page);
	}

	bio_put(bio);
	return 0;
}

/* only thing we run in interrupt context */
static void btrfs_dio_bi_end_io(struct bio *bio, int error)
{
	struct btrfs_diocb *diocb = bio->bi_private;
	unsigned long flags;

	spin_lock_irqsave(&diocb->bio_lock, flags);

	if (error && !diocb->error) {
		diocb->error = error;
		diocb->error_bio = bio;
	}

	/* circular single linked for fifo retries */
	if (!diocb->tail_done_bios) {
		bio->bi_private = bio;
	} else {
		bio->bi_private = diocb->tail_done_bios->bi_private;
		diocb->tail_done_bios->bi_private = bio;
	}
	diocb->tail_done_bios = bio;

	diocb->finished_bios++;

 	/* must only set either diocb->waiter or diocb->work.func
	 * (mutually exclusive) after all bios are submitted
	 */
	if (--diocb->pending_bios == 0) {
		if (diocb->work.func)
			btrfs_queue_worker(
				&BTRFS_I(diocb->inode)->root->fs_info->
					endio_workers, &diocb->work);
		else if (diocb->waiter)
			wake_up_process(diocb->waiter);
	}

	spin_unlock_irqrestore(&diocb->bio_lock, flags);
}

static int btrfs_dio_complete_bios(struct btrfs_diocb *diocb)
{
	struct bio *bio;
	int err = 0;

	do {
		spin_lock_irq(&diocb->bio_lock);
		bio = diocb->tail_done_bios;
		if (bio) {
		        struct bio *head = bio->bi_private;
			if (bio == head) {
				diocb->tail_done_bios = NULL;
			} else {
				/* pop off head of fifo chain */ 
				bio->bi_private = head->bi_private;
				bio = head;
			}
			diocb->finished_bios--;
		}
		spin_unlock_irq(&diocb->bio_lock);

		if (bio)
			err = btrfs_dio_bio_done(diocb, bio);
	} while (bio);

	return err;
}

/* processs context worker routine to handle aio completion.
 * our aio end is always deferred from interrupt context so
 * we can handle compressed extents, checksums, and retries
 */
static void btrfs_dio_aio_complete(struct btrfs_work *work)
{
	struct btrfs_diocb *diocb = 
		container_of(work, struct btrfs_diocb, work);
	ssize_t ret;
	int err;
 
	err = btrfs_dio_complete_bios(diocb);

	if (diocb->return_count)
		ret = diocb->return_count;
	else
		ret = err;

	aio_complete(diocb->kiocb, ret, 0);

	/* FIXME only used now in testing */
	if (diocb->waiter)
		wake_up_process(diocb->waiter);

	kfree(diocb->pagelist);
	kfree(diocb->devlist);
	kfree(diocb);
}

static int btrfs_dio_new_bio(struct btrfs_diocb *diocb,
	struct btrfs_dio_dev *device)
{
	int vecs = min(diocb->maxpages, bio_get_nr_vecs(device->bdev));

	device->bio = bio_alloc(GFP_NOFS, vecs);
	if (device->bio == NULL)
		return -ENOMEM;

	device->vecs = vecs;
	device->bio->bi_bdev = device->bdev;
	device->bio->bi_sector = device->physical >> 9;
	device->bio->bi_private = diocb;
	device->bio->bi_end_io = &btrfs_dio_bi_end_io;

	/* no need to be exact on reaping so no locking */
	if (diocb->finished_bios > diocb->reap_bios)
		return btrfs_dio_complete_bios(diocb);	
	return 0;
}

static void btrfs_dio_submit_bio(struct btrfs_diocb *diocb,
	struct btrfs_dio_dev *device)
{
	if (!device->bio->bi_vcnt) {
		bio_put(device->bio);
		device->bio = NULL;
		return;
	}
	bio_get(device->bio);
	submit_bio(diocb->rw, device->bio);
	bio_put(device->bio);
	device->bio = NULL;

	spin_lock_irq(&diocb->bio_lock);
	diocb->pending_bios++;
	spin_unlock_irq(&diocb->bio_lock);
}

/* pin user pages and add to current bio until either
 * bio is full or device read/write length remaining is 0.
 * spans memory segments in multiple io vectors that can
 * begin and end on non-page boundaries, always sector-size aligned.
 * FIXME ??? currently optimized for 1 page == 1 segment but
 * if testing shows multiple pages are commonly physically
 * contiguous, code will change if it improves performance.
 */   
static int btrfs_dio_add_user_pages(long *dev_left,
	struct btrfs_diocb *diocb, struct btrfs_dio_dev *device)
{
	while (device->vecs && *dev_left) {
		struct page **pglist = diocb->pagelist;
		unsigned long addr = (unsigned long)diocb->iov->iov_base +
			(diocb->iov->iov_len - diocb->iov_left);
		unsigned int offset = addr & (PAGE_SIZE-1);
		int pages = min_t(long, min(diocb->maxpages, device->vecs),
			(min_t(long, *dev_left, offset + diocb->iov_left) +
				PAGE_SIZE-1) / PAGE_SIZE);

		pages = get_user_pages_fast(addr, pages, 1, pglist);
		if (pages <= 0) {
			WARN_ON(!pages); /* must be code bug */
			return pages ? pages : -ERANGE;
		}

		while (pages) {
			unsigned int pglen = min_t(long, *dev_left,
				min(PAGE_SIZE - offset, diocb->iov_left));

			if (!bio_add_page(device->bio, *pglist,
						pglen, offset)) {
				/* unlikely but not impossible, since we
				 * should have few excess just release
				 * and get them again with new bio
				 */
				device->vecs = 0;
				for (; pages; pages--, pglist++)
					page_cache_release(*pglist);
				return 0;
			}
			pages--;
			offset = 0;
			pglist++;
			diocb->iov_left -= pglen;
			*dev_left -= pglen;
			device->physical += pglen;
			device->vecs--;
			diocb->return_count += pglen;
		}

		if (!diocb->iov_left && diocb->nr_segs) {
			diocb->nr_segs--;
			diocb->iov++;
			diocb->iov_left = diocb->iov->iov_len;
		}
	}

	return 0;
}

static int btrfs_dio_hole_read(struct btrfs_diocb *diocb, u64 hole_len)
{
	return btrfs_dio_copy_to_user(diocb, hole_len, NULL, 0);
}

static int btrfs_dio_copy_to_user(struct btrfs_diocb *diocb, u64 user_len,
	struct extent_buffer *eb, unsigned long inline_start)
{
	while (user_len) {
		struct page **pglist = diocb->pagelist;
		unsigned long addr = (unsigned long)diocb->iov->iov_base +
			(diocb->iov->iov_len - diocb->iov_left);
		unsigned int offset = addr & (PAGE_SIZE-1);
		int pages = min_t(long, diocb->maxpages,
			(min_t(u64, user_len, offset + diocb->iov_left) +
				PAGE_SIZE-1) / PAGE_SIZE);

		pages = get_user_pages_fast(addr, pages, 1, pglist);
		if (pages <= 0) {
			WARN_ON(!pages); /* must be code bug */
			return pages ? pages : -ERANGE;
		}

		while (pages) {
			unsigned int pglen = min_t(u64, user_len,
				min(PAGE_SIZE - offset, diocb->iov_left));

			char *userpage = kmap_atomic(*pglist, KM_USER0);

			if (!eb) {
				/* called by hole_read */
				memset(userpage + offset, 0, pglen);
			} else {
				/* called by inline_read */
				read_extent_buffer(eb, userpage + offset,
					inline_start, pglen);
				inline_start += pglen;
			}

			kunmap_atomic(userpage, KM_USER0);
			flush_dcache_page(*pglist);
			if (!PageCompound(*pglist))
				set_page_dirty_lock(*pglist);
			page_cache_release(*pglist);

			pages--;
			offset = 0;
			pglist++;
			diocb->iov_left -= pglen;
			user_len -= pglen;
			diocb->return_count += pglen;
		}

		if (!diocb->iov_left && diocb->nr_segs) {
			diocb->nr_segs--;
			diocb->iov++;
			diocb->iov_left = diocb->iov->iov_len;
		}
	}

	return 0;
}

static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
{
	int err;
	size_t size;
	size_t extent_offset;
	u64 extent_start;
	u64 objectid = diocb->inode->i_ino;
	struct btrfs_root *root = BTRFS_I(diocb->inode)->root;
	struct btrfs_path *path;
	struct btrfs_file_extent_item *item;
	struct extent_buffer *leaf;
	struct btrfs_key found_key;

	path = btrfs_alloc_path();

	err = btrfs_lookup_file_extent(NULL, root, path, objectid, diocb->start, 0);
	if (err) {
		/* FIXME WTF do these conditions mean */
		WARN_ON(1);
		if (err < 0)
			goto notfound;
		if (path->slots[0] == 0)
			goto notyet;
		path->slots[0]--;
	}

	leaf = path->nodes[0];
	item = btrfs_item_ptr(leaf, path->slots[0],
			      struct btrfs_file_extent_item);
	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
	if (found_key.objectid != objectid ||
		btrfs_key_type(&found_key) != BTRFS_EXTENT_DATA_KEY ||
		btrfs_file_extent_type(leaf, item) != BTRFS_FILE_EXTENT_INLINE) {
		/* FIXME WTF corruption ??? */
		WARN_ON(1);
		err= -EDOM;
		goto notyet;
	}

	extent_start = found_key.offset;
	size = btrfs_file_extent_inline_len(leaf, item);
	if (diocb->start < extent_start || diocb->start >= extent_start + size) {
		/* FIXME WTF corruption ??? */
		WARN_ON(1);
		err= -EDOM;
		goto notyet;
	}

	extent_offset = diocb->start - extent_start;

	if (btrfs_file_extent_compression(leaf, item) ==
						BTRFS_COMPRESS_ZLIB) {
		/* FIXME still on the TODO list */
		err= -EPERM;
		goto notyet;
	} else {
		unsigned long inline_start;
		inline_start = btrfs_file_extent_inline_start(item)
				+ extent_offset;

		*data_len = min_t(u64, *data_len, size);
		err = btrfs_dio_copy_to_user(diocb, *data_len,
			leaf, inline_start);
	}

notyet:
	btrfs_release_path(root, path);
notfound:
	btrfs_free_path(path);
	return err;
}

/* submit kernel temporary pages for compressed read */  
static int btrfs_dio_add_temp_pages(long *dev_left,
	struct btrfs_diocb *diocb, struct btrfs_dio_dev *device)
{
	return -EPERM; /* FIXME TODO */
}


--------------020005050001060107010308--
