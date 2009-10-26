From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Allocator changes
Date: Mon, 26 Oct 2009 18:28:01 +0900
Message-ID: <20091026092801.GD5564@think>
References: <20091021214135.GA5935@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091021214135.GA5935@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2009 at 05:41:36PM -0400, Josef Bacik wrote:
> Hello,
> 
> I've been thinking recently about how to fix the caching stuff so it isn't so
> damned slow and had started to work on writing out the free space cache into
> bitmaps for every dirty bitmap, but then Eric Sandeen pointed out that xfs just
> has a couple of btree's to track free space, so I started thinking about doing
> it that way, since we do have this nice btree code laying about.
> 
> There are a couple of problems with adding another free space root however:

The free space root seems like it will have a pretty high overhead to
me.  But, I do like your general idea of caching the free space map at
commit time as an on-disk cache.  I think as we nail down the enospc
corners we can go back and give that a try.

To get around the cow problem, we can log the cache to the log tree.

-chris
