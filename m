Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:33604 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbcGFJ4D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 05:56:03 -0400
Received: by mail-vk0-f45.google.com with SMTP id k68so210918452vkb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 02:56:02 -0700 (PDT)
MIME-Version: 1.0
From: Stanislaw Kaminski <stasheck.fora@gmail.com>
Date: Wed, 6 Jul 2016 11:55:42 +0200
Message-ID: <CALLEBqG65hkAd+KyoNZudCKv58OuBm3L5VOjWcvMQ5GfGNCngA@mail.gmail.com>
Subject: Out of space error even though there's 100 GB unused?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I am fighting with this since at least Monday - see
https://superuser.com/questions/1096658/btrfs-out-of-space-even-though-there-should-be-10-left

Here's the data:
#   uname -a
Linux archb3 4.6.3-2-ARCH #1 PREEMPT Wed Jun 29 07:15:33 MDT 2016
armv5tel GNU/Linux

#   btrfs --version
btrfs-progs v4.6

#   btrfs fi show
Label: 'home'  uuid: 1c7e35e8-f013-4f65-9d19-eaa168ac088b
        Total devices 1 FS bytes used 1.71TiB
        devid    1 size 1.81TiB used 1.71TiB path /dev/sda4

#   btrfs fi df /home
Data, single: total=1.71TiB, used=1.71TiB
System, DUP: total=32.00MiB, used=224.00KiB
Metadata, DUP: total=4.00GiB, used=2.07GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# btrfs f usage -T  /home
Overall:
    Device size:                   1.81TiB
    Device allocated:              1.71TiB
    Device unallocated:           97.89GiB
    Device missing:                  0.00B
    Used:                          1.71TiB
    Free (estimated):             98.22GiB      (min: 49.27GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

             Data    Metadata System
Id Path      single  DUP      DUP       Unallocated
-- --------- ------- -------- --------- -----------
 1 /dev/sda4 1.71TiB  8.00GiB  64.00MiB    97.89GiB
-- --------- ------- -------- --------- -----------
   Total     1.71TiB  4.00GiB  32.00MiB    97.89GiB
   Used      1.71TiB  2.07GiB 224.00KiB

# btrfs fi du -s /home
Total Exclusive Set shared Filename
1.60TiB 1.60TiB 0.00B /home

# btrfs f resize 1:+1G /home/
Resize '/home/' of '1:+1G'
ERROR: unable to resize '/home/': no enough free space

This all is after closely following:
https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_I_ran_out_of_disk_space.21
http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html

So, already did full volume rebalance, defrag, rebooted multiple times
- still, "Error: out of disk space".

To sum up:
- my files sum to 1.6 TiB
- disk usage is shown to be 1.71 TiB
- volume size is 1.81 TiB
- btrfs util shows I have ~98 GiB free space on the volume
- I am getting "out of space" message

Bonus:
- I removed 50 GB of data from the drive and I still get "out of
space" message after writing ~1 GB.

Help would be very appreciated.

Cheers,
Stan
