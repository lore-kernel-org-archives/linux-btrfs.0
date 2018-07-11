Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f180.google.com ([209.85.208.180]:46033 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388590AbeGKRPO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 13:15:14 -0400
Received: by mail-lj1-f180.google.com with SMTP id q5-v6so19936372ljh.12
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2018 10:09:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180710180915.onnxuak7vb7uywyn@merlins.org>
References: <20180710180915.onnxuak7vb7uywyn@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 11 Jul 2018 11:09:56 -0600
Message-ID: <CAJCQCtRQdg56Hxk=U2JMXbE35Jj_Q5Ock_gn43jWxci4Nbs5UA@mail.gmail.com>
Subject: Re: btrfs check lowmem, take 2
To: Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Su Yue <Damenly_Su@gmx.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 10, 2018 at 12:09 PM, Marc MERLIN <marc@merlins.org> wrote:
> Thanks to Su and Qu, I was able to get my filesystem to a point that
> it's mountable.
> I then deleted loads of snapshots and I'm down to 26.
>
> IT now looks like this:
> gargamel:~# btrfs fi show /mnt/mnt
> Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
>         Total devices 1 FS bytes used 12.30TiB
>         devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2
>
> gargamel:~# btrfs fi df /mnt/mnt
> Data, single: total=13.57TiB, used=12.19TiB
> System, DUP: total=32.00MiB, used=1.55MiB
> Metadata, DUP: total=124.50GiB, used=115.62GiB
> Metadata, single: total=216.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> Problems
> 1) btrfs check --repair _still_ takes all 32GB of RAM and crashes the
> server, despite my deleting lots of snapshots.
> Is it because I have too many files then?

I think originally needs most of metdata in memory.

I'm not understanding why btrfs check won't use swap like at least
xfs_repair and pretty sure e2fsck will as well.

Using 128G swap on nvme with original check is still gonna be faster
than lowmem mode.




-- 
Chris Murphy
