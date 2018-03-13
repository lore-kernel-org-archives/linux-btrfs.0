Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from services.gouders.net ([141.101.32.176]:43388 "EHLO
        services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbeCMOuC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 10:50:02 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: FS unmountable after RAID/LVM problems
In-Reply-To: <a9f30fd5-d044-2daa-0a52-085b02f258b1@gmx.com> (Qu Wenruo's
        message of "Tue, 13 Mar 2018 22:31:02 +0800")
References: <ghlgew5pbq.fsf@lena.gouders.net>
        <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
        <ghwoygxh77.fsf@lena.gouders.net>
        <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
        <ghsh94xfx9.fsf@lena.gouders.net>
        <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com>
        <gho9jsxdii.fsf@lena.gouders.net>
        <a9f30fd5-d044-2daa-0a52-085b02f258b1@gmx.com>
Date: Tue, 13 Mar 2018 15:49:53 +0100
Message-ID: <ghk1ugxc6m.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo <quwenruo.btrfs@gmx.com> writes:

> On 2018年03月13日 22:21, Dirk Gouders wrote:
>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>> 
>>> On 2018年03月13日 21:29, Dirk Gouders wrote:
>>>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>>>
>>>>> On 2018年03月13日 21:01, Dirk Gouders wrote:
>>>>>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>>>>>
>>>>>>> On 2018年03月13日 16:53, Dirk Gouders wrote:
>>>>>>
>>>>>> <SNIP>
>>>>>>
>>>>>>>> find-root:
>>>>>>>>
>>>>>>>> # btrfs-find-root /dev/loop0p1
>>>>>>>> Superblock thinks the generation is 9858294
>>>>>>>> Superblock thinks the level is 1
>>>>>>>> Found tree root at 848773120 gen 9858294 level 1
>>>>>>>
>>>>>>> Tree root is found, find-root won't help much here.
>>>>>>> And if it's really tree root corruption, we should have some kernel
>>>>>>> message for it.
>>>>>>>
>>>>>>>> Well block 832045056(gen: 9858272 level: 1) seems good, but generation/level doesn't match, want gen: 9858294 level: 1
>>>>>>>
>>>>>>> Especially when the next tree block is 22 generation older.
>>>>>>>
>>>>>>> Would you please try to call "btrfs inspect dump-tree <device>" and
>>>>>>> paste the result with *stderr*?
>>>>>>>
>>>>>>> At least we could know which tree block is corrupted.
>>>>>>
>>>>>> Here is the result of inspect:
>>>>>>
>>>>>> # btrfs inspect dump-tree /dev/loop0p1
>>>>>> btrfs-progs v4.15
>>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>>> checksum verify failed on 363069440 found DC09290B wanted C630FD61
>>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>>> bytenr mismatch, want=363069440, have=17552567724568668829
>>>>>> ERROR: unable to open /dev/loop0p1
>>>>>
>>>>> OK, one tree block in some important tree is corrupted.
>>>>>
>>>>> Would you please dump the super block by "btrfs inspect dump-super
>>>>> <device>" so that we could have some clue about where the corrupted tree
>>>>> block belongs?
>>>>
>>>> Yes, here is the requested output:
>>>
>>> Sorry, I forgot to add "-f" parameter for dump-super.
>>>
>>> So what we need is "btrfs inspect dump-super -f /dev/loop0p1".
>>>
>>>
>>> And, what's the version of btrfs-progs?
>>> IIRC the latest version of btrfs-progs has loosen the restriction on
>>> essential trees for "btrfs inspect dump-tree" if using '-b' option.
>>>
>>> So along with "dump-super -f" you could also try "btrfs inspect
>>> dump-tree -b <number> <device>"
>>> Where the number could be any "*_root" value.
>>> Like 20971520 (chunk_root) and 848773120 (root) to see if it works.
>> 
>> I am a bit lost ;-)  I translated "*_root value" to using both numbers,
>> please let me know if I should also use some other numbers.
>> 
>> The version of btrfs-progs is 4.15.
>> 
>> And here is more requested information:
>> 
>> # btrfs inspect dump-super -f /dev/loop0p1
>> superblock: bytenr=65536, device=/dev/loop0p1
>> ---------------------------------------------------------
>> csum_type               0 (crc32c)
>> csum_size               4
>> csum                    0x31998c61 [match]
>> bytenr                  65536
>> flags                   0x1
>>                         ( WRITTEN )
>> magic                   _BHRfS_M [match]
>> fsid                    a6459a90-ebe3-4c75-97f4-5496eadcc96f
>> label
>> generation              9858294
>> root                    848773120
>> sys_array_size          226
>> chunk_root_generation   18814
>> root_level              1
>> chunk_root              20971520
>> chunk_root_level        0
>> log_root                0
>> log_root_transid        0
>> log_root_level          0
>> total_bytes             10741612544
>> bytes_used              9141452800
>> sectorsize              4096
>> nodesize                16384
>> leafsize (deprecated)           16384
>> stripesize              4096
>> root_dir                6
>> num_devices             1
>> compat_flags            0x0
>> compat_ro_flags         0x0
>> incompat_flags          0x61
>>                         ( MIXED_BACKREF |
>>                           BIG_METADATA |
>>                           EXTENDED_IREF )
>> cache_generation        9858294
>> uuid_tree_generation    9824396
>> dev_item.uuid           b92bd216-a0bb-467d-8f8f-788f845af30c
>> dev_item.fsid           a6459a90-ebe3-4c75-97f4-5496eadcc96f [match]
>> dev_item.type           0
>> dev_item.total_bytes    10741612544
>> dev_item.bytes_used     10741612544
>> dev_item.io_align       4096
>> dev_item.io_width       4096
>> dev_item.sector_size    4096
>> dev_item.devid          1
>> dev_item.dev_group      0
>> dev_item.seek_speed     0
>> dev_item.bandwidth      0
>> dev_item.generation     0
>> sys_chunk_array[2048]:
>>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
>>                 length 4194304 owner 2 stripe_len 65536 type SYSTEM
>>                 io_align 4096 io_width 4096 sector_size 4096
>>                 num_stripes 1 sub_stripes 0
>>                         stripe 0 devid 1 offset 0
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>
> An old btrfs made by old mkfs.btrfs.
> Which still has the temporary chunk.
>
>>         item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
>>                 length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 2 sub_stripes 0
>>                         stripe 0 devid 1 offset 20971520
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>                         stripe 1 devid 1 offset 29360128
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>
> With this chunk item, it's clear that corrupted tree block doesn't
> belong to chunk tree.
>
>> backup_roots[4]:
>>         backup 0:
>>                 backup_tree_root:       848773120       gen: 9858294    level: 1
>>                 backup_chunk_root:      20971520        gen: 18814      level: 0
>>                 backup_extent_root:     848789504       gen: 9858294    level: 2
>>                 backup_fs_root:         850509824       gen: 9858293    level: 2
>>                 backup_dev_root:        30408704        gen: 9855433    level: 0
>>                 backup_csum_root:       75300864        gen: 9855436    level: 2
>>                 backup_total_bytes:     10741612544
>>                 backup_bytes_used:      9141452800
>>                 backup_num_devices:     1
>> 
>>         backup 1:
>>                 backup_tree_root:       848773120       gen: 9858291    level: 1
>>                 backup_chunk_root:      20971520        gen: 18814      level: 0
>>                 backup_extent_root:     847937536       gen: 9858291    level: 2
>>                 backup_fs_root:         845496320       gen: 9858291    level: 2
>>                 backup_dev_root:        30408704        gen: 9855433    level: 0
>>                 backup_csum_root:       75300864        gen: 9855436    level: 2
>>                 backup_total_bytes:     10741612544
>>                 backup_bytes_used:      9141436416
>>                 backup_num_devices:     1
>> 
>>         backup 2:
>>                 backup_tree_root:       848871424       gen: 9858292    level: 1
>>                 backup_chunk_root:      20971520        gen: 18814      level: 0
>>                 backup_extent_root:     847675392       gen: 9858292    level: 2
>>                 backup_fs_root:         849068032       gen: 9858293    level: 2
>>                 backup_dev_root:        30408704        gen: 9855433    level: 0
>>                 backup_csum_root:       75300864        gen: 9855436    level: 2
>>                 backup_total_bytes:     10741612544
>>                 backup_bytes_used:      9141436416
>>                 backup_num_devices:     1
>> 
>>         backup 3:
>>                 backup_tree_root:       852295680       gen: 9858293    level: 1
>>                 backup_chunk_root:      20971520        gen: 18814      level: 0
>>                 backup_extent_root:     849887232       gen: 9858293    level: 2
>>                 backup_fs_root:         850509824       gen: 9858293    level: 2
>>                 backup_dev_root:        30408704        gen: 9855433    level: 0
>>                 backup_csum_root:       75300864        gen: 9855436    level: 2
>>                 backup_total_bytes:     10741612544
>>                 backup_bytes_used:      9141452800
>>                 backup_num_devices:     1
>> 
>> # btrfs inspect dump-tree -b 20971520 /dev/loop0p1
>> btrfs-progs v4.15
>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>> checksum verify failed on 363069440 found DC09290B wanted C630FD61
>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>> bytenr mismatch, want=363069440, have=17552567724568668829
>> leaf 20971520 items 14 free space 14731 generation 18814 owner 3
>> leaf 20971520 flags 0x1(WRITTEN) backref revision 1
>> fs uuid a6459a90-ebe3-4c75-97f4-5496eadcc96f
>> chunk uuid 6f325a21-ce3e-4994-a638-b88ea82d504c
>>         item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
>>                 devid 1 total_bytes 10741612544 bytes_used 10741612544
>>                 io_align 4096 io_width 4096 sector_size 4096 type 0
>>                 generation 0 start_offset 0 dev_group 0
>>                 seek_speed 0 bandwidth 0
>>                 uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>                 fsid a6459a90-ebe3-4c75-97f4-5496eadcc96f
>>         item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 16105 itemsize 80
>>                 length 4194304 owner 2 stripe_len 65536 type SYSTEM
>>                 io_align 4096 io_width 4096 sector_size 4096
>>                 num_stripes 1 sub_stripes 0
>>                         stripe 0 devid 1 offset 0
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 16025 itemsize 80
>>                 length 8388608 owner 2 stripe_len 65536 type METADATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 0
>>                         stripe 0 devid 1 offset 4194304
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 15945 itemsize 80
>>                 length 8388608 owner 2 stripe_len 65536 type DATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 0
>>                         stripe 0 devid 1 offset 12582912
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 15833 itemsize 112
>>                 length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 2 sub_stripes 0
>>                         stripe 0 devid 1 offset 20971520
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>                         stripe 1 devid 1 offset 29360128
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 15721 itemsize 112
>>                 length 1073741824 owner 2 stripe_len 65536 type METADATA|DUP
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 2 sub_stripes 0
>>                         stripe 0 devid 1 offset 37748736
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>                         stripe 1 devid 1 offset 1111490560
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 1103101952) itemoff 15641 itemsize 80
>>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 1
>>                         stripe 0 devid 1 offset 2185232384
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 2176843776) itemoff 15561 itemsize 80
>>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 1
>>                         stripe 0 devid 1 offset 3258974208
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 8 key (FIRST_CHUNK_TREE CHUNK_ITEM 3250585600) itemoff 15481 itemsize 80
>>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 1
>>                         stripe 0 devid 1 offset 4332716032
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 9 key (FIRST_CHUNK_TREE CHUNK_ITEM 4324327424) itemoff 15401 itemsize 80
>>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 1
>>                         stripe 0 devid 1 offset 5406457856
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 10 key (FIRST_CHUNK_TREE CHUNK_ITEM 5398069248) itemoff 15321 itemsize 80
>>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 1
>>                         stripe 0 devid 1 offset 6480199680
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 11 key (FIRST_CHUNK_TREE CHUNK_ITEM 6471811072) itemoff 15241 itemsize 80
>>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 1
>>                         stripe 0 devid 1 offset 7553941504
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 12 key (FIRST_CHUNK_TREE CHUNK_ITEM 7545552896) itemoff 15161 itemsize 80
>>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 1
>>                         stripe 0 devid 1 offset 8627683328
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>>         item 13 key (FIRST_CHUNK_TREE CHUNK_ITEM 8619294720) itemoff 15081 itemsize 80
>>                 length 1040187392 owner 2 stripe_len 65536 type DATA
>>                 io_align 65536 io_width 65536 sector_size 4096
>>                 num_stripes 1 sub_stripes 1
>>                         stripe 0 devid 1 offset 9701425152
>>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>> 
>> # btrfs inspect dump-tree -b 848773120 /dev/loop0p1
>> btrfs-progs v4.15
>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>> checksum verify failed on 363069440 found DC09290B wanted C630FD61
>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>> bytenr mismatch, want=363069440, have=17552567724568668829
>> node 848773120 level 1 items 2 free 491 generation 9858294 owner 1
>> fs uuid a6459a90-ebe3-4c75-97f4-5496eadcc96f
>> chunk uuid 6f325a21-ce3e-4994-a638-b88ea82d504c
>>         key (EXTENT_TREE ROOT_ITEM 0) block 848986112 (51818) gen 9858294
>>         key (346 ROOT_ITEM 18671) block 72089600 (4400) gen 9728190
>
> And also not a tree block of root tree.
>
> It may be extent tree, and if that's the case, we may enhance
> btrfs-restore to handle it.
> Please dump the following info.
>
> # btrfs inspect dump-tree -b 848986112 /dev/loop0p1
> # btrfs inspect dump-tree -b 72089600 /dev/loop0p1

