Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38009C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 03:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE2352084B
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 03:58:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="coBfE1dB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfDCD6f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 23:58:35 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:41738 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfDCD6f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 23:58:35 -0400
Received: by mail-lj1-f182.google.com with SMTP id k8so5125126lja.8
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 20:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=Xvx2vwRs2r06nNJizGZxRIq5QPzNgJWniJwrIvmzL2s=;
        b=coBfE1dBVS9yoBlh34LRgQLnXOVomhvFRye+M6m5R2xOgXgXpC/wM8Bi6FbQ0mllig
         I5Uqa0D5Sykrxl5L5BcbRZ/CmTl40rIyDozsQ4zrECUj9Z73wm0ILMLL26KK5eG53eUu
         4gK9BF+sYuex92K2wojZThhMG9TaYAQfJhIogMd5ZaO2osjIjg4ZeufYdP6navQs4+Ho
         VtY+HjwYP9oePAScwIj85whOh2BtYq37Stld+uM2wuOOtGUuni+Y3VdQq/iwurKnnzRf
         BoUH8/Jxc+11Ah4anIp1nGnHbQ3cog5k8K4pbdRbswbDsaFw3/QwfsRJXzsZ8cRzivMN
         NOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Xvx2vwRs2r06nNJizGZxRIq5QPzNgJWniJwrIvmzL2s=;
        b=N0DRGd9YWs5BVbu8EyhBajxg48LjQuAhzmOlXYzbOlSNmuLmdTWccY3TnQH28QKQXC
         6ECfVhroFqiQmefFRd2S27J6oPRglFU0tlIamYG8CqdvQdwSavFpKbA+1auOKcrYTeBB
         PJRKDm6yuwnFnWJBRDGwwy/g10Lq2UULo2x6edmonMiOS0eHzd+dRJxs0JGjhO4XbfXJ
         D5gpmOpluJOK7iM0pkK0gAHzxe4cXSYyfhzTa3d1uM4dXueZHOtGjFqtjDUTjssKgAde
         WmCgxZXItOdOoR79kg2DTsBkTJsBMsIjtJ9GuRNUYskci6BQS8vbEy7sEVN6GUbUoREA
         FTlQ==
X-Gm-Message-State: APjAAAUxeseDbFYamTYc72W0zCHPDuKrB4bnifALrCmj5B6CylRlPsfn
        MLBOJEZuulKUBuUoD5ZEFypiKQTRKAQ+YS9Kntc09RrcA8U=
X-Google-Smtp-Source: APXvYqytcDYd30SuJsVfSeqhVPNLrB+2J3oEu5ylKDUBuihZFVMNf6HxhFkSwYde1DVEL+xyJA174QCnDNq0TU5c73A=
X-Received: by 2002:a2e:9d12:: with SMTP id t18mr7232942lji.163.1554263911984;
 Tue, 02 Apr 2019 20:58:31 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 2 Apr 2019 21:58:21 -0600
Message-ID: <CAJCQCtTwrBS-ZCm=MWStBdfm4iRgMiCt9vnC-WZHYNr9m1dO_Q@mail.gmail.com>
Subject: life time of backup roots
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'm sometimes seeing the same backup_tree_root used more than once.
Below you'll see backup 0 and backup 2 have the same address,
different generation. The concern is if this suggests backup 2 is
actually stale and not useful?

We've previously seen that Btrfs with discard mount option can very
quickly cause the locations pointed to by backup roots to return no
data (metadata deallocated and trimmed). I wonder if this is similar
where Btrfs has no concept of delaying metadata deallocation for a
while so that the backup trees remain valid for a while (few minutes?)
Anyway if these backup roots can become stale, if they're ever needed
they're not going to be useful.

superblock: bytenr=65536, device=/dev/mapper/sdc
---------------------------------------------------------
csum_type        0 (crc32c)
csum_size        4
csum            0xe0c01b78 [match]
bytenr            65536
flags            0x1
            ( WRITTEN )
