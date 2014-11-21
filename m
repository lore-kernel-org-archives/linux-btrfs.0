Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5654 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbaKUWBO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 17:01:14 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <david@fromorbit.com>, <sandeen@redhat.com>,
        <zab@redhat.com>, <clm@facebook.com>, <dm-devel@redhat.com>,
        <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>, <tytso@mit.edu>
Subject: [RFC][PATCH] dm: add dm-power-fail target
Date: Fri, 21 Nov 2014 17:00:31 -0500
Message-ID: <1416607231-8588-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm hoping some FS guys can weigh in and verify my approach for testing power
fail conditions, and the DM guys to of course verify I didn't completely fail at
making a DM target.  All suggestions welcome, I want to have a nice robust tool
for testing power fail so we can be sure our fsync/commit code is all working
properly.  Thanks,

Josef


For power fail testing we want to be able to catch cases where the fs isn't
waiting for IO to complete properly.  This target aims to do this by creating a
linear mapping on a device and keeping track of all WRITEs and FLUSH/FUA
operations.  Any WRITEs are added to a global list on completion, then when we
submit a FLUSH this list is spliced onto the request and once that request
completes then it marks those blocks as valid.  FUA bypasses this logic
altogether and is considered valid once it completes.  There are two modes of
operation here

1) Zero - any WRITE that wasn't flushed will return 0's when we try to read from
it.  This is meant for BTRFS (or any COW fs) where we only write blocks once, so
if we try to read a block we didn't properly flush then we can just send back
0's.

2) Split - the device is split in half and written to alternating sides.  This
is for overwriting fs'es (ext*/xfs).  Once a FLUSH occurs we walk all the
completed WRITEs and set their mirror to whichever mirror they last wrote to.
Anything that wasn't flushed properly will point to its previous mirror.

We then have 3 different power fail events we can do

1) DROP_WRITES - just drop all writes immediately, any new writes are
immediately completed and outstanding ones are treated as if they never
completed.

2) DROP_AFTER_FUA - this allows a FUA to go through, and as soon as it completes
we drop all writes.  This is meant to be really evil about making sure your
commit code is doing the right thing by dropping at the worst possible moment.

3) DROP_AFTER_FLUSH - this allows a FLUSH to go through, and as soon as it
completes we drop all writes.  This can be good for testing fdatasync on
overwrite fs'es that may only issue a FLUSH and not have to update metadata.

There is also an option to return -EIO as soon as we have our power fail event
to make it easier to script stress tests.

The idea is to be as evil as possible wrt how a device's cache would react to a
powerfail event.  I had originally bolted this onto dm-flakey but it got
complicated trying to work in these new options with its original behavior so I
created a new target instead.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 drivers/md/Kconfig         |  14 +
 drivers/md/Makefile        |   1 +
 drivers/md/dm-power-fail.c | 691 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 706 insertions(+)
 create mode 100644 drivers/md/dm-power-fail.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 5bdedf6..bc3d6ca 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -432,4 +432,18 @@ config DM_SWITCH
 
 	  If unsure, say N.
 
+config DM_POWER_FAIL
+	tristate "Power fail target support"
+	depends on BLK_DEV_DM
+	---help---
+	  This device-mapper target creates a device that can be used for
+	  testing a file systems ability to survive power fails.  There are
+	  several modes of operation in order to test a variety of power fail
+	  scenarios.
+
+	  To compile this code as a module, choos M here: the module will be
+	  called dm-power-fail.
+
+	  If unsure, say N.
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index a2da532..c667218 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_MQ)	+= dm-cache-mq.o
 obj-$(CONFIG_DM_CACHE_CLEANER)	+= dm-cache-cleaner.o
 obj-$(CONFIG_DM_ERA)		+= dm-era.o
