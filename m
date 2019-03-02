Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04418C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 02:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE5942075B
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 02:55:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="q9aJMRy/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfCBCzI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 21:55:08 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:46242 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbfCBCzI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2019 21:55:08 -0500
Received: by mail-lj1-f170.google.com with SMTP id v16so22111802ljg.13
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 18:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qr1sbDQNzHEolBgFN7CuW7hFxXAYqJWdSrgC7yA5ojY=;
        b=q9aJMRy/xXtFLY1Or5Q8WfivLyxt/gg9yAGnNSllVkFxI090qPVWGh/bt33ZfjgiJJ
         SBkHVhzTqosyfB0DL9DfG3uFZr42i+QcT7pZWUGoQjNO807kIuaRPXn5JqWSqNvOUFQz
         ih/FCphkU6q289ShysdHqzNc7Mgvv7LVHjGesKOrcvjl7/0U7WZjv2+YWfyh/NrCcB4r
         1iruYXu6Ak4aahf0IyrRL5x2MapaiiEaClb4/mhHRBK1NO0bwDBlSxEgT9pBTscePokb
         zufU+GqxgkdLZx8fJeamb+sKdG3fs2Mt0tKaQ6CB7thwi5TkbYERXPoNfg/aw2HfSEem
         Z2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qr1sbDQNzHEolBgFN7CuW7hFxXAYqJWdSrgC7yA5ojY=;
        b=D8QOdmftP7O1ozN1R5sEDhrbbJrlTK8MK/ets1iNHz2N2uC5ohlO1PPyakSE5nkAcD
         1oSYe5fONk6DcA+qC5ImT1f8ChxdPEyqyGzemOU8Leq5iLTHS3LFBE02QQD3Otbu67ua
         jUGqDVtjk/rAA+umS1DcodTiU6lnEeWe3HINhE+dBQObL8hmJNPMyePIaDvO8KuZwHLg
         mTQYaiUwgTbXppSV7f8EOnA/eKGLX8pr5nFNLRwSa7xkDFlolgIWefekmVoYBxmdca0I
         fM2LkfcCfaBH00rx4nCmQq/BiL0nQWM79rGsk16i6jpW/CHDcX1+yEvb/a/rULSAWAJr
         z89Q==
X-Gm-Message-State: APjAAAWrrSqKERm5XgYhrCim4gE+KT4+bCoZAhD5U/JZeS2zmbpcJLlU
        bJiXroANOVA1sDE/YWAbumouDbfLsYk6W9Vo1/3ijg==
X-Google-Smtp-Source: APXvYqzV/dklcShMGKax/j7CjLOo3pReBBpcUD0d7q6qMbfE8ihlYl1ay1HsHgirio+F+qHSHo1hF5kHJPdy1vyFFXc=
X-Received: by 2002:a2e:2419:: with SMTP id k25mr4410052ljk.38.1551495304929;
 Fri, 01 Mar 2019 18:55:04 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
 <4dfdc5a4-a6d7-e96b-afa1-a9c71b123a96@gmx.com> <CAJCQCtT+VnSp_8i-QWT6iwCv9yaqQv2XfsVtsdvQmoG70aQZ7w@mail.gmail.com>
In-Reply-To: <CAJCQCtT+VnSp_8i-QWT6iwCv9yaqQv2XfsVtsdvQmoG70aQZ7w@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 1 Mar 2019 19:54:53 -0700
Message-ID: <CAJCQCtQvi77SZbL4_fK1B5jNRpYhWOHBQOKvZ2Pdr8AoJDBXBg@mail.gmail.com>
Subject: Re: [bug] btrfs check clear-space-cache v1 corrupted file system
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

OK this is screwy. The super has a totally different generation for
the root tree than any of the backup roots.

$ sudo btrfs rescue super -v /dev/mapper/sdd
All Devices:
    Device: id = 1, name = /dev/mapper/sdc
    Device: id = 2, name = /dev/mapper/sdd

