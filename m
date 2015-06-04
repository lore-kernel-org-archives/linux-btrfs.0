Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbbFDPbI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jun 2015 11:31:08 -0400
Date: Thu, 4 Jun 2015 11:31:07 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-btrfs@vger.kernel.org
Subject: Re: block: add a bi_error field to struct bio
Message-ID: <20150604153106.GA31567@redhat.com>
References: <1433338959-24808-1-git-send-email-hch@lst.de>
 <1433338959-24808-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433338959-24808-2-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 03 2015 at  9:42P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Currently we have two different ways to signal an I/O error on a BIO:
> 
>  (1) by clearing the BIO_UPTODATE flag
>  (2) by returning a Linux errno value to the bi_end_io callback
> 
> The first one has the drawback of only communicating a single possible
> error (-EIO), and the second one has the drawback of not beeing persistent
> when bios are queued up, and are not passed along from child to parent
> bio in the ever more popular chaining scenario.  Having both mechanisms
> available has the additional drawback of utterly confusing driver authors
> and introducing bugs where various I/O submitters only deal with one of
> them, and the others have to add boilerplate code to deal with both kinds
> of error returns.
> 
> So add a new bi_error field to store an errno value directly in struct
> bio and remove the existing mechanisms to clean all this up.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This patch _really_ concerns me because just in DM alone I found you
took liberties that you shouldn't have and created a regression.  First
issue is a real bug (your proposed dm-io.c:dmio_complete change missed
that dm-io uses error_bits and not traditional error code like expected)
the other issue being you added extra branching that isn't needed and
made review more tedious (dm.c:clone_endio).

I'll defer to others to check their respective areas of expertise but my
experience with this review should really underscore the need for more
eyes on this patch.  That said, I do appreciate your effort on cleaning
this up!

For DM, please add Signed-off-by: Mike Snitzer <snitzer@redhat.com> once
you've folded in this patch, thanks!

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 86dbbc7..d2fc49f 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -545,7 +545,8 @@ static void dmio_complete(unsigned long error, void *context)
 {
 	struct dm_buffer *b = context;
 
-	b->bio.bi_end_io(&b->bio, error ? -EIO : 0);
+	b->bio.bi_error = error ? -EIO : 0;
+	b->bio.bi_end_io(&b->bio);
 }
 
 static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 767bce9..85a7c3d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -954,25 +954,22 @@ static void disable_write_same(struct mapped_device *md)
 	limits->max_write_same_sectors = 0;
 }
 
-static void clone_endio(struct bio *bio, int error)
+static void clone_endio(struct bio *bio)
 {
-	int r = error;
+	int r = bio->bi_error;
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
-	if (!bio_flagged(bio, BIO_UPTODATE) && !error)
-		error = -EIO;
-
 	if (endio) {
-		r = endio(tio->ti, bio, error);
+		r = endio(tio->ti, bio, bio->bi_error);
 		if (r < 0 || r == DM_ENDIO_REQUEUE)
 			/*
 			 * error and requeue request are handled
 			 * in dec_pending().
 			 */
-			error = r;
+			;
 		else if (r == DM_ENDIO_INCOMPLETE)
 			/* The target will handle the io */
 			return;
@@ -987,7 +984,7 @@ static void clone_endio(struct bio *bio, int error)
 		disable_write_same(md);
 
 	free_tio(md, tio);
-	dec_pending(io, error);
+	dec_pending(io, r);
 }
 
 static struct dm_rq_target_io *tio_from_request(struct request *rq)
