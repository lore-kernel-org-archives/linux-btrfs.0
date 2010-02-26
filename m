From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 13:11:57 -0500 (EST)
Message-ID: <20100226181157.50F73414B9@viridian.itc.virginia.edu>
References: <20100226175927.GG12841@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com (Chris Mason)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226175927.GG12841@think>
List-ID: <linux-btrfs.vger.kernel.org>

> 
> Does the array have any kind of writeback cache?
> 

Yes, the array has a writeback cache.

>
> Are all of the filesystems spread across all of the drives?  Or do some
> filesystems use some drives only?
> 

In all cases the array is presenting 1 physical volume to the host
system (which is RAID 6 on the array itself).  That physical volume is
made into a volume group and the filesystems are on logical volumes in
that volume group.

-- 
Bill


