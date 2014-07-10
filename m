Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:33053 "EHLO
	mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaGJI1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 04:27:54 -0400
From: Martin Steigerwald <ms@teamix.de>
To: <russell@coker.com.au>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs RAID with enterprise SATA or SAS drives
Date: Thu, 10 Jul 2014 10:27:45 +0200
Message-ID: <1453423.niV9gl2pIF@merkaba>
In-Reply-To: <1873412.YKCevnRR4J@russell.coker.com.au>
References: <4FAAE94D.4010103@pocock.com.au> <41327882.AW8TtKTnAV@merkaba> <1873412.YKCevnRR4J@russell.coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

﻿Am Donnerstag, 10. Juli 2014, 12:10:46 schrieb Russell Coker:
> On Wed, 9 Jul 2014 16:48:05 Martin Steigerwald wrote:
> > > - for someone using SAS or enterprise SATA drives with Linux, I
> > > understand btrfs gives the extra benefit of checksums, are there any
> > > other specific benefits over using mdadm or dmraid?
> > 
> > I think I can answer this one.
> > 
> > Most important advantage I think is BTRFS is aware of which blocks of
> > the RAID are in use and need to be synced:
> > 
> > - Instant initialization of RAID regardless of size (unless at some
> > capacity mkfs.btrfs needs more time)
> 
> From mdadm(8):
> 
>        --assume-clean
>               Tell mdadm that the array pre-existed and is known to be 
> clean. It  can be useful when trying to recover from a major failure as
> you can be sure that no data will be affected unless  you  actu‐ ally 
> write  to  the array.  It can also be used when creating a RAID1 or
> RAID10 if you want to avoid the initial resync, however this  practice 
> — while normally safe — is not recommended.  Use this only if you
> really know what you are doing.
> 
>               When the devices that will be part of a new  array  were 
> filled with zeros before creation the operator knows the array is actu‐
> ally clean. If that is the case,  such  as  after  running  bad‐
> blocks,  this  argument  can be used to tell mdadm the facts the
> operator knows.
> 
> While it might be regarded as a hack, it is possible to do a fairly
> instant initialisation of a Linux software RAID-1.

It is not the same.

BTRFS doesn´t care if the data of the unused blocks differ.

The RAID is on *filesystem* level, not on raw block level. The data on both 
disks don´t even have to be located in the exact same sectors.


> > - Rebuild after disk failure or disk replace will only copy *used*
> > blocks
> Have you done any benchmarks on this?  The down-side of copying used
> blocks is that you first need to discover which blocks are used.  Given
> that seek time is a major bottleneck at some portion of space used it
> will be faster to just copy the entire disk.

As BTRFS operates the RAID on the filesystem level it already knows which 
blocks are in use. I never had a disk replace or faulty disk yet in my two 
RAID-1 arrays, so I have no measurements. It may depend on free space 
fragementation.

> > Scrubbing can repair from good disk if RAID with redundancy, but
> > SoftRAID should be able to do this as well. But also for scrubbing:
> > BTRFS only check and repairs used blocks.
> 
> When you scrub Linux Software RAID (and in fact pretty much every RAID)
> it will only correct errors that the disks flag.  If a disk returns bad
> data and says that it's good then the RAID scrub will happily copy the
> bad data over the good data (for a RAID-1) or generate new valid parity
> blocks for bad data (for RAID-5/6).
> 
> http://research.cs.wisc.edu/adsl/Publications/corruption-fast08.html
> 
> Page 12 of the above document says that "nearline" disks (IE the ones
> people like me can afford for home use) have a 0.466% incidence of
> returning bad data and claiming it's good in a year.  Currently I run
> about 20 such disks in a variety of servers, workstations, and laptops.
>  Therefore the probability of having no such errors on all those disks
> would be .99534^20=.91081.  The probability of having no such errors
> over a period of 10 years would be (.99534^20)^10=.39290 which means
> that over 10 years I should expect to have such errors, which is why
> BTRFS RAID-1 and DUP metadata on single disks are necessary features.

Yeah, the checksums comes in handy here.

(excuse long signature, its added by server)

Ciao,

-- 
Martin Steigerwald
Consultant / Trainer

teamix GmbH
Südwestpark 43
90449 Nürnberg

fon:  +49 911 30999 55
fax:  +49 911 30999 99
mail: martin.steigerwald@teamix.de
web:  http://www.teamix.de
blog: http://blog.teamix.de

Amtsgericht Nürnberg, HRB 18320
Geschäftsführer: Oliver Kügow, Richard Müller

** JETZT ANMELDEN – teamix TechDemo - 23.07.2014 - http://www.teamix.de/techdemo **

