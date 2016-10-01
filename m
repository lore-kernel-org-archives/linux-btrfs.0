Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36154 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbcJAInO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Oct 2016 04:43:14 -0400
Received: by mail-wm0-f53.google.com with SMTP id k125so65041733wma.1
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Oct 2016 01:43:14 -0700 (PDT)
MIME-Version: 1.0
From: Nicolas Pujol <nicolas.pujol@gmail.com>
Date: Sat, 1 Oct 2016 10:42:32 +0200
Message-ID: <CAOf5Se5C+6Y+=uz=Lkv-wrPhHZOMD94hzrtLHwDR3D78UHiSSQ@mail.gmail.com>
Subject: Resize a btrfs File System : no enough free space... why ?!?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dears,

I added a news disk to my RAID5 array so I now have 4 * 2Tio disks,
with an +/-6Tio available capacity. On the RAID I have only one LVM
volume to manage all this space :
$ lvdisplay
  --- Logical volume ---
  LV Path                /dev/VG1/Vol3
  LV Name                Vol3
  VG Name                VG1
  LV UUID                dEGmTz-Fj0Z-qbOf-xn67-D5D8-5BNY-EwCsoF
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 1
  LV Size                5,46 TiB
  Current LE             1430795
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2

After increased the RAID, then the LVM, I resize the BTRFS :
$ btrfs filesystem resize 1:max /mnt/RAID

Now I have 5,5T available:
# df -h /mnt/RAID
Sys. de fichiers     Taille Utilisé Dispo Uti% Monté sur
/dev/mapper/VG1-Vol3   5,5T    3,5T  1,9T  66% /mnt/RAID

# btrfs fi show
Label: none  uuid: 8dbd4ab0-e3d9-417d-b69b-dfdb51475e7e
    Total devices 1 FS bytes used 43.70GiB
    devid    1 size 100.00GiB used 79.04GiB path /dev/sdc3

Label: none  uuid: b8fd880f-fa7f-4f8b-bf40-1619e4931207
    Total devices 1 FS bytes used 3.46TiB
    devid    1 size 5.46TiB used 3.61TiB path /dev/mapper/VG1-Vol3

# btrfs fi df /mnt/RAID
Data, single: total=3.48TiB, used=3.46TiB
System, DUP: total=8.00MiB, used=416.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=69.62GiB, used=5.86GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

Unfortunately, I want to change the RAID chunk size because it is only
4K so I have to update the size of BTRFS before. Now, array size is
5860537608 so I want to reduce to 5860537344k :
$ btrfs filesystem resize 1:5860537344k /mnt/RAID
Resize '/mnt/RAID' of '1:5860537344k'
ERROR: unable to resize '/mnt/RAID': no enough free space

I tried severals tips but without any success:
# btrfs balance start -v -dusage=0 /mnt/RAID
# btrfs balance start -v -dusage=5 /mnt/RAID
# btrfs filesystem defragment /mnt/RAID

Like I don't understand the error, do you know why I can not resize
the BTRFS partition while 2TB are free?

For information:
# uname -a
Linux PC-NPL 4.6.4-1-ARCH #1 SMP PREEMPT Mon Jul 11 19:12:32 CEST 2016
x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.6.1

# mdadm --detail /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Thu Jun 16 21:32:53 2011
     Raid Level : raid5
     Array Size : 5860537608 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 1953512536 (1863.01 GiB 2000.40 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sat Oct  1 09:45:38 2016
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : parity-last
     Chunk Size : 4K

           Name : PC-NPL.localdomain:0
           UUID : f225928d:d977588a:058808df:cc6c53ca
         Events : 989508

    Number   Major   Minor   RaidDevice State
       1       8       49        0      active sync   /dev/sdd1
       4       8       65        1      active sync   /dev/sde1
       3       8        1        2      active sync   /dev/sda1
       5       8       17        3      active sync   /dev/sdb1
