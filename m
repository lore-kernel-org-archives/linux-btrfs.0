Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36399 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbcBFXcr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Feb 2016 18:32:47 -0500
Received: by mail-io0-f170.google.com with SMTP id g73so163825452ioe.3
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Feb 2016 15:32:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B66704.5070505@gmail.com>
References: <56B66704.5070505@gmail.com>
Date: Sat, 6 Feb 2016 16:32:46 -0700
Message-ID: <CAJCQCtSOv8rhDi69NyR6J4cs91bc9ahh7382+kHz1knAe5BRdg@mail.gmail.com>
Subject: Re: Unrecoverable error on raid10
From: Chris Murphy <lists@colorremedies.com>
To: Tom Arild Naess <tanaess@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 6, 2016 at 2:35 PM, Tom Arild Naess <tanaess@gmail.com> wrote:
> Hello,
>
> I have quite recently converted my file server to btrfs, and I am in the
> progress of setting up a new backup server with btrfs to be able to utilize
> btrfs send/receive.
>
> FIle server:
>>
>> uname -a
>
> Linux main 3.19.0-49-generic #55~14.04.1-Ubuntu SMP Fri Jan 22 11:24:31 UTC
> 2016 x86_64 x86_64 x86_64 GNU/Linux
>
>> btrfs fi show /store
>
> Label: none  uuid: 2d84ca51-ec42-4fe3-888a-777cad6e1921
>     Total devices 4 FS bytes used 4.35TiB
>     devid    1 size 3.64TiB used 2.18TiB path /dev/sdc
>     devid    2 size 3.64TiB used 2.18TiB path /dev/sdd
>     devid    3 size 3.64TiB used 2.18TiB path /dev/sdb
>     devid    4 size 3.64TiB used 2.18TiB path /dev/sda
>
> btrfs-progs v4.1 (custom compiled)
>
>> btrfs fi df /store
>
> Data, RAID10: total=4.35TiB, used=4.35TiB
> System, RAID10: total=64.00MiB, used=480.00KiB
> Metadata, RAID10: total=6.00GiB, used=4.59GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> Backup server:
>>
>> uname -a
>
> Linux backup 4.2.5-1-ARCH #1 SMP PREEMPT Tue Oct 27 08:13:28 CET 2015 x86_64
> GNU/Linux

It's probably unrelated the problem, but I would given the many bug
fixes (including in send/receive) since kernel 3.19, and progs 4.1,
that I'd get both systems using the same kernel and progs version. I
suspect most of upstream's testing before release for send/receive is
with matching kernel and progs versions. My understanding is most of
the send code is in the kernel, and most of the receive code is in
progs (of course, receive also implies writing to a Btrfs volume as
well which would be kernel code too). I really wouldn't intentionally
mix and match versions like this, unless you're trying to find bugs as
a result of mismatching versions.



> This an except from the logs while scrubbing:
>
> Feb 06 06:21:20 backup kernel: BTRFS: checksum error at logical
> 3531011186688 on dev /dev/sdd, sector 3446072048, root 3811, inode 127923,
> offset 6936002560, length 4096, links 1 (path: xxxxxxxx)
> Feb 06 06:21:20 backup kernel: BTRFS: checksum error at logical
> 3531011186688 on dev /dev/sda, sector 3446072048, root 3811, inode 127923,
> offset 6936002560, length 4096, links 1 (path: xxxxxxxx)
> Feb 06 06:21:20 backup kernel: BTRFS: unable to fixup (regular) error at
> logical 3531011186688 on dev /dev/sda
> Feb 06 06:21:20 backup kernel: BTRFS: bdev /dev/sdd errs: wr 0, rd 0, flush
> 0, corrupt 1, gen 0
> Feb 06 06:21:20 backup kernel: BTRFS: unable to fixup (regular) error at
> logical 3531011186688 on dev /dev/sdd
> Feb 06 06:21:20 backup kernel: BTRFS: bdev /dev/sda errs: wr 0, rd 0, flush
> 0, corrupt 1, gen 0
> Feb 06 06:21:20 backup kernel: BTRFS: unable to fixup (regular) error at
> logical 3531011186688 on dev /dev/sda
> Feb 06 06:21:20 backup kernel: BTRFS: unable to fixup (regular) error at
> logical 3531011186688 on dev /dev/sdd
>
> What's strange is that the failed file have a checksum error in the exact
> same spot on both the mirrored copies, which means the file is
> unrecoverable.

Note that this is a logical address. The chunk tree will translate
that into separate physical sectors on the actual drives. This kind of
corruption suggests that it's not media, or even storage stack related
like a torn write or anything like that. I'm not sure how it can
happen, someone else who knows the sequence of data checksumming, data
allocation being split into two paths for writes, and metadata writes,
would have to speak up.

Also, the file is still recoverable most likely. You can use btrfs
restore to extract it from the unmounted file system without
complaining about checksum mismatches. It's just that the normal read
path won't hand over data it thinks is corrupt.

>This is not what I expect from a raid10!

Technically what you don't expect from raid10 is any notification that
the file may be corrupt at all. It'd be interesting to extract the
file with restore, and then compare hashes to a known good copy.


-- 
Chris Murphy
