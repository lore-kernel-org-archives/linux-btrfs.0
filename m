Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37262 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762691Ab2KBLSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 07:18:31 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
Date: Fri, 2 Nov 2012 12:18:29 +0100
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it> (sfid-20121102_120303_604806_A6E2AC77)
In-Reply-To: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201211021218.29778.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 2. November 2012 schrieb Goffredo Baroncelli:
> Hi all, on the basis of the discussion in the thread
> '[RFC] New attempt to a better "btrfs fi df"', I prepared the following
> set of patches.
> These patches update the btrfs fi df command and add two new commands:
> - btrfs filesystem disk-usage <path>
> - btrfs device disk-usage <path>
> 
> The command "btrfs filesystem df" now shows only the disk
> usage/available.
> 
> $ btrfs filesystem df /mnt/btrfs1/
> Disk size:		 109.00GB
> Disk allocated:		   5.90GB
> Disk unallocated:	 103.10GB
> Used:			 284.00KB
> Free (Estimated):	  63.00GB	(Max: 106.51GB, min: 54.96GB)
> Data to disk ratio:	     58 %

This is coming along nicely.

Tested-By: Martin Steigerwald <martin@lichtvoll.de>

I can test on some other boxes next week, if you want to.

I just wonder about one thing:


merkaba:[…]/btrfs-progs-unstable> ./btrfs fi df /
Disk size:                18.62GB
Disk allocated:           18.62GB
Disk unallocated:            0.00
Used:                     11.26GB
Free (Estimated):          5.61GB       (Max: 5.61GB, min: 5.61GB)
Data to disk ratio:          91 %


merkaba:[…]/btrfs-progs-unstable> ./btrfs filesystem disk-usage /
Data,Single: Size:15.10GB, Used:10.65GB
   /dev/dm-0       15.10GB

Metadata,Single: Size:8.00MB, Used:0.00
   /dev/dm-0        8.00MB

Metadata,DUP: Size:1.75GB, Used:627.84MB
   /dev/dm-0        3.50GB

System,Single: Size:4.00MB, Used:0.00
   /dev/dm-0        4.00MB

System,DUP: Size:8.00MB, Used:4.00KB
   /dev/dm-0       16.00MB

Unallocated:
   /dev/dm-0          0.00


merkaba:[…]/btrfs-progs-unstable> ./btrfs filesystem disk-usage -t /
          Data    Metadata Metadata System System             
          Single  Single   DUP      Single DUP     Unallocated
                                                              
/dev/dm-0 15.10GB   8.00MB   3.50GB 4.00MB 16.00MB        0.00
          ======= ======== ======== ====== ======= ===========
Total     15.10GB   8.00MB   1.75GB 4.00MB  8.00MB        0.00
Used      10.65GB     0.00 627.84MB   0.00  4.00KB            


Metadata, DUP is displayed as 3,50GB on the device level and as 1,75GB
in total. I understand the logic behind this, but this could be a bit
confusing.

But it makes sense: Showing real allocation on device level makes sense,
cause thats what really allocated on disk. Total makes some sense, cause
thats what is being used from the tree by BTRFS.

It still looks confusing at first…

Maybe two sizes: One total with dup / raid1 / raid10 being accounted for
and one without?

Well maybe just leave as is for now. This output is for experienced
users.


merkaba:[…]/btrfs-progs-unstable> ./btrfs device disk-usage /   
/dev/dm-0          18.62GB
   Data,Single:             15.10GB
   Metadata,Single:          8.00MB
   Metadata,DUP:             3.50GB
   System,Single:            4.00MB
   System,DUP:              16.00MB
   Unallocated:                0.00


This is a nice view on the disk. I know its fully allocated by BTRFS,
and in order to make more free space for the data tree for example I´d
need to look at the tree usage and then if it makes sense do a balance
operation.

Well in that case, I plan to migrate metadata and system to single. And
remove the dup trees then.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
