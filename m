Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:37390 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbdI2UAb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 16:00:31 -0400
Received: by mail-qk0-f196.google.com with SMTP id z143so426807qkb.4
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 13:00:31 -0700 (PDT)
MIME-Version: 1.0
From: Dirk Diggler <docmax1978@gmail.com>
Date: Fri, 29 Sep 2017 22:00:28 +0200
Message-ID: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
Subject: Can't remove device -> I/O error
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

is there any chance to get my device removed?
Scrub literally takes months to complete (SATA 2/3 mix, about 1 minute
per gigabyte) and i'm not sure if that helps.
I guess same with balance. Mabye there is a quicker way. I can do
without some data if it's corrupted. I have a backup, but i want to
avoid to copy all data from scratch!

Whenever i try to remove dev 6, i get:

console:
ERROR: error removing device '/dev/sdj': Input/output error

dmesg (i/o error right after this):
BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
csum 0x98f94189 expected csum 0x585e5744 mirror 1
BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675119616
csum 0x98f94189 expected csum 0xcefd2ae0 mirror 1
BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
csum 0x98f94189 expected csum 0x585e5744 mirror 1
BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675119616
csum 0x98f94189 expected csum 0xcefd2ae0 mirror 1
BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
csum 0x4023cac1 expected csum 0x585e5744 mirror 2
BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675119616
csum 0xea91b663 expected csum 0xcefd2ae0 mirror 2
BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
csum 0x98f94189 expected csum 0x585e5744 mirror 1
BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
csum 0x4023cac1 expected csum 0x585e5744 mirror 2

My setup:
/dev/sdf, ID: 3
   Device size:             2.73TiB
   Device slack:              0.00B
   Data,RAID5:            333.00GiB
   Data,RAID5:              5.00GiB
   Unallocated:             2.40TiB

/dev/sdg, ID: 2
   Device size:             1.82TiB
   Device slack:              0.00B
   Data,RAID5:            333.00GiB
   Data,RAID5:            955.00GiB
   Data,RAID5:              5.57GiB
   Metadata,RAID1:          3.00GiB
   Unallocated:           566.44GiB

/dev/sdh, ID: 4
   Device size:             1.82TiB
   Device slack:              0.00B
   Data,RAID5:            333.00GiB
   Data,RAID5:            955.00GiB
   Data,RAID5:              5.57GiB
   Metadata,RAID1:          2.00GiB
   System,RAID1:           32.00MiB
   Unallocated:           567.41GiB

/dev/sdi, ID: 7
   Device size:             2.73TiB
   Device slack:              0.00B
   Data,RAID5:            333.00GiB
   Data,RAID5:            955.00GiB
   Data,RAID5:              5.57GiB
   Metadata,RAID1:         11.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             1.45TiB

/dev/sdj, ID: 6
   Device size:           465.76GiB
   Device slack:              0.00B
   Data,RAID5:            333.00GiB
   Data,RAID5:            587.38MiB
   Unallocated:           132.19GiB

/dev/sdk, ID: 1
   Device size:             1.82TiB
   Device slack:              0.00B
   Data,RAID5:            333.00GiB
   Data,RAID5:            955.00GiB
   Data,RAID5:              5.57GiB
   Metadata,RAID1:          3.00GiB
   Unallocated:           566.44GiB

/dev/sdl, ID: 5
   Device size:             1.82TiB
   Device slack:              0.00B
   Data,RAID5:            333.00GiB
   Data,RAID5:            955.00GiB
   Data,RAID5:              5.57GiB
   Metadata,RAID1:          3.00GiB
   Unallocated:           566.44GiB

Thanks,
DocMAX
