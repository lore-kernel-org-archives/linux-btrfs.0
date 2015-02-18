Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37647 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbbBRBMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 20:12:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YNtC2-0006px-25
	for linux-btrfs@vger.kernel.org; Wed, 18 Feb 2015 02:12:46 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2015 02:12:46 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2015 02:12:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid-1 uuid-fstab
Date: Wed, 18 Feb 2015 01:12:39 +0000 (UTC)
Message-ID: <pan$93af2$24f94d22$4d466b71$2bb509e4@cox.net>
References: <loom.20150214T001556-40@post.gmane.org>
	<CAJCQCtSRgOmUfNFdvxoU1m77m-K_oKvp-nFeyaR8VtuYZbacyg@mail.gmail.com>
	<pan$61fb6$e370d823$43b0d70$79a222c6@cox.net>
	<sgb6rb-2hv.ln1@hurikhan77.spdns.de>
	<pan$bfe1d$b1a37d6$247b6812$65dedebb@cox.net>
	<7aaarb-op3.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Tue, 17 Feb 2015 00:15:50 +0100 as excerpted:

> Long story short: I managed to strip dracut down to
> too few modules and it lost its ability to mount anything and even could
> not spawn a shell. *gnarf

Ouch!

FWIW, that's why I use a kernel built-in initramfs.  If I upgrade dracut 
or change its config and it fails to work, just as if the new kernel the 
initramfs is appended to fails to work, I simply boot an older kernel... 
with a known-working dracut-created initramfs.

Tho I /did/ have trouble with an older dracut locking to a particular 
default-root UUID at one point, so it would boot any root= I pointed it 
at, but *ONLY* as long as that particular UUID continued to exist!

Which is pretty hard to test for, since until you actually mkfs the 
existing default-root, its UUID will continue to exist, and you'll never 
know that your boot to the backup root using root= is working now, but 
will fail as soon as the default-root ceases to exist, until you're 
actually in the situation and can't boot, using any kernel/dracut 
combination!

That did drop me to the dracut/initramfs shell, but I was new enough with 
dracut at the time that I didn't really know how to fix it from there, 
nor could I properly edit a file or even view an entire file (cat worked, 
but that only let me see the last N lines and I didn't have a pager in 
the initramfs), to try to read documentation and fix the issue.

