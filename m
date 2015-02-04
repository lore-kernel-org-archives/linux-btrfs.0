Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbbBDXef (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 18:34:35 -0500
Date: Wed, 4 Feb 2015 18:34:02 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, dm-devel@redhat.com, david@fromorbit.com,
        sandeen@redhat.com, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, clm@facebook.com, zab@redhat.com
Subject: Re: [PATCH][RFC] dm: log writes target
Message-ID: <20150204233402.GB1380@redhat.com>
References: <1418077949-28771-1-git-send-email-jbacik@fb.com>
 <20150204184108.GA2801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150204184108.GA2801@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 04 2015 at  1:41pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> @@ -527,9 +522,10 @@ static void normal_map_bio(struct dm_target *ti, struct bio *bio)
>  	struct log_writes_c *lc = ti->private;
>  
>  	bio->bi_bdev = lc->dev->bdev;
> +	// FIXME: why would bi_sector ever need to be changed?
> +	// if you just copied dm-linear then it is misplaced since there isn't an offset
>  	if (bio_sectors(bio))
> -		bio->bi_iter.bi_sector =
> -			dm_target_offset(ti, bio->bi_iter.bi_sector);
> +		bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
>  }

In above FIXME: s/misplaced/incomplete/

FYI sharing this quick private exchange I had with Alasdair just to make
sure I'm clear on what the above FIXME was trying to convey:

On Wed, Feb 04 2015 at  6:28pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Feb 04 2015 at  5:43pm -0500,
> Alasdair G Kergon <agk@redhat.com> wrote:
>
> > On Wed, Feb 04, 2015 at 01:41:09PM -0500, Mike Snitzer wrote:
> > > + // FIXME: why would bi_sector ever need to be changed?
> > > + // if you just copied dm-linear then it is misplaced since there isn't an offset
> >
> > Why shouldn't we use this target on the 2nd or later line of a
> table?
>
> Wasn't saying it shouldn't.  Just was saying that Josef's target didn't
> go as far as say dm-linear with its 'start' offset.  Without it then
> this dm-log-writes target implicitly assumes every logical address
> space, be it 2nd or later, identity maps to exact same offset on the
> backing the data disk.
>
> My FIXME was too cryptic.  I can follow-up on this point.
