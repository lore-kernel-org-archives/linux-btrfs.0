Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:32776 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934955AbdEZI5N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 04:57:13 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 10/13] dm: change ->end_io calling convention
Date: Fri, 26 May 2017 11:56:17 +0300
Message-Id: <20170526085620.3113-11-hch@lst.de>
In-Reply-To: <20170526085620.3113-1-hch@lst.de>
References: <20170526085620.3113-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Turn the error paramter into a pointer so that target drivers can change
the value, and make sure only DM_ENDIO_* values are returned from the
methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-cache-target.c  |  4 ++--
 drivers/md/dm-flakey.c        |  8 ++++----
 drivers/md/dm-log-writes.c    |  4 ++--
 drivers/md/dm-mpath.c         | 11 ++++++-----
 drivers/md/dm-raid1.c         | 14 +++++++-------
 drivers/md/dm-snap.c          |  4 ++--
 drivers/md/dm-stripe.c        | 14 +++++++-------
 drivers/md/dm-thin.c          |  4 ++--
 drivers/md/dm.c               | 36 ++++++++++++++++++------------------
 include/linux/device-mapper.h |  2 +-
 10 files changed, 51 insertions(+), 50 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index d682a0511381..c48612e6d525 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2820,7 +2820,7 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
 	return r;
 }
 
-static int cache_end_io(struct dm_target *ti, struct bio *bio, int error)
+static int cache_end_io(struct dm_target *ti, struct bio *bio, int *error)
 {
 	struct cache *cache = ti->private;
 	unsigned long flags;
@@ -2838,7 +2838,7 @@ static int cache_end_io(struct dm_target *ti, struct bio *bio, int error)
 	bio_drop_shared_lock(cache, bio);
 	accounted_complete(cache, bio);
 
-	return 0;
+	return DM_ENDIO_DONE;
 }
 
 static int write_dirty_bitset(struct cache *cache)
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index e8f093b323ce..c9539917a59b 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -358,12 +358,12 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-static int flakey_end_io(struct dm_target *ti, struct bio *bio, int error)
+static int flakey_end_io(struct dm_target *ti, struct bio *bio, int *error)
 {
 	struct flakey_c *fc = ti->private;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 
-	if (!error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
+	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
 		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
 		    all_corrupt_bio_flags_match(bio, fc)) {
 			/*
@@ -377,11 +377,11 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio, int error)
 			 * Error read during the down_interval if drop_writes
 			 * and error_writes were not configured.
 			 */
-			return -EIO;
+			*error = -EIO;
 		}
 	}
 
-	return error;
+	return DM_ENDIO_DONE;
 }
 
 static void flakey_status(struct dm_target *ti, status_type_t type,
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index e42264706c59..cc57c7fa1268 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -664,7 +664,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-static int normal_end_io(struct dm_target *ti, struct bio *bio, int error)
+static int normal_end_io(struct dm_target *ti, struct bio *bio, int *error)
 {
 	struct log_writes_c *lc = ti->private;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
@@ -686,7 +686,7 @@ static int normal_end_io(struct dm_target *ti, struct bio *bio, int error)
 		spin_unlock_irqrestore(&lc->blocks_lock, flags);
 	}
 
-	return error;
+	return DM_ENDIO_DONE;
 }
 
 /*
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bf6e49c780d5..ceeeb495d01c 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1517,14 +1517,15 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	return r;
 }
 
-static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone, int error)
+static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone, int *error)
 {
 	struct multipath *m = ti->private;
 	struct dm_mpath_io *mpio = get_mpio_from_bio(clone);
 	struct pgpath *pgpath = mpio->pgpath;
 	unsigned long flags;
+	int r = DM_ENDIO_DONE;
 
-	if (!error || noretry_error(error))
+	if (!*error || noretry_error(*error))
 		goto done;
 
 	if (pgpath)
@@ -1533,7 +1534,7 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone, int err
 	if (atomic_read(&m->nr_valid_paths) == 0 &&
 	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
 		dm_report_EIO(m);
-		error = -EIO;
+		*error = -EIO;
 		goto done;
 	}
 
@@ -1546,7 +1547,7 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone, int err
 	if (!test_bit(MPATHF_QUEUE_IO, &m->flags))
 		queue_work(kmultipathd, &m->process_queued_bios);
 
-	error = DM_ENDIO_INCOMPLETE;
+	r = DM_ENDIO_INCOMPLETE;
 done:
 	if (pgpath) {
 		struct path_selector *ps = &pgpath->pg->ps;
@@ -1555,7 +1556,7 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone, int err
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
 
-	return error;
+	return r;
 }
 
 /*
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index d9c0c6a77eb5..77bcf50ce75f 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1236,7 +1236,7 @@ static int mirror_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
+static int mirror_end_io(struct dm_target *ti, struct bio *bio, int *error)
 {
 	int rw = bio_data_dir(bio);
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
@@ -1252,16 +1252,16 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
 		if (!(bio->bi_opf & REQ_PREFLUSH) &&
 		    bio_op(bio) != REQ_OP_DISCARD)
 			dm_rh_dec(ms->rh, bio_record->write_region);
-		return error;
+		return DM_ENDIO_DONE;
 	}
 
-	if (error == -EOPNOTSUPP)
-		return error;
+	if (*error == -EOPNOTSUPP)
+		return DM_ENDIO_DONE;
 
 	if (bio->bi_opf & REQ_RAHEAD)
-		return error;
+		return DM_ENDIO_DONE;
 
-	if (unlikely(error)) {
+	if (unlikely(*error)) {
 		m = bio_record->m;
 
 		DMERR("Mirror read failed from %s. Trying alternative device.",
@@ -1285,7 +1285,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
 		DMERR("All replicated volumes dead, failing I/O");
 	}
 
-	return error;
+	return DM_ENDIO_DONE;
 }
 
 static void mirror_presuspend(struct dm_target *ti)
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5a7f73f9a6fb..79a845798e2f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1851,14 +1851,14 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
 	return r;
 }
 
-static int snapshot_end_io(struct dm_target *ti, struct bio *bio, int error)
+static int snapshot_end_io(struct dm_target *ti, struct bio *bio, int *error)
 {
 	struct dm_snapshot *s = ti->private;
 
 	if (is_bio_tracked(bio))
 		stop_tracking_chunk(s, bio);
 
-	return 0;
+	return DM_ENDIO_DONE;
 }
 
 static void snapshot_merge_presuspend(struct dm_target *ti)
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 780e95889a7c..49888bc2c909 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -375,20 +375,20 @@ static void stripe_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int stripe_end_io(struct dm_target *ti, struct bio *bio, int error)
+static int stripe_end_io(struct dm_target *ti, struct bio *bio, int *error)
 {
 	unsigned i;
 	char major_minor[16];
 	struct stripe_c *sc = ti->private;
 
-	if (!error)
-		return 0; /* I/O complete */
+	if (!*error)
+		return DM_ENDIO_DONE; /* I/O complete */
 
 	if (bio->bi_opf & REQ_RAHEAD)
