Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933754AbbFJP0v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 11:26:51 -0400
Date: Wed, 10 Jun 2015 11:26:49 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-btrfs@vger.kernel.org
Subject: Re: block: add a bi_error field to struct bio
Message-ID: <20150610152649.GA31140@redhat.com>
References: <1433338959-24808-1-git-send-email-hch@lst.de>
 <1433338959-24808-2-git-send-email-hch@lst.de>
 <20150604153106.GA31567@redhat.com>
 <20150610081138.GA3841@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150610081138.GA3841@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 10 2015 at  4:11am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Jun 04, 2015 at 11:31:07AM -0400, Mike Snitzer wrote:
> > This patch _really_ concerns me because just in DM alone I found you
> > took liberties that you shouldn't have and created a regression.  First
> > issue is a real bug (your proposed dm-io.c:dmio_complete change missed
> > that dm-io uses error_bits and not traditional error code like expected)
> 
> Point taken.  I already wanted to complain about the mess due to the bio
> error abuse with it's own values in DM in the first posting, guess I
> need to add that to the second one.  I don't think overloading common
> interfaces with your private error codes is a good idea, but let's
> leave that for a separate discussion.

I'll queue a patch to rename 'error' to 'error_bits' where appropriate.

> > the other issue being you added extra branching that isn't needed and
> > made review more tedious (dm.c:clone_endio).
> 
> I think the code is better than what it was before, but it's still
> a bit of a mess.  What do you think of the patch below which I'd
> like to add before the big bi_error patch as a preparatory one?

If you're referring to the mix of error variables I totally agree.  Just
don't think we need the extra branching.
 
> > For DM, please add Signed-off-by: Mike Snitzer <snitzer@redhat.com> once
> > you've folded in this patch, thanks!
> 
> FYI, that wasn't a foldable patch but updated hunks of the old one.  Not
> really a problem, but a little confusing.

Yeap, should have been clearer they were meant to replace your hunks.

> >From f095cbeba5135afa6cf102718319f0d0c1e7b422 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 10 Jun 2015 10:04:45 +0200
> Subject: dm: use a single error code variable in clone_endio
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> clone_endio currently uses two variables for tracking error state, with
> values getting bounceѕ forth and back between the two, which makes the
> code hard to read.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 2161ed9..8467976 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -956,7 +956,6 @@ static void disable_write_same(struct mapped_device *md)
>  
>  static void clone_endio(struct bio *bio, int error)
>  {
> -	int r = error;
>  	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
>  	struct dm_io *io = tio->io;
>  	struct mapped_device *md = tio->io->md;
> @@ -966,23 +965,22 @@ static void clone_endio(struct bio *bio, int error)
>  		error = -EIO;
>  
>  	if (endio) {
> -		r = endio(tio->ti, bio, error);
> -		if (r < 0 || r == DM_ENDIO_REQUEUE)
> -			/*
> -			 * error and requeue request are handled
> -			 * in dec_pending().
> -			 */
> -			error = r;
> -		else if (r == DM_ENDIO_INCOMPLETE)
> +		error = endio(tio->ti, bio, error);
> +		if (error == DM_ENDIO_INCOMPLETE) {
>  			/* The target will handle the io */
>  			return;
> -		else if (r) {
> -			DMWARN("unimplemented target endio return value: %d", r);
> +		}
> +
> +		if (error > 0 && error != DM_ENDIO_REQUEUE) {
> +			DMWARN("unimplemented target endio return value: %d",
> +				error);
>  			BUG();
>  		}
> +
> +		/* Error and requeue request are handled in dec_pending(). */
>  	}
>  
> -	if (unlikely(r == -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &&
> +	if (unlikely(error == -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &&
>  		     !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors))
>  		disable_write_same(md);
>  
> -- 
> 1.9.1

Unfortunately by dropping the original error (e.g. -EREMOTEIO) on the
floor (in the 'if (endio) {' branch) you're breaking the REQ_WRITE_SAME
check.

Your new bi_error patch gets away with the redundant error code cleanup
because we can directly check the bio's bi_error for -EREMOTEIO.  So
feel free to fold the simplified 'if (error > 0 && error != DM_ENDIO_REQUEUE) {'
in to your new patch -- but not seeing the point of making this prep
patch in advance.