OK.

(This mail gets a bit long but I don't want to snip probably important
 information above.)

# btrfs inspect dump-tree -b 848986112 /dev/loop0p1
btrfs-progs v4.15
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found DC09290B wanted C630FD61
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
bytenr mismatch, want=363069440, have=17552567724568668829
leaf 848986112 items 71 free space 3562 generation 9858294 owner 1
leaf 848986112 flags 0x1(WRITTEN) backref revision 1
fs uuid a6459a90-ebe3-4c75-97f4-5496eadcc96f
chunk uuid 6f325a21-ce3e-4994-a638-b88ea82d504c
        item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 439
                generation 9858294 root_dirid 0 bytenr 848789504 level 2 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16531456 flags 0x0(none)
                uuid 00000000-0000-0000-0000-000000000000
                drop key (0 UNKNOWN.0 0) level 0
        item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 15405 itemsize 439
                generation 9855433 root_dirid 0 bytenr 30408704 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid 00000000-0000-0000-0000-000000000000
                drop key (0 UNKNOWN.0 0) level 0
        item 2 key (FS_TREE INODE_REF 6) itemoff 15388 itemsize 17
                index 0 namelen 7 name: default
        item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
                generation 9858293 root_dirid 256 bytenr 850509824 level 2 refs 1
                lastsnap 263791 byte_limit 0 bytes_used 213549056 flags 0x0(none)
                uuid 00000000-0000-0000-0000-000000000000
                ctransid 9858293 otransid 0 stransid 0 rtransid 0
                ctime 1519807754.115000000 (2018-02-28 09:49:14)
                drop key (0 UNKNOWN.0 0) level 0
        item 4 key (FS_TREE ROOT_REF 257) itemoff 14924 itemsize 25
                root ref key dirid 258 sequence 2 name i386-pc
        item 5 key (FS_TREE ROOT_REF 258) itemoff 14896 itemsize 28
                root ref key dirid 258 sequence 3 name x86_64-efi
        item 6 key (FS_TREE ROOT_REF 259) itemoff 14875 itemsize 21
                root ref key dirid 256 sequence 3 name opt
        item 7 key (FS_TREE ROOT_REF 260) itemoff 14854 itemsize 21
                root ref key dirid 256 sequence 4 name srv
        item 8 key (FS_TREE ROOT_REF 261) itemoff 14833 itemsize 21
                root ref key dirid 256 sequence 5 name tmp
        item 9 key (FS_TREE ROOT_REF 262) itemoff 14810 itemsize 23
                root ref key dirid 259 sequence 2 name local
        item 10 key (FS_TREE ROOT_REF 263) itemoff 14787 itemsize 23
                root ref key dirid 260 sequence 2 name crash
        item 11 key (FS_TREE ROOT_REF 264) itemoff 14762 itemsize 25
                root ref key dirid 261 sequence 2 name mailman
        item 12 key (FS_TREE ROOT_REF 265) itemoff 14739 itemsize 23
                root ref key dirid 261 sequence 3 name named
        item 13 key (FS_TREE ROOT_REF 266) itemoff 14716 itemsize 23
                root ref key dirid 261 sequence 4 name pgsql
        item 14 key (FS_TREE ROOT_REF 267) itemoff 14695 itemsize 21
                root ref key dirid 260 sequence 4 name log
        item 15 key (FS_TREE ROOT_REF 268) itemoff 14674 itemsize 21
                root ref key dirid 260 sequence 5 name opt
        item 16 key (FS_TREE ROOT_REF 269) itemoff 14651 itemsize 23
                root ref key dirid 260 sequence 6 name spool
        item 17 key (FS_TREE ROOT_REF 270) itemoff 14630 itemsize 21
                root ref key dirid 260 sequence 7 name tmp
        item 18 key (FS_TREE ROOT_REF 275) itemoff 14602 itemsize 28
                root ref key dirid 256 sequence 22 name .snapshots
        item 19 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 14442 itemsize 160
                generation 3 transid 0 size 0 nbytes 16384
                block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
                sequence 0 flags 0x0(none)
                atime 1446716178.0 (2015-11-05 10:36:18)
                ctime 1446716178.0 (2015-11-05 10:36:18)
                mtime 1446716178.0 (2015-11-05 10:36:18)
                otime 0.0 (1970-01-01 01:00:00)
        item 20 key (ROOT_TREE_DIR INODE_REF 6) itemoff 14430 itemsize 12
                index 0 namelen 2 name: ..
        item 21 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 14393 itemsize 37
                location key (FS_TREE ROOT_ITEM -1) type DIR
                transid 0 data_len 0 name_len 7
                name: default
        item 22 key (CSUM_TREE ROOT_ITEM 0) itemoff 13954 itemsize 439
                generation 9855436 root_dirid 0 bytenr 75300864 level 2 refs 1
                lastsnap 0 byte_limit 0 bytes_used 9895936 flags 0x0(none)
                uuid 00000000-0000-0000-0000-000000000000
                drop key (0 UNKNOWN.0 0) level 0
        item 23 key (UUID_TREE ROOT_ITEM 0) itemoff 13515 itemsize 439
                generation 263946 root_dirid 0 bytenr 212353024 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid 450142b8-aff3-7043-946f-07f2297053de
                drop key (0 UNKNOWN.0 0) level 0
        item 24 key (256 INODE_ITEM 0) itemoff 13355 itemsize 160
                generation 0 transid 9858294 size 0 nbytes 61294247936
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 27 flags 0x3915b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 01:00:00)
                ctime 1474991460.474000000 (2016-09-27 17:51:00)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)
        item 25 key (257 ROOT_ITEM 0) itemoff 12916 itemsize 439
                generation 9855434 root_dirid 256 bytenr 48955392 level 1 refs 1
                lastsnap 0 byte_limit 0 bytes_used 524288 flags 0x0(none)
                uuid 9eedce31-5bef-bf4a-a25b-bdf0b0801397
                ctransid 9855434 otransid 6 stransid 0 rtransid 0
                ctime 1519632969.856000000 (2018-02-26 09:16:09)
                otime 1446716178.880000000 (2015-11-05 10:36:18)
                drop key (0 UNKNOWN.0 0) level 0
        item 26 key (257 ROOT_BACKREF 5) itemoff 12891 itemsize 25
                root backref key dirid 258 sequence 2 name i386-pc
        item 27 key (258 ROOT_ITEM 0) itemoff 12452 itemsize 439
                generation 9855434 root_dirid 256 bytenr 48660480 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid 2419d0ab-9fa7-414d-a0d4-9df016ea2dfb
                ctransid 9855434 otransid 7 stransid 0 rtransid 0
                ctime 1519632969.789000000 (2018-02-26 09:16:09)
                otime 1446716178.932000000 (2015-11-05 10:36:18)
                drop key (0 UNKNOWN.0 0) level 0
        item 28 key (258 ROOT_BACKREF 5) itemoff 12424 itemsize 28
                root backref key dirid 258 sequence 3 name x86_64-efi
        item 29 key (259 ROOT_ITEM 0) itemoff 11985 itemsize 439
                generation 9855434 root_dirid 256 bytenr 47218688 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid ee509c20-1869-4a40-88bf-55bb7fa9f155
                ctransid 9855434 otransid 8 stransid 0 rtransid 0
                ctime 1519632969.589000000 (2018-02-26 09:16:09)
                otime 1446716178.988000000 (2015-11-05 10:36:18)
                drop key (0 UNKNOWN.0 0) level 0
        item 30 key (259 ROOT_BACKREF 5) itemoff 11964 itemsize 21
                root backref key dirid 256 sequence 3 name opt
        item 31 key (260 ROOT_ITEM 0) itemoff 11525 itemsize 439
                generation 9855434 root_dirid 256 bytenr 47071232 level 1 refs 1
                lastsnap 0 byte_limit 0 bytes_used 2244608 flags 0x0(none)
                uuid 34b5a192-fba4-d14f-9fc7-86f4826479c7
                ctransid 9855434 otransid 9 stransid 0 rtransid 0
                ctime 1519632969.481000000 (2018-02-26 09:16:09)
                otime 1446716179.40000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 32 key (260 ROOT_BACKREF 5) itemoff 11504 itemsize 21
                root backref key dirid 256 sequence 4 name srv
        item 33 key (261 ROOT_ITEM 0) itemoff 11065 itemsize 439
                generation 9858293 root_dirid 256 bytenr 851296256 level 1 refs 1
                lastsnap 0 byte_limit 0 bytes_used 49152 flags 0x0(none)
                uuid 0b5abe51-1fdf-924f-9606-6c784177e94f
                ctransid 9858293 otransid 10 stransid 0 rtransid 0
                ctime 1519807748.323000000 (2018-02-28 09:49:08)
                otime 1446716179.92000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 34 key (261 ROOT_BACKREF 5) itemoff 11044 itemsize 21
                root backref key dirid 256 sequence 5 name tmp
        item 35 key (262 ROOT_ITEM 0) itemoff 10605 itemsize 439
                generation 9855434 root_dirid 256 bytenr 46940160 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid 98b4c35b-18fb-7947-8471-d651ca5f5e0f
                ctransid 9855434 otransid 11 stransid 0 rtransid 0
                ctime 1519632969.228000000 (2018-02-26 09:16:09)
                otime 1446716179.140000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 36 key (262 ROOT_BACKREF 5) itemoff 10582 itemsize 23
                root backref key dirid 259 sequence 2 name local
        item 37 key (263 ROOT_ITEM 0) itemoff 10143 itemsize 439
                generation 9855434 root_dirid 256 bytenr 46891008 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid 5645bb42-8c99-0d47-8129-a2ca05f51fe2
                ctransid 9855434 otransid 12 stransid 0 rtransid 0
                ctime 1519632969.226000000 (2018-02-26 09:16:09)
                otime 1446716179.196000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 38 key (263 ROOT_BACKREF 5) itemoff 10120 itemsize 23
                root backref key dirid 260 sequence 2 name crash
        item 39 key (264 ROOT_ITEM 0) itemoff 9681 itemsize 439
                generation 9855434 root_dirid 256 bytenr 46776320 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid ffd3602c-e9c5-4a45-adb7-91ffc602ddfe
                ctransid 9855434 otransid 13 stransid 0 rtransid 0
                ctime 1519632969.207000000 (2018-02-26 09:16:09)
                otime 1446716179.240000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 40 key (264 ROOT_BACKREF 5) itemoff 9656 itemsize 25
                root backref key dirid 261 sequence 2 name mailman
        item 41 key (265 ROOT_ITEM 0) itemoff 9217 itemsize 439
                generation 9855434 root_dirid 256 bytenr 46645248 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid 921707e6-ca55-c64b-ae92-151f72877eb7
                ctransid 9855434 otransid 14 stransid 0 rtransid 0
                ctime 1519632969.43000000 (2018-02-26 09:16:09)
                otime 1446716179.292000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 42 key (265 ROOT_BACKREF 5) itemoff 9194 itemsize 23
                root backref key dirid 261 sequence 3 name named
        item 43 key (266 ROOT_ITEM 0) itemoff 8755 itemsize 439
                generation 9855434 root_dirid 256 bytenr 46497792 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid c5088517-54c8-0e48-b117-d83eb265d310
                ctransid 9855434 otransid 15 stransid 0 rtransid 0
                ctime 1519632968.681000000 (2018-02-26 09:16:08)
                otime 1446716179.348000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 44 key (266 ROOT_BACKREF 5) itemoff 8732 itemsize 23
                root backref key dirid 261 sequence 4 name pgsql
        item 45 key (267 ROOT_ITEM 0) itemoff 8293 itemsize 439
                generation 9858293 root_dirid 256 bytenr 850477056 level 1 refs 1
                lastsnap 0 byte_limit 0 bytes_used 720896 flags 0x0(none)
                uuid 4bdce6a2-7c29-e34f-9093-069814030702
                ctransid 9858293 otransid 16 stransid 0 rtransid 0
                ctime 1519807753.828000000 (2018-02-28 09:49:13)
                otime 1446716179.392000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 46 key (267 ROOT_BACKREF 5) itemoff 8272 itemsize 21
                root backref key dirid 260 sequence 4 name log
        item 47 key (268 ROOT_ITEM 0) itemoff 7833 itemsize 439
                generation 9855434 root_dirid 256 bytenr 46202880 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid 0ccd97bc-ec14-8741-b9a4-4759a53da090
                ctransid 9855434 otransid 17 stransid 0 rtransid 0
                ctime 1519632968.203000000 (2018-02-26 09:16:08)
                otime 1446716179.436000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 48 key (268 ROOT_BACKREF 5) itemoff 7812 itemsize 21
                root backref key dirid 260 sequence 5 name opt
        item 49 key (269 ROOT_ITEM 0) itemoff 7373 itemsize 439
                generation 9858288 root_dirid 256 bytenr 847282176 level 1 refs 1
                lastsnap 0 byte_limit 0 bytes_used 49152 flags 0x0(none)
                uuid c9ae2b48-c019-4743-acdf-bd2920044351
                ctransid 9858288 otransid 18 stransid 0 rtransid 0
                ctime 1519807501.838000000 (2018-02-28 09:45:01)
                otime 1446716179.472000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 50 key (269 ROOT_BACKREF 5) itemoff 7350 itemsize 23
                root backref key dirid 260 sequence 6 name spool
        item 51 key (270 ROOT_ITEM 0) itemoff 6911 itemsize 439
                generation 9858274 root_dirid 256 bytenr 844120064 level 2 refs 1
                lastsnap 0 byte_limit 0 bytes_used 24772608 flags 0x0(none)
                uuid edf076de-cdfe-4147-80a5-c10b801b8bd1
                ctransid 9858274 otransid 19 stransid 0 rtransid 0
                ctime 1519806635.707000000 (2018-02-28 09:30:35)
                otime 1446716179.516000000 (2015-11-05 10:36:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 52 key (270 ROOT_BACKREF 5) itemoff 6890 itemsize 21
                root backref key dirid 260 sequence 7 name tmp
        item 53 key (271 INODE_ITEM 0) itemoff 6730 itemsize 160
                generation 0 transid 9855436 size 0 nbytes 27693678592
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 27 flags 0x19cab(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 01:00:00)
                ctime 1474990771.256000000 (2016-09-27 17:39:31)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)
        item 54 key (272 INODE_ITEM 0) itemoff 6570 itemsize 160
                generation 0 transid 273541 size 0 nbytes 7124811776
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 27 flags 0x6a2b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 01:00:00)
                ctime 1459940562.293000000 (2016-04-06 13:02:42)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)
        item 55 key (273 INODE_ITEM 0) itemoff 6410 itemsize 160
                generation 0 transid 9728190 size 0 nbytes 8831369216
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 27 flags 0x8399(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 01:00:00)
                ctime 1474991460.474000000 (2016-09-27 17:51:00)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)
        item 56 key (274 INODE_ITEM 0) itemoff 6250 itemsize 160
                generation 0 transid 9855436 size 0 nbytes 44692144128
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 27 flags 0x299f7(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 01:00:00)
                ctime 1474990707.660000000 (2016-09-27 17:38:27)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)
        item 57 key (275 ROOT_ITEM 0) itemoff 5811 itemsize 439
                generation 9858273 root_dirid 256 bytenr 842039296 level 1 refs 1
                lastsnap 0 byte_limit 0 bytes_used 49152 flags 0x0(none)
                uuid bb3970e5-bb33-8b4c-a15e-634d3d943ce4
                ctransid 9858273 otransid 39 stransid 0 rtransid 0
                ctime 1519806602.240000000 (2018-02-28 09:30:02)
                otime 1446716730.796000000 (2015-11-05 10:45:30)
                drop key (0 UNKNOWN.0 0) level 0
        item 58 key (275 ROOT_BACKREF 5) itemoff 5783 itemsize 28
                root backref key dirid 256 sequence 22 name .snapshots
        item 59 key (275 ROOT_REF 346) itemoff 5757 itemsize 26
                root ref key dirid 634 sequence 2 name snapshot
        item 60 key (275 ROOT_REF 349) itemoff 5731 itemsize 26
                root ref key dirid 640 sequence 2 name snapshot
        item 61 key (275 ROOT_REF 374) itemoff 5705 itemsize 26
                root ref key dirid 775 sequence 2 name snapshot
        item 62 key (275 ROOT_REF 375) itemoff 5679 itemsize 26
                root ref key dirid 779 sequence 2 name snapshot
        item 63 key (275 ROOT_REF 376) itemoff 5653 itemsize 26
                root ref key dirid 784 sequence 2 name snapshot
        item 64 key (275 ROOT_REF 377) itemoff 5627 itemsize 26
                root ref key dirid 788 sequence 2 name snapshot
        item 65 key (275 ROOT_REF 378) itemoff 5601 itemsize 26
                root ref key dirid 793 sequence 2 name snapshot
        item 66 key (275 ROOT_REF 379) itemoff 5575 itemsize 26
                root ref key dirid 797 sequence 2 name snapshot
        item 67 key (275 ROOT_REF 380) itemoff 5549 itemsize 26
                root ref key dirid 803 sequence 2 name snapshot
        item 68 key (275 ROOT_REF 381) itemoff 5523 itemsize 26
                root ref key dirid 808 sequence 2 name snapshot
        item 69 key (275 ROOT_REF 382) itemoff 5497 itemsize 26
                root ref key dirid 816 sequence 2 name snapshot
        item 70 key (276 INODE_ITEM 0) itemoff 5337 itemsize 160
                generation 0 transid 9691852 size 0 nbytes 1272446976
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 27 flags 0x12f6(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 01:00:00)
                ctime 1474991095.943000000 (2016-09-27 17:44:55)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)

