Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:34028 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdGRAw7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 20:52:59 -0400
Received: by mail-wr0-f181.google.com with SMTP id 12so6381052wrb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jul 2017 17:52:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAK8kLn08QooOnG76opnaQFxSWjsbgBbKW2tLtfh=630NW1CXg@mail.gmail.com>
References: <CAAK8kLn08QooOnG76opnaQFxSWjsbgBbKW2tLtfh=630NW1CXg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Jul 2017 18:52:57 -0600
Message-ID: <CAJCQCtTv7g+9CFxi1dCrgUGxmetRWPE-8=KmmTy1s35PswQNNA@mail.gmail.com>
Subject: Re: BTRFS error on my raid1
To: "Tom, OE1TKT" <oe1tkt@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 17, 2017 at 5:12 PM, Tom, OE1TKT <oe1tkt@gmail.com> wrote:
> Hello,
>
> my raid1 (2 x HDD 4TB) started in RO mode,
> what procedure should I do to get my btrfs working again?
>
> # uname -a
> Linux black 4.11.9-1-ARCH #1 SMP PREEMPT Wed Jul 5 18:23:08 CEST 2017
> x86_64 GNU/Linux
> # btrfs --version
> btrfs-progs v4.11.1
> # btrfs f sh
> Label: 'ssd'  uuid: dc54bfb3-64ad-4e39-ac5a-e41d04d0d1e7
>     Total devices 1 FS bytes used 34.70GiB
>     devid    1 size 105.75GiB used 37.04GiB path /dev/sda1
>
> Label: 'raid1'  uuid: 1c7cbc22-9c22-4107-a99e-81eaca53f8aa
>     Total devices 2 FS bytes used 2.27TiB
>     devid    1 size 3.64TiB used 2.28TiB path /dev/sdb
>     devid    2 size 3.64TiB used 2.28TiB path /dev/sdc
>
> # btrfs fi df /home
> Data, RAID1: total=2.27TiB, used=2.26TiB
> System, RAID1: total=8.00MiB, used=384.00KiB
> Metadata, RAID1: total=6.00GiB, used=4.52GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

What happens if you just try to mount it again normally? And then -o
ro? And then -o ro,usebackuproot?

[   67.217591] BTRFS: error (device sdb) in __btrfs_free_extent:6942:
errno=-2 No such entry
[   67.217592] BTRFS info (device sdb): forced readonly
[   67.217594] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2961: errno=-2 No such entry
[   67.219019] BTRFS error (device sdb): pending csums is 153581588480

pending csums seems really high... there's not enough information in
the dmesg. Can you post the entire thing? Even better would be
something like 'sudo journalctl _TRANSPORT=kernel --since=-2d' to get
all the kernel messages for the past couple days.


-- 
Chris Murphy
