Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36181 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbcCVUTP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 16:19:15 -0400
Received: by mail-io0-f178.google.com with SMTP id 124so102844293iov.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 13:19:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Mar 2016 16:19:14 -0400
Message-ID: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
Subject: RAID Assembly with Missing Empty Drive
From: John Marrett <johnf@zioncluster.ca>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I recently had a drive failure in a file server running btrfs. The
failed drive was completely non-functional. I added a new drive to the
filesystem successfully, when I attempted to remove the failed drive I
encountered an error. I discovered that I actually experienced a dual
drive failure, the second drive only exhibited as failed when btrfs
tried to write to the drives in the filesystem when I removed the
disk.

I shut down the array and imaged the failed drive using GNU ddrescue,
I was able to recover all but a few kb from the drive. Unfortunately,
when I imaged the drive I overwrote the drive that I had successfully
added to the filesystem.

This brings me to my current state, I now have two devices missing:

 - the completely failed drive
 - the empty drive that I overwrote with the second failed disks image

Consequently I can't start the filesystem. I've discussed the issue in
the past with Ke and other people on the #btrfs channel, the
concensus; as I understood it, is that with the right patch it should
be possible to mount either the array with the empty drive absent or
to create a new btrfs fileystem on an empty drive and then manipulate
its UUIDs so that it believes it's the missing UUID from the existing
btrfs filesystem.

Here's the info showing the current state of the filesystem:

ubuntu@ubuntu:~$ sudo btrfs filesystem show
warning, device 6 is missing
warning devid 6 not found already
warning devid 7 not found already
Label: none  uuid: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
    Total devices 7 FS bytes used 5.47TiB
    devid    1 size 1.81TiB used 1.71TiB path /dev/sda3
    devid    2 size 1.81TiB used 1.71TiB path /dev/sdb3
    devid    3 size 1.82TiB used 1.72TiB path /dev/sdc1
    devid    4 size 1.82TiB used 1.72TiB path /dev/sdd1
    devid    5 size 2.73TiB used 2.62TiB path /dev/sde1
    *** Some devices missing
btrfs-progs v4.0
ubuntu@ubuntu:~$ sudo mount -o degraded /dev/sda3 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sda3,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
ubuntu@ubuntu:~$ dmesg
[...]
[  749.322385] BTRFS info (device sde1): allowing degraded mounts
[  749.322404] BTRFS info (device sde1): disk space caching is enabled
[  749.323571] BTRFS warning (device sde1): devid 6 uuid
f41bcb72-e88a-432f-9961-01307ec291a9 is missing
[  749.335543] BTRFS warning (device sde1): devid 7 uuid
17f8e02a-923e-4ac3-9db2-eb1b47c1a8db missing
[  749.407802] BTRFS: bdev (null) errs: wr 81791613, rd 57814378,
flush 0, corrupt 0, gen 0
[  749.407808] BTRFS: bdev /dev/sde1 errs: wr 0, rd 5002, flush 0,
corrupt 0, gen 0
[  774.759717] BTRFS: too many missing devices, writeable mount is not allowed
[  774.804053] BTRFS: open_ctree failed

Thank you in advance for your help,

-JohnF
