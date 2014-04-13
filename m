Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33110 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaDMWnD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 18:43:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WZT74-0002WT-Mb
	for linux-btrfs@vger.kernel.org; Mon, 14 Apr 2014 00:42:58 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 00:42:58 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 00:42:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs RAID1 corrupted after crash
Date: Sun, 13 Apr 2014 22:42:48 +0000 (UTC)
Message-ID: <pan$b81be$f24a3d23$40041e1f$3538cdeb@cox.net>
References: <CAA7TVBzRubwy-xUOGFGAJCi+mVvBBwwpqXHs9RRKxjpsrAd_=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maximilian Bräutigam posted on Sun, 13 Apr 2014 22:18:21 +0200 as
excerpted:

> unfortunately, I am very very deperate and I highly appreciate any help.
> One week ago, I move my entire system to btrfs to setup a RAID1. I
> created the RAID between device /dev/sdb and /dev/sdc with no partition
> table on normal HDDs. Everything was working smoothly until my computer
> crashed and at reboot I was not able to mount the device (my home dir)
> again and got the following messages:

You did your research before switching to a new filesystem and know that 
(as the btrfs kernel config option implies, and as the mkfs.btrfs command 
said at least last I used it, tho that was the v3.12 version) btrfs isn't 
entirely stable yet, and that (even more than with fully stable 
filesystems, where the general principle still applies) you should keep 
tested-to-be-usable backups when running it, or by action if not words, 
you're demonstrating that you really don't care about the data you place 
on it and don't mind if it gets trashed, right?

Good.  Then you either have a backup and can simply mkfs from your rescue 
method and restore from that backup, or you've demonstrated by your 
actions that the data wasn't of any major value to you anyway. No big 
deal either way! =:^)

In case you didn't, well, you still have a reasonably good chance at 
recovery =:^), but regardless of whether it's recovered or not, do chalk 
this up to a learning experience and do your research and have those 
backups ready and tested next time, OK?

[snip dmesg output from first attempt to mount]

> So I cleared the cache with trying the mount option clear_cache

Good.  First thing to try. =:^)

> but it stayed problematic and I was not able to mount it:
> 
> [  368.159594] BTRFS: error (device sdc) in __btrfs_free_extent:5755:
> errno=-5 IO failure
> [  368.159602] BTRFS: error (device sdc) in
> btrfs_run_delayed_refs:2713: errno=-5 IO failure
> [  368.165584] BTRFS warning (device sdc): Skipping commit of aborted
> transaction.
> [  368.165589] BTRFS: error (device sdc) in cleanup_transaction:1545:
> errno=-5 IO failure
> [  368.165787] BTRFS: error (device sdc) in
> open_ctree:2839: errno=-5 IO failure (Failed to recover log tree)
> [  368.227161] BTRFS: open_ctree failed

OK, there's several things to try based on that output...

> Now, if I tried to mount it manually with degraded option enabled:
> 
> # mount -t btrfs -o degraded /dev/sdb /mnt/sonst/
> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try dmesg | tail
>        or so.

FWIW, the degraded option could be used if you didn't have both devices 
available, but the above dmesg got beyond that, so degraded isn't likely 
to help here.


> Now I run btrfsck with repair option enabled but still I cannot mount
> it.

That was a mistake, as you'd have known if you had read this list before 
you tried your btrfs test.  btrfsck --repair can fix some problems, but 
the code is rather new and not well tested and it can also make some 
problems it doesn't know about worse, so the recommendation is to try it 
last, after all other attempts to either fix the problem or simply 
recover the data have failed and the next step would be a mkfs, so you're 
not losing anything by trying it anyway.  Either that, or run it in 
repair mode (without --repair it's OK since it's read-only and thus can't 
do further damage) only after being told to do so by a dev who can read 
the output from the read-only run and other diagnostics and is thus 
relatively confident it will fix the problems without doing further 
damage.

> Here you can find the dmesg and btrfsck outputs:
> dmesg: http://pastebin.com/zsaKQ0h1
> btrfsck: http://pastebin.com/xva6uJwT
> 
> Please, help me! ;( Are there other options to investigate my RAID or to
> even temporarily mount it to get some data? What went wrong here? What
> can I do? Why is a simple crash making my RAID unusable? Can I use other
> tools for a recovery?

> Archlinux, linux-3.14-5, btrfs-progs-3.14-1

Good.  You're using current kernel and tools. =:^)

As hinted above, there are indeed additional tools to try, and there's a 
fair chance you can at least recover some/most of the data.  =:^)  Tho 
you didn't do yourself any favors running btrfsck --repair before trying 
them. =:^(

Please read the wiki and manpages before doing anything else so as to 
increase the chances of recovery without further damage, but there's the 
recovery mount option (which often works best with ro), and tools to 
bypass the log tree and to recover from previous tree roots, among other 
things.

wiki start page (suitable for memory or bookmarking):

https://btrfs.wiki.kernel.org

Here's the wiki's btrfsck page, which has a nice list of other things to 
try before you use it with --repair (and a link to the page of a list 
regular with further detail, too), but they will hopefully work afterward 
as well.  Given the log-tree error in your dmesg, the btrfs-zero-log tool 
might be useful.  But I'd definitely try mount -o ro,recovery first, and 
if that works, get everything to backup before trying anything else.

https://btrfs.wiki.kernel.org/index.php/Btrfsck

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

