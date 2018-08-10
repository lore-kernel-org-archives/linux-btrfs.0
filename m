Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:39629 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbeHJMXf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 08:23:35 -0400
Received: by mail-oi0-f41.google.com with SMTP id d189-v6so14846766oib.6
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 02:54:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com> <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Fri, 10 Aug 2018 05:54:25 -0400
Message-ID: <CAPL5yKdL=-GPuu6Kx-s4Bt7yQSsZ4JbwHaA3seTGG=O_ducWzg@mail.gmail.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

E: Resending without the 500k attachment.

On Fri, Aug 10, 2018 at 5:13 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 8/10/18 4:47 PM, Dan Merillat wrote:
>> Unfortunately that doesn't appear to be it, a forced restart and
>> attempted to mount with skip_balance leads to the same thing.
>
> That's strange.
>
> Would you please provide the following output to determine whether we
> have any balance running?
>
> # btrfs inspect dump-super -fFa <device>

superblock: bytenr=65536, device=/dev/bcache0
---------------------------------------------------------
csum_type        0 (crc32c)
csum_size        4
csum            0xaeff2ec3 [match]
bytenr            65536
flags            0x1
            ( WRITTEN )
magic            _BHRfS_M [match]
fsid            16adc029-64c5-45ff-8114-e2f5b2f2d331
label            MEDIA
generation        4584957
root            33947648
sys_array_size        129
chunk_root_generation    4534813
root_level        1
chunk_root        13681127653376
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        12001954226176
bytes_used        11387838865408
sectorsize        4096
nodesize        16384
leafsize (deprecated)        16384
stripesize        4096
root_dir        6
num_devices        1
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x169
            ( MIXED_BACKREF |
              COMPRESS_LZO |
              BIG_METADATA |
              EXTENDED_IREF |
              SKINNY_METADATA )
cache_generation    4584957
uuid_tree_generation    4584925
dev_item.uuid        ec51cc1f-992a-47a2-b7b2-83af026723fd
dev_item.fsid        16adc029-64c5-45ff-8114-e2f5b2f2d331 [match]
dev_item.type        0
dev_item.total_bytes    12001954226176
dev_item.bytes_used    11613258579968
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
    item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 13681127456768)
        length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 1
            stripe 0 devid 1 offset 353298808832
            dev_uuid ec51cc1f-992a-47a2-b7b2-83af026723fd
            stripe 1 devid 1 offset 353332363264
            dev_uuid ec51cc1f-992a-47a2-b7b2-83af026723fd
backup_roots[4]:
    backup 0:
        backup_tree_root:    3666753175552    gen: 4584956    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    3666740674560    gen: 4584956    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    199376896    gen: 4584935    level: 1
        backup_csum_root:    3666753568768    gen: 4584956    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838865408
        backup_num_devices:    1

    backup 1:
        backup_tree_root:    33947648    gen: 4584957    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    33980416    gen: 4584957    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    34160640    gen: 4584957    level: 1
        backup_csum_root:    34357248    gen: 4584957    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838865408
        backup_num_devices:    1

    backup 2:
        backup_tree_root:    3666598461440    gen: 4584954    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    3666595233792    gen: 4584954    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    199376896    gen: 4584935    level: 1
        backup_csum_root:    3666600034304    gen: 4584954    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838898176
        backup_num_devices:    1

    backup 3:
        backup_tree_root:    3666690998272    gen: 4584955    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    3666690293760    gen: 4584955    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    199376896    gen: 4584935    level: 1
        backup_csum_root:    3666691604480    gen: 4584955    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838881792
        backup_num_devices:    1


superblock: bytenr=67108864, device=/dev/bcache0
---------------------------------------------------------
csum_type        0 (crc32c)
csum_size        4
csum            0x0e9e060d [match]
bytenr            67108864
flags            0x1
            ( WRITTEN )
magic            _BHRfS_M [match]
fsid            16adc029-64c5-45ff-8114-e2f5b2f2d331
label            MEDIA
generation        4584957
root            33947648
sys_array_size        129
chunk_root_generation    4534813
root_level        1
chunk_root        13681127653376
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        12001954226176
bytes_used        11387838865408
sectorsize        4096
nodesize        16384
leafsize (deprecated)        16384
stripesize        4096
root_dir        6
num_devices        1
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x169
            ( MIXED_BACKREF |
              COMPRESS_LZO |
              BIG_METADATA |
              EXTENDED_IREF |
              SKINNY_METADATA )
cache_generation    4584957
uuid_tree_generation    4584925
dev_item.uuid        ec51cc1f-992a-47a2-b7b2-83af026723fd
dev_item.fsid        16adc029-64c5-45ff-8114-e2f5b2f2d331 [match]
dev_item.type        0
dev_item.total_bytes    12001954226176
dev_item.bytes_used    11613258579968
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
    item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 13681127456768)
        length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 1
            stripe 0 devid 1 offset 353298808832
            dev_uuid ec51cc1f-992a-47a2-b7b2-83af026723fd
            stripe 1 devid 1 offset 353332363264
            dev_uuid ec51cc1f-992a-47a2-b7b2-83af026723fd
