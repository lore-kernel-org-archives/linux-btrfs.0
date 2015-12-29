Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh3.e.nsc.no ([193.213.121.74]:47388 "EHLO nmsh3.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbbL2UTP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 15:19:15 -0500
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <567FEEB6.3080701@online.no>
 <CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
 <56806F06.50309@online.no> <pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
 <568098B1.2040908@online.no>
 <CAJCQCtRGbKJ6RJ++1rUSuVByC_=mJq4afNV-3CCt_s4gCft92A@mail.gmail.com>
 <5681A4D5.4060203@online.no>
 <CAJCQCtSAm2i0QuXPK5xDWNXvcrg3uo_DU5WYOnOD8Fkgn+c4eQ@mail.gmail.com>
 <5681BDD0.1060407@online.no>
 <CAJCQCtQX6x4Fx_f_RyLmNS3q611Zb_Q+hw025--Fx-zmH1wRvw@mail.gmail.com>
From: Waxhead <waxhead@online.no>
Message-ID: <5682EABB.8040408@online.no>
Date: Tue, 29 Dec 2015 21:19:07 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQX6x4Fx_f_RyLmNS3q611Zb_Q+hw025--Fx-zmH1wRvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy wrote:
> On Mon, Dec 28, 2015 at 3:55 PM, Waxhead <waxhead@online.no> wrote:
>
>> I tried the following....
>>
>>   btrfs-image -t4 -c9 /dev/sdb1 /btrfs_raid6.img
>> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
>> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
>> checksum verify failed on 28734324736 found 5F516E2A wanted BBB2D39C
>> checksum verify failed on 28734324736 found C4AA0B8D wanted 41745FB5
>> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
>> bytenr mismatch, want=28734324736, have=16273726433708437499
>> Error reading metadata block
>> Error adding block -5
>> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
>> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
>> checksum verify failed on 28734324736 found 5F516E2A wanted BBB2D39C
>> checksum verify failed on 28734324736 found C4AA0B8D wanted 41745FB5
>> checksum verify failed on 28734324736 found C3E98F3B wanted EB2392C6
>> bytenr mismatch, want=28734324736, have=16273726433708437499
>> Error reading metadata block
>> Error flushing pending -5
>> create failed (Success)
>>
>> Well, I can't make out what this is supposed to mean, but no output file...
> Dunno. Maybe btrfs-show-super -fa for each device, along with
> btrfs-debug-tree <dev> output to a file might have some useful info
> for a dev. It could be a while before we hear from one though,
> considering the season.
>
The btrfs-debug-tree creates about 56.3 megabytes of text for each 
device a few checksums (marked [match]) and dev.item.uuid differs 
between the files for all partitions so I will leave that out of this post.

The output of btrfs-show-super -fa for each device follows:

--snip--

superblock: bytenr=65536, device=/dev/sdb1
---------------------------------------------------------
csum            0xdedfa466 [match]
bytenr            65536
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        c14fb599-f515-4feb-a458-227af0af683b
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=67108864, device=/dev/sdb1
---------------------------------------------------------
csum            0x7ebe8ca8 [match]
bytenr            67108864
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        c14fb599-f515-4feb-a458-227af0af683b
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=65536, device=/dev/sdc1
---------------------------------------------------------
csum            0xf975b895 [match]
bytenr            65536
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        9a1af441-88fc-43b1-b1f8-e1d1163195ef
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        2
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=67108864, device=/dev/sdc1
---------------------------------------------------------
csum            0x5914905b [match]
bytenr            67108864
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        9a1af441-88fc-43b1-b1f8-e1d1163195ef
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        2
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=65536, device=/dev/sdd1
---------------------------------------------------------
csum            0x182c19c3 [match]
bytenr            65536
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        a1ae2083-2730-4611-b019-ba9954c8fa13
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        3
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=67108864, device=/dev/sdd1
---------------------------------------------------------
csum            0xb84d310d [match]
bytenr            67108864
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        a1ae2083-2730-4611-b019-ba9954c8fa13
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        3
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=65536, device=/dev/sde1
---------------------------------------------------------
csum            0xaa2b7d21 [match]
bytenr            65536
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        3458b150-02a7-44a5-81e5-61a734e30439
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        4
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=67108864, device=/dev/sde1
---------------------------------------------------------
csum            0x0a4a55ef [match]
bytenr            67108864
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        3458b150-02a7-44a5-81e5-61a734e30439
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        4
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=65536, device=/dev/sdf1
---------------------------------------------------------
csum            0x1ad4ce81 [match]
bytenr            65536
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        c292e6f4-d113-47af-96bf-1b262ef28c77
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        5
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=67108864, device=/dev/sdf1
---------------------------------------------------------
csum            0xbab5e64f [match]
bytenr            67108864
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        c292e6f4-d113-47af-96bf-1b262ef28c77
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        5
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=65536, device=/dev/sdg1
---------------------------------------------------------
csum            0xa5a6757e [match]
bytenr            65536
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        094d2a3c-f538-4a4e-850a-e611f2517e7f
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        6
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6


superblock: bytenr=67108864, device=/dev/sdg1
---------------------------------------------------------
csum            0x05c75db0 [match]
bytenr            67108864
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            2832346e-0720-499f-8239-355534e5721b
label
generation        15529
root            28539699200
sys_array_size        257
chunk_root_generation    15524
root_level        0
chunk_root        28416425984
chunk_root_level    0
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        49453105152
bytes_used        9239322624
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        6
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0xe1
             ( MIXED_BACKREF |
               BIG_METADATA |
               EXTENDED_IREF |
               RAID56 )
csum_type        0
csum_size        4
cache_generation    15529
uuid_tree_generation    15529
dev_item.uuid        094d2a3c-f538-4a4e-850a-e611f2517e7f
dev_item.fsid        2832346e-0720-499f-8239-355534e5721b [match]
dev_item.type        0
dev_item.total_bytes    8242184192
dev_item.bytes_used    3305111552
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        6
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 28416409600)
         chunk length 67108864 owner 2 stripe_len 65536
         type SYSTEM|RAID6 num_stripes 6
             stripe 0 devid 5 offset 303038464
             dev uuid: c292e6f4-d113-47af-96bf-1b262ef28c77
             stripe 1 devid 4 offset 1048576
             dev uuid: 3458b150-02a7-44a5-81e5-61a734e30439
             stripe 2 devid 3 offset 1074790400
             dev uuid: a1ae2083-2730-4611-b019-ba9954c8fa13
             stripe 3 devid 2 offset 1074790400
             dev uuid: 9a1af441-88fc-43b1-b1f8-e1d1163195ef
             stripe 4 devid 6 offset 1074790400
             dev uuid: 094d2a3c-f538-4a4e-850a-e611f2517e7f
             stripe 5 devid 1 offset 1074790400
             dev uuid: c14fb599-f515-4feb-a458-227af0af683b
