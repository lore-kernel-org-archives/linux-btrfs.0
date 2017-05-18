Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54641 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934091AbdERNSr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 09:18:47 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 08/15] dm mpath: merge do_end_io_bio into multipath_end_io_bio
Date: Thu, 18 May 2017 15:18:05 +0200
Message-Id: <20170518131812.22956-9-hch@lst.de>
In-Reply-To: <20170518131812.22956-1-hch@lst.de>
References: <20170518131812.22956-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This simplifies the code and especially the error passing a bit and
will help with the next patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 3df056b73b66..b1cb0273b081 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1510,24 +1510,26 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	return r;
 }
 
-static int do_end_io_bio(struct multipath *m, struct bio *clone,
-			 int error, struct dm_mpath_io *mpio)
+static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone, int error)
 {
+	struct multipath *m = ti->private;
+	struct dm_mpath_io *mpio = get_mpio_from_bio(clone);
+	struct pgpath *pgpath = mpio->pgpath;
 	unsigned long flags;
 
-	if (!error)
-		return 0;	/* I/O complete */
+	BUG_ON(!mpio);
 
-	if (noretry_error(error))
-		return error;
+	if (!error || noretry_error(error))
+		goto done;
 
-	if (mpio->pgpath)
-		fail_path(mpio->pgpath);
+	if (pgpath)
+		fail_path(pgpath);
 
 	if (atomic_read(&m->nr_valid_paths) == 0 &&
 	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
 		dm_report_EIO(m);
-		return -EIO;
+		error = -EIO;
+		goto done;
 	}
 
 	/* Queue for the daemon to resubmit */
@@ -1539,28 +1541,16 @@ static int do_end_io_bio(struct multipath *m, struct bio *clone,
 	if (!test_bit(MPATHF_QUEUE_IO, &m->flags))
 		queue_work(kmultipathd, &m->process_queued_bios);
 
-	return DM_ENDIO_INCOMPLETE;
-}
-
-static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone, int error)
-{
-	struct multipath *m = ti->private;
-	struct dm_mpath_io *mpio = get_mpio_from_bio(clone);
-	struct pgpath *pgpath;
-	struct path_selector *ps;
-	int r;
-
-	BUG_ON(!mpio);
-
-	r = do_end_io_bio(m, clone, error, mpio);
-	pgpath = mpio->pgpath;
+	error = DM_ENDIO_INCOMPLETE;
+done:
 	if (pgpath) {
-		ps = &pgpath->pg->ps;
+		struct path_selector *ps = &pgpath->pg->ps;
+
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
 
-	return r;
+	return error;
 }
 
 /*
-- 
2.11.0

