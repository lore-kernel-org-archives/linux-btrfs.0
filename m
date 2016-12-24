Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33310 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755439AbcLXRYy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Dec 2016 12:24:54 -0500
Received: by mail-it0-f65.google.com with SMTP id c20so27370654itb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Dec 2016 09:24:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$32d3$c1252fb4$635d3287$d238a362@cox.net>
References: <CAOE4rSz5zeQYcGU3saZOk9HHb53NOwVF_vZV6m_UgQLftr9efQ@mail.gmail.com>
 <pan$32d3$c1252fb4$635d3287$d238a362@cox.net>
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Sat, 24 Dec 2016 19:24:53 +0200
Message-ID: <CAOE4rSyjCxWH=r78m5_nnaLqxd4YtP2kvHZrdHtCT9vjPKyX4g@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2041 repair_io_failure (v4.8.11)
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-12-24 11:37 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
> Dāvis Mosāns posted on Sat, 24 Dec 2016 04:22:24 +0200 as excerpted:
>
>> On two disk RAID1 btrfs partition one disk went offline, other was still
>> writing, then kernel paniced.
>
> [snip btrfs fi usage as not needed for this reply]
>
>> Now kernel panics every time after some time when accessing that
>> partition.
>
>
> Have you done a scrub on the filesystem since the event that offlined one
> of the two component devices?  If not, please do so ASAP.  Expect some
> repairs.
>

Running scrub also causes kernel panic, but it does fix some things.
I'll send that kernel log in separate email.

> As for the continued panics, I'm not a dev (just a list regular and btrfs
> raid1 user affected by this myself) so can't read enough of that bug-dump
> to know if this is the bug or not, but do you use btrfs compression,
> either via the compress mount option or via later compression using
> defrag with the appropriate commandline option?
>

It definitely is a bug, it's just unhandled case, it shouldn't cause
kernel panic but fix if it can or if can't then log it and continue.
And yeah, compression is enabled, mount option is
rw,noatime,autodefrag,compress=lzo,subvol=root

> The problem is that sometimes the affected filesystems are used by boot
> services, so I have to boot to systemd emergency or rescue mode (I forgot
> which, whichever one does the mounts but doesn't start normal services)
> and do the scrub from there, because if I try to boot normally, the
> starting services read enough affected files from the filesystem to
> trigger the panic before I get a chance to do the scrub.
>

Yeah that was happening since it's my / root partition and it paniced
before it even finished booting.
Now when I mounted it from other system it caused kernel panic even
there on 4.8.13

Thanks for detailed reply!
