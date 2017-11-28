Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50063 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdK2ADY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 19:03:24 -0500
Date: Tue, 28 Nov 2017 16:01:24 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/7] Btrfs: retry write for non-raid56
Message-ID: <20171128230123.GB11789@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
 <20171122003558.28722-4-bo.li.liu@oracle.com>
 <5523d8a5-1a91-50e6-fb88-01699fd59cff@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5523d8a5-1a91-50e6-fb88-01699fd59cff@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 22, 2017 at 04:41:10PM +0200, Nikolay Borisov wrote:
> 
> 
> On 22.11.2017 02:35, Liu Bo wrote:
> > If the underlying protocal doesn't support retry and there are some
> > transient errors happening somewhere in our IO stack, we'd like to
> > give an extra chance for IO.
> > 
> > In btrfs, read retry is handled in bio_readpage_error() with the retry
> > unit being page size , for write retry however, we're going to do it
> > in a different way, as a write may consist of several writes onto
> > different stripes, retry write needs to be done right after the IO on
> > each stripe completes and reaches to endio.
> > 
> > As write errors are really corner cases, performance impact is not
> > considered.
> > 
> > This adds code to retry write on errors _sector by sector_ in order to
> > find out which sector is really bad so that we can mark it somewhere.
> > And since endio is running in interrupt context, the real retry work
> > is scheduled in system_unbound_wq in order to get a normal context.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/volumes.c | 162 +++++++++++++++++++++++++++++++++++++++++++++--------
> >  fs/btrfs/volumes.h |   3 +
> >  2 files changed, 142 insertions(+), 23 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 853f9ce..c11db0b 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -6023,34 +6023,150 @@ static void __btrfs_end_bio(struct bio *bio)
> >  	}
> >  }
> >  
> > -static void btrfs_end_bio(struct bio *bio)
> > +static inline struct btrfs_device *get_device_from_bio(struct bio *bio)
> >  {
> >  	struct btrfs_bio *bbio = bio->bi_private;
> > -	int is_orig_bio = 0;
> > +	unsigned int stripe_index = btrfs_io_bio(bio)->stripe_index;
> > +
> > +	BUG_ON(stripe_index >= bbio->num_stripes);
> > +	return bbio->stripes[stripe_index].dev;
> > +}
> > +
> > +/*
> > + * return 1 if every sector retry returns successful.
> > + * return 0 if one or more sector retries fails.
> > + */
> > +int btrfs_narrow_write_error(struct bio *bio, struct btrfs_device *dev)
> > +{
> > +	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
> > +	u64 sectors_to_write;
> > +	u64 offset;
> > +	u64 orig;
> > +	u64 unit;
> > +	u64 block_sectors;
> > +	int ok = 1;
> > +	struct bio *wbio;
> > +
> > +	/* offset and unit are bytes aligned, not 512-bytes aligned. */
> > +	sectors_to_write = io_bio->iter.bi_size >> 9;
> > +	orig = io_bio->iter.bi_sector;
> > +	offset = 0;
> > +	block_sectors = bdev_logical_block_size(dev->bdev) >> 9;
> > +	unit = block_sectors;
> > +	ASSERT(unit == 1);
> > +
> > +	while (1) {
> > +		if (!sectors_to_write)
> > +			break;
> > +		/*
> > +		 * LIUBO: I don't think unit > sectors_to_write could
> > +		 * happen, sectors_to_write should be aligned to PAGE_SIZE
> > +		 * which is > unit.  Just in case.
> > +		 */
> > +		if (unit > sectors_to_write) {
> > +			WARN_ONCE(1, "unit %llu > sectors_to_write (%llu)\n", unit, sectors_to_write);
> > +			unit = sectors_to_write;
> > +		}
> > +
> > +		/* write @unit bytes at @offset */
> > +		/* this would never fail, check btrfs_bio_clone(). */
> > +		wbio = btrfs_bio_clone(bio);
> > +		wbio->bi_opf = REQ_OP_WRITE;
> > +		wbio->bi_iter = io_bio->iter;
> > +
> > +		bio_trim(wbio, offset, unit);
> > +		bio_copy_dev(wbio, bio);
> > +
> > +		/* submit in sync way */
> > +		/*
> > +		 * LIUBO: There is an issue, if this bio is quite
> > +		 * large, say 1M or 2M, and sector size is just 512,
> > +		 * then this may take a while.
> > +		 *
> > +		 * May need to schedule the job to workqueue.
> > +		 */
> > +		if (submit_bio_wait(wbio) < 0) {
> > +			ok = 0 && ok;
> > +			/*
> > +			 * This is not correct if badblocks is enabled
> > +			 * as we need to record every bad sector by
> > +			 * trying sectors one by one.
> > +			 */
> > +			break;
> > +		}
> > +
> > +		bio_put(wbio);
> > +		offset += unit;
> > +		sectors_to_write -= unit;
> > +		unit = block_sectors;
> > +	}
> > +	return ok;
> > +}
> > +
> > +void btrfs_record_bio_error(struct bio *bio, struct btrfs_device *dev)
> > +{
> > +	if (bio->bi_status == BLK_STS_IOERR ||
> > +	    bio->bi_status == BLK_STS_TARGET) {
> > +		if (dev->bdev) {
> > +			if (bio_data_dir(bio) == WRITE)
> > +				btrfs_dev_stat_inc(dev,
> > +						   BTRFS_DEV_STAT_WRITE_ERRS);
> > +			else
> > +				btrfs_dev_stat_inc(dev,
> > +						   BTRFS_DEV_STAT_READ_ERRS);
> > +			if (bio->bi_opf & REQ_PREFLUSH)
> > +				btrfs_dev_stat_inc(dev,
> > +						   BTRFS_DEV_STAT_FLUSH_ERRS);
> > +			btrfs_dev_stat_print_on_error(dev);
> > +		}
> > +	}
> > +}
> > +
> > +static void btrfs_handle_bio_error(struct work_struct *work)
> > +{
> > +	struct btrfs_io_bio *io_bio = container_of(work, struct btrfs_io_bio,
> > +						   work);
> > +	struct bio *bio = &io_bio->bio;
> > +	struct btrfs_device *dev = get_device_from_bio(bio);
> > +
> > +	ASSERT(bio_data_dir(bio) == WRITE);
> > +
> > +	if (!btrfs_narrow_write_error(bio, dev)) {
> > +		/* inc error counter if narrow (retry) fails */
> > +		struct btrfs_bio *bbio = bio->bi_private;
> >  
> > -	if (bio->bi_status) {
> >  		atomic_inc(&bbio->error);
> > -		if (bio->bi_status == BLK_STS_IOERR ||
> > -		    bio->bi_status == BLK_STS_TARGET) {
> > -			unsigned int stripe_index =
> > -				btrfs_io_bio(bio)->stripe_index;
> > -			struct btrfs_device *dev;
> > -
> > -			BUG_ON(stripe_index >= bbio->num_stripes);
> > -			dev = bbio->stripes[stripe_index].dev;
> > -			if (dev->bdev) {
> > -				if (bio_op(bio) == REQ_OP_WRITE)
> > -					btrfs_dev_stat_inc(dev,
> > -						BTRFS_DEV_STAT_WRITE_ERRS);
> > -				else
> > -					btrfs_dev_stat_inc(dev,
> > -						BTRFS_DEV_STAT_READ_ERRS);
> > -				if (bio->bi_opf & REQ_PREFLUSH)
> > -					btrfs_dev_stat_inc(dev,
> > -						BTRFS_DEV_STAT_FLUSH_ERRS);
> > -				btrfs_dev_stat_print_on_error(dev);
> > -			}
> > +		btrfs_record_bio_error(bio, dev);
> > +	}
> > +
> > +	__btrfs_end_bio(bio);
> > +}
> > +
> > +/* running in irq context */
> > +static void btrfs_reschedule_retry(struct bio *bio)
> > +{
> > +	INIT_WORK(&btrfs_io_bio(bio)->work, btrfs_handle_bio_error);
> > +	/* _temporarily_ use system_unbound_wq */
> > +	queue_work(system_unbound_wq, &btrfs_io_bio(bio)->work);
> > +}
> > +
> > +static void btrfs_end_bio(struct bio *bio)
> > +{
> > +	if (bio->bi_status) {
> > +		struct btrfs_bio *bbio = bio->bi_private;
> > +
> > +		if (bio_data_dir(bio) == WRITE) {
> > +			btrfs_reschedule_retry(bio);
> > +			return;
> >  		}
> > +
> > +		atomic_inc(&bbio->error);
> > +
> > +		/* I don't think we can have REQ_PREFLUSH, but just in case. */
> > +		WARN_ON_ONCE(bio->bi_opf & REQ_PREFLUSH);
> > +
> > +		/* REQ_PREFLUSH */
> > +		btrfs_record_bio_error(bio, get_device_from_bio(bio));
> >  	}
> 
> This patch adds btrfs_end_bio but the same function is also added by the
> previous one. Perhaps some of the refactorings here should go into the
> previous patch which just juggles existing code and leave the new
> changes for this patch?

I looked into it, it seems that git diff made a joke as
btrfs_end_bio() and btrfs_handle_bio_error() share some code.

Tbh I'm not sure how to refactor to make git diff happy, as you can
see, patch 2 is too easy to be refactored.

Thanks,

-liubo
