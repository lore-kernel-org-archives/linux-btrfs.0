Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:33769 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbdHUQt5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 12:49:57 -0400
Received: by mail-ua0-f175.google.com with SMTP id q40so10008075uag.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:49:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAANLjFrM9TsxoL_WdeSLZt-7hn2zXKo=Qi0mVw9p=oWSCPxLqA@mail.gmail.com>
References: <CAANLjFrM9TsxoL_WdeSLZt-7hn2zXKo=Qi0mVw9p=oWSCPxLqA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 21 Aug 2017 10:49:55 -0600
Message-ID: <CAJCQCtQetpECDgmPshOHY_n-j-TB5U5Kt+eXLHKhDQ925HBvzQ@mail.gmail.com>
Subject: Re: Btrfs Raid5 issue.
To: Robert LeBlanc <robert@leblancnet.us>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 10:31 AM, Robert LeBlanc <robert@leblancnet.us> wrote:
> Qu,
>
> Sorry, I'm not on the list (I was for a few years about three years ago).
>
> I looked at the backup roots like you mentioned.
>
> # ./btrfs inspect dump-super -f /dev/bcache0
> superblock: bytenr=65536, device=/dev/bcache0
> ---------------------------------------------------------
> csum_type               0 (crc32c)
> csum_size               4
> csum                    0x45302c8f [match]
> bytenr                  65536
> flags                   0x1
>                         ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    fef29f0a-dc4c-4cc4-b524-914e6630803c
> label                   kvm-btrfs
> generation              1620386
> root                    5310022877184
> sys_array_size          161
> chunk_root_generation   1620164
> root_level              1
> chunk_root              4725030256640
> chunk_root_level        1
> log_root                2876047507456
> log_root_transid        0
> log_root_level          0
> total_bytes             8998588280832
> bytes_used              3625869234176
> sectorsize              4096
> nodesize                16384
> leafsize (deprecated)           16384
> stripesize              4096
> root_dir                6
> num_devices             3
> compat_flags            0x0
> compat_ro_flags         0x0
> incompat_flags          0x1e1
>                         ( MIXED_BACKREF |
>                           BIG_METADATA |
>                           EXTENDED_IREF |
>                           RAID56 |
>                           SKINNY_METADATA )
> cache_generation        1620386
> uuid_tree_generation    42
> dev_item.uuid           cb56a9b7-8d67-4ae8-8cb0-076b0b93f9c4
> dev_item.fsid           fef29f0a-dc4c-4cc4-b524-914e6630803c [match]
> dev_item.type           0
> dev_item.total_bytes    2998998654976
> dev_item.bytes_used     2295693574144
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          2
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
> sys_chunk_array[2048]:
>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 4725030256640)
>                 length 67108864 owner 2 stripe_len 65536 type
> SYSTEM|RAID5
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 3 sub_stripes 1
>                         stripe 0 devid 1 offset 2185232384
>                         dev_uuid e273c794-b231-4d86-9a38-53a6d2fa8643
>                         stripe 1 devid 3 offset 1195075698688
>                         dev_uuid 120d6a05-b0bc-46c8-a87e-ca4fe5008d09
>                         stripe 2 devid 2 offset 41340108800
>                         dev_uuid cb56a9b7-8d67-4ae8-8cb0-076b0b93f9c4
> backup_roots[4]:
>         backup 0:
>                 backup_tree_root:       5309879451648   gen: 1620384    level: 1
>                 backup_chunk_root:      4725030256640   gen: 1620164    level: 1
>                 backup_extent_root:     5309910958080   gen: 1620385    level: 2
>                 backup_fs_root:         3658468147200   gen: 1618016    level: 1
>                 backup_dev_root:        5309904224256   gen: 1620384    level: 1
>                 backup_csum_root:       5309910532096   gen: 1620385    level: 3
>                 backup_total_bytes:     8998588280832
>                 backup_bytes_used:      3625871646720
>                 backup_num_devices:     3
>
>         backup 1:
>                 backup_tree_root:       5309780492288   gen: 1620385    level: 1
>                 backup_chunk_root:      4725030256640   gen: 1620164    level: 1
>                 backup_extent_root:     5309659037696   gen: 1620385    level: 2
>                 backup_fs_root:         0       gen: 0  level: 0
>                 backup_dev_root:        5309872275456   gen: 1620385    level: 1
>                 backup_csum_root:       5309674536960   gen: 1620385    level: 3
>                 backup_total_bytes:     8998588280832
>                 backup_bytes_used:      3625869234176
>                 backup_num_devices:     3


Well that's strange. A backup entry with a null fs root.



> I noticed on that page that there is a 'nologreplay' mount option so I
> tried it with degraded and it requires ro, but the volume mounted and
> I can "see" things on the volume.

Degraded suggests it's not finding one of the three devices.


> So with this nologreplay option, if I do a btrfs send of the subvolume
> that I'm interested in (I don't think it was being written to at the
> time of failure), would it copy (send) over the corruption as well.

Anything that results in EIO will get included in the send, and by
default receive fails. You can use verbose messaging on the receive
side, and use -E option to permit the errors. But file system specific
problems aren't going to propagate through send receive.

Note that you can't change the subvolume in question to read only
because the file system itself is read only. And only read only
subvolumes can be send/receive. You might have to fall back to rsync.




-- 
Chris Murphy
