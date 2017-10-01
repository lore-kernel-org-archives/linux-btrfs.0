Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:51805 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdJAHtB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Oct 2017 03:49:01 -0400
Received: by mail-wm0-f44.google.com with SMTP id i131so5430248wma.0
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Oct 2017 00:49:00 -0700 (PDT)
MIME-Version: 1.0
From: Adam Bahe <adambahe@gmail.com>
Date: Sun, 1 Oct 2017 02:48:19 -0500
Message-ID: <CACzgC9iBu13Ziiji134MDwxLcdCNqth-EJ=pSjfKpmzg22G_yg@mail.gmail.com>
Subject: Cannot remove device, no space left on device
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a hard drive that is about a year old with some pending sectors
on it. I'd like to RMA this drive out of an abundance of caution.
Doing so requires me removing it from my raid10 array. However I am
unable to do so as it eventually errors out by saying there is no
space left on the device. I have 21 drives in a raid10 array.
Totalling about 100TB raw. I'm using around 28TB. So I should have
plenty of space left.

I have done a number of balances with incremental increases in dusage
and musage values from 5-100%. Each balance completed successfully. So
it looks as though my filesystem is balanced fine. I'm on kernel 4.10

I also tried adding more space. I threw in another 4TB hard drive and
it added mostly fine. It took 3-4 tries at a balance before it was
fully balanced into the array. The same no space left on device error
occurred when adding the drive. But it did eventually add.

But I still can't seem to remove the hard drive I want to RMA. Here
are some statistics. Let me know if there is any more info I can
provide. But I really need to get this drive removed as my RMA window
is only open for 30 days once I submit.

/dev/sdo is the drive I would like to remove, why am I unable to do so?

btrfs fi show:

Label: 'nas'  uuid: 4fcd5725-b6c6-4d8a-9860-f2fc5474cbcb
    Total devices 20 FS bytes used 24.12TiB
    devid    1 size 3.64TiB used 2.86TiB path /dev/sdm
    devid    2 size 3.64TiB used 2.86TiB path /dev/sde
    devid    3 size 7.28TiB used 3.02TiB path /dev/sdt
    devid    4 size 7.28TiB used 2.08TiB path /dev/sdo
    devid    5 size 7.28TiB used 3.02TiB path /dev/sdi
    devid    6 size 7.28TiB used 3.02TiB path /dev/sdd
    devid    7 size 1.82TiB used 1.82TiB path /dev/sdp
    devid    9 size 1.82TiB used 1.82TiB path /dev/sdv
    devid   10 size 1.82TiB used 1.82TiB path /dev/sdk
    devid   11 size 1.82TiB used 1.82TiB path /dev/sdq
    devid   12 size 1.82TiB used 1.82TiB path /dev/sdg
    devid   13 size 1.82TiB used 1.82TiB path /dev/sdl
    devid   14 size 1.82TiB used 1.82TiB path /dev/sdr
    devid   15 size 1.82TiB used 1.82TiB path /dev/sdf
    devid   16 size 5.46TiB used 3.02TiB path /dev/sds
    devid   17 size 9.10TiB used 3.02TiB path /dev/sdn
    devid   18 size 9.10TiB used 3.02TiB path /dev/sdh
    devid   19 size 9.10TiB used 3.02TiB path /dev/sdc
    devid   20 size 9.10TiB used 3.02TiB path /dev/sdu
    devid   21 size 3.64TiB used 1.76TiB path /dev/sdj

btrfs fi df

[root@nas ~]# btrfs fi df /mnt2/nas
Data, RAID10: total=24.13TiB, used=24.10TiB
System, RAID10: total=30.19MiB, used=5.39MiB
Metadata, RAID10: total=25.51GiB, used=24.98GiB

GlobalReserve, single: total=512.00MiB, used=0.00B
Overall:
Device size:                  96.42TiB
Device allocated:             48.31TiB
Device unallocated:           48.11TiB
Device missing:                  0.00B
Used:                         48.24TiB
Free (estimated):             24.09TiB      (min: 24.09TiB)
Data ratio:                       2.00
Metadata ratio:                   2.00
Global reserve:              512.00MiB      (used: 0.00B)

btrfs fi usage

