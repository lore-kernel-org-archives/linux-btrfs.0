Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35883 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbcFLXCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 19:02:17 -0400
Received: by mail-oi0-f48.google.com with SMTP id p204so184430592oih.3
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 16:02:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
References: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
Date: Sun, 12 Jun 2016 17:02:16 -0600
Message-ID: <CAJCQCtQrF3fJAFBiJTyMUUVk9zsNrUJpdq+xZd-Z04t4YaiYcw@mail.gmail.com>
Subject: Re: dd on wrong device, 1.9 GiB from the beginning has been
 overwritten, how to restore partition?
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Maximilian_B=C3=B6hm?= <winlux@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 12, 2016 at 3:22 PM, Maximilian Böhm <winlux@gmail.com> wrote:
> Hi there, I did something terribly wrong, all blame on me. I wanted to
> write to an USB stick but /dev/sdc wasn't the stick in this case but
> an attached HDD with GPT and an 8 TB btrfs partition…
>
> $ sudo dd bs=4M if=manjaro-kde-16.06.1-x86_64.iso of=/dev/sdc
> 483+1 Datensätze ein
> 483+1 Datensätze aus
> 2028060672 bytes (2,0 GB, 1,9 GiB) copied, 16,89 s, 120 MB/s
>
> So, shit.
>
> $ sudo btrfs check --repair /dev/sdc
> enabling repair mode
> No valid Btrfs found on /dev/sdc
> Couldn't open file system
>
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
>
>

OK but none of these can work anyway because the tools work based on
fixed offsets. By pointing the tool to /dev/sdc the wrong offset is
always being used, because originally the drive had a partition. By
default GPT disks offset the 1st partition 1MiB, or 2048 using 512
byte sectors assuming the drive uses 512 byte logical sectors (and
most still do).

What you should do is run gdisk /dev/sdc and it'll find the backup GPT
at the end of the drive, and offer to fix up the primary one. And now
you can point the tools to /dev/sdc1 (or whatever partition is for
Btrfs).

2GIB of Btrfs metadata is a lot of missing metadata though. So even
though btrfs-show-super will find the 3rd superblock, chances are it's
going to point to metadata somewhere in those first 2GiB that were
overwritten, but maybe not. It might be possible to get a -o ro mount
at least and start copying off some data.

If it's ro mountable, it might be possible to put /dev/sdc1 on an
overlay, and then fix the overlay rather than the original with
btrfsck - maybe it can fix up enough such that you'll just get piles
of read errors for the data that's missing rather than hitting some
brick wall and stopping.


-- 
Chris Murphy
