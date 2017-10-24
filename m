Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:52034 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbdJXAYO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 20:24:14 -0400
Received: from mail-yw0-f178.google.com ([209.85.161.178]) by
 mrelay.perfora.net (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id
 0M0SIl-1dCtfc1Iy5-00ubJH for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017
 02:24:13 +0200
Received: by mail-yw0-f178.google.com with SMTP id u142so10150596ywg.4
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 17:24:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
From: Zak Kohler <y2k@y2kbugger.com>
Date: Mon, 23 Oct 2017 20:23:41 -0400
Message-ID: <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All three devices completed the 'long' SMART selftest without error:

# 1  Extended offline    Completed without error       00%


Here is the standard data that I forgot to include in my first message:
Running Arch linux

$ uname -a
Linux HOSTNAME 4.9.56-1-lts #1 SMP Thu Oct 12 22:34:15 CEST 2017
x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.13

$ sudo btrfs fi show
Label: 'CRUCIAL116'  uuid: 31c38558-c8c7-49c4-8fea-9d0730ee58a7
        Total devices 1 FS bytes used 7.77GiB
        devid    1 size 59.62GiB used 59.62GiB path /dev/sda2

Label: 'OfflineJ'  uuid: 88406942-e3e1-42c6-ad71-e23bb315caa7
        Total devices 3 FS bytes used 1.98TiB
        devid    1 size 1.82TiB used 679.00GiB path /dev/sdi
        devid    2 size 1.82TiB used 679.01GiB path /dev/sdh
        devid    3 size 1.82TiB used 679.01GiB path /dev/sdn

$ sudo btrfs fi df /mnt
Data, RAID0: total=1.98TiB, used=1.98TiB
System, RAID1: total=8.00MiB, used=144.00KiB
Metadata, RAID1: total=3.00GiB, used=2.44GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

$ dmesg | grep BTRFS
[    5.262090] BTRFS: device label CRUCIAL116 devid 1 transid 98407 /dev/sda2
[   15.636475] BTRFS: device label OfflineJ devid 2 transid 612 /dev/sdh
[   15.646343] BTRFS: device label OfflineJ devid 1 transid 612 /dev/sdi
[   15.647194] BTRFS: device label OfflineJ devid 3 transid 612 /dev/sdn
[   15.754204] BTRFS info (device sda2): disk space caching is enabled
[   15.754206] BTRFS info (device sda2): has skinny extents
[   15.778659] BTRFS info (device sda2): detected SSD devices, enabling SSD mode
[   58.492530] BTRFS info (device sdn): disk space caching is enabled
[   58.492532] BTRFS info (device sdn): has skinny extents
[   61.243226] BTRFS info (device sdn): checking UUID tree
[  114.437424] BTRFS warning (device sdn): csum failed ino 6407 off
7683907584 csum 1745651892 expected csum 3952841867
[  114.450699] BTRFS warning (device sdn): csum failed ino 6407 off
7683907584 csum 1745651892 expected csum 3952841867
[38494.978379] BTRFS warning (device sdn): csum failed ino 4708 off
27529216 csum 876064455 expected csum 874979996
[38494.989301] BTRFS warning (device sdn): csum failed ino 4708 off
27529216 csum 2615801759 expected csum 874979996
[38541.079264] BTRFS warning (device sdn): csum failed ino 4708 off
27529216 csum 876064455 expected csum 874979996
[38571.245421] BTRFS warning (device sdn): csum failed ino 4708 off
27529216 csum 2615801759 expected csum 874979996
[39434.215600] BTRFS warning (device sdn): csum failed ino 4708 off
27529216 csum 2615801759 expected csum 874979996
[73132.653297] BTRFS warning (device sdn): csum failed ino 4708 off
27529216 csum 2615801759 expected csum 874979996
[73167.897106] BTRFS warning (device sdn): csum failed ino 4708 off
27529216 csum 2615801759 expected csum 874979996


One thing I notice is that ino 4708 keeps returns a few different
'wrong' csums, I can also
confirm that one of those 'csum failed' messages gets written each
time I run '$ sudo btrfs send /mnt/dataroot.2017.10.21/ | pv -i5 > /dev/null'

Does anyone know why scrub did not catch these errors that show up in dmesg?



On Mon, Oct 23, 2017 at 12:25 AM, Zak Kohler <y2k@y2kbugger.com> wrote:
> Was attempting my first btrfs send receive over ssh and continually
> received ioctl error at different points but always in the first 3
> minutes. The volume consists of three devices with only metadata
> duplication. I narrowed down the error to the send command by
> recreating the error while redirecting to /dev/null. Sometime it would
> happen after ~12Gib, or ~7.6Gib, right now rerunning multiple times it
> has stopped on exactly 3.76 multiple times.
>
> $ sudo btrfs send /mnt/dataroot.2017.10.21/ | pv -i5 > /dev/null
> At subvol /mnt/dataroot.2017.10.21/
> ERROR: send ioctl failed with -5: Input/output error                    ]
> 3.76GiB 0:00:13 [ 290MiB/s] [      <=>                                  ]
>
>
> First I checked the btrfs device stats, each of the 3 drives appear clean:
> $ sudo btrfs device stats /mnt
> [/dev/sdi].write_io_errs    0
> [/dev/sdi].read_io_errs     0
> [/dev/sdi].flush_io_errs    0
> [/dev/sdi].corruption_errs  0
> [/dev/sdi].generation_errs  0
> [/dev/sdh].write_io_errs    0
> [/dev/sdh].read_io_errs     0
> [/dev/sdh].flush_io_errs    0
> [/dev/sdh].corruption_errs  0
> [/dev/sdh].generation_errs  0
> [/dev/sdn].write_io_errs    0
> [/dev/sdn].read_io_errs     0
> [/dev/sdn].flush_io_errs    0
> [/dev/sdn].corruption_errs  0
> [/dev/sdn].generation_errs  0
>
> The next thing I tried was running and checking that SMART short
> selftest passed on each of three drives with no error.
> $ sudo smartctl -l selftest /dev/sdh
> # 1  Short offline       Completed without error
>
>
> I read somewhere to check dmesg, which yielded some info:
> BTRFS warning (device sdn): csum failed ino 6407 off 7683907584 csum
> 1745651892 expected csum 3952841867
>
> But when I when to see if scrub could detect the errors, nothing was found:
> $ sudo btrfs scrub status -d /mnt
> scrub status for 88406942-e3e1-42c6-ad71-e23bb315caa7
> scrub device /dev/sdi (id 1) history
>         scrub started at Sun Oct 22 14:43:20 2017 and finished after 01:57:00
>         total bytes scrubbed: 677.69GiB with 0 errors
> scrub device /dev/sdh (id 2) history
>         scrub started at Sun Oct 22 14:43:20 2017 and finished after 01:56:38
>         total bytes scrubbed: 677.44GiB with 0 errors
> scrub device /dev/sdn (id 3) history
>         scrub started at Sun Oct 22 14:43:20 2017 and finished after 01:56:38
>         total bytes scrubbed: 677.36GiB with 0 errors
>
>
> After all that scrubbing I still receive the ioctl error.
>
>
> Does anyone have any ideas of what to try next? Right now I am running
> the SMART 'long' self test.
