Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:32920 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcEKSgZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 14:36:25 -0400
Received: by mail-lf0-f46.google.com with SMTP id y84so59203088lfc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 May 2016 11:36:24 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 11 May 2016 13:36:23 -0500
Message-ID: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
Subject: BTRFS Data at Rest File Corruption
From: Richard Lochner <lochner@clone1.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have encountered a data corruption error with BTRFS which may or may
not be of interest to your developers.

The problem is that an unmodified file on a RAID-1 volume that had
been scrubbed successfully is now corrupt.  The details follow.

The volume was formatted as btrfs with raid1 data and raid1 metadata
on two new 4T hard drives (WD Data Center Re WD4000FYYZ) .

A large binary file was copied to the volume (~76 GB) on December 27,
2015.  Soon after copying the file, a btrfs scrub was run. There were
no errors.  Multiple scrubs have also been run over the past several
months.

Recently, a scrub returned an unrecoverable error on that file.
Again, the file has not been modified since it was originally copied
and has the time stamp from December.  Furthermore, SMART tests (long)
for both drives do not indicate any errors (Current_Pending_Sector or
otherwise).

I should note that the system does not have ECC memory.

It would be interesting to me to know if:

a) The primary and secondary data blocks match (I suspect they do), and
b) The primary and secondary checksums for the block match (I suspect
they do as well).

Unfortunately, I do not have the skills to do such a verification.

If you have any thoughts or suggestions, I would be most interested.
I was hoping that I could trust the integrity of "data at rest" in a
RAID-1 setting under BTRFS, but this appears not to be the case.

Thank you,

R. Lochner

#uname -a
Linux vmh001.clone1.com 4.4.6-300.fc23.x86_64 #1 SMP Wed Mar 16
22:10:37 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.4.1

# btrfs fi show
Label: 'raid_pool'  uuid: d397ff55-e5c8-4d31-966e-d65694997451
    Total devices 2 FS bytes used 2.32TiB
    devid    1 size 3.00TiB used 2.32TiB path /dev/sdb1
    devid    2 size 3.00TiB used 2.32TiB path /dev/sdc1

# btrfs fi df /mnt
Data, RAID1: total=2.32TiB, used=2.31TiB
System, RAID1: total=40.00MiB, used=384.00KiB
Metadata, RAID1: total=7.00GiB, used=5.42GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Dmesg:

[2027323.705035] BTRFS warning (device sdc1): checksum error at
logical 3037444042752 on dev /dev/sdc1, sector 4988750584, root 259,
inode 1437377, offset 75754369024, length 4096, links 1 (path:
Rick/sda4.img)
[2027323.705056] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr 0,
rd 13, flush 0, corrupt 3, gen 0
[2027323.718869] BTRFS error (device sdc1): unable to fixup (regular)
error at logical 3037444042752 on dev /dev/sdc1

ls:

#ls -l /mnt/backup/Rick/sda4.img
-rw-r--r--. 1 root root 75959197696 Dec 27 10:36 /mnt/backup/Rick/sda4.img
