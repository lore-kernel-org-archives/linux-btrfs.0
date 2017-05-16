Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35962 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbdEPSQ7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 14:16:59 -0400
Date: Tue, 16 May 2017 11:15:53 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs: use bio_clone_bioset_partial to simplify DIO
 submit
Message-ID: <20170516171552.GB11826@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
 <1492478187-24875-3-git-send-email-bo.li.liu@oracle.com>
 <20170516143737.GA24541@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170516143737.GA24541@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 07:37:37AM -0700, Christoph Hellwig wrote:
> >  }
> >  
> > +struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask, int offset, int size)
> > +{
> > +	struct bio *bio;
> > +
> > +	bio = bio_clone_fast(orig, gfp_mask, btrfs_bioset);
> > +	if (bio) {
> 
> bio_clone_fast will never fail when backed by a bioset, which this
> one always is.  Also you always pass GFP_NPFS as the gfp_mask argument,
> it might make sense to hardcode that here.
> 

I see.

> > +		struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
> > +		btrfs_bio->csum = NULL;
> > +		btrfs_bio->csum_allocated = NULL;
> > +		btrfs_bio->end_io = NULL;
> > +
> > +		bio_trim(bio, (offset >> 9), (size >> 9));
> 
> No need for the inner braces here.
> 
> Last but not least do you even need this as a separate helper?
> 

Not necessary indeed, but I need to access %btrfs_bioset which is
'static' defined in extent_io.c

> > +struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask, int offset, int size);
> 
> Over long line, please trim to 80 characters

OK, fixed.

Thanks for the comments.

Thanks,

-liubo