backup_roots[4]:
    backup 0:
        backup_tree_root:    3666753175552    gen: 4584956    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    3666740674560    gen: 4584956    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    199376896    gen: 4584935    level: 1
        backup_csum_root:    3666753568768    gen: 4584956    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838865408
        backup_num_devices:    1

    backup 1:
        backup_tree_root:    33947648    gen: 4584957    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    33980416    gen: 4584957    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    34160640    gen: 4584957    level: 1
        backup_csum_root:    34357248    gen: 4584957    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838865408
        backup_num_devices:    1

    backup 2:
        backup_tree_root:    3666598461440    gen: 4584954    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    3666595233792    gen: 4584954    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    199376896    gen: 4584935    level: 1
        backup_csum_root:    3666600034304    gen: 4584954    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838898176
        backup_num_devices:    1

    backup 3:
        backup_tree_root:    3666690998272    gen: 4584955    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    3666690293760    gen: 4584955    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    199376896    gen: 4584935    level: 1
        backup_csum_root:    3666691604480    gen: 4584955    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838881792
        backup_num_devices:    1


superblock: bytenr=274877906944, device=/dev/bcache0
---------------------------------------------------------
csum_type        0 (crc32c)
csum_size        4
csum            0xf319503c [match]
bytenr            274877906944
flags            0x1
            ( WRITTEN )
magic            _BHRfS_M [match]
fsid            16adc029-64c5-45ff-8114-e2f5b2f2d331
label            MEDIA
generation        4584957
root            33947648
sys_array_size        129
chunk_root_generation    4534813
root_level        1
chunk_root        13681127653376
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        12001954226176
bytes_used        11387838865408
sectorsize        4096
nodesize        16384
leafsize (deprecated)        16384
stripesize        4096
root_dir        6
num_devices        1
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x169
            ( MIXED_BACKREF |
              COMPRESS_LZO |
              BIG_METADATA |
              EXTENDED_IREF |
              SKINNY_METADATA )
cache_generation    4584957
uuid_tree_generation    4584925
dev_item.uuid        ec51cc1f-992a-47a2-b7b2-83af026723fd
dev_item.fsid        16adc029-64c5-45ff-8114-e2f5b2f2d331 [match]
dev_item.type        0
dev_item.total_bytes    12001954226176
dev_item.bytes_used    11613258579968
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
    item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 13681127456768)
        length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 1
            stripe 0 devid 1 offset 353298808832
            dev_uuid ec51cc1f-992a-47a2-b7b2-83af026723fd
            stripe 1 devid 1 offset 353332363264
            dev_uuid ec51cc1f-992a-47a2-b7b2-83af026723fd
backup_roots[4]:
    backup 0:
        backup_tree_root:    3666753175552    gen: 4584956    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    3666740674560    gen: 4584956    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    199376896    gen: 4584935    level: 1
        backup_csum_root:    3666753568768    gen: 4584956    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838865408
        backup_num_devices:    1

    backup 1:
        backup_tree_root:    33947648    gen: 4584957    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    33980416    gen: 4584957    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    34160640    gen: 4584957    level: 1
        backup_csum_root:    34357248    gen: 4584957    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838865408
        backup_num_devices:    1

    backup 2:
        backup_tree_root:    3666598461440    gen: 4584954    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    3666595233792    gen: 4584954    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    199376896    gen: 4584935    level: 1
        backup_csum_root:    3666600034304    gen: 4584954    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838898176
        backup_num_devices:    1

    backup 3:
        backup_tree_root:    3666690998272    gen: 4584955    level: 1
        backup_chunk_root:    13681127653376    gen: 4534813    level: 1
        backup_extent_root:    3666690293760    gen: 4584955    level: 2
        backup_fs_root:        0    gen: 0    level: 0
        backup_dev_root:    199376896    gen: 4584935    level: 1
        backup_csum_root:    3666691604480    gen: 4584955    level: 3
        backup_total_bytes:    12001954226176
        backup_bytes_used:    11387838881792
        backup_num_devices:    1

>
> # btrfs inspect dump-tree -t root <device>
>

Uploaded: http://dan.merillat.org/dump-tree.bz2

There's a balance item at the end:
        item 178 key (BALANCE TEMPORARY_ITEM 0) itemoff 6945 itemsize 448
                temporary item objectid BALANCE offset 0
                balance status flags 6
                DATA
                profiles 0 devid 0 target 0 flags 0
                usage_min 0 usage_max 0 pstart 0 pend 0
                vstart 0 vend 0 limit_min 0 limit_max 0
                stripes_min 0 stripes_max 0
                METADATA
                profiles 0 devid 0 target 0 flags 0
                usage_min 0 usage_max 0 pstart 0 pend 0
                vstart 0 vend 0 limit_min 0 limit_max 0
                stripes_min 0 stripes_max 0
                SYSTEM
                profiles 0 devid 0 target 0 flags 0
                usage_min 0 usage_max 0 pstart 0 pend 0
                vstart 0 vend 0 limit_min 0 limit_max 0
                stripes_min 0 stripes_max 0

btrfs check is still running, it's found one thing so far:

Checking filesystem on /dev/bcache0
UUID: 16adc029-64c5-45ff-8114-e2f5b2f2d331
checking extents
ref mismatch on [13135707160576 16384] extent item 0, found 1
tree backref 13135707160576 parent 13136850550784 root 13136850550784 not found
in extent tree
backpointer mismatch on [13135707160576 16384]
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
