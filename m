From: Chris Mason <chris.mason@oracle.com>
Subject: Re: generic pagecache to block mapping layer (was Re: Btrfs for
 mainline)
Date: Mon, 05 Jan 2009 11:37:33 -0500
Message-ID: <1231173453.4290.137.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <200901052132.22620.nickpiggin@yahoo.com.au>
	 <1231161703.4290.14.camel@think.oraclecorp.com>
	 <200901060139.37404.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200901060139.37404.nickpiggin@yahoo.com.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-06 at 01:39 +1100, Nick Piggin wrote:
> [trim ccs]
> 
> Feel free to ignore this diversion ;) I'd like to see btrfs go upstream
> sooner rather than later. But eventually we'll have to resurrect fsblock
> vs extent map discussion.
> 

There's extent_map, extent_state and extent_buffer.  I'd expect the
mapping code to beat fsblock, since it more closely models the
conditions of the disk format.  This is a very thin layer of code to
figure out which file offset goes to which block on disk.

extent_state is a different beast, since it is trying to track state
across extents.  It is entirely possible that we're better off keeping
the state in the pages, aside from the part where we're running out of
bits.

extent_buffers are an api to access/modify the contents of ranges of
bytes, supporting larger and smaller blocksizes than the page.  I'd be
really interested in comparing this to fsblock, but I need to first fix
it to actually support larger and smaller blocksizes than the page ;)

So, long term we can have a benchmarking contest, but I've got a little
ways to go before that is a good idea.

-chris


