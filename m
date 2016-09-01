Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s32.hotmail.com ([65.55.116.43]:58142 "EHLO
        BLU004-OMC1S32.hotmail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753230AbcIAU5d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 16:57:33 -0400
From: Kyle Gates <kylegates@live.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: your mail
Date: Thu, 1 Sep 2016 16:44:36 +0000
Message-ID: <CY4PR06MB2726B15A26AA728457B155B9B0E20@CY4PR06MB2726.namprd06.prod.outlook.com>
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
 <20160901074415.pz32d72d4h6pk77t@invalid>,<31a75b1a-445a-47cd-816e-1e7e9d1c4bb8@gmail.com>
In-Reply-To: <31a75b1a-445a-47cd-816e-1e7e9d1c4bb8@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Austin S. Hemmelgarn
> Sent: Thursday, September 01, 2016 6:18 AM
> To: linux-btrfs@vger.kernel.org
> Subject: Re: your mail
> 
> On 2016-09-01 03:44, M G Berberich wrote:
> > Am Mittwoch, den 31. August schrieb Fennec Fox:
> >> Linux Titanium 4.7.2-1-MANJARO #1 SMP PREEMPT Sun Aug 21 15:04:37
> UTC
> >> 2016 x86_64 GNU/Linux
> >> btrfs-progs v4.7
> >>
> >> Data, single: total=30.01GiB, used=18.95GiB System, single:
> >> total=4.00MiB, used=16.00KiB Metadata, single: total=1.01GiB,
> >> used=422.17MiB GlobalReserve, single: total=144.00MiB, used=0.00B
> >>
> >> {02:50} Wed Aug 31
> >> [fennectech@Titanium ~]$  sudo fstrim -v / [sudo] password for
> >> fennectech:
> >> Sorry, try again.
> >> [sudo] password for fennectech:
> >> /: 99.8 GiB (107167244288 bytes) trimmed
> >>
> >> {03:08} Wed Aug 31
> >> [fennectech@Titanium ~]$  sudo fstrim -v / [sudo] password for
> >> fennectech:
> >> /: 99.9 GiB (107262181376 bytes) trimmed
> >>
> >>   I ran these commands minutes after echother ane each time it is
> >> trimming the entire free space
> >>
> >> Anyone else seen this?   the filesystem is the root FS and is compressed
> >
> > You should be very happy that it is trimming at all. Typical situation
> > on a used btrfs is
> >
> >   # fstrim -v /
> >   /: 0 B (0 bytes) trimmed
> >
> > even if there is 33G unused space ob the fs:
> >
> >   # df -h /
> >   Filesystem      Size  Used Avail Use% Mounted on
> >   /dev/sda2        96G   61G   33G  66% /
> >
> I think you're using an old kernel, this has been working since at least 4.5, but
> was broken in some older releases.

M G is running 4.7.2
The problem is that all space has been allocated by block groups and fstrim will only work on unallocated space.

On my system all space has been allocated on my root filesystem so 0 B are trimmed:
kyle@home:~$  uname -a
Linux home 4.7.2-040702-generic #201608201334 SMP Sat Aug 20 17:37:03 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
kyle@home:~$  sudo btrfs fi show /
Label: 'root'  uuid: 6af4ebde-81ef-428a-a45f-0e8480ad969a
        Total devices 2 FS bytes used 13.44GiB
        devid   14 size 20.00GiB used 20.00GiB path /dev/sde2
        devid   15 size 20.00GiB used 20.00GiB path /dev/sdb2
kyle@home:~$  btrfs fi df /
Data, RAID1: total=18.97GiB, used=12.98GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=1.00GiB, used=473.83MiB
GlobalReserve, single: total=160.00MiB, used=0.00B
kyle@home:~$  sudo fstrim -v /
[sudo] password for kyle:
/: 0 B (0 bytes) trimmed

But I do have space trimmed on my home filesystem:
kyle@home:~$  sudo btrfs fi show /home/
Label: 'home'  uuid: b75fb450-4a28-434a-a483-e784940d463a
        Total devices 2 FS bytes used 18.63GiB
        devid   11 size 64.00GiB used 29.03GiB path /dev/sde3
        devid   12 size 64.00GiB used 29.03GiB path /dev/sdb3
kyle@home:~$  btrfs fi df /home/
Data, RAID1: total=27.00GiB, used=18.46GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=2.00GiB, used=168.62MiB
GlobalReserve, single: total=64.00MiB, used=0.00B
kyle@home:~$  sudo fstrim -v /home
/home: 70 GiB (75092721664 bytes) trimmed
