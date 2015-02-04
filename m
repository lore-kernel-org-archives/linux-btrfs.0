Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161518AbbBDSlm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 13:41:42 -0500
Date: Wed, 4 Feb 2015 13:41:09 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, dm-devel@redhat.com, david@fromorbit.com,
        sandeen@redhat.com, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, clm@facebook.com, zab@redhat.com
Subject: Re: [PATCH][RFC] dm: log writes target
Message-ID: <20150204184108.GA2801@redhat.com>
References: <1418077949-28771-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418077949-28771-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 08 2014 at  5:32P -0500,
Josef Bacik <jbacik@fb.com> wrote:

> This is my latest attempt at a target for testing power fail and fs consistency.
> This is based on the idea Zach Brown had where we could just walk through all
> the operations done to an fs in order to verify we're doing the correct thing.
> There is a userspace component as well that can be found here
> 
> https://github.com/josefbacik/log-writes
> 
> It is very rough as I just threw it together to test the various aspects of how
> you would want to replay a log to test it.  Again I would love feedback on this,
> I really want to have something that we all think is usefull and eventually
> incorporate it into xfstests.

hey josef,

i finally took a quick look at your target.  has this target proven
useful to you (or others) since you posted?  would you still like to see
this land upstream?

i see no need to stack discard limits if discards are supported by the
underlying device (you'll get that for free via blk_stack_limits).

here is a patch that applies ontop of your original submission.  mostly
whitespace (i'm not pedantic about 80 char limit, etc).  but i did
include some small improvements and FIXMEs/questions in the patch:

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 4aa627a..3c84777 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -137,7 +137,7 @@ static void log_end_io(struct bio *bio, int err)
 	if (err) {
 		unsigned long flags;
 
-		DMERR("Error writing log block %d\n", err);
+		DMERR("Error writing log block %d", err);
 		spin_lock_irqsave(&lc->blocks_lock, flags);
 		lc->logging_enabled = false;
 		spin_unlock_irqrestore(&lc->blocks_lock, flags);
@@ -335,8 +335,7 @@ static int log_writes_kthread(void *arg)
 		spin_lock_irq(&lc->blocks_lock);
 		if (!list_empty(&lc->logging_blocks)) {
 			block = list_first_entry(&lc->logging_blocks,
-						 struct pending_block,
-						 list);
+						 struct pending_block, list);
 			list_del_init(&block->list);
 			if (!lc->logging_enabled)
 				goto next;
@@ -362,8 +361,7 @@ static int log_writes_kthread(void *arg)
 			lc->logged_entries++;
 			atomic_inc(&lc->io_blocks);
 
-			super = (block->flags &
-				 (LOG_FUA_FLAG | LOG_MARK_FLAG));
+			super = (block->flags & (LOG_FUA_FLAG | LOG_MARK_FLAG));
 			if (super)
 				atomic_inc(&lc->io_blocks);
 		}
@@ -380,9 +378,8 @@ next:
 					lc->logging_enabled = false;
 					spin_unlock_irq(&lc->blocks_lock);
 				}
-			} else {
+			} else
 				free_pending_block(lc, block);
-			}
 			continue;
 		}
 
@@ -429,15 +426,13 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	atomic_set(&lc->pending_blocks, 0);
 
 	devname = dm_shift_arg(&as);
-	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table),
-			  &lc->dev)) {
+	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table), &lc->dev)) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
 
 	logdevname = dm_shift_arg(&as);
