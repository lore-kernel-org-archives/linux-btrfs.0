Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35734 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbcC3OLz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 10:11:55 -0400
Received: by mail-vk0-f44.google.com with SMTP id e6so62451206vkh.2
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2016 07:11:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$440f4$30656b38$7703d942$803f5cf7@cox.net>
References: <CAHaDNyXRW4FQC+5P2_8apdFan2wtsHnPyzuK5ZPq8dLXW-S9_g@mail.gmail.com>
 <pan$440f4$30656b38$7703d942$803f5cf7@cox.net>
From: "Warren, Daniel" <daniel.warren@mcmcllc.com>
Date: Wed, 30 Mar 2016 10:11:13 -0400
Message-ID: <CAHaDNyVkL6ALehiSPdLVNZ7eJhaG4yuwaKHpCtnXymbKoztkTg@mail.gmail.com>
Subject: Re: attempt to mount after crash during rebalance hard crashes server
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I had about 3.5MB if xterm buffer, including my test to see if
I would get a panic with the old kernel i had left in grub - I grabbed
the wrong panic.

running 4.4.6 ( which deb packages as 4.4.0 for some reason - I was
confused) I am able to capture this on a mount attempt before my ssh
connection fails:

Mar 30 09:51:38 ds4-ls0 kernel: [67178.590745] BTRFS info (device
dm-45): disk space caching is enabled
Mar 30 09:51:38 ds4-ls0 systemd[1]: systemd-udevd.service: Got
notification message from PID 338 (WATCHDOG=1)
Mar 30 09:51:38 ds4-ls0 systemd-udevd[338]: seq 3514 queued, 'add' 'bdi'
Mar 30 09:51:38 ds4-ls0 systemd-udevd[338]: Validate module index
Mar 30 09:51:38 ds4-ls0 systemd-udevd[338]: Check if link
configuration needs reloading.
Mar 30 09:51:38 ds4-ls0 systemd-udevd[338]: seq 3514 forked new worker [7411]
Mar 30 09:51:38 ds4-ls0 systemd-udevd[7411]: seq 3514 running
Mar 30 09:51:38 ds4-ls0 systemd-udevd[7411]: passed device to netlink
monitor 0x55c10d5c79b0
Mar 30 09:51:38 ds4-ls0 systemd-udevd[7411]: seq 3514 processed
Mar 30 09:51:38 ds4-ls0 systemd-udevd[338]: cleanup idle workers
Mar 30 09:51:38 ds4-ls0 systemd-udevd[7411]: Unload module index
Mar 30 09:51:38 ds4-ls0 systemd-udevd[7411]: Unloaded link
configuration context.
Mar 30 09:51:38 ds4-ls0 systemd-udevd[338]: worker [7411] exited
Mar 30 09:51:38 ds4-ls0 kernel: [67178.841517] BTRFS info (device
dm-45): bdev /dev/dm-31 errs: wr 13870290, rd 9, flush 2798850,
corrupt 0, gen 0
Mar 30 09:52:09 ds4-ls0 kernel: [67207.430391] BUG: unable to handle
kernel NULL pointer dereference at 00000000000001f0
Mar 30 09:52:09 ds4-ls0 kernel: [67207.477511] IP:
[<ffffffffa021ce4e>] can_overcommit+0x1e/0xf0 [btrfs]
Mar 30 09:52:09 ds4-ls0 kernel: [67207.516215] PGD 0


I ran check last night - the output is about 23MB - don't know if that
is useful, or where to look.

I only posted at the recommendation of someone in IRC, in hopes to be
helpful, as a kernel panic seems an extreme result of a corrupted FS.

This machine is an off site copy of a file archive, I need to either
fix or recreate it to maintain redundancy, but the up-time
requirements are basically 0.

The old kernel is the result of this machine being built when it was
and then basically left as a black box.

If poking at this is not of use to anybody I'll just run check
--repair and see what I get.

Daniel Warren
Unix System Admin,Compliance Infrastructure Architect, ITServices
MCMC LLC


