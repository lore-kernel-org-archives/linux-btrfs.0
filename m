Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35075 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbcEPEv7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 00:51:59 -0400
Received: by mail-oi0-f66.google.com with SMTP id w198so27187151oiw.2
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 21:51:59 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 15 May 2016 22:51:58 -0600
Message-ID: <CAJCQCtTqmqg5tMGbLU9NV57s92JebCjT_4DFzRP613ZtXQ=Uiw@mail.gmail.com>
Subject: corrupt node with extent csum item results in bogus data being read
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs v4.5.2
kernel 4.5.3-300.fc24.x86_64
mkfs.btrfs -draid1 -mraid1 /dev/VG/b1 /dev/VG/b2 ## where b1/b2 are
LVM thinp LVs



The gist is that when a node containing a csum extent item is corrupt,
I'm allowed to read the file that csum data applies to, and the data
read in is bogus. Either the file data passed to user space should be
what's in the data extents, or I should get some failure to read the
file: enoent, or may eperm?

Here we go:

[root@f23s ~]# mount /dev/VG/b1 /mnt/0
[root@f23s ~]# sha256sum /mnt/0/openSUSE-Tumbleweed-NET-x86_64-Current.iso
5427573e30b49df3cede6608e1d5483aa7ddd60318f0c84d9d8965d74787416a
/mnt/0/openSUSE-Tumbleweed-NET-x86_64-Current.iso

## that matches the published sha256 hash for this file

[root@f23s ~]# umount /mnt/0
[root@f23s ~]# btrfs-debug-tree /dev/VG/b1
btrfs-progs v4.5.2
root tree
leaf 3317760000 items 16 free space 12515 generation 81 owner 1
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 439
        root data bytenr 3317776384 level 0 dirid 0 refs 1 gen 81 lastsnap 0
        uuid 00000000-0000-0000-0000-000000000000
    item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 15405 itemsize 439
        root data bytenr 3317792768 level 0 dirid 0 refs 1 gen 81 lastsnap 0
        uuid 00000000-0000-0000-0000-000000000000
    item 2 key (FS_TREE INODE_REF 6) itemoff 15388 itemsize 17
        inode ref index 0 namelen 7 name: default
    item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
        root data bytenr 3318169600 level 0 dirid 256 refs 1 gen 70 lastsnap 57
        uuid 00000000-0000-0000-0000-000000000000
        ctransid 70 otransid 0 stransid 0 rtransid 0
    item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 14789 itemsize 160
        inode generation 3 transid 0 size 0 nbytes 16384
        block group 0 mode 40755 links 1 uid 0 gid 0
        rdev 0 flags 0x0
    item 5 key (ROOT_TREE_DIR INODE_REF 6) itemoff 14777 itemsize 12
        inode ref index 0 namelen 2 name: ..
    item 6 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 14740 itemsize 37
        location key (FS_TREE ROOT_ITEM -1) type DIR
        namelen 7 datalen 0 name: default
    item 7 key (CSUM_TREE ROOT_ITEM 0) itemoff 14301 itemsize 439
        root data bytenr 3317809152 level 1 dirid 0 refs 1 gen 81 lastsnap 0
        uuid 00000000-0000-0000-0000-000000000000
    item 8 key (UUID_TREE ROOT_ITEM 0) itemoff 13862 itemsize 439
        root data bytenr 3317743616 level 0 dirid 0 refs 1 gen 58 lastsnap 0
        uuid d9c75fe1-fd56-8344-88a8-d00ac81d504a
    item 9 key (259 INODE_ITEM 0) itemoff 13702 itemsize 160
        inode generation 81 transid 81 size 262144 nbytes 6553600
        block group 0 mode 100600 links 1 uid 0 gid 0
        rdev 0 flags 0x1b
    item 10 key (259 EXTENT_DATA 0) itemoff 13649 itemsize 53
        extent data disk byte 2244214784 nr 262144
        extent data offset 0 nr 262144 ram 262144
        extent compression(none)
    item 11 key (260 INODE_ITEM 0) itemoff 13489 itemsize 160
        inode generation 81 transid 81 size 262144 nbytes 4194304
        block group 0 mode 100600 links 1 uid 0 gid 0
        rdev 0 flags 0x1b
    item 12 key (260 EXTENT_DATA 0) itemoff 13436 itemsize 53
        extent data disk byte 2243952640 nr 262144
        extent data offset 0 nr 262144 ram 262144
        extent compression(none)
    item 13 key (FREE_SPACE UNTYPED 2243952640) itemoff 13395 itemsize 41
        location key (259 INODE_ITEM 0)
        cache generation 81 entries 3 bitmaps 0
    item 14 key (FREE_SPACE UNTYPED 3317694464) itemoff 13354 itemsize 41
        location key (260 INODE_ITEM 0)
        cache generation 81 entries 6 bitmaps 0
    item 15 key (DATA_RELOC_TREE ROOT_ITEM 0) itemoff 12915 itemsize 439
        root data bytenr 3318284288 level 0 dirid 256 refs 1 gen 63 lastsnap 57
        uuid 00000000-0000-0000-0000-000000000000
