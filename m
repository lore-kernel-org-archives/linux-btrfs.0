Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from services.gouders.net ([141.101.32.176]:47335 "EHLO
        services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbeCMOVS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 10:21:18 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: FS unmountable after RAID/LVM problems
In-Reply-To: <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com> (Qu Wenruo's
        message of "Tue, 13 Mar 2018 21:44:28 +0800")
References: <ghlgew5pbq.fsf@lena.gouders.net>
        <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
        <ghwoygxh77.fsf@lena.gouders.net>
        <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
        <ghsh94xfx9.fsf@lena.gouders.net>
        <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com>
Date: Tue, 13 Mar 2018 15:21:09 +0100
Message-ID: <gho9jsxdii.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo <quwenruo.btrfs@gmx.com> writes:

> On 2018年03月13日 21:29, Dirk Gouders wrote:
>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>> 
>>> On 2018年03月13日 21:01, Dirk Gouders wrote:
>>>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>>>
>>>>> On 2018年03月13日 16:53, Dirk Gouders wrote:
>>>>
>>>> <SNIP>
>>>>
>>>>>> find-root:
>>>>>>
>>>>>> # btrfs-find-root /dev/loop0p1
>>>>>> Superblock thinks the generation is 9858294
>>>>>> Superblock thinks the level is 1
>>>>>> Found tree root at 848773120 gen 9858294 level 1
>>>>>
>>>>> Tree root is found, find-root won't help much here.
>>>>> And if it's really tree root corruption, we should have some kernel
>>>>> message for it.
>>>>>
>>>>>> Well block 832045056(gen: 9858272 level: 1) seems good, but generation/level doesn't match, want gen: 9858294 level: 1
>>>>>
>>>>> Especially when the next tree block is 22 generation older.
>>>>>
>>>>> Would you please try to call "btrfs inspect dump-tree <device>" and
>>>>> paste the result with *stderr*?
>>>>>
>>>>> At least we could know which tree block is corrupted.
>>>>
>>>> Here is the result of inspect:
>>>>
>>>> # btrfs inspect dump-tree /dev/loop0p1
>>>> btrfs-progs v4.15
>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>> checksum verify failed on 363069440 found DC09290B wanted C630FD61
>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>> bytenr mismatch, want=363069440, have=17552567724568668829
>>>> ERROR: unable to open /dev/loop0p1
>>>
>>> OK, one tree block in some important tree is corrupted.
>>>
>>> Would you please dump the super block by "btrfs inspect dump-super
>>> <device>" so that we could have some clue about where the corrupted tree
>>> block belongs?
>> 
>> Yes, here is the requested output:
>
> Sorry, I forgot to add "-f" parameter for dump-super.
>
> So what we need is "btrfs inspect dump-super -f /dev/loop0p1".
>
>
> And, what's the version of btrfs-progs?
> IIRC the latest version of btrfs-progs has loosen the restriction on
> essential trees for "btrfs inspect dump-tree" if using '-b' option.
>
> So along with "dump-super -f" you could also try "btrfs inspect
> dump-tree -b <number> <device>"
> Where the number could be any "*_root" value.
> Like 20971520 (chunk_root) and 848773120 (root) to see if it works.

I am a bit lost ;-)  I translated "*_root value" to using both numbers,
please let me know if I should also use some other numbers.

The version of btrfs-progs is 4.15.

And here is more requested information:

# btrfs inspect dump-super -f /dev/loop0p1
superblock: bytenr=65536, device=/dev/loop0p1
---------------------------------------------------------
csum_type               0 (crc32c)
csum_size               4
csum                    0x31998c61 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    a6459a90-ebe3-4c75-97f4-5496eadcc96f
label
generation              9858294
root                    848773120
sys_array_size          226
chunk_root_generation   18814
root_level              1
chunk_root              20971520
chunk_root_level        0
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             10741612544
bytes_used              9141452800
sectorsize              4096
nodesize                16384
leafsize (deprecated)           16384
stripesize              4096
root_dir                6
num_devices             1
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x61
                        ( MIXED_BACKREF |
                          BIG_METADATA |
                          EXTENDED_IREF )
cache_generation        9858294
uuid_tree_generation    9824396
dev_item.uuid           b92bd216-a0bb-467d-8f8f-788f845af30c
dev_item.fsid           a6459a90-ebe3-4c75-97f4-5496eadcc96f [match]
dev_item.type           0
dev_item.total_bytes    10741612544
dev_item.bytes_used     10741612544
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
                length 4194304 owner 2 stripe_len 65536 type SYSTEM
                io_align 4096 io_width 4096 sector_size 4096
                num_stripes 1 sub_stripes 0
                        stripe 0 devid 1 offset 0
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
                length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 2 sub_stripes 0
                        stripe 0 devid 1 offset 20971520
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
                        stripe 1 devid 1 offset 29360128
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
backup_roots[4]:
        backup 0:
                backup_tree_root:       848773120       gen: 9858294    level: 1
                backup_chunk_root:      20971520        gen: 18814      level: 0
                backup_extent_root:     848789504       gen: 9858294    level: 2
                backup_fs_root:         850509824       gen: 9858293    level: 2
                backup_dev_root:        30408704        gen: 9855433    level: 0
                backup_csum_root:       75300864        gen: 9855436    level: 2
                backup_total_bytes:     10741612544
                backup_bytes_used:      9141452800
                backup_num_devices:     1

        backup 1:
                backup_tree_root:       848773120       gen: 9858291    level: 1
                backup_chunk_root:      20971520        gen: 18814      level: 0
                backup_extent_root:     847937536       gen: 9858291    level: 2
                backup_fs_root:         845496320       gen: 9858291    level: 2
                backup_dev_root:        30408704        gen: 9855433    level: 0
                backup_csum_root:       75300864        gen: 9855436    level: 2
                backup_total_bytes:     10741612544
                backup_bytes_used:      9141436416
                backup_num_devices:     1

        backup 2:
                backup_tree_root:       848871424       gen: 9858292    level: 1
                backup_chunk_root:      20971520        gen: 18814      level: 0
                backup_extent_root:     847675392       gen: 9858292    level: 2
                backup_fs_root:         849068032       gen: 9858293    level: 2
                backup_dev_root:        30408704        gen: 9855433    level: 0
                backup_csum_root:       75300864        gen: 9855436    level: 2
                backup_total_bytes:     10741612544
                backup_bytes_used:      9141436416
                backup_num_devices:     1

        backup 3:
                backup_tree_root:       852295680       gen: 9858293    level: 1
                backup_chunk_root:      20971520        gen: 18814      level: 0
                backup_extent_root:     849887232       gen: 9858293    level: 2
                backup_fs_root:         850509824       gen: 9858293    level: 2
                backup_dev_root:        30408704        gen: 9855433    level: 0
                backup_csum_root:       75300864        gen: 9855436    level: 2
                backup_total_bytes:     10741612544
                backup_bytes_used:      9141452800
                backup_num_devices:     1

