From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Mon, 05 Jan 2009 08:21:43 -0500
Message-ID: <1231161703.4290.14.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20090103.013755.42849152.ryusuke@osrg.net>
	 <1230925087.7538.41.camel@think.oraclecorp.com>
	 <200901052132.22620.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200901052132.22620.nickpiggin@yahoo.com.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-05 at 21:32 +1100, Nick Piggin wrote:
> On Saturday 03 January 2009 06:38:07 Chris Mason wrote:

> > The extent_map and extent_buffer code was also intended for generic use.
> > It needs some love and care (making it work for blocksize != pagesize)
> > before I'd suggest moving it out of fs/btrfs.
> 
> I'm yet to be convinced it is a good idea to use extents for this. Been a
> long time since we visited the issue, but when you converted ext2 to use
> the extent mapping stuff, it actually went slower, and complexity went up
> a lot (IIRC possibly required allocations in the writeback path).
> 
>
> So I think it is a fine idea to live in btrfs until it is more proven and
> found useful elsewhere.

It has gotten faster since then, but it makes sense to wait on moving
extent_* code.

-chris

