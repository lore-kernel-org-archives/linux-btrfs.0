Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:46264 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab2I0Uiy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 16:38:54 -0400
Message-ID: <5064B96B.7060502@libero.it>
Date: Thu, 27 Sep 2012 22:39:07 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?UTF-8?B?U8OpYmFzdGllbiBNYXVyeQ==?= <sebastien.maury@inserm.fr>
CC: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
In-Reply-To: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/27/2012 12:44 PM, Sébastien Maury wrote:
> Hi,
>
> I've installed a new server using btrfs for my root partition ("/").
>
> It uses snapper for snapshots management and all seems to work pretty fine.
>
> My problem is to be able to know the remaining REAL free space in my
> partition.
>
> Using different commands, i have different results, and i don't know how
> to interpret them correctly :
> poivron:~ # btrfs filesystem df /
> Data: total=4.01GB, used=2.16GB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=3.00GB, used=429.16MB
> Metadata: total=8.00MB, used=0.00

In effect the output of "btrfs filesystem df /" is not very friendly. 
What about changing the output as below:

$ btrfs filesystem disk-free /
Summary:
   Total: 			135.00GB
   Allocated:			 10.51GB
   Unallocated:			124.49GB
   Free_(Estimated)	   	 86.56GB
   Average_disk_efficiency:  	    62 %

Details:
   Chunk-type      Mode       Allocated        Used        Free
   ----------      ----       ---------    --------   ---------
   Data		  Single        4.01GB	    2.16GB      1.87GB
   System	  DUP	       16.00MB	    4.00KB      7.99MB
   System	  Single	4.00MB	      0.00      4.00MB
   Metadata	  DUP	        6.00GB    429.16MB      2.57GB
   Metadata	  Single        8.00MB        0.00      8.00MB



Where the "Free_(Estimated)" and "Average_disk_efficency" are computed as:
   Average_disk_efficency = ratio of average disk usage =
	(sum(ChunkUsed)+sum(ChunkFree))/sum(ChunkAllocated)

   Estimated_available = Average_disk_efficency *
				Unallocated+sum(ChunkFree)

I am open to suggestion about the terms: Used vs Allocated and Free vs 
Available, or a better description of "Average disk efficiency"


BR
G.Baroncelli

P.S. the source could be find at

	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

branch
	disk_free
