From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Btrfs for mainline
Date: Mon, 5 Jan 2009 21:32:22 +1100
Message-ID: <200901052132.22620.nickpiggin@yahoo.com.au>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20090103.013755.42849152.ryusuke@osrg.net> <1230925087.7538.41.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1230925087.7538.41.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 03 January 2009 06:38:07 Chris Mason wrote:
> On Sat, 2009-01-03 at 01:37 +0900, Ryusuke Konishi wrote:
> > Hi,
> >
> > On Wed, 31 Dec 2008 18:19:09 -0500, Chris Mason <chris.mason@oracle.com> 
wrote:
> > > This has only btrfs as a module and would be the fastest way to see
> > > the .c files.  btrfs doesn't have any changes outside of fs/Makefile
> > > and fs/Kconfig
>
> [ ... ]
>
> > In addition, there seem to be well-separated reusable routines such as
> > async-thread (enhanced workqueue) and extent_map.  Do you intend to
> > move these into lib/ or so?
>
> Sorry, looks like I hit send too soon that time.  The async-thread code
> is very self contained, and was intended for generic use.  Pushing that
> into lib is probably a good idea.
>
> The extent_map and extent_buffer code was also intended for generic use.
> It needs some love and care (making it work for blocksize != pagesize)
> before I'd suggest moving it out of fs/btrfs.

I'm yet to be convinced it is a good idea to use extents for this. Been a
long time since we visited the issue, but when you converted ext2 to use
the extent mapping stuff, it actually went slower, and complexity went up
a lot (IIRC possibly required allocations in the writeback path).

So I think it is a fine idea to live in btrfs until it is more proven and
found useful elsewhere.

