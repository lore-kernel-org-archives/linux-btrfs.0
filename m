Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:52532 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756599AbdLOXHn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 18:07:43 -0500
Subject: Re: [4.14.3] btrfs out of space error
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Ian Kumlien <ian.kumlien@gmail.com>,
        Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
 <20171215103423.0fd678a6@natsu>
 <CAA85sZsEf7T+9s_BKpzoFm4aNO6hHsXNTk86LQCOiFiuA3aJYw@mail.gmail.com>
 <88ff9cce-fa9b-ef4e-e1ea-062e13eec833@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <87dfadcb-f4d6-1a63-838c-0725d3a3dde6@mendix.com>
Date: Sat, 16 Dec 2017 00:07:40 +0100
MIME-Version: 1.0
In-Reply-To: <88ff9cce-fa9b-ef4e-e1ea-062e13eec833@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/15/2017 09:53 AM, Qu Wenruo wrote:
> 
> 
> On 2017年12月15日 16:36, Ian Kumlien wrote:
>> On Fri, Dec 15, 2017 at 6:34 AM, Roman Mamedov <rm@romanrm.net> wrote:
>>> On Fri, 15 Dec 2017 01:39:03 +0100
>>> Ian Kumlien <ian.kumlien@gmail.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> Running a 4.14.3 kernel, this just happened, but there should have
>>>> been another 20 gigs or so available.
>>>>
>>>> The filesystem seems fine after a reboot though
>>>
>>> What are your mount options, and can you show the output of "btrfs fi
>>> df" and "btrfs fi us" for the filesystem? And what does
>>> "cat /sys/block/sdb/queue/rotational" return.
>>
>> It's a btrfs raid1 mirror of two ssd:s
>>
>> mount options was:
>> defaults,acl,noatime,space_cache,autodefrag,compress=lzo
>>
>> btrfs fi df /
>> Data, RAID1: total=459.25GiB, used=372.42GiB
>> Data, single: total=8.00MiB, used=0.00B
>> System, RAID1: total=8.00MiB, used=80.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, RAID1: total=6.00GiB, used=3.69GiB
> 
> Both meta and data has a lot of space let.

The real question is how fragmented that free space is.

Here's a good starting point to read up about the -o ssd behavior pre 4.14:

https://www.spinics.net/lists/linux-btrfs/msg70622.html

>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> btrfs fi us /
>> Overall:
>>     Device size: 930.54GiB
>>     Device allocated: 930.53GiB
>>     Device unallocated:   20.05MiB
>>     Device missing:      0.00B
>>     Used: 752.22GiB
>>     Free (estimated):   86.84GiB (min: 86.84GiB)
>>     Data ratio:       2.00
>>     Metadata ratio:       2.00
>>     Global reserve: 512.00MiB (used: 0.00B)
>>
>> Data,single: Size:8.00MiB, Used:0.00B
>>    /dev/sdb2    8.00MiB
>>
>> Data,RAID1: Size:459.25GiB, Used:372.42GiB
>>    /dev/sdb2 459.25GiB
>>    /dev/sdc2 459.25GiB
>>
>> Metadata,single: Size:8.00MiB, Used:0.00B
>>    /dev/sdb2    8.00MiB
>>
>> Metadata,RAID1: Size:6.00GiB, Used:3.69GiB
>>    /dev/sdb2    6.00GiB
>>    /dev/sdc2    6.00GiB
>>
>> System,single: Size:4.00MiB, Used:0.00B
>>    /dev/sdb2    4.00MiB
>>
>> System,RAID1: Size:8.00MiB, Used:80.00KiB
>>    /dev/sdb2    8.00MiB
>>    /dev/sdc2    8.00MiB
>>
>> Unallocated:
>>    /dev/sdb2   24.00KiB
>>    /dev/sdc2   20.02MiB
> 
> Well, at least no new chunk can be allocated.

Exactly.

> In v4.15, Josef introduced a new inode reservation system, which I think
> it would enhance metadata related reservation.
> 
> If you're hitting the problem quite frequently, please consider to try
> v4.15-rc* to see if it solves the problem.
> 
> Despite of that, there should be no damage to your fs.
> (except some unwritten data in buffer)
> 
> Thanks,
> Qu
> 
>>
>> And as expected:
>> cat /sys/block/sdb/queue/rotational
>> 0
>>
>>> I wonder if it's the same old "ssd allocation scheme" problem, and no
>>> balancing done in a long time or at all.

Looks like it. So, yay, you're on 4.14 already. Now just do a full
balance of your entire filesystem, only once (data only, metadata not
needed) and then you can forget about this again.

>> I had something similar happen on a laptop a while ago - took a while
>> before i could get it back in order
>> (in that case i think it was actually a oops --- it kept saying "no
>> space left" and switched to read only even
>> if you removed a lot of data, invalidated the space cache and so on)

-- 
Hans van Kranenburg