chunk tree
leaf 4391436288 items 5 free space 15626 generation 68 owner 3
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
        dev item devid 1 total_bytes 536870912000 bytes used 2181038080
        dev uuid f1a61a34-72d1-4951-89d5-3ce2d2f6d415
    item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
        dev item devid 2 total_bytes 536870912000 bytes used 2181038080
        dev uuid 4fbfd261-0fa8-4c5e-85aa-dddd79414843
    item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 2243952640) itemoff 15975
itemsize 112
        chunk length 1073741824 owner 2 stripe_len 65536
        type DATA|RAID1 num_stripes 2
            stripe 0 devid 2 offset 2190475264
            dev uuid: 4fbfd261-0fa8-4c5e-85aa-dddd79414843
            stripe 1 devid 1 offset 2210398208
            dev uuid: f1a61a34-72d1-4951-89d5-3ce2d2f6d415
    item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 3317694464) itemoff 15863
itemsize 112
        chunk length 1073741824 owner 2 stripe_len 65536
        type METADATA|RAID1 num_stripes 2
            stripe 0 devid 2 offset 3297771520
            dev uuid: 4fbfd261-0fa8-4c5e-85aa-dddd79414843
            stripe 1 devid 1 offset 3317694464
            dev uuid: f1a61a34-72d1-4951-89d5-3ce2d2f6d415
    item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 4391436288) itemoff 15751
itemsize 112
        chunk length 33554432 owner 2 stripe_len 65536
        type SYSTEM|RAID1 num_stripes 2
            stripe 0 devid 2 offset 1048576
            dev uuid: 4fbfd261-0fa8-4c5e-85aa-dddd79414843
            stripe 1 devid 1 offset 1048576
            dev uuid: f1a61a34-72d1-4951-89d5-3ce2d2f6d415
extent tree key (EXTENT_TREE ROOT_ITEM 0)
leaf 3317776384 items 21 free space 15032 generation 81 owner 2
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (2243952640 EXTENT_ITEM 262144) itemoff 16230 itemsize 53
        extent refs 1 gen 81 flags DATA
        extent data backref root 1 objectid 260 offset 0 count 1
    item 1 key (2243952640 BLOCK_GROUP_ITEM 1073741824) itemoff 16206
itemsize 24
        block group used 110624768 chunk_objectid 256 flags DATA|RAID1
    item 2 key (2244214784 EXTENT_ITEM 262144) itemoff 16153 itemsize 53
        extent refs 1 gen 81 flags DATA
        extent data backref root 1 objectid 259 offset 0 count 1
    item 3 key (2354839552 EXTENT_ITEM 110100480) itemoff 16100 itemsize 53
        extent refs 1 gen 69 flags DATA
        extent data backref root 5 objectid 258 offset 0 count 1
    item 4 key (3317694464 BLOCK_GROUP_ITEM 1073741824) itemoff 16076
