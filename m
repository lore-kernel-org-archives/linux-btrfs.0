Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39917 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbcASNzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 08:55:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aLWkS-0005cX-33
	for linux-btrfs@vger.kernel.org; Tue, 19 Jan 2016 14:55:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 14:55:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 14:55:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: FS corruption when mounting non-degraded after mounting
 degraded
Date: Tue, 19 Jan 2016 13:54:58 +0000 (UTC)
Message-ID: <pan$a4844$bd143cc5$12ca4a6e$4f571b46@cox.net>
References: <alpine.OSX.2.20.1601190308520.34954@ioko>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rian Hunter posted on Tue, 19 Jan 2016 03:28:53 -0800 as excerpted:

> Nothing was corrupted before I mounted the soft-failing disk in
> non-degraded mode. This leads me to believe that btrfs doesn't
> intelligently handle remounting normally previously degraded arrays. Can
> anyone confirm this?

Two things:

1) Critical:  I see absolutely no mention of the kernel version you were/
are using.  Btrfs raid56 mode is reasonably new and was only nominally 
complete with kernel 3.19.  Both 3.19 and 4.0 still had quickly known 
bugs in raid56 mode, however, and should be out of use now as neither one 
was an LTS kernel, and obviously anything 3.18 and earlier shouldn't be 
used for raid56 mode either as it wasn't even complete at that point.  
Beyond that, the recommendation has always been to wait for awhile if you 
need anything like stable, with my own recommendation being at least a 
year, five releases cyles, after full-feature introduction, and then 
looking at reports on the list, before considering it stable.

So LTS 4.1 still isn't stable for raid56 mode, 4.2 is already out of the 
last couple current kernel releases window, and 4.3, while to my 
knowledge not having any critical known raid56 bugs, is still within that 
year stabilization window, which means with 4.4 out you should be on it, 
unless there's a specific bug in it that is preventing that at this point.

The just released 4.4 is the first kernel that could meet the year-
minimum-to-stabilize criteria, and it's LTS, which means it has the 
/potential/ of being the first kernel I'd consider btrfs raid56 mode as 
stable as the rest of btrfs.  But 4.4 is still new enough we don't /know/ 
that yet, and while it's an LTS and hopefully will eventually be 
reasonably stable for raid56 mode, there's no reason beyond the simple 
first-release-after-1-year timing to suggest that it actually /is/ at 
that level yet, as it simply hasn't been out long enough to know.

So, particularly with btrfs raid56 mode, running the latest kernel is 
absolutely critical, and if you're not on kernel 4.4 yet, you definitely 
should be if you're running raid56 mode.

And even 4.4 shouldn't really be considered raid56 mode stable yet.  It 
might be, but we simply don't have the data for it one way or the other 
yet.

And given that you didn't mention kernel version at all, where kernel 
version is so critical, a reasonable assumption would be that you didn't 
do due-diligence research before deploying on raid56 and no nothing about 
it, so who knows /what/ old kernel you might be using?

Meanwhile, btrfs itself is, as frequently stated on this list, 
"stabilizING, but not entirely stable and mature yet."  IOW, even for 
single-device btrfs or the more mature raid0/1/10 modes, btrfs isn't 
"production ready stable", even if it's stable /enough/ that many both on 
this list and in the wider Linux distro world are using it as a "daily 
driver", hopefully with backups available and ready, since it /is/ still 
stabilizing and maturing.  Of course the sysadmin's rule of backups even 
for mature filesystems says, in simplest form, that if you don't have at 
least one backup, that by your actions, you're defining the data as worth 
less than the time and resources necessary to do the backup, despite any 
verbal/written claims to the contrary, and with btrfs not yet fully 
stable and btrfs raid56 even less so, that means on btrfs raid56, you 
REALLY have backups or you REALLY are declaring the data of trivial 
value, at best.

So by all means, use btrfs if you have appropriate backups and are 
willing to use them, but don't expect btrfs raid56 mode to be stable yet, 
particularly on kernels before the just-released 4.4, because it simply 
isn't.


2) Specifically regarding your posted point, I don't personally use raid56 
yet, and don't understand its limitations as well as I do the raid1 mode 
I do use, but it wouldn't surprise me if indeed adding an old device 
after the filesystem has moved on could indeed cause problems, 
particularly in a rebuild from degraded environment.

Btrfs raid1 mode has a similar but more limited don't-do-this case -- it 
should be OK in the situation you mentioned, but it's strongly 
recommended not to separate the two copies, mount each one writable 
separately, and then try to use them together, as that's an invitation to 
corruption.  Rather, if raid1 components must be separated, care should 
be taken to mount just one degraded,rw, if it's at all planned to mount 
them together, undegraded, again (and if that's done, a scrub is needed, 
at minimum, to catch the older device data back up to the newer one(s)).  
In the event that both /do/ get separately mounted rw, the only way to 
properly use them combined again is to wipe one or the other, and add it 
again as a new device.

And with parity rebuilds there's a generally known non-btrfs-specific 
rebuild hole where parity rebuilds can corrupt under the wrong 
circumstances already.  I've never taken the time to fully dig into the 
technical details so don't claim to fully understand the hole and thus 
don't know for sure if you obviously triggered it, but I know it's 
there.  And because btrfs does per-chunk raid rather than whole-device 
raid, it's possible you triggered it in the btrfs case even if you 
wouldn't have in the general case.  But I'll defer to the more 
knowledgeable for the specifics there.


Meanwhile... these facts are no secret.  The non-btrfs-specific parity 
rebuild hole is well known, as is the fact that btrfs raid56 mode isn't 
yet mature.  Anyone doing due-diligence pre-deployment research should 
have come across the latter repeatedly on this list as well as on the 
btrfs wiki, and the former repeatedly in general discussions of parity-
raid.

So I'd say, restore from the backup you certainly had if the data was of 
any value at all, and call it good.  And if you didn't have that backup, 
well, your actions declared the data of trivial value at best, so be 
happy, because you saved what your actions defined as of higher value, 
the time and resources you would have put into the backup had you done 
it.  So you can still call it good!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

