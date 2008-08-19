From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Add compability for kernels >=2.6.27-rc1
Date: Tue, 19 Aug 2008 12:30:05 -0400
Message-ID: <20080819162619.GA14618@think.oraclecorp.com>
References: <alpine.LNX.1.10.0807302100500.2294@titan.stealer.net> <20080730195628.GP20055@kernel.dk> <1217448700.20239.30.camel@think.oraclecorp.com> <20080730201333.GR20055@kernel.dk> <1217450622.20239.32.camel@think.oraclecorp.com> <1217532421.3454.291.camel@pmac.infradead.org> <1217533058.20239.62.camel@think.oraclecorp.com> <1219157500.3184.484.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Sven Wegener <sven.wegener@stealer.net>,
	linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219157500.3184.484.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 19, 2008 at 03:51:40PM +0100, David Woodhouse wrote:
> On Thu, 2008-07-31 at 15:37 -0400, Chris Mason wrote:
> > > BUG: unable to handle kernel paging request at ffff880107c2aa00
> > > IP: [<ffffffffa03e73bc>] end_bio_extent_writepage+0x1f4/0x29c
> > [btrfs]
> > 
> > If you can reliably reproduce this, please try with the spin locks
> > instead of rcu read locks.  What were you doing at the time?
> 
> Just using CONFIG_DEBUG_PAGEALLOC and dirtying a bunch of pages from
> different inodes seems enough. Another patch to add to my collection at
> git.infradead.org/users/dwmw2/btrfs-kernel-unstable.git ...

Great, I'm testing this locally, it should solve Toei Rei's oopsen.  It
doesn't solve the missing checksum errors that Steve was hitting, but
I'm able to trigger those locally now and hope to nail them down
today.

-chris
