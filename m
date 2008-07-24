From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Use do_div() instead of native 64-bit division in
	btrfs_ordered_sum_size()
Date: Wed, 23 Jul 2008 20:19:15 -0400
Message-ID: <1216858755.6932.154.camel@think.oraclecorp.com>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
	 <20080723111309.GA19988@infradead.org>
	 <1216819706.6932.146.camel@think.oraclecorp.com>
	 <1216847224.3019.137.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216847224.3019.137.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-07-23 at 17:07 -0400, David Woodhouse wrote:
> On Wed, 2008-07-23 at 09:28 -0400, Chris Mason wrote:
> > On Wed, 2008-07-23 at 07:13 -0400, Christoph Hellwig wrote:
> > > Chris, can you please put this patch in?  Without it btrfs can't be
> > > loaded on 32bit platforms.
> > > 
> > 
> > I've pushed out a slightly different fix.  The ordered extents are
> > based on ram writeback, and so an unsigned long is enough.
> 
> Does the job for me, although we still need the
> s/BUG_ON(spin_trylock(&tree->lock))/assert_spin_locked(&tree->lock)/
> patch I sent a few days ago.
> 
> Now I can actually build the module, load it and avoid it hitting a
> BUG_ON() when it first tries to mount, I can perhaps move on to doing
> something more useful with it... :)

;) My goal tonight is to figure out why I'm leaving locked data pages
everywhere.  Once that is done I'll be able to finally integrate the
pending patches.

-chris


