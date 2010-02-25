From: Chris Mason <chris.mason@oracle.com>
Subject: Re: assertion failures
Date: Wed, 24 Feb 2010 19:40:04 -0500
Message-ID: <20100225004004.GK25641@think>
References: <20100224134532.282174094A@viridian.itc.virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100224134532.282174094A@viridian.itc.virginia.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2010 at 08:45:32AM -0500, Bill Pemberton wrote:
> I've had 2 different filesystems fail in the same way recently.  In
> both cases the server crashed (probably due to something unrelated to
> btrfs).  On reboot the fsck fails as follows:
> 
> #  btrfsck /dev/raidvg/vol4
> parent transid verify failed on 20971520 wanted 206856 found 214247

I don't suppose you have the dmesg errors from the crash?  This error
shows the header in the block is incorrect, so either something was
written to the wrong place or not written at all.

Have you memtest86 on this system?

How did it crash...was a power off used to reset the machine?

-chris
