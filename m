From: Chris Mason <chris.mason@oracle.com>
Subject: Re: nodatacsum broken?
Date: Mon, 16 Nov 2009 12:23:27 -0500
Message-ID: <20091116172327.GD27677@think>
References: <4B017C63.5000600@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B017C63.5000600@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 16, 2009 at 10:22:59AM -0600, Steven Pratt wrote:
> Did we break the ability to run with -o nodatacsum somewhere along
> the way? I had not run just this option in a while (usually doing
> nodatacow which implies nodatacsum).  Just did a full run with just
> nodatacsum and it looks like we still did csums.
> 
> from proc/mounts:
> 
> /dev/ffsbdev1 on /mnt/ffsb1 type btrfs (rw,nodatacsum)
                                         ^^^^^^^^^^^^^^

This should be mount -o nodatasum.

2.6.33 will have a patch from Sage to fail mounting when we don't
recognize the option instead of silently pretending it worked.  I just
didn't want to introduce it this late in the 2.6.32-rc series.

-chris