-		return error;
+		return DM_ENDIO_DONE;
 
-	if (error == -EOPNOTSUPP)
-		return error;
+	if (*error == -EOPNOTSUPP)
+		return DM_ENDIO_DONE;
 
 	memset(major_minor, 0, sizeof(major_minor));
 	sprintf(major_minor, "%d:%d",
@@ -409,7 +409,7 @@ static int stripe_end_io(struct dm_target *ti, struct bio *bio, int error)
 				schedule_work(&sc->trigger_event);
 		}
 
-	return error;
+	return DM_ENDIO_DONE;
 }
 
 static int stripe_iterate_devices(struct dm_target *ti,
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 17ad50daed08..22b1a64c44b7 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4177,7 +4177,7 @@ static int thin_map(struct dm_target *ti, struct bio *bio)
 	return thin_bio_map(ti, bio);
 }
 
-static int thin_endio(struct dm_target *ti, struct bio *bio, int err)
+static int thin_endio(struct dm_target *ti, struct bio *bio, int *err)
 {
 	unsigned long flags;
 	struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
@@ -4212,7 +4212,7 @@ static int thin_endio(struct dm_target *ti, struct bio *bio, int err)
 	if (h->cell)
 		cell_defer_no_holder(h->tc, h->cell);
 
-	return 0;
+	return DM_ENDIO_DONE;
 }
 
 static void thin_presuspend(struct dm_target *ti)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 499f8209bacf..7a7047211c64 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -845,24 +845,7 @@ static void clone_endio(struct bio *bio)
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
-	if (endio) {
-		r = endio(tio->ti, bio, error);
-		if (r < 0 || r == DM_ENDIO_REQUEUE)
-			/*
-			 * error and requeue request are handled
-			 * in dec_pending().
-			 */
-			error = r;
-		else if (r == DM_ENDIO_INCOMPLETE)
-			/* The target will handle the io */
-			return;
-		else if (r) {
-			DMWARN("unimplemented target endio return value: %d", r);
-			BUG();
-		}
-	}
-
-	if (unlikely(r == -EREMOTEIO)) {
+	if (unlikely(error == -EREMOTEIO)) {
 		if (bio_op(bio) == REQ_OP_WRITE_SAME &&
 		    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
 			disable_write_same(md);
@@ -871,6 +854,23 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
+	if (endio) {
+		r = endio(tio->ti, bio, &error);
+		switch (r) {
+		case DM_ENDIO_REQUEUE:
+			error = DM_ENDIO_REQUEUE;
+			/*FALLTHRU*/
+		case DM_ENDIO_DONE:
+			break;
+		case DM_ENDIO_INCOMPLETE:
+			/* The target will handle the io */
+			return;
+		default:
+			DMWARN("unimplemented target endio return value: %d", r);
+			BUG();
+		}
+	}
+
 	free_tio(tio);
 	dec_pending(io, error);
 }
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index f4c639c0c362..dec227acc13b 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -72,7 +72,7 @@ typedef void (*dm_release_clone_request_fn) (struct request *clone);
  * 2   : The target wants to push back the io
  */
 typedef int (*dm_endio_fn) (struct dm_target *ti,
-			    struct bio *bio, int error);
+			    struct bio *bio, int *error);
 typedef int (*dm_request_endio_fn) (struct dm_target *ti,
 				    struct request *clone, int error,
 				    union map_info *map_context);
-- 
2.11.0