itemsize 24
        block group used 229376 chunk_objectid 256 flags METADATA|RAID1
    item 5 key (3317743616 METADATA_ITEM 0) itemoff 16043 itemsize 33
        extent refs 1 gen 58 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 9
    item 6 key (3317760000 METADATA_ITEM 0) itemoff 16010 itemsize 33
        extent refs 1 gen 81 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 1
    item 7 key (3317776384 METADATA_ITEM 0) itemoff 15977 itemsize 33
        extent refs 1 gen 81 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 2
    item 8 key (3317792768 METADATA_ITEM 0) itemoff 15944 itemsize 33
        extent refs 1 gen 81 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 4
    item 9 key (3317809152 METADATA_ITEM 1) itemoff 15911 itemsize 33
        extent refs 1 gen 81 flags TREE_BLOCK
        tree block skinny level 1
        tree block backref root 7
    item 10 key (3317858304 METADATA_ITEM 0) itemoff 15878 itemsize 33
        extent refs 1 gen 74 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 7
    item 11 key (3317874688 METADATA_ITEM 0) itemoff 15845 itemsize 33
        extent refs 1 gen 74 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 7
    item 12 key (3317891072 METADATA_ITEM 0) itemoff 15812 itemsize 33
        extent refs 1 gen 74 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 7
    item 13 key (3317907456 METADATA_ITEM 0) itemoff 15779 itemsize 33
        extent refs 1 gen 74 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 7
    item 14 key (3317923840 METADATA_ITEM 0) itemoff 15746 itemsize 33
        extent refs 1 gen 74 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 7
    item 15 key (3317940224 METADATA_ITEM 0) itemoff 15713 itemsize 33
        extent refs 1 gen 74 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 7
    item 16 key (3317956608 METADATA_ITEM 0) itemoff 15680 itemsize 33
        extent refs 1 gen 74 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 7
    item 17 key (3318169600 METADATA_ITEM 0) itemoff 15647 itemsize 33
        extent refs 1 gen 70 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 5
    item 18 key (3318284288 METADATA_ITEM 0) itemoff 15614 itemsize 33
        extent refs 1 gen 63 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 18446744073709551607
    item 19 key (4391436288 METADATA_ITEM 0) itemoff 15581 itemsize 33
        extent refs 1 gen 68 flags TREE_BLOCK
        tree block skinny level 0
        tree block backref root 3
    item 20 key (4391436288 BLOCK_GROUP_ITEM 33554432) itemoff 15557 itemsize 24
        block group used 16384 chunk_objectid 256 flags SYSTEM|RAID1
device tree key (DEV_TREE ROOT_ITEM 0)
leaf 3317792768 items 8 free space 15715 generation 81 owner 4
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (0 DEV_STATS 1) itemoff 16243 itemsize 40
        device stats
    item 1 key (0 DEV_STATS 2) itemoff 16203 itemsize 40
        device stats
    item 2 key (1 DEV_EXTENT 1048576) itemoff 16155 itemsize 48
        dev extent chunk_tree 3
        chunk objectid 256 chunk offset 4391436288 length 33554432
    item 3 key (1 DEV_EXTENT 2210398208) itemoff 16107 itemsize 48
        dev extent chunk_tree 3
        chunk objectid 256 chunk offset 2243952640 length 1073741824
    item 4 key (1 DEV_EXTENT 3317694464) itemoff 16059 itemsize 48
        dev extent chunk_tree 3
        chunk objectid 256 chunk offset 3317694464 length 1073741824
    item 5 key (2 DEV_EXTENT 1048576) itemoff 16011 itemsize 48
        dev extent chunk_tree 3
        chunk objectid 256 chunk offset 4391436288 length 33554432
    item 6 key (2 DEV_EXTENT 2190475264) itemoff 15963 itemsize 48
        dev extent chunk_tree 3
        chunk objectid 256 chunk offset 2243952640 length 1073741824
    item 7 key (2 DEV_EXTENT 3297771520) itemoff 15915 itemsize 48
        dev extent chunk_tree 3
        chunk objectid 256 chunk offset 3317694464 length 1073741824
