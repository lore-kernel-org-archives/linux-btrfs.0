From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 17/18] Btrfs: Full direct I/O and AIO read implementation.
Date: Sun, 21 Mar 2010 23:34:59 -0400
Message-ID: <4BA6E563.4090206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/dio.c | 2001 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 2001 insertions(+), 0 deletions(-)
 create mode 100644 fs/btrfs/dio.c

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
new file mode 100644
index 0000000..c930ff5
--- /dev/null
+++ b/fs/btrfs/dio.c
@@ -0,0 +1,2001 @@
+/*
+ * (c) Copyright Hewlett-Packard Development Company, L.P., 2009
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/bitops.h>
+#include <linux/slab.h>
+#include <linux/bio.h>
+#include <linux/mm.h>
+#include <linux/mmu_context.h>
+#include <linux/gfp.h>
+#include <linux/pagemap.h>
+#include <linux/page-flags.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/swap.h>
+#include <linux/writeback.h>
+#include <linux/pagevec.h>
+
+#include "extent_io.h"
+#include "extent_map.h"
+#include "compat.h"
+#include "ctree.h"
+#include "btrfs_inode.h"
+#include "volumes.h"
+#include "compression.h"
+#include "disk-io.h"
+
+
+/* per-stripe working info while building and submitting I/O */
+struct btrfs_dio_dev {
+	u64 physical;		/* byte number on device */
+	int vecs;		/* number of unused bio_vecs in bio */
+	int unplug;		/* bios were submitted so issue unplug */
+	struct bio *bio;
+};
+
+/* modified working copy that describes current state of user memory
+ * remaining to submit I/O on, or on I/O completion the area of user
+ * memory that applies to the uncompressed extent.
+ */
+struct btrfs_dio_user_mem_control {
+	const struct iovec *user_iov;	/* user input vector being processed */
+	struct iovec work_iov;		/* updated base/len for part not done */
+	long remaining;			/* total user input memory left */
+	long todo;			/* user mem applicable to extent part */
+	int next_user_page;		/* gup */
+	int user_pages_left;		/* gup */
+	int gup_max;			/* gup */
+	struct page **pagelist;		/* gup */
+};
+
+/* max bios that we can process in one extent - minimum 32 for compression */
+#define MAX_STRIPE_SEGMENTS 32
+#define CSUM_RESERVE_SEGMENTS 1
+
+/* per-physical-extent submit/completion processing info */
+struct btrfs_dio_extcb {
+	struct btrfs_dio_extcb *next;
+	struct btrfs_diocb *diocb;
+
+	struct extent_map *em;		/* chunk stripe map for this extent */
+	/* active_umc is diocb.umc in submit and extcb.umc in completion */
+	struct btrfs_dio_user_mem_control *active_umc;
+	struct btrfs_dio_user_mem_control umc;
+	struct extent_buffer *leaf;
+
+	struct btrfs_inflate icb;	/* extent decompression processing */
+
+	u64 filestart;
+	u64 iostart;
+	u32 iolen;
+	u32 filetail;
+	u32 beforetail;
+
+	u64 lockstart;
+	u64 lockend;
+
+	int compressed;
+	int stripes;
+	int error;
+	int pending_bios;
+	int shortread;
+	int retry_mirror;
+	u32 retry_len;
+	u32 retry_csum;
+	u64 retry_start;
+	struct bio *retry_bio;
+
+	char *tmpbuf;			/* for fetching range of checksums */
+	int tmpbuf_size;
+
+	int bo_used;			/* order[] bio entries in use */
+	int bo_now;			/* order[bo_now] being completed */
+	int bo_bvn;			/* order[bo_now] bi_io_vec */
+	int bo_frag;			/* bv_len unfinished on error */
+
+	struct page *csum_pg1;		/* temp read area for unaligned I/O */
+	struct page *csum_pg2;		/* may need two for head and tail */
+	struct bio *order[MAX_STRIPE_SEGMENTS + CSUM_RESERVE_SEGMENTS];
+	struct btrfs_dio_dev diodev[];	/* array size based on stripes */
+};
+
+#define GUP_IOSUBMIT_MAX 64		/* same as fs/direct-io.c */
+#define GUP_IODONE_MAX 33		/* unaligned inflate 128k + 1 page */
+
+/* single master control for user's directIO request */
+struct btrfs_diocb {
+	/* coordinate all submit, I/O interrupt, reaping, completion threads */
+	spinlock_t diolock;
+	struct kiocb *kiocb;
+	struct inode *inode;
+	u64 start;			/* current submit file position */
+	u64 end;
+	u64 lockstart;
+	u64 begin;			/* original beginning file position */
+	u64 terminate;			/* fpos after submit/completion */
+
+	struct btrfs_dio_user_mem_control umc;
+	struct workspace *workspace;
+	char *csum_buf;
+
+	u32 alignment;
+	int rw;
+	int error;
+	int sleeping;
+	int reaping;
+	int pending_extcbs;
+	struct btrfs_dio_extcb *done_extcbs;
+
+	struct mm_struct *user_mm;	/* workers assume state of user task */
+	struct task_struct *waiter;	/* final completion processing */
+	struct btrfs_work submit;	/* submit and finish thread for aio */
+	struct btrfs_work reaper;	/* completion handling during submit */
+
+	struct page *gup_iosubmit_pages[GUP_IOSUBMIT_MAX];
+	struct page *gup_iodone_pages[GUP_IODONE_MAX];
+};
+
+static void btrfs_dio_reaper(struct btrfs_work *work);
+static void btrfs_dio_aio_submit(struct btrfs_work *work);
+static ssize_t btrfs_dio_wait(struct btrfs_diocb *diocb);
+static void btrfs_dio_free_diocb(struct btrfs_diocb *diocb);
+static void btrfs_dio_extcb_biodone(struct btrfs_dio_extcb *extcb);
+static void btrfs_dio_bi_end_io(struct bio *bio, int error);
+static void btrfs_dio_write(struct btrfs_diocb *diocb);
+static void btrfs_dio_read(struct btrfs_diocb *diocb);
+static int btrfs_dio_new_extcb(struct btrfs_dio_extcb **alloc_extcb,
+			struct btrfs_diocb *diocb, struct extent_map *em);
+static int btrfs_dio_compressed_read(struct btrfs_diocb *diocb,
+				struct extent_map *lem, u64 data_len);
+static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
+				struct extent_map *lem, u64 data_len);
+static void btfrs_dio_unplug(struct btrfs_dio_extcb *extcb);
+static int btrfs_dio_read_stripes(struct btrfs_dio_extcb *extcb,
+				u64 *rd_start, u64 *rd_len, int temp_pages);
+static void btrfs_dio_reset_next_in(struct btrfs_dio_extcb *extcb);
+static void btrfs_dio_get_next_in(struct bio_vec *vec,
+				struct btrfs_dio_extcb *extcb);
+static void btrfs_dio_put_next_in(struct bio_vec *vec,
+				struct btrfs_dio_extcb *extcb);
+static int btrfs_dio_inflate_next_in(struct bio_vec *ivec,
+				struct btrfs_inflate *icb);
+static int btrfs_dio_inline_next_in(struct bio_vec *ivec,
+				struct btrfs_inflate *icb);
+static int btrfs_dio_get_user_bvec(struct bio_vec *uv,
+				struct btrfs_dio_user_mem_control *umc);
+static void btrfs_dio_put_user_bvec(struct bio_vec *uv,
+				struct btrfs_dio_user_mem_control *umc);
+static void btrfs_dio_release_unused_pages(
+				struct btrfs_dio_user_mem_control *umc);
+static void btrfs_dio_skip_user_mem(struct btrfs_dio_user_mem_control *umc,
+				u32 skip_len);
+static int btrfs_dio_get_next_out(struct bio_vec *ovec,
+				struct btrfs_inflate *icb);
+static void btrfs_dio_done_with_out(struct bio_vec *ovec,
+				struct btrfs_inflate *icb);
+static void btrfs_dio_release_bios(struct btrfs_dio_extcb *extcb, int dirty);
+static void btrfs_dio_read_done(struct btrfs_dio_extcb *extcb);
+static void btrfs_dio_decompress(struct btrfs_dio_extcb *extcb);
+static void btrfs_dio_free_extcb(struct btrfs_dio_extcb *extcb);
+static int btrfs_dio_get_workbuf(struct btrfs_dio_extcb *extcb);
+static void btrfs_dio_drop_workbuf(struct btrfs_dio_extcb *extcb);
+static void btrfs_dio_complete_bios(struct btrfs_diocb *diocb);
+static int btrfs_dio_new_bio(struct btrfs_dio_extcb *extcb, int dvn);
+static void btrfs_dio_submit_bio(struct btrfs_dio_extcb *extcb, int dvn);
+static int btrfs_dio_add_user_pages(u64 *dev_left,
+				struct btrfs_dio_extcb *extcb, int dvn);
+static int btrfs_dio_add_temp_pages(u64 *dev_left,
+				struct btrfs_dio_extcb *extcb, int dvn);
+static int btrfs_dio_hole_read(struct btrfs_diocb *diocb, u64 hole_len);
+static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len);
+static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb);
+static void btrfs_dio_free_retry(struct btrfs_dio_extcb *extcb);
+static int btrfs_dio_retry_block(struct btrfs_dio_extcb *extcb);
+static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb);
+
+
+ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
+			const struct iovec *iov, loff_t offset,
+			unsigned long nr_segs)
+{
+	int seg;
+	ssize_t done = 0;
+	struct btrfs_diocb *diocb;
+	struct inode *inode = kiocb->ki_filp->f_mapping->host;
+	u32 alignment = BTRFS_I(inode)->root->sectorsize;
+
+	/* check memory alignment, device blocks cannot straddle pages
+	 * because special hardware (e.g. iommu) is needed for split dma.
+	 * allow 0-length vectors which are questionable but seem legal.
+	 * limit I/O to smaller of request size or available memory.
+	 */
+	alignment |= offset;
+	for (seg = 0; seg < nr_segs && done < kiocb->ki_left; seg++)
+		if (iov[seg].iov_len) {
+			/* alignment only needed through size of I/O */
+			done += iov[seg].iov_len;
+			done = min_t(ssize_t, done, kiocb->ki_left);
+			alignment |= done | (unsigned long)iov[seg].iov_base;
+		}
+
+	/* minimum alignment is smallest logical_block_size of all devices in
+	 * this fs. this check is not enough if there are larger blocksizes
+	 * in the filesystem and we need a larger alignment for this I/O, so
+	 * we retest alignment as we build the bio and fail it at that point.
+	 * aligning here on largest blocksize would be simpler, but it would
+	 * mean applications that were working might fail if the user added a
+	 * larger blocksize device even though none of their file was on it.
+	 */
+	if (alignment &
+	    (BTRFS_I(inode)->root->fs_info->fs_devices->dio_min_blocksize - 1))
+		return -EINVAL;
+
+	/* no write code here so fall back to buffered writes */
+	if (rw == WRITE)
+		return 0;
+
+	diocb = kzalloc(sizeof(*diocb), GFP_NOFS);
+	if (!diocb)
+		return -ENOMEM;
+
+	/* determine minimum user alignment block size across entire I/O
+	 * so we can use it for eof tail handling and testing each device
+	 */
+	diocb->alignment =
+		BTRFS_I(inode)->root->fs_info->fs_devices->dio_min_blocksize;
+	while (!(alignment & diocb->alignment))
+		diocb->alignment *= 2;
+
+	diocb->rw = rw;
+	diocb->kiocb = kiocb;
+	diocb->start = offset;
+	diocb->begin = offset;
+	diocb->terminate = offset + done;
+	diocb->inode = inode;
+
+	diocb->umc.user_iov = iov;
+	diocb->umc.work_iov = *iov;
+	diocb->umc.remaining = done;
+	diocb->umc.gup_max = GUP_IOSUBMIT_MAX;
+	diocb->umc.pagelist = diocb->gup_iosubmit_pages;
+
+	spin_lock_init(&diocb->diolock);
+
+	diocb->user_mm = current->mm;
+	diocb->reaper.func = btrfs_dio_reaper;
+	btrfs_set_work_high_prio(&diocb->reaper);
+
+	if (is_sync_kiocb(diocb->kiocb)) {
+		if (diocb->rw == READ)
+			btrfs_dio_read(diocb);
+		else
+			btrfs_dio_write(diocb);
+		done = btrfs_dio_wait(diocb);
+		btrfs_dio_free_diocb(diocb);
+	} else {
+		diocb->submit.func = btrfs_dio_aio_submit;
+		btrfs_queue_worker(&BTRFS_I(diocb->inode)->root->fs_info->
+				submit_workers, &diocb->submit);
+		done = -EIOCBQUEUED;
+	}
+
+	return done;
+}
+
+/* process context worker routine to handle bio completion
+ * for extents that finish while submitting other extents,
+ * limited to one thread for a dio so we don't hog the cpus
+ */
+static void btrfs_dio_reaper(struct btrfs_work *work)
+{
+	struct btrfs_diocb *diocb =
+		container_of(work, struct btrfs_diocb, reaper);
+
+	use_mm(diocb->user_mm);
+
+	btrfs_dio_complete_bios(diocb);
+
+	spin_lock_irq(&diocb->diolock);
+	diocb->reaping = 0;
+	if (!diocb->pending_extcbs && diocb->sleeping) {
+		diocb->sleeping = 0;
+		wake_up_process(diocb->waiter);
+	}
+	spin_unlock_irq(&diocb->diolock);
+
+	unuse_mm(diocb->user_mm);
+
+	/* return control to btrfs worker pool */
+}
+
+/* process context worker routine to handle aio submit
+ * and final completion callback
+ */
+static void btrfs_dio_aio_submit(struct btrfs_work *work)
+{
+	struct btrfs_diocb *diocb =
+		container_of(work, struct btrfs_diocb, submit);
+	ssize_t done;
+
+	use_mm(diocb->user_mm);
+
+	if (diocb->rw == READ)
+		btrfs_dio_read(diocb);
+	else
+		btrfs_dio_write(diocb);
+
+	done = btrfs_dio_wait(diocb);
+
+	aio_complete(diocb->kiocb, done, 0);
+
+	unuse_mm(diocb->user_mm);
+
+	btrfs_dio_free_diocb(diocb);
+
+	/* return control to btrfs worker pool */
+}
+
+static ssize_t btrfs_dio_wait(struct btrfs_diocb *diocb)
+{
+	ssize_t done;
+
+	spin_lock_irq(&diocb->diolock);
+	diocb->waiter = current;
+
+	/* after reaper terminates, we complete any remaining bios */
+	do {
+		if (diocb->reaping ||
+		    (diocb->pending_extcbs && !diocb->done_extcbs)) {
+			diocb->sleeping = 1;
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			spin_unlock_irq(&diocb->diolock);
+			io_schedule();
+			spin_lock_irq(&diocb->diolock);
+		}
+		spin_unlock_irq(&diocb->diolock);
+		btrfs_dio_complete_bios(diocb);
+		spin_lock_irq(&diocb->diolock);
+	} while (diocb->pending_extcbs || diocb->done_extcbs);
+
+	spin_unlock_irq(&diocb->diolock);
+
+	done = min(diocb->start, diocb->terminate) - diocb->begin;
+	return done ? done : diocb->error;
+}
+
+static void btrfs_dio_free_diocb(struct btrfs_diocb *diocb)
+{
+	if (diocb->workspace)
+		free_workspace(diocb->workspace);
+	kfree(diocb->csum_buf);
+	kfree(diocb);
+}
+
+/* must be called with diocb->diolock held.
+ * performs "all bios are done for extcb" processing
+ * to prevent submit/reap thread race
+ */
+static void btrfs_dio_extcb_biodone(struct btrfs_dio_extcb *extcb)
+{
+	struct btrfs_diocb *diocb = extcb->diocb;
+
+	if (--extcb->pending_bios == 0) {
+		extcb->next = diocb->done_extcbs;
+		diocb->done_extcbs = extcb;
+		if (!diocb->reaping) {
+			if (!diocb->waiter) {
+				diocb->reaping = 1;
+				btrfs_queue_worker(
+					&BTRFS_I(diocb->inode)->root->fs_info->
+					endio_workers, &diocb->reaper);
+			} else if (diocb->sleeping) {
+				diocb->sleeping = 0;
+				wake_up_process(diocb->waiter);
+			}
+		}
+	}
+}
+
+/* only thing we run in interrupt context, bio completion
+ * processing is always deferred from interrupt context so
+ * we can handle compressed extents, checksums, and retries
+ */
+static void btrfs_dio_bi_end_io(struct bio *bio, int error)
+{
+	struct btrfs_dio_extcb *extcb = bio->bi_private;
+	unsigned long flags;
+
+	if (error)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+
+	spin_lock_irqsave(&extcb->diocb->diolock, flags);
+	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		extcb->error = error ? error : -EIO;
+	btrfs_dio_extcb_biodone(extcb);
+	spin_unlock_irqrestore(&extcb->diocb->diolock, flags);
+}
+
+static void btrfs_dio_write(struct btrfs_diocb *diocb)
+{
+}
+
+/* verify that we have locked everything we need to do the read and
+ * have pushed the ordered data into the btree so the extent is valid
+ */
+static void btrfs_dio_safe_to_read(struct btrfs_diocb *diocb,
+				struct extent_map *em, u64 *lockend,
+				u64 *data_len, int *safe_to_read)
+{
+	struct extent_io_tree *io_tree = &BTRFS_I(diocb->inode)->io_tree;
+	struct btrfs_ordered_extent *ordered;
+	u64 stop;
+
+	/* must ensure the whole compressed extent is valid on each loop
+	 * as we don't know the final extent size until we look it up
+	 */
+	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) &&
+	    (diocb->lockstart > em->start || *lockend <= em->start + em->len)) {
+		unlock_extent(io_tree, diocb->lockstart, *lockend, GFP_NOFS);
+		diocb->lockstart = em->start;
+		*lockend = min(*lockend, em->start + em->len - 1);
+		*safe_to_read = 0;
+		return;
+	}
+
+	/* one test on first loop covers all extents if no concurrent writes */
+	if (*safe_to_read)
+		return;
+
+	ordered = btrfs_lookup_first_ordered_extent(diocb->inode,
+			diocb->lockstart, *lockend + 1 - diocb->lockstart);
+	if (!ordered) {
+		*safe_to_read = 1;
+		return;
+	}
+
+	/* we checked everything to lockend which might cover multiple extents
+	 * in the hope that we could do the whole read with one locking. that
+	 * won't happen now, but we can read the first extent (or part of it
+	 * for uncompressed data) if what we need is before this ordered data.
+	 * we must have the whole extent valid to read any compressed data,
+	 * while we can read a single block of valid uncompressed data.
+	 */
+	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
+		stop = em->start + em->len;
+	else
+		stop = diocb->lockstart +
+				BTRFS_I(diocb->inode)->root->sectorsize;
+
+	if (ordered->file_offset < stop) {
+		unlock_extent(io_tree, diocb->lockstart, *lockend, GFP_NOFS);
+		btrfs_start_ordered_extent(diocb->inode, ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+		*safe_to_read = 0;
+		return;
+	}
+
+	/* do the part of the data that is valid to read now with the
+	 * remainder unlocked so that ordered data can flush in parallel
+	 */
+	unlock_extent(io_tree, ordered->file_offset, *lockend, GFP_NOFS);
+	*lockend = ordered->file_offset - 1;
+	*data_len = ordered->file_offset - diocb->start;
+	btrfs_put_ordered_extent(ordered);
+
+	*safe_to_read = 1;
+	return;
+}
+
+static void btrfs_dio_read(struct btrfs_diocb *diocb)
+{
+	struct extent_io_tree *io_tree = &BTRFS_I(diocb->inode)->io_tree;
+	u64 end = diocb->terminate; /* copy because reaper changes it */
+	u64 lockend;
+	u64 data_len;
+	int safe_to_read;
+	int err = 0;
+	u32 blocksize = BTRFS_I(diocb->inode)->root->sectorsize;
+
+	/* expand lock region to include what we read to validate checksum */
+	diocb->lockstart = diocb->start & ~(blocksize - 1);
+	lockend = ALIGN(end, blocksize) - 1;
+
+getlock:
+	/* writeout everything we read for checksum or compressed extents */
+	filemap_write_and_wait_range(diocb->inode->i_mapping,
+				diocb->lockstart, lockend);
+	lock_extent(io_tree, diocb->lockstart, lockend, GFP_NOFS);
+
+	data_len = min_t(u64, end, i_size_read(diocb->inode));
+	if (data_len <= diocb->start) {
+		/* whatever we finished (or 0) is returned past EOF */
+		goto fail;
+	}
+	data_len -= diocb->start;
+
+	safe_to_read = 0;
+	while (data_len && !diocb->error) { /* error in reaper stops submit */
+		struct extent_map *em;
+		u64 len;
+
+		em = btrfs_get_extent(diocb->inode, NULL, 0,
+					diocb->start, data_len, 0);
+		if (IS_ERR(em)) {
+			err = PTR_ERR(em);
+			printk(KERN_ERR
+				"btrfs directIO fail btrfs_get_extent ino %lu "
+				"extent start %llu len %llu error %d\n",
+				diocb->inode->i_ino, diocb->start,
+				data_len, err);
+			goto fail;
+		}
+
+		/* verify extent was locked and ordered data was flushed,
+		 * may change data_len and lockend whether true or false.
+		 */
+		btrfs_dio_safe_to_read(diocb, em, &lockend, &data_len,
+					&safe_to_read);
+		if (!safe_to_read) {
+			free_extent_map(em);
+			goto getlock;
+		}
+
+		len = data_len;
+
+		/* problem flushing ordered data with btree not updated */
+		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
+			printk(KERN_ERR
+				"btrfs directIO extent map incomplete ino %lu "
+				"extent start %llu len %llu\n",
+				diocb->inode->i_ino, diocb->start, len);
+			err = -EIO;
+		} else if (em->block_start == EXTENT_MAP_INLINE) {
+			/* ugly stuff because inline can exist in a large file
+			 * with other extents if a hole immediately follows.
+			 * the inline might end short of the btrfs block with
+			 * an implied hole that we need to zero here.
+			 */
+			u64 expected = min(diocb->start + len,
+						em->start + em->len);
+			err = btrfs_dio_inline_read(diocb, &len);
+			if (!err && expected > diocb->start) {
+				data_len -= len;
+				len = expected - diocb->start;
+				err = btrfs_dio_hole_read(diocb, len);
+			}
+		} else {
+			len = min(len, em->len - (diocb->start - em->start));
+			if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
+			    em->block_start == EXTENT_MAP_HOLE)
+				err = btrfs_dio_hole_read(diocb, len);
+			else if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
+				err = btrfs_dio_compressed_read(diocb, em, len);
+			else
+				err = btrfs_dio_extent_read(diocb, em, len);
+		}
+
+		free_extent_map(em);
+		data_len -= len;
+		if (err)
+			goto fail;
+		cond_resched();
+	}
+
+	/* we might have shortened data_len because of uncommitted
+	 * ordered data, we want to try again to read the remainder
+	 */
+	if (diocb->start < end && !err && !diocb->error) {
+		lockend = ALIGN(end, blocksize) - 1;
+		goto getlock;
+	}
+
+fail:
+	if (err)
+		diocb->error = err;
+
+	/* extent processing routines unlock or keep locked their
+	 * range as appropriate for submitted bios, so we only
+	 * need to unlock the unprocessed remainder
+	 */
+	if (diocb->lockstart <= lockend)
+		unlock_extent(io_tree, diocb->lockstart, lockend, GFP_NOFS);
+}
+
+static int btrfs_dio_new_extcb(struct btrfs_dio_extcb **alloc_extcb,
+			struct btrfs_diocb *diocb, struct extent_map *em)
+{
+	int devices = btrfs_map_stripe_count(em);
+	struct btrfs_dio_extcb *extcb;
+
+	extcb = kzalloc(sizeof(*extcb) +
+			sizeof(struct btrfs_dio_dev) * devices, GFP_NOFS);
+	if (!extcb)
+		return -ENOMEM;
+
+	extcb->em = em;
+	extcb->diocb = diocb;
+	extcb->filestart = diocb->start;
+	extcb->stripes = devices;
+
+	/* need these for completion error/tail processing */
+	extcb->umc.work_iov = diocb->umc.work_iov;
+	extcb->umc.user_iov = diocb->umc.user_iov;
+	extcb->umc.remaining = diocb->umc.remaining;
+
+	/* can use common list because we run 1 completion thread */
+	extcb->umc.gup_max = GUP_IODONE_MAX;
+	extcb->umc.pagelist = diocb->gup_iodone_pages;
+
+	extcb->pending_bios = 1;	/* prevent reaping race */
+	*alloc_extcb = extcb;
+	return 0;
+}
+
+/* compressed data is at most 128kb uncompressed and will be in
+ * one single matching logical->physical extent map that may be
+ * multiple raid stripes. we must read the whole compressed extent
+ * to inflate it, independent of user file data_start and data_len.
+ */
+static int btrfs_dio_compressed_read(struct btrfs_diocb *diocb,
+				struct extent_map *lem, u64 data_len)
+{
+	struct extent_map_tree *em_tree = &BTRFS_I(diocb->inode)->
+		root->fs_info->mapping_tree.map_tree;
+	u64 compressed_start = lem->block_start;
+	u64 compressed_len = lem->block_len;
+	struct extent_map *em;
+	int err;
+	struct btrfs_dio_extcb *extcb;
+
+	/* get single extent map with device raid layout for compressed data */
+	read_lock(&em_tree->lock);
+	em = lookup_extent_mapping(em_tree, compressed_start, compressed_len);
+	read_unlock(&em_tree->lock);
+	BUG_ON(em->block_len < data_len);
+
+	err = btrfs_dio_new_extcb(&extcb, diocb, em);
+	if (err) {
+		free_extent_map(em);
+		return err;
+	}
+
+	/* we now own this range and will unlock it in our completion */
+	extcb->lockstart = diocb->lockstart;
+	extcb->lockend = diocb->lockstart + lem->len - 1;
+	diocb->lockstart += lem->len;
+
+	extcb->compressed = 1;
+	extcb->iostart = compressed_start;
+	extcb->icb.out_start = diocb->start - lem->start;
+	extcb->icb.out_len = data_len;
+	extcb->icb.get_next_in = btrfs_dio_inflate_next_in;
+	extcb->icb.get_next_out = btrfs_dio_get_next_out;
+	extcb->icb.done_with_out = btrfs_dio_done_with_out;
+
+	/* completion code is per-extent on user memory */
+	extcb->active_umc = &extcb->umc;
+	extcb->umc.todo = data_len;
+
+	/* read entire compressed extent into temp pages,
+	 * it must all fit in one extcb for us to inflate
+	 */
+	err = btrfs_dio_read_stripes(extcb, &compressed_start,
+					&compressed_len, 1);
+	if (compressed_len && !err)
+		err = -EIO;
+	if (!err)
+		diocb->start += data_len;
+
+	/* adjust diocb->iov and diocb->iov_left to account
+	 * for uncompressed size so we start the next extent
+	 * at the proper point in user memory
+	 */
+	btrfs_dio_skip_user_mem(&diocb->umc, data_len);
+
+	btfrs_dio_unplug(extcb);
+
+	spin_lock_irq(&diocb->diolock);
+	diocb->pending_extcbs++;
+	/* decrement pending_bios to let reaper run on extcb,
+	 * it will run immediately to clean up if we failed
+	 */
+	btrfs_dio_extcb_biodone(extcb);
+	spin_unlock_irq(&diocb->diolock);
+
+	return err;
+}
+
+/* called with a hard-sector bounded file byte data start/len
+ * which covers areas of disk data.  it might not... be contiguous,
+ * be on the same device(s), have the same redundancy property.
+ * get the extent map per contiguous chunk and submit bios.
+ */
+static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
+				struct extent_map *lem, u64 data_len)
+{
+	struct extent_map_tree *em_tree = &BTRFS_I(diocb->inode)->
+		root->fs_info->mapping_tree.map_tree;
+	u64 data_start = lem->block_start + (diocb->start - lem->start);
+	struct extent_map *em;
+	int err = -EIO;
+	int csum = !(BTRFS_I(diocb->inode)->flags & BTRFS_INODE_NODATASUM);
+	u64 csum_before = 0;
+	u64 csum_after = 0;
+	u32 blocksize = BTRFS_I(diocb->inode)->root->sectorsize;
+	u32 filetail = (data_start + data_len) & (blocksize - 1);
+
+	if (csum) {
+		csum_before = data_start & (blocksize - 1);
+		if (filetail)
+			csum_after = blocksize - filetail;
+	}
+
+	/* to make eof consistent between inline/compressed/normal extents,
+	 * any unaligned bytes at eof get special treatment. those bytes are
+	 * read into a kernel temp page and copied to user memory.
+	 */
+	filetail &= diocb->alignment - 1;
+
+	data_start -= csum_before;
+	data_len += csum_before + csum_after;
+
+	while (data_len) {
+		struct btrfs_dio_extcb *extcb;
+		u64 filelen = 0;
+
+		/* get device extent map for next contiguous chunk */
+		read_lock(&em_tree->lock);
+		em = lookup_extent_mapping(em_tree, data_start, data_len);
+		read_unlock(&em_tree->lock);
+
+		err = btrfs_dio_new_extcb(&extcb, diocb, em);
+		if (err) {
+			free_extent_map(em);
+			return err;
+		}
+
+		/* if the chunk can not fit into MAX_STRIPE_SEGMENTS,
+		 * we will have to split it into multiple extcbs, but
+		 * for now, do everything assuming it fits.
+		 */
+		extcb->iostart = data_start;
+		/* we now own this range and will unlock it in our completion */
+		extcb->lockstart = diocb->lockstart;
+		diocb->lockstart += data_len;
+		extcb->lockend = diocb->lockstart - 1;
+
+		/* only the first extent read can start inside a
+		 * btrfs block, must read part of block before
+		 * user start into temp page to validate csum.
+		 */
+		if (csum_before) {
+			data_len -= csum_before;
+			err = btrfs_dio_read_stripes(extcb,
+				&data_start, &csum_before, 1);
+			if (err)
+				goto fail;
+			BUG_ON(csum_before);
+		}
+
+		/* device transfers to user pages in sector alignment
+		 * but file tail can be 1-byte aligned.  since we need
+		 * to have a temp page for checksum, we put the tail in
+		 * that page and copy it to user memory on completion so
+		 * post-xfer-memory looks the same as compressed or inline
+		 */
+		data_len -= csum_after + filetail;
+		filelen = data_len;
+		if (data_len) {
+			/* add_user_pages submits must be done using diocb */
+			extcb->active_umc = &diocb->umc;
+			err = btrfs_dio_read_stripes(extcb,
+				&data_start, &data_len, 0);
+			filelen -= data_len;
+			if (err)
+				goto fail;
+		}
+
+		if (data_len) {
+			/* chunk must not have fit in MAX_STRIPE_SEGMENTS,
+			 * fix everything to reflect our current state
+			 * so we can process more of the chunk in a new extcb.
+			 * we save an extra bio slot to handle the case that
+			 * the user memory vectors caused a partial last block
+			 * when we need a full one for checksums. add part of
+			 * extent as "tail checksum" and recalculate what we
+			 * have remaining for next loop.
+			 */
+			if (csum && (extcb->iolen & (blocksize - 1))) {
+				u64 align_size = blocksize -
+					(extcb->iolen & (blocksize - 1));
+
+				data_len += filetail;
+				if (data_len <= align_size) {
+					extcb->filetail = data_len;
+					data_len = 0;
+				} else {
+					extcb->filetail = align_size;
+					filetail = (data_start + data_len) &
+							(blocksize - 1);
+					data_len -= align_size;
+					if (csum && filetail)
+						csum_after = blocksize -
+							filetail;
+					else
+						csum_after = 0;
+					filetail &= diocb->alignment - 1;
+				}
+
+				extcb->csum_pg2 = extcb->csum_pg1;
+				err = btrfs_dio_read_stripes(extcb,
+					&data_start, &align_size, 1);
+				if (!err && align_size)
+					err = -EIO;
+				if (err) {
+					extcb->filetail = 0;
+					goto fail;
+				}
+				/* must skip area we copy into on completion */
+				btrfs_dio_skip_user_mem(&diocb->umc,
+							extcb->filetail);
+				extcb->beforetail = filelen;
+			}
+			data_len += csum_after + filetail;
+			extcb->lockend -= data_len;
+			diocb->lockstart = extcb->lockend + 1;
+		} else if (csum_after || filetail) {
+			/* only the last extent read can end inside a
+			 * btrfs block, must read part of block after
+			 * user end into temp page to validate csum.
+			 * csum_pg2 saves csum_before page in same extent.
+			 */
+			extcb->csum_pg2 = extcb->csum_pg1;
+			csum_after += filetail;
+			csum_after = ALIGN(csum_after, diocb->alignment);
+			err = btrfs_dio_read_stripes(extcb,
+				&data_start, &csum_after, 1);
+			if (err)
+				goto fail;
+			BUG_ON(csum_after);
+			extcb->filetail = filetail;
+			extcb->beforetail = filelen;
+		}
+
+fail:
+		diocb->start += filelen + extcb->filetail;
+
+		/* completion code is on extent not on diocb */
+		extcb->active_umc = &extcb->umc;
+
+		btfrs_dio_unplug(extcb);
+
+		spin_lock_irq(&diocb->diolock);
+		diocb->pending_extcbs++;
+		/* decrement pending_bios to let reaper run on extcb */
+		btrfs_dio_extcb_biodone(extcb);
+		spin_unlock_irq(&diocb->diolock);
+
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static void btfrs_dio_unplug(struct btrfs_dio_extcb *extcb)
+{
+	int dvn;
+
+	for (dvn = 0; dvn < extcb->stripes; dvn++) {
+		if (extcb->diodev[dvn].bio)
+			btrfs_dio_submit_bio(extcb, dvn);
+		if (extcb->diodev[dvn].unplug) {
+			struct backing_dev_info *bdi = blk_get_backing_dev_info(
+					btrfs_map_stripe_bdev(extcb->em, dvn));
+			if (bdi && bdi->unplug_io_fn)
+				bdi->unplug_io_fn(bdi, NULL);
+		}
+	}
+}
+
+/* build and submit bios for multiple devices that describe a raid set */
+static int btrfs_dio_read_stripes(struct btrfs_dio_extcb *extcb,
+				u64 *rd_start, u64 *rd_len, int temp_pages)
+{
+	int err = -EIO;
+
+	while (*rd_len) {
+		u64 dev_left = *rd_len;
+		struct btrfs_stripe_info stripe_info;
+		int mirror = 0;
+		int dvn;
+
+retry:
+		btrfs_map_to_stripe(extcb->em, READ, mirror, *rd_start,
+				&dev_left, &stripe_info);
+
+		dvn = stripe_info.stripe_index;
+		extcb->diodev[dvn].physical = stripe_info.phys_offset +
+			btrfs_map_stripe_physical(extcb->em,
+						stripe_info.stripe_index);
+
+		/* we can have devices with different logical blocksizes
+		 * in the filesystem. the user I/O start and length or
+		 * memory address and length may not be sector aligned
+		 * on a device with blocksize > dio_min_blocksize.
+		 * if the user alignment is not correct for this device,
+		 * try other copies to see if any meet their alignment.
+		 */
+		if (!temp_pages && extcb->diocb->alignment <
+		    bdev_logical_block_size(btrfs_map_stripe_bdev(
+		    extcb->em, dvn))) {
+			if (mirror < btrfs_map_num_copies(extcb->em)) {
+				mirror++;
+				goto retry;
+			}
+			err = -ENOTBLK;
+			goto bailout;
+		}
+
+		*rd_len -= dev_left;
+		*rd_start += dev_left;
+
+		while (dev_left) {
+			err = btrfs_dio_new_bio(extcb, dvn);
+			if (err)
+				goto bailout;
+			extcb->order[extcb->bo_used] = extcb->diodev[dvn].bio;
+			extcb->bo_used++;
+
+			if (temp_pages)
+				err = btrfs_dio_add_temp_pages(&dev_left,
+						extcb, dvn);
+			else
+				err = btrfs_dio_add_user_pages(&dev_left,
+						extcb, dvn);
+
+			btrfs_dio_submit_bio(extcb, dvn);
+
+			/* err or limit on bios we can handle in one extcb */
+			if (err || extcb->bo_used == MAX_STRIPE_SEGMENTS) {
+				*rd_len += dev_left;
+				*rd_start -= dev_left;
+				goto bailout;
+			}
+		}
+	}
+
+bailout:
+	return err;
+}
+
+static void btrfs_dio_reset_next_in(struct btrfs_dio_extcb *extcb)
+{
+	extcb->bo_now = 0;
+	extcb->bo_bvn = 0;
+	extcb->bo_frag = 0;
+}
+
+static void btrfs_dio_get_next_in(struct bio_vec *vec,
+				struct btrfs_dio_extcb *extcb)
+{
+	*vec = extcb->order[extcb->bo_now]->bi_io_vec[extcb->bo_bvn];
+
+	if (extcb->bo_frag) {
+		vec->bv_offset += vec->bv_len - extcb->bo_frag;
+		vec->bv_len = extcb->bo_frag;
+		extcb->bo_frag = 0;
+	}
+
+	if (++extcb->bo_bvn == extcb->order[extcb->bo_now]->bi_vcnt) {
+		extcb->bo_now++;
+		extcb->bo_bvn = 0;
+	}
+}
+
+static void btrfs_dio_put_next_in(struct bio_vec *vec,
+				struct btrfs_dio_extcb *extcb)
+{
+	while (vec->bv_len) {
+		unsigned int bv_len;
+		if (extcb->bo_frag) {
+			/* current bi_io_vec is part of this put-back */
+			vec->bv_len += extcb->bo_frag;
+			extcb->bo_frag = 0;
+			/* else put-back begins at previous bi_io_vec or bio */
+		} else if (extcb->bo_bvn) {
+			extcb->bo_bvn--;
+		} else {
+			extcb->bo_now--;
+			extcb->bo_bvn = extcb->order[extcb->bo_now]->
+					bi_vcnt - 1;
+		}
+
+		bv_len = extcb->order[extcb->bo_now]->
+				bi_io_vec[extcb->bo_bvn].bv_len;
+		if (vec->bv_len < bv_len) {
+			extcb->bo_frag = vec->bv_len;
+			vec->bv_len = 0;
+			return;
+		}
+		vec->bv_len -= bv_len;
+	}
+}
+
+static int btrfs_dio_inflate_next_in(struct bio_vec *ivec,
+				struct btrfs_inflate *icb)
+{
+	struct btrfs_dio_extcb *extcb =
+		container_of(icb, struct btrfs_dio_extcb, icb);
+
+	btrfs_dio_get_next_in(ivec, extcb);
+	return 0;
+}
+
+static int btrfs_dio_inline_next_in(struct bio_vec *ivec,
+				struct btrfs_inflate *icb)
+{
+	struct btrfs_dio_extcb *extcb =
+		container_of(icb, struct btrfs_dio_extcb, icb);
+
+	access_extent_buffer_page(ivec, extcb->leaf,
+					extcb->iostart, extcb->iolen);
+	extcb->iostart += ivec->bv_len;
+	extcb->iolen -= ivec->bv_len;
+	return 0;
+}
+
+static int btrfs_dio_get_user_bvec(struct bio_vec *uv,
+				struct btrfs_dio_user_mem_control *umc)
+{
+	/* allows 0-length user iov which is questionable but seems legal */
+	while (!umc->work_iov.iov_len) {
+		umc->user_iov++;
+		umc->work_iov = *umc->user_iov;
+	}
+
+	if (!umc->user_pages_left) {
+		unsigned long addr = (unsigned long)umc->work_iov.iov_base;
+		unsigned int offset = addr & (PAGE_SIZE-1);
+		int pages = min_t(long, umc->gup_max,
+			(min_t(long, umc->work_iov.iov_len, umc->remaining)
+				+ offset + PAGE_SIZE-1) / PAGE_SIZE);
+
+		pages = get_user_pages_fast(addr, pages, 1, umc->pagelist);
+		if (pages <= 0)
+			return pages ? pages : -ERANGE;
+		umc->user_pages_left = pages;
+		umc->next_user_page = 0;
+	}
+
+	uv->bv_page = umc->pagelist[umc->next_user_page];
+	uv->bv_offset = (unsigned long)umc->work_iov.iov_base
+					& (PAGE_SIZE-1);
+	uv->bv_len = min_t(long, PAGE_SIZE - uv->bv_offset,
+			min_t(long, min_t(long, umc->todo, umc->remaining),
+				umc->work_iov.iov_len));
+
+	/* advance position for next caller */
+	umc->work_iov.iov_base += uv->bv_len;
+	umc->work_iov.iov_len -= uv->bv_len;
+	umc->remaining -= uv->bv_len;
+	umc->todo -= uv->bv_len;
+	if (!umc->work_iov.iov_len || uv->bv_offset + uv->bv_len == PAGE_SIZE) {
+		umc->next_user_page++;
+		umc->user_pages_left--;
+	} else {
+		/* unaligned user vectors may have multiple page releasers so
+		 * we must increment ref count now to prevent premature release
+		 */
+		get_page(uv->bv_page);
+	}
+
+	return 0;
+}
+
+/* error processing only, put back the user bvec we could not process
+ * so we can get it again later or release it properly
+ */
+static void btrfs_dio_put_user_bvec(struct bio_vec *uv,
+				struct btrfs_dio_user_mem_control *umc)
+{
+	umc->work_iov.iov_base -= uv->bv_len;
+	umc->work_iov.iov_len += uv->bv_len;
+	umc->remaining += uv->bv_len;
+	umc->todo += uv->bv_len;
+	if (umc->work_iov.iov_len == uv->bv_len ||
+	    uv->bv_offset + uv->bv_len == PAGE_SIZE) {
+		umc->next_user_page--;
+		umc->user_pages_left++;
+	} else {
+		/* remove the extra ref we took on unaligned page */
+		put_page(uv->bv_page);
+	}
+}
+
+/* error processing only, release unused user pages */
+static void btrfs_dio_release_unused_pages(
+				struct btrfs_dio_user_mem_control *umc)
+{
+	while (umc->user_pages_left) {
+		page_cache_release(umc->pagelist[umc->next_user_page]);
+		umc->next_user_page++;
+		umc->user_pages_left--;
+	}
+}
+
+static void btrfs_dio_skip_user_mem(struct btrfs_dio_user_mem_control *umc,
+				u32 skip_len)
+{
+	while (skip_len) {
+		u32 len;
+		if (!umc->work_iov.iov_len) {
+			umc->user_iov++;
+			umc->work_iov = *umc->user_iov;
+		}
+
+		len = min_t(u32, umc->work_iov.iov_len, skip_len);
+		umc->work_iov.iov_base += len;
+		umc->work_iov.iov_len -= len;
+		umc->remaining -= len;
+		skip_len -= len;
+	}
+}
+
+static int btrfs_dio_get_next_out(struct bio_vec *ovec,
+				struct btrfs_inflate *icb)
+{
+	struct btrfs_dio_extcb *extcb =
+		container_of(icb, struct btrfs_dio_extcb, icb);
+	return btrfs_dio_get_user_bvec(ovec, extcb->active_umc);
+}
+
+static void btrfs_dio_done_with_out(struct bio_vec *ovec,
+				struct btrfs_inflate *icb)
+{
+	flush_dcache_page(ovec->bv_page);
+	if (!PageCompound(ovec->bv_page))
+		set_page_dirty_lock(ovec->bv_page);
+	page_cache_release(ovec->bv_page);
+}
+
+static void btrfs_dio_release_bios(struct btrfs_dio_extcb *extcb, int dirty)
+{
+	int vn;
+
+	for (vn = 0; vn < extcb->bo_used; vn++) {
+		struct bio *bio = extcb->order[vn];
+		struct bio_vec *bvec = bio->bi_io_vec;
+		int pn;
+
+		for (pn = 0; pn < bio->bi_vcnt; pn++) {
+			struct page *page = bvec[pn].bv_page;
+			if (dirty && !PageCompound(page) &&
+			    page != extcb->csum_pg1 && page != extcb->csum_pg2)
+				set_page_dirty_lock(page);
+			page_cache_release(page);
+		}
+		bio_put(bio);
+	}
+	extcb->bo_used = 0;
+}
+
+/* finish non-compressed extent that has no errors */
+static void btrfs_dio_read_done(struct btrfs_dio_extcb *extcb)
+{
+	if (extcb->filetail) {
+		btrfs_dio_skip_user_mem(extcb->active_umc, extcb->beforetail);
+		extcb->active_umc->todo = extcb->filetail;
+		while (extcb->active_umc->todo) {
+			struct bio_vec uv;
+			char *filetail;
+			char *out;
+
+			extcb->error = btrfs_dio_get_user_bvec(&uv,
+							extcb->active_umc);
+			if (extcb->error) {
+				extcb->filestart -= extcb->active_umc->todo;
+				goto fail;
+			}
+			filetail = kmap_atomic(extcb->csum_pg1, KM_USER0);
+			out = kmap_atomic(uv.bv_page, KM_USER1);
+			memcpy(out + uv.bv_offset, filetail, uv.bv_len);
+			kunmap_atomic(out, KM_USER1);
+			kunmap_atomic(filetail, KM_USER0);
+
+			btrfs_dio_done_with_out(&uv, NULL);
+		}
+	}
+fail:
+	btrfs_dio_release_bios(extcb, 1);
+}
+
+/* inflate and finish compressed extent that has no errors.
+ * all-or-nothing as partial result from zlib is likely garbage.
+ * we don't retry if decompression fails, the assumption is
+ * all mirrors are trash because we had valid checksums.
+ */
+static void btrfs_dio_decompress(struct btrfs_dio_extcb *extcb)
+{
+	u32 len = extcb->icb.out_len;
+
+	extcb->error = btrfs_zlib_inflate(&extcb->icb);
+
+	/* ugly again - compressed extents can end with an implied hole */
+	if (!extcb->error && extcb->icb.out_len != len) {
+		while (extcb->umc.todo) {
+			struct bio_vec uv;
+			char *out;
+
+			extcb->error = btrfs_dio_get_user_bvec(&uv,
+								&extcb->umc);
+			if (extcb->error)
+				goto fail;
+			out = kmap_atomic(uv.bv_page, KM_USER0);
+			memset(out + uv.bv_offset, 0, uv.bv_len);
+			kunmap_atomic(out, KM_USER0);
+
+			btrfs_dio_done_with_out(&uv, NULL);
+		}
+	}
+fail:
+	btrfs_dio_release_bios(extcb, 0);
+}
+
+static void btrfs_dio_free_extcb(struct btrfs_dio_extcb *extcb)
+{
+	if (!extcb->error)
+		extcb->error = extcb->shortread;
+	if (extcb->error) {
+		spin_lock_irq(&extcb->diocb->diolock);
+		if (extcb->diocb->terminate > extcb->filestart)
+			extcb->diocb->terminate = extcb->filestart;
+		if (!extcb->diocb->error)
+			extcb->diocb->error = extcb->error;
+		spin_unlock_irq(&extcb->diocb->diolock);
+	}
+
+	btrfs_dio_free_retry(extcb);
+
+	btrfs_dio_release_bios(extcb, 1); /* mark dirty as we just don't know */
+
+	btrfs_dio_release_unused_pages(extcb->active_umc);
+
+	unlock_extent(&BTRFS_I(extcb->diocb->inode)->io_tree, extcb->lockstart,
+			extcb->lockend, GFP_NOFS);
+	free_extent_map(extcb->em);
+	kfree(extcb);
+}
+
+static int btrfs_dio_get_workbuf(struct btrfs_dio_extcb *extcb)
+{
+	if (extcb->compressed) {
+		if (!extcb->diocb->workspace) {
+			struct workspace *workspace;
+			workspace = find_zlib_workspace();
+			if (IS_ERR(workspace))
+				return -ENOMEM;
+			extcb->diocb->workspace = workspace;
+		}
+		extcb->icb.workspace = extcb->diocb->workspace;
+		extcb->tmpbuf = extcb->icb.workspace->buf;
+	} else {
+		if (!extcb->diocb->csum_buf) {
+			extcb->diocb->csum_buf = kmalloc(PAGE_SIZE, GFP_NOFS);
+			if (!extcb->diocb->csum_buf)
+				return -ENOMEM;
+		}
+		extcb->tmpbuf = extcb->diocb->csum_buf;
+	}
+	extcb->tmpbuf_size = PAGE_SIZE;
+	return 0;
+}
+
+/* on error retries, our work buffers could be released
+ * if not in use for other extcbs, so drop them to be safe
+ */
+static void btrfs_dio_drop_workbuf(struct btrfs_dio_extcb *extcb)
+{
+	extcb->icb.workspace = NULL;
+	extcb->tmpbuf = NULL;
+	extcb->tmpbuf_size = 0;
+}
+
+static void btrfs_dio_complete_bios(struct btrfs_diocb *diocb)
+{
+	struct btrfs_dio_extcb *extcb;
+
+	do {
+		spin_lock_irq(&diocb->diolock);
+		extcb = diocb->done_extcbs;
+		if (extcb) {
+			diocb->done_extcbs = extcb->next;
+			diocb->pending_extcbs--;
+			extcb->next = NULL;
+		}
+
+		spin_unlock_irq(&diocb->diolock);
+
+		if (extcb) {
+			int err2 = extcb->error;
+
+			/* when another I/O failed with a file offset
+			 * less than our own, no reason to do anything.
+			 */
+			if (diocb->terminate < extcb->filestart) {
+				btrfs_dio_free_retry(extcb);
+				err2 = -EIO;
+			} else if (err2 || extcb->retry_bio)
+				err2 = btrfs_dio_read_retry(extcb);
+
+			/* wait for io/csum retry we just started to finish */
+			if (extcb->retry_bio)
+				continue;
+
+			if (!err2)
+				err2 = btrfs_dio_get_workbuf(extcb);
+
+			if (!err2 && !(BTRFS_I(diocb->inode)->
+					flags & BTRFS_INODE_NODATASUM)) {
+				err2 = btrfs_dio_read_csum(extcb);
+				if (extcb->retry_bio) {
+					btrfs_dio_drop_workbuf(extcb);
+					continue; /* trying another copy */
+				}
+			}
+
+			if (!err2) {
+				btrfs_dio_reset_next_in(extcb);
+				if (extcb->compressed)
+					btrfs_dio_decompress(extcb);
+				else
+					btrfs_dio_read_done(extcb);
+			}
+
+			if (err2)
+				extcb->error = err2;
+			btrfs_dio_free_extcb(extcb);
+			cond_resched();
+		}
+	} while (extcb);
+
+	/* release large zlib memory until we run again */
+	if (diocb->workspace) {
+		free_workspace(diocb->workspace);
+		diocb->workspace = NULL;
+	}
+}
+
+static int btrfs_dio_new_bio(struct btrfs_dio_extcb *extcb, int dvn)
+{
+	int vecs = bio_get_nr_vecs(btrfs_map_stripe_bdev(extcb->em, dvn));
+
+	extcb->diodev[dvn].bio = bio_alloc(GFP_NOFS, vecs);
+	if (extcb->diodev[dvn].bio == NULL)
+		return -ENOMEM;
+
+	extcb->diodev[dvn].vecs = vecs;
+	extcb->diodev[dvn].bio->bi_bdev = btrfs_map_stripe_bdev(extcb->em, dvn);
+	extcb->diodev[dvn].bio->bi_sector = extcb->diodev[dvn].physical >> 9;
+	extcb->diodev[dvn].bio->bi_private = extcb;
+	extcb->diodev[dvn].bio->bi_end_io = &btrfs_dio_bi_end_io;
+
+	return 0;
+}
+
+static void btrfs_dio_submit_bio(struct btrfs_dio_extcb *extcb, int dvn)
+{
+	if (!extcb->diodev[dvn].bio)
+		return;
+	extcb->diodev[dvn].vecs = 0;
+	if (!extcb->diodev[dvn].bio->bi_vcnt) {
+		bio_put(extcb->diodev[dvn].bio);
+		extcb->diodev[dvn].bio = NULL;
+		return;
+	}
+	spin_lock_irq(&extcb->diocb->diolock);
+	extcb->pending_bios++;
+	spin_unlock_irq(&extcb->diocb->diolock);
+
+	bio_get(extcb->diodev[dvn].bio);
+	submit_bio(extcb->diocb->rw, extcb->diodev[dvn].bio);
+	bio_put(extcb->diodev[dvn].bio);
+	extcb->diodev[dvn].bio = NULL;
+	extcb->diodev[dvn].unplug++;
+}
+
+/* pin user pages and add to current bio until either
+ * bio is full or device read/write length remaining is 0.
+ * spans memory segments in multiple io vectors that can
+ * begin and end on non-page (but sector-size aligned) boundaries.
+ */
+static int btrfs_dio_add_user_pages(u64 *dev_left,
+				struct btrfs_dio_extcb *extcb, int dvn)
+{
+	extcb->active_umc->todo = *dev_left;
+	while (extcb->diodev[dvn].vecs && *dev_left) {
+		struct bio_vec uv;
+
+		int err = btrfs_dio_get_user_bvec(&uv, extcb->active_umc);
+		if (err)
+			return err;
+
+		if (!bio_add_page(extcb->diodev[dvn].bio, uv.bv_page,
+				uv.bv_len, uv.bv_offset)) {
+			btrfs_dio_put_user_bvec(&uv, extcb->active_umc);
+			extcb->diodev[dvn].vecs = 0;
+			return 0;
+		}
+		extcb->iolen += uv.bv_len;
+		extcb->diodev[dvn].physical += uv.bv_len;
+		*dev_left -= uv.bv_len;
+		extcb->diodev[dvn].vecs--;
+	}
+	return 0;
+}
+
+/* submit kernel temporary pages for compressed read */
+static int btrfs_dio_add_temp_pages(u64 *dev_left,
+				struct btrfs_dio_extcb *extcb, int dvn)
+{
+	while (extcb->diodev[dvn].vecs && *dev_left) {
+		unsigned int pglen = min_t(long, *dev_left, PAGE_SIZE);
+		struct page *page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+
+		if (!page)
+			return -ENOMEM;
+		if (!bio_add_page(extcb->diodev[dvn].bio, page, pglen, 0)) {
+			extcb->diodev[dvn].vecs = 0;
+			page_cache_release(page);
+			return 0;
+		}
+		extcb->csum_pg1 = page;
+		extcb->iolen += pglen;
+		extcb->diodev[dvn].physical += pglen;
+		*dev_left -= pglen;
+		extcb->diodev[dvn].vecs--;
+	}
+
+	return 0;
+}
+
+static int btrfs_dio_hole_read(struct btrfs_diocb *diocb, u64 hole_len)
+{
+	int err = 0;
+	diocb->umc.todo = hole_len;
+	while (diocb->umc.todo) {
+		struct bio_vec uv;
+		char *out;
+
+		err = btrfs_dio_get_user_bvec(&uv, &diocb->umc);
+		if (err)
+			goto fail;
+		diocb->start += uv.bv_len;
+		out = kmap_atomic(uv.bv_page, KM_USER0);
+		memset(out + uv.bv_offset, 0, uv.bv_len);
+		kunmap_atomic(out, KM_USER0);
+
+		btrfs_dio_done_with_out(&uv, NULL);
+	}
+fail:
+	unlock_extent(&BTRFS_I(diocb->inode)->io_tree, diocb->lockstart,
+			diocb->start - 1, GFP_NOFS);
+	diocb->lockstart = diocb->start;
+	return err;
+}
+
+static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
+{
+	int err;
+	u32 size;
+	u32 extent_offset;
+	u64 extent_start;
+	u64 objectid = diocb->inode->i_ino;
+	struct btrfs_root *root = BTRFS_I(diocb->inode)->root;
+	struct btrfs_path *path;
+	struct btrfs_file_extent_item *item;
+	struct extent_buffer *leaf;
+	struct btrfs_key found_key;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	err = btrfs_lookup_file_extent(NULL, root, path, objectid,
+					diocb->start, 0);
+	if (err) {
+		if (err < 0)
+			goto notfound;
+		err = -EDOM;
+		if (path->slots[0] == 0) {
+			printk(KERN_ERR
+				"btrfs directIO inline not found ino %lu\n",
+				diocb->inode->i_ino);
+			goto fail;
+		}
+		path->slots[0]--;
+	}
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0],
+			      struct btrfs_file_extent_item);
+	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+	if (found_key.objectid != objectid ||
+	    btrfs_key_type(&found_key) != BTRFS_EXTENT_DATA_KEY ||
+	    btrfs_file_extent_type(leaf, item) != BTRFS_FILE_EXTENT_INLINE) {
+		printk(KERN_ERR "btrfs directIO inline leaf mismatch ino %lu\n",
+			diocb->inode->i_ino);
+		err = -EDOM;
+		goto fail;
+	}
+
+	extent_start = found_key.offset;
+	/* uncompressed size */
+	size = btrfs_file_extent_inline_len(leaf, item);
+	if (diocb->start < extent_start) {
+		printk(KERN_ERR "btrfs directIO inline range mismatch ino %lu"
+			" fpos %lld found start %lld size %d\n",
+			diocb->inode->i_ino, diocb->start, extent_start, size);
+		err = -EDOM;
+		goto fail;
+	}
+
+	/* we can end here when we start in an implied hole on a larger file */
+	if (diocb->start >= extent_start + size) {
+		*data_len = 0;
+		err = 0;
+		goto fail;
+	}
+
+	extent_offset = diocb->start - extent_start;
+	size = min_t(u64, *data_len, size - extent_offset);
+	*data_len = size;
+
+	if (btrfs_file_extent_compression(leaf, item) == BTRFS_COMPRESS_ZLIB) {
+		struct btrfs_dio_extcb *extcb;
+
+		extcb = kzalloc(sizeof(*extcb), GFP_NOFS);
+		if (!extcb) {
+			err = -ENOMEM;
+			goto fail;
+		}
+
+		extcb->diocb = diocb;
+		extcb->compressed = 1;
+
+		extcb->active_umc = &extcb->umc;
+		extcb->umc.gup_max = GUP_IOSUBMIT_MAX;
+		extcb->umc.pagelist = diocb->gup_iosubmit_pages;
+		extcb->umc.work_iov = diocb->umc.work_iov;
+		extcb->umc.user_iov = diocb->umc.user_iov;
+		extcb->umc.remaining = diocb->umc.remaining;
+		extcb->umc.todo = size;
+
+		extcb->iostart = btrfs_file_extent_inline_start(item);
+		extcb->iolen = btrfs_file_extent_inline_item_len(leaf,
+					btrfs_item_nr(leaf, path->slots[0]));
+
+		extcb->icb.out_start = extent_offset;
+		extcb->icb.out_len = size;
+		extcb->icb.get_next_in = btrfs_dio_inline_next_in;
+		extcb->icb.get_next_out = btrfs_dio_get_next_out;
+		extcb->icb.done_with_out = btrfs_dio_done_with_out;
+		/* NULL icb.workspace so btrfs_zlib_inflate allocs workspace */
+
+		extcb->leaf = leaf;
+
+		err = btrfs_zlib_inflate(&extcb->icb);
+		/* all or nothing as we can't trust partial inflate */
+		if (!err)
+			diocb->start += size;
+
+		/* we allow extents after inline if a hole follows */
+		diocb->umc.work_iov = extcb->umc.work_iov;
+		diocb->umc.user_iov = extcb->umc.user_iov;
+		diocb->umc.remaining = extcb->umc.remaining;
+
+		kfree(extcb);
+	} else {
+		unsigned long inline_start;
+		inline_start = btrfs_file_extent_inline_start(item)
+				+ extent_offset;
+		diocb->umc.todo = size;
+		while (diocb->umc.todo) {
+			struct bio_vec uv;
+			char *out;
+
+			err = btrfs_dio_get_user_bvec(&uv, &diocb->umc);
+			if (err)
+				goto fail;
+			diocb->start += uv.bv_len;
+			out = kmap_atomic(uv.bv_page, KM_USER1);
+			read_extent_buffer(leaf, out + uv.bv_offset,
+					inline_start, uv.bv_len);
+			inline_start += uv.bv_len;
+			kunmap_atomic(out, KM_USER1);
+
+			btrfs_dio_done_with_out(&uv, NULL);
+		}
+	}
+
+fail:
+	btrfs_release_path(root, path);
+notfound:
+	btrfs_free_path(path);
+	if (!err && *data_len) {
+		unlock_extent(&BTRFS_I(diocb->inode)->io_tree, diocb->lockstart,
+				diocb->start - 1, GFP_NOFS);
+		diocb->lockstart = diocb->start;
+	}
+	return err;
+}
+
+/* verify disk data checksums for extent read.
+ * complexity is user memory addesses may not be
+ * aligned with our checksummed logical disk blocks.
+ *
+ * this changes extcb->filestart for uncompressed extents
+ * to identify where good data ends on a partial success.
+ */
+static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
+{
+	struct bio_vec ivec;
+	struct btrfs_root *root =
+			BTRFS_I(extcb->diocb->inode)->root->fs_info->csum_root;
+	u32 blocksize = BTRFS_I(extcb->diocb->inode)->root->sectorsize;
+	u32 iolen_per_csum_buf = blocksize * (extcb->tmpbuf_size
+		/ btrfs_super_csum_size(&root->fs_info->super_copy));
+
+	if (extcb->iolen & (blocksize - 1)) {
+		printk(KERN_WARNING
+			"btrfs directIO unaligned checksum for ino %lu "
+			"start %lld len %d\n", extcb->diocb->inode->i_ino,
+			extcb->iostart, extcb->iolen);
+		extcb->iolen &= ~(blocksize - 1);
+	}
+
+	ivec.bv_len = 0;
+	while (extcb->iolen) {
+		u64 len = min(extcb->iolen, iolen_per_csum_buf);
+		u64 end = extcb->iostart + len - 1;
+		u32 *fs_csum = (u32 *)extcb->tmpbuf;
+		u32 csum;
+		int err;
+
+		err = btrfs_lookup_csums_range(root, extcb->iostart, end,
+						NULL, fs_csum);
+		if (err) {
+			printk(KERN_ERR
+				"btrfs directIO csum lookup failed ino %lu "
+				"extent start %llu end %llu\n",
+				extcb->diocb->inode->i_ino,
+				extcb->iostart, end);
+			return err;
+		}
+
+		while (len) {
+			u32 csum_len = blocksize;
+
+			/* each checksum block is a filesystem block and on the
+			 * same device, but user memory can be 512 byte aligned
+			 * so we have to be able to span multiple pages here
+			 */
+			csum = ~(u32)0;
+			while (csum_len) {
+				char *in;
+				u32 cl;
+
+				if (ivec.bv_len == 0)
+					btrfs_dio_get_next_in(&ivec, extcb);
+				cl = min_t(u32, ivec.bv_len, csum_len);
+				in = kmap_atomic(ivec.bv_page, KM_USER0);
+				csum = btrfs_csum_data(root,
+						in + ivec.bv_offset, csum, cl);
+				kunmap_atomic(in, KM_USER0);
+				ivec.bv_offset += cl;
+				ivec.bv_len -= cl;
+				csum_len -= cl;
+			}
+
+			btrfs_csum_final(csum, (char *)&csum);
+			if (csum != *fs_csum) {
+				printk(KERN_WARNING
+					"btrfs directIO csum failed ino %lu "
+					"block %llu csum %u wanted %u\n",
+					extcb->diocb->inode->i_ino,
+					extcb->iostart, csum, *fs_csum);
+				/* give up if partial read failure or
+				 * missing checksum from btree lookup
+				 */
+				if (extcb->shortread || *fs_csum == 0)
+					return -EIO;
+				extcb->retry_csum = *fs_csum;
+				extcb->retry_start = extcb->iostart;
+				extcb->retry_mirror = 0;
+				extcb->retry_len = blocksize;
+
+				/* need to give back vector remaining
+				 * length and the length of checksum block
+				 * so we are at correct input spot for retry
+				 */
+				ivec.bv_len += blocksize;
+				btrfs_dio_put_next_in(&ivec, extcb);
+				return btrfs_dio_retry_block(extcb);
+			}
+
+			extcb->iostart += blocksize;
+			extcb->iolen -= blocksize;
+			if (!extcb->compressed) {
+				if (!extcb->iolen && extcb->filetail) {
+					extcb->filestart += extcb->filetail;
+				} else {
+					extcb->filestart += blocksize;
+					/* 1st extent can start inside block */
+					extcb->filestart &= ~(blocksize - 1);
+				}
+			}
+			len -= blocksize;
+			fs_csum++;
+			cond_resched();
+		}
+	}
+	return 0;
+}
+
+static void btrfs_dio_free_retry(struct btrfs_dio_extcb *extcb)
+{
+	if (!extcb->retry_bio)
+		return;
+
+	/* we only allocate temp pages for uncompressed retries */
+	if (!extcb->compressed) {
+		struct bio_vec *bvec = extcb->retry_bio->bi_io_vec;
+		int pn;
+
+		for (pn = 0; pn < extcb->retry_bio->bi_vcnt; pn++)
+			page_cache_release(bvec[pn].bv_page);
+	}
+	bio_put(extcb->retry_bio);
+	extcb->retry_bio = NULL;
+}
+
+/* reads exactly one filesystem block into temp page(s) for
+ * retry on bio/checksum error.  blocksize and temp pages
+ * guarentee we don't have sector size issues between mirrors
+ * and are not failing checksum from user overwriting memory.
+ * if it works, we will memcopy the new data to user memory.
+ */
+static int btrfs_dio_retry_block(struct btrfs_dio_extcb *extcb)
+{
+	struct btrfs_stripe_info stripe_info;
+	u64 len = BTRFS_I(extcb->diocb->inode)->root->sectorsize;
+	u64 physical;
+	struct backing_dev_info *bdi;
+	int pages = ALIGN(len, PAGE_SIZE) / PAGE_SIZE;
+
+	btrfs_dio_free_retry(extcb);
+	extcb->retry_mirror++;
+	if (extcb->retry_mirror > btrfs_map_num_copies(extcb->em)) {
+		u32 good = extcb->retry_start -
+				min(extcb->retry_start, extcb->iostart);
+		/* csum retry ends here as always !good */
+		if (extcb->compressed || !good)
+			return -EIO;
+		/* no checksum, return partial success of i/o from device */
+		if (BTRFS_I(extcb->diocb->inode)->
+				flags &	BTRFS_INODE_NODATASUM) {
+			extcb->filestart += good;
+			return -EIO;
+		}
+		/* limit checksum test to valid read length */
+		extcb->iolen = good;
+		extcb->filetail = 0;
+		extcb->shortread = -EIO;
+		btrfs_dio_reset_next_in(extcb);
+		return 0;
+	}
+
+	extcb->retry_bio = bio_alloc(GFP_NOFS, pages);
+	if (extcb->retry_bio == NULL)
+		return -ENOMEM;
+
+	btrfs_map_to_stripe(extcb->em, READ, extcb->retry_mirror,
+			extcb->retry_start, &len, &stripe_info);
+	physical = stripe_info.phys_offset +
+		btrfs_map_stripe_physical(extcb->em, stripe_info.stripe_index);
+	extcb->retry_bio->bi_sector = physical >> 9;
+	extcb->retry_bio->bi_bdev =
+		btrfs_map_stripe_bdev(extcb->em, stripe_info.stripe_index);
+	extcb->retry_bio->bi_private = extcb;
+	extcb->retry_bio->bi_end_io = &btrfs_dio_bi_end_io;
+	bdi = blk_get_backing_dev_info(extcb->retry_bio->bi_bdev);
+
+	while (len) {
+		unsigned int pglen = min_t(long, len, PAGE_SIZE);
+		struct page *page;
+
+		/* compressed read bios use temp pages, reuse them */
+		if (extcb->compressed) {
+			page = extcb->order[extcb->bo_now]->
+					bi_io_vec[extcb->bo_bvn].bv_page;
+		} else {
+			page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+			if (!page)
+				return -ENOMEM;
+		}
+		if (!bio_add_page(extcb->retry_bio, page, pglen, 0)) {
+			if (!extcb->compressed)
+				page_cache_release(page);
+			return -EIO;
+		}
+		len -= pglen;
+		if (len && extcb->compressed)
+			extcb->bo_bvn++;
+	}
+
+	spin_lock_irq(&extcb->diocb->diolock);
+	extcb->pending_bios++;
+	extcb->diocb->pending_extcbs++;
+	spin_unlock_irq(&extcb->diocb->diolock);
+	bio_get(extcb->retry_bio);
+	submit_bio(extcb->diocb->rw, extcb->retry_bio);
+	bio_put(extcb->retry_bio);
+	if (bdi && bdi->unplug_io_fn)
+		bdi->unplug_io_fn(bdi, NULL);
+	return 0;
+}
+
+/* scan forward in file order looking for next bio that failed */
+static int btrfs_dio_bad_bio_scan(struct btrfs_dio_extcb *extcb)
+{
+	for ( ; extcb->bo_now < extcb->bo_used; extcb->bo_now++) {
+		struct bio *bio = extcb->order[extcb->bo_now];
+		int vn;
+
+		extcb->retry_len = 0;
+		for (vn = 0; vn < bio->bi_vcnt; vn++)
+			extcb->retry_len += bio->bi_io_vec[vn].bv_len;
+
+		if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+			extcb->bo_bvn = 0;
+			extcb->bo_frag = 0;
+			return btrfs_dio_retry_block(extcb);
+		}
+
+		extcb->retry_start += extcb->retry_len;
+	}
+
+	/* if we get here, it must all be good */
+	btrfs_dio_reset_next_in(extcb);
+	extcb->error = 0;
+	return 0;
+}
+
+static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
+{
+	u32 blocksize = BTRFS_I(extcb->diocb->inode)->root->sectorsize;
+
+	/* begin with first I/O error from bios sent by initial extent submit */
+	if (!extcb->retry_bio) {
+		extcb->retry_start = extcb->iostart;
+		extcb->retry_mirror = 0;
+		return btrfs_dio_bad_bio_scan(extcb);
+	}
+
+	/* we already sent a block retry and are now checking it */
+	if (!test_bit(BIO_UPTODATE, &extcb->retry_bio->bi_flags))
+		return btrfs_dio_retry_block(extcb);
+
+	extcb->error = 0;
+
+	if (extcb->retry_csum) {
+		struct btrfs_root *root =
+			BTRFS_I(extcb->diocb->inode)->root->fs_info->csum_root;
+		struct bio_vec *retry = extcb->retry_bio->bi_io_vec;
+		char *new;
+		u32 csum = ~0;
+		u32 csum_len = extcb->retry_len;
+
+		/* blocksize can exceed page size */
+		while (csum_len) {
+			u32 cl = min_t(u32, retry->bv_len, csum_len);
+			new = kmap_atomic(retry->bv_page, KM_USER0);
+			csum = btrfs_csum_data(root, new, csum, cl);
+			kunmap_atomic(new, KM_USER0);
+			retry++;
+			csum_len -= cl;
+		}
+		btrfs_csum_final(csum, (char *)&csum);
+		if (csum != extcb->retry_csum)
+			return btrfs_dio_retry_block(extcb);
+	}
+
+	/* compressed extents have temp pages that we read blocks into,
+	 * uncompressed extents must be de-blocked into user's pages
+	 */
+	if (!extcb->compressed) {
+		struct bio_vec *retry = extcb->retry_bio->bi_io_vec;
+		struct bio_vec bad;
+		u32 bad_len = min(extcb->retry_len, blocksize);
+		u32 offset;
+
+		/* user file position can start inside logical block */
+		offset = extcb->retry_start & (blocksize - 1);
+		retry->bv_offset += offset;
+		retry->bv_len -= offset;
+
+		bad.bv_len = 0;
+		while (bad_len) {
+			u32 cl;
+			char *new;
+			char *out;
+
+			if (bad.bv_len == 0)
+				btrfs_dio_get_next_in(&bad, extcb);
+			cl = min_t(u32, bad_len,
+					min(bad.bv_len, retry->bv_len));
+			new = kmap_atomic(retry->bv_page, KM_USER0);
+			out = kmap_atomic(bad.bv_page, KM_USER1);
+			memcpy(out + bad.bv_offset, new + retry->bv_offset, cl);
+			kunmap_atomic(out, KM_USER1);
+			kunmap_atomic(new, KM_USER0);
+
+			retry->bv_offset += cl;
+			retry->bv_len -= cl;
+			if (!retry->bv_len)
+				retry++;
+			bad.bv_offset += cl;
+			bad.bv_len -= cl;
+			bad_len -= cl;
+		}
+
+		/* record unfinished part of user memory for next retry */
+		btrfs_dio_put_next_in(&bad, extcb);
+	}
+
+	btrfs_dio_free_retry(extcb);
+
+	if (extcb->retry_csum) {
+		extcb->iostart += blocksize;
+		extcb->iolen -= blocksize;
+		if (!extcb->compressed) {
+			if (!extcb->iolen && extcb->filetail) {
+				extcb->filestart += extcb->filetail;
+			} else {
+				extcb->filestart += blocksize;
+				extcb->filestart &= ~(blocksize - 1);
+			}
+		}
+		return 0;
+	}
+
+	/* we are still processing bad bios from I/O submit */
+	extcb->retry_start += blocksize;
+	extcb->retry_mirror = 0;
+
+	/* do we have any more blocks to do in this bio */
+	extcb->retry_len -= blocksize;
+	if (extcb->retry_len)
+		return btrfs_dio_retry_block(extcb);
+
+	/* continue scan with next bio */
+	if (extcb->compressed) /* uncompressed copy incremented bo_now */
+		extcb->bo_now++;
+	return btrfs_dio_bad_bio_scan(extcb);
+}
-- 
1.6.3.3
