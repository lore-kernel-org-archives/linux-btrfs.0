Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34173 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbcDZLoC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 07:44:02 -0400
Received: by mail-lf0-f54.google.com with SMTP id j11so14459961lfb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 04:44:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <571F4CD0.9050004@gmail.com>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
	<pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
	<571DFCF2.6050604@gmail.com>
	<pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net>
	<571E154C.9060604@gmail.com>
	<CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
	<571F4CD0.9050004@gmail.com>
Date: Tue, 26 Apr 2016 05:44:00 -0600
Message-ID: <CAHaPQf39H-JRhQmCssmgJ98RCxL_36poE_kObAmgmH6nkn4xoA@mail.gmail.com>
Subject: Re: Add device while rebalancing
From: Juan Alberto Cirez <jacirez@rdcsafety.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well,
RAID1 offers no parity, striping, or spanning of disk space across
multiple disks.

RAID10 configuration, on the other hand, requires a minimum of four
HDD, but it stripes data across mirrored pairs. As long as one disk in
each mirrored pair is functional, data can be retrieved.

With GlusterFS as a distributed volume, the files are already spread
among the servers causing file I/O to be spread fairly evenly among
them as well, thus probably providing the benefit one might expect
with stripe (RAID10).

The question I have now is: Should I use a RAID10 or RAID1 underneath
of a GlusterFS stripped (and possibly replicated) volume?

On Tue, Apr 26, 2016 at 5:11 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-04-26 06:50, Juan Alberto Cirez wrote:
>>
>> Thank you guys so very kindly for all your help and taking the time to
>> answer my question. I have been reading the wiki and online use cases
>> and otherwise delving deeper into the btrfs architecture.
>>
>> I am managing a 520TB storage pool spread across 16 server pods and
>> have tried several methods of distributed storage. Last attempt was
>> using Zfs as a base for the physical bricks and GlusterFS as a glue to
>> string together the storage pool. I was not satisfied with the results
>> (mainly Zfs). Once I have run btrfs for a while on the test server
>> (32TB, 8x 4TB HDD RAID10) for a while I will try btrfs/ceph
>
> For what it's worth, GlusterFS works great on top of BTRFS.  I don't have
> any claims to usage in production, but I've done _a lot_ of testing with it
> because we're replacing one of our critical file servers at work with a
> couple of systems set up with Gluster on top of BTRFS, and I've been looking
> at setting up a small storage cluster at home using it on a couple of
> laptops I have which have non-functional displays.  Based on what I've seen,
> it appears to be rock solid with respect to the common failure modes,
> provided you use something like raid1 mode on the BTRFS side of things.
