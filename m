Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53637 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751538AbeDGA4Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 20:56:16 -0400
Subject: Re: Bad magic on superblock on /dev/sda at 65536
To: Ben Parsons <9parsonsb@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
 <20180406170329.GH8557@twin.jikos.cz>
 <1401c2e5-d0e9-ac9e-178f-776cb9847ffb@gmx.com>
 <CAAGPGf8m-8qQ-tsW6ZxtEktm1DbP4FfrU6FZr+tX3vb_Cq+9_g@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <17a45d05-1dc9-4b1b-5786-c4bf8ae8a5eb@gmx.com>
Date: Sat, 7 Apr 2018 08:56:07 +0800
MIME-Version: 1.0
In-Reply-To: <CAAGPGf8m-8qQ-tsW6ZxtEktm1DbP4FfrU6FZr+tX3vb_Cq+9_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月07日 08:35, Ben Parsons wrote:
>> btrfs inspect-internal dump-super -Ffa /path
> 
> superblock: bytenr=65536, device=/dev/sda
> ---------------------------------------------------------
> csum_type        0 (crc32c)
> csum_size        4
> csum            0x00000000 [DON'T MATCH]
> bytenr            0
> flags            0x0
> magic            ........ [DON'T MATCH]
> fsid            00000000-0000-0000-0000-000000000000

First super block is completely gone.

> label
> generation        0
> root            0
> sys_array_size        0
> chunk_root_generation    0
> root_level        0
> chunk_root        0
> chunk_root_level    0
> log_root        0
> log_root_transid    0
> log_root_level        0
> total_bytes        0
> bytes_used        0
> sectorsize        0
> nodesize        0
> leafsize (deprecated)        0
> stripesize        0
> root_dir        0
> num_devices        0
> compat_flags        0x0
> compat_ro_flags        0x0
> incompat_flags        0x0
> cache_generation    0
> uuid_tree_generation    0
> dev_item.uuid        00000000-0000-0000-0000-000000000000
> dev_item.fsid        00000000-0000-0000-0000-000000000000 [match]
> dev_item.type        0
> dev_item.total_bytes    0
> dev_item.bytes_used    0
> dev_item.io_align    0
> dev_item.io_width    0
> dev_item.sector_size    0
> dev_item.devid        0
> dev_item.dev_group    0
> dev_item.seek_speed    0
> dev_item.bandwidth    0
> dev_item.generation    0
> sys_chunk_array[2048]:
> backup_roots[4]:
> 
> superblock: bytenr=67108864, device=/dev/sda
> ---------------------------------------------------------
> csum_type        65178 (INVALID)
> csum_size        32
> csum
> 0x24f2057c939118ef8cf9c276a05ff294223c99ec79e0b5cfe8ed795fe0a96715
> [DON'T MATCH]
> bytenr            6481065229944367737

Neither this backup superblock is valid.

> flags            0x527ffc9117fc11
>             ( WRITTEN |
>               CHANGING_FSID |
>               METADUMP_V2 |
>               unknown flag: 0x527ff09117fc10 )
> magic            ...;)... [DON'T MATCH]
> fsid            7011f2d5-0afe-5dc6-fce2-70e04b80939d
> label
> ;.."`....8..8.x.?.N../....z....F..H.......|h].i.C........)........j....<?P..&.......4.(.}'.)....n...9....G..D..^....g.X....g)....L..G...z.|R.V.0...K.~..!..~..C................pO..........@U.>....).......4....d_..5.../.......1.?.r....r5.E..
> generation        7112314448606197494
[snip]
> 
> 
> superblock: bytenr=274877906944, device=/dev/sda
> ---------------------------------------------------------
> csum_type        63651 (INVALID)
> csum_size        32
> csum
> 0x39db30683b693c000000004ff05c0073a1fa00db390c32963bae3c0000000037
> [DON'T MATCH]
> bytenr            6341162744368070656

2nd backup is also gone.

> flags            0x9731d639d900f69a
>             ( RELOC |
>               CHANGING_FSID |
>               SEEDING |
>               unknown flag: 0x9731d630d900f698 )
> magic            ;.<..... [DON'T MATCH]
> fsid            e25b006e-a0f9-00df-390a-32923bae3c00
> label            .9~2.;.<
> generation        15852938566880484858
> root            17063576824041017
> sys_array_size        2956094009
> chunk_root_generation    9223372036858758203
> root_level        0
> chunk_root        2305935309654720512
> chunk_root_level    212
> log_root        12624074888383091845
> log_root_transid    9583660007048386619
> log_root_level        57
> total_bytes        14916195329329095163
> bytes_used        17051482582002489
[snip]

unfortunately, the filesystem seems to be totally corrupted.

> 
>> Despite that, any extra info on how this happened is also appreciated,
>> as similar problem happened twice, which means we need to pay attention
>> on this.
> 
> I dont know exactly what happened but here is some background:
> 
> i am running Arch Linux on mainline kernel (4.16.0-1) and mesa-git
> (101352.498d9d0f4d-1) as I have a rx vega 64

Vega is nice, however I would wait until mesa in extra/ repo get updated.

> over the past few months I have been getting hard locks when opening
> certain programs (usually due to a bad versions of mesa-git /
> llvm-git, etc).
> 
> i was at the time trying to open the program "cheese" and when I did,
> my machine hard locked and only alt+shift+sysrq+b got my screen to go
> black - and then did nothing else, so I held the power button for 3
> seconds and then my machine rebooted.

Pretty common hard power reset.

> looking at journalctl, there is a large stacktrace from kernel: amdgpu
> (see attached).
> then when I booted back up the pool (2 disks, 1TB + 2TB) wouldn't mount.

I'd say such corruption is pretty serious.

And what's the profile of the btrfs? If metadata is raid1, we could at
least try to recovery the superblock from the remaining disk.

And is there special mount options used here like discard?

Thanks,
Qu

> 
> Thanks,
> Ben
> 
> On 7 April 2018 at 09:44, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 2018年04月07日 01:03, David Sterba wrote:
>>> On Fri, Apr 06, 2018 at 11:32:34PM +1000, Ben Parsons wrote:
>>>> Hi,
>>>>
>>>> I just had an unexpected restart and now my btrfs pool wont mount.
>>>> The error on mount is:
>>>>
>>>>     "ERROR: unsupported checksum algorithm 41700"
>>>>
>>>> and when running
>>>>
>>>>     btrfs inspect-internal dump-super /dev/sda
>>>>     ERROR: bad magic on superblock on /dev/sda at 65536
>>>>
>>>> I saw a thread in the mailing list about it:
>>>> https://www.spinics.net/lists/linux-btrfs/msg75326.html
>>>> However I am told on IRC that Qu fixed it using magic.
>>>>
>>>> Any help would be much appreciated.
>>>
>>> In the previous report, there were 2 isolated areas of superblock
>>> damaged. Please post output of
>>>
>>>       btrfs inspect dump-super /path
>>
>> And don't forget -Ffa option.
>> -F to force btrfs-progs to recognize it as btrfs no matter what the magic is
>> -f shows all data so we could find all corruption and fix them if possible
>> -a shows all backup superblocks, and if some backup is good, "btrfs
>> rescue super-recovery" mentioned by Nikolay would be the best solution.
>>
>> Despite that, any extra info on how this happened is also appreciated,
>> as similar problem happened twice, which means we need to pay attention
>> on this.
>>
>> Thanks,
>> Qu
>>
>> Thanks,
>> Qu
>>
>>>
>>> so we can see if it's a similar issue.
>>>
>>> In case it is, there's a tool in the btrfs-progs repo that can fix the
>>> individual values.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
