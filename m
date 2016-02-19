Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:35009 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1426761AbcBSABy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 19:01:54 -0500
Received: by mail-vk0-f43.google.com with SMTP id e6so60071485vkh.2
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 16:01:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C52685.8090505@cn.fujitsu.com>
References: <CABmr4wVBb0CCEoU_N2jxYvC=gVn9vUKWfb0902yZDuP2N3ck3w@mail.gmail.com>
	<56C40C06.8090900@cn.fujitsu.com>
	<CABmr4wVvjB7vGDsZWyCd222E1D-+kmk2SS2XwH2dp+K6YWWe=A@mail.gmail.com>
	<56C52685.8090505@cn.fujitsu.com>
Date: Thu, 18 Feb 2016 19:01:53 -0500
Message-ID: <CABmr4wV7FwcPibZ18coRubmfDnfuUWpcG8jLABBUP4rr2jJC9w@mail.gmail.com>
Subject: Re: RAID 6 full, but there is still space left on some devices
From: Dan Blazejewski <dan.blazejewski@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu, thanks for your input. I cancelled the existing balance, and
kicked off a balance set to dconvert=single. Should be busy for the
next few days, but I already see the multiple RAID 6 stripes
disappearing, and the chunk distribution across all drives is starting
to normalize. I'll let you know if it works once it's done. Thanks!

