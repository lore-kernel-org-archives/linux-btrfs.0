Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:57300 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbeBQPSF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Feb 2018 10:18:05 -0500
Subject: Re: Ongoing Btrfs stability issues
To: Shehbaz Jaffer <shehbazjaffer007@gmail.com>, Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
 <pan$44d82$cdc95127$80ea1d4a$cb43d97@cox.net>
 <CAPLK-i8zoUfmq8aYN7b-bczQieMyAsN6pY+-q5GHxGM0ca9U-g@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1994bc33-fc8e-d0f9-3b4e-220834b0fe60@mendix.com>
Date: Sat, 17 Feb 2018 16:18:02 +0100
MIME-Version: 1.0
In-Reply-To: <CAPLK-i8zoUfmq8aYN7b-bczQieMyAsN6pY+-q5GHxGM0ca9U-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/17/2018 05:34 AM, Shehbaz Jaffer wrote:
>> It's hosted on an EBS volume; we don't use ephemeral storage at all. The EBS volumes are all SSD
> 
> I have recently done some SSD corruption experiments on small set of
> workloads, so I thought I would share my experience.
> 
> While creating btrfs using mkfs.btrfs command for SSDs, by default the
> metadata duplication option is disabled. this renders btrfs-scrubbing
> ineffective, as there are no redundant metadata to restore corrupted
> metadata from.
> So if there are any errors during read operation on SSD, unlike HDD
> where the corruptions would be handled by btrfs scrub on the fly while
> detecting checksum error, for SSD the read would fail as uncorrectable
> error.

First of all, the ssd mount option does not have anything to do with
having single or DUP metadata.

Well, both the things that happen by default (mkfs using single, mount
enabling the ssd option) are happening because of the lookup result on
the rotational flag, but that's all.

> Could you confirm if metadata DUP is enabled for your system by
> running the following cmd:
> 
> $btrfs fi df /mnt # mount is the mount point
> Data, single: total=8.00MiB, used=64.00KiB
> System, single: total=4.00MiB, used=16.00KiB
> Metadata, single: total=168.00MiB, used=112.00KiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> 
> If metadata is single in your case as well (and not DUP), that may be
> the problem for btrfs-scrub not working effectively on the fly
> (mid-stream bit-rot correction), causing reliability issues. A couple
> of such bugs that are observed specifically for SSDs is reported here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=198463
> https://bugzilla.kernel.org/show_bug.cgi?id=198807

Here you show that when you have 'single' metadata, there's no copy to
recover from. This is expected.

Also, instead of physically damaging flash cells inside your SSD, you
are writing data to a perfectly working one. This is a different failure
scenario.

One of the reasons to turn off DUP for metadata by default on SSD is
(from man mkfs.btrfs):

    "The controllers may put data written in a short timespan into the
same physical storage unit (cell, block etc). In case this unit dies,
both copies are lost. BTRFS does not add any artificial delay between
metadata writes." .. "The traditional rotational hard drives usually
fail at the sector level."

And, of course, in case of EBS, you don't have any idea at all where the
data actually ends up, since it's talking to a black box service, and
not an SSD.

In any case, using DUP instead of single obviously increases the chance
of recovery in case of failures that corrupt one copy of the data when
it's travelling between system memory and disk, while you're sending two
of them right after each other, so you're totally right that it's better
to enable.

> These do not occur for HDD, and I believe should not occur when
> filesystem is mounted with nossd mode.

So to reiterate, mounting nossd does not make your metadata writes DUP.

> On Fri, Feb 16, 2018 at 10:03 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Austin S. Hemmelgarn posted on Fri, 16 Feb 2018 14:44:07 -0500 as
>> excerpted:
>>
>>> This will probably sound like an odd question, but does BTRFS think your
>>> storage devices are SSD's or not?  Based on what you're saying, it
>>> sounds like you're running into issues resulting from the
>>> over-aggressive SSD 'optimizations' that were done by BTRFS until very
>>> recently.
>>>
>>> You can verify if this is what's causing your problems or not by either
>>> upgrading to a recent mainline kernel version (I know the changes are in
>>> 4.15, I don't remember for certain if they're in 4.14 or not, but I
>>> think they are), or by adding 'nossd' to your mount options, and then
>>> seeing if you still have the problems or not (I suspect this is only
>>> part of it, and thus changing this will reduce the issues, but not
>>> completely eliminate them).  Make sure and run a full balance after
>>> changing either item, as the aforementioned 'optimizations' have an
>>> impact on how data is organized on-disk (which is ultimately what causes
>>> the issues), so they will have a lingering effect if you don't balance
>>> everything.
>>
>> According to the wiki, 4.14 does indeed have the ssd changes.
>>
>> According to the bug, he's running 4.13.x on one server and 4.14.x on
>> two.  So upgrading the one to 4.14.x should mean all will have that fix.
>>
>> However, without a full balance it /will/ take some time to settle down
>> (again, assuming btrfs was using ssd mode), so the lingering effect could
>> still be creating problems on the 4.14 kernel servers for the moment.

-- 
Hans van Kranenburg
