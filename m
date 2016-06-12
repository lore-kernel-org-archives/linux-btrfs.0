Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33318 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282AbcFLWt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 18:49:26 -0400
Received: by mail-vk0-f51.google.com with SMTP id d185so34257031vkg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 15:49:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
References: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 13 Jun 2016 00:49:24 +0200
Message-ID: <CAPmG0jZxM65Fn3WsUMEO-EJ8oVEEW7DT=S09q2fLv8cXkoqUGA@mail.gmail.com>
Subject: Re: dd on wrong device, 1.9 GiB from the beginning has been
 overwritten, how to restore partition?
To: =?UTF-8?Q?Maximilian_B=C3=B6hm?= <winlux@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 12, 2016 at 11:22 PM, Maximilian Böhm <winlux@gmail.com> wrote:
> Hi there, I did something terribly wrong, all blame on me. I wanted to
> write to an USB stick but /dev/sdc wasn't the stick in this case but
> an attached HDD with GPT and an 8 TB btrfs partition…

GPT has a secondary copy at the end of the device, so maybe gdisk can
reconstruct in first main one at the beginning of the disk, I don't
know all gdisk commands. But is you once created just 1 partition max
size for the whole disk with modern tools, your btrfs fs starts at
sector 2048, (with logical sectorsize 512).


> $ sudo dd bs=4M if=manjaro-kde-16.06.1-x86_64.iso of=/dev/sdc
> 483+1 Datensätze ein
> 483+1 Datensätze aus
> 2028060672 bytes (2,0 GB, 1,9 GiB) copied, 16,89 s, 120 MB/s

To confuse btrfs+tools as little as possible, I would first overwrite
/dev/sdc again from the start with the same amount of bytes byte then
from /dev/zero.
Then create / 'newly overlay' a the original partition offset 1M, till
the end. Alternatively:
$ losetup /dev/loopX -o 1M /dev/sdc
then your broken fs will be on /dev/sdc1 or /dev/loopX

Or overlay it with dm, snapshot, set the original ro and then work on
the rw flavor, so you keep the current broken HDD/fs as is and then do
the above.

> $ sudo btrfs check --repair /dev/sdc
> enabling repair mode
> No valid Btrfs found on /dev/sdc
> Couldn't open file system

Forget --repair I would say, hopefully btrfs restore can still find /
copy most of the data

> $ sudo btrfs-find-root /dev/sdc
> No valid Btrfs found on /dev/sdc
> ERROR: open ctree failed
>
> $ sudo btrfs-show-super /dev/sdc --all
> superblock: bytenr=65536, device=/dev/sdc
> ---------------------------------------------------------
> ERROR: bad magic on superblock on /dev/sdc at 65536
>
> superblock: bytenr=67108864, device=/dev/sdc
> ---------------------------------------------------------
> ERROR: bad magic on superblock on /dev/sdc at 67108864
>
> superblock: bytenr=274877906944, device=/dev/sdc
> ---------------------------------------------------------
> ERROR: bad magic on superblock on /dev/sdc at 274877906944

run
$ sudo btrfs-show-super /dev/sdc1 --all
or
$ sudo btrfs-show-super /dev/loopX --all



> System infos:
>
> $ uname -a
> Linux Mongo 4.6.2-1-MANJARO #1 SMP PREEMPT Wed Jun 8 11:00:08 UTC 2016
> x86_64 GNU/Linux
>
> $ btrfs --version
> btrfs-progs v4.5.3
>
> Don't think dmesg is necessary here.
>
>
> OK, the btrfs wiki says there is a second superblock at 64 MiB
> (overwritten too in my case) and a third at 256 GiB ("0x4000000000").
> But how to restore it? And how to restore the general btrfs header
> metadata? How to restore GPT without doing something terrible again?

See above, maybe you have lookup various sizes etc GPT etc first, but
I think your 3rd SB should be there.