fs tree key (FS_TREE ROOT_ITEM 0)
leaf 3318169600 items 8 free space 15419 generation 70 owner 5
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
        inode generation 3 transid 70 size 84 nbytes 16384
        block group 0 mode 40755 links 1 uid 0 gid 0
        rdev 0 flags 0x0
    item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
        inode ref index 0 namelen 2 name: ..
    item 2 key (256 DIR_ITEM 139828949) itemoff 16039 itemsize 72
        location key (258 INODE_ITEM 0) type FILE
        namelen 42 datalen 0 name: openSUSE-Tumbleweed-NET-x86_64-Current.iso
    item 3 key (256 DIR_INDEX 3) itemoff 15967 itemsize 72
        location key (258 INODE_ITEM 0) type FILE
        namelen 42 datalen 0 name: openSUSE-Tumbleweed-NET-x86_64-Current.iso
    item 4 key (258 INODE_ITEM 0) itemoff 15807 itemsize 160
        inode generation 69 transid 70 size 110100480 nbytes 110100480
        block group 0 mode 100644 links 1 uid 0 gid 0
        rdev 0 flags 0x0
    item 5 key (258 INODE_REF 256) itemoff 15755 itemsize 52
        inode ref index 3 namelen 42 name:
openSUSE-Tumbleweed-NET-x86_64-Current.iso
    item 6 key (258 XATTR_ITEM 3817753667) itemoff 15672 itemsize 83
        location key (0 UNKNOWN.0 0) type XATTR
        namelen 16 datalen 37 name: security.selinux
        data unconfined_u:object_r:unlabeled_t:s0
    item 7 key (258 EXTENT_DATA 0) itemoff 15619 itemsize 53
        extent data disk byte 2354839552 nr 110100480
        extent data offset 0 nr 110100480 ram 110100480
        extent compression(none)
checksum tree key (CSUM_TREE ROOT_ITEM 0)
node 3317809152 level 1 items 7 free 486 generation 81 owner 7
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    key (EXTENT_CSUM EXTENT_CSUM 2354839552) block 3317858304 (202506) gen 74
    key (EXTENT_CSUM EXTENT_CSUM 2371457024) block 3317874688 (202507) gen 74
    key (EXTENT_CSUM EXTENT_CSUM 2388074496) block 3317891072 (202508) gen 74
    key (EXTENT_CSUM EXTENT_CSUM 2404691968) block 3317907456 (202509) gen 74
    key (EXTENT_CSUM EXTENT_CSUM 2421309440) block 3317923840 (202510) gen 74
    key (EXTENT_CSUM EXTENT_CSUM 2437926912) block 3317940224 (202511) gen 74
    key (EXTENT_CSUM EXTENT_CSUM 2454544384) block 3317956608 (202512) gen 74
leaf 3317858304 items 1 free space 30 generation 74 owner 7
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (EXTENT_CSUM EXTENT_CSUM 2354839552) itemoff 55 itemsize 16228
        extent csum item
leaf 3317874688 items 1 free space 30 generation 74 owner 7
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (EXTENT_CSUM EXTENT_CSUM 2371457024) itemoff 55 itemsize 16228
        extent csum item
leaf 3317891072 items 1 free space 30 generation 74 owner 7
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (EXTENT_CSUM EXTENT_CSUM 2388074496) itemoff 55 itemsize 16228
        extent csum item
leaf 3317907456 items 1 free space 30 generation 74 owner 7
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (EXTENT_CSUM EXTENT_CSUM 2404691968) itemoff 55 itemsize 16228
        extent csum item
