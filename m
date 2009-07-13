From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] brtfs: less- and greater than confusion
Date: Mon, 13 Jul 2009 09:26:31 -0400
Message-ID: <20090713132631.GC4704@think>
References: <4A5A6418.2070906@gmail.com> <20090713132252.GB4704@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Roel Kluin <roel.kluin@gmail.com>, linux-btrfs@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090713132252.GB4704@think>
List-ID: <linux-btrfs.vger.kernel.org>

[ sorry, fixed up cc ]

On Mon, Jul 13, 2009 at 09:22:52AM -0400, Chris Mason wrote:
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
> 
> -chris
> 
