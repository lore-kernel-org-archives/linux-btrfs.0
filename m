Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34784 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbbGCGBt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 02:01:49 -0400
Received: by oigx81 with SMTP id x81so71604814oig.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2015 23:01:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKWZ-jTGkK7btiHziDf9LhW31QUSFbJ9DpLy1xqmk7vUCQ@mail.gmail.com>
References: <CAG+QAKX1eSmarBn+YXq5dkZ0zTWsSDM6cfwTtDg-43-nTRSXWQ@mail.gmail.com>
 <CAC=t97Dy57JMBZ-exzCytMMUUhrV_zh7W9L+fQR_G_LOqfhWhA@mail.gmail.com> <CAG+QAKWZ-jTGkK7btiHziDf9LhW31QUSFbJ9DpLy1xqmk7vUCQ@mail.gmail.com>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Fri, 3 Jul 2015 01:01:29 -0500
Message-ID: <CAC=t97Cq6+-KjphpNu2+34TeUXiyOjrui_hWYGGqe1EDVWjLUA@mail.gmail.com>
Subject: Re: btrfs full, but not full, can't rebalance
To: Rich Rauenzahn <rrauenza@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because this is raid1 I believe you need another for that to work.

On Fri, Jul 3, 2015 at 12:57 AM, Rich Rauenzahn <rrauenza@gmail.com> wrote:
> Yes, I tried that -- and adding the loopback device.
>
> # btrfs device add /dev/loop1 /
> Performing full device TRIM (5.00GiB) ...
>
> # btrfs fi show /
> Label: 'centos7'  uuid: 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
>         Total devices 3 FS bytes used 17.13GiB
>         devid    1 size 111.11GiB used 111.10GiB path /dev/sdf3
>         devid    2 size 111.11GiB used 111.10GiB path /dev/sdg3
>         devid    3 size 5.00GiB used 0.00 path /dev/loop1
>
> Btrfs v3.16.2
>
> # btrfs balance start -m /
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
>
> # btrfs balance start -v -dusage=1 /
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=1
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
>
>
>
> On Thu, Jul 2, 2015 at 10:45 PM, Donald Pearson
> <donaldwhpearson@gmail.com> wrote:
>> Have you seen this article?
>>
>> I think the interesting part for you is the "balance cannot run
>> because the filesystem is full" heading.
>>
>> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
>>
>> On Fri, Jul 3, 2015 at 12:32 AM, Rich Rauenzahn <rrauenza@gmail.com> wrote:
>>> Running on CentOS7 ... / got full, I removed the files, but it still
>>> thinks it is full.  I've tried following the FAQ, even adding a
>>> loopback device during the rebalance.
>>>
>>> # btrfs fi show /
>>> Label: 'centos7'  uuid: 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
>>>         Total devices 2 FS bytes used 24.27GiB
>>>         devid    1 size 111.11GiB used 111.05GiB path /dev/sdf3
>>>         devid    2 size 111.11GiB used 111.05GiB path /dev/sdg3
>>>
>>> # btrfs fi df /
>>> Data, RAID1: total=107.02GiB, used=22.12GiB
>>> System, RAID1: total=32.00MiB, used=16.00KiB
>>> Metadata, RAID1: total=4.05GiB, used=2.15GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00
>>>
>>> # btrfs balance start -v -dusage=1 /
>>> Dumping filters: flags 0x1, state 0x0, force is off
>>>   DATA (flags 0x2): balancing, usage=1
>>> ERROR: error during balancing '/' - No space left on device
>>> There may be more info in syslog - try dmesg | tail
>>>
>>> # btrfs balance start -m /
>>> ERROR: error during balancing '/' - No space left on device
>>> There may be more info in syslog - try dmesg | tail
>>>
>>> What can I do?
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
