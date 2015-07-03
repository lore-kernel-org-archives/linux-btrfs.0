Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36675 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbbGCH43 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 03:56:29 -0400
Received: by obdbs4 with SMTP id bs4so65051765obd.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2015 00:56:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKWZ-jTGkK7btiHziDf9LhW31QUSFbJ9DpLy1xqmk7vUCQ@mail.gmail.com>
References: <CAG+QAKX1eSmarBn+YXq5dkZ0zTWsSDM6cfwTtDg-43-nTRSXWQ@mail.gmail.com>
	<CAC=t97Dy57JMBZ-exzCytMMUUhrV_zh7W9L+fQR_G_LOqfhWhA@mail.gmail.com>
	<CAG+QAKWZ-jTGkK7btiHziDf9LhW31QUSFbJ9DpLy1xqmk7vUCQ@mail.gmail.com>
Date: Fri, 3 Jul 2015 00:56:28 -0700
Message-ID: <CAG+QAKW1ZH_6AN3CSmXxiQr9xmR_ha=erfruSHxvKYKH6w3WiA@mail.gmail.com>
Subject: Re: btrfs full, but not full, can't rebalance
From: Rich Rauenzahn <rrauenza@gmail.com>
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Donald and I went offline so I will summarize where I am now:

(1) Since I'm RAID1, I had to add two loopbacks.   That makes sense!
(2) The two 5GB loopbacks filled up almost instantly and did me no good.
(3) I created two more 100 GB loopbacks (hint: use /usr/bin/truncate
not /usr/bin/dd to create the empty files!)

I then was able to make some progress with balancing with -dusage=1.
I went to -dusage=2 and it failed with enospc again.  A little while
later -dusage=2 worked.  I believe I made it up to -dusage=5 and then
higher values failed.

At this point I saw that my 'btrfs fi show' showed that I had some
headroom, so I dropped all of the loopbacks from my volume.

But I found that I still could not "touch /tmp/foo".

I then just tried running btrfs balance start.  I noticed in dmesg
that although btrfs balance was exiting with an error about space, it
was making progress on some extents.  btrfs fi show also reflected
that.   So I began a loop...

while ! btrfs balance start /; do btrfs fi show /; btrfs fi df / ; done

It is still running, but after a few iterations I am now able to touch
a file /tmp/foo successfully and the fi show seems to still be coming
down to a proper value, although occasionally it bumps up the wrong
direction:

]# while ! btrfs balance start /; do btrfs fi show /; btrfs fi df / ; done
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
Label: 'centos7'  uuid: 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
        Total devices 2 FS bytes used 17.25GiB
        devid    1 size 111.11GiB used 84.03GiB path /dev/sdf3
        devid    2 size 111.11GiB used 84.03GiB path /dev/sdg3

Btrfs v3.16.2
Data, RAID1: total=41.00GiB, used=16.54GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=43.00GiB, used=724.38MiB
GlobalReserve, single: total=256.00MiB, used=336.00KiB
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
Label: 'centos7'  uuid: 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
        Total devices 2 FS bytes used 17.25GiB
        devid    1 size 111.11GiB used 85.03GiB path /dev/sdf3
        devid    2 size 111.11GiB used 85.03GiB path /dev/sdg3

Btrfs v3.16.2
Data, RAID1: total=40.00GiB, used=16.54GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=45.00GiB, used=724.30MiB
GlobalReserve, single: total=256.00MiB, used=256.00KiB
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
Label: 'centos7'  uuid: 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
        Total devices 2 FS bytes used 17.25GiB
        devid    1 size 111.11GiB used 86.03GiB path /dev/sdf3
        devid    2 size 111.11GiB used 86.03GiB path /dev/sdg3

Btrfs v3.16.2
Data, RAID1: total=39.00GiB, used=16.54GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=47.00GiB, used=723.78MiB
GlobalReserve, single: total=256.00MiB, used=272.00KiB

Many thanks to Donald for getting me to this point!

On Thu, Jul 2, 2015 at 10:57 PM, Rich Rauenzahn <rrauenza@gmail.com> wrote:
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
