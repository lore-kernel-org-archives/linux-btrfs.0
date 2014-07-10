Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50494 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGJCKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 22:10:52 -0400
From: Russell Coker <russell@coker.com.au>
To: Martin Steigerwald <ms@teamix.de>, linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: Re: btrfs RAID with enterprise SATA or SAS drives
Date: Thu, 10 Jul 2014 12:10:46 +1000
Message-ID: <1873412.YKCevnRR4J@russell.coker.com.au>
In-Reply-To: <41327882.AW8TtKTnAV@merkaba>
References: <4FAAE94D.4010103@pocock.com.au> <41327882.AW8TtKTnAV@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 9 Jul 2014 16:48:05 Martin Steigerwald wrote:
> > - for someone using SAS or enterprise SATA drives with Linux, I
> > understand btrfs gives the extra benefit of checksums, are there any
> > other specific benefits over using mdadm or dmraid?
> 
> I think I can answer this one.
> 
> Most important advantage I think is BTRFS is aware of which blocks of the
> RAID are in use and need to be synced:
> 
> - Instant initialization of RAID regardless of size (unless at some
> capacity mkfs.btrfs needs more time)

>From mdadm(8):

       --assume-clean
              Tell mdadm that the array pre-existed and is known to be  clean.
              It  can be useful when trying to recover from a major failure as
              you can be sure that no data will be affected unless  you  actu‐
              ally  write  to  the array.  It can also be used when creating a
              RAID1 or RAID10 if you want to avoid the initial resync, however
              this  practice  — while normally safe — is not recommended.  Use
              this only if you really know what you are doing.

              When the devices that will be part of a new  array  were  filled
              with zeros before creation the operator knows the array is actu‐
              ally clean. If that is the case,  such  as  after  running  bad‐
              blocks,  this  argument  can be used to tell mdadm the facts the
              operator knows.

While it might be regarded as a hack, it is possible to do a fairly instant 
initialisation of a Linux software RAID-1.

> - Rebuild after disk failure or disk replace will only copy *used* blocks

Have you done any benchmarks on this?  The down-side of copying used blocks is 
that you first need to discover which blocks are used.  Given that seek time is 
a major bottleneck at some portion of space used it will be faster to just 
copy the entire disk.

I haven't done any tests on BTRFS in this regard, but I've seen a disk 
replacement on ZFS run significantly slower than a dd of the block device 
would.

> Scrubbing can repair from good disk if RAID with redundancy, but SoftRAID
> should be able to do this as well. But also for scrubbing: BTRFS only
> check and repairs used blocks.

When you scrub Linux Software RAID (and in fact pretty much every RAID) it 
will only correct errors that the disks flag.  If a disk returns bad data and 
says that it's good then the RAID scrub will happily copy the bad data over 
the good data (for a RAID-1) or generate new valid parity blocks for bad data 
(for RAID-5/6).

http://research.cs.wisc.edu/adsl/Publications/corruption-fast08.html

Page 12 of the above document says that "nearline" disks (IE the ones people 
like me can afford for home use) have a 0.466% incidence of returning bad data 
and claiming it's good in a year.  Currently I run about 20 such disks in a 
variety of servers, workstations, and laptops.  Therefore the probability of 
having no such errors on all those disks would be .99534^20=.91081.  The 
probability of having no such errors over a period of 10 years would be 
(.99534^20)^10=.39290 which means that over 10 years I should expect to have 
such errors, which is why BTRFS RAID-1 and DUP metadata on single disks are 
necessary features.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

