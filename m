Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:34087 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1950479AbdD3Vf3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 17:35:29 -0400
Received: by mail-yw0-f177.google.com with SMTP id k11so49971893ywb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Apr 2017 14:35:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D52BBC8E.48696%zaller@iteris.com>
References: <D52BBC8E.48696%zaller@iteris.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 30 Apr 2017 15:35:27 -0600
Message-ID: <CAJCQCtTi+uOSrTvPMp+C22UdCwCNwtQWaZH4Lbr3vd_EBY_t4w@mail.gmail.com>
Subject: Re: How to fix these btrfs errors
To: Zach Aller <ZAller@iteris.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 30, 2017 at 3:08 PM, Zach Aller <ZAller@iteris.com> wrote:

> uname -a
> Linux server 4.11.0-041100rc8-generic #201704232131 SMP Mon Apr 24
> 01:32:55 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>
> ./btrfs --version
> btrfs-progs v4.10
>
> ./btrfs fi show
> Label: none  uuid: bdd89c26-038d-49fd-b895-52b8deb989cc
>         Total devices 1 FS bytes used 17.04TiB
>         devid    1 size 21.83TiB used 17.28TiB path /dev/sda


How old is the file system? Is this a recent problem with just
4.11rc8? Is most of the 17TB written with a particular kernel version,
which?


>
> Here is a dmesg snippet
>
>
> [    3.633295] BTRFS: device fsid bdd89c26-038d-49fd-b895-52b8deb989cc
> devid 1 transid 72387 /dev/sda
> [   12.907658] BTRFS info (device sda): disk space caching is enabled
> [   12.907659] BTRFS info (device sda): has skinny extents
> [   13.129140] BTRFS info (device sda): bdev /dev/sda errs: wr 0, rd 0,
> flush 0, corrupt 217, gen 19
> [20956.415076] BTRFS info (device sda): The free space cache file
> (9804365955072) is invalid. skip it
> [36292.358558] BTRFS warning (device sda): checksum error at logical
> 5614914584576 on dev /dev/sda, sector 10979229344: metadata leaf (level 0)
> in tree 7
> [36292.358563] BTRFS warning (device sda): checksum error at logical
> 5614914584576 on dev /dev/sda, sector 10979229344: metadata leaf (level 0)
> in tree 7
> [36292.358569] BTRFS error (device sda): bdev /dev/sda errs: wr 0, rd 0,
> flush 0, corrupt 218, gen 19
> [36292.364717] BTRFS error (device sda): unable to fixup (regular) error
> at logical 5614914584576 on dev /dev/sda


Both copies of metadata are failing checksum, so it can't be fixed. It
suggests there's a hardware problem (memory or storage), or maybe a
new bug.

Have there been any crashes while writing to the file system?
What is the storage stack configuration? 22TB for a single block
device means it's built up from something else.

I'd dig around for any non-btrfs storage stack related errors in the
meantime, maybe a dev will have some idea what's going on from the
call traces, I'm not sure what they mean.

-- 
Chris Murphy