-	if (dm_get_device(ti, logdevname, dm_table_get_mode(ti->table),
-			  &lc->logdev)) {
+	if (dm_get_device(ti, logdevname, dm_table_get_mode(ti->table), &lc->logdev)) {
 		ti->error = "Log device lookup failed";
 		dm_put_device(ti, lc->dev);
 		goto bad;
@@ -477,13 +472,13 @@ static int log_mark(struct log_writes_c *lc, char *data)
 
 	block = kzalloc(sizeof(struct pending_block), GFP_KERNEL);
 	if (!block) {
-		DMERR("Error allocating pending block\n");
+		DMERR("Error allocating pending block");
 		return -ENOMEM;
 	}
 
 	block->data = kstrndup(data, maxsize, GFP_KERNEL);
 	if (!block->data) {
-		DMERR("Error copying mark data\n");
+		DMERR("Error copying mark data");
 		kfree(block);
 		return -ENOMEM;
 	}
@@ -527,9 +522,10 @@ static void normal_map_bio(struct dm_target *ti, struct bio *bio)
 	struct log_writes_c *lc = ti->private;
 
 	bio->bi_bdev = lc->dev->bdev;
+	// FIXME: why would bi_sector ever need to be changed?
+	// if you just copied dm-linear then it is misplaced since there isn't an offset
 	if (bio_sectors(bio))
-		bio->bi_iter.bi_sector =
-			dm_target_offset(ti, bio->bi_iter.bi_sector);
+		bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
 }
 
 static int log_writes_map(struct dm_target *ti, struct bio *bio)
@@ -568,8 +564,8 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	if (discard_bio)
 		alloc_size = sizeof(struct pending_block);
 	else
-		alloc_size = sizeof(struct pending_block) +
-			sizeof(struct bio_vec) * bio_segments(bio);
+		alloc_size = sizeof(struct pending_block) + sizeof(struct bio_vec) * bio_segments(bio);
+
 	block = kzalloc(alloc_size, GFP_NOIO);
 	if (!block) {
 		DMERR("Error allocating pending block");
@@ -614,6 +610,9 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	 * the actual contents into new pages so we know the data will always be
 	 * there.
 	 */
+	// FIXME: why not just hold onto the original bio until "way later"?
+	// would doing so compromise the target's function?
+	// seems it'd avoid all this duplication (of state and data) in pending_block
 	bio_for_each_segment(bv, bio, iter) {
 		struct page *page;
 		void *src, *dst;
@@ -661,16 +660,14 @@ static int normal_end_io(struct dm_target *ti, struct bio *bio, int error)
 
 		spin_lock_irqsave(&lc->blocks_lock, flags);
 		if (block->flags & LOG_FLUSH_FLAG) {
-			list_splice_tail_init(&block->list,
-					      &lc->logging_blocks);
+			list_splice_tail_init(&block->list, &lc->logging_blocks);
 			list_add_tail(&block->list, &lc->logging_blocks);
 			wake_up_process(lc->log_kthread);
 		} else if (block->flags & LOG_FUA_FLAG) {
 			list_add_tail(&block->list, &lc->logging_blocks);
 			wake_up_process(lc->log_kthread);
-		} else {
+		} else
 			list_add_tail(&block->list, &lc->unflushed_blocks);
-		}
 		spin_unlock_irqrestore(&lc->blocks_lock, flags);
 	}
 
@@ -692,11 +689,11 @@ static void log_writes_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%llu %llu", lc->logged_entries,
 		       (unsigned long long)lc->next_sector - 1);
 		if (!lc->logging_enabled)
-			DMEMIT(" logging disabled");
+			DMEMIT(" logging_disabled");
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s %s ", lc->dev->name, lc->logdev->name);
+		DMEMIT("%s %s", lc->dev->name, lc->logdev->name);
 		break;
 	}
 }
@@ -742,57 +739,37 @@ static int log_writes_iterate_devices(struct dm_target *ti,
 }
 
 /*
- * Valid messages
- *
- * mark <mark data> - specify the marked data.
+ * Messages supported:
+ *   mark <mark data> - specify the marked data.
  */
 static int log_writes_message(struct dm_target *ti, unsigned argc, char **argv)
 {
+	int r = -EINVAL;
 	struct log_writes_c *lc = ti->private;
 
 	if (argc != 2) {
-		DMWARN("Invalid log-writes message arguments, expect 2 "
-		       "argument, got %d", argc);
-		return -EINVAL;
+		DMWARN("Invalid log-writes message arguments, expect 2 arguments, got %d", argc);
+		return r;
 	}
 
-	if (!strcasecmp(argv[0], "mark")) {
-		int ret;
-
-		ret = log_mark(lc, argv[1]);
-		if (ret)
-			return ret;
-	} else {
-		DMWARN("Invalid argument %s", argv[0]);
-		return -EINVAL;
-	}
+	if (!strcasecmp(argv[0], "mark"))
+		r = log_mark(lc, argv[1]);
+	else
+		DMWARN("Unrecognised log writes target message received: %s", argv[0]);
 
-	return 0;
+	return r;
 }
 
-static void log_writes_io_hints(struct dm_target *ti,
-			       struct queue_limits *limits)
+static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct log_writes_c *lc = ti->private;
 	struct request_queue *q = bdev_get_queue(lc->dev->bdev);
-	sector_t max_discard = (UINT_MAX >> SECTOR_SHIFT);
 
-	if (!q || !blk_queue_discard(q))
+	if (!q || !blk_queue_discard(q)) {
 		lc->device_supports_discard = false;
-
-	if (lc->device_supports_discard) {
-		struct queue_limits *data_limits = &q->limits;
-		limits->max_discard_sectors =
-			min_t(unsigned int, data_limits->max_discard_sectors,
-			      max_discard);
-		limits->discard_granularity =
-			max_t(unsigned int, data_limits->discard_granularity,
-			      1 << SECTOR_SHIFT);
-	} else {
 		limits->discard_granularity = 1 << SECTOR_SHIFT;
-		limits->max_discard_sectors = max_discard;
+		limits->max_discard_sectors = (UINT_MAX >> SECTOR_SHIFT);
 	}
-	dump_stack();
 }
 
 static struct target_type log_writes_target = {
@@ -830,6 +807,6 @@ static void __exit dm_log_writes_exit(void)
 module_init(dm_log_writes_init);
 module_exit(dm_log_writes_exit);
 
-MODULE_DESCRIPTION(DM_NAME " write log target");
+MODULE_DESCRIPTION(DM_NAME " log writes target");
 MODULE_AUTHOR("Josef Bacik <jbacik@fb.com>");
 MODULE_LICENSE("GPL");
