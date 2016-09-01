Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33641 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753563AbcIBPEl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2016 11:04:41 -0400
Received: by mail-oi0-f44.google.com with SMTP id c15so165216457oig.0
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 08:04:41 -0700 (PDT)
Subject: Re: your mail
To: Kyle Gates <kylegates@live.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
 <20160901074415.pz32d72d4h6pk77t@invalid>
 <31a75b1a-445a-47cd-816e-1e7e9d1c4bb8@gmail.com>
 <CY4PR06MB2726B15A26AA728457B155B9B0E20@CY4PR06MB2726.namprd06.prod.outlook.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <34ee2549-1cf4-cfb3-6818-a342aa9d27d2@gmail.com>
Date: Thu, 1 Sep 2016 13:06:14 -0400
MIME-Version: 1.0
In-Reply-To: <CY4PR06MB2726B15A26AA728457B155B9B0E20@CY4PR06MB2726.namprd06.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-01 12:44, Kyle Gates wrote:
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
>> owner@vger.kernel.org] On Behalf Of Austin S. Hemmelgarn
>> Sent: Thursday, September 01, 2016 6:18 AM
>> To: linux-btrfs@vger.kernel.org
>> Subject: Re: your mail
>>
>> On 2016-09-01 03:44, M G Berberich wrote:
>>> Am Mittwoch, den 31. August schrieb Fennec Fox:
>>>> Linux Titanium 4.7.2-1-MANJARO #1 SMP PREEMPT Sun Aug 21 15:04:37
>> UTC
>>>> 2016 x86_64 GNU/Linux
>>>> btrfs-progs v4.7
>>>>
>>>> Data, single: total=30.01GiB, used=18.95GiB System, single:
>>>> total=4.00MiB, used=16.00KiB Metadata, single: total=1.01GiB,
>>>> used=422.17MiB GlobalReserve, single: total=144.00MiB, used=0.00B
>>>>
>>>> {02:50} Wed Aug 31
>>>> [fennectech@Titanium ~]$  sudo fstrim -v / [sudo] password for
>>>> fennectech:
>>>> Sorry, try again.
>>>> [sudo] password for fennectech:
>>>> /: 99.8 GiB (107167244288 bytes) trimmed
>>>>
>>>> {03:08} Wed Aug 31
>>>> [fennectech@Titanium ~]$  sudo fstrim -v / [sudo] password for
>>>> fennectech:
>>>> /: 99.9 GiB (107262181376 bytes) trimmed
>>>>
>>>>   I ran these commands minutes after echother ane each time it is
>>>> trimming the entire free space
>>>>
>>>> Anyone else seen this?   the filesystem is the root FS and is compressed
>>>
>>> You should be very happy that it is trimming at all. Typical situation
>>> on a used btrfs is
>>>
>>>   # fstrim -v /
>>>   /: 0 B (0 bytes) trimmed
>>>
>>> even if there is 33G unused space ob the fs:
>>>
>>>   # df -h /
>>>   Filesystem      Size  Used Avail Use% Mounted on
>>>   /dev/sda2        96G   61G   33G  66% /
>>>
>> I think you're using an old kernel, this has been working since at least 4.5, but
>> was broken in some older releases.
>
> M G is running 4.7.2
> The problem is that all space has been allocated by block groups and fstrim will only work on unallocated space.
Yep, that would do so also, and this behavior really could be much 
better documented.
