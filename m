Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36218 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbcCCA2h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 19:28:37 -0500
Received: by mail-io0-f182.google.com with SMTP id l127so10575656iof.3
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Mar 2016 16:28:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160227211450.GS26042@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
Date: Thu, 3 Mar 2016 02:28:36 +0200
Message-ID: <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-02-27 23:14 GMT+02:00 Marc Haber <mh+linux-btrfs@zugschlus.de>:
> Hi,
>
> I have again the issue of no space left on device while rebalancing
> (with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):
>

I've same issue, 4.4.3 kernel on Arch Linux

$ sudo btrfs fi show /mnt/fs/
Label: 'fs'  uuid: a3c66d25-2c25-40e5-a827-5f7e5208e235
        Total devices 1 FS bytes used 396.94GiB
        devid    1 size 435.76GiB used 435.76GiB path /dev/sdi2

$ sudo btrfs fi df /mnt/fs/
Data, single: total=416.70GiB, used=390.62GiB
System, DUP: total=32.00MiB, used=96.00KiB
Metadata, DUP: total=9.50GiB, used=6.32GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

$ sudo btrfs fi usage /mnt/fs/
Overall:
    Device size:                 435.76GiB
    Device allocated:            435.76GiB
    Device unallocated:            1.00MiB
    Device missing:                  0.00B
    Used:                        403.26GiB
    Free (estimated):             26.07GiB      (min: 26.07GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:416.70GiB, Used:390.62GiB
   /dev/sdi2     416.70GiB

Metadata,DUP: Size:9.50GiB, Used:6.32GiB
   /dev/sdi2      19.00GiB

System,DUP: Size:32.00MiB, Used:96.00KiB
   /dev/sdi2      64.00MiB

Unallocated:
   /dev/sdi2       1.00MiB


$ sudo btrfs balance start -v /mnt/fs/
Dumping filters: flags 0x7, state 0x0, force is off
  DATA (flags 0x0): balancing
  METADATA (flags 0x0): balancing
  SYSTEM (flags 0x0): balancing
ERROR: error during balancing '/mnt/fs/': No space left on device
There may be more info in syslog - try dmesg | tail

$ sudo btrfs balance start -dusage=34 /mnt/fs/
Done, had to relocate 0 out of 438 chunks
$ sudo btrfs balance start -dusage=35 /mnt/fs/
ERROR: error during balancing '/mnt/fs/': No space left on device


$ sudo btrfs balance start -musage=0 /mnt/fs/
Done, had to relocate 0 out of 438 chunks
$ sudo btrfs balance start -musage=1 /mnt/fs/
ERROR: error during balancing '/mnt/fs/': No space left on device


$ sudo btrfs balance start -dprofiles=single /mnt/fs
ERROR: error during balancing '/mnt/fs': No space left on device

$ sudo btrfs balance start -mprofiles=dup /mnt/fs
Done, had to relocate 20 out of 438 chunks

$ sudo btrfs balance start -sprofiles=dup --force /mnt/fs
Done, had to relocate 1 out of 433 chunks


$ sudo btrfs fi df /mnt/fs/
Data, single: total=416.70GiB, used=390.62GiB
System, DUP: total=32.00MiB, used=96.00KiB
Metadata, DUP: total=7.00GiB, used=6.31GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

$  sudo btrfs fi usage /mnt/fs/
Overall:
    Device size:                 435.76GiB
    Device allocated:            430.76GiB
    Device unallocated:            5.00GiB
    Device missing:                  0.00B
    Used:                        403.25GiB
    Free (estimated):             31.07GiB      (min: 28.57GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:416.70GiB, Used:390.62GiB
   /dev/sdi2     416.70GiB

Metadata,DUP: Size:7.00GiB, Used:6.31GiB
   /dev/sdi2      14.00GiB

System,DUP: Size:32.00MiB, Used:96.00KiB
   /dev/sdi2      64.00MiB

Unallocated:
   /dev/sdi2       5.00GiB

now balance works

$ sudo btrfs balance start -m /mnt/fs/
Done, had to relocate 15 out of 433 chunks

$ sudo btrfs balance start /mnt/fs/

it's still going but most likley it will finish

$ sudo btrfs balance status /mnt/fs/
Balance on '/mnt/fs/' is running
26 out of about 431 chunks balanced (27 considered),  94% left