Data,RAID10: Size:24.13TiB, Used:24.10TiB
/dev/sdc        1.51TiB
/dev/sdd        1.51TiB
/dev/sde        1.43TiB
/dev/sdf      930.43GiB
/dev/sdg      930.59GiB
/dev/sdh        1.51TiB
/dev/sdi        1.51TiB
/dev/sdj      900.48GiB
/dev/sdk      930.17GiB
/dev/sdl      930.42GiB
/dev/sdm        1.43TiB
/dev/sdn        1.51TiB
/dev/sdo        1.04TiB
/dev/sdp      929.93GiB
/dev/sdq      930.42GiB
/dev/sdr      930.04GiB
/dev/sds        1.51TiB
/dev/sdt        1.51TiB
/dev/sdu        1.51TiB
/dev/sdv      930.48GiB

Metadata,RAID10: Size:25.51GiB, Used:24.98GiB
/dev/sdc        1.49GiB
/dev/sdd        1.49GiB
/dev/sde        1.49GiB
/dev/sdf        1.04GiB
/dev/sdg      903.66MiB
/dev/sdh        1.49GiB
/dev/sdi        1.49GiB
/dev/sdj        1.49GiB
/dev/sdk        1.27GiB
/dev/sdl        1.01GiB
/dev/sdm        1.49GiB
/dev/sdn        1.49GiB
/dev/sdp        1.49GiB
/dev/sdq        1.04GiB
/dev/sdr        1.37GiB
/dev/sds        1.49GiB
/dev/sdt        1.49GiB
/dev/sdu        1.49GiB
/dev/sdv     1005.44MiB

System,RAID10: Size:30.19MiB, Used:5.39MiB
/dev/sdc        2.16MiB
/dev/sdd        2.16MiB
/dev/sde        2.16MiB
/dev/sdh        2.16MiB
/dev/sdi        2.16MiB
/dev/sdj        2.16MiB
/dev/sdk        2.16MiB
/dev/sdm        2.16MiB
/dev/sdn        2.16MiB
/dev/sdp        2.16MiB
/dev/sdr        2.16MiB
/dev/sds        2.16MiB
/dev/sdt        2.16MiB
/dev/sdu        2.16MiB

Unallocated:
/dev/sdc        7.58TiB
/dev/sdd        5.76TiB
/dev/sde        2.21TiB
/dev/sdf      931.55GiB
/dev/sdg      931.54GiB
/dev/sdh        7.58TiB
/dev/sdi        5.76TiB
/dev/sdj        2.76TiB
/dev/sdk      931.57GiB
/dev/sdl      931.58GiB
/dev/sdm        2.21TiB
/dev/sdn        7.58TiB
/dev/sdo        6.24TiB
/dev/sdp      931.59GiB
/dev/sdq      931.55GiB
/dev/sdr      931.61GiB
/dev/sds        3.95TiB
/dev/sdt        5.76TiB
/dev/sdu        7.58TiB
/dev/sdv      931.56GiB

btrfs device usage:

/dev/sdc, ID: 19
Device size:             9.10TiB
Device slack:              0.00B
Data,RAID10:           463.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             7.58TiB

/dev/sdd, ID: 6
Device size:             7.28TiB
Device slack:              0.00B
Data,RAID10:           463.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB

Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             5.76TiB

/dev/sde, ID: 2
Device size:             3.64TiB
Device slack:              0.00B
Data,RAID10:           377.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             2.21TiB

/dev/sdf, ID: 15
Device size:             1.82TiB
Device slack:              0.00B
Data,RAID10:            58.65GiB
Data,RAID10:            94.54GiB
Data,RAID10:            66.50MiB
Data,RAID10:           435.28MiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.01GiB
Metadata,RAID10:         9.53MiB
Metadata,RAID10:        13.25MiB
Unallocated:           931.55GiB

/dev/sdg, ID: 12
Device size:             1.82TiB
Device slack:              0.00B
Data,RAID10:            58.86GiB
Data,RAID10:            91.51GiB
Data,RAID10:             1.51GiB
Data,RAID10:             1.96GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:       903.66MiB
Unallocated:           931.54GiB

/dev/sdh, ID: 18
Device size:             9.10TiB
Device slack:              0.00B
Data,RAID10:           463.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             7.58TiB