+obj-$(CONFIG_DM_POWER_FAIL)	+= dm-power-fail.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-power-fail.c b/drivers/md/dm-power-fail.c
new file mode 100644
index 0000000..44c5045
--- /dev/null
+++ b/drivers/md/dm-power-fail.c
@@ -0,0 +1,691 @@
+/*
+ * Copyright (C) 2014 Facebook. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#include <linux/device-mapper.h>
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/slab.h>
+
+#define DM_MSG_PREFIX "power-fail"
+
+/*
+ * The way this interface is meant to be used is like this
+ *
+ * dmsetup create powerfail
+ * mkfs /dev/powerfail
+ * mount /dev/powerfail /mnt/test
+ * do some stuff &
+ * sleep 30
+ * dmsetup message powerfail (drop_after_flush|drop_after_fua|drop_writes)
+ * umount /mnt/test
+ * dmsetup message powerfail redirect_reads
+ * fsck /dev/powerfail || exit 1
+ * mount /dev/powerfail /mnt/test
+ * <verify contents>
+ *
+ * You can set redirect_reads whenever you want, but the idea is that you want
+ * the teardown stuff to work like normal, and then flip the switch for us to
+ * start returning garbage on any writes that would have failed, and then do
+ * verification checks.  A perfectly functioning fs will recover properly and
+ * not give you IO errors and such.
+ *
+ * There are two modes for this target.
+ *
+ * zero - any write IO's that are lost once the power fail event happens will
+ * return 0's when read after redirect_reads is set.  This is meant for btrfs or
+ * any other future COW fs that comes along.
+ *
+ * split - we split the device in half, and write to alternating sides of the
+ * device.  We track which is the last good mirror to have completed.  Then
+ * whenever the power fail event occurs we will stop updating the last good
+ * mirror for writes and when redirect_reads is turned on we will read from the
+ * last good mirror.
+ */
+
+struct pfail_ctx {
+	struct dm_dev *dev;
+	spinlock_t pending_blocks_lock;
+	struct rb_root pending_blocks;
+	struct list_head unflushed_blocks;
+	long endio_delay;
+	unsigned long flags;
+	bool split;
+	bool error;
+};
+
+enum pfail_flag_bits {
+	DROP_WRITES,
+	DROP_AFTER_FUA,
+	DROP_AFTER_FLUSH,
+	REDIRECT_READS,
+};
+
+struct pending_block {
+	struct rb_node node;
+	struct list_head list;
+	unsigned long long bytenr;
+	unsigned bytes;
+	unsigned good_mirror;
+	unsigned cur_mirror;
+	unsigned rewrite;
+};
+
+struct per_bio_data {
+	struct pending_block *block;
+	struct pfail_ctx *pc;
+	struct work_struct work;
+	int error;
+	bool track;
+};
+
+static int contains(unsigned long long a, unsigned a_len,
+		    unsigned long long b, unsigned b_len)
+{
+	if (a >= (b + b_len))
+		return 0;
+	if (b >= (a + a_len))
+		return 0;
+	return 1;
+}
+
+static struct pending_block *insert_pending_block(struct pfail_ctx *pc,
+						  struct pending_block *block)
+{
+	struct rb_node **p = &pc->pending_blocks.rb_node;
+	struct rb_node *parent = NULL;
+	struct pending_block *entry;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct pending_block, node);
+
+		if (contains(block->bytenr, block->bytes, entry->bytenr,
+			     entry->bytes)) {
+			if (!pc->split) {
+				/*
+				 * With zero mode we free up blocks once they
+				 * successfully complete, and assume the fs
+				 * doesn't write to the same block until it has
+				 * been completely written, so if this happens
+				 * we have a problem.
+				 */
+				DMERR("existing block %llu-%u insert "
+				      "%llu-%u", entry->bytenr, entry->bytes,
+				       block->bytenr, block->bytes);
+			} else if (block->bytes > entry->bytes) {
+				printk(KERN_ERR "well shit\n");
+			}
+			kfree(block);
+			return entry;
+		} else if (entry->bytenr > block->bytenr)
+			p = &(*p)->rb_left;
+		else if (entry->bytenr < block->bytenr)
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&block->node, parent, p);
+	rb_insert_color(&block->node, &pc->pending_blocks);
+	return block;
+}
+
+static struct pending_block *find_pending_block(struct pfail_ctx *pc,
+						unsigned long long bytenr,
+						unsigned bytes)
+{
+	struct rb_node *n = pc->pending_blocks.rb_node;
+	struct pending_block *block;
+
+	while (n) {
+		block = rb_entry(n, struct pending_block, node);
+		if (contains(block->bytenr, block->bytes, bytenr, bytes))
+			return block;
+		else if (block->bytenr > bytenr)
+			n = n->rb_left;
+		else if (block->bytenr < bytenr)
+			n = n->rb_right;
+	}
+	return NULL;
+}
+
+static int parse_pfail_features(struct dm_arg_set *as, struct pfail_ctx *pc,
+				struct dm_target *ti)
+{
+	const char *arg_name;
+	unsigned argc;
+	int ret;
+	static struct dm_arg _args[] = {
+		{0, 3, "Invalid number of power fail feature arguments"},
+	};
+
+	if (!as->argc)
+		return 0;
+	ret = dm_read_arg_group(_args, as, &argc, &ti->error);
+	if (ret)
+		return -EINVAL;
+
+	while (argc) {
+		arg_name = dm_shift_arg(as);
+		argc--;
+
+		if (!strcasecmp(arg_name, "split")) {
+			pc->split = true;
+		} else if (!strcasecmp(arg_name, "error_on_fail")) {
+			pc->error = true;
+		} else {
+			ti->error = "Unrecognized power fail feature "
+				"requested";
+			ret = -EINVAL;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Construct a power-fail mapping:
+ * power-fail <dev_path> <endio_delay> [<#feature args [<arg>]*]
+ *
+ * endio_delay is in jiffies, if it is 0 there will be no delay.  This is
+ * helpful for widening suspected races in your waiting logic.
+ *
+ * Option feature arguments are:
+ *
+ * split - Meant for overwrite fs'es where we need to return the old busted data
+ *	   for reads on uncompleted blocks.  Must pass in a length of >= half of
+ *	   the disk so that we can use one side for pending blocks and one side
+ *	   for completed blocks
+ * error_on_fail - Instead of just pretending that the writes completed normally
+ *		   after the failure event, we will return -EIO.
+ */
+static int pfail_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct pfail_ctx *pc;
+	struct dm_arg_set as;
+	const char *devname;
+	sector_t sectors;
+	long endio_delay;
+	char dummy;
+	int ret;
+
+	as.argc = argc;
+	as.argv = argv;
+
+	if (argc < 2) {
+		ti->error = "Invalid argument count";
+		return -EINVAL;
+	}
+
+	pc = kzalloc(sizeof(*pc), GFP_KERNEL);
+	if (!pc) {
+		ti->error = "Cannot allocate context";
+		return -ENOMEM;
+	}
+	pc->pending_blocks = RB_ROOT;
+	spin_lock_init(&pc->pending_blocks_lock);
+	INIT_LIST_HEAD(&pc->unflushed_blocks);
+
+	devname = dm_shift_arg(&as);
+	if (sscanf(dm_shift_arg(&as), "%ld%c", &endio_delay, &dummy) != 1) {
+		ti->error = "Invalid endio delay";
+		goto bad;
+	}
+	pc->endio_delay = endio_delay;
+	ret = parse_pfail_features(&as, pc, ti);
+	if (ret)
+		goto bad;
+
+	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table), &pc->dev)) {
+		ti->error = "Device lookup failed";
+		goto bad;
+	}
+
+	sectors = PAGE_CACHE_SIZE >> 9;
+	if (pc->split)
+		sectors = 512 >> 9;
+	ret = dm_set_target_max_io_len(ti, sectors);
+	if (ret)
+		goto bad;
+
+	sectors = (i_size_read(pc->dev->bdev->bd_inode) >> 9) - ti->begin;
+	sectors /= 2;
+	if (pc->split && ti->len > sectors) {
+		ti->error = "Using split but specified a device size that is "
+			"too large";
+		dm_put_device(ti, pc->dev);
+		goto bad;
+	}
+
+	ti->num_flush_bios = 1;
+	ti->flush_supported = true;
+	ti->num_discard_bios = 1;
+	ti->per_bio_data_size = sizeof(struct per_bio_data);
+	ti->private = pc;
+	return 0;
+
+bad:
+	kfree(pc);
+	return -EINVAL;
+}
+
+static void pfail_dtr(struct dm_target *ti)
+{
+	struct pfail_ctx *pc = ti->private;
+	struct pending_block *block;
+	struct rb_node *n;
+
+	dm_put_device(ti, pc->dev);
+	while ((n = rb_last(&pc->pending_blocks)) != NULL) {
+		block = rb_entry(n, struct pending_block, node);
+		rb_erase(&block->node, &pc->pending_blocks);
+		kfree(block);
+	}
+	kfree(pc);
+}
+
+static sector_t pfail_map_sector(struct dm_target *ti, sector_t bi_sector,
+				 int mirror)
+{
+	WARN_ON(bi_sector >= ti->len);
+	if (mirror == 2)
+		bi_sector += ti->len;
+	return dm_target_offset(ti, bi_sector);
+}
+
+static void pfail_map_bio(struct dm_target *ti, struct bio *bio, int mirror)
+{
+	struct pfail_ctx *pc = ti->private;
+
+	bio->bi_bdev = pc->dev->bdev;
+	if (bio_sectors(bio))
+		bio->bi_iter.bi_sector =
+			pfail_map_sector(ti, bio->bi_iter.bi_sector, mirror);
+}
+
+static int maybe_zero_bio(struct pfail_ctx *pc, struct bio *bio, int *mirror)
+{
+	struct pending_block *block;
+	char *data = bio_data(bio);
+	unsigned long long bytenr = bio->bi_iter.bi_sector << 9;
+	int good_mirror, cur_mirror;
+	int ret = 0;
+
+	if (!bio_has_data(bio))
+		return 0;
+
+	spin_lock(&pc->pending_blocks_lock);
+	block = find_pending_block(pc, bytenr, bio_cur_bytes(bio));
+	if (block) {
+		good_mirror = block->good_mirror;
+		cur_mirror = block->cur_mirror;
+	}
+	spin_unlock(&pc->pending_blocks_lock);
+	if (!block)
+		return 0;
+
+	if (test_bit(REDIRECT_READS, &pc->flags)) {
+		if (pc->split) {
+			*mirror = good_mirror;
+		} else {
+			memset(data, 0, bio_cur_bytes(bio));
+			ret = 1;
+		}
+	} else if (pc->split) {
+		*mirror = cur_mirror;
+	}
+
+	return ret;
+}
+
+static unsigned bio_bytes(struct bio *bio)
+{
+	if (!bio_has_data(bio))
+		return 0;
+
+	return bio_cur_bytes(bio);
+}
+
+static int pfail_map(struct dm_target *ti, struct bio *bio)
+{
+	struct pfail_ctx *pc = ti->private;
+	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
+	struct pending_block *block;
+	unsigned mirror = 0;
+	bool fua_bio = (bio->bi_rw & REQ_FUA);
+	bool flush_bio = (bio->bi_rw & REQ_FLUSH);
+
+	if (bio_sectors(bio) || flush_bio)
+		pb->track = true;
+	else
+		pb->track = false;
+	pb->pc = pc;
+	pb->block = NULL;
+
+	/*
+	 * Map reads as normal.
+	 */
+	if (bio_data_dir(bio) == READ) {
+		if (maybe_zero_bio(pc, bio, &mirror)) {
+			bio_endio(bio, 0);
+			return DM_MAPIO_SUBMITTED;
+		}
+		goto map_bio;
+	}
+
+	if (test_bit(DROP_WRITES, &pc->flags)) {
+		if (pc->error)
+			return -EIO;
+		pb->track = false;
+		bio_endio(bio, 0);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	/*
+	 * If we have just a naked REQ_FLUSH then we need to do alloc a dummy
+	 * block to hold the unflushed blocks.
+	 */
+	if (flush_bio && !fua_bio) {
+		struct pending_block *block;
+
+		block = kzalloc(sizeof(struct pending_block), GFP_NOIO);
+		if (!block) {
+			DMERR("Error allocating pending block");
+			return -ENOMEM;
+		}
+		INIT_LIST_HEAD(&block->list);
+
+		/*
+		 * IMPORTANT NOTE FOR FS DEVELOPERS!!!!
+		 *
+		 * We only take blocks that have already come through the end_io
+		 * handler as flushable blocks.  Anything that is still
+		 * outstanding IO at this point is assumed to be unflushable.
+		 */
+		spin_lock(&pc->pending_blocks_lock);
+		list_splice_init(&pc->unflushed_blocks, &block->list);
+		spin_unlock(&pc->pending_blocks_lock);
+		pb->block = block;
+	} else if (bio_data_dir(bio) == WRITE && bio_sectors(bio)) {
+		if (!pc->split && fua_bio)
+			goto map_bio;
+
+		block = kzalloc(sizeof(struct pending_block), GFP_NOIO);
+		if (!block) {
+			DMERR("Error allocating pending block");
+			return -ENOMEM;
+		}
+		block->bytenr = bio->bi_iter.bi_sector << 9;
+		block->bytes = bio_bytes(bio);
+		INIT_LIST_HEAD(&block->list);
+		spin_lock(&pc->pending_blocks_lock);
+		block = insert_pending_block(pc, block);
+		if (pc->split) {
+			if (block->good_mirror == 0 ||
+			    block->good_mirror == 1)
+				block->cur_mirror = 2;
+			else
+				block->cur_mirror = 1;
+			mirror = block->cur_mirror;
+		}
+		pb->block = block;
+
+		/*
+		 * If we do REQ_FLUSH|REQ_FUA we'll have an actual block and we
+		 * want to do the unflushed blocks dance here.
+		 */
+		if (flush_bio)
+			list_splice_init(&pc->unflushed_blocks, &block->list);
+		spin_unlock(&pc->pending_blocks_lock);
+	}
+map_bio:
+	pfail_map_bio(ti, bio, mirror);
+	return DM_MAPIO_REMAPPED;
+}
+
+static void pfail_write_end_io(struct work_struct *work)
+{
+	struct per_bio_data *pb = container_of(work, struct per_bio_data,
+					       work);
+	struct bio *bio;
+	struct pfail_ctx *pc = pb->pc;
+	struct pending_block *block;
+	bool flush, fua;
+
+	bio = dm_bio_from_per_bio_data(pb, sizeof(struct per_bio_data));
+	flush = bio->bi_rw & REQ_FLUSH;
+	fua = bio->bi_rw & REQ_FUA;
+	pb->track = false;
+	block = pb->block;
+
+	if (pc->endio_delay)
+		schedule_timeout(pc->endio_delay);
+
+	if (test_bit(DROP_WRITES, &pc->flags)) {
+		if (pc->error && !pb->error)
+			pb->error = -EIO;
+		if (flush && block && block->bytes == 0)
+			kfree(block);
+		goto out;
+	}
+
+	if (fua && test_bit(DROP_AFTER_FUA, &pc->flags)) {
+		if (test_and_set_bit(DROP_WRITES, &pc->flags)) {
+			if (pc->error && !pb->error)
+				pb->error = -EIO;
+			goto out;
+		}
+	}
+
+	if (flush && test_bit(DROP_AFTER_FLUSH, &pc->flags)) {
+		if (test_and_set_bit(DROP_WRITES, &pc->flags)) {
+			if (pc->error && !pb->error)
+				pb->error = -EIO;
+			goto out;
+		}
+	}
+
+	if (flush) {
+		struct pending_block *tmp, *n;
+
+		if (!block)
+			goto out;
+
+		spin_lock(&pc->pending_blocks_lock);
+		list_for_each_entry_safe(tmp, n, &block->list, list) {
+			list_del_init(&tmp->list);
+			if (pc->split) {
+				tmp->good_mirror = tmp->cur_mirror;
+			} else {
+				rb_erase(&tmp->node, &pc->pending_blocks);
+				kfree(tmp);
+			}
+			cond_resched_lock(&pc->pending_blocks_lock);
+		}
+		if (block->bytes != 0 && pc->split) {
+			block->good_mirror = block->cur_mirror;
+		} else if (block->bytes == 0) {
+			kfree(block);
+		}
+		spin_unlock(&pc->pending_blocks_lock);
+	} else if (fua) {
+		/*
+		 * FUA goes straight to disk, if it completes then the cur
+		 * mirror is the good mirror.
+		 */
+		if (pc->split) {
+			spin_lock(&pc->pending_blocks_lock);
+			block->good_mirror = block->cur_mirror;
+			spin_unlock(&pc->pending_blocks_lock);
+		}
+	} else if (block) {
+		spin_lock(&pc->pending_blocks_lock);
+		list_move_tail(&block->list, &pc->unflushed_blocks);
+		spin_unlock(&pc->pending_blocks_lock);
+	}
+out:
+	bio_endio(bio, pb->error);
+}
+
+static int pfail_end_io(struct dm_target *ti, struct bio *bio, int error)
+{
+	struct pfail_ctx *pc = ti->private;
+	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
+
+	if (bio_data_dir(bio) == WRITE && pb->track &&
+	    !test_bit(DROP_WRITES, &pc->flags)) {
+		pb->error = error;
+
+		atomic_inc(&bio->bi_remaining);
+		INIT_WORK(&pb->work, pfail_write_end_io);
+		schedule_work(&pb->work);
+		return DM_ENDIO_INCOMPLETE;
+	}
+
+	return error;
+}
+
+static void pfail_status(struct dm_target *ti, status_type_t type,
+			 unsigned status_flags, char *result, unsigned maxlen)
+{
+	unsigned sz = 0;
+	struct pfail_ctx *pc = ti->private;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		result[0] = '\0';
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %ld ", pc->dev->name, pc->endio_delay);
+
+		DMEMIT("%u ", pc->split + pc->error);
+
+		if (pc->split)
+			DMEMIT("split ");
+		if (pc->error)
+			DMEMIT("error_on_fail ");
+		break;
+	}
+}
+
+static int pfail_ioctl(struct dm_target *ti, unsigned int cmd, unsigned long arg)
+{
+	struct pfail_ctx *pc = ti->private;
+	struct dm_dev *dev = pc->dev;
+	int r = 0;
+
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
+	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
+}
+
+static int pfail_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+			struct bio_vec *biovec, int max_size)
+{
+	struct pfail_ctx *pc = ti->private;
+	struct request_queue *q = bdev_get_queue(pc->dev->bdev);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = pc->dev->bdev;
+	bvm->bi_sector = pfail_map_sector(ti, bvm->bi_sector, 0);
+
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
+static int pfail_iterate_devices(struct dm_target *ti,
+				 iterate_devices_callout_fn fn, void *data)
+{
+	struct pfail_ctx *pc = ti->private;
+
+	return fn(ti, pc->dev, 0, ti->len, data);
+}
+
+/*
+ * Valid messages
+ *
+ * drop_after_fua - drop all writes after the next seen fua write.
+ * drop_after_flush - drop all writes after the next seen flush write.
+ * drop_writes - drop all writes from now on.
+ * redirect_reads - start returning 0's/old data for reads done on unflushed
+ *	blocks.
+ * allow_writes - allow writes to start back up again.
+ */
+static int pfail_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct pfail_ctx *pc = ti->private;
+
+	if (argc != 1) {
+		DMWARN("Invalid power-fail message arguments, expect 1 "
+		       "argument, got %d", argc);
+		return -EINVAL;
+	}
+
+	if (!strcasecmp(argv[0], "redirect_reads")) {
+		set_bit(REDIRECT_READS, &pc->flags);
+	} else if (!strcasecmp(argv[0], "drop_after_fua")) {
+		set_bit(DROP_AFTER_FUA, &pc->flags);
+	} else if (!strcasecmp(argv[0], "drop_after_flush")) {
+		set_bit(DROP_AFTER_FLUSH, &pc->flags);
+	} else if (!strcasecmp(argv[0], "drop_writes")) {
+		set_bit(DROP_WRITES, &pc->flags);
+	} else if (!strcasecmp(argv[0], "allow_writes")) {
+		clear_bit(DROP_WRITES, &pc->flags);
+		clear_bit(DROP_AFTER_FUA, &pc->flags);
+		clear_bit(DROP_AFTER_FLUSH, &pc->flags);
+	} else {
+		DMWARN("Invalid argument %s", argv[0]);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct target_type pfail_target = {
+	.name   = "power-fail",
+	.version = {1, 3, 1},
+	.module = THIS_MODULE,
+	.ctr    = pfail_ctr,
+	.dtr    = pfail_dtr,
+	.map    = pfail_map,
+	.end_io = pfail_end_io,
+	.status = pfail_status,
+	.ioctl	= pfail_ioctl,
+	.merge	= pfail_merge,
+	.message = pfail_message,
+	.iterate_devices = pfail_iterate_devices,
+};
+
+static int __init dm_pfail_init(void)
+{
+	int r = dm_register_target(&pfail_target);
+
+	if (r < 0)
+		DMERR("register failed %d", r);
+
+	return r;
+}
+
+static void __exit dm_pfail_exit(void)
+{
+	dm_unregister_target(&pfail_target);
+}
+
+/* Module hooks */
+module_init(dm_pfail_init);
+module_exit(dm_pfail_exit);
+
+MODULE_DESCRIPTION(DM_NAME " power fail target");
+MODULE_AUTHOR("Josef Bacik <jbacik@fb.com>");
+MODULE_LICENSE("GPL");
-- 
1.8.3.1

