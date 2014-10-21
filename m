Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59271 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbaJULCJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 07:02:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XgXCU-0005zP-Sd
	for linux-btrfs@vger.kernel.org; Tue, 21 Oct 2014 13:02:02 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 13:02:02 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 13:02:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS with more than two parities
Date: Tue, 21 Oct 2014 11:01:50 +0000 (UTC)
Message-ID: <pan$d767e$1d30b489$62393364$27aa0a46@cox.net>
References: <D06BC9A8.4013C%ronnyegner@ronnyegner-consulting.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ronny Egner posted on Tue, 21 Oct 2014 06:28:34 +0000 as excerpted:

> Dear All,
> 
> i was wondering what happened with the patch posted by Andrea Mazzoleni
> back in Februrary 2014 (this Thread:
> http://thread.gmane.org/gmane.linux.kernel/1654735).
> 
> Why wash´t it added to the code? Something missing/wrong?
> 
> In my opinion the posted patch is awesome and would enable a unique
> feature to btrfs that no file system / volume manager on Linux and other
> UNIX-operating system currently has.

That, along with a bunch of other features, is on the longer term
roadmap and will likely eventually be implemented.  Actually, the 
discussion involves a quite flexible plan where number of 
redundancies/parities/strips-per-strip are all configurable along 
different/independent axes.

I wouldn't recommend expecting it any time soon, however, as btrfs 
features have repeatedly taken far longer to implement and become stable 
than originally predicted.

In fact, the big feature I've been waiting for, N-way-mirroring (current 
btrfs raid1 mode is 2-way-mirroring regardless of the number of devices, 
more devices simply adds more capacity), has been on the roadmap for 
implementation "right after raid56 mode" for something like two years 
now, with raid56 mode originally due to drop in kernel 3.5.

Needless to say, 3.5 came and went with no raid56.  So did 3.6 and 3.7 
and 3.8.  An incomplete implementation finally dropped as of 3.9, 
complete in normal operation but lacking a working scrub and reliable 
recovery.

That was 3.9, and 3.17 was recently released.  Two plus years since 
original planned drop and 12 kernel series later, a year and a half plus 
and 8 kernel series since the original partial implementation drop, raid56 
mode is still incomplete. tho some progress has been made.

Altho certainly the devs haven't been idle.  /Tremendous/ progress has 
been made in general btrfs stability in that time.  It's just that, well, 
stability /did/ become the overriding focus, and in that time, btrfs has 
gone from a definitely experimental filesystem that could and did often 
eat data, to one that's still not entirely stable and where backups for 
data of any value are still strongly recommended, but that works pretty 
well, most of the time for most users, including not only the traditional 
filesystem features, but even most of the existing non-traditional 
features that are (nearly) btrfs specific.

But the roadmap remains, after completion of raid56 mode, n-way-mirroring 
should be next.

And with a bit of luck, with n-way-mirroring will come a redo of the way 
btrfs handles mirrors/parity/stripes to fit into the larger framework 
with each one on its own access so they can be even more flexibly 
combined.  After all, some of that will be needed in ordered to 
accommodate n-way-mirroring anyway, and they might as well redo the 
framework for how it's all specified at the same time, since it has 
already been discussed and there's a vision there.

Of course with the experience I've had waiting for raid56 and knowing it 
wasn't the first feature to take much longer than anticipated, I don't 
really expect n-way-mirroring, at least complete and stable enough to be 
less risk rather than more compared to the current 2-way-mirroring raid1, 
to take much under a year, particularly if it introduces the raid-
framework redo along with it.

But once that is done, plugging in further raid expansions including 3+-
way-parity should be a comparatively minor detail.

But, I'd guess we're looking at at /least/ two years out, another couple 
kernel cycles anyway to complete raid56, say another year to complete n-
way-mirroring and the raid-framework redo, and another several kernel 
cycles after that for 3+-way-parity.  So realistically, 2-2.5 years, and 
that's assuming no 2+-year delays on n-way-mirroring as happened with 
raid56, and integration of the raid-framework redo into the same year's 
time I'm allowing for n-way-mirroring.  And given project history, that 
could /easily/ stretch to 5+ years.

So bottom line, as I said up top, it's on the roadmap, but don't expect 
it any time soon.  Realistically at least two years out, and it could be 
five...

Unless of course you have a spare kernel and filesystems developer or 
two, along with their sponsorship, to dedicate to the task.  Tho even 
then, given the time it'd take them to come upto speed and the testing 
the new raid-framework would take, a year and a half to two years out 
wouldn't be unreasonable.

FWIW, the other, more mature but not fully GPLv2 kernel license 
compatible alternative is Sun/Oracle's ZFS.  It's a mature filesystem 
with many promised btrfs features already implemented and long mature, 
but choosing it does mean either choosing a non-mainline kernel module 
with questionable legal issues (or the slower userspace code), or 
choosing a kernel other than Linux -- one of the implementing BSDs or 
Solaris.  That's the most viable current option for some would-be btrfs 
users, tho it's not so viable for others, for various reasons.

The other more general raid solution would be to get the n-way-parity 
code into the kernel's md- or dmraid implementations.  I've no idea what 
the status is there, but presumably they're considering it, and given 
btrfs implementation timetables, they may well have it implemented and 
stable long before btrfs does.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

