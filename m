Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35359 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbcAAXXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 18:23:13 -0500
Received: by mail-lf0-f45.google.com with SMTP id c192so75545284lfe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 15:23:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2876879.yKrnxB0p8M@orione>
References: <2876879.yKrnxB0p8M@orione>
Date: Sat, 2 Jan 2016 00:23:12 +0100
Message-ID: <CAPmG0jYHf90fuw1kds1aMhUbopmZX-wOLqDkR36mfb_hSm6szw@mail.gmail.com>
Subject: Re: Btrfs send / receive freeze system?
From: Henk Slager <eye1tm@gmail.com>
To: =?UTF-8?B?ZnVnYXp6acKu?= <fugazzi99@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 1, 2016 at 4:51 PM, fugazzi® <fugazzi99@gmail.com> wrote:
> Hi everyone.
> It's a few weeks that I converted my root partition into btrfs with three sub-
> volumes named boot,root,home. I'm booting with /boot on subvol.
>
> I'm using btrfs send and receive to make backup of the three snapshotted
> subvolumes on a second btrfs formatted drive with three commands like this:
>
> btrfs send /btrfs-root/snap-root/ | gzip > $BKFOLDER/root.dump.gz
>
> Sometimes, let say once a week, the system completely freeze (mouse keyboard)
> during the send, only solution was the reset button. The freeze happened on
> different place every time. Last time happened at 80% of the home send for
> example.
>
> The freeze also happened during a send/receive from an external e-sata drive
> (to copy some mp3 using send instead of rsync) to the same internal drive
> where the backup are also made.
>
> The system always run and was stable with XFS/xfsdump.
>
> Kernel is 4.3.3, btrfs progs are 4.3.1, system is Arch Linux 64 bit, Ram 8Gb
> Mainboard Asus striker extreme Nvidia 680i, 8 years old.
>
> After the crash nothing is shown in the systemd log, it simply freeze.

You could try this (maybe you have already) and see if and where the
problem is in btrfs:
https://en.m.wikipedia.org/wiki/Magic_SysRq_key

Instead of pipe to gzip you could do:
| btrfs receive -vv <some btrfs mount>
and trace back at which file the freeze happens. Maybe that tells something
about the source filesystem.
