Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:42656 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdLPKVV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Dec 2017 05:21:21 -0500
Received: by mail-vk0-f50.google.com with SMTP id 189so7018078vkc.9
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Dec 2017 02:21:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87dfadcb-f4d6-1a63-838c-0725d3a3dde6@mendix.com>
References: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
 <20171215103423.0fd678a6@natsu> <CAA85sZsEf7T+9s_BKpzoFm4aNO6hHsXNTk86LQCOiFiuA3aJYw@mail.gmail.com>
 <88ff9cce-fa9b-ef4e-e1ea-062e13eec833@gmx.com> <87dfadcb-f4d6-1a63-838c-0725d3a3dde6@mendix.com>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Sat, 16 Dec 2017 11:20:59 +0100
Message-ID: <CAA85sZuS7=+8PBU6aWu1dvRm5_2R6TSxxfcM6OnH9Jkyans+gQ@mail.gmail.com>
Subject: Re: [4.14.3] btrfs out of space error
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 16, 2017 at 12:07 AM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> On 12/15/2017 09:53 AM, Qu Wenruo wrote:
>> On 2017年12月15日 16:36, Ian Kumlien wrote:
>>> On Fri, Dec 15, 2017 at 6:34 AM, Roman Mamedov <rm@romanrm.net> wrote:
>>>> On Fri, 15 Dec 2017 01:39:03 +0100
>>>> Ian Kumlien <ian.kumlien@gmail.com> wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> Running a 4.14.3 kernel, this just happened, but there should have
>>>>> been another 20 gigs or so available.
>>>>>
>>>>> The filesystem seems fine after a reboot though
>>>>
>>>> What are your mount options, and can you show the output of "btrfs fi
>>>> df" and "btrfs fi us" for the filesystem? And what does
>>>> "cat /sys/block/sdb/queue/rotational" return.
>>>
>>> It's a btrfs raid1 mirror of two ssd:s
>>>
>>> mount options was:
>>> defaults,acl,noatime,space_cache,autodefrag,compress=lzo
>>>
>>> btrfs fi df /
>>> Data, RAID1: total=459.25GiB, used=372.42GiB
>>> Data, single: total=8.00MiB, used=0.00B
>>> System, RAID1: total=8.00MiB, used=80.00KiB
>>> System, single: total=4.00MiB, used=0.00B
>>> Metadata, RAID1: total=6.00GiB, used=3.69GiB
>>
>> Both meta and data has a lot of space let.
>
> The real question is how fragmented that free space is.

Somewhat fragmented i'd say

> Here's a good starting point to read up about the -o ssd behavior pre 4.14:
>
> https://www.spinics.net/lists/linux-btrfs/msg70622.html

Will do

[--8<--]

>>> Unallocated:
>>>    /dev/sdb2   24.00KiB
>>>    /dev/sdc2   20.02MiB
>>
>> Well, at least no new chunk can be allocated.
>
> Exactly.

After running:
btrfs balance start -dusage=50 /

a few times (first one failed but freed 6 gigs) it's now:
Unallocated:
   /dev/sdb2   13.25GiB
   /dev/sdc2   13.26GiB

>> In v4.15, Josef introduced a new inode reservation system, which I think
>> it would enhance metadata related reservation.
>>
>> If you're hitting the problem quite frequently, please consider to try
>> v4.15-rc* to see if it solves the problem.
>>
>> Despite of that, there should be no damage to your fs.
>> (except some unwritten data in buffer)
>>
>> Thanks,
>> Qu
>>
>>>
>>> And as expected:
>>> cat /sys/block/sdb/queue/rotational
>>> 0
>>>
>>>> I wonder if it's the same old "ssd allocation scheme" problem, and no
>>>> balancing done in a long time or at all.
>
> Looks like it. So, yay, you're on 4.14 already. Now just do a full
> balance of your entire filesystem, only once (data only, metadata not
> needed) and then you can forget about this again.

Any special filters etc needed?

>>> I had something similar happen on a laptop a while ago - took a while
>>> before i could get it back in order
>>> (in that case i think it was actually a oops --- it kept saying "no
>>> space left" and switched to read only even
>>> if you removed a lot of data, invalidated the space cache and so on)
>
> --
> Hans van Kranenburg
