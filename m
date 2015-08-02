Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52000 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbbHBA1g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 1 Aug 2015 20:27:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZLh7m-0001nz-Mc
	for linux-btrfs@vger.kernel.org; Sun, 02 Aug 2015 02:27:34 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Aug 2015 02:27:34 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Aug 2015 02:27:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Data single *and* raid?
Date: Sun, 2 Aug 2015 00:27:29 +0000 (UTC)
Message-ID: <pan$b8fa$cc3e43af$7e32a698$96ba80bb@cox.net>
References: <55BD277F.2040201@friedels.name>
	<20150801203258.GA14352@carfax.org.uk>
	<CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
	<pan$7fbcf$6323c57d$e51a436f$80a59676@cox.net>
	<CAJCQCtQOa8_fcX_O9zop=mT0ABp=3XtJZ5N2SE2nrX7-0TvSpw@mail.gmail.com>
	<20150801223413.GC14352@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sat, 01 Aug 2015 22:34:13 +0000 as excerpted:

>> Yes and that also puts it in the realm of kernels that weren't
>> releasing/deallocating empty chunks; although I don't know if that's a
>> factor, if dconvert forcibly deals with this..
> 
>    It does -- you only have to look at the btrfs fi df output to see
> that there's no empty block groups (to within 0.1% or so)

Exactly.  The allocations are all full.

And the fi show says there's little to no room to allocate more, as 
well.  There's room on one device, but that's not going to help except 
with single, which shouldn't be allocated any more.

I'd say...

1) If this fs was created with btrfs-progs v4.1.1, get what you need to 
retrieve off of it immediately, then blow it away and start over, as the 
thing isn't stable and all data is at risk.

2) If it wasn't created with progs v4.1.1, the next issue is that kernel, 
since it's obviously from before raid56 was fully functional (well either 
that or there's a more serious bug going on).  Existing data should at 
least be reasonably stable, but with raid56 mode being so new, the newer 
the kernel you're using to work with it, the better.  4.1.x at LEAST, if 
not 4.2-rc, as we're nearing the end of the 4.2 development cycle.  And 
plan on keeping even better than normal backups and on current on kernels 
for at least another several kernel cycles, if you're going to use raid56 
mode, as while it's complete now, it's going to take a bit to stabilize 
to the level of the rest of btrfs itself, which of course is stabilizing 
now, but not really fully stable and mature yet, so the sysadmin's rule 
that data with any value is backed up, or by definition it's throw-away 
data, despite any claims to the contrary, continues to apply double on 
btrfs, compared to more mature and stable filesystems.

So definitely upgrade the kernel.  Then see where things stand.

3) Meanwhile, based on raid56 mode's newness, I've been recommending that 
people stay off it until 4.5-ish or so, basically a year after initial 
nominal full support, unless of course their intent is to be a leading/
bleeding edge testing and report deployment.  Otherwise, use raid1 or 
raid10 mode until then, and evaluate raid56 mode stability around 4.5, 
before deploying.

And if you're one of the brave doing current raid56 deployment, testing 
and bug reporting in full knowledge of its newness and lack of current 
stability and maturity, THANKS, it's your work that's helping to 
stabilize it for others, when they do switch to it. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

