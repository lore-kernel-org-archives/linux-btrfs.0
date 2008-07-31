From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Add compability for kernels >=2.6.27-rc1
Date: Thu, 31 Jul 2008 15:37:38 -0400
Message-ID: <1217533058.20239.62.camel@think.oraclecorp.com>
References: <alpine.LNX.1.10.0807302100500.2294@titan.stealer.net>
	 <20080730195628.GP20055@kernel.dk>
	 <1217448700.20239.30.camel@think.oraclecorp.com>
	 <20080730201333.GR20055@kernel.dk>
	 <1217450622.20239.32.camel@think.oraclecorp.com>
	 <1217532421.3454.291.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Sven Wegener <sven.wegener@stealer.net>,
	linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1217532421.3454.291.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-07-31 at 20:27 +0100, David Woodhouse wrote:
> On Wed, 2008-07-30 at 16:43 -0400, Chris Mason wrote:
> > On Wed, 2008-07-30 at 22:13 +0200, Jens Axboe wrote:
> > 
> > [ rcu page cache ]
> > 
> > > > > For btrfs's usage, it should be safe with a simple rcu_read_lock(), if
> > > > > the return is referenced safely.
> > > > > 
> > > > 
> > > > This btrfs code is basically a find_get_page without the get.  It should
> > > > only be called when I know I already have a reference on the page.
> > > 
> > > Then it's definitely safe ;-)
> > > 
> > 
> > Yeah, I'm testing on the latest git now and it all seems ok.  I'll push
> > this out, thanks Sven.
> 
> Seems to crash for me with Linus' current tree. I thought it was
> something to do with my fixes for NFS export, but now I've hooked up a
> serial console and managed to catch it, I suspect not...
> 
> BUG: unable to handle kernel paging request at ffff880107c2aa00
> IP: [<ffffffffa03e73bc>] end_bio_extent_writepage+0x1f4/0x29c [btrfs]

If you can reliably reproduce this, please try with the spin locks
instead of rcu read locks.  What were you doing at the time?

-chris


