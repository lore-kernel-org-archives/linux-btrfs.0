From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated performance results
Date: Fri, 11 Sep 2009 15:29:55 -0400
Message-ID: <20090911192955.GB2894@think>
References: <4A68DE81.3020505@dangyankee.net>
 <20090724132407.GC16192@think>
 <20090724140002.GD16192@think>
 <4A6F5BB6.4020204@austin.ibm.com>
 <20090728202355.GC13940@think>
 <4A6F6951.9020304@austin.ibm.com>
 <20090805203526.GE12524@think>
 <4A7C32A4.9070106@austin.ibm.com>
 <20090807231240.GD3710@think>
 <4A9C0D19.5010108@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A9C0D19.5010108@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2009 at 12:49:13PM -0500, Steven Pratt wrote:
> Better late than never. Finally got this finished up.  Mixed bag on
> this one.  BTRFS lags significantly on single threaded.  Seems
> unable to keep IO outstanding to the device.  Less that 60% busy on
> the DM device, compared to 97%+ for all other filesystems.
> nodatacow helps out, increasing utilization to about 70%, but still
> trails by a large margin.

Hi Steve,

Jens Axboe did some profiling on his big test rig and I think we found
the biggest CPU problems.  The end result is now setting in the master
branch of the btrfs-unstable repo.

On his boxes, btrfs went from around 400MB/s streaming writes to 1GB/s
limit, and we're now tied with XFS while using less CPU time.

Hopefully you will see similar results ;)

-chris
