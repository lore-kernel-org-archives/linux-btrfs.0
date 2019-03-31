Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFD1C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 18:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E81B20870
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 18:36:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i3ffX15J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbfCaSg2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 14:36:28 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38620 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfCaSg2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 14:36:28 -0400
Received: by mail-io1-f66.google.com with SMTP id v4so5831175ioj.5
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2019 11:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=SEBcTmMn9LrnXPw5/3HXot3HoCetbxOjXIZCFfr+m5M=;
        b=i3ffX15JqLvTFH9XHHgD/GscjAvmriGuiMNpSy8faErLkHJXdwDELJqWKfF9Eof7zO
         foZj654vBX/ufSmzvcJRGnhhZzYkhVIKrxTKB+6eNF+wGQ3sLB+JTbFpgoLY3JrV1AR8
         AyTCnPFEs4OisTJV6rcwT/FY3tweISX24rkqLTAO2pcZxR2EYR2CdU8+9xqCokfKzl/F
         oMyNp9FUd3xhm9261wlACXxED84R0nR34mD3FGyh1sq+i21xrtc1ZD90LkOndFrV434k
         nV8Cz1iqDYj0l+MnJT0kIBcUEK8KF+OWE89uMm5KiEHX4L8qoDminYN6t4vWQ++7n9TT
         Y6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SEBcTmMn9LrnXPw5/3HXot3HoCetbxOjXIZCFfr+m5M=;
        b=ruB83nk44IoiUEdDyH3AETzjYjV1ghnS1JatmKPlMBTvWrat+zb/yVQYFaexlHVbZF
         nqSLg+nJhPPG8ahGxmv1J3gXgwNvX/lkwivFQW7xhppo77nMA3K/lxQhLPLlIvFXLUwg
         HqgfInxdATC6ma080y/BqGRwYshHZMUV2UtqUD5Ci3KxLdHKqtIyXKCmxUNtfm6tT6Dv
         d1fqLCpQp6YRMyCnJ+8hgyjObc3YlwLW0tF8xPM4NIymR/s2Z2QHvVsZKRXLF9D+HSYD
         W23RtKXW282kmfNr/gz+1h7DthKNAfVrXfuqkvk6hhYQgr10D/QuPnHYzMselRnkR5bM
         VDeA==
X-Gm-Message-State: APjAAAUN5Yq13rZxWPm68ns21fKpR5YxISR3dxyogG5TymCluplkfdhC
        MPWaXQsaCRaCgxxA3O37lGLUtdUvgxbayu65h5+18hJF
X-Google-Smtp-Source: APXvYqxIHxL09QQ0G1zwHoF4kKFtxyQmY3vSjY64dxalh3sztAlkw43GfigF1o6NRsWOVUT4BSmkay+kkIoT4MLtXuA=
X-Received: by 2002:a5d:9a8d:: with SMTP id c13mr21488211iom.195.1554057387845;
 Sun, 31 Mar 2019 11:36:27 -0700 (PDT)
MIME-Version: 1.0
From:   Aleksandr Levchuk <alevchuk@gmail.com>
Date:   Sun, 31 Mar 2019 11:36:17 -0700
Message-ID: <CAK9PHfbVvxEA-j=3m7-rPaPGH1+514-o8Wo9+jz5B4QV9srBVg@mail.gmail.com>
Subject: How to reduce log spew when btrfs drive fails?
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have btrfs raid-1. When one of the drives failed, I ran out of disk space.

The disk was used by:
* /var/log/messages
* /var/log/kern.log
* /var/log/syslog

All of these contained errors that look like this:
```
Mar 31 15:15:55 b2 kernel: [ 3816.592556] BTRFS warning (device
mmcblk0p4): i/o error at logical 217488986112 on dev /dev/sda,
physical 182894366720, root 5, inode 2943, offset 18087936, length
4096, links 1 (path: bitcoin/bitcoin-data/blocks/rev00740.dat)
Mar 31 15:15:55 b2 kernel: [ 3816.604975] scrub_handle_errored_block:
7743 callbacks suppressed
Mar 31 15:15:55 b2 kernel: [ 3816.604996] BTRFS error (device
mmcblk0p4): unable to fixup (regular) error at logical 217488797696 on
dev /dev/sda
```

also
```
Mar 31 15:20:45 b2 kernel: [ 4107.205771]
btrfs_dev_stat_print_on_error: 28954 callbacks suppressed
Mar 31 15:20:45 b2 kernel: [ 4107.205792] BTRFS error (device
mmcblk0p4): bdev /dev/sda errs: wr 1087192, rd 543622, flush 2,
corrupt 0, gen 0
Mar 31 15:20:45 b2 kernel: [ 4107.206125] BTRFS error (device
mmcblk0p4): bdev /dev/sda errs: wr 1087193, rd 543622, flush 2,
corrupt 0, gen 0
Mar 31 15:20:45 b2 kernel: [ 4107.206155] BTRFS error (device
mmcblk0p4): bdev /dev/sda errs: wr 1087194, rd 543622, flush 2,
corrupt 0, gen 0
Mar 31 15:20:45 b2 kernel: [ 4107.206165] scrub_handle_errored_block:
9645 callbacks suppressed
```

I have Linux l2 4.19.25+ #1205 Mon Feb 25 17:52:12 GMT 2019 armv6l GNU/Linux
btrfs-progs v4.7.3

$  btrfs fi show
Label: 'bitcoind'  uuid: 8848dbdc-bf70-4de0-b06f-312ce71b396a
        Total devices 2 FS bytes used 203.44GiB
        devid    1 size 225.00GiB used 206.03GiB path /dev/sda
        devid    2 size 225.00GiB used 206.03GiB path /dev/mmcblk0p4

$ btrfs fi df /mnt/btrfs_bitcoind/
Data, RAID1: total=204.00GiB, used=202.88GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=2.00GiB, used=581.30MiB
GlobalReserve, single: total=421.27MiB, used=0.00B

Alex