Before Recovering:
    [All good supers]:
        device name = /dev/mapper/sdc
        superblock bytenr = 65536

        device name = /dev/mapper/sdc
        superblock bytenr = 67108864

        device name = /dev/mapper/sdc
        superblock bytenr = 274877906944

        device name = /dev/mapper/sdd
        superblock bytenr = 65536

        device name = /dev/mapper/sdd
        superblock bytenr = 67108864

        device name = /dev/mapper/sdd
        superblock bytenr = 274877906944

    [All bad supers]:

All supers are valid, no need to recover

$ sudo btrfs insp dump-s -f /dev/mapper/sdd
superblock: bytenr=65536, device=/dev/mapper/sdd
---------------------------------------------------------
csum_type        0 (crc32c)
csum_size        4
csum            0x312a8b5e [match]
bytenr            65536
flags            0x1
            ( WRITTEN )
magic            _BHRfS_M [match]
fsid            f5adc913-bbea-4340-8b5f-3411e2cda642
label            second
generation        4514
root            29392896
sys_array_size        258
chunk_root_generation    3823
root_level        1
chunk_root        822549151744
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        1500308553728
bytes_used        735327125504
sectorsize        4096
nodesize        16384
leafsize (deprecated)        16384
stripesize        4096
root_dir        6
num_devices        2
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x161
            ( MIXED_BACKREF |
              BIG_METADATA |
              EXTENDED_IREF |
              SKINNY_METADATA )
cache_generation    4076
uuid_tree_generation    4076
dev_item.uuid        2fbaa023-7cf8-4f48-b4ed-c6e18c99d2bd
dev_item.fsid        f5adc913-bbea-4340-8b5f-3411e2cda642 [match]
dev_item.type        0
dev_item.total_bytes    750154276864
dev_item.bytes_used    737702576128
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        2
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
    item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
        length 8388608 owner 2 stripe_len 65536 type SYSTEM|RAID1
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 0
            stripe 0 devid 2 offset 1048576
            dev_uuid 2fbaa023-7cf8-4f48-b4ed-c6e18c99d2bd
            stripe 1 devid 1 offset 20971520
            dev_uuid d071b0ca-1d27-48cb-826e-63c5e9972339
    item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 822549151744)
        length 33554432 owner 2 stripe_len 65536 type SYSTEM|RAID1
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 1
            stripe 0 devid 2 offset 737670070272
            dev_uuid 2fbaa023-7cf8-4f48-b4ed-c6e18c99d2bd
            stripe 1 devid 1 offset 737689993216
            dev_uuid d071b0ca-1d27-48cb-826e-63c5e9972339
backup_roots[4]:
    backup 0:
        backup_tree_root:    931053568    gen: 4075    level: 1
        backup_chunk_root:    822549151744    gen: 3823    level: 1
        backup_extent_root:    931086336    gen: 4075    level: 2
        backup_fs_root:        537116672    gen: 3806    level: 0
        backup_dev_root:    721174528    gen: 3823    level: 1
        backup_csum_root:    932249600    gen: 4075    level: 2
        backup_total_bytes:    1500308553728
        backup_bytes_used:    735441764352
        backup_num_devices:    2

    backup 1:
        backup_tree_root:    930086912    gen: 4076    level: 1
        backup_chunk_root:    822549151744    gen: 3823    level: 1
        backup_extent_root:    930447360    gen: 4076    level: 2
        backup_fs_root:        537116672    gen: 3806    level: 0
        backup_dev_root:    930856960    gen: 4076    level: 1
        backup_csum_root:    932118528    gen: 4076    level: 2
        backup_total_bytes:    1500308553728
        backup_bytes_used:    735441764352
        backup_num_devices:    2

    backup 2:
        backup_tree_root:    930070528    gen: 4073    level: 1
        backup_chunk_root:    822549151744    gen: 3823    level: 1
        backup_extent_root:    930365440    gen: 4073    level: 2
        backup_fs_root:        537116672    gen: 3806    level: 0
        backup_dev_root:    721174528    gen: 3823    level: 1
        backup_csum_root:    931086336    gen: 4073    level: 2
        backup_total_bytes:    1500308553728
        backup_bytes_used:    735441764352
        backup_num_devices:    2

    backup 3:
        backup_tree_root:    930086912    gen: 4074    level: 1
        backup_chunk_root:    822549151744    gen: 3823    level: 1
        backup_extent_root:    930447360    gen: 4074    level: 2
        backup_fs_root:        537116672    gen: 3806    level: 0
        backup_dev_root:    721174528    gen: 3823    level: 1
        backup_csum_root:    932052992    gen: 4074    level: 2
        backup_total_bytes:    1500308553728
        backup_bytes_used:    735441764352
        backup_num_devices:    2
