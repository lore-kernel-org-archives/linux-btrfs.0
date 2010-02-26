From: Chris Mason <chris.mason@oracle.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 11:17:30 -0500
Message-ID: <20100226161730.GC12841@think>
References: <20100225004004.GK25641@think>
 <20100225140420.4EBA940954@viridian.itc.virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100225140420.4EBA940954@viridian.itc.virginia.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2010 at 09:04:20AM -0500, Bill Pemberton wrote:
> > 
> > I don't suppose you have the dmesg errors from the crash?  This error
> > shows the header in the block is incorrect, so either something was
> > written to the wrong place or not written at all.
> > 
> > Have you memtest86 on this system?
> > 
> > How did it crash...was a power off used to reset the machine?
> > 
> 
> No dmesg.  This has happened on two different machines that both have
> other active btrfs filesystems, so I suspect it's not a memory issue.
> In both cases it was the same data that was being copied when the
> crash occurred.

Ok, is there anything special about this data?

> 
> I didn't deal with the reboot in the first case, so I don't have much
> in the way of details.  In the second case the kernel seemed convinced
> the array was having problems (and the load went way up), but the
> array was convinced it was fine.  A normal reboot hung and the server
> had to be powered off.
> 
> Since it appears that the same operation caused the problem in both
> cases, I'm going to try to reproduce it.  I'll let you know if I can
> reproduce it.

What kind of array is this?  It really sounds like the IO isn't
happening properly.

-chris
