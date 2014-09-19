Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186]:30481 "EHLO
	mx-out-1.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaISJII (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 05:08:08 -0400
Message-ID: <541BF025.1030309@rwth-aachen.de>
Date: Fri, 19 Sep 2014 10:58:13 +0200
From: Jakob Breier <Jakob.Breier@rwth-aachen.de>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Help for creating a useful bugreport
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

my btrfs partition got corrupted. With some trouble I got most of the 
valuable data out of it using `btrfs restore -i` (it crashed a few 
times, but on the fourth or fifth run it reached the stuff I wanted to 
recover). As far as I can tell, the file system broke during normal 
operations without any hardware failures. Before I switch back to ext4, 
I'd like to file a bug report so my troubles were not completely in 
vain. Unfortunately I don't have much to work with. Can you help me with 
extracting enough information to create a useful bugreport?

Regards,
Jakob

$ cat /etc/fedora-release
Fedora release 20 (Heisenbug)

$ uname -a
Linux localhost.localdomain 3.16.2-200.fc20.x86_64 #1 SMP Mon Sep 8 
11:54:45 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

$ sudo btrfs fi show /dev/dm-1
Label: 'EncJakobExtern'  uuid: 8ccbd085-564d-4022-bfc9-18fd429d0a8d
         Total devices 1 FS bytes used 731.07GiB
         devid    1 size 931.60GiB used 769.04GiB path 
/dev/mapper/luks-a266c492-2360-404d-9ad7-00edc2f0c09d

Btrfs v3.16

$ sudo mount /dev/dm-1 /mnt/diverse/
mount: wrong fs type, bad option, bad superblock on 
/dev/mapper/luks-a266c492-2360-404d-9ad7-00edc2f0c09d,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

$ sudo mount /dev/dm-1 /mnt/diverse/ -o recovery
mount: wrong fs type, bad option, bad superblock on 
/dev/mapper/luks-a266c492-2360-404d-9ad7-00edc2f0c09d,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.


*Syslog:*
Sep 19 10:11:11 localhost.localdomain kernel: BTRFS: device label 
EncJakobExtern devid 1 transid 4923 /dev/dm-1
Sep 19 10:11:11 localhost.localdomain udisksd[1971]: Unlocked LUKS 
device /dev/sdb1 as /dev/dm-1

Sep 19 10:16:13 localhost.localdomain sudo[5080]: jakob : TTY=pts/6 ; 
PWD=/home/jakob ; USER=root ; COMMAND=/bin/mount /dev/dm-1 /mnt/diverse/
Sep 19 10:16:17 localhost.localdomain kernel: BTRFS info (device dm-1): 
disk space caching is enabled
Sep 19 10:16:18 localhost.localdomain kernel: parent transid verify 
failed on 46678016 wanted 4923 found 3306
Sep 19 10:16:18 localhost.localdomain kernel: parent transid verify 
failed on 46678016 wanted 4923 found 3306
Sep 19 10:16:18 localhost.localdomain kernel: BTRFS: Failed to read 
block groups: -5
Sep 19 10:16:18 localhost.localdomain kernel: BTRFS: open_ctree failed

Sep 19 10:16:45 localhost.localdomain sudo[5456]: jakob : TTY=pts/6 ; 
PWD=/home/jakob ; USER=root ; COMMAND=/bin/mount /dev/dm-1 /mnt/diverse/ 
-o recovery
Sep 19 10:16:45 localhost.localdomain kernel: BTRFS info (device dm-1): 
enabling auto recovery
Sep 19 10:16:45 localhost.localdomain kernel: BTRFS info (device dm-1): 
disk space caching is enabled
Sep 19 10:16:46 localhost.localdomain kernel: parent transid verify 
failed on 46678016 wanted 4923 found 3306
Sep 19 10:16:46 localhost.localdomain kernel: parent transid verify 
failed on 46678016 wanted 4923 found 3306
Sep 19 10:16:46 localhost.localdomain kernel: BTRFS: Failed to read 
block groups: -5
Sep 19 10:16:46 localhost.localdomain kernel: BTRFS: open_ctree failed


*fstab entry with which it was usually mounted:*
/dev/mapper/LuksOpenendEncJakobExtern /mnt/EncJakobExtern btrfs 
compress=lzo,nofail 0 0