# btrfs inspect dump-tree -b 20971520 /dev/loop0p1
btrfs-progs v4.15
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found DC09290B wanted C630FD61
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
bytenr mismatch, want=363069440, have=17552567724568668829
leaf 20971520 items 14 free space 14731 generation 18814 owner 3
leaf 20971520 flags 0x1(WRITTEN) backref revision 1
fs uuid a6459a90-ebe3-4c75-97f4-5496eadcc96f
chunk uuid 6f325a21-ce3e-4994-a638-b88ea82d504c
        item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
                devid 1 total_bytes 10741612544 bytes_used 10741612544
                io_align 4096 io_width 4096 sector_size 4096 type 0
                generation 0 start_offset 0 dev_group 0
                seek_speed 0 bandwidth 0
                uuid b92bd216-a0bb-467d-8f8f-788f845af30c
                fsid a6459a90-ebe3-4c75-97f4-5496eadcc96f
        item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 16105 itemsize 80
                length 4194304 owner 2 stripe_len 65536 type SYSTEM
                io_align 4096 io_width 4096 sector_size 4096
                num_stripes 1 sub_stripes 0
                        stripe 0 devid 1 offset 0
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 16025 itemsize 80
                length 8388608 owner 2 stripe_len 65536 type METADATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 0
                        stripe 0 devid 1 offset 4194304
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 15945 itemsize 80
                length 8388608 owner 2 stripe_len 65536 type DATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 0
                        stripe 0 devid 1 offset 12582912
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 15833 itemsize 112
                length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 2 sub_stripes 0
                        stripe 0 devid 1 offset 20971520
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
                        stripe 1 devid 1 offset 29360128
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 15721 itemsize 112
                length 1073741824 owner 2 stripe_len 65536 type METADATA|DUP
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 2 sub_stripes 0
                        stripe 0 devid 1 offset 37748736
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
                        stripe 1 devid 1 offset 1111490560
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 1103101952) itemoff 15641 itemsize 80
                length 1073741824 owner 2 stripe_len 65536 type DATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 1
                        stripe 0 devid 1 offset 2185232384
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 2176843776) itemoff 15561 itemsize 80
                length 1073741824 owner 2 stripe_len 65536 type DATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 1
                        stripe 0 devid 1 offset 3258974208
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 8 key (FIRST_CHUNK_TREE CHUNK_ITEM 3250585600) itemoff 15481 itemsize 80
                length 1073741824 owner 2 stripe_len 65536 type DATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 1
                        stripe 0 devid 1 offset 4332716032
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 9 key (FIRST_CHUNK_TREE CHUNK_ITEM 4324327424) itemoff 15401 itemsize 80
                length 1073741824 owner 2 stripe_len 65536 type DATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 1
                        stripe 0 devid 1 offset 5406457856
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 10 key (FIRST_CHUNK_TREE CHUNK_ITEM 5398069248) itemoff 15321 itemsize 80
                length 1073741824 owner 2 stripe_len 65536 type DATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 1
                        stripe 0 devid 1 offset 6480199680
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 11 key (FIRST_CHUNK_TREE CHUNK_ITEM 6471811072) itemoff 15241 itemsize 80
                length 1073741824 owner 2 stripe_len 65536 type DATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 1
                        stripe 0 devid 1 offset 7553941504
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 12 key (FIRST_CHUNK_TREE CHUNK_ITEM 7545552896) itemoff 15161 itemsize 80
                length 1073741824 owner 2 stripe_len 65536 type DATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 1
                        stripe 0 devid 1 offset 8627683328
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
        item 13 key (FIRST_CHUNK_TREE CHUNK_ITEM 8619294720) itemoff 15081 itemsize 80
                length 1040187392 owner 2 stripe_len 65536 type DATA
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 1 sub_stripes 1
                        stripe 0 devid 1 offset 9701425152
                        dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c

# btrfs inspect dump-tree -b 848773120 /dev/loop0p1
btrfs-progs v4.15
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found DC09290B wanted C630FD61
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
bytenr mismatch, want=363069440, have=17552567724568668829
node 848773120 level 1 items 2 free 491 generation 9858294 owner 1
fs uuid a6459a90-ebe3-4c75-97f4-5496eadcc96f
chunk uuid 6f325a21-ce3e-4994-a638-b88ea82d504c
        key (EXTENT_TREE ROOT_ITEM 0) block 848986112 (51818) gen 9858294
        key (346 ROOT_ITEM 18671) block 72089600 (4400) gen 9728190

Thanks,

Dirk
