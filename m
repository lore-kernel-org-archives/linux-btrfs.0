Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35650 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbbGSVYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jul 2015 17:24:52 -0400
Received: by lblf12 with SMTP id f12so85399855lbl.2
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jul 2015 14:24:51 -0700 (PDT)
Received: from [192.168.1.47] ([95.163.215.56])
        by smtp.gmail.com with ESMTPSA id mx10sm4726403lbb.20.2015.07.19.14.24.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 19 Jul 2015 14:24:50 -0700 (PDT)
From: Aleksey Trifonov <aleksey.trifonov@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: BTRFS Couldn't read chunk root
Message-Id: <B1FF1E21-89FC-448F-AE9E-6B154D6F3C34@gmail.com>
Date: Mon, 20 Jul 2015 00:24:48 +0300
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I have a CentOS 7 box with 4 HDD (3x1Tb and 1x2Tb) in soft RAID-5 made with mdadm and btrfs over this.
Once I was need to remove my 2Tb disk from box and at this time SATA cable of 1Tb disk was failed.
I’ve done it on turned off machine, 2Tb disk was remoced by «mdadm —fail; mdadm --remove» and after turning machine on my RAID-array was inactive with 2 disks. I’ve replaced cable. assembled array, but my BTRFS is crashed.
Please, help me to recover files from my disks - there are some very important photos for me.

$ uname -a
Linux server.local 3.10.0-229.7.2.el7.x86_64 #1 SMP Tue Jun 23 22:06:11 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

$ btrfs --version
Btrfs v3.16.2

$ ./btrfs --version
btrfs-progs v4.1.2

$ sudo btrfs fi show
Label: none  uuid: 63a98c84-d857-45bf-a13f-68e00e1bd3e4
        Total devices 1 FS bytes used 1.54TiB
        devid    1 size 2.73TiB used 1.55TiB path /dev/md0

$ sudo ./btrfs check /dev/md0
checksum verify failed on 21053440 found 9F31D50C wanted 300A0D31
checksum verify failed on 21053440 found 9F31D50C wanted 300A0D31
checksum verify failed on 21053440 found 166E9CB1 wanted BE59B4B7
checksum verify failed on 21053440 found 9F31D50C wanted 300A0D31
bytenr mismatch, want=21053440, have=17447212025753641184
Couldn't read chunk root
Couldn't open file system

$ sudo btrfs rescue chunk-recover /dev/md0
scan chunk headers error
Abort to rebuild the on-disk chunk tree.

$ sudo ./btrfs-find-root /dev/md0
Couldn't read chunk root
Open ctree failed

$ sudo ./btrfs rescue super-recover /dev/md0
ctree.h:2021: btrfs_super_csum_size: Assertion `t >= ARRAY_SIZE(btrfs_csum_sizes)` failed.
./btrfs[0x434260]
./btrfs(btrfs_recover_superblocks+0x136)[0x4344e8]
./btrfs(cmd_super_recover+0x102)[0x42f0b4]
./btrfs(handle_command_group+0x5d)[0x409d8f]
./btrfs(cmd_rescue+0x15)[0x42f3b1]
./btrfs(main+0x153)[0x409ee7]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f2b80771af5]
./btrfs[0x409aa9]

$ sudo ./btrfs-show-super /dev/md0
superblock: bytenr=65536, device=/dev/md0
---------------------------------------------------------
csum                    0x51a27ea6 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    63a98c84-d857-45bf-a13f-68e00e1bd3e4
label
generation              1010
root                    1381383192576
sys_array_size          226
chunk_root_generation   960
root_level              1
chunk_root              21053440
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             3000211341312
bytes_used              1696763748352
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             1
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x61
                        ( MIXED_BACKREF |
                          BIG_METADATA |
                          EXTENDED_IREF )
csum_type               0
csum_size               4
cache_generation        1010
uuid_tree_generation    1010
dev_item.uuid           5b484f94-efec-4d9a-97a2-2c35614c133f
dev_item.fsid           63a98c84-d857-45bf-a13f-68e00e1bd3e4 [match]
dev_item.type           0
dev_item.total_bytes    3000211341312
dev_item.bytes_used     1701918539776
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
__
Aleksey Trifonov


