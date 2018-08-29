Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:42762 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeH2P5D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 11:57:03 -0400
Received: by mail-oi0-f43.google.com with SMTP id k81-v6so2492752oib.9
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 05:00:28 -0700 (PDT)
MIME-Version: 1.0
From: Jorge Bastos <jorge.mrbastos@gmail.com>
Date: Wed, 29 Aug 2018 13:00:16 +0100
Message-ID: <CAHzMYBT22xie_4Tjp+Zn6w7DG0sDAdkRRDrgesUvJ60j0TrmnA@mail.gmail.com>
Subject: btrfs fi du unreliable?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Read on another post that you can use sudo btrfs fi du -s
<pathtosnapshot>' to get a report on  how much exclusive space is
being used by the snapshots, I wasn't aware of this command and
believed that there wasn't an easy way to get this, but after using it
on some of my btrfs file systems used for backups it seems unreliable.

This file system is used to backup one of my desktop disks where I
temporally save mostly large multimedia files to later archive to
another server, everyday before making the backup I do a snapshot, so
there are practically no modified files, only new or deleted files,
these are just a few days of snapshots:

btrfs fi du -s /mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-2*
     Total   Exclusive  Set shared  Filename
 199.98GiB   648.22MiB   199.35GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-20-070001
 198.74GiB     2.45GiB   196.29GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-21-070001
 277.13GiB       0.00B   277.13GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-22-070001
 277.13GiB       0.00B   277.13GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-23-070001
  80.04GiB     2.44GiB    77.60GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-24-070001
  93.71GiB     1.17GiB    92.55GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-25-070001
  94.85GiB       0.00B    94.85GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-26-070001
 339.82GiB   127.77GiB   212.05GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-27-070001
 279.94GiB    79.69GiB   200.25GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-28-070002
 118.00GiB     5.77GiB   112.22GiB
/mnt/disks/BackupSS/snaps/sspaces_daily_2018-07-29-070001

Look for example at snapshots from July 21st and 22nd, total used
space went from 199 to 277GiB, this is mostly from new added files, as
I confirmed from browsing those snapshots, there were no changes on
the 23rd, and a lot of files were deleted before the 24th, so should't
there be about 80GiB of exclusive content for the 22nd, or am I
misunderstanding how this is reported? ? Those were new files only,
never existed on previous snapshots, If I delete both snapshots from
the 22nd and the 23rd I expect to get about 80GiB freed space.

kernel 4.14.49 / btrfs-progs v4.15.1

Label: none  uuid: e12ba68e-1200-467c-99e7-95e986c1d6f2
        Total devices 2 FS bytes used 1.43TiB
        devid    2 size 1.82TiB used 1.38TiB path /dev/sdh1
        devid    3 size 931.51GiB used 706.51GiB path /dev/sdi1

Data, single: total=2.06TiB, used=1.43TiB
System, RAID1: total=32.00MiB, used=336.00KiB
Metadata, RAID1: total=4.00GiB, used=1.55GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
