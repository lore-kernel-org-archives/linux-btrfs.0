Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36397 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbcJBT35 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Oct 2016 15:29:57 -0400
Received: by mail-oi0-f68.google.com with SMTP id h186so6144876oia.3
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 12:29:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161002181754.wxved3j66dzrvfoc@tiamat>
References: <20161002181754.wxved3j66dzrvfoc@tiamat>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 2 Oct 2016 13:29:56 -0600
Message-ID: <CAJCQCtTr3tG_8YSB_8gfBkpy558HKC+cz394B0wH2Je3v9kZmQ@mail.gmail.com>
Subject: Re: Unable to open ctree
To: Leonidas Spyropoulos <artafinde@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 2, 2016 at 12:17 PM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> Hi all,
>
> I'm a everyday user of btrfs. The system is a laptop with UEFI partition
> and the following partition scheme:
> # blkid
> /dev/sda1: UUID="." TYPE="vfat" PARTUUID="."
> /dev/sda2: UUID="." TYPE="swap" PARTUUID="."
> /dev/sda3: LABEL="root" UUID="." UUID_SUB="." TYPE="btrfs" PARTUUID="."
> /dev/sda4: LABEL="home" UUID="." UUID_SUB="." TYPE="btrfs" PARTUUID="."
>
> The partitions are surely not out of space:
> # btrfs fi show
> Label: 'root'  uuid: c7a773e0-e2be-4482-acdc-dbfa4c13c98c
>         Total devices 1 FS bytes used 9.98GiB
>                 devid    1 size 74.52GiB used 13.03GiB path /dev/sda3
>
> Label: 'home'  uuid: 63f5219f-399a-4cce-be86-a8c7400853bd
>                 Total devices 1 FS bytes used 17.65GiB
>                 devid    1 size 188.87GiB used 25.03GiB path /dev/sda4
>
> When the "root" partition is to be mounted during boot up it fails and I
> am dropped on an emergency shell. The dmesg output is:
>
> [  716.434137] BTRFS info (device sda3): disk space caching is enabled
> [  716.434147] BTRFS info (device sda3): has skinny extents
> [  716.436538] BTRFS info (device sda3): bdev /dev/sda3 errs: wr 0, rd
> 0, flush 0, corrupt 32, gen 0
> [  716.439182] BTRFS warning (device sda3): sda3 checksum verify failed
> on 11185160192 wanted 2670F0AB found FDB2F5BD level 0
> [  716.439195] BTRFS error (device sda3): failed to read block groups:
> -5
> [  716.481402] BTRFS: open_ctree failed
>
> The btrfs check /dev/sdc3 output is https://ptpb.pw/nc1d
>
> dmesg output: https://ptpb.pw/G0Wv
>
> The kernel I was running is right before this failure was 4.7.5 (with ck
> patchset custom compiled) and there was not any kernel panics - just a
> restart. Currently runnign through latest Archlinux liveCD
>
> # uname -a
> Linux archiso 4.7.5-1-ARCH #1 SMP PREEMPT Sat Sep 24 13:04:22 CEST 2016
> x86_64 GNU/Linux
>
> # btrfs --version
> btrfs-progs v4.7.3
>
> As this is the root partition I am not able to access it without a
> liveCD. Can I perform any kind of steps to recaclulate checksums?

Well short of a bug, the problem aren't the checksums. The problem is
the metadata is wrong, so if you recalculate checksums you're likely
end up with an even more corrupted file system because it'll start out
trusting bad metadata.

If you're prepared to lose this filesystem, use --repair and see if it
can fix the metadata problems despite csum failures. If it were me,
I'd take a btrfs-image before --repair. In theory, if it makes things
worse you can restore the image, or donate the image to making the
btrfsck better.

If --repair doesn't work, try -b --repair.

If that doesn't work then I'd probably use --init-extent-tree which,
while it's a heavy hammer, at least still isn't going to pretend bad
metadata is good which is what --init-csum-tree will end up doing.

But before all of that I'm curious what you get for:

btrfs-debug-tree -b 11185160192 /dev/sda3
btrfs-find-root /dev/sda3





-- 
Chris Murphy
