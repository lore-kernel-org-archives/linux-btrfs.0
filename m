Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34419 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbeELHvL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 May 2018 03:51:11 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: james harvey <jamespharvey20@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops, check/scrub pass
Date: Sat, 12 May 2018 09:51:04 +0200
Message-ID: <1835523.2oRAal5OEW@merkaba>
In-Reply-To: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey James.

james harvey - 12.05.18, 07:08:
> 100% reproducible, booting from disk, or even Arch installation ISO.
> Kernel 4.16.7.  btrfs-progs v4.16.
> 
> Reading one of two journalctl files causes a kernel oops.  Initially
> ran into it from "journalctl --list-boots", but cat'ing the file does
> it too.  I believe this shows there's compressed data that is invalid,
> but its btrfs checksum is invalid.  I've cat'ed every file on the
> disk, and luckily have the problems narrowed down to only these 2
> files in /var/log/journal.
> 
> This volume has always been mounted with lzo compression.
> 
> scrub has never found anything, and have ran it since the oops.
> 
> Found a user a few years ago who also ran into this, without
> resolution, at:
> https://www.spinics.net/lists/linux-btrfs/msg52218.html
> 
> 1. Cat'ing a (non-essential) file shouldn't be able to bring down the
> system.
> 
> 2. If this is infact invalid compressed data, there should be a way to
> check for that.  Btrfs check and scrub pass.

I think systemd-journald sets those files to nocow on BTRFS in order to 
reduce fragmentation: That means no checksums, no snapshots, no nothing. 
I just removed /var/log/journal and thus disabled journalling to disk. 
Its sufficient for me to have the recent state in /run/journal.

Can you confirm nocow being set via lsattr on those files?

Still they should be decompressible just fine.

> Hardware is fine.  Passes memtest86+ in SMP mode.  Works fine on all
> other files.
> 
> 
> 
> [  381.869940] BUG: unable to handle kernel paging request at
> 0000000000390e50 [  381.870881] BTRFS: decompress failed
[…]
-- 
Martin