On Tue, Mar 29, 2016 at 6:55 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Warren, Daniel posted on Tue, 29 Mar 2016 16:21:28 -0400 as excerpted:
>
>> I'm running 4.4.0 from deb sid
>
> Correction.
>
> According to the kernel panic you posted at...
>
> http://pastebin.com/aBF6XmzA
>
> ... you're running kernel 3.16.something.
>
> You might be running btrfs-progs userspace 4.4.0, but on mounted
> filesystems it's the kernel code that counts, not the userspace code.
>
> Btrfs is still stabilizing, and kernel 3.16 is ancient history.  On this
> list we're forward focused and track mainline.  If your distro supports
> btrfs on that old a kernel, that's their business, but we don't track
> what patches they may or may not have backported and thus can't really
> support it here very well, so in that case, you really should be looking
> to your distro for that support, as they know what they've backported and
> what they haven't, and are thus in a far better position to provide that
> support.
>
> On this list, meanwhile, we recommend one of two kernel tracks, both
> mainline, current or LTS.  On current we recommend and provide the best
> support for the latest two kernel series.  With 4.5 out that's 4.5 and
> 4.4.
>
> On the LTS track, the former position was similar, the latest two LTS
> kernel series, with 4.4 being the latest and 4.1 the previous one.
> However, as btrfs has matured, now the second LTS series back, 3.18,
> wasn't bad, and while we still really recommend the last couple LTS
> series, we do recognize that some people will still be on 3.18 and we
> still do our best to support them as well.
>
> But before 3.18, and on non-mainline-LTS kernels more than two back, so
> currently 4.4, while we'll still do the best we can, unless it's a known
> issue recognizable on sight, very often that best is simply to ask that
> people upgrade to something reasonably current and report back with their
> results then, if the problem remains.
>
> As for btrfs-progs userspace, during normal operations, most of the time
> the userspace code simply calls the appropriate kernel functionality to
> do the real work, so userspace version isn't as important.  Mkfs.btrfs is
> an exception, and of course once the filesystem is having issues and
> you're using btrfs check or btrfs restore, along with other tools, to try
> to diagnose and fix the problem or at least to recover files off the
> unmountable filesystem, /then/ it's userspace code doing the work, and
> the userspace version becomes far more important.  And userspace is
> written to handle older kernels.
>
> For userspace, a good rule of thumb, therefore, is to run a version at
> least comparable to the kernel you're running.  The release series
> numbers are synced, and as long as you're following the kernel
> recommendations, running at least as new a userspace as the kernel will
> ensure your userspace doesn't get too old either.
>
>
> Bottom line for you, a 3.16 kernel is too old to practically support on
> this list.  Either check with your distro for support, or upgrade to at
> least the latest 3.18 LTS kernel, and preferably at least the latest 4.1
> LTS.
>
> Meanwhile, btrfs really is still stabilizing, and you may want to
> reconsider whether using a still stabilizing filesystem such as btrfs is
> compatible with your apparent desire to run really old and stale^H^Hble
> distros such as you seem to have chosen.  There are legitimate reasons to
> be conservative and choose really stable over the latest as yet unproven
> code, but such reasons tend to be incompatible with choosing a still
> stabilizing, definitely not yet fully stable and mature, filesystem such
> as btrfs remains at this point.  There's a very good chance that your
> interests will be best served by either choosing a distro and distro
> release that's rather more current, if you really want to follow not yet
> fully stable products such as btrfs, or that if you prefer stable and
> mature, you really should be on a more stable and mature filesystem,
> perhaps ext3 or ext4, or xfs, or the reiserfs that I used for years and
> that I still use on my spinning rust (I run btrfs on my ssds), as since
> it switched to data=ordered by default (as opposed to the data=writeback
> default that got reiserfs its bad stability reputation) it has in my own
> experience been incredibly stable, even on systems with hardware issues
> that made most filesystems (including a then much less stable and mature
> btrfs) unworkable.
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
