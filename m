From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Bonnie++ run with RAID-1 on a single SSD
 (2.6.29-rc4-224-g4b6136c)
Date: Fri, 13 Feb 2009 09:26:11 -0500
Message-ID: <1234535171.17533.9.camel@think.oraclecorp.com>
References: <200902132331.12928.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200902132331.12928.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-02-13 at 23:31 +1100, Chris Samuel wrote:
> Hi folks,
> 
> For people who might be interested, here is how btrfs performs
> with two partitions on a single SSD drive in a RAID-1 mirror.
> 
> This is on a Dell E4200 with Core 2 Duo U9300 (1.2GHz), 2GB RAM
> and a Samsung SSD (128GB Thin uSATA SSD).
> 

Thanks for posting these, it is especially good to see the metadata ops
are still fast on this ssd.

> Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> sys26            2G           28299  17 18633  12           85702  29  3094  18
>                     ------Sequential Create------ --------Random Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16  7513  99 +++++ +++  5140  98  3964  67 +++++ +++  5652  99
> sys26,2G,,,28299,17,18633,12,,,85702,29,3093.9,18,16,7513,99,+++++,+++,5140,98,3964,67,+++++,+++,5652,99
> 

So, btrfs is doing ~28MB/s writes while writing the data  twice and XFS
is doing 62MB writing it once.  That's not too bad really.

But, one important thing about the ssds is they stripe internally across
a bunch of flash storage, and then they have the FTL managing all the
writes.

So, if you make two partitions on a single device, a raid1 data write
from btrfs is very likely to result in two large IOs, which the FTL very
well might put directly adjacent to each other on the SSD.

Duplicating the data does make it more likely you'll recover something
if the device goes bad, but two devices are still safer than one.

I'm not saying the test isn't valid, I just want to make sure people
reading the list don't run off and partition their ssds in hopes of
getting raid ;)

-chris


