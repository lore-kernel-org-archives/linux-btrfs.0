Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:40956 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752138AbeDOMO6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 08:14:58 -0400
Received: by mail-io0-f170.google.com with SMTP id t123so7778731iof.7
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Apr 2018 05:14:57 -0700 (PDT)
MIME-Version: 1.0
From: Alexander Zapatka <alexzapatka@gmail.com>
Date: Sun, 15 Apr 2018 08:14:36 -0400
Message-ID: <CAFd7Xoev1N4yQpM-THMSgu2NNO19eK+Hd14Nx9XOPZC2BcOTWA@mail.gmail.com>
Subject: having issue removing a drive with a bad block
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

i recently set up a drive pool in single mode on my little media
server.  about a week later SMART started telling me that the drive
was having issue and there is one bad sector.  since the array is far
from full i decided to remove the drive from the pool.  but running

btrfs device remove /dev/sdc /mnt/pool

resulted in a deadlock.  everything crashed, and i had to pull the
plug to reboot.  once up i did a btrfs check of the drive and it
reported no issues with the file system...  but running the remove
again results in a dead lock.  i have tried running a scrub and it
eventually results in a dead lock also.

my system:

Linux kodbox 4.13.0-38-generic #43-Ubuntu SMP Wed Mar 14 15:20:44 UTC
2018 x86_64 x86_64 x86_64 GNU/Linux

 btrfs version:

btrfs-progs v4.12

though i have also compiled the latest btrfs from git and i get the
same results.

btrfs fi sh /mnt/pool

Label: none  uuid: cb30a848-1882-4f7f-aae1-1533f52d8783
        Total devices 4 FS bytes used 6.73TiB
        devid    1 size 7.28TiB used 5.67TiB path /dev/sdb1
        devid    2 size 1.82TiB used 219.00GiB path /dev/sdd1
        devid    3 size 1.82TiB used 220.03GiB path /dev/sda1
        devid    4 size 3.64TiB used 655.00GiB path /dev/sdc1

btrfs fi us /mnt/pool

Overall:
    Device size:                  14.55TiB
    Device allocated:              6.74TiB
    Device unallocated:            7.81TiB
    Device missing:                  0.00B
    Used:                          6.74TiB
    Free (estimated):              7.81TiB      (min: 3.91TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:6.73TiB, Used:6.72TiB
   /dev/sda1     216.00GiB
   /dev/sdb1       5.67TiB
   /dev/sdc1     655.00GiB
   /dev/sdd1     215.00GiB

Metadata,RAID1: Size:8.00GiB, Used:7.25GiB
   /dev/sda1       4.00GiB

   /dev/sdb1       8.00GiB
   /dev/sdd1       4.00GiB

System,RAID1: Size:32.00MiB, Used:768.00KiB
   /dev/sda1      32.00MiB
   /dev/sdb1      32.00MiB

Unallocated:
   /dev/sda1       1.60TiB
   /dev/sdb1       1.60TiB
   /dev/sdc1       3.00TiB
   /dev/sdd1       1.60TiB


smartmontools tells me this:

=== START OF READ SMART DATA SECTION ===
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       90%     11625
      1372896792
# 2  Short offline       Completed: read failure       90%     11571
      1372896792
# 3  Extended offline    Completed: read failure       90%     11562
      1372896792
# 4  Extended offline    Completed without error       00%     11243         -
# 5  Short offline       Completed without error       00%     10702         -
# 6  Conveyance offline  Completed without error       00%     10702         -

can i just dd if=zero of=/dev/sdc count=1 bs=16k seek=42903024

(i get the location by calculating lba * sector size / block size, so
1372896792*512/16384

which should cause the drive to correctly reallocate the sector.  i think.

anyway, the data is not super important, but i'd like to rescue it if
i can.  is there a way to get data off of one device manually and put
it on another device?
