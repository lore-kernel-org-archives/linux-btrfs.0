Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43139 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891AbcFLWPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 18:15:22 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Maximilian =?ISO-8859-1?Q?B=F6hm?= <winlux@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: dd on wrong device, 1.9 GiB from the beginning has been overwritten, how to restore partition?
Date: Mon, 13 Jun 2016 00:15:19 +0200
Message-ID: <1993269.StbmRRduWI@merkaba>
In-Reply-To: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
References: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Maximilian,

On Sonntag, 12. Juni 2016 23:22:11 CEST Maximilian Böhm wrote:
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
> Would be glad for any help!

But it says bad magic on that one as well.

Well, no idea if there is any chance to fix BTRFS in this situation.

Does btrfs restore do anything useful to copy of what if can find from this 
device? It does not work in place, so you need an additional space to let it 
restore to.

If BTRFS cannot be salvaged… you can still have a go with photorec, but it 
will not recover filenames and directory structure, just the data of any file 
of a file in a known format that it finds in one piece.

I suspect you have no backup.

So *good* luck.


I do think tough that dd should just bail out or warn for a BTRFS filesystem 
that is still mounted, or wasn´t it mounted at that time?

I also think it would be good to add an existing filesystem check just like in 
mkfs.btrfs, mkfs.xfs and so on. I´d like that, but that would be a suggestions 
for the coreutils people.

Yes, Unix is for people who know what they are doing… unless they don´t. And 
in the end even one of the most experienced admin could make such a mistake.

Goodnight,
-- 
Martin
