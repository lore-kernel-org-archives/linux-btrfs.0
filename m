From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: generic pagecache to block mapping layer (was Re: Btrfs for mainline)
Date: Tue, 6 Jan 2009 04:10:42 +1100
Message-ID: <200901060410.42380.nickpiggin@yahoo.com.au>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <200901060139.37404.nickpiggin@yahoo.com.au> <1231173453.4290.137.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231173453.4290.137.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 06 January 2009 03:37:33 Chris Mason wrote:
> On Tue, 2009-01-06 at 01:39 +1100, Nick Piggin wrote:
> > [trim ccs]
> >
> > Feel free to ignore this diversion ;) I'd like to see btrfs go upstream
> > sooner rather than later. But eventually we'll have to resurrect fsblock
> > vs extent map discussion.
>
> There's extent_map, extent_state and extent_buffer.  I'd expect the
> mapping code to beat fsblock, since it more closely models the
> conditions of the disk format.  This is a very thin layer of code to
> figure out which file offset goes to which block on disk.

It looks somewhat similar to the optional extent mapping layer I
added in front of fsblock (which works very nicely for ext2, but
may not be bloated^W enough for btrfs :P).

#define FE_mapped       0x1
#define FE_hole         0x2
#define FE_new          0x4

struct fsb_extent {
        struct rb_node          rb_node;
        sector_t                offset;
        sector_t                block;
        unsigned int            size;
        unsigned int            flags;
};

But I have a feeling that it might be better to not have such a layer
and go direct to the filesystem in cases where they have good in
memory data structures for mapping themselves. btrfs for example has
some non-generic looking data in its mapping.

But... we'll see. If we can distill the common goodness from different
places and make it more usable, it would definitely be a good idea.


> extent_state is a different beast, since it is trying to track state
> across extents.  It is entirely possible that we're better off keeping
> the state in the pages, aside from the part where we're running out of
> bits.

OK, I haven't really understood how that works.


> extent_buffers are an api to access/modify the contents of ranges of
> bytes, supporting larger and smaller blocksizes than the page.  I'd be
> really interested in comparing this to fsblock, but I need to first fix
> it to actually support larger and smaller blocksizes than the page ;)

Yes, this area is where we have a difference of opinion I think ;)


> So, long term we can have a benchmarking contest, but I've got a little
> ways to go before that is a good idea.

That would be good.

Thanks,
Nick

