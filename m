Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39011 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbcHIVcQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 17:32:16 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bXEdA-0007mb-L8
	for linux-btrfs@vger.kernel.org; Tue, 09 Aug 2016 23:32:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: system locked up with btrfs-transaction consuming 100% CPU
Date: Tue, 9 Aug 2016 21:32:06 +0000 (UTC)
Message-ID: <pan$40039$460e87d$113bf211$8f82b7dd@cox.net>
References: <CAGdWbB5aRffesaje-VSEOOH=O-rCWTqupLEu=BLdXurRU7dmtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave T posted on Tue, 09 Aug 2016 14:07:46 -0400 as excerpted:

> I hard reset my system, expecting the worst, but it rebooted normally.
> journalctl -xb -p3 showed no entries.

I don't have any suggestions for your primary problem, tho I do have a 
comment down below, but I do have a suggestion regarding your "hard 
reset".

Consider doing some reading on "magic sysrequest", aka sysrq aka srq.

$KERNDIR/Documentation/sysrq.txt , and there's lots of googlable articles 
about it as well.

Basically, when you'd otherwise do a hard reset, try a series of triple-
key chords, alt-sysrq-<otherkey> first.  (Sysrq is printscreen, if alt 
isn't pressed with it, so alt-sysrq-thirdkey.)

The longer form of the emergency sequence is reisub -- you can read what 
the r-e-i keys due in the documentation -- but from my own experience, I 
find when the system's in bad enough shape I need to do an emergency 
reboot, these keys don't do much for me, while the last three, sub, often 
(but not always) do, and they're much easier to remember, so...

Alt-sysrq-s alt-sysrq-u alt-sysrq-b

s=Sync.  If the kernel is still alive and believes it's still stable 
enough to write to permanent storage without risking writing somewhere it 
shouldn't, this will force all write-cached "dirty" data to be written 
out.

You can safely do an alt-srq-s at any time, and continue working, as it 
forces cached writes to be written out, but doesn't otherwise interfere 
with the running system.  As such, alt-srq-s is a useful sequence to use 
right before you do anything you suspect /might/ crash the system, like 
starting X with a new graphics driver.

u=remoUnt-read-only.  Again, if the kernel is alive and stable, this will 
remount all filesystems read-only, allowing them to safely clean up in 
the process.  The action carries down to sub-filesystem layers like 
dmcrypt as well.

Note that this is an emergency remount-read-only, so it's a bit more 
forceful regarding open files that would block an ordinary remount-
readonly.  As such, consider the system unusable after doing an alt-srq-
u, and shutdown or reboot immediately.

b=reBoot.  This forces the kernel to do an immediate reboot, without 
syncing or remounting, etc.  Thus the s-u- first, to sync and remount.


Besides being a bit safer than a hard reset, since when it works it 
allows the system to sync and cleanup the filesystems before the reboot, 
this also serves as a crude but effective method of finding out just how 
severely the system was locked up.  If the sync and remount steps light 
up your storage I/O activity LED, you know the kernel considered itself 
in pretty good shape, even if userspace was lost and there was no display 
at all.  If there's no response to them but the reboot step works, you 
know the kernel was still alive enough to respond, but either there 
wasn't anything dirty to write out, or more likely, the kernel believed 
itself to be corrupted, and thus didn't trust its ability to write to 
permanent storage without risking scribbling on other parts of the device 
(other files, perhaps even other partitions).  And of course if none of 
them work and you /do/ have to do a hard reboot, then you know the kernel 
itself was dead, at least to the point it could no longer respond at all 
to magic srq.


As to the comment... I'm running plasma/kde5 on gentoo, here, but I'm 
running upstream-kde's live-git version, available via the gentoo/kde 
overlay.  Some weeks ago, for a period, something wasn't working, and 
every time I left the system alone long enough to lock the screen and 
power-down the monitors, when I came back the system would be crashed.  
With a bit of experimentation, I discovered that it would stay running as 
long as I didn't let the monitors power off automatically (I could power 
them down manually, tho), so for awhile, I was running xset -dpmi after 
every X/plasma restart (I start X/plasma using startx from a text login 
and don't use a *DM), to keep plasma from powering down the graphics 
adapter, tho it could and did still run the screenlocker.

Since then, they fixed whatever it was and I can let the power-downs 
happen normally.  I don't believe the bug made it to a release, tho 
because I'm following live-git I'm not tracking the releases closely and 
could be mistaken.

You mentioned arch, which IIRC is pretty close to upstream's release 
cycle, so it's just possible that if this /did/ hit a release, and you're 
running a new enough kde/plasma, the problem you're seeing may be related 
to what I was experiencing.  Tho I doubt it since as I said it was only a 
short period, and I don't think the defective code made it into a release.

FWIW, tho, I'm running Radeon Turks graphics (hd6670, IIRC) with triple 
monitor and the native freedomware kernel/mesa/xorg driver, not frglx or 
whatever the proprietary thing is called.  If you're running Radeon, with 
the freedomware driver, especially if also running multi-monitor and the 
absolute latest plasma, you might try either downgrading a version to see 
if the problem goes away, or doing the xset -dpmi thing I was doing, 
temporarily.  It's just possible it'll help since your problem seems 
similarly to be triggering when you're away from the machine, but your 
problem does seem a bit different than mine (mine was a consistent 
crash), and I don't believe mine made release code anyway, so it's likely 
the similarity is just coincidence.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

