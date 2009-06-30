From: Chris Mason <chris.mason@oracle.com>
Subject: Re: high cpu load for random write
Date: Tue, 30 Jun 2009 09:41:03 -0400
Message-ID: <20090630134103.GB8345@think>
References: <4A4A0AF1.9060107@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Piavlo <piavka@cs.bgu.ac.il>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A4A0AF1.9060107@cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 30, 2009 at 03:54:09PM +0300, Piavlo wrote:
>  Hi,
> 
> I've just ran a tiobench benchmark  on  2.6.31-rc1-git5 with
> btrfs-progs-0.18
> on single ATA disk with default mount options.  Then performance now
> looks great compared with previous kernel versions.
> 
> But one thing that I noticed - is that CPU load (besides being terribly
> high) for random write  - is several  times higher than for sequential
> write.
> While for all other file systems ever tried, I've always seen the
> opposite - the less data is written to the disk the less is the cpu load
> (no matter if it's random or sequential writes).

There are two causes of the high CPU load.  The first is data
checksumming (which is constant for creating the file and for random
writes) and the second is the cost of maintaining back references for
the file data extent.

In btrfs, we track the owners of each extent, which makes repair, volume
management and other things much easier.  Small random writes make for a
lot of extents, and so they also make for a lot of tracking.

In general, you'll find that mount -o ssd will be faster here, just
because it forces the allocator into more sequential allocations for
this workload.

You'll find that mount -o nodatacow uses much less CPU time, but this
disables checksumming and a few other advanced features.

-chris
