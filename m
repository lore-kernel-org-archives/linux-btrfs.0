Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:53433 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbbGIXea (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 19:34:30 -0400
MIME-Version: 1.0
Message-ID: <trinity-6ce0e74d-59bd-46bc-a3d6-a45d130708b7-1436484868276@3capp-webde-bs53>
From: conchur@web.de
To: linux-btrfs@vger.kernel.org
Subject: [BUG] Fails to duplicate metadata/system
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jul 2015 01:34:28 +0200
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've noticed that a single device partition was using metadata.single and system.single instead of metadata.dup and system.dup. All tests to force conversion to dup failed.

Here is how to reproduce this with an image and some very simple BTRFS commands (Debian stretch):

$ uname -a
Linux asdasd 4.0.0-1-amd64 #1 SMP Debian 4.0.2-1 (2015-05-11) x86_64 GNU/Linux
$ btrfs --version
btrfs-progs v4.0
$ fallocate -l 8G test.img
$ mkdir mnt
$ mkfs.btrfs test.img
$ mount -o loop test.img mnt
$ touch mnt/asdasd
$ btrfs fi df mnt
Data, single: total=8.00MiB, used=64.00KiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=409.56MiB, used=112.00KiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=16.00MiB, used=0.00B
$ btrfs balance start -v -mconvert=single -sconvert=single -dconvert=single mnt -f
Dumping filters: flags 0xf, state 0x0, force is on
  DATA (flags 0x100): converting, target=281474976710656, soft is off
  METADATA (flags 0x100): converting, target=281474976710656, soft is off
  SYSTEM (flags 0x100): converting, target=281474976710656, soft is off
Done, had to relocate 5 out of 5 chunks
$ btrfs fi df mnt
Data, single: total=832.00MiB, used=256.00KiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=256.00MiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B
$ btrfs balance start -v -mconvert=dup -sconvert=dup -dconvert=single mnt -f
Dumping filters: flags 0xf, state 0x0, force is on
  DATA (flags 0x100): converting, target=281474976710656, soft is off
  METADATA (flags 0x100): converting, target=32, soft is off
  SYSTEM (flags 0x100): converting, target=32, soft is off
Done, had to relocate 3 out of 3 chunks
$ btrfs fi df mnt                                                                
Data, single: total=832.00MiB, used=320.00KiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=256.00MiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B


The expected result would be "Metadata, DUP" and "System, DUP" and not "Metadata, single" and "System, single"






Some more info.


$ btrfs fi show mnt
Label: none  uuid: b1a70fc4-7c18-4929-9b73-8f8bb328e7de
        Total devices 1 FS bytes used 384.00KiB
        devid    1 size 8.00GiB used 1.09GiB path /dev/loop0

btrfs-progs v4.0
$ btrfs fi usage mnt
Overall:
    Device size:                   8.00GiB
    Device allocated:              1.09GiB
    Device unallocated:            6.91GiB
    Device missing:                  0.00B
    Used:                        384.00KiB
    Free (estimated):              7.72GiB      (min: 7.72GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,single: Size:832.00MiB, Used:256.00KiB
   /dev/loop0    832.00MiB

Metadata,single: Size:256.00MiB, Used:112.00KiB
   /dev/loop0    256.00MiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/loop0     32.00MiB

Unallocated:
   /dev/loop0      6.91GiB
$ btrfs-debug-tree test.img 
root tree
leaf 2539634688 items 16 free space 12515 generation 47 owner 1
fs uuid b1a70fc4-7c18-4929-9b73-8f8bb328e7de
chunk uuid c2606900-bfa1-444e-ab4d-3f0b2d31626b
        item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 439
                root data bytenr 2539651072 level 0 dirid 0 refs 1 gen 47
                uuid 00000000-0000-0000-0000-000000000000
        item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 15405 itemsize 439
                root data bytenr 2539569152 level 0 dirid 0 refs 1 gen 46
                uuid 00000000-0000-0000-0000-000000000000
        item 2 key (FS_TREE INODE_REF 6) itemoff 15388 itemsize 17
                inode ref index 0 namelen 7 name: default
        item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
                root data bytenr 2539356160 level 0 dirid 256 refs 1 gen 42
                uuid 00000000-0000-0000-0000-000000000000
                ctransid 6 otransid 0 stransid 0 rtransid 0
        item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 14789 itemsize 160
                inode generation 3 transid 0 size 0 block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0 flags 0x0
        item 5 key (ROOT_TREE_DIR INODE_REF 6) itemoff 14777 itemsize 12
                inode ref index 0 namelen 2 name: ..
        item 6 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 14740 itemsize 37
                location key (FS_TREE ROOT_ITEM -1) type DIR
                namelen 7 datalen 0 name: default
        item 7 key (CSUM_TREE ROOT_ITEM 0) itemoff 14301 itemsize 439
                root data bytenr 2539667456 level 0 dirid 0 refs 1 gen 47
                uuid 00000000-0000-0000-0000-000000000000
        item 8 key (UUID_TREE ROOT_ITEM 0) itemoff 13862 itemsize 439
                root data bytenr 2539208704 level 0 dirid 0 refs 1 gen 41
                uuid be2539ee-1c09-e84c-8ec9-bfe054347ccf
        item 9 key (259 INODE_ITEM 0) itemoff 13702 itemsize 160
                inode generation 47 transid 47 size 196608 block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0 flags 0x1b
        item 10 key (259 EXTENT_DATA 0) itemoff 13649 itemsize 53
                extent data disk byte 1633615872 nr 196608
                extent data offset 0 nr 196608 ram 196608
                extent compression 0
        item 11 key (260 INODE_ITEM 0) itemoff 13489 itemsize 160
                inode generation 47 transid 47 size 65536 block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0 flags 0x1b
        item 12 key (260 EXTENT_DATA 0) itemoff 13436 itemsize 53
                extent data disk byte 1633222656 nr 65536
                extent data offset 0 nr 65536 ram 65536
                extent compression 0
        item 13 key (FREE_SPACE UNTYPED 1633222656) itemoff 13395 itemsize 41
                location key (259 INODE_ITEM 0)
                cache generation 47 entries 2 bitmaps 0
        item 14 key (FREE_SPACE UNTYPED 2539192320) itemoff 13354 itemsize 41
                location key (260 INODE_ITEM 0)
                cache generation 47 entries 6 bitmaps 0
        item 15 key (DATA_RELOC_TREE ROOT_ITEM 0) itemoff 12915 itemsize 439
                root data bytenr 2539552768 level 0 dirid 256 refs 1 gen 46
                uuid 00000000-0000-0000-0000-000000000000
chunk tree
leaf 2505637888 items 4 free space 15845 generation 46 owner 3
fs uuid b1a70fc4-7c18-4929-9b73-8f8bb328e7de
chunk uuid c2606900-bfa1-444e-ab4d-3f0b2d31626b
        item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
                dev item devid 1 total_bytes 8589934592 bytes used 1174405120
                dev uuid fbdcbb0e-9419-4fc8-8779-4b758783b1db
        item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 1633222656) itemoff 16105 itemsize 80
                chunk length 872415232 owner 2 type DATA num_stripes 1
                        stripe 0 devid 1 offset 2071068672
        item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 2505637888) itemoff 16025 itemsize 80
                chunk length 33554432 owner 2 type SYSTEM num_stripes 1
                        stripe 0 devid 1 offset 1048576
        item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 2539192320) itemoff 15945 itemsize 80
                chunk length 268435456 owner 2 type METADATA num_stripes 1
                        stripe 0 devid 1 offset 34603008
