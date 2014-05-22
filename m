Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:47711 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752714AbaEVWJr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 18:09:47 -0400
Message-ID: <ac1e9fe46f993235f30b4c003210dec8.squirrel@webmail.wanet.net>
In-Reply-To: <1795587.Ol58oREtZ7@xev>
References: <2308735.51F3c4eZQ7@xev> <4483661.BdmCOR8JR5@xev>
    <57f050e2a37907d810b40c5e115b28ff.squirrel@webmail.wanet.net>
    <1795587.Ol58oREtZ7@xev>
Date: Thu, 22 May 2014 15:09:40 -0700
Subject: Re: ditto blocks on ZFS
From: ashford@whisperpc.com
To: russell@coker.com.au
Cc: ashford@whisperpc.com, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell,

Overall, there are still a lot of unknowns WRT the stability, and ROI
(Return On Investment) of implementing ditto blocks for BTRFS.  The good
news is that there's a lot of time before the underlying structure is in
place to support, so there's time to figure this out a bit better.

> On Tue, 20 May 2014 07:56:41 ashford@whisperpc.com wrote:
>> 1.  There will be more disk space used by the metadata.  I've been aware
>> of space allocation issues in BTRFS for more than three years.  If the
>> use of ditto blocks will make this issue worse, then it's probably not a
>> good idea to implement it.  The actual increase in metadata space is
>> probably small in most circumstances.
>
> Data, RAID1: total=2.51TB, used=2.50TB
> System, RAID1: total=32.00MB, used=376.00KB
> Metadata, RAID1: total=28.25GB, used=26.63GB
>
> The above is my home RAID-1 array.  It includes multiple backup copies of
> a medium size Maildir format mail spool which probably accounts for a
> significant portion of the used space, the Maildir spool has an average
> file size of about 70K and lots of hard links between different versions
> of the backup.  Even so the metadata is only 1% of the total used space.
> Going from 1% to 2% to improve reliability really isn't a problem.
>
> Data, RAID1: total=140.00GB, used=139.60GB
> System, RAID1: total=32.00MB, used=28.00KB
> Metadata, RAID1: total=4.00GB, used=2.97GB
>
> Above is a small Xen server which uses snapshots to backup the files for
> Xen block devices (the system is lightly loaded so I don't use nocow)
> and for data> files that include a small Maildir spool.  It's still only
> 2% of disk space used for metadata, again going from 2% to 4% isn't
> going to be a great problem.

You've addressed half of the issue.  It appears that the metadata is
normally a bit over 1% using the current methods, but two samples do not
make a statistical universe.  The good news is that these two samples are
from opposite extremes of usage, so I expect they're close to where the
overall average would end up.  I'd like to see a few more samples, from
other usage scenarios, just to be sure.

If the above numbers are normal, adding ditto blocks could increase the
size of the metadata from 1% to 2% or even 3%.  This isn't a problem.

What we still don't know, and probably won't until after it's implemented,
is whether or not the addition of ditto blocks will make the space
allocation worse.

>> 2.  Use of ditto blocks will increase write bandwidth to the disk.  This
>> is a direct and unavoidable result of having more copies of the
>> metadata.
>> The actual impact of this would depend on the file-system usage pattern,
>> but would probably be unnoticeable in most circumstances.  Does anyone
>> have a “worst-case” scenario for testing?
>
> The ZFS design involves ditto blocks being spaced apart due to the fact
> that corruption tends to have some spacial locality.  So you are adding
> an extra seek.
>
> The worst case would be when you have lots of small synchronous writes,
> probably the default configuration of Maildir delivery would be a good
> case.

Is there a performance test for this?  That would be helpful in
determining the worst-case performance impact of implementing ditto
blocks, and probably some other enhancements as well.

>> 3.  Certain kinds of disk errors would be easier to recover from.  Some
>> people here claim that those specific errors are rare.  I have no
>> opinion on how often they happen, but I believe that if the overall
>> disk space cost is low, it will have a reasonable return.  There would
>> be virtually no reliability gains on an SSD-based file-system, as the
>> ditto blocks would be written at the same time, and the SSD would be
>> likely to map the logical blocks into the same page of flash memory.
>
> That claim is unproven AFAIK.

That claim is a direct result of how SSDs function.

>> 4.  If the BIO layer of BTRFS and the device driver are smart enough,
>> ditto blocks could reduce I/O wait time.  This is a direct result of
>> having more instances of the data on the disk, so it's likely that there
>> will be a ditto block closer to where the disk head is currently.  The
>> actual benefit for disk-based file-systems is likely to be under 1ms per
>> metadata seek.  It's possible that a short-term backlog on one disk
>> could cause BTRFS to use a ditto block on another disk, which could
>> deliver >20ms of performance.  There would be no performance benefit for
>> SSD-based file-systems.
>
> That is likely with RAID-5 and RAID-10.

It's likely with all disk layouts.  The reason just looks different on
different RAID structures.

>> My experience is that once your disks are larger than about 500-750GB,
>> RAID-6 becomes a much better choice, due to the increased chances of
>> having an uncorrectable read error during a reconstruct.  My opinion is
>> that anyone storing critical information in RAID-5, or even 2-disk
>> RAID-1,
>> with disks of this capacity, should either reconsider their storage
>> topology, or verify that they have a good backup/restore mechanism in
>> place for that data.
>
> http://research.cs.wisc.edu/adsl/Publications/corruption-fast08.html
>
> The NetApp research shows that the incidence of silent corruption is a
> lot greater than you would expect.  RAID-6 doesn't save you from this.
> You need BTRFS or ZFS RAID-6.

I was referring to hard read errors, not silent data corruption.

Peter Ashford