# btrfs inspect dump-tree -b 72089600 /dev/loop0p1 
btrfs-progs v4.15
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found DC09290B wanted C630FD61
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
bytenr mismatch, want=363069440, have=17552567724568668829
leaf 72089600 items 35 free space 9005 generation 9728190 owner 1
leaf 72089600 flags 0x1(WRITTEN) backref revision 1
fs uuid a6459a90-ebe3-4c75-97f4-5496eadcc96f
chunk uuid 6f325a21-ce3e-4994-a638-b88ea82d504c
        item 0 key (346 ROOT_ITEM 18671) itemoff 15844 itemsize 439
                generation 18672 root_dirid 256 bytenr 1066942464 level 2 refs 1
                lastsnap 18671 byte_limit 0 bytes_used 194658304 flags 0x1(RDONLY)
                uuid cb7deeb6-0cc1-f84a-9327-727fd2744eed
                ctransid 18671 otransid 18671 stransid 0 rtransid 0
                ctime 1447754576.356000000 (2015-11-17 11:02:56)
                otime 1447754576.972000000 (2015-11-17 11:02:56)
                drop key (0 UNKNOWN.0 0) level 0
        item 1 key (346 ROOT_BACKREF 275) itemoff 15818 itemsize 26
                root backref key dirid 634 sequence 2 name snapshot
        item 2 key (347 INODE_ITEM 0) itemoff 15658 itemsize 160
                generation 0 transid 9691911 size 0 nbytes 1610350592
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 27 flags 0x17ff(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 01:00:00)
                ctime 1474990707.660000000 (2016-09-27 17:38:27)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)
        item 3 key (348 INODE_ITEM 0) itemoff 15498 itemsize 160
                generation 0 transid 297737 size 0 nbytes 2159542272
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 27 flags 0x202e(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 01:00:00)
                ctime 1474991460.474000000 (2016-09-27 17:51:00)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)
        item 4 key (349 ROOT_ITEM 18769) itemoff 15059 itemsize 439
                generation 18770 root_dirid 256 bytenr 964427776 level 2 refs 1
                lastsnap 18769 byte_limit 0 bytes_used 205062144 flags 0x1(RDONLY)
                uuid 979db73c-6233-3d49-adfe-41df7945174a
                ctransid 18769 otransid 18769 stransid 0 rtransid 0
                ctime 1447757948.615000000 (2015-11-17 11:59:08)
                otime 1447757948.651000000 (2015-11-17 11:59:08)
                drop key (0 UNKNOWN.0 0) level 0
        item 5 key (349 ROOT_BACKREF 275) itemoff 15033 itemsize 26
                root backref key dirid 640 sequence 2 name snapshot
        item 6 key (351 INODE_ITEM 0) itemoff 14873 itemsize 160
                generation 0 transid 9728190 size 0 nbytes 1013121024
                block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                sequence 27 flags 0x1421(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 01:00:00)
                ctime 1474991195.376000000 (2016-09-27 17:46:35)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)
        item 7 key (374 ROOT_ITEM 29547) itemoff 14434 itemsize 439
                generation 29547 root_dirid 256 bytenr 870629376 level 2 refs 1
                lastsnap 29547 byte_limit 0 bytes_used 213336064 flags 0x1(RDONLY)
                uuid 54ec24e0-01e5-b143-ad02-e79cb0109047
                ctransid 29547 otransid 29547 stransid 0 rtransid 0
                ctime 1448377634.207000000 (2015-11-24 16:07:14)
                otime 1448377634.265000000 (2015-11-24 16:07:14)
                drop key (0 UNKNOWN.0 0) level 0
        item 8 key (374 ROOT_BACKREF 275) itemoff 14408 itemsize 26
                root backref key dirid 775 sequence 2 name snapshot
        item 9 key (375 ROOT_ITEM 29550) itemoff 13969 itemsize 439
                generation 29550 root_dirid 256 bytenr 882671616 level 2 refs 1
                lastsnap 29550 byte_limit 0 bytes_used 213352448 flags 0x1(RDONLY)
                uuid 0266a5f7-1043-af44-b81e-92a879169e1e
                ctransid 29550 otransid 29550 stransid 0 rtransid 0
                ctime 1448377708.259000000 (2015-11-24 16:08:28)
                otime 1448377708.785000000 (2015-11-24 16:08:28)
                drop key (0 UNKNOWN.0 0) level 0
        item 10 key (375 ROOT_BACKREF 275) itemoff 13943 itemsize 26
                root backref key dirid 779 sequence 2 name snapshot
        item 11 key (376 ROOT_ITEM 30944) itemoff 13504 itemsize 439
                generation 30944 root_dirid 256 bytenr 470810624 level 2 refs 1
                lastsnap 30944 byte_limit 0 bytes_used 213352448 flags 0x1(RDONLY)
                uuid 8e1c7595-8eed-8e43-b267-a54f89b586dc
                ctransid 30892 otransid 30944 stransid 0 rtransid 0
                ctime 1448456402.3000000 (2015-11-25 14:00:02)
                otime 1448459396.15000000 (2015-11-25 14:49:56)
                drop key (0 UNKNOWN.0 0) level 0
        item 12 key (376 ROOT_BACKREF 275) itemoff 13478 itemsize 26
                root backref key dirid 784 sequence 2 name snapshot
        item 13 key (377 ROOT_ITEM 30960) itemoff 13039 itemsize 439
                generation 30960 root_dirid 256 bytenr 491372544 level 2 refs 1
                lastsnap 30960 byte_limit 0 bytes_used 213352448 flags 0x1(RDONLY)
                uuid 9a515eda-2a4c-bd47-894b-6ddf8e714f55
                ctransid 30960 otransid 30960 stransid 0 rtransid 0
                ctime 1448459878.906000000 (2015-11-25 14:57:58)
                otime 1448459881.717000000 (2015-11-25 14:58:01)
                drop key (0 UNKNOWN.0 0) level 0
        item 14 key (377 ROOT_BACKREF 275) itemoff 13013 itemsize 26
                root backref key dirid 788 sequence 2 name snapshot
        item 15 key (378 ROOT_ITEM 227145) itemoff 12574 itemsize 439
                generation 227145 root_dirid 256 bytenr 874496000 level 2 refs 1
                lastsnap 227145 byte_limit 0 bytes_used 213401600 flags 0x1(RDONLY)
                uuid 471c2b44-6b45-f744-8612-654effab326c
                ctransid 227145 otransid 227145 stransid 0 rtransid 0
                ctime 1459930839.575000000 (2016-04-06 10:20:39)
                otime 1459930839.671000000 (2016-04-06 10:20:39)
                drop key (0 UNKNOWN.0 0) level 0
        item 16 key (378 ROOT_BACKREF 275) itemoff 12548 itemsize 26
                root backref key dirid 793 sequence 2 name snapshot
        item 17 key (379 ROOT_ITEM 227148) itemoff 12109 itemsize 439
                generation 227148 root_dirid 256 bytenr 874561536 level 2 refs 1
                lastsnap 227148 byte_limit 0 bytes_used 213401600 flags 0x1(RDONLY)
                uuid 356acc7b-459e-f644-a4b9-ab1fa30736a0
                ctransid 227148 otransid 227148 stransid 0 rtransid 0
                ctime 1459930925.758000000 (2016-04-06 10:22:05)
                otime 1459930925.763000000 (2016-04-06 10:22:05)
                drop key (0 UNKNOWN.0 0) level 0
        item 18 key (379 ROOT_BACKREF 275) itemoff 12083 itemsize 26
                root backref key dirid 797 sequence 2 name snapshot
        item 19 key (380 ROOT_ITEM 227149) itemoff 11644 itemsize 439
                generation 227150 root_dirid 256 bytenr 886030336 level 2 refs 1
                lastsnap 227149 byte_limit 0 bytes_used 213450752 flags 0x1(RDONLY)
                uuid 82cfac93-56f1-104b-87e7-b61a6c759404
                ctransid 227149 otransid 227149 stransid 0 rtransid 0
                ctime 1459930939.604000000 (2016-04-06 10:22:19)
                otime 1459930939.772000000 (2016-04-06 10:22:19)
                drop key (0 UNKNOWN.0 0) level 0
        item 20 key (380 ROOT_BACKREF 275) itemoff 11618 itemsize 26
                root backref key dirid 803 sequence 2 name snapshot
        item 21 key (381 ROOT_ITEM 227173) itemoff 11179 itemsize 439
                generation 227173 root_dirid 256 bytenr 992591872 level 2 refs 1
                lastsnap 227173 byte_limit 0 bytes_used 213450752 flags 0x1(RDONLY)
                uuid 74988136-529e-0d4c-aade-25560036171e
                ctransid 227173 otransid 227173 stransid 0 rtransid 0
                ctime 1459931730.628000000 (2016-04-06 10:35:30)
                otime 1459931731.184000000 (2016-04-06 10:35:31)
                drop key (0 UNKNOWN.0 0) level 0
        item 22 key (381 ROOT_BACKREF 275) itemoff 11153 itemsize 26
                root backref key dirid 808 sequence 2 name snapshot
        item 23 key (382 ROOT_ITEM 253660) itemoff 10714 itemsize 439
                generation 253660 root_dirid 256 bytenr 947126272 level 2 refs 1
                lastsnap 253660 byte_limit 0 bytes_used 213745664 flags 0x1(RDONLY)
                uuid 7b1631e5-fe02-5044-ab0d-23405434db50
                ctransid 253660 otransid 253660 stransid 0 rtransid 0
                ctime 1459940654.929000000 (2016-04-06 13:04:14)
                otime 1459940654.932000000 (2016-04-06 13:04:14)
                drop key (0 UNKNOWN.0 0) level 0
        item 24 key (382 ROOT_BACKREF 275) itemoff 10688 itemsize 26
                root backref key dirid 816 sequence 2 name snapshot
        item 25 key (FREE_SPACE UNTYPED 29360128) itemoff 10647 itemsize 41
                location key (256 INODE_ITEM 0)
                cache generation 269825 entries 21 bitmaps 8
        item 26 key (FREE_SPACE UNTYPED 1103101952) itemoff 10606 itemsize 41
                location key (271 INODE_ITEM 0)
                cache generation 269716 entries 4 bitmaps 0
        item 27 key (FREE_SPACE UNTYPED 2176843776) itemoff 10565 itemsize 41
                location key (272 INODE_ITEM 0)
                cache generation 253653 entries 2 bitmaps 0
        item 28 key (FREE_SPACE UNTYPED 3250585600) itemoff 10524 itemsize 41
                location key (273 INODE_ITEM 0)
                cache generation 269825 entries 3 bitmaps 0
        item 29 key (FREE_SPACE UNTYPED 4324327424) itemoff 10483 itemsize 41
                location key (274 INODE_ITEM 0)
                cache generation 269714 entries 4 bitmaps 0
        item 30 key (FREE_SPACE UNTYPED 5398069248) itemoff 10442 itemsize 41
                location key (276 INODE_ITEM 0)
                cache generation 269775 entries 6 bitmaps 0
        item 31 key (FREE_SPACE UNTYPED 6471811072) itemoff 10401 itemsize 41
                location key (347 INODE_ITEM 0)
                cache generation 269714 entries 12 bitmaps 0
        item 32 key (FREE_SPACE UNTYPED 7545552896) itemoff 10360 itemsize 41
                location key (348 INODE_ITEM 0)
                cache generation 269825 entries 31 bitmaps 0
        item 33 key (FREE_SPACE UNTYPED 8619294720) itemoff 10319 itemsize 41
                location key (351 INODE_ITEM 0)
                cache generation 269820 entries 34 bitmaps 0
        item 34 key (DATA_RELOC_TREE ROOT_ITEM 0) itemoff 9880 itemsize 439
                generation 4 root_dirid 256 bytenr 29442048 level 0 refs 1
                lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
                uuid 00000000-0000-0000-0000-000000000000
                drop key (0 UNKNOWN.0 0) level 0

Thanks,

Dirk