magic            _BHRfS_M [match]
fsid            ecd5e90e-6fb7-4b42-ab57-515a733c01f2
metadata_uuid        ecd5e90e-6fb7-4b42-ab57-515a733c01f2
label            third
generation        686
root            3355115520
sys_array_size        129
chunk_root_generation    685
root_level        1
chunk_root        4325376000
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        1000207335424
bytes_used        439356653568
sectorsize        4096
nodesize        32768
leafsize (deprecated)    32768
stripesize        4096
root_dir        6
num_devices        2
compat_flags        0x0
compat_ro_flags        0x3
            ( FREE_SPACE_TREE |
              FREE_SPACE_TREE_VALID )
incompat_flags        0x171
            ( MIXED_BACKREF |
              COMPRESS_ZSTD |
              BIG_METADATA |
              EXTENDED_IREF |
              SKINNY_METADATA )
cache_generation    18446744073709551615
uuid_tree_generation    686
dev_item.uuid        de7a23cd-ec25-47d4-bbdb-fcf9c4dc705a
dev_item.fsid        ecd5e90e-6fb7-4b42-ab57-515a733c01f2 [match]
dev_item.type        0
dev_item.total_bytes    500103667712
dev_item.bytes_used    442415185920
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        2
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
    item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 4325376000)
        length 33554432 owner 2 stripe_len 65536 type SYSTEM|RAID1
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 1
            stripe 0 devid 2 offset 1083179008
            dev_uuid de7a23cd-ec25-47d4-bbdb-fcf9c4dc705a
            stripe 1 devid 1 offset 1104150528
            dev_uuid 15e28877-dbc7-446d-9991-618504a758ca
backup_roots[4]:
    backup 0:
        backup_tree_root:    3355115520    gen: 686    level: 1
        backup_chunk_root:    4325376000    gen: 685    level: 1
        backup_extent_root:    3358523392    gen: 686    level: 2
        backup_fs_root:        3550511104    gen: 497    level: 0
        backup_dev_root:    3358752768    gen: 685    level: 1
        backup_csum_root:    3259400192    gen: 500    level: 2
        backup_total_bytes:    1000207335424
        backup_bytes_used:    439356653568
        backup_num_devices:    2

    backup 1:
        backup_tree_root:    3358752768    gen: 683    level: 1
        backup_chunk_root:    4325441536    gen: 677    level: 1
        backup_extent_root:    3359506432    gen: 683    level: 2
        backup_fs_root:        3550511104    gen: 497    level: 0
        backup_dev_root:    3358982144    gen: 677    level: 1
        backup_csum_root:    3259400192    gen: 500    level: 2
        backup_total_bytes:    1000207335424
        backup_bytes_used:    439356653568
        backup_num_devices:    2

    backup 2:
        backup_tree_root:    3355115520    gen: 684    level: 1
        backup_chunk_root:    4325441536    gen: 677    level: 1
        backup_extent_root:    3358523392    gen: 684    level: 2
        backup_fs_root:        3550511104    gen: 497    level: 0
        backup_dev_root:    3358982144    gen: 677    level: 1
        backup_csum_root:    3259400192    gen: 500    level: 2
        backup_total_bytes:    1000207335424
        backup_bytes_used:    439356653568
        backup_num_devices:    2

    backup 3:
        backup_tree_root:    3359834112    gen: 685    level: 1
        backup_chunk_root:    4325376000    gen: 685    level: 1
        backup_extent_root:    3361898496    gen: 685    level: 2
        backup_fs_root:        3550511104    gen: 497    level: 0
        backup_dev_root:    3358752768    gen: 685    level: 1
        backup_csum_root:    3259400192    gen: 500    level: 2
        backup_total_bytes:    1000207335424
        backup_bytes_used:    439356653568
        backup_num_devices:    2




-- 
Chris Murphy