leaf 3317923840 items 1 free space 30 generation 74 owner 7
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (EXTENT_CSUM EXTENT_CSUM 2421309440) itemoff 55 itemsize 16228
        extent csum item
leaf 3317940224 items 1 free space 30 generation 74 owner 7
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (EXTENT_CSUM EXTENT_CSUM 2437926912) itemoff 55 itemsize 16228
        extent csum item
leaf 3317956608 items 1 free space 6106 generation 74 owner 7
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (EXTENT_CSUM EXTENT_CSUM 2454544384) itemoff 6131 itemsize 10152
        extent csum item
uuid tree key (UUID_TREE ROOT_ITEM 0)
leaf 3317743616 items 0 free space 16283 generation 58 owner 9
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0)
leaf 3318284288 items 2 free space 16061 generation 63 owner
18446744073709551607
fs uuid f25ca737-51e5-459a-b461-6a92f1909803
chunk uuid defe7881-e3d2-4ddd-b3b3-128bbfc4d351
    item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
        inode generation 3 transid 0 size 0 nbytes 16384
        block group 0 mode 40755 links 1 uid 0 gid 0
        rdev 0 flags 0x0
    item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
        inode ref index 0 namelen 2 name: ..
total bytes 1073741824000
bytes used 110870528
uuid f25ca737-51e5-459a-b461-6a92f1909803


## grab the logical address for the first node containing extent csum

[root@f23s ~]# btrfs-map-logical -l 3317858304 /dev/VG/b1
mirror 1 logical 3317858304 physical 3297935360 device /dev/mapper/VG-b2
mirror 2 logical 3317858304 physical 3317858304 device /dev/mapper/VG-b1

## identically corrupt both copies of the node checksum, first byte


[root@f23s ~]# printf '\xa1' | dd conv=notrunc of=/dev/VG/b2 bs=1
seek=3297935360
1+0 records in
1+0 records out
1 byte (1 B) copied, 0.0285455 s, 0.0 kB/s
[root@f23s ~]# printf '\xa1' | dd conv=notrunc of=/dev/VG/b1 bs=1
seek=3317858304
1+0 records in
1+0 records out
1 byte (1 B) copied, 0.0348683 s, 0.0 kB/s

## confirm the corruption

[root@f23s ~]# btrfs check /dev/VG/b1
Checking filesystem on /dev/VG/b1
UUID: f25ca737-51e5-459a-b461-6a92f1909803
checking extents
checksum verify failed on 3317858304 found EE51EFE0 wanted EE51EFA1
checksum verify failed on 3317858304 found EE51EFE0 wanted EE51EFA1
checksum verify failed on 3317858304 found EE51EFE0 wanted EE51EFA1
checksum verify failed on 3317858304 found EE51EFE0 wanted EE51EFA1
Csum didn't match
owner ref check failed [3317858304 16384]
checking free space cache
checking fs roots
checksum verify failed on 3317858304 found EE51EFE0 wanted EE51EFA1
checksum verify failed on 3317858304 found EE51EFE0 wanted EE51EFA1
checksum verify failed on 3317858304 found EE51EFE0 wanted EE51EFA1
checksum verify failed on 3317858304 found EE51EFE0 wanted EE51EFA1
Csum didn't match
found 110346242 bytes used err is 1
total csum bytes: 91292
total tree bytes: 229376
total fs tree bytes: 32768
total extent tree bytes: 16384
btree space waste bytes: 128945
file data blocks allocated: 110624768
 referenced 110624768


[root@f23s ~]# mount /dev/VG/b1 /mnt/0
[root@f23s ~]# sha256sum /mnt/0/openSUSE-Tumbleweed-NET-x86_64-Current.iso
455198311931e67f1fde04848f0d1d91978c4a7cc88e07c799d3fd67a218f5a6
/mnt/0/openSUSE-Tumbleweed-NET-x86_64-Current.iso


Why is the data in this file returning at all? Why does it return incorrectly?


-- 
Chris Murphy
