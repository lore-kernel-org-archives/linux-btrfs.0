Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42897 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaL0E01 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Dec 2014 23:26:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y4ixM-0000J1-Bo
	for linux-btrfs@vger.kernel.org; Sat, 27 Dec 2014 05:26:24 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Dec 2014 05:26:24 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Dec 2014 05:26:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 04:26:10 +0000 (UTC)
Message-ID: <pan$248af$ca4818d4$b1ce7df3$527f91c1@cox.net>
References: <3738341.y7uRQFcLJH@merkaba> <6794875.ElpGA7E3Vr@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Fri, 26 Dec 2014 16:59:09 +0100 as excerpted:

> Dec 26 16:17:57 merkaba kernel: [ 8102.029438] mce:
> [Hardware Error]: Machine check events logged
> Dec 26 16:20:27 merkaba kernel: [ 8252.054015] mce:
> [Hardware Error]: Machine check events logged

Have you checked these MCEs?  What are they?

MCEs are hardware errors.  These are *NOT* kernel errors, tho of course 
they may /trigger/ kernel errors.  The reported event codes can be looked 
up and translated into English. 

Since shortly after the first one until a bit before the second one here, 
you had hardware thermal throttling, the CPUs, on-chip cache, and 
possibly the memory, was working pretty hard.

FWIW, I had an AMD machine that would MCE with memory related errors some 
time (about a decade) ago.  I had ECC RAM, but it was cheap and 
apparently not quite up to the speeds it was actually rated for.  MemTest 
check out the memory fine, but under high stress especially, it would 
sometimes have bus/transit related corruption, which would sometimes (not 
always) trigger those MCEs.

Eventually a BIOS update gave me the ability to turn down the memory 
timings, and turning them down just one notch made everything rock-stable 
-- I was even able to decrease some of the wait-states to get a bit of 
the memory speed back.  It just so happened that it was borderline stable 
at the rated clock, and turning the memory clock down just one notch was 
all it took.  Later, I upgraded the RAM (the bad RAM was two half-gig 
sticks, back when they were $100+ a piece, I upgraded to four 2-gig 
sticks), and the new RAM didn't have the problem at all -- the bad RAM 
sticks simply weren't /quite/ stable at the rated speed, that was it.

I run gentoo so of course do a lot of building from sources, and 
interestingly enough, the thing that turned out to detect the corruption 
the most often was bzip2 compression checksums -- I'd get errors on 
sources decompress previous to the build, rather more often than actual 
build failures altho those would happen occasionally as well, while 
redoing it would work fine -- checksums passed, and I never had a build 
that actually finished fail to run due to a bad build.

Now here's the thing.  Of course a decade ago was well before I was 
running btrfs (FWIW I was running reiserfs at the time, and it seemed 
pretty resilient given the bad RAM I had), so it was the bzip2 checksums 
it failed on.

But guess what btrfs uses for file integrity, checksums.  If your MCEs 
are either like my memory-related MCEs were, or are similar CPU-cache or 
CPU related but still something that would affect checksumming, btrfs may 
well be fighting bad checksums due to the same issues, and that would of 
course throw all sorts of wrenches into things.  Another thing I've seen 
reported as triggering MCEs is bad power (in that case it was an either 
underpowered or going bad UPS, once it was out of the picture, the MCEs 
and problems stopped).

Now I think you're having other btrfs issues as well, some of which are 
likely legit bugs.  However, your MCEs certainly aren't helping things, 
and I'd definitely recommend checking up on them to see what's actually 
happening to your hardware.  It may well be that without whatever 
hardware issues are triggering those MCEs, you may end up with less btrfs 
problems as well.

Or maybe not, but it's something to look into, because right now, 
regardless of whether they're making things worse physically, they're at 
minimum obscuring a troubleshooting picture that would be clearer without 
them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