backup_roots[4]:
     backup 0:
         backup_tree_root:    28541386752    gen: 15526    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28541403136    gen: 15526    level: 1
         backup_fs_root:        28496560128    gen: 15514    level: 2
         backup_dev_root:    28540829696    gen: 15524    level: 0
         backup_csum_root:    28541452288    gen: 15526    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9164218368
         backup_num_devices:    6

     backup 1:
         backup_tree_root:    28502654976    gen: 15527    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28513714176    gen: 15528    level: 1
         backup_fs_root:        28513566720    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28513615872    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9206489088
         backup_num_devices:    6

     backup 2:
         backup_tree_root:    28538421248    gen: 15528    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28538028032    gen: 15528    level: 1
         backup_fs_root:        28537700352    gen: 15528    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28537864192    gen: 15528    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

     backup 3:
         backup_tree_root:    28539699200    gen: 15529    level: 0
         backup_chunk_root:    28416425984    gen: 15524    level: 0
         backup_extent_root:    28539420672    gen: 15529    level: 1
         backup_fs_root:        28539109376    gen: 15529    level: 2
         backup_dev_root:    28513550336    gen: 15527    level: 0
         backup_csum_root:    28539289600    gen: 15529    level: 2
         backup_total_bytes:    49453105152
         backup_bytes_used:    9239322624
         backup_num_devices:    6

--snip---