$


Super says root tree generation 4514; but the most recent backup says
4076. What?

# btrfs insp dump-t -b 930086912 /dev/mapper/sdd
btrfs-progs v4.19.1
node 930086912 level 1 items 19 free 474 generation 4076 owner ROOT_TREE
fs uuid f5adc913-bbea-4340-8b5f-3411e2cda642
chunk uuid 4af0d265-00fa-4a2b-9ea9-59c06a372284
    key (EXTENT_TREE ROOT_ITEM 0) block 931102720 gen 4076
    key (279 INODE_ITEM 0) block 535216128 gen 3802
    key (307 INODE_ITEM 0) block 715111579648 gen 3511
    key (368 EXTENT_DATA 0) block 715103928320 gen 3510
    key (430 INODE_ITEM 0) block 715111612416 gen 3511
    key (491 EXTENT_DATA 0) block 715111677952 gen 3511
    key (553 INODE_ITEM 0) block 715111841792 gen 3511
    key (652 EXTENT_DATA 0) block 714560716800 gen 3523
    key (711 INODE_ITEM 0) block 934019072 gen 4076
    key (773 INODE_ITEM 0) block 934887424 gen 4076
    key (829 INODE_ITEM 0) block 671989760 gen 3808
    key (884 INODE_ITEM 0) block 714619404288 gen 3525
    key (939 ROOT_ITEM 1889) block 715035377664 gen 3506
    key (981 ROOT_ITEM 3330) block 933658624 gen 4067
    key (1034 INODE_ITEM 0) block 172621824 gen 3546
    key (1095 EXTENT_DATA 0) block 934232064 gen 4076
    key (FREE_SPACE UNTYPED 11840520192) block 934248448 gen 4076
    key (FREE_SPACE UNTYPED 275981008896) block 934658048 gen 4076
    key (FREE_SPACE UNTYPED 568038785024) block 933724160 gen 4067
# btrfs insp dump-t -b 29392896 /dev/mapper/sdd
btrfs-progs v4.19.1
node 29392896 level 1 items 10 free 483 generation 4514 owner ROOT_TREE
fs uuid f5adc913-bbea-4340-8b5f-3411e2cda642
chunk uuid 4af0d265-00fa-4a2b-9ea9-59c06a372284
    key (EXTENT_TREE ROOT_ITEM 0) block 712994078720 gen 4514
    key (773 INODE_ITEM 0) block 29442048 gen 4470
    key (829 INODE_ITEM 0) block 671989760 gen 3808
    key (884 INODE_ITEM 0) block 714619404288 gen 3525
    key (939 ROOT_ITEM 1889) block 715035377664 gen 3506
    key (981 ROOT_ITEM 3330) block 933658624 gen 4067
    key (1034 INODE_ITEM 0) block 172621824 gen 3546
    key (1095 EXTENT_DATA 0) block 29409280 gen 4514
    key (FREE_SPACE UNTYPED 559448850432) block 29376512 gen 4483
    key (FREE_SPACE UNTYPED 568038785024) block 933724160 gen 4067
#

I guess I don't understand why 'btrfs check' would have successfully
written six updated copies of the super, when the operation hadn't yet
succeeded. I guess this isn't an atomic operation, and perhaps it
can't be.

---
Chris Murphy