extent tree key (EXTENT_TREE ROOT_ITEM 0) 
leaf 2539651072 items 13 free space 15516 generation 47 owner 2
fs uuid b1a70fc4-7c18-4929-9b73-8f8bb328e7de
chunk uuid c2606900-bfa1-444e-ab4d-3f0b2d31626b
        item 0 key (1633222656 EXTENT_ITEM 65536) itemoff 16230 itemsize 53
                extent refs 1 gen 47 flags DATA
                extent data backref root 1 objectid 260 offset 0 count 1
        item 1 key (1633222656 BLOCK_GROUP_ITEM 872415232) itemoff 16206 itemsize 24
                block group used 262144 chunk_objectid 256 flags DATA
        item 2 key (1633615872 EXTENT_ITEM 196608) itemoff 16153 itemsize 53
                extent refs 1 gen 47 flags DATA
                extent data backref root 1 objectid 259 offset 0 count 1
        item 3 key (2505637888 METADATA_ITEM 0) itemoff 16120 itemsize 33
                extent refs 1 gen 46 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 3
        item 4 key (2505637888 BLOCK_GROUP_ITEM 33554432) itemoff 16096 itemsize 24
                block group used 16384 chunk_objectid 256 flags SYSTEM
        item 5 key (2539192320 BLOCK_GROUP_ITEM 268435456) itemoff 16072 itemsize 24
                block group used 114688 chunk_objectid 256 flags METADATA
        item 6 key (2539208704 METADATA_ITEM 0) itemoff 16039 itemsize 33
                extent refs 1 gen 41 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 9
        item 7 key (2539356160 METADATA_ITEM 0) itemoff 16006 itemsize 33
                extent refs 1 gen 42 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 5
        item 8 key (2539552768 METADATA_ITEM 0) itemoff 15973 itemsize 33
                extent refs 1 gen 46 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 18446744073709551607
        item 9 key (2539569152 METADATA_ITEM 0) itemoff 15940 itemsize 33
                extent refs 1 gen 46 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 4
        item 10 key (2539634688 METADATA_ITEM 0) itemoff 15907 itemsize 33
                extent refs 1 gen 47 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 1
        item 11 key (2539651072 METADATA_ITEM 0) itemoff 15874 itemsize 33
                extent refs 1 gen 47 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 2
        item 12 key (2539667456 METADATA_ITEM 0) itemoff 15841 itemsize 33
                extent refs 1 gen 47 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 7
