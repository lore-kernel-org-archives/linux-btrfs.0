Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36284 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2J1KdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 06:33:13 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: kreijack@inwind.it
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Date: Sun, 28 Oct 2012 11:33:10 +0100
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Michael =?iso-8859-1?q?Kj=F6rling?= <michael@kjorling.se>
References: <50899151.1070503@inwind.it> <508CF469.5070407@inwind.it> (sfid-20121028_112200_809835_E2621924)
In-Reply-To: <508CF469.5070407@inwind.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210281133.10571.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Oktober 2012 schrieb Goffredo Baroncelli:
> On 2012-10-25 21:21, Goffredo Baroncelli wrote:
> > Hi all,
> > 
> > this is a new attempt to improve the output of the command "btrfs
> > fi df".
> 
> Below you can see another iteration. I tried to address all the cwillu
> requests, which to me make sense.
> 
> I thought a lot about chunk/disks vs disk/chunks, and I reached the
> conclusion that we could need both. In order to avoid a too long and
> redundant output, my idea is to have three different commands:
> 
> 1) btrfs filesystem df <path>         -> which show what it is called
>                                           summary
> 2) btrfs filesystem disk-usage <path> -> which show what is called
>                                          "Detail"
> 3) btrfs device disk-usage <path>     -> which is like 2) but grouped
>                                          by disk instead of chunks.
> 
> 
> This is an idea about which I want some comments. The example below
> show the latest results. I want to point out that I was not able to
> show the chunk usage per disk, because I don't have this information.
> 
> The patches are not shaped to be showed, however the code is pullable
> from
> 
>         http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
> branch
>         info-cmd  (commit f90e55e7)
> 
> 
> $ sudo ./btrfs fi df /mnt/btrfs1/
> Path: /mnt/btrfs1
> Summary:
>   Disk_size:		  21.00GB
>   Disk_allocated:	   1.83GB
>   Disk_unallocated:	  19.17GB
>   Used:			 284.00KB
>   Free_(Estimated):	  15.76GB	(Max: 20.54GB, min: 10.96GB)
>   Data_to_disk_ratio:	     75 %

Okay, so that btrfs fi df.

Which is a summary.

I think much more wouldn´t be a summary anymore, so thats okay.


And the following

> Allocated_area:
>   Data,Single: Size:8.00MB, Used:0.00
>      /dev/vdb	    8.00MB
> 
>   Data,RAID0: Size:921.75MB, Used:256.00KB
>      /dev/vdb	  307.25MB
>      /dev/vdc	  307.25MB
>      /dev/vdd	  307.25MB
> 
>   Metadata,Single: Size:8.00MB, Used:0.00
>      /dev/vdb	    8.00MB
> 
>   Metadata,RAID1: Size:460.94MB, Used:24.00KB
>      /dev/vdb	  460.94MB
>      /dev/vdd	  460.94MB
> 
>   System,Single: Size:4.00MB, Used:0.00
>      /dev/vdb	    4.00MB
> 
>   System,RAID1: Size:8.00MB, Used:4.00KB
>      /dev/vdc	    8.00MB
>      /dev/vdd	    8.00MB
> 
>   Unallocated:
>      /dev/vdb	    2.23GB
>      /dev/vdc	    2.69GB
>      /dev/vdd	    2.24GB
>      /dev/vdf	   12.00GB

is detail shown by btrfs filesystem disk-usage?

While

> Disks:
>   /dev/vdb	    3.00GB
>      Data,Single:              8.00MB
>      Data,RAID0:             307.25MB
>      Metadata,Single:          8.00MB
>      Metadata,RAID1:         460.94MB
>      System,Single:            4.00MB
>      Unallocated:              2.23GB
> 
>   /dev/vdc	    3.00GB
>      Data,RAID0:             307.25MB
>      System,RAID1:             8.00MB
>      Unallocated:              2.69GB
> 
>   /dev/vdd	    3.00GB
>      Data,RAID0:             307.25MB
>      Metadata,RAID1:         460.94MB
>      System,RAID1:             8.00MB
>      Unallocated:              2.24GB
> 
>   /dev/vdf	   12.00GB
>      Unallocated:             12.00GB

will be btrfs device disk-usage?

What was your reasoning for not using options to btrfs filesystem df? That 
df doesn´t show more than "disk free" as well?

Then there is a little "inconsistency": "df" versus "disk-usage". I would 
use either "disk-free" and "disk-usage" or "df" and "du". While regular 
"du" is not disk-usage but a filesystem directory tree usage command.

I will think about this a bit more.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
