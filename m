Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f41.google.com ([209.85.128.41]:42416 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3LGPfd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Dec 2013 10:35:33 -0500
Received: by mail-qe0-f41.google.com with SMTP id gh4so1555910qeb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Dec 2013 07:35:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$eae06$5585191a$304325c1$fe3db1e1@cox.net>
References: <CADdntNuHYRAK_kcDJf1bnJeuTmc=CRx7TeyJPv4hsW9NPyd6mg@mail.gmail.com>
	<pan$4b17c$7a4e1e36$4569b4d4$d3dc2dcf@cox.net>
	<CADdntNt_5yvz0KC3StkJ0sOEw55oHWq4fV0qfOLaXymrYWOLUA@mail.gmail.com>
	<pan$eae06$5585191a$304325c1$fe3db1e1@cox.net>
Date: Sat, 7 Dec 2013 16:35:30 +0100
Message-ID: <CADdntNvokc0sUdfaMjUMhe7+pYoPYv6qwSZGZ691SHZc9tPihQ@mail.gmail.com>
Subject: Re: Can't remove empty directory after kernel panic, no errors in dmesg
From: Niklas Schnelle <niklas.schnelle@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok here is yet another update, I compiled the current git version
of btrfs progs on the Ubuntu Live System and ran that on my filesystem
first as btrfs check then with repair.
Here is the output after repair:
http://niklas.sceneproject.org/btrfs_out.txt

Somehow I still don't see btrfs errors when actually running with that
fillesystem,
even though that looks like a lot of errors to me. I hope
this information is useful. I guess I'll just try my luck until
my course paper is due and then it might be best to just get my
btrfs sent backups even though they are a few weeks old,
thankfully I'm pretty sure everything changed since then is
either updates, in git or in Dropbox.

Thanks for the information and help anyway.

On Sat, Dec 7, 2013 at 2:59 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Niklas Schnelle posted on Sat, 07 Dec 2013 12:37:05 +0000 as excerpted:
>
>> root 470 inode 60984 errors 200
>> root 470 inode 62463 errors 200
>
> Three quick things to note:
>
> 1) As another thread pointed out recently, that's not 200 errors, but an
> error type bitmask, with the 0x200 bit set.  Based on that other thread
> (I'm not a dev and haven't actually looked myself), there's comments/
> varnames in the code (unfortunately only, no non-dev admin-level
> documentation anywhere that I know of) saying what each bitflag
> represents.
>
> 2) I had meant to mention earlier but forgot:  As announced on this list
> IIRC shortly after the kernel 3.12 release, btrfs-progs is now versioned
> similar to the kernel and will follow a similar release schedule as long
> as the level of new code warrants (possibly skipping kernel versions here
> and there as the code ultimately stabilizes and churn slows down), with
> the first release following that version scheme being 3.12.
>
> Your reported version number is v0.20-rc1, no git commit snapshot
> indication, and IIRC that was released late last year, so it's about a
> year old now.  You may wish to try something a bit newer, to match your
> 3.13-release-candidate kernel version.  There have been a number of fixes
> since v0.20-rc1 (including btrfsck being made part of the main btrfs
> command now, as btrfs check) and it's just possible a current version may
> fix your issues.
>
> 3) You asked in what might have been a private mail as I didn't see it
> hit the list, what liveCD, etc, to use, since it's a rootfs btrfs that
> you're working with.  The list mail I'm replying to says you tried a live
> stick (doesn't say the version), so you've worked around that to some
> extent, but as a more general followup based on the multiple independent
> btrfs partitions scheme I use that I mentioned earlier in the thread...
>
> One of the best setups I've come up with over a decade's worth of
> experience here is, as I said, multiple independent partitions, with the
> first level backup actually on an identically sized partition on the same
> physical device.
>
> So I have a working rootfs and a rootbak, identically sized independent
> partitions, with snapshot copy of the working root taken at a point I'm
> comfortable that it's stable.  There's further copies on other (also
> bootable) media, on reiserfs in case the after all still under heavy
> development btrfs blows up both my working root and primary backup.
>
> That very nicely solves the whole rescue disk issue, since I effectively
> have my entire installed and configured system, *NOT* just a few rescue
> tools, as a snapshot taken when I did the backup, as ready to go now as
> it was when I did the backup, even if it's slightly out of date now and
> would need an update to bring it current.  That means all documentation,
> a fully configured X and kde install, media players so I can listen to
> music while I'm fixing the system, it's all there and ready to go, just
> as it was at the time I did the backup.
>
> (I actually keep multiple fstab layouts around too, maintained with a
> script so I can update one and run the script to update the others, with
> fstab itself actually being a symlink to the active one, making selecting
> an fstab layout as easy as updating a symlink from single-user-mode.)
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
