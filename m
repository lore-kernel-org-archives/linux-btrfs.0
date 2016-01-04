Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.arkena.net ([95.81.173.75]:50027 "EHLO smtp-2.arkena.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbcADNl0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jan 2016 08:41:26 -0500
Received: from [10.201.4.47] (unknown [10.201.4.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-2.arkena.net (Postfix) with ESMTPSA id 3pYyYX2YlSzHhB8
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Jan 2016 13:32:16 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Abe <ml-btrfs@zeroloop.net>
Subject: Broken RAID6, segfault on chunk-recover
Message-ID: <568A7460.6070607@zeroloop.net>
Date: Mon, 4 Jan 2016 14:32:16 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Could you please help in recovering this multiple device filesystem?
I went up to a point where running chunk-recover looks to be promising,
but unfortunately the command will segfault consistently.

This was a 8 devices Btrfs RAID6 using LSI HBA. One disk died suddenly
and is 100% unavailable. At this point, I had evidences userland was
receiving corrupted data while reading files (few invalid bytes in
gigabytes files). System was rebooted. Since then I can't mount it as
degraded or use any recovery command.
Memtest is ok.

What would you advise ?
Is the segfault issue something you would like me to help debug before
going further ?


----------------------------------

# uname -a
Linux horo 4.3.0-1-amd64 #1 SMP Debian 4.3.3-2 (2015-12-17) x86_64 GNU/Linux

----------------------------------

# ./btrfs version
btrfs-progs v4.3.1

----------------------------------

# lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 119.2G  0 disk
├─sda1   8:1    0     1M  0 part
└─sda2   8:2    0 118.3G  0 part /
sdb      8:16   0   477G  0 disk
└─sdb1   8:17   0   477G  0 part
sdc      8:32   0   477G  0 disk
└─sdc1   8:33   0   477G  0 part
sdd      8:48   0   477G  0 disk
└─sdd1   8:49   0   477G  0 part
sde      8:64   0   477G  0 disk
└─sde1   8:65   0   477G  0 part
sdf      8:80   0   477G  0 disk
└─sdf1   8:81   0   477G  0 part
sdg      8:96   0   477G  0 disk
└─sdg1   8:97   0   477G  0 part
sdh      8:112  0   477G  0 disk
└─sdh1   8:113  0   477G  0 part

----------------------------------

# ./btrfs fi show
warning, device 6 is missing
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
bytenr mismatch, want=4415566151680, have=526521381424393794
Couldn't read chunk root
Label: 'hive'  uuid: bec7b9a0-c56c-494e-8631-072d3f89c0c9
        Total devices 8 FS bytes used 2.22TiB
        devid    1 size 476.94GiB used 325.73GiB path /dev/sdf1
        devid    2 size 476.94GiB used 325.73GiB path /dev/sdc1
        devid    3 size 476.94GiB used 325.73GiB path /dev/sdd1
        devid    4 size 476.94GiB used 325.73GiB path /dev/sde1
        devid    5 size 476.94GiB used 325.73GiB path /dev/sdb1
        devid    7 size 476.94GiB used 325.73GiB path /dev/sdh1
        devid    8 size 476.94GiB used 325.73GiB path /dev/sdg1
        *** Some devices missing

----------------------------------

# mount -o ro,degraded,recovery /dev/sdb1 /mnt/temp
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so.

[169387.880114] BTRFS info (device sdb1): allowing degraded mounts
[169387.880125] BTRFS info (device sdb1): enabling auto recovery
[169387.880130] BTRFS info (device sdb1): disk space caching is enabled
[169387.880132] BTRFS: has skinny extents
[169387.890940] BTRFS: bdev (null) errs: wr 27, rd 1535, flush 9,
corrupt 0, gen 0
[169388.014701] BTRFS (device sdb1): bad tree block start
8621721664010832405 6766851391488
[169388.015117] BTRFS (device sdb1): bad tree block start
8621721664010832405 6766851391488
[169388.015148] BTRFS: Failed to read block groups: -5
[169388.042731] BTRFS: open_ctree failed

----------------------------------

# ./btrfs check --readonly /dev/sdb1
warning, device 6 is missing
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
bytenr mismatch, want=4415566151680, have=526521381424393794
Couldn't read chunk root
Couldn't open file system

# ./btrfs check --readonly --tree-root 4415566151680 /dev/sdb1
warning, device 6 is missing
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
bytenr mismatch, want=4415566151680, have=526521381424393794
Couldn't read chunk root
Couldn't open file system

# ./btrfs check --readonly --tree-root 526521381424393794 /dev/sdb1
warning, device 6 is missing
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
bytenr mismatch, want=4415566151680, have=526521381424393794
Couldn't read chunk root
Couldn't open file system

# ./btrfs check --repair --init-csum-tree /dev/sdb1
enabling repair mode
Creating a new CRC tree
warning, device 6 is missing
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
checksum verify failed on 4415566151680 found F8A6E83A wanted EB7CA66C
bytenr mismatch, want=4415566151680, have=526521381424393794
Couldn't read chunk root
Couldn't open file system

----------------------------------

# ./btrfs rescue super-recover -v /dev/sd[bcdefgh]1
[...]
All supers are valid, no need to recover

----------------------------------

# ./btrfs rescue chunk-recover -v /dev/sdb1
All Devices:
        Device: id = 1, name = /dev/sdf1
        Device: id = 7, name = /dev/sdh1
        Device: id = 8, name = /dev/sdg1
        Device: id = 4, name = /dev/sde1
        Device: id = 2, name = /dev/sdc1
        Device: id = 3, name = /dev/sdd1
        Device: id = 5, name = /dev/sdb1

Scanning: 0 in dev0, 0 in dev1, 0 in dev2, 0 in dev3, 0 in dev4, 0 in
dev5, 0 in dev6
Segmentation fault

# ./btrfs rescue chunk-recover -v /dev/sdc1
All Devices:
        Device: id = 1, name = /dev/sdf1
        Device: id = 7, name = /dev/sdh1
        Device: id = 8, name = /dev/sdg1
        Device: id = 4, name = /dev/sde1
        Device: id = 3, name = /dev/sdd1
        Device: id = 5, name = /dev/sdb1
        Device: id = 2, name = /dev/sdc1

Scanning: 4096 in dev0, 2052096 in dev1, 2183168 in dev2, 1146880 in
dev3, 0 in dev4, 0 in dev5, 0 in dev6
Segmentation fault

# ./btrfs rescue chunk-recover -v /dev/sdd1
All Devices:
        Device: id = 1, name = /dev/sdf1
        Device: id = 7, name = /dev/sdh1
        Device: id = 8, name = /dev/sdg1
        Device: id = 4, name = /dev/sde1
        Device: id = 2, name = /dev/sdc1
        Device: id = 5, name = /dev/sdb1
        Device: id = 3, name = /dev/sdd1

Scanning: 0 in dev0, 0 in dev1, 0 in dev2, 0 in dev3, 0 in dev4, 0 in
dev5, 0 in dev6
Segmentation fault

[...]

----------------------------------


Best regards