device tree key (DEV_TREE ROOT_ITEM 0) 
leaf 2539569152 items 4 free space 15999 generation 46 owner 4
fs uuid b1a70fc4-7c18-4929-9b73-8f8bb328e7de
chunk uuid c2606900-bfa1-444e-ab4d-3f0b2d31626b
        item 0 key (0 DEV_STATS_ITEM 1) itemoff 16243 itemsize 40
                device stats
        item 1 key (1 DEV_EXTENT 1048576) itemoff 16195 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 2505637888 length 33554432
        item 2 key (1 DEV_EXTENT 34603008) itemoff 16147 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 2539192320 length 268435456
        item 3 key (1 DEV_EXTENT 2071068672) itemoff 16099 itemsize 48
                dev extent chunk_tree 3
                chunk objectid 256 chunk offset 1633222656 length 872415232
fs tree key (FS_TREE ROOT_ITEM 0) 
leaf 2539356160 items 6 free space 15713 generation 42 owner 5
fs uuid b1a70fc4-7c18-4929-9b73-8f8bb328e7de
chunk uuid c2606900-bfa1-444e-ab4d-3f0b2d31626b
        item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
                inode generation 3 transid 6 size 12 block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0 flags 0x0
        item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
                inode ref index 0 namelen 2 name: ..
        item 2 key (256 DIR_ITEM 1642998658) itemoff 16075 itemsize 36
                location key (257 INODE_ITEM 0) type FILE
                namelen 6 datalen 0 name: asdasd
        item 3 key (256 DIR_INDEX 2) itemoff 16039 itemsize 36
                location key (257 INODE_ITEM 0) type FILE
                namelen 6 datalen 0 name: asdasd
        item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
                inode generation 6 transid 6 size 0 block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0 flags 0x0
        item 5 key (257 INODE_REF 256) itemoff 15863 itemsize 16
                inode ref index 2 namelen 6 name: asdasd
checksum tree key (CSUM_TREE ROOT_ITEM 0) 
leaf 2539667456 items 0 free space 16283 generation 47 owner 7
fs uuid b1a70fc4-7c18-4929-9b73-8f8bb328e7de
chunk uuid c2606900-bfa1-444e-ab4d-3f0b2d31626b
uuid tree key (UUID_TREE ROOT_ITEM 0) 
leaf 2539208704 items 0 free space 16283 generation 41 owner 9
fs uuid b1a70fc4-7c18-4929-9b73-8f8bb328e7de
chunk uuid c2606900-bfa1-444e-ab4d-3f0b2d31626b
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 
leaf 2539552768 items 2 free space 16061 generation 46 owner 18446744073709551607
fs uuid b1a70fc4-7c18-4929-9b73-8f8bb328e7de
chunk uuid c2606900-bfa1-444e-ab4d-3f0b2d31626b
        item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
                inode generation 3 transid 0 size 0 block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0 flags 0x0
        item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
                inode ref index 0 namelen 2 name: ..
total bytes 8589934592
bytes used 393216
uuid b1a70fc4-7c18-4929-9b73-8f8bb328e7de
btrfs-progs v4.0
