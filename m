Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34607 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbcDZMOL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 08:14:11 -0400
Received: by mail-lf0-f43.google.com with SMTP id j11so15394400lfb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 05:14:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <571F594A.2090305@gmail.com>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
	<pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
	<571DFCF2.6050604@gmail.com>
	<pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net>
	<571E154C.9060604@gmail.com>
	<CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
	<571F4CD0.9050004@gmail.com>
	<CAHaPQf39H-JRhQmCssmgJ98RCxL_36poE_kObAmgmH6nkn4xoA@mail.gmail.com>
	<571F594A.2090305@gmail.com>
Date: Tue, 26 Apr 2016 06:14:04 -0600
Message-ID: <CAHaPQf2h3Q3iXfuxM5YzmhxgEVTBeaJsn41Du_Y5jHH6ZzTMvQ@mail.gmail.com>
Subject: Re: Add device while rebalancing
From: Juan Alberto Cirez <jacirez@rdcsafety.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you again, Austin.

My ideal case would be high availability coupled with reliable data
replication and integrity against accidental lost. I am willing to
cede ground on the write speed; but the read has to be as optimized as
possible.
So far BTRFS, RAID10 on the 32TB test server is quite good both read &
write and data lost/corruption has not been an issue yet. When I
introduce the network/distributed layer, I would like the same.
BTW does Ceph provides similar functionality, reliability and performace?

On Tue, Apr 26, 2016 at 6:04 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-04-26 07:44, Juan Alberto Cirez wrote:
>>
>> Well,
>> RAID1 offers no parity, striping, or spanning of disk space across
>> multiple disks.
>>
>> RAID10 configuration, on the other hand, requires a minimum of four
>> HDD, but it stripes data across mirrored pairs. As long as one disk in
>> each mirrored pair is functional, data can be retrieved.
>>
>> With GlusterFS as a distributed volume, the files are already spread
>> among the servers causing file I/O to be spread fairly evenly among
>> them as well, thus probably providing the benefit one might expect
>> with stripe (RAID10).
>>
>> The question I have now is: Should I use a RAID10 or RAID1 underneath
>> of a GlusterFS stripped (and possibly replicated) volume?
>
> If you have enough systems and a new enough version of GlusterFS, I'd
> suggest using raid1 on the low level, and then either a distributed
> replicated volume or an erasure coded volume in GlusterFS.
> Having more individual nodes involved will improve your scalability to
> larger numbers of clients, and you can have more nodes with the same number
> of disks if you use raid1 instead of raid10 on BTRFS.  Using Erasure coding
> in Gluster will provide better resiliency with higher node counts for each
> individual file, at the cost of moderately higher CPU time being used.
> FWIW, RAID5 and RAID6 are both specific cases of (mathematically) optimal
> erasure coding (RAID5 is n,n+1 and RAID6 is n,n+2 using the normal
> notation), but the equivalent forms in Gluster are somewhat risky with any
> decent sized cluster.
>
> It is worth noting that I would not personally trust just GlusterFS or just
> BTRFS with the data replication, BTRFS is still somewhat new (although I
> haven't had a truly broken filesystem in more than a year), and GlusterFS
> has a lot more failure modes because of the networking.
>
>>
>> On Tue, Apr 26, 2016 at 5:11 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>
>>> On 2016-04-26 06:50, Juan Alberto Cirez wrote:
>>>>
>>>>
>>>> Thank you guys so very kindly for all your help and taking the time to
>>>> answer my question. I have been reading the wiki and online use cases
>>>> and otherwise delving deeper into the btrfs architecture.
>>>>
>>>> I am managing a 520TB storage pool spread across 16 server pods and
>>>> have tried several methods of distributed storage. Last attempt was
>>>> using Zfs as a base for the physical bricks and GlusterFS as a glue to
>>>> string together the storage pool. I was not satisfied with the results
>>>> (mainly Zfs). Once I have run btrfs for a while on the test server
>>>> (32TB, 8x 4TB HDD RAID10) for a while I will try btrfs/ceph
>>>
>>>
>>> For what it's worth, GlusterFS works great on top of BTRFS.  I don't have
>>> any claims to usage in production, but I've done _a lot_ of testing with
>>> it
>>> because we're replacing one of our critical file servers at work with a
>>> couple of systems set up with Gluster on top of BTRFS, and I've been
>>> looking
>>> at setting up a small storage cluster at home using it on a couple of
>>> laptops I have which have non-functional displays.  Based on what I've
>>> seen,
>>> it appears to be rock solid with respect to the common failure modes,
>>> provided you use something like raid1 mode on the BTRFS side of things.
>
>
