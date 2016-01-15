Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38731 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcAOC0M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 21:26:12 -0500
Received: by mail-wm0-f52.google.com with SMTP id b14so4255864wmb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 18:26:11 -0800 (PST)
MIME-Version: 1.0
From: "cheater00 ." <cheater00@gmail.com>
Date: Fri, 15 Jan 2016 03:25:51 +0100
Message-ID: <CA+9GZUjeXhvb0xHCrfxg3F+Os55EzSq+66009EAbqztwQM-VVQ@mail.gmail.com>
Subject: Crash on btrfs check
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,
I have a particularly full btrfs (nearly all of 6TB used on a disk).
This is different than the fs I've experienced the resize bug on
recently.

btrfs check crashes on it:

# btrfs check /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: 95db96b3-96fe-4a12-810c-27c1dbd30b0d
checking extents
extent_io.c:543: __alloc_extent_buffer: Assertion failed.
btrfs[0x80558a3]
btrfs[0x8092971]
btrfs(alloc_extent_buffer+0xb7)[0x8093494]
btrfs(btrfs_find_create_tree_block+0x2b)[0x8083785]
btrfs(read_tree_block+0x32)[0x808503f]
btrfs(read_node_slot+0x63)[0x807f430]
btrfs(btrfs_search_slot+0xb47)[0x8081a28]
btrfs(btrfs_lookup_extent_info+0xd6)[0x808a0df]
btrfs[0x806c13a]
btrfs[0x806d95e]
btrfs[0x806e5cb]
btrfs(cmd_check+0x10f8)[0x8070fee]
btrfs(main+0x14d)[0x8055acb]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb74f0a83]
btrfs[0x8055af8]



$ uname -a
Linux SX20S 4.4.0-040400-generic #201601101930 SMP Mon Jan 11 00:49:33
UTC 2016 i686 i686 i686 GNU/Linux

$ btrfs --version
btrfs-progs v4.3

# btrfs fi show /dev/sdb1
Label: 'A'  uuid: 95db96b3-96fe-4a12-810c-27c1dbd30b0d
    Total devices 1 FS bytes used 5.41TiB
    devid    1 size 5.46TiB used 5.46TiB path /dev/sdb1

# btrfs-show-super /dev/sdb1
superblock: bytenr=65536, device=/dev/sdb1
---------------------------------------------------------
csum            0x116b97f0 [match]
bytenr            65536
flags            0x1
            ( WRITTEN )
magic            _BHRfS_M [match]
fsid            95db96b3-96fe-4a12-810c-27c1dbd30b0d
label            P
generation        128737
root            43384832
sys_array_size        226
chunk_root_generation    106809
root_level        1
chunk_root        20971520
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        6001173463040
bytes_used        5948325072896
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        1
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x61
            ( MIXED_BACKREF |
              BIG_METADATA |
              EXTENDED_IREF )
csum_type        0
csum_size        4
cache_generation    128737
uuid_tree_generation    128737
dev_item.uuid        e2a8e731-b28c-437b-8cb9-583bb96aea5f
dev_item.fsid        95db96b3-96fe-4a12-810c-27c1dbd30b0d [match]
dev_item.type        0
dev_item.total_bytes    6001173463040
dev_item.bytes_used    6001173463040
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0

# btrfs fi usage A
Overall:
    Device size:           5.46TiB
    Device allocated:           5.46TiB
    Device unallocated:             0.00B
    Device missing:             0.00B
    Used:               5.42TiB
    Free (estimated):          35.41GiB    (min: 35.41GiB)
    Data ratio:                  1.00
    Metadata ratio:              2.00
    Global reserve:         512.00MiB    (used: 0.00B)

Data,single: Size:5.43TiB, Used:5.40TiB
   /dev/sdb1       5.43TiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdb1       8.00MiB

Metadata,DUP: Size:12.50GiB, Used:11.22GiB
   /dev/sdb1      25.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdb1       4.00MiB

System,DUP: Size:8.00MiB, Used:608.00KiB
   /dev/sdb1      16.00MiB

Unallocated:
   /dev/sdb1         0.00B

dmesg is showing a lot of stuff like this, but it only started doing
this when I upgraded to linux 4.4, whereas before on 4.3 this didn't
happen:

[56319.486446] BTRFS critical (device sdb1): entry offset
6102519574528, bytes 20480, bitmap no
[56319.486447] BTRFS critical (device sdb1): entry offset
6102527688704, bytes 24576, bitmap no
[56319.486448] BTRFS critical (device sdb1): entry offset
6102528040960, bytes 8192, bitmap no
[56319.486450] BTRFS critical (device sdb1): entry offset
6102536241152, bytes 8192, bitmap no
[56319.486451] BTRFS critical (device sdb1): entry offset
6102561120256, bytes 8192, bitmap no
[56319.486452] BTRFS critical (device sdb1): entry offset
6102590480384, bytes 4096, bitmap no
[56319.486453] BTRFS critical (device sdb1): entry offset
6102620999680, bytes 12288, bitmap no
[56319.486454] BTRFS critical (device sdb1): entry offset
6102633365504, bytes 16384, bitmap no
[56319.486455] BTRFS info (device sdb1): block group has cluster?: no
[56319.486456] BTRFS info (device sdb1): 1 blocks of free space at or
bigger than bytes is
