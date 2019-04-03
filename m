Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17C4C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 08:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF42D206BA
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 08:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfDCIE0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 04:04:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:40922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725936AbfDCIE0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 04:04:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7D445ADA3;
        Wed,  3 Apr 2019 08:04:24 +0000 (UTC)
Subject: Re: life time of backup roots
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTwrBS-ZCm=MWStBdfm4iRgMiCt9vnC-WZHYNr9m1dO_Q@mail.gmail.com>
 <186f3845-10b2-35c0-0ca3-3518b45acdd8@gmx.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <701c3374-c603-39ac-f964-2252e03abdfc@suse.com>
Date:   Wed, 3 Apr 2019 11:04:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <186f3845-10b2-35c0-0ca3-3518b45acdd8@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.04.19 г. 10:05 ч., Qu Wenruo wrote:
> 
> 
> On 2019/4/3 上午11:58, Chris Murphy wrote:
>> I'm sometimes seeing the same backup_tree_root used more than once.
>> Below you'll see backup 0 and backup 2 have the same address,
>> different generation. The concern is if this suggests backup 2 is
>> actually stale and not useful?
> 
> Currently, backup root of btrfs only has a life time of one generation.
> 
> That's to say, any backup older than current generation - 1 is already
> stale.

Yeah, backup roots should really be perceived as a "best-effort" type of
mechanism rather than something guaranteeing you can go back 4
generations w.r.t fs state.

> 
> Filipe had tried to make btrfs to pin down extents up to 4 generations.
> Thus btrfs could make all 4 backup roots valid, but that leaded to a lot
> of ENOSPC. So he gave up that idea.
> 
> Thanks,
> Qu
> 
>>
>> We've previously seen that Btrfs with discard mount option can very
>> quickly cause the locations pointed to by backup roots to return no
>> data (metadata deallocated and trimmed). I wonder if this is similar
>> where Btrfs has no concept of delaying metadata deallocation for a
>> while so that the backup trees remain valid for a while (few minutes?)
>> Anyway if these backup roots can become stale, if they're ever needed
>> they're not going to be useful.
>>
>> superblock: bytenr=65536, device=/dev/mapper/sdc
>> ---------------------------------------------------------
>> csum_type        0 (crc32c)
>> csum_size        4
>> csum            0xe0c01b78 [match]
>> bytenr            65536
>> flags            0x1
>>             ( WRITTEN )
>> magic            _BHRfS_M [match]
>> fsid            ecd5e90e-6fb7-4b42-ab57-515a733c01f2
>> metadata_uuid        ecd5e90e-6fb7-4b42-ab57-515a733c01f2
>> label            third
>> generation        686
>> root            3355115520
>> sys_array_size        129
>> chunk_root_generation    685
>> root_level        1
>> chunk_root        4325376000
>> chunk_root_level    1
>> log_root        0
>> log_root_transid    0
>> log_root_level        0
>> total_bytes        1000207335424
>> bytes_used        439356653568
>> sectorsize        4096
>> nodesize        32768
>> leafsize (deprecated)    32768
>> stripesize        4096
>> root_dir        6
>> num_devices        2
>> compat_flags        0x0
>> compat_ro_flags        0x3
>>             ( FREE_SPACE_TREE |
>>               FREE_SPACE_TREE_VALID )
>> incompat_flags        0x171
>>             ( MIXED_BACKREF |
>>               COMPRESS_ZSTD |
>>               BIG_METADATA |
>>               EXTENDED_IREF |
>>               SKINNY_METADATA )
>> cache_generation    18446744073709551615
>> uuid_tree_generation    686
>> dev_item.uuid        de7a23cd-ec25-47d4-bbdb-fcf9c4dc705a
>> dev_item.fsid        ecd5e90e-6fb7-4b42-ab57-515a733c01f2 [match]
>> dev_item.type        0
>> dev_item.total_bytes    500103667712
>> dev_item.bytes_used    442415185920
>> dev_item.io_align    4096
>> dev_item.io_width    4096
>> dev_item.sector_size    4096
>> dev_item.devid        2
>> dev_item.dev_group    0
>> dev_item.seek_speed    0
>> dev_item.bandwidth    0
>> dev_item.generation    0
>> sys_chunk_array[2048]:
>>     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 4325376000)
>>         length 33554432 owner 2 stripe_len 65536 type SYSTEM|RAID1
>>         io_align 65536 io_width 65536 sector_size 4096
>>         num_stripes 2 sub_stripes 1
>>             stripe 0 devid 2 offset 1083179008
>>             dev_uuid de7a23cd-ec25-47d4-bbdb-fcf9c4dc705a
>>             stripe 1 devid 1 offset 1104150528
>>             dev_uuid 15e28877-dbc7-446d-9991-618504a758ca
>> backup_roots[4]:
>>     backup 0:
>>         backup_tree_root:    3355115520    gen: 686    level: 1
>>         backup_chunk_root:    4325376000    gen: 685    level: 1
>>         backup_extent_root:    3358523392    gen: 686    level: 2
>>         backup_fs_root:        3550511104    gen: 497    level: 0
>>         backup_dev_root:    3358752768    gen: 685    level: 1
>>         backup_csum_root:    3259400192    gen: 500    level: 2
>>         backup_total_bytes:    1000207335424
>>         backup_bytes_used:    439356653568
>>         backup_num_devices:    2
>>
>>     backup 1:
>>         backup_tree_root:    3358752768    gen: 683    level: 1
>>         backup_chunk_root:    4325441536    gen: 677    level: 1
>>         backup_extent_root:    3359506432    gen: 683    level: 2
>>         backup_fs_root:        3550511104    gen: 497    level: 0
>>         backup_dev_root:    3358982144    gen: 677    level: 1
>>         backup_csum_root:    3259400192    gen: 500    level: 2
>>         backup_total_bytes:    1000207335424
>>         backup_bytes_used:    439356653568
>>         backup_num_devices:    2
>>
>>     backup 2:
>>         backup_tree_root:    3355115520    gen: 684    level: 1
>>         backup_chunk_root:    4325441536    gen: 677    level: 1
>>         backup_extent_root:    3358523392    gen: 684    level: 2
>>         backup_fs_root:        3550511104    gen: 497    level: 0
>>         backup_dev_root:    3358982144    gen: 677    level: 1
>>         backup_csum_root:    3259400192    gen: 500    level: 2
>>         backup_total_bytes:    1000207335424
>>         backup_bytes_used:    439356653568
>>         backup_num_devices:    2
>>
>>     backup 3:
>>         backup_tree_root:    3359834112    gen: 685    level: 1
>>         backup_chunk_root:    4325376000    gen: 685    level: 1
>>         backup_extent_root:    3361898496    gen: 685    level: 2
>>         backup_fs_root:        3550511104    gen: 497    level: 0
>>         backup_dev_root:    3358752768    gen: 685    level: 1
>>         backup_csum_root:    3259400192    gen: 500    level: 2
>>         backup_total_bytes:    1000207335424
>>         backup_bytes_used:    439356653568
>>         backup_num_devices:    2
>>
>>
>>
>>
> 