On Wed, Feb 17, 2016 at 9:03 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Dan Blazejewski wrote on 2016/02/17 18:04 -0500:
>>
>> Hello,
>>
>> I upgraded my kernel to 4.4.2, and btrfs-progs to 4.4. I also added
>> another 4TB disk and kicked off a full balance (currently 7x4TB
>> RAID6). I'm interested to see what an additional drive will do to
>> this. I'll also have to wait and see if a full system balance on a
>> newer version of BTRFS tools does the trick or not.
>>
>> I also noticed that "btrfs device usage" shows multiple entries for
>> Data, RAID 6 on some drives. Is this normal? Please note that /dev/sdh
>> is the new disk, and I only just started the balance.
>>
>> # btrfs dev usage /mnt/data
>> /dev/sda, ID: 5
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:           733.67GiB
>>
>> /dev/sdb, ID: 6
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:             2.15TiB
>>
>> /dev/sdc, ID: 7
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:            732.69GiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:        982.00MiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:            25.21MiB
>>
>> /dev/sdd, ID: 1
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:            732.69GiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:        982.00MiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:            25.21MiB
>>
>> /dev/sdf, ID: 3
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:            732.69GiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:        982.00MiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:            25.21MiB
>>
>> /dev/sdg, ID: 2
>>     Device size:             3.64TiB
>>     Data,RAID6:              1.43TiB
>>     Data,RAID6:            732.69GiB
>>     Data,RAID6:              1.48TiB
>>     Data,RAID6:            320.00KiB
>>     Metadata,RAID6:          2.55GiB
>>     Metadata,RAID6:        982.00MiB
>>     Metadata,RAID6:          1.50GiB
>>     System,RAID6:           16.00MiB
>>     Unallocated:            25.21MiB
>>
>> /dev/sdh, ID: 8
>>     Device size:             3.64TiB
>>     Data,RAID6:            320.00KiB
>>     Unallocated:             3.64TiB
>>
>
> Not sure how that multiple chunk type shows up.
> Maybe all these shown RAID6 has different number of stripes?
>
>>
>>
>> Qu, in regards to your question, I ran RAID 1 on multiple disks of
>> different sizes. I believe I had a mix of 2x4TB, 1x2TB, and 1x3TB
>> drive. I replaced the 2TB drive first with a 4TB, and balanced it.
>> Later on, I replaced the 3TB drive with another 4TB, and balanced,
>> yielding an array of 4x4TB RAID1. A little while later, I wound up
>> sticking a fifth 4TB drive in, and converting to RAID6. The sixth 4TB
>> drive was added some time after that. The seventh was added just a few
>> minutes ago.
>
>
> Personally speaking, I just came up to one method to balance all these
> disks, and in fact you don't need to add a disk.
>
> 1) Balance all data chunk to single profile
> 2) Balance all metadata chunk to single or RAID1 profile
> 3) Balance all data chunk back to RAID6 profile
> 4) Balance all metadata chunk back to RAID6 profile
> System chunk is so small that normally you don't need to bother.
>
> The trick is, as single is the most flex chunk type, only needs one disk
> with unallocated space.
> And btrfs chunk allocater will allocate chunk to device with most
> unallocated space.
>
> So after 1) and 2) you should found that chunk allocation is almost
> perfectly balanced across all devices, as long as they are in same size.
>
> Now you have a balance base layout for RAID6 allocation. Should make things
> go quite smooth and result a balanced RAID6 chunk layout.
>
> Thanks,
> Qu
>
>
>
>>
>> Thanks!
>>
>> On Wed, Feb 17, 2016 at 12:58 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>>
>>>
>>> Dan Blazejewski wrote on 2016/02/16 15:20 -0500:
>>>>
>>>>
>>>> Hello,
>>>>
>>>> I've searched high and low about my issue, but have been unable to
>>>> turn up anything like what I'm seeing right now.
>>>>
>>>> A little background: I started using BTRFS over a year ago, in RAID 1
>>>> with mixed size drives. A few months ago, I started replacing the
>>>> disks with 4 TB drives, and eventually switched over to RAID 6. I am
>>>> currently running a 6x4TB RAID6 drive configuration, which should give
>>>> me ~14.5 TB
>>>> usable, but I'm only getting around 11.
>>>>
>>>> The weird thing is that It seems to completely fill 4/6 of the disks,
>>>> while leaving lots of space free on 2 of the disks. I've tried full
>>>> filesystem balances, yet the problem continues.
>>>>
>>>> # btrfs fi show
>>>>
>>>> Label: none  uuid: 78733087-d597-4301-8efa-8e1df800b108
>>>>           Total devices 6 FS bytes used 11.59TiB
>>>>           devid    1 size 3.64TiB used 3.64TiB path /dev/sdd
>>>>           devid    2 size 3.64TiB used 3.64TiB path /dev/sdg
>>>>           devid    3 size 3.64TiB used 3.64TiB path /dev/sdf
>>>>           devid    5 size 3.64TiB used 2.92TiB path /dev/sda
>>>>           devid    6 size 3.64TiB used 1.48TiB path /dev/sdb
>>>>           devid    7 size 3.64TiB used 3.64TiB path /dev/sdc
>>>>
>>>> btrfs-progs v4.2.3
>>>
>>>
>>>
>>> Your space really used up, as it can't found *at least 4* disk with
>>> enough
>>> space to allocate a new chunk.
>>> As 4 devices in your array is already filled, the rest 2 is of no means
>>> for
>>> RAID6, and can only be allocated with Single/RAID1/RAID0.
>>>
>>>
>>> But the real problem is, why your devices get such a unbalanced layout.
>>>
>>> Normally, for RAID5/6, it will allocate chunks using all disk with
>>> available
>>> space, and since all your devices are in the same size, it should result
>>> very balanced allocation.
>>>
>>> How did you convert to current RAID6? Did it involves balance from
>>> already
>>> some used disks?
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>>
>>>>
>>>> # btrfs fi df /mnt/data
>>>>
>>>> Data, RAID6: total=11.67TiB, used=11.58TiB
>>>> System, RAID6: total=64.00MiB, used=1.70MiB
>>>> Metadata, RAID6: total=15.58GiB, used=13.89GiB
>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>> dan@Morpheus:/mnt/data/temp$ sudo btrfs fi usage /mnt/data
>>>>
>>>>
>>>>
>>>> # btrfs fi usage /mnt/data
>>>>
>>>> WARNING: RAID56 detected, not implemented
>>>> WARNING: RAID56 detected, not implemented
>>>> WARNING: RAID56 detected, not implemented
>>>> Overall:
>>>>       Device size:                  21.83TiB
>>>>       Device allocated:                0.00B
>>>>       Device unallocated:           21.83TiB
>>>>       Device missing:                  0.00B
>>>>       Used:                            0.00B
>>>>       Free (estimated):                0.00B      (min: 8.00EiB)
>>>>       Data ratio:                       0.00
>>>>       Metadata ratio:                   0.00
>>>>       Global reserve:              512.00MiB      (used: 0.00B)
>>>>
>>>> Data,RAID6: Size:11.67TiB, Used:11.58TiB
>>>>      /dev/sda        2.92TiB
>>>>      /dev/sdb        1.48TiB
>>>>      /dev/sdc        3.63TiB
>>>>      /dev/sdd        3.63TiB
>>>>      /dev/sdf        3.63TiB
>>>>      /dev/sdg        3.63TiB
>>>>
>>>> Metadata,RAID6: Size:15.58GiB, Used:13.89GiB
>>>>      /dev/sda        4.05GiB
>>>>      /dev/sdb        1.50GiB
>>>>      /dev/sdc        5.01GiB
>>>>      /dev/sdd        5.01GiB
>>>>      /dev/sdf        5.01GiB
>>>>      /dev/sdg        5.01GiB
>>>>
>>>> System,RAID6: Size:64.00MiB, Used:1.70MiB
>>>>      /dev/sda       16.00MiB
>>>>      /dev/sdb       16.00MiB
>>>>      /dev/sdc       16.00MiB
>>>>      /dev/sdd       16.00MiB
>>>>      /dev/sdf       16.00MiB
>>>>      /dev/sdg       16.00MiB
>>>>
>>>> Unallocated:
>>>>      /dev/sda      733.65GiB
>>>>      /dev/sdb        2.15TiB
>>>>      /dev/sdc        1.02MiB
>>>>      /dev/sdd        1.02MiB
>>>>      /dev/sdf        1.02MiB
>>>>      /dev/sdg        1.02MiB
>>>>
>>>>
>>>>
>>>>
>>>> Can anyone shed some light on why a full balance (sudo btrfs balance
>>>> start /mnt/data) doesnt seem to straighten this out? Any and all help
>>>> is appreciated.
>>>>
>>>>
>>>> Thanks!
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>
>
