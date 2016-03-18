Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:33532 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034AbcCRSzV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 14:55:21 -0400
Received: by mail-qg0-f49.google.com with SMTP id a36so76271350qge.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 11:55:21 -0700 (PDT)
Subject: Re: Snapshots slowing system
To: Pete <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
 <pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
 <56E88CB2.6020300@petezilla.co.uk> <56E945E9.1050005@gmail.com>
 <56EB1CC7.2000602@petezilla.co.uk>
 <pan$24d34$c6dcbaed$b9940b06$c8b4f058@cox.net>
 <56EC4612.4030206@petezilla.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56EC4EFE.5000105@gmail.com>
Date: Fri, 18 Mar 2016 14:54:54 -0400
MIME-Version: 1.0
In-Reply-To: <56EC4612.4030206@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-18 14:16, Pete wrote:
> On 03/18/2016 09:17 AM, Duncan wrote:
>
>> So bottom line regarding that smartctl output, yeah, a new device is
>> probably a very good idea at this point.  Those smart attributes indicate
>> either head slop or spin wobble, and some errors and command timeouts and
>> retries, which could well account for your huge slowdowns.  Fortunately,
>> it's mostly backup, so you have your working copy, but if I'm not mixing
>> up my threads, you have some media files, etc, on a different partition
>> on it as well, and if you don't have backups elsewhere, getting them onto
>> something else ASAP is a very good idea, because this drive does look to
>> be struggling, and tho it could continue working in a low usage scenario
>> for some time yet, it could also fail rather quickly, as well.
>>
>
> This disk is one of a pair or raid1 disks which hold the data on my
> system.  As you summised the machine is generally on 24x7 as it can just
> get on with backups and some data grabbing and crunching on its own.
>
> This is a set up of 2 x 3TB disks completely dedicated to btrfs.  I'm
> wondering if the failing one is the older one wrenched out of a USB
> enclosure as it was cheaper than a desktop one or whether it was the
> desktop drive?  Still academic.  I have 1.37TB unallocated, 720GB free
> estimated.  I'm therefore wondering whether I opt for the cheapest
> reasonable desktop drive, a NAS drive advertised for 24x7 or whether I
> pick a wallet frightening 'enterprise drive' as it might be twice as
> much as the standard desktop but will give me less grief in the long
> term.  Probably one for comp.os.linux.hardware.
Personally, I find that desktop drives generally do fine for 24/7 usage 
as long as things aren't constantly being written to and read from them. 
  For a write-once-read-many workload like most backup setups, there's 
not usually a huge advantage to getting high end disks unless you can't 
be there to replace them relatively soon after they fail (one disk in a 
RAID set failing puts more load on the other disk, thus increasing it's 
chance of also failing).  Desktop disks usually do provide similarly low 
error rates as higher end disks, the big difference is in how they 
handle errors.  Desktop drives will (usually) keep retrying a read on a 
bad sector for multiple minutes before giving up, while NAS drives will 
return an error almost immediately, and enterprise drives will let you 
configure how long it will retry.
>
>
>>> Confused.  I'm getting one SSD which I intend to use raid0.  Seems to me
>>> to make no sense to split it in two and put both sides of raid1 on one
>>> disk and I reasonably think that you are not suggesting that.  Or are
>>> you assuming that I'm getting two disks?  Or are you saying that buying
>>> a second SSD disk is strongly advised?  (bearing in mind that it looks
>>> like I might need another hdd if the smart field above is worth worrying
>>> about).
>>
>> Well, raid0 normally requires two devices.  So either you mean single
>> mode on a single device, or you're combining it with another device (or
>> more than one more) to do raid0.
>
> Sorry, I confused raid0 with single.  The _lone_ system disk contains
> the root partition, it is btrfs in single mode.
Don't feel bad, I made this mistake myself a couple of times at first too.
>
>
>
>> So btrfs raid1 has data integrity and repair features that aren't
>> available on normal raid1, and thus is highly recommended.
>>
>> But, raid1 /does/ mean two copies of both data and metadata (assuming of
>> course you make them both raid1, as I did), and if you simply don't have
>> room to do it that way, you don't have room, highly recommended tho it
>> may be.
>
> This looks like a strong recommendation to get a second SSD for the root
> partition and go raid1.  Are SSDs more flakey that hdd or are you just a
> strong believer in the integrity of raid1?
Generally, SSD's have better reliability in harsh conditions than HDD's, 
they can safely handle a wider temperature range, and are pretty much 
unaffected by vibration.  They fail in different ways however, so advice 
for preventing data loss on HDD's doesn't necessarily apply to SSD's.

Overall though, it really depends on what brand you get.  As of right 
now, the top three brands of SSD as far as quality IMHO are Intel, 
Samsung, and Crucial.  I usually go with Crucial myself because they are 
almost on-par with the other two, give more deterministic performance 
(their peak performance is often lower, but I'm willing to sacrifice a 
bit of performance to get consistency across operating conditions), and 
cost less (sometimes less than half as much as an equivalently sized 
Intel or Samsung SSD) .  Kingston, SanDisk, ADATA, Transcend, and Micron 
are generally OK, but sometimes have issues with data loss when they 
lose power unexpectedly (this likely won't be an issue for you though if 
you have a system that's on 24/7).  The only brand I would actively 
avoid is OCZ, as they've had numerous issues with reliability and data 
integrity over multiple revisions of multiple models of SSD.
