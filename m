Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:36804 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751181AbdKZQCz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Nov 2017 11:02:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 27 Nov 2017 01:02:53 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Martin Raiber <martin@urbackup.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: again "out of space" and remount read only, with 4.14
In-Reply-To: <0102015ff8f9e46f-83a96bab-ee99-4ec2-b09f-7801b64fc2d5-000000@eu-west-1.amazonses.com>
References: <dfdbf8227acb0f10ed14edb0a8638ce0@virtall.com>
 <0102015ff8f9e46f-83a96bab-ee99-4ec2-b09f-7801b64fc2d5-000000@eu-west-1.amazonses.com>
Message-ID: <ddbe76a2ddcf5d7d7b18f3c7f09294bd@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-27 00:37, Martin Raiber wrote:
> On 26.11.2017 08:46 Tomasz Chmielewski wrote:
>> Got this one on a 4.14-rc7 filesystem with some 400 GB left:
> 
> Hi,
> 
> I guess it is too late now, but I guess the "btrfs fi usage" output of
> the file system (especially after it went ro) would be useful.

It was more or less similar as it went ro:


# btrfs fi df /srv
Data, RAID1: total=2.21TiB, used=2.15TiB
System, RAID1: total=32.00MiB, used=352.00KiB
Metadata, RAID1: total=16.00GiB, used=13.09GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


# btrfs fi show /srv
Label: 'btrfs'  uuid: 105b2e0c-8af2-45ee-b4c8-14ff0a3ca899
         Total devices 2 FS bytes used 2.16TiB
         devid    1 size 2.63TiB used 2.22TiB path /dev/sda4
         devid    2 size 2.63TiB used 2.22TiB path /dev/sdb4


# btrfs fi usage /srv
Overall:
     Device size:                   5.25TiB
     Device allocated:              4.45TiB
     Device unallocated:          823.97GiB
     Device missing:                  0.00B
     Used:                          4.33TiB
     Free (estimated):            471.91GiB      (min: 471.91GiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:2.21TiB, Used:2.15TiB
    /dev/sda4       2.21TiB
    /dev/sdb4       2.21TiB

Metadata,RAID1: Size:16.00GiB, Used:13.09GiB
    /dev/sda4      16.00GiB
    /dev/sdb4      16.00GiB

System,RAID1: Size:32.00MiB, Used:352.00KiB
    /dev/sda4      32.00MiB
    /dev/sdb4      32.00MiB

Unallocated:
    /dev/sda4     411.99GiB
    /dev/sdb4     411.99GiB



Tomasz Chmielewski
https://lxadm.com
