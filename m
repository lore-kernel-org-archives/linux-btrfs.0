Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33839 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbbG1WKH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 18:10:07 -0400
Received: by obre1 with SMTP id e1so95403515obr.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 15:10:07 -0700 (PDT)
MIME-Version: 1.0
From: Alejandro Recarey <alex@recarey.org>
Date: Wed, 29 Jul 2015 00:09:47 +0200
Message-ID: <CA+zbGr_adypZYbm7xcu1PZnLvuh1Nkba2VL-d-G2vFOde2hBQw@mail.gmail.com>
Subject: Error removing an HDD from a RAID1 BTRFS array
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I setup a btrfs filesystem on 3 disks with raid 1. Somehow, a small
portion (2GiB) got used as RAID0. At the time, no amount of running
balance -dconvert raid1 would change it so I left it as is.

Lately /dev/sda is starting to show SMART errors and general
issues. So I added 2 other disks to the btrfs array, and then proceded
to run `btrfs device delete`. All of the data was moved out of sda
*except* 1 GiB, and the delete fails with this message:

  > # ./btrfs device delete /dev/sda /storage
  ERROR: error removing the device '/dev/sda' - No space left on device

It seems there is a small part of sda that still has a raid0
partition, and that small part cannot be deleted. This is a completely
uninformed assumption! It's just that the 1 GiB space remaining on
disk seems suspicious.

I don't know what files are there, and at this point I really don't
care. I would like to nuke that 1 GiB partition so I can remove /dev/sda and
get my array working correctly.

I tried to run a `balance -dconvert` again, but the command starts
moving my data back *into* sda and I don't trust the disk to die on me
while writing that much data.

Any tips or suggestions are apreciated! Thank you,

Alex

----

My system information:

> # uname -a
Linux nerd-server 3.13.0-48-generic \
   #80-Ubuntu SMP Thu Mar 12 11:16:15 UTC \
   2015 x86_64 x86_64 x86_64 GNU/Linux


> # ./btrfs --version
btrfs-progs v4.1.2


> # ./btrfs fi show
Label: none  uuid: 5e63e5b5-48bb-442e-a79c-1c71a22de476
Total devices 5 FS bytes used 3.86TiB
devid    1 size 2.73TiB used 1.00GiB path /dev/sda
devid    2 size 2.73TiB used 1.97TiB path /dev/sdd
devid    3 size 2.73TiB used 1.81TiB path /dev/sdc
devid    4 size 2.73TiB used 1.97TiB path /dev/sde
devid    5 size 2.73TiB used 1.97TiB path /dev/sdf

btrfs-progs v4.1.2

root@nerd-server ~/src/btrfs-progs
> # ./btrfs fi df /storage
Data, RAID1: total=3.85TiB, used=3.85TiB
Data, RAID0: total=2.00GiB, used=1.54GiB
System, RAID1: total=32.00MiB, used=744.00KiB
Metadata, RAID1: total=6.00GiB, used=4.64GiB
