Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35447 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S948146AbcKAFZJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 01:25:09 -0400
Subject: Re: cannot mount read-write because of unsupported optional features
 (2)
To: Tobias Holst <tobby@tobby.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAGwxe4jsSHNP5qXy=wL6MuYNzKTQF70MpD-0aYhHaUzVR4SuLg@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <51d348af-54f1-0f11-6478-6561693477e6@cn.fujitsu.com>
Date: Tue, 1 Nov 2016 13:24:58 +0800
MIME-Version: 1.0
In-Reply-To: <CAGwxe4jsSHNP5qXy=wL6MuYNzKTQF70MpD-0aYhHaUzVR4SuLg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/01/2016 12:46 PM, Tobias Holst wrote:
> Hi
>
> I can't mount my boot partition anymore. When I try it by entering
> "mount /dev/sdi1 /mnt/boot/" I get:
>> mount: wrong fs type, bad option, bad superblock on /dev/sdi1,
>>       missing codepage or helper program, or other error
>>
>>       In some cases useful info is found in syslog - try
>>       dmesg | tail or so.
>
> "dmesg | tail" gives me:
>> BTRFS info (device sdi1): using free space tree
>> BTRFS info (device sdi1): has skinny extents
>> BTRFS error (device sdi1): cannot mount read-write because of unsupported optional features (2)
>> BTRFS: open_ctree failed
>
> I am using an Ubuntu 16.10 Live CD with Kernel 4.8 and btrfs-progs v4.8.2.
>
> "btrfs inspect-internal dump-super /dev/sdi1" gives me the following:
>> superblock: bytenr=65536, device=/dev/sdi1
>> ---------------------------------------------------------
>> csum_type               0 (crc32c)
>> csum_size               4
>> csum                    0x0f346b08 [match]
>> bytenr                  65536
>> flags                   0x1
>>                        ( WRITTEN )
>> magic                   _BHRfS_M [match]
>> fsid                    67ac5740-1ced-4d59-8999-03bb3195ec49
>> label                   t-hyper-boot
>> generation              64
>> root                    20971520
>> sys_array_size          129
>> chunk_root_generation   43
>> root_level              1
>> chunk_root              12587008
>> chunk_root_level        0
>> log_root                0
>> log_root_transid        0
>> log_root_level          0
>> total_bytes             2147483648
>> bytes_used              102813696
>> sectorsize              4096
>> nodesize                4096
>> leafsize                4096
>> stripesize              4096
>> root_dir                6
>> num_devices             1
>> compat_flags            0x0
>> compat_ro_flags         0x3
compat_ro_flags 0x3 is FREE_SPACE_TREE and FREE_SPACE_TREE_VALID.

FREE_SPACE_TREE_VALID is introduced later to fix a endian bug in free 
space tree.

And that seems to be cause.

Thanks,
Qu

>> incompat_flags          0x34d
>>                        ( MIXED_BACKREF |
>>                          MIXED_GROUPS |
>>                          COMPRESS_LZO |
>>                          EXTENDED_IREF |
>>                          SKINNY_METADATA |
>>                          NO_HOLES )
>> cache_generation        53
>> uuid_tree_generation    64
>> dev_item.uuid           273d5800-add1-45bb-8a11-ecd6d8c1503e
>> dev_item.fsid           67ac5740-1ced-4d59-8999-03bb3195ec49 [match]
>> dev_item.type           0
>> dev_item.total_bytes    2147483648
>> dev_item.bytes_used     667680768
>> dev_item.io_align       4096
>> dev_item.io_width       4096
>> dev_item.sector_size    4096
>> dev_item.devid          1
>> dev_item.dev_group      0
>> dev_item.seek_speed     0
>> dev_item.bandwidth      0
>> dev_item.generation     0
>
> Does anyone have an idea why I can't mount it anymore?
>
> Regards,
> Tobias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


