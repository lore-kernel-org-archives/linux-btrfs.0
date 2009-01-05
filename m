From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: generic pagecache to block mapping layer (was Re: Btrfs for mainline)
Date: Tue, 6 Jan 2009 01:39:37 +1100
Message-ID: <200901060139.37404.nickpiggin@yahoo.com.au>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <200901052132.22620.nickpiggin@yahoo.com.au> <1231161703.4290.14.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>,
	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231161703.4290.14.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

[trim ccs]

Feel free to ignore this diversion ;) I'd like to see btrfs go upstream
sooner rather than later. But eventually we'll have to resurrect fsblock
vs extent map discussion.

On Tuesday 06 January 2009 00:21:43 Chris Mason wrote:
> On Mon, 2009-01-05 at 21:32 +1100, Nick Piggin wrote:
> > On Saturday 03 January 2009 06:38:07 Chris Mason wrote:
> > > The extent_map and extent_buffer code was also intended for generic
> > > use. It needs some love and care (making it work for blocksize !=
> > > pagesize) before I'd suggest moving it out of fs/btrfs.
> >
> > I'm yet to be convinced it is a good idea to use extents for this. Been a
> > long time since we visited the issue, but when you converted ext2 to use
> > the extent mapping stuff, it actually went slower, and complexity went up
> > a lot (IIRC possibly required allocations in the writeback path).
> >
> >
> > So I think it is a fine idea to live in btrfs until it is more proven and
> > found useful elsewhere.
>
> It has gotten faster since then, but it makes sense to wait on moving
> extent_* code.

faster, than it was or than buffer heads now?

fsblock is faster than buffer heads, robust WRT memory allocation,
supports smaller and larger blocks than pagecache, and does locking
solely on a per-page basis.

I added a module that can cache block mapping (but not pagecache state
mapping, importantly) in extents for filesystems that don't have a good
in-memory data structure (although this has a per-inode lock course). I
agree that using extents for this makes perfect sense, but I've just
never thought pagecache state extents are a good idea.

I don't think this will be too easy to beat with state extents. I
haven't looked closely at your implementation for quite a while, but
last I did, I couldn't imagine it being easy to make fast+scalable or
rework it to have good memory allocation behaviour.

