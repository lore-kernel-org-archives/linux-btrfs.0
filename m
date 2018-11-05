Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F6AC46464
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 18:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75A3A22503
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 18:10:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75A3A22503
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387789AbeKFDb1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 22:31:27 -0500
Received: from mail-lf1-f51.google.com ([209.85.167.51]:36198 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387595AbeKFDb0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 22:31:26 -0500
Received: by mail-lf1-f51.google.com with SMTP id h192so6856916lfg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2018 10:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=QcQxmNf2G2IQPPFqCzcmZQ882LjFJmT42IzEQcq7MJ4=;
        b=q7orSNpwGEKYyd9vJ35mw5oXsX3SBUBXDhqWiMn1MOMzLdNEWGJE8rEMoEubkCdxOw
         1NQnK6VwkUdY3qCK6DwWI1kLoEoKPCzmwbnHpSUYQwXsX07J3aIxMtdgsPAd4J2nXAn7
         ypV8MJAnXCoo/qafAtSglvfTO/SaXozOcX6Ewfw8lLLsu+1/I0kPWJ8YQDzjeQkZCota
         R5L/6EOHErfNbvWqhv43XPKTavBU0+lGMDQZMC6Zj2ffYE3qmHrjMTwi9tzYERMFY1+X
         MWf7w0Tqqvy3SOLVkJslxoH/gnMLU2K0Ae0VFRu79ClpYKVmwqMBnAjawExualnIA3bY
         5wEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=QcQxmNf2G2IQPPFqCzcmZQ882LjFJmT42IzEQcq7MJ4=;
        b=UL5EUGi56eJYmq+YnTFdNCd7DLPZyRfhhccf9G5DCqDcHXktizWW79VMetPRYNWHL8
         TfKEWipdP1QYiVNvpax4/H6LPdOTS9hwgurX4B2jyZ+5scQL7TTsaSWg4oNViXlVVm4y
         pMXwY10gtYTL3xlrZWYS+33ihCuCXFN6LQjuEHcDVrZ+eSmMRa+bIygVcfFwWui/0wCu
         J7kpGwhSgHE8VhL1hqG+6aPkAqCbDVlzW7HnmJKWvWA09XRCntFSWZAYn1lUsDc5wpTY
         HzF5CLMpj40RMoOXcTBrT6u0U0Erd4wkiws3dsTpzZRFHPdD3O1P6m0CRLAFGdBa/S8U
         Z5GQ==
X-Gm-Message-State: AGRZ1gIxqrmqQAT3AbpALtpiTMfyabL5bNBJEnkJYpdmevfNSK2gp7ys
        38cO2taEzSrX1Di16z/h9xd/7k/RmchXT2oL1ThEt6/3
X-Google-Smtp-Source: AJdET5ewoB0L4Aw4K9K5DONhWT8TrA+JV2+cfxSbii6/Q1l30Ym4WE8Yg5D82fsl/aqHeUOFxFdVLCrwUXs/gOhVaBg=
X-Received: by 2002:a19:641d:: with SMTP id y29mr12945006lfb.14.1541441430751;
 Mon, 05 Nov 2018 10:10:30 -0800 (PST)
MIME-Version: 1.0
References: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
 <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com>
In-Reply-To: <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com>
From:   Attila Vangel <vangel.attila@gmail.com>
Date:   Mon, 5 Nov 2018 18:10:20 +0000
Message-ID: <CAGSQd29wes1P6yxEUOG-u5Go+TNqK4BfvCsvMK9obrwCLnuV+w@mail.gmail.com>
Subject: Re: btrfs partition is broken, cannot restore anything
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Stupid gmail has put my email (or Qu's reply? ) to spam, so I just saw
the reply after I sent my reply (gmail asked me whether to remove it
from spam).

Anyway here is the requested output. Thanks for the help!

$ sudo btrfs check /dev/nvme0n1p2
Opening filesystem to check...
checksum verify failed on 18811453440 found E4E3BDB6 wanted 00000000
checksum verify failed on 18811453440 found E4E3BDB6 wanted 00000000
bad tree block 18811453440, bytenr mismatch, want=18811453440, have=0
ERROR: cannot open file system

$ sudo btrfs check --mode=lowmem /dev/nvme0n1p2
Opening filesystem to check...
checksum verify failed on 18811453440 found E4E3BDB6 wanted 00000000
checksum verify failed on 18811453440 found E4E3BDB6 wanted 00000000
bad tree block 18811453440, bytenr mismatch, want=18811453440, have=0
ERROR: cannot open file system

Regards,
Attila

On Mon, Nov 5, 2018 at 6:01 PM Attila Vangel <vangel.attila@gmail.com> wrote:
>
> Hi,
>
> TL;DR: I want to save data from my unmountable btrfs partition.
> I saw some commands in another thread "Salvage files from broken btrfs".
> I use the most recent Manjaro live (kernel: 4.19.0-3-MANJARO,
> btrfs-progs 4.17.1-1) to execute these commands.
>
> $ sudo mount -o ro,nologreplay /dev/nvme0n1p2 /mnt
> mount: /mnt: wrong fs type, bad option, bad superblock on
> /dev/nvme0n1p2, missing codepage or helper program, or other error.
>
> Corresponding lines from dmesg:
>
> [ 1517.772302] BTRFS info (device nvme0n1p2): disabling log replay at mount time
> [ 1517.772307] BTRFS info (device nvme0n1p2): disk space caching is enabled
> [ 1517.772310] BTRFS info (device nvme0n1p2): has skinny extents
> [ 1517.793414] BTRFS error (device nvme0n1p2): bad tree block start,
> want 18811453440 have 0
> [ 1517.793430] BTRFS error (device nvme0n1p2): failed to read block groups: -5
> [ 1517.808619] BTRFS error (device nvme0n1p2): open_ctree failed
>
> $ sudo btrfs-find-root /dev/nvme0n1p2
> Superblock thinks the generation is 220524
> Superblock thinks the level is 1
> Found tree root at 25018368 gen 220524 level 1
> Well block 4243456(gen: 220520 level: 1) seems good, but
> generation/level doesn't match, want gen: 220524 level: 1
> Well block 5259264(gen: 220519 level: 1) seems good, but
> generation/level doesn't match, want gen: 220524 level: 1
> Well block 4866048(gen: 220518 level: 0) seems good, but
> generation/level doesn't match, want gen: 220524 level: 1
>
> $ sudo btrfs ins dump-super -Ffa /dev/nvme0n1p2
> superblock: bytenr=65536, device=/dev/nvme0n1p2
> ---------------------------------------------------------
> csum_type        0 (crc32c)
> csum_size        4
> csum            0x7956a931 [match]
> bytenr            65536
> flags            0x1
>             ( WRITTEN )
> magic            _BHRfS_M [match]
> fsid            014c9d24-339c-482e-8f06-9284e4a7bc40
> label            newhome
> generation        220524
> root            25018368
> sys_array_size        97
> chunk_root_generation    219209
> root_level        1
> chunk_root        131072
> chunk_root_level    1
> log_root        86818816
> log_root_transid    0
> log_root_level        0
> total_bytes        355938074624
> bytes_used        344504737792
> sectorsize        4096
> nodesize        16384
> leafsize (deprecated)        16384
> stripesize        4096
> root_dir        6
> num_devices        1
> compat_flags        0x0
> compat_ro_flags        0x0
> incompat_flags        0x161
>             ( MIXED_BACKREF |
>               BIG_METADATA |
>               EXTENDED_IREF |
>               SKINNY_METADATA )
> cache_generation    220524
> uuid_tree_generation    220524
> dev_item.uuid        05fe6ce8-1f2d-41ba-a367-cbdb8f06ffd3
> dev_item.fsid        014c9d24-339c-482e-8f06-9284e4a7bc40 [match]
> dev_item.type        0
> dev_item.total_bytes    355938074624
> dev_item.bytes_used    355792322560
> dev_item.io_align    4096
> dev_item.io_width    4096
> dev_item.sector_size    4096
> dev_item.devid        1
> dev_item.dev_group    0
> dev_item.seek_speed    0
> dev_item.bandwidth    0
> dev_item.generation    0
> sys_chunk_array[2048]:
>     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
>         length 4194304 owner 2 stripe_len 65536 type SYSTEM
>         io_align 4096 io_width 4096 sector_size 4096
>         num_stripes 1 sub_stripes 0
>             stripe 0 devid 1 offset 0
>             dev_uuid 05fe6ce8-1f2d-41ba-a367-cbdb8f06ffd3
> backup_roots[4]:
>     backup 0:
>         backup_tree_root:    42598400    gen: 220522    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    26460160    gen: 220522    level: 2
>         backup_fs_root:        51347456    gen: 220523    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    26558464    gen: 220522    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344504741888
>         backup_num_devices:    1
>
>     backup 1:
>         backup_tree_root:    52363264    gen: 220523    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    51806208    gen: 220523    level: 2
>         backup_fs_root:        51347456    gen: 220523    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    52461568    gen: 220523    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344504729600
>         backup_num_devices:    1
>
>     backup 2:
>         backup_tree_root:    25018368    gen: 220524    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    21479424    gen: 220524    level: 2
>         backup_fs_root:        53084160    gen: 220524    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    53379072    gen: 220524    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344504737792
>         backup_num_devices:    1
>
>     backup 3:
>         backup_tree_root:    21921792    gen: 220521    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    5570560    gen: 220521    level: 2
>         backup_fs_root:        4571136    gen: 220521    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    5619712    gen: 220521    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344506957824
>         backup_num_devices:    1
>
>
> superblock: bytenr=67108864, device=/dev/nvme0n1p2
> ---------------------------------------------------------
> csum_type        0 (crc32c)
> csum_size        4
> csum            0x36d97b1b [match]
> bytenr            67108864
> flags            0x1
>             ( WRITTEN )
> magic            _BHRfS_M [match]
> fsid            014c9d24-339c-482e-8f06-9284e4a7bc40
> label            newhome
> generation        220524
> root            25018368
> sys_array_size        97
> chunk_root_generation    219209
> root_level        1
> chunk_root        131072
> chunk_root_level    1
> log_root        0
> log_root_transid    0
> log_root_level        0
> total_bytes        355938074624
> bytes_used        344504737792
> sectorsize        4096
> nodesize        16384
> leafsize (deprecated)        16384
> stripesize        4096
> root_dir        6
> num_devices        1
> compat_flags        0x0
> compat_ro_flags        0x0
> incompat_flags        0x161
>             ( MIXED_BACKREF |
>               BIG_METADATA |
>               EXTENDED_IREF |
>               SKINNY_METADATA )
> cache_generation    220524
> uuid_tree_generation    220524
> dev_item.uuid        05fe6ce8-1f2d-41ba-a367-cbdb8f06ffd3
> dev_item.fsid        014c9d24-339c-482e-8f06-9284e4a7bc40 [match]
> dev_item.type        0
> dev_item.total_bytes    355938074624
> dev_item.bytes_used    355792322560
> dev_item.io_align    4096
> dev_item.io_width    4096
> dev_item.sector_size    4096
> dev_item.devid        1
> dev_item.dev_group    0
> dev_item.seek_speed    0
> dev_item.bandwidth    0
> dev_item.generation    0
> sys_chunk_array[2048]:
>     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
>         length 4194304 owner 2 stripe_len 65536 type SYSTEM
>         io_align 4096 io_width 4096 sector_size 4096
>         num_stripes 1 sub_stripes 0
>             stripe 0 devid 1 offset 0
>             dev_uuid 05fe6ce8-1f2d-41ba-a367-cbdb8f06ffd3
> backup_roots[4]:
>     backup 0:
>         backup_tree_root:    42598400    gen: 220522    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    26460160    gen: 220522    level: 2
>         backup_fs_root:        51347456    gen: 220523    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    26558464    gen: 220522    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344504741888
>         backup_num_devices:    1
>
>     backup 1:
>         backup_tree_root:    52363264    gen: 220523    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    51806208    gen: 220523    level: 2
>         backup_fs_root:        51347456    gen: 220523    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    52461568    gen: 220523    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344504729600
>         backup_num_devices:    1
>
>     backup 2:
>         backup_tree_root:    25018368    gen: 220524    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    21479424    gen: 220524    level: 2
>         backup_fs_root:        53084160    gen: 220524    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    53379072    gen: 220524    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344504737792
>         backup_num_devices:    1
>
>     backup 3:
>         backup_tree_root:    21921792    gen: 220521    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    5570560    gen: 220521    level: 2
>         backup_fs_root:        4571136    gen: 220521    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    5619712    gen: 220521    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344506957824
>         backup_num_devices:    1
>
>
> superblock: bytenr=274877906944, device=/dev/nvme0n1p2
> ---------------------------------------------------------
> csum_type        0 (crc32c)
> csum_size        4
> csum            0xcb5e2d2a [match]
> bytenr            274877906944
> flags            0x1
>             ( WRITTEN )
> magic            _BHRfS_M [match]
> fsid            014c9d24-339c-482e-8f06-9284e4a7bc40
> label            newhome
> generation        220524
> root            25018368
> sys_array_size        97
> chunk_root_generation    219209
> root_level        1
> chunk_root        131072
> chunk_root_level    1
> log_root        0
> log_root_transid    0
> log_root_level        0
> total_bytes        355938074624
> bytes_used        344504737792
> sectorsize        4096
> nodesize        16384
> leafsize (deprecated)        16384
> stripesize        4096
> root_dir        6
> num_devices        1
> compat_flags        0x0
> compat_ro_flags        0x0
> incompat_flags        0x161
>             ( MIXED_BACKREF |
>               BIG_METADATA |
>               EXTENDED_IREF |
>               SKINNY_METADATA )
> cache_generation    220524
> uuid_tree_generation    220524
> dev_item.uuid        05fe6ce8-1f2d-41ba-a367-cbdb8f06ffd3
> dev_item.fsid        014c9d24-339c-482e-8f06-9284e4a7bc40 [match]
> dev_item.type        0
> dev_item.total_bytes    355938074624
> dev_item.bytes_used    355792322560
> dev_item.io_align    4096
> dev_item.io_width    4096
> dev_item.sector_size    4096
> dev_item.devid        1
> dev_item.dev_group    0
> dev_item.seek_speed    0
> dev_item.bandwidth    0
> dev_item.generation    0
> sys_chunk_array[2048]:
>     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
>         length 4194304 owner 2 stripe_len 65536 type SYSTEM
>         io_align 4096 io_width 4096 sector_size 4096
>         num_stripes 1 sub_stripes 0
>             stripe 0 devid 1 offset 0
>             dev_uuid 05fe6ce8-1f2d-41ba-a367-cbdb8f06ffd3
> backup_roots[4]:
>     backup 0:
>         backup_tree_root:    42598400    gen: 220522    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    26460160    gen: 220522    level: 2
>         backup_fs_root:        51347456    gen: 220523    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    26558464    gen: 220522    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344504741888
>         backup_num_devices:    1
>
>     backup 1:
>         backup_tree_root:    52363264    gen: 220523    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    51806208    gen: 220523    level: 2
>         backup_fs_root:        51347456    gen: 220523    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    52461568    gen: 220523    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344504729600
>         backup_num_devices:    1
>
>     backup 2:
>         backup_tree_root:    25018368    gen: 220524    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    21479424    gen: 220524    level: 2
>         backup_fs_root:        53084160    gen: 220524    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    53379072    gen: 220524    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344504737792
>         backup_num_devices:    1
>
>     backup 3:
>         backup_tree_root:    21921792    gen: 220521    level: 1
>         backup_chunk_root:    131072    gen: 219209    level: 1
>         backup_extent_root:    5570560    gen: 220521    level: 2
>         backup_fs_root:        4571136    gen: 220521    level: 2
>         backup_dev_root:    4472832    gen: 220520    level: 1
>         backup_csum_root:    5619712    gen: 220521    level: 2
>         backup_total_bytes:    355938074624
>         backup_bytes_used:    344506957824
>         backup_num_devices:    1
>
> If I understood correctly, somehow it is possible to use this data to
> parametrize btrfs restore to save the files from the partition.
> Could you please help how to do it in this case? I am not familiar
> with these technical terms in the outputs.
> Thanks in advance!
>
> Cheers,
> Attila
>
> On Thu, Nov 1, 2018 at 8:40 PM Attila Vangel <vangel.attila@gmail.com> wrote:
> >
> > Hi,
> >
> > Somehow my btrfs partition got broken. I use Arch, so my kernel is
> > quite new (4.18.x).
> > I don't remember exactly the sequence of events. At some point it was
> > accessible in read-only, but unfortunately I did not take backup
> > immediately. dmesg log from that time:
> >
> > [ 62.602388] BTRFS warning (device nvme0n1p2): block group
> > 103923318784 has wrong amount of free space
> > [ 62.602390] BTRFS warning (device nvme0n1p2): failed to load free
> > space cache for block group 103923318784, rebuilding it now
> > [ 108.039188] BTRFS error (device nvme0n1p2): bad tree block start 0 18812026880
> > [ 108.039227] BTRFS: error (device nvme0n1p2) in
> > __btrfs_free_extent:7010: errno=-5 IO failure
> > [ 108.039241] BTRFS info (device nvme0n1p2): forced readonly
> > [ 108.039250] BTRFS: error (device nvme0n1p2) in
> > btrfs_run_delayed_refs:3076: errno=-5 IO failure
> >
> > At the next reboot it failed to mount. Problem may have been that at
> > some point I booted to another distro with older kernel (4.15.x,
> > 4.14.52) and unfortunately attempted some checks/repairs (?) e.g. from
> > gparted, and at that time I did not know it could be destructive.
> >
> > Anyway, currently it fails to mount (even with ro and/or recovery),
> > btrfs check results in "checksum verify failed" and "bad tree block"
> > errors, btrfs restore resulted in "We have looped trying to restore
> > files in" errors for a dozen of paths then exit.
> >
> > Is there some hope to save data from the filesystem, and if so, how?
> >
> > BTW I checked some diagnostics commands regarding my SSD with the nvme
> > client and from that it seems there are no hardware problems.
> >
> > Your help is highly appreciated.
> >
> > Cheers,
> > Attila
