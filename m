Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52559 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaHJEED (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 00:04:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XGKMS-0003E2-OS
	for linux-btrfs@vger.kernel.org; Sun, 10 Aug 2014 06:04:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 06:04:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 06:04:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Date: Sun, 10 Aug 2014 04:03:47 +0000 (UTC)
Message-ID: <pan$bda9a$bcfe7d3f$f7527ba5$c0b77ff1@cox.net>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<20140809182113.GI12778@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 09 Aug 2014 11:21:13 -0700 as excerpted:

> You could argue that since 3.16.0 does not have the recently found
> deadlock patch that's been plaging 15 and 16 (14 not as much for me),
> it's not usable for some (it ran about 1 day on my laptop before
> deadlocking, and maybe an hour at most on my server).
> 
> I sure hope that deadlock patch is going to be added to the 3.16.x tree,
> I'm not super stocked with being stuck at 3.14.

Well, yes.

It'll almost certainly make it to the stable series including 3.16.x 
shortly after it ends up in the 3.17 development tree.  But the switch to 
worker-threads was only with 3.15, so anything previous to that doesn't 
need it (thus 3.14 working well for you, previous versions had other 
bugs), and 3.15 isn't a long-term-stable and Greg KH already warned that 
the just-Friday-released 3.15.9 is its penultimate release and people 
should be thinking about switching to 3.16, so pre-3.15 the patch isn't 
needed and whether it'll make it into 3.15.10, the last 3.15-series 
release, is questionable at this point, so 3.17-development or presumably 
3.16.1 or 3.16.2 looks to be the soonest it'll possibly happen for people 
not willing to cherrypick the patch from the list as soon as posted.

FWIW, 3.15 (where I didn't have time to try the development series and 
only upgraded about time it came out) and the 3.16 development series 
including the 3.16.0 release have worked well enough for me, but my btrfs 
are all on ssd, the ones I regularly mount all being raid1-pairs, and 
apparently on my 6-core at least, the bug is hard enough to trigger on 
ssd and I don't routinely push them hard enough to have seen it, thus 
explaining why I've not had problems with 3.15 and the 3.16 series up 
thru 3.16.0 release, beyond an instance that was either right about 3.15 
release or in 3.14, and might have been a one-off as it certainly was for 
me.

Tho while the problem has been pretty well traced so we know what it is, 
I'm not sure that a full patch for it has yet been posted on the list, 
has it?  I think it was nailed down too late in the week to prepare and 
pre-post test a patch before the weekend.  So I'd expect to see the patch 
on the list on Tuesday or so, just in time to make the last bit of the 
3.17 commit window (tho it's a stable-candidate fix so could go in later 
as well), but likely too late to make 3.15.10 and 3.16.1, so 3.17-rc1 or 
3.16.2 it'll likely be.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

