Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44785 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbaKHEE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 23:04:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XmxGj-0006gn-CF
	for linux-btrfs@vger.kernel.org; Sat, 08 Nov 2014 05:04:57 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Nov 2014 05:04:57 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Nov 2014 05:04:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: corruption, bad block, input/output errors - do i run --repair?
Date: Sat, 8 Nov 2014 04:04:45 +0000 (UTC)
Message-ID: <pan$4647a$3e6e327a$4051c8f5$2fb711d5@cox.net>
References: <545CD848.8070308@techsquare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matt McKinnon posted on Fri, 07 Nov 2014 09:33:44 -0500 as excerpted:

> I'm running into some corruption and I wanted to seek out advice on
> whether or not to run btrfs check --repair, or if I should fall back to
> my backup file server, or both.
> 
> The system is mountable, and usable.
> 
> # uname -a
> Linux cbmm-fs 3.17.2-custom #1 SMP Thu Oct 30 14:09:57 EDT 2014
> x86_64 x86_64 x86_64 GNU/Linux
> 
> # btrfs --version Btrfs v3.14.2

> I did run into some RO snapshot corruption [...]

> I have been sending incremental snapshot dumps over to an identical file
> server as backups.  Everything checks out OK there.  Do I try to run
> check with --repair first, and fall back to my backup if that fails?


It looks like you may already know about the early 3.17 series RO-
snapshot corruption bug, which you appear to have had, either from the 
list or from elsewhere, but apparently haven't been following the list 
closely enough to have noted the fix.

Kernel 3.17.2, which you have, fixed the bug causing the problem, which 
only affected earlier 3.17 series kernels and only filesystems with read-
only snapshots.

But that didn't entirely fix the problem for people (apparently including 
you) who had already experienced corruption on their filesystems due to 
it, since that didn't fix existing damage, only prevent new damage.

The fix for existing damage is *ONLY* in btrfs-progs 3.17 or newer.  With 
it, running btrfs check --repair should fix existing damage.

*HOWEVER*, attempting to repair the damage with btrfs check --repair with 
btrfs-progs versions PRIOR TO 3.17 WILL MAKE IT WORSE, basically 
unrecoverable using existing tools.

So for this specific damage, running btrfs check --repair from btrfs-progs 
3.17 or newer should fix it.  Do NOT attempt to repair it with earlier 
btrfs-progs versions.


More generally, as recently discussed here in the "Compatibility matrix 
kernels/tools" thread from last week, while any recent kernel version 
should in general work with any recent userspace, and while keeping 
reasonably current on kernels is strongly recommended as older ones have 
now-fixed bugs that may trigger damage in some cases, keeping userspace 
current isn't generally as vital, AS LONG AS you're primarily running 
"online" tools (in general those that work with mounted filesystems), 
which normally do their work via kernel calls anyway.  In that case, the 
most you will be missing is some of the newer features.

HOWEVER, once you get into the offline userspace tools like btrfs check 
and btrfs restore, where the functionality is either fixing damaged 
filesystems or retrieving data off of them while unmounted, a current 
btrfs userspace becomes MUCH more important, since then it's the 
userspace code working on the filesystem.

Which is what we see here.  A kernel bug started creating damage in 
certain corner cases but was relatively rapidly fixed.  However, that fix 
only kept it from creating further damage, it didn't do anything to 
correct existing filesystem damage of that type.  That's where the 
userspace fix comes in, fixing existing damage.  However, only the newest 
btrfs-progs (userspace) has the fixes to correct the existing damage 
properly.  Older versions, including the 3.14.2 you're running, could see 
some damage -- they detect that something isn't right-- but didn't 
understand the problem and if they were used to try to fix it, would 
instead make the problem worse.


So... applying that to your specific case:

Kernel 3.17.2 has the kernel fix and won't cause more damage.

Your 3.14.2 userspace is too old to fix the existing damage, however.

Since you have been wise enough to have backups, you are thus left with 
two choices:

1) Upgrade the userspace and fix the existing damage with the upgraded 
userspace btrfs check --repair.

2) Do a mkfs, thus eliminating the existing damage along with the data on 
the existing filesystem, and restore from backup to the new filesystem, 
recreated free of the damage.  Optionally upgrade the btrfs-progs 
userspace.

In either case, continue to run kernel 3.17.2 or newer so as not to have 
either this bug or the one that affected the 3.15 kernel and early 3.16, 
reappear.

Either way should work.  Here, if the existing filesystem was older than 
say kernel 3.14, I'd probably do the mkfs but do the optional userspace 
upgrade too, taking advantage of newer filesystem options such as skinny-
metadata and 16-KiB metadata nodes while I was at it.  If the filesystem 
was new and already took advantage of those features, I'd probably just 
do the userspace upgrade and btrfs check --repair.  But fortunately for 
you, unlike many unfortunate posters here you have a backup available, 
thus giving you the /choice/, and that choice is up to you. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

