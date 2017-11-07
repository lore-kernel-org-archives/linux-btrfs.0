Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:55694 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752580AbdKGFNz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 00:13:55 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 14721104CEB7
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Nov 2017 05:13:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Nov 2017 05:13:50 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 07 Nov 2017 14:13:49 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to run balance successfully (No space left on device)?
In-Reply-To: <c6c0eb84c550f44ffe443d625c198a39@wpkg.org>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
 <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
 <c6c0eb84c550f44ffe443d625c198a39@wpkg.org>
Message-ID: <64e4c4c4341f5880349a02cf57eb3ff7@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 23:18, Tomasz Chmielewski wrote:
> On 2017-09-18 17:20, Tomasz Chmielewski wrote:
>>>> # df -h /var/lib/lxd
>>>> 
>>>> FWIW, standard (aka util-linux) df is effectively useless in a 
>>>> situation
>>>> such as this, as it really doesn't give you the information you need 
>>>> (it
>>>> can say you have lots of space available, but if btrfs has all of it
>>>> allocated into chunks, even if the chunks have space in them still, 
>>>> there
>>>> can be problems).
>> 
>> I see here on RAID-1, "df -h" it shows pretty much the same amount of
>> free space as "btrfs fi show":
>> 
>> - "df -h" shows 105G free
>> - "btrfs fi show" says: Free (estimated):            104.28GiB
>> (min: 104.28GiB)
>> 
>> 
>> 
>>> But chances are pretty good that one you get that patch integrated,
>>> whether by integrating it yourself to what you have currently, or by
>>> trying 4.14-rc1 or waiting until it hits release or stable, that bug 
>>> will
>>> have been squashed! =:^)
>> 
>> OK, will wait for 4.14.
> 
> So I've tried to run balance with 4.14-rc6.

I've also tried with 4.14-rc7 on a server which was failing with "no 
space left" - unfortunately, it's still failing:


# time btrfs balance start /srv
WARNING:

         Full balance without filters requested. This operation is very
         intense and takes potentially very long. It is recommended to
         use the balance filters to narrow down the scope of balance.
         Use 'btrfs balance start --full-balance' option to skip this
         warning. The operation will start in 10 seconds.
         Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
ERROR: error during balancing '/srv': No space left on device
There may be more info in syslog - try dmesg | tail

real    8731m13.424s
user    0m0.000s
sys     560m36.363s



# dmesg -c
(...)
[546228.496902] BTRFS info (device sda4): relocating block group 
297455845376 flags data|raid1
[546251.393541] BTRFS info (device sda4): found 107799 extents
[546512.346360] BTRFS info (device sda4): found 107799 extents
[546529.407077] BTRFS info (device sda4): relocating block group 
296382103552 flags metadata|raid1
[546692.465746] BTRFS info (device sda4): found 35202 extents
[546733.294172] BTRFS info (device sda4): found 2586 extents
[546738.487556] BTRFS info (device sda4): relocating block group 
295308361728 flags data|raid1
[546770.474409] BTRFS info (device sda4): found 140906 extents
[547037.744023] BTRFS info (device sda4): found 140906 extents
[547065.840993] BTRFS info (device sda4): 117 enospc errors during 
balance


# btrfs fi df /srv
Data, RAID1: total=2.46TiB, used=2.35TiB
System, RAID1: total=32.00MiB, used=416.00KiB
Metadata, RAID1: total=19.00GiB, used=12.92GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


# btrfs fi show /srv
Label: 'btrfs'  uuid: 105b2e0c-8af2-45ee-b4c8-14ff0a3ca899
         Total devices 2 FS bytes used 2.36TiB
         devid    1 size 2.63TiB used 2.48TiB path /dev/sda4
         devid    2 size 2.63TiB used 2.48TiB path /dev/sdb4


# btrfs fi usage /srv
Overall:
     Device size:                   5.25TiB
     Device allocated:              4.96TiB
     Device unallocated:          302.00GiB
     Device missing:                  0.00B
     Used:                          4.72TiB
     Free (estimated):            268.66GiB      (min: 268.66GiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:2.46TiB, Used:2.35TiB
    /dev/sda4       2.46TiB
    /dev/sdb4       2.46TiB

Metadata,RAID1: Size:19.00GiB, Used:12.92GiB
    /dev/sda4      19.00GiB
    /dev/sdb4      19.00GiB

System,RAID1: Size:32.00MiB, Used:416.00KiB
    /dev/sda4      32.00MiB
    /dev/sdb4      32.00MiB

Unallocated:
    /dev/sda4     151.00GiB
    /dev/sdb4     151.00GiB


Tomasz Chmielewski
https://lxadm.com
