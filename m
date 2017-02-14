Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:33498 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752826AbdBNK60 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 05:58:26 -0500
Received: by mail-wr0-f171.google.com with SMTP id i10so167469615wrb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Feb 2017 02:58:26 -0800 (PST)
Subject: Re: Root volume (ID 5) in deleting state
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <ed8d7383-c75c-584e-4722-c889c6f19a46@gmail.com>
 <a103e413-d922-9c79-0075-1ce00a3cd7de@mendix.com>
 <af9179d8-cf9e-7eef-3150-477bf3a55ff8@gmail.com>
 <e6162766-c862-0098-858f-198e6f88e060@mendix.com>
From: =?UTF-8?B?TWFydGluIE1seW7DocWZ?= <nextsux@gmail.com>
Message-ID: <0f9815fc-c36d-7569-a6d1-ed0d63b9ee87@gmail.com>
Date: Tue, 14 Feb 2017 11:58:22 +0100
MIME-Version: 1.0
In-Reply-To: <e6162766-c862-0098-858f-198e6f88e060@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> It looks you're right!
>>
>> On a different machine:
>>
>> # btrfs sub list / | grep -v lxc
>> ID 327 gen 1959587 top level 5 path mnt/reaver
>> ID 498 gen 593655 top level 5 path var/lib/machines
>>
>> # btrfs sub list / -d | wc -l
>> 0
> Ok, apparently it's a regression in one of the latest versions then.
> But, it seems quite harmless.
I'm glad my data are safe :)

>
>>
>>>> # uname -a
>>>> Linux interceptor 4.9.6-1-ARCH #1 SMP PREEMPT Thu Jan 26 09:22:26 CET
>>>> 2017 x86_64 GNU/Linux
>>>>
>>>> # btrfs fi show  /
>>>> Label: none  uuid: 859dec5c-850c-4660-ad99-bc87456aa309
>>>>       Total devices 1 FS bytes used 132.89GiB
>>>>       devid    1 size 200.00GiB used 200.00GiB path
>>>> /dev/mapper/vg0-btrfsroot
>>> As a side note, all of your disk space is allocated (200GiB of 200GiB).
>>>
>>> Even while there's still 70GiB of free space scattered around inside,
>>> this might lead to out-of-space issues, depending on how badly
>>> fragmented that free space is.
>> I have not noticed this at all!
>>
>> # btrfs fi show /
>> Label: none  uuid: 859dec5c-850c-4660-ad99-bc87456aa309
>>      Total devices 1 FS bytes used 134.23GiB
>>      devid    1 size 200.00GiB used 200.00GiB path /dev/mapper/vg0-btrfsroot
>>
>> # btrfs fi df /
>> Data, single: total=195.96GiB, used=131.58GiB
>> System, single: total=3.00MiB, used=48.00KiB
>> Metadata, single: total=4.03GiB, used=2.64GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> After btrfs defrag there is no difference. btrfs fi show says still
>> 200/200. I'll try to play with it.

[ ... ]
>> So, to get the numbers of total raw disk space allocation down, you need
>> to defragment free space (compact the data), not defrag used space.
>>
>> You can even create pictures of space utilization in your btrfs
>> filesystem, which might help understanding what it looks like right now: \o/
>>
>> https://github.com/knorrie/btrfs-heatmap/
I've run into your tool yesterday while googling around this - thanks, 
it's really nice tool. Now rebalance is running and it seems to work well.

Thank you for excellent responses and help!



