Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34477 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbcGDSJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 14:09:31 -0400
Received: by mail-wm0-f49.google.com with SMTP id 187so22972353wmz.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 11:09:30 -0700 (PDT)
Received: from [127.0.0.1] ([188.122.213.4])
        by smtp.googlemail.com with ESMTPSA id z1sm3760814wjh.14.2016.07.04.11.09.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Jul 2016 11:09:29 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Subject: Unable to mount degraded RAID5
Message-ID: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
Date: Mon, 4 Jul 2016 20:09:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
one of my 3 disks failed in RAID5. After that, fs is unable to mount.
Any help on what to try next would be appreciated.


sudo btrfs version
btrfs-progs v4.6.1
-- I installed 4.6.1 just now. I ran rescue on 4.4

uname -a
Linux uncik-srv 4.4.0-24-generic #43-Ubuntu SMP Wed Jun 8 19:27:37 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux



sudo mount -t btrfs -o ro,recovery /dev/sdc /shares
mount: wrong fs type, bad option, bad superblock on /dev/sdc,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

sudo btrfs rescue chunk-recover /dev/sdc
Scanning: 2517981163520 in dev0, 3166618750976 in dev1Segmentation fault
(core dumped)

sudo btrfs filesystem show /dev/sda
warning, device 3 is missing
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
bytenr mismatch, want=12678831570944, have=10160133442474442752
Couldn't read chunk tree
Label: none  uuid: 2dab74bb-fc73-4c47-a413-a55840f6f71e
        Total devices 3 FS bytes used 3.80TiB
        devid    1 size 3.64TiB used 1.92TiB path /dev/sdb
        devid    2 size 3.64TiB used 1.92TiB path /dev/sda
        *** Some devices missing

sudo btrfs restore /dev/sda /mnt
warning, device 3 is missing
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
bytenr mismatch, want=12678831570944, have=10160133442474442752
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 3 is missing
warning, device 1 is missing
bytenr mismatch, want=12678831570944, have=0
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 3 is missing
warning, device 1 is missing
bytenr mismatch, want=12678831570944, have=0
Couldn't read chunk tree
Could not open root, trying backup super

sudo btrfs check /dev/sda
warning, device 3 is missing
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
checksum verify failed on 12678831570944 found 3DC57E3E wanted 771D2379
bytenr mismatch, want=12678831570944, have=10160133442474442752
Couldn't read chunk tree
Couldn't open file system


Log
http://sebsauvage.net/paste/?236c3f6f238dbf26#4kM3tx+CjlA8ke9yMH+gD/QDsnjNnBK2i5Do4CXwD04=

Thank you
Tomas

---
Tato zpráva byla zkontrolována na viry programem Avast Antivirus.
https://www.avast.com/antivirus

