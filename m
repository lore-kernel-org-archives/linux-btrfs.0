From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v1 2/6] scrub: added unverified_errors
Date: Fri, 17 Jun 2011 10:16:49 +0200
Message-ID: <20110617081649.GE12709@twin.jikos.cz>
References: <cover.1307991539.git.list.btrfs@jan-o-sch.net>
 <cfc81e25919ac1abcee5cbbbf3462c147a838d02.1307991539.git.list.btrfs@jan-o-sch.net>
 <20110616212521.GB12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Schmidt <list.btrfs@jan-o-sch.net>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110616212521.GB12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

sorry for the noise, this has no comments from me,

david

On Thu, Jun 16, 2011 at 11:25:21PM +0200, David Sterba wrote:
> On Mon, Jun 13, 2011 at 09:10:35PM +0200, Jan Schmidt wrote:
> > In normal operation, scrub is reading data sequentially in large portions.
> > In case of an i/o error, we try to find the corrupted area(s) by issuing
> > page sized read requests. With this commit we increment the
> > unverified_errors counter if all of the small size requests succeed.
> > 
> > Userland patches carrying such conspicous events to the administrator should
> > already be around.
> > 
> > Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> > ---
> >  fs/btrfs/scrub.c |   37 ++++++++++++++++++++++++++-----------
> >  1 files changed, 26 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> > index d5a4108..00e4e58 100644
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -207,18 +207,25 @@ nomem:
> >   * recheck_error gets called for every page in the bio, even though only
> >   * one may be bad
> >   */
> > -static void scrub_recheck_error(struct scrub_bio *sbio, int ix)
> > +static int scrub_recheck_error(struct scrub_bio *sbio, int ix)
> >  {
> > +	struct scrub_dev *sdev = sbio->sdev;
> > +	u64 sector = (sbio->physical + ix * PAGE_SIZE) >> 9;
> > +
> >  	if (sbio->err) {
> > -		if (scrub_fixup_io(READ, sbio->sdev->dev->bdev,
> > -				   (sbio->physical + ix * PAGE_SIZE) >> 9,
> > +		if (scrub_fixup_io(READ, sbio->sdev->dev->bdev, sector,
> >  				   sbio->bio->bi_io_vec[ix].bv_page) == 0) {
> >  			if (scrub_fixup_check(sbio, ix) == 0)
> > -				return;
> > +				return 0;
> >  		}
> >  	}
> >  
> > +	spin_lock(&sdev->stat_lock);
> > +	++sdev->stat.read_errors;
> > +	spin_unlock(&sdev->stat_lock);
> > +
> >  	scrub_fixup(sbio, ix);
> > +	return 1;
> >  }
> >  
> >  static int scrub_fixup_check(struct scrub_bio *sbio, int ix)
> > @@ -388,8 +395,14 @@ static void scrub_checksum(struct btrfs_work *work)
> >  	int ret;
> >  
> >  	if (sbio->err) {
> > +		ret = 0;
> >  		for (i = 0; i < sbio->count; ++i)
> > -			scrub_recheck_error(sbio, i);
> > +			ret |= scrub_recheck_error(sbio, i);
> > +		if (!ret) {
> > +			spin_lock(&sdev->stat_lock);
> > +			++sdev->stat.unverified_errors;
> > +			spin_unlock(&sdev->stat_lock);
> > +		}
> >  
> >  		sbio->bio->bi_flags &= ~(BIO_POOL_MASK - 1);
> >  		sbio->bio->bi_flags |= 1 << BIO_UPTODATE;
> > @@ -402,10 +415,6 @@ static void scrub_checksum(struct btrfs_work *work)
> >  			bi->bv_offset = 0;
> >  			bi->bv_len = PAGE_SIZE;
> >  		}
> > -
> > -		spin_lock(&sdev->stat_lock);
> > -		++sdev->stat.read_errors;
> > -		spin_unlock(&sdev->stat_lock);
> >  		goto out;
> >  	}
> >  	for (i = 0; i < sbio->count; ++i) {
> > @@ -426,8 +435,14 @@ static void scrub_checksum(struct btrfs_work *work)
> >  			WARN_ON(1);
> >  		}
> >  		kunmap_atomic(buffer, KM_USER0);
> > -		if (ret)
> > -			scrub_recheck_error(sbio, i);
> > +		if (ret) {
> > +			ret = scrub_recheck_error(sbio, i);
> > +			if (!ret) {
> > +				spin_lock(&sdev->stat_lock);
> > +				++sdev->stat.unverified_errors;
> > +				spin_unlock(&sdev->stat_lock);
> > +			}
> > +		}
> >  	}
> >  
> >  out:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
