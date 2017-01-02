Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33512 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755536AbdABVG7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jan 2017 16:06:59 -0500
Received: by mail-yw0-f195.google.com with SMTP id s68so36586097ywg.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jan 2017 13:06:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQU4+JJQH_mS=9qc1mrwVAALdBbYFg7Edcy1gL118YERg@mail.gmail.com>
References: <d538b76e-ecdc-19bb-2395-281a5c7c44e5@gmail.com>
 <08b63d21-820e-6e69-bb5f-c9f94d8fc8ac@suse.com> <CAJCQCtQU4+JJQH_mS=9qc1mrwVAALdBbYFg7Edcy1gL118YERg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 2 Jan 2017 14:06:58 -0700
Message-ID: <CAJCQCtQ+ftYY+QgmkP0xkz+1=qANqf+5biMnHa2g0TMbSE+LDA@mail.gmail.com>
Subject: Re: Will fstrim discard unused parts of chunks?
To: Chris Murphy <lists@colorremedies.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 2, 2017 at 2:05 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Jan 2, 2017 at 2:02 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 1/2/17 4:55 AM, Andrei Borzenkov wrote:
>>> I try to understand what exactly is trimmed in case of btrfs. Using
>>> installation in QEMU I see that host file size is about 9GB, allocated
>>> size in guest approximately matches it and used space in guest is 7.6GB.
>>> After some experimenting it looks like host size follows "Device
>>> allocated" value in "btrfs filesystem usage" which leads me to believe
>>> trim only considers space outside of allocated chunks. Is it correct?
>>
>> It should consider all available space.  The code iterates over all
>> block groups and trims free space and then iterates over free dev
>> extents, which is all of the unallocated space.
>>
>> Which kernel version are you using?  This stuff was broken for a while
>> but was fixed in 4.3.
>
> Appears for some time now, since I think 4.6 or 4.7, to only trim
> unallocated space.
>
> [chris@f25h ~]$ sudo btrfs fi us /
> Overall:
>     Device size:          73.83GiB
>     Device allocated:          25.03GiB
>     Device unallocated:          48.80GiB
>     Device missing:             0.00B
>     Used:              21.29GiB
>     Free (estimated):          52.21GiB    (min: 52.21GiB)
>     Data ratio:                  1.00
>     Metadata ratio:              1.00
>     Global reserve:          71.16MiB    (used: 0.00B)
>
> Data,single: Size:24.00GiB, Used:20.59GiB
>    /dev/nvme0n1p4      20.00GiB
>    /dev/nvme0n1p6       4.00GiB
>
> Metadata,single: Size:1.00GiB, Used:722.42MiB
>    /dev/nvme0n1p4       1.00GiB
>
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/nvme0n1p4      32.00MiB
>
> Unallocated:
>    /dev/nvme0n1p4       3.97GiB
>    /dev/nvme0n1p6      44.83GiB
> [chris@f25h ~]$ sudo fstrim -v /
> [sudo] password for chris:
> /: 48.8 GiB (52393148416 bytes) trimmed
> [chris@f25h ~]$
>
>
> Otherwise, it should have trimmed ~52GiB.

This was done with 4.8.15-300.fc25.x86_64


-- 
Chris Murphy
