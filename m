From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch] btrfs: remove dead code #3
Date: Thu, 26 Mar 2009 16:43:20 +0100
Message-ID: <20090326154320.GF27476@kernel.dk>
References: <Pine.LNX.4.64.0903261633260.31773@usbsys.site> <Pine.LNX.4.64.0903261650260.31773@usbsys.site> <Pine.LNX.4.64.0903261716270.1976@usbsys.site> <20090326143936.GE27476@kernel.dk> <1238078881.5676.14.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <error27@gmail.com>, no@kernel.dk,
	To-header@kernel.dk, on@kernel.dk, ";;chris.mason"@oracle.com,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1238078881.5676.14.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 26 2009, Chris Mason wrote:
> On Thu, 2009-03-26 at 15:39 +0100, Jens Axboe wrote:
> > On Thu, Mar 26 2009, Dan Carpenter wrote:
> > > kzalloc() already initialized ->error to zero.
> > > 
> > > regards,
> > > dan carpenter
> > > 
> > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > 
> > > --- orig/fs/btrfs/volumes.c	2009-03-26 17:14:13.000000000 +0300
> > > +++ devel/fs/btrfs/volumes.c	2009-03-26 17:14:55.000000000 +0300
> > > @@ -2422,10 +2422,8 @@
> > >  		multi = kzalloc(btrfs_multi_bio_size(stripes_allocated),
> > >  				GFP_NOFS);
> > >  		if (!multi)
> > >  			return -ENOMEM;
> > > -
> > > -		atomic_set(&multi->error, 0);
> > >  	}
> > >  
> > >  	spin_lock(&em_tree->lock);
> > >  	em = lookup_extent_mapping(em_tree, logical, *length);
> > 
> > Careful, some archs require a barrier there. It's dangerous to makes
> > assumptions about the underlying implementation of such things, I'd
> > leave that one alone.
> > 
> Yeah, I'm not so much worried about the barrier as I am that assuming a
> memset can init an atomic in general.

Right, it was more a generic comment. As to the memset(), if someone
decided to add a magic to atomic_t or something for debug purposes, it
would break. That's the bigger problem here :-)

-- 
Jens Axboe

