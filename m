From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] brtfs: less- and greater than confusion
Date: Mon, 13 Jul 2009 14:28:04 +0100
Message-ID: <1247491684.19180.178.camel@macbook.infradead.org>
References: <4A5A6418.2070906@gmail.com>  <20090713132252.GB4704@think>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-btrfs@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, yan.zheng@oracle.com
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090713132252.GB4704@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-07-13 at 09:22 -0400, Chris Mason wrote:
> On Mon, Jul 13, 2009 at 12:30:48AM +0200, Roel Kluin wrote:
> > Without this the loop won't start
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 3ab80e9..2c873c9 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2795,7 +2795,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
> >  		}
> >  	}
> >  
> > -	for (i = 0; i > nr; i++) {
> > +	for (i = 0; i < nr; i++) {
> >  		struct btrfs_multi_bio *multi;
> >  		struct btrfs_bio_stripe *stripe;
> >  		int ret;
> 
> Thanks, this does look buggy.  That second loop should just be to verify
> the first loop didn't mess things up.  Yan Zheng, is there any reason we
> shouldn't delete it?

I deleted it in my tree because it made my head hurt for RAID5:
http://git.infradead.org/users/dwmw2/btrfs-raid56.git?a=commitdiff;h=93562d49

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

