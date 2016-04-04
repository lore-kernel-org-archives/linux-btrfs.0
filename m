Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34731 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbcDDJmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 05:42:31 -0400
Received: by mail-lb0-f182.google.com with SMTP id vo2so152290103lbb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 02:42:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALJXSJrdkqau4xWax72xQGBcaONDxWBeDLOn4KD7vP8NKJikDw@mail.gmail.com>
References: <CALJXSJrdkqau4xWax72xQGBcaONDxWBeDLOn4KD7vP8NKJikDw@mail.gmail.com>
Date: Mon, 4 Apr 2016 11:42:29 +0200
Message-ID: <CAPmG0jaxZY1d365KGy=HL+e7WNyZ7w6jtT2VJod00KD=JBC=ng@mail.gmail.com>
Subject: Re: csum failed on innexistent inode
From: Henk Slager <eye1tm@gmail.com>
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 4, 2016 at 9:50 AM, Jérôme Poulin <jeromepoulin@gmail.com> wrote:
> Hi all,
>
> I have a BTRFS on disks running in RAID10 meta+data, one of the disk
> has been going bad and scrub was showing 18 uncorrectable errors
> (which is weird in RAID10). I tried using --repair-sector with hdparm
> even if it shouldn't be necessary since BTRFS would overwrite the
> sector. Repair sector fixed the sector in SMART but BTRFS was still
> showing 18 uncorr. errors.
>
> I finally decided to give up this opportunity to test the error
> correction property of BTRFS (this is a home system, backed up) and
> installed a brand new disk in the machine. After running btrfs
> replace, everything was fine, I decided to run btrfs scrub again and I
> still have the same 18 uncorrectable errors.

You might want this patch:
http://www.spinics.net/lists/linux-btrfs/msg53552.html

As workaround, you can reset the counters on new/healty device with:

btrfs device stats [-z] <path>|<device>

> Later on, since I had a new disk with more space, I decided to run a
> balance to free up the new space but the balance has stopped with csum
> errors too. Here are the output of multiple programs.
>
> How is it possible to get rid of the referenced csum errors if they do
> not exist? Also, the expected checksum looks suspiciously the same for
> multiple errors. Could it be bad RAM in that case? Can I convince
> BTRFS to update the csum?
>
> # btrfs inspect-internal logical-resolve -v 1809149952 /mnt/btrfs/
> ioctl ret=-1, error: No such file or directory
> # btrfs inspect-internal inode-resolve -v 296 /mnt/btrfs/
> ioctl ret=-1, error: No such file or directory
>
>
> dmesg after first bad sector:
> avr 01 18:29:52 p4.i.ticpu.net kernel: BTRFS info (device dm-43): read
> error corrected: ino 1 off 655368716288 (dev /dev/dm-42 sector
> 2939136)
> avr 01 18:29:52 p4.i.ticpu.net kernel: BTRFS info (device dm-43): read
> error corrected: ino 1 off 655368720384 (dev /dev/dm-42 sector
> 2939144)
> avr 01 18:29:52 p4.i.ticpu.net kernel: BTRFS info (device dm-43): read
> error corrected: ino 1 off 655368724480 (dev /dev/dm-42 sector
> 2939152)
> avr 01 18:29:52 p4.i.ticpu.net kernel: BTRFS info (device dm-43): read
> error corrected: ino 1 off 655368728576 (dev /dev/dm-42 sector
> 2939160)
>
> dmesg after balance:
> [1738474.444648] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809195008 csum 1515428513 expected csum 2566472073
> [1738474.444649] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809084416 csum 4147641019 expected csum 1755301217
> [1738474.444702] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809199104 csum 1927504681 expected csum 2566472073
> [1738474.444717] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809211392 csum 3086571080 expected csum 2566472073
> [1738474.444917] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809084416 csum 4147641019 expected csum 1755301217
> [1738474.444962] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809195008 csum 1515428513 expected csum 2566472073
> [1738474.444998] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809199104 csum 1927504681 expected csum 2566472073
> [1738474.445034] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809211392 csum 3086571080 expected csum 2566472073
> [1738474.473286] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809149952 csum 3254083717 expected csum 2566472073
> [1738474.473357] BTRFS warning (device dm-40): csum failed ino 296 off
> 1809162240 csum 3157020538 expected csum 2566472073
>
> btrfs check:
> ./btrfs check /dev/mapper/luksbtrfsdata2
> Checking filesystem on /dev/mapper/luksbtrfsdata2
> UUID: 805f6ad7-1188-448d-aee4-8ddeeb70c8a7
> checking extents
> bad metadata [1453741768704, 1453741785088) crossing stripe boundary
> bad metadata [1454487764992, 1454487781376) crossing stripe boundary
> bad metadata [1454828552192, 1454828568576) crossing stripe boundary
> bad metadata [1454879735808, 1454879752192) crossing stripe boundary
> bad metadata [1455087222784, 1455087239168) crossing stripe boundary
> bad metadata [1456269426688, 1456269443072) crossing stripe boundary
> bad metadata [1456273227776, 1456273244160) crossing stripe boundary
> bad metadata [1456404234240, 1456404250624) crossing stripe boundary
> bad metadata [1456418914304, 1456418930688) crossing stripe boundary

Those are false alerts; This patch handles that:
https://patchwork.kernel.org/patch/8706891/

> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 689292505473 bytes used err is 0
> total csum bytes: 660112536
> total tree bytes: 1764098048
> total fs tree bytes: 961921024
> total extent tree bytes: 79331328
> btree space waste bytes: 232774315
> file data blocks allocated: 4148513517568
>  referenced 972284129280
>
> btrfs scrub:
> I don't have the output handy but the dmesg output were pairs of
> logical blocks like balance and no errors were corrected.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
