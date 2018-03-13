Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from services.gouders.net ([141.101.32.176]:47117 "EHLO
        services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932718AbeCMN3O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 09:29:14 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: FS unmountable after RAID/LVM problems
In-Reply-To: <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com> (Qu Wenruo's
        message of "Tue, 13 Mar 2018 21:20:19 +0800")
References: <ghlgew5pbq.fsf@lena.gouders.net>
        <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
        <ghwoygxh77.fsf@lena.gouders.net>
        <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
Date: Tue, 13 Mar 2018 14:29:06 +0100
Message-ID: <ghsh94xfx9.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo <quwenruo.btrfs@gmx.com> writes:

> On 2018年03月13日 21:01, Dirk Gouders wrote:
>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>> 
>>> On 2018年03月13日 16:53, Dirk Gouders wrote:
>> 
>> <SNIP>
>> 
>>>> find-root:
>>>>
>>>> # btrfs-find-root /dev/loop0p1
>>>> Superblock thinks the generation is 9858294
>>>> Superblock thinks the level is 1
>>>> Found tree root at 848773120 gen 9858294 level 1
>>>
>>> Tree root is found, find-root won't help much here.
>>> And if it's really tree root corruption, we should have some kernel
>>> message for it.
>>>
>>>> Well block 832045056(gen: 9858272 level: 1) seems good, but generation/level doesn't match, want gen: 9858294 level: 1
>>>
>>> Especially when the next tree block is 22 generation older.
>>>
>>> Would you please try to call "btrfs inspect dump-tree <device>" and
>>> paste the result with *stderr*?
>>>
>>> At least we could know which tree block is corrupted.
>> 
>> Here is the result of inspect:
>> 
>> # btrfs inspect dump-tree /dev/loop0p1
>> btrfs-progs v4.15
>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>> checksum verify failed on 363069440 found DC09290B wanted C630FD61
>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>> bytenr mismatch, want=363069440, have=17552567724568668829
>> ERROR: unable to open /dev/loop0p1
>
> OK, one tree block in some important tree is corrupted.
>
> Would you please dump the super block by "btrfs inspect dump-super
> <device>" so that we could have some clue about where the corrupted tree
> block belongs?

Yes, here is the requested output:

# btrfs inspect dump-super /dev/loop0p1 
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


Thanks,

Dirk
