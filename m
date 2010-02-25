From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Subject: Re: assertion failures
Date: Thu, 25 Feb 2010 09:04:20 -0500 (EST)
Message-ID: <20100225140420.4EBA940954@viridian.itc.virginia.edu>
References: <20100225004004.GK25641@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com (Chris Mason)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100225004004.GK25641@think>
List-ID: <linux-btrfs.vger.kernel.org>

> 
> I don't suppose you have the dmesg errors from the crash?  This error
> shows the header in the block is incorrect, so either something was
> written to the wrong place or not written at all.
> 
> Have you memtest86 on this system?
> 
> How did it crash...was a power off used to reset the machine?
> 

No dmesg.  This has happened on two different machines that both have
other active btrfs filesystems, so I suspect it's not a memory issue.
In both cases it was the same data that was being copied when the
crash occurred.

I didn't deal with the reboot in the first case, so I don't have much
in the way of details.  In the second case the kernel seemed convinced
the array was having problems (and the load went way up), but the
array was convinced it was fine.  A normal reboot hung and the server
had to be powered off.

Since it appears that the same operation caused the problem in both
cases, I'm going to try to reproduce it.  I'll let you know if I can
reproduce it.

-- 
Bill


