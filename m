From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V3 17/18] Btrfs: Full direct I/O and AIO read
 implementation.
Date: Tue, 23 Mar 2010 20:57:19 -0400
Message-ID: <20100324005719.GF5021@think>
References: <4BA6E563.4090206@gmail.com>
 <87sk7r60zw.fsf@basil.nowhere.org>
 <4BA93530.4080303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BA93530.4080303@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 23, 2010 at 05:40:00PM -0400, jim owens wrote:
> > 
> > I know the page cache currently doesn't support that today, but
> > presumably it wouldn't be too hard to add.
> 
> The only reason I did not do something like that is:
> 1) I did not want to disturb the page cache with throw-away pages.
> 2) "uncached IO" makes it even less like classic direct IO.
> 3) Writing that page cache code might not be simpler.
> 
> As further argument against "uncached IO", Chris sent a very simple
> patch up to read into page cache then purge it for btrfs direct IO
> reads and it was NACKed.

Yes, but it wasn't NACKed because it was uncached IO, it was just the
mechanics of how I did it.  We definitely do save some performance by
not hammering on the page cache though, so I do prefer the non-buffered
code when it is possible.

-chris