What I finally did to get out of that hole was manually ln -s the /dev/
disk/by-uuid/* symlink that the dracut/initramfs scripts were looking for 
based on the error, pointing it at an existing /dev/sdXN.  It didn't have 
to point at the root device, it could point at any device-block file, as 
long as that device-block file actually existed.

I didn't originally file a bug on that as the host-only option 
documentation warned about it being host-specific, so I figured it was 
/designed/ to do that.  Only later, when host-only was being discussed as 
the gentoo-recommended default on gentoo-dev and I explained that it 
wasn't always suitable as it broke if/when you blew away your default-
root and recreated it with a new UUID, and the gentoo dracut maintainer 
asked why I hadn't filed a bug, did I figure out it /was/ a bug, not a 
"confusingly documented feature".  So I filed a bug and the gentoo 
maintainer filed one upstream as well, and it was apparently fixed.  But 
of course by then I had long since worked around the problem with more 
specific dracut-module include and exclude statements in the config, 
instead of using host-only, and that was working and continues to work, 
so I've never had reason to go back and test the more loosely specified 
host-only mode, and thus have never confirmed whether the bug was 
actually fixed or not, since I don't use that mode any more.

> And when that wasn't fun enough, my BIOS decided to no longer initialize
> USB so I could neither get into BIOS nor into Grub shell. I don't know
> when that problem happened. Probably been that for a while and I never
> noticed. Just that it went a lot slower through BIOS after I managed to
> convince it to initialize USB again (by opening the case and shorting
> the reset jumper).

Ouch.  FWIW my mobo has dual-bios, which is nice, but I've been down the 
bios-reset road before, several times.

I even had a BIOS update go bad once (due to bad RAM), screwed up the 
last-ditch bios-rescue it offered as I didn't know what I was doing, and 
had to use my netbook to setup a webmail account (didn't have the 
passwords to my normal email as I don't normally keep anything private on 
the netbook at all, in case I lose it, and couldn't access my other disks 
without a device to convert them to external/USB) and order a new BIOS 
shipped to me.

That is of course the big reason my new machine is dual-bios! =:^)  Tho 
it's not an absolute cure-all, as once it successfully boots from the 
main BIOS it auto-overwrites the second one, if different.  I'd actually 
rather make the auto-overwrite bit manual, so I could update it only when 
I was sufficiently sure it worked _reliably_, but oh, well, better than 
not having a backup BIOS at all, as I learned from experience!

> The next fun part was: My backup was incomplete in a special way: It had
> no directories dev, proc, run, sys and friends... Don't ask me how I
> solved that, probably by "init=/bin/bash".

init=/bin/bash is indeed a very handy tool to have as a sysadmin. =:^)

I think I mentioned that setting that (via grub var) is actually one of 
my grub2 menu options, in the backup menu, FWIW.

> It happens, because I used
> "rsync" with the option to exclude those dirs. But well: In the end by
> backup was tested bootable. :-)
> 
> I fixed by dracut setup and in the same procedure also fixed a
> long-standing issue with "btrfs check" telling me nlink errors. Luckily,
> this newer version could tell me the paths and I just delete those files
> in the chrome profile and var/lib/bluetooth directory. I wonder if those
> errors were causing me issues with chrome freezing the PC and bluetooth
> stopped working sometimes.

Likely.

With all my filesystems being rather small, and having (tested) backup 
versions of them available, I'd probably just ensure that I had a current 
backup, blow the filesystem away and recreate it fresh, restoring from 
backup, at the first sign of nlink errors or the like.

> And BTW: bcache is pretty fast, booting to graphical.target within 3-8
> seconds (mostly around 5). Now I wonder what I need the resume swap for
> which I created in the process: It takes longer to resume from swap than
> just booting to complete KDE desktop. Well, without the benefit of
> having a fully running session at least.

Since my main filesystems are all on ssd, I get that too.  Tho I can say 
I was rather surprised at how much faster systemd was than even 
parallelized openrc.  Systemd's demand-based socket setup, not making 
final initialization of a daemon thru opening the socket a necessity 
before starting other services that depend on that socket, probably has a 
lot to do with that.  Openrc can parallelize, but if a daemon must be up 
and a socket it creates usable before another service depending on it can 
start, it must be, and openrc doesn't have the demand-based socket 
activation available to shortcut that, as systemd does.  That makes more 
difference than I expected.

As for resume-swap, back when my system was still on spinning rust, yes, 
resume took longer, dramatically longer if I made the resume image big 
enough to save and restore everything in cache, but it was still worth 
it, because dropping cache as one did on reboot was EXPENSIVE, due to 
having to reload all that stuff from slow spinning-rust over time.

But now that most of the system's on ssd (basically everything but the 
media partition, with media being primarily serially accessed big files 
anyway, such that speed doesn't make so much difference as long as it's 
faster than the play-rate consumption, as even spinning-rust is for most 
media... tho full 4k video may change that) cache is still faster, but 
more like an order of magnitude faster instead of about three orders of 
magnitude faster.

So dropping and having to reread gigabytes of cached files off of ssd 
isn't the big deal it was when it was gigabytes of cached files off of 
spinning rust.

But bcache will get most of that benefit, too.  I went full ssd instead, 
both because I did it a bit earlier, before bcache was mature, and 
because ssds became cheap enough for my limited non-media requirements 
that I decided it was worth throwing the required money at it, to avoid 
the hassle of ssd-cache-of-still-spinning-rust vs. just ssd pretty much 
everything.

But bigger ssds have continued to drop in price, and even my media files 
requirements aren't /that/ big, particularly as local storage 
increasingly is simply cache for media otherwise streamed from the net 
anyway (they're advertising "gigablast" here, now, tho my own connection 
remains under single-digit MiByte/sec, in-single-digit Mbit/sec), so I'll 
probably just go full ssd, even for media files, at some point, if only 
to be able to kill off the constant incremental power draw and noise of 
spinning-rust, entirely.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

