From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: generic pagecache to block mapping layer (was Re: Btrfs for mainline)
Date: Wed, 7 Jan 2009 04:20:27 +1100
Message-ID: <200901070420.28286.nickpiggin@yahoo.com.au>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231173453.4290.137.camel@think.oraclecorp.com> <200901060410.42380.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200901060410.42380.nickpiggin@yahoo.com.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 06 January 2009 04:10:42 Nick Piggin wrote:
> On Tuesday 06 January 2009 03:37:33 Chris Mason wrote:

> > So, long term we can have a benchmarking contest, but I've got a little
> > ways to go before that is a good idea.
>
> That would be good.

This got me motivated to rebase fsblock to current again. I finally
switched it to create a private inode for the metadata linear mapping,
which makes it incredibly cleaner (doesn't require the new page flag,
lives much more happily beside buffer_heads etc).

Another big thing I did a few months back is to add a ->data pointer
to metadata fsblocks (like bh->b_data), which makes a quick fsblock
conversion much more trivial (although it wouldn't support super-page
blocks without further work).

I'd also converted XFS to fsblock, which involved adding support for
delalloc and unwritten blocks. Although that has a couple of
unfinished bits, it works pretty well and helps prove fsblock working
with an advanced filesystem.

Given these points (particularly the first one), I'm going to try to
find time in the next few months to work on fsblock with a view to
submitting it.