/dev/sdi, ID: 5
Device size:             7.28TiB
Device slack:              0.00B
Data,RAID10:           463.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             5.76TiB

/dev/sdj, ID: 21
Device size:             3.64TiB
Device slack:              0.00B
Data,RAID10:           776.75GiB
Data,RAID10:             7.78GiB
Data,RAID10:           113.69GiB
Data,RAID10:           968.53MiB
Data,RAID10:             1.31GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             2.76TiB

/dev/sdk, ID: 10
Device size:             1.82TiB
Device slack:              0.00B
Data,RAID10:            60.78GiB
Data,RAID10:            85.38GiB
Data,RAID10:             6.86GiB
Data,RAID10:           403.94MiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.02GiB
Metadata,RAID10:        93.38MiB
Metadata,RAID10:       159.28MiB
System,RAID10:           2.16MiB
Unallocated:           931.57GiB

/dev/sdl, ID: 13
Device size:             1.82TiB
Device slack:              0.00B
Data,RAID10:            60.62GiB
Data,RAID10:            84.35GiB
Data,RAID10:             1.00GiB
Data,RAID10:             7.69GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:       981.81MiB
Metadata,RAID10:        43.81MiB
Metadata,RAID10:        13.34MiB
Unallocated:           931.58GiB

/dev/sdm, ID: 1
Device size:             3.64TiB
Device slack:              0.00B
Data,RAID10:           377.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             2.21TiB

/dev/sdn, ID: 17
Device size:             9.10TiB
Device slack:              0.00B
Data,RAID10:           463.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             7.58TiB

/dev/sdo, ID: 4
Device size:             7.28TiB
Device slack:              0.00B
Data,RAID10:           172.00GiB
Data,RAID10:           776.75GiB
Data,RAID10:             3.50GiB
Data,RAID10:           111.92GiB
Data,RAID10:            76.09MiB
Unallocated:             6.24TiB

/dev/sdp, ID: 7
Device size:             1.82TiB
Device slack:              0.00B
Data,RAID10:            61.26GiB
Data,RAID10:            86.17GiB
Data,RAID10:             4.39GiB
Data,RAID10:             1.35GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:           931.59GiB

/dev/sdq, ID: 11
Device size:             1.82TiB
Device slack:              0.00B
Data,RAID10:            59.46GiB
Data,RAID10:            86.19GiB
Data,RAID10:             1.76GiB
Data,RAID10:             6.25GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:      1010.69MiB
Metadata,RAID10:        55.19MiB
Unallocated:           931.55GiB

/dev/sdr, ID: 14
Device size:             1.82TiB
Device slack:              0.00B
Data,RAID10:            60.35GiB
Data,RAID10:            82.68GiB
Data,RAID10:             2.27GiB
Data,RAID10:             7.98GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.08GiB
Metadata,RAID10:        91.38MiB
Metadata,RAID10:       202.22MiB
System,RAID10:           2.16MiB
Unallocated:           931.61GiB

/dev/sds, ID: 16
Device size:             5.46TiB
Device slack:              0.00B
Data,RAID10:           463.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             3.95TiB

/dev/sdt, ID: 3
Device size:             7.28TiB
Device slack:              0.00B
Data,RAID10:           463.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             5.76TiB

/dev/sdu, ID: 20
Device size:             9.10TiB
Device slack:              0.00B
Data,RAID10:           463.85GiB
Data,RAID10:            61.43GiB
Data,RAID10:           115.98GiB
Data,RAID10:           118.31GiB
Data,RAID10:            10.93GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:         1.13GiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:       211.75MiB
Metadata,RAID10:        59.09MiB
System,RAID10:           2.16MiB
Unallocated:             7.58TiB

/dev/sdv, ID: 9
Device size:             1.82TiB
Device slack:              0.00B
Data,RAID10:            60.19GiB
Data,RAID10:            84.01GiB
Data,RAID10:             2.65GiB
Data,RAID10:             6.87GiB
Data,RAID10:           776.75GiB
Metadata,RAID10:       867.31MiB
Metadata,RAID10:        99.00MiB
Metadata,RAID10:        39.12MiB
Unallocated:           931.56GiB
