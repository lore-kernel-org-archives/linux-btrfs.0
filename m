Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:35055 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbeCFBwA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Mar 2018 20:52:00 -0500
Received: from homiemail-a93.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id A3C4C8E3DE
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Mar 2018 17:51:59 -0800 (PST)
Received: from homiemail-a93.g.dreamhost.com (localhost [127.0.0.1])
        by homiemail-a93.g.dreamhost.com (Postfix) with ESMTP id 2520A801A120
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Mar 2018 17:51:59 -0800 (PST)
Received: from [192.168.0.3] (unknown [68.200.76.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: flat@imo.uto.moe)
        by homiemail-a93.g.dreamhost.com (Postfix) with ESMTPSA id DE740801A118
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Mar 2018 17:51:58 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Ken Swenson <flat@imo.uto.moe>
Subject: ERROR: unsupported checksum algorithm 35355
Message-ID: <1b11c57b-ee9f-b94a-3d79-bbacf01ba3bf@imo.uto.moe>
Date: Mon, 5 Mar 2018 20:51:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
 
Somehow it appears the csum_type on my btrfs file system got corrupted.
I cannot mount the system in recovery or read only. btrfs check just
returns "ERROR: unsupported checksum algorithm 35355" as well as btrfs
recover. The only command I was able to successfully run was btrfs
inspect-internal dump-super, which I've pasted the output at the end of
this message.

Requested information from the wiki:
Linux 4.15.7-1-ARCH #1 SMP PREEMPT Wed Feb 28 19:01:57 UTC 2018 x86_64
GNU/Linux
btrfs-progs v4.15.1
btrfs fi show: ERROR: unsupported checksum algorithm 35355 ERROR: cannot
scan /dev/mapper/x: Input/output error

dmesg:
[ 11.232399] Btrfs loaded, crc32c=crc32c-intel
[ 11.233229] BTRFS: device fsid 513f07e1-08be-4d94-a55c-11c6251f6c2f
devid 1 transid 7777 /dev/dm-2
[ 488.372891] BTRFS error (device dm-2): unsupported checksum algorithm
35355
[ 488.372894] BTRFS error (device dm-2): superblock checksum mismatch
[ 488.384902] BTRFS error (device dm-2): open_ctree failed

Is there anything I can do to recovery from this or am I out of luck? To
give some background the disk was working fine until I upgraded to
Kernel 4.15.7 and rebooted.

superblock: bytenr=65536, device=/dev/mapper/x
---------------------------------------------------------
csum_type        35355 (INVALID)
csum_size        32
csum           
0xf0dbeddd00000000000000000000000000000000000000000000000000000000 [match]
bytenr            65536
flags            0x1
            ( WRITTEN )
magic            _BHRfS_M [match]
fsid            513f07e1-08be-4d94-a55c-11c6251f6c2f
label           
generation        7777
root            186466304
sys_array_size        129
chunk_root_generation    7450
root_level        1
chunk_root        21004288
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        5000947523584
bytes_used        420849201152
sectorsize        4096
nodesize        16384
leafsize (deprecated)        16384
stripesize        4096
root_dir        6
num_devices        1
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x176d200000000169
            ( MIXED_BACKREF |
              COMPRESS_LZO |
              BIG_METADATA |
              EXTENDED_IREF |
              SKINNY_METADATA |
              unknown flag: 0x176d200000000000 )
cache_generation    7777
uuid_tree_generation    7777
dev_item.uuid        880c692f-5270-4c7a-908d-8b3956fb3790
dev_item.fsid        513f07e1-08be-4d94-a55c-11c6251f6c2f [match]
dev_item.type        0
dev_item.total_bytes    5000947523584
dev_item.bytes_used    457439182848
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
    item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
        length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 0
            stripe 0 devid 1 offset 20971520
            dev_uuid 880c692f-5270-4c7a-908d-8b3956fb3790
            stripe 1 devid 1 offset 29360128
            dev_uuid 880c692f-5270-4c7a-908d-8b3956fb3790
backup_roots[4]:
    backup 0:
        backup_tree_root:    181174272    gen: 7774    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    181190656    gen: 7774    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    93585408    gen: 7631    level: 1
        backup_csum_root:    181862400    gen: 7774    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

    backup 1:
        backup_tree_root:    183828480    gen: 7775    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    183320576    gen: 7775    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    183975936    gen: 7775    level: 1
        backup_csum_root:    185761792    gen: 7775    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

    backup 2:
        backup_tree_root:    186810368    gen: 7776    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    186613760    gen: 7776    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    183975936    gen: 7775    level: 1
        backup_csum_root:    187056128    gen: 7776    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

    backup 3:
        backup_tree_root:    186466304    gen: 7777    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    187908096    gen: 7777    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    183975936    gen: 7775    level: 1
        backup_csum_root:    188071936    gen: 7777    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1


superblock: bytenr=67108864, device=/dev/mapper/x
---------------------------------------------------------
csum_type        35355 (INVALID)
csum_size        32
csum           
0x50bac51300000000000000000000000000000000000000000000000000000000
[DON'T MATCH]
bytenr            67108864
flags            0x1
            ( WRITTEN )
magic            _BHRfS_M [match]
fsid            513f07e1-08be-4d94-a55c-11c6251f6c2f
label           
generation        7777
root            186466304
sys_array_size        129
chunk_root_generation    7450
root_level        1
chunk_root        21004288
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        5000947523584
bytes_used        420849201152
sectorsize        4096
nodesize        16384
leafsize (deprecated)        16384
stripesize        4096
root_dir        6
num_devices        1
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x176d200000000169
            ( MIXED_BACKREF |
              COMPRESS_LZO |
              BIG_METADATA |
              EXTENDED_IREF |
              SKINNY_METADATA |
              unknown flag: 0x176d200000000000 )
cache_generation    7777
uuid_tree_generation    7777
dev_item.uuid        880c692f-5270-4c7a-908d-8b3956fb3790
dev_item.fsid        513f07e1-08be-4d94-a55c-11c6251f6c2f [match]
dev_item.type        0
dev_item.total_bytes    5000947523584
dev_item.bytes_used    457439182848
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
    item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
        length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 0
            stripe 0 devid 1 offset 20971520
            dev_uuid 880c692f-5270-4c7a-908d-8b3956fb3790
            stripe 1 devid 1 offset 29360128
            dev_uuid 880c692f-5270-4c7a-908d-8b3956fb3790
backup_roots[4]:
    backup 0:
        backup_tree_root:    181174272    gen: 7774    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    181190656    gen: 7774    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    93585408    gen: 7631    level: 1
        backup_csum_root:    181862400    gen: 7774    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

    backup 1:
        backup_tree_root:    183828480    gen: 7775    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    183320576    gen: 7775    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    183975936    gen: 7775    level: 1
        backup_csum_root:    185761792    gen: 7775    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

    backup 2:
        backup_tree_root:    186810368    gen: 7776    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    186613760    gen: 7776    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    183975936    gen: 7775    level: 1
        backup_csum_root:    187056128    gen: 7776    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

    backup 3:
        backup_tree_root:    186466304    gen: 7777    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    187908096    gen: 7777    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    183975936    gen: 7775    level: 1
        backup_csum_root:    188071936    gen: 7777    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1


superblock: bytenr=274877906944, device=/dev/mapper/x
---------------------------------------------------------
csum_type        35355 (INVALID)
csum_size        32
csum           
0xad3d932200000000000000000000000000000000000000000000000000000000
[DON'T MATCH]
bytenr            274877906944
flags            0x1
            ( WRITTEN )
magic            _BHRfS_M [match]
fsid            513f07e1-08be-4d94-a55c-11c6251f6c2f
label           
generation        7777
root            186466304
sys_array_size        129
chunk_root_generation    7450
root_level        1
chunk_root        21004288
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        5000947523584
bytes_used        420849201152
sectorsize        4096
nodesize        16384
leafsize (deprecated)        16384
stripesize        4096
root_dir        6
num_devices        1
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x176d200000000169
            ( MIXED_BACKREF |
              COMPRESS_LZO |
              BIG_METADATA |
              EXTENDED_IREF |
              SKINNY_METADATA |
              unknown flag: 0x176d200000000000 )
cache_generation    7777
uuid_tree_generation    7777
dev_item.uuid        880c692f-5270-4c7a-908d-8b3956fb3790
dev_item.fsid        513f07e1-08be-4d94-a55c-11c6251f6c2f [match]
dev_item.type        0
dev_item.total_bytes    5000947523584
dev_item.bytes_used    457439182848
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
    item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
        length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 0
            stripe 0 devid 1 offset 20971520
            dev_uuid 880c692f-5270-4c7a-908d-8b3956fb3790
            stripe 1 devid 1 offset 29360128
            dev_uuid 880c692f-5270-4c7a-908d-8b3956fb3790
backup_roots[4]:
    backup 0:
        backup_tree_root:    181174272    gen: 7774    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    181190656    gen: 7774    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    93585408    gen: 7631    level: 1
        backup_csum_root:    181862400    gen: 7774    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

    backup 1:
        backup_tree_root:    183828480    gen: 7775    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    183320576    gen: 7775    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    183975936    gen: 7775    level: 1
        backup_csum_root:    185761792    gen: 7775    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

    backup 2:
        backup_tree_root:    186810368    gen: 7776    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    186613760    gen: 7776    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    183975936    gen: 7775    level: 1
        backup_csum_root:    187056128    gen: 7776    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

    backup 3:
        backup_tree_root:    186466304    gen: 7777    level: 1
        backup_chunk_root:    21004288    gen: 7450    level: 1
        backup_extent_root:    187908096    gen: 7777    level: 2
        backup_fs_root:        809828352    gen: 6404    level: 0
        backup_dev_root:    183975936    gen: 7775    level: 1
        backup_csum_root:    188071936    gen: 7777    level: 2
        backup_total_bytes:    5000947523584
        backup_bytes_used:    420849201152
        backup_num_devices:    1

Thank you,
Ken


���{.n�+�������+%�����ݶ��w��{.n�+����{���k~���^n�r���z���h����&���z��z�ޗ�+��+zf���h���~����i��������z_��j:+v���)ߣ�m
