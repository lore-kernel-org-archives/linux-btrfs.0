Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56166 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbbHBDq0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 1 Aug 2015 23:46:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZLkEB-0005T9-W0
	for linux-btrfs@vger.kernel.org; Sun, 02 Aug 2015 05:46:24 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Aug 2015 05:46:23 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Aug 2015 05:46:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Data single *and* raid?
Date: Sun, 2 Aug 2015 03:46:17 +0000 (UTC)
Message-ID: <pan$2c3c8$edc30c0$3c253f51$8a661bd4@cox.net>
References: <55BD277F.2040201@friedels.name>
	<20150801203258.GA14352@carfax.org.uk>
	<CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
	<pan$7fbcf$6323c57d$e51a436f$80a59676@cox.net>
	<CAJCQCtQOa8_fcX_O9zop=mT0ABp=3XtJZ5N2SE2nrX7-0TvSpw@mail.gmail.com>
	<20150801223413.GC14352@carfax.org.uk>
	<pan$b8fa$cc3e43af$7e32a698$96ba80bb@cox.net>
	<CAJCQCtQqkUY=oRKFAx-0UaT-87STiDgD-vQ+gknkE5V2SzPb4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 01 Aug 2015 19:14:13 -0600 as excerpted:

> On Sat, Aug 1, 2015 at 6:27 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> 1) If this fs was created with btrfs-progs v4.1.1, get what you need to
>> retrieve off of it immediately, then blow it away and start over, as
>> the thing isn't stable and all data is at risk.
> 
> Agreed. But I'd go so far as to say at this point it looks like it's
> wedged itself into a kind of self-induced faux-ENOSPC state because
> there isn't room to allocate more raid5 chunks. So, I think it's stuck
> in any case.

Well, yes and no.  If it was setup with progs v4.1.1, save what you can 
and blow it away as it's not stable enough to try anything else.

If it was setup with something earlier (not sure about 4.1.0, was it 
affected? but 4.0.x and earlier should be fine for setup), however, once 
on a new kernel the usual ENOSPC workarounds can be given a try.  That 
would include a first balance start -dusage=0 -musage=0, and if that 
didn't free up at least a gig on a second device, I'd try the old add-a-
device trick and see what happens.  (A few GiB thumb drive should work in 
a pinch, or even a ramdrive if you're willing to risk loss in the event 
of a crash vaporizing everything in memory including the ramdrive.)

After all, even if he didn't know the risk of the still very new raid56 
mode before, he does after reading my earlier message, and anything of 
value should be backed up before he attempts anything, so at that point, 
there's nothing to lose and it's upto him whether he wants to simply blow 
away the current setup and start over with either raid1 or (with another 
device) raid10, avoiding the current risk of raid56, or blow away and 
start over with raid56 again, knowing the risks now, or try to recover 
what's there, viewing it not as the easiest way but as practice in 
disaster recovery, again, with anything of value backed up so there's 
nothing to lose besides the time of fiddling with it and ending up having 
to blow away and restart from backups anyway, regardless of how it goes.

> It'd be great to reproduce this with a current kernel and see if it's
> still happening.

Absolutely.

Tho at this point I believe the chances are pretty good it's simply 
either that bad 4.1.1 mkfs.btrfs, or an older pre-full-raid56-support 
kernel that didn't handle balance to raid56 so well, yet, and that on the 
latest userspace and kernel the problem shouldn't reoccur.

But it'd be nice to *KNOW* that, by trying to reproduce, absolutely.  He 
may well have stumbled upon yet another confirmation of my recommendation 
to wait on raid56 unless you're deliberately testing it, and confirmation 
thereof would be halfway to getting it fixed, so those who /do/ choose to 
wait won't be dealing with it. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

