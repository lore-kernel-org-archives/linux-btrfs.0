From: jim owens <jowens@hp.com>
Subject: Re: [RFC] Early look at btrfs directIO read code
Date: Wed, 02 Sep 2009 17:48:01 -0400
Message-ID: <4A9EE811.6040508@hp.com>
References: <4A92853E.8010800@hp.com> <4A92D493.3070804@hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040806090700060405080709"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A92D493.3070804@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040806090700060405080709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Still not ready for review or for anyone else to try it,
this V2 update fixes the bugs I have found in my testing.

New things that now seem to work:

* multiple disks (btrfs raid 0,1,10,5,6)

* AIO

* multiple buffer vectors

* files that are not a multiple of 512 bytes

jim

=======================
fs/btrfs/dio.c attached
=======================

--------------040806090700060405080709
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
	unsigned int iosize;	/* size of hard sector */
	int vecs;
	int unplug;
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
	 * An alternative is to just use 512 here and if they
	 * have a larger sector disk, the code will detect it
	 * is unaligned in btrfs_dio_read_stripes and error out.
	 */

	block_mask = inode->i_sb->s_blocksize - 1;
	block_mask = 511; /* FIXME see above - TESTING HACK */

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
			spin_unlock_irq(&diocb->bio_lock);
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
		device->iosize = bdev_logical_block_size(device->bdev);
		device->unplug = 0;
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

static void btfrs_dio_unplug(struct btrfs_diocb *diocb)
{
	int dvn;

	for (dvn = 0; dvn < diocb->parts; dvn++) {
		struct btrfs_dio_dev *device =
			&diocb->devlist[dvn];
		if (device->bio)
			btrfs_dio_submit_bio(diocb, device);
		/* FIXME ??? is this needed or a waste of time */
		if (device->unplug) {
			struct backing_dev_info *bdi =
				blk_get_backing_dev_info(device->bdev);
			if (bdi && bdi->unplug_io_fn)
				bdi->unplug_io_fn(bdi, NULL);
		}
	}
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

		/* FIXME ??? btrfs extents are in bytes so they could
		 * start and end inside device sectors, code currently
		 * does not support starting inside a sector and supports
		 * only the final extent ending before the sector end
		 */
		if ((device->physical & (device->iosize-1)) ||
				((unsigned long)diocb->iov->iov_base +
				(diocb->iov->iov_len - diocb->iov_left))
				& (device->iosize-1)) {
			err = -ENOTBLK;
			WARN_ONCE(1,"Btrfs - Unaligned extent in directIO");
			goto bailout;
		}

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
	btfrs_dio_unplug(diocb);
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

 	/* must only set diocb->waiter or diocb->work.func
	 * after all bios are submitted
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
	device->unplug++;

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
			/* FIXME ??? deals with the problem that a btrfs
			 * extent length is not a device sector multiple
			 * but devices only transfer full sectors.  It will
			 * only work now if there is no following extent as
			 * then we would overwrite some memory with 2 bios.
			 * note - iov always device sector size multiple
			 * so page will have space for full sector.
			 * FIXME too ??? tail of partial sector must be
			 * written as 0 or we will leak data unless we
			 * do the read into a kernel buffer and copy out.
			 */
			unsigned int pglen = min_t(long, *dev_left,
				min(PAGE_SIZE - offset, diocb->iov_left));
			unsigned int block_len = pglen & (device->iosize - 1)
				? (pglen & -device->iosize) + device->iosize
				: pglen;

			if (!bio_add_page(device->bio, *pglist,
						block_len, offset)) {
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


--------------040806090700060405080709--
