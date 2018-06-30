Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:45371 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbeF3AEw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 20:04:52 -0400
Received: by mail-ot0-f179.google.com with SMTP id k3-v6so11681767otl.12
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 17:04:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180629171044.yudgzzwpgpetim5q@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org> <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org> <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org> <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org> <6a86d5d5-1d67-f34b-f809-b4e534485f3e@gmx.com>
 <20180629072831.qocyipdvmcm6cbo7@merlins.org> <20180629171044.yudgzzwpgpetim5q@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 29 Jun 2018 18:04:51 -0600
Message-ID: <CAJCQCtQ1YuEpG0CXUVir5ZbADHxyB-NPDd7u8sFEtzJPmMOeMg@mail.gmail.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got about 1/2 the snapshots and less than 1/10th the data...but
my btrfs check times are much shorter than either: 15 minutes and 65
minutes (lowmem).


[chris@f28s ~]$ sudo btrfs fi us /mnt/first
Overall:
    Device size:        1024.00GiB
    Device allocated:         774.12GiB
    Device unallocated:         249.87GiB
    Device missing:             0.00B
    Used:             760.48GiB
    Free (estimated):         256.95GiB    (min: 132.01GiB)
    Data ratio:                  1.00
    Metadata ratio:              2.00
    Global reserve:         512.00MiB    (used: 0.00B)

Data,single: Size:761.00GiB, Used:753.93GiB
   /dev/mapper/first     761.00GiB

Metadata,DUP: Size:6.50GiB, Used:3.28GiB
   /dev/mapper/first      13.00GiB

System,DUP: Size:64.00MiB, Used:112.00KiB
   /dev/mapper/first     128.00MiB

Unallocated:
   /dev/mapper/first     249.87GiB


146 subvolumes
137 snapshots

total csum bytes: 790549924
total tree bytes: 3519250432
total fs tree bytes: 2546073600
total extent tree bytes: 131350528


Original mode check takes ~15 minutes
Lowmem mode takes ~65 minutes

RAM: 4G
CPU: Intel(R) Pentium(R) CPU  N3700  @ 1.60GHz



Chris Murphy
