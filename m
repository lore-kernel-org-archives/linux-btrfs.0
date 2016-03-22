Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35340 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbcCVNjt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 09:39:49 -0400
Received: by mail-qg0-f46.google.com with SMTP id y89so178920691qge.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 06:39:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Mar 2016 14:39:48 +0100
Message-ID: <CADNFivbfQvYPSuDFw7XodyibNeHr0=H55N05E4p0uk53rDQhEQ@mail.gmail.com>
Subject: Unable to rescue super-recover and/or restore
From: Thomas Kuther <thomas.kuther@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

I could need some advice on recovering a sort of broken filesystem
(power cycle death). It seems the first superblock is damaged, but I'm
unable to recover from a good one.

Running on a livecd with latest kernel and btrfs-tools I could get my
hands on, this is all the info I can give:


# uname -a
Linux archiso 4.4.1-2-ARCH #1 SMP PREEMPT Wed Feb 3 13:12:33 UTC 2016
x86_64 GNU/Linux

# btrfs version
btrfs-progs v4.5

# fdisk -l /dev/sda
Disk /dev/sda: 119.2 GiB, 128035676160 bytes, 250069680 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 8A4EA6CE-3E19-48DC-B6D3-A01F22F6EEC3

Device     Start       End   Sectors   Size Type
/dev/sda1   2048      6143      4096     2M BIOS boot
/dev/sda2   6144 250069646 250063503 119.2G Linux filesystem

# btrfs-show-super -a /dev/sda2
superblock: bytenr=65536, device=/dev/sda2
---------------------------------------------------------
ERROR: bad magic on superblock on /dev/sda2 at 65536

superblock: bytenr=67108864, device=/dev/sda2
---------------------------------------------------------
csum 0xaf86e706 [match]
bytenr 67108864
flags 0x1
( WRITTEN )
magic _BHRfS_M [match]
fsid 4fe9d531-bef6-431d-b6be-ed68df8023bc
label
generation 1176204
root 42795008
sys_array_size 226
chunk_root_generation 158914
root_level 1
chunk_root 20971520
chunk_root_level 0
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 128032509952
bytes_used 79141912576
sectorsize 4096
nodesize 16384
leafsize 16384
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x69
( MIXED_BACKREF |
  COMPRESS_LZO |
  BIG_METADATA |
  EXTENDED_IREF )
csum_type 0
csum_size 4
cache_generation 1176204
uuid_tree_generation 1176204
dev_item.uuid e0474a00-70fe-4aee-9dc4-467966f4998c
dev_item.fsid 4fe9d531-bef6-431d-b6be-ed68df8023bc [match]
dev_item.type 0
dev_item.total_bytes 128032509952
dev_item.bytes_used 128032505856
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

To my understanding, that backup superblock looks healthy (I might be
wrong though, just looking at the csum MATCH). So trying to recover
from it:

# btrfs check -s1 /dev/sda2
using SB copy 1, bytenr 67108864
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
bytenr mismatch, want=42795008, have=18446744073709551615
Couldn't read tree root
Couldn't open file system

# btrfs rescue super-recover -v /dev/sda2
All Devices:
Device: id = 1, name = /dev/sda2

ctree.h:2068: btrfs_super_csum_size: Assertion `t >=
ARRAY_SIZE(btrfs_csum_sizes)` failed.
btrfs[0x436f6a]
btrfs(btrfs_recover_superblocks+0x19c)[0x43712c]
btrfs(main+0x82)[0x40adf2]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7fd0ce8fa710]
btrfs(_start+0x29)[0x40aef9]


# btrfs-select-super -s1 /dev/sda2
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
bytenr mismatch, want=42795008, have=18446744073709551615
Couldn't read tree root
Open ctree failed


Trying to get the data off using restore, no surprise:

# btrfs restore -u1 -D /dev/sda2 /mnt
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
checksum verify failed on 42795008 found 8FF848E2 wanted FFFFFFFF
bytenr mismatch, want=42795008, have=18446744073709551615
Couldn't read tree root
Could not open root, trying backup super
Superblock bytenr is larger than device size
Could not open root, trying backup super


Do you have any advice on how to proceed here?

Best regards,
Thomas
