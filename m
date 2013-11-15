Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52072 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3KOQHs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 11:07:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhLvt-0004Ul-3y
	for linux-btrfs@vger.kernel.org; Fri, 15 Nov 2013 17:07:45 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 17:07:45 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 17:07:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Subvolume creation returns file exists
Date: Fri, 15 Nov 2013 16:07:22 +0000 (UTC)
Message-ID: <pan$8331$e81056a3$92e0314$93218fd5@cox.net>
References: <528630D6.5090103@elastichosts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alin Dobre posted on Fri, 15 Nov 2013 14:33:58 +0000 as excerpted:

> We are using btrfs filesystems in our infrastructure and, at some point
> of time, they start refusing to create new subvolumes.
> 
> Each file system is being quota initialized immediately after its
> creation

I'd suggest staying away from quotas on btrfs at this point.  There's 
something going on there that just doesn't work correctly, and a lot of 
folks have been reporting quota-related bugs.  So if your use-case needs 
quotes, try a different filesystem.  If it doesn't, consider disabling 
them for the time being (and reboot, since apparently some bits don't 
fully disable until after a reboot).

You can read the list for more detail.  AFAIK there's some very recent 
patches that address at least part of the problem, but they're recent 
enough I don't believe they're in 3.12, and the 3.13 commit-window pull 
was just requested in the last 24 hours or so, so they're likely not even 
in 3.13 yet.  Even then, however, I'd test for awhile before relying on 
btrfs quotas, because I'm not sure if the new patches fix all the bugs or 
simply fix enough for the next batch to make their appearance.

Meanwhile, it's worth noting what both the btrfs kernel option and the 
wiki[1] say about btrfs state: btrfs is still an experimental 
filesystem.  Don't use it with data you can't afford to lose (either make 
and test your backups to the point that you're comfortable with the 
possibility of full btrfs loss should the worst occur, or use only 
scratch data you don't care about losing in the first place), and DO keep 
updated, as btrfs development is quite rapid and every kernel includes 
fixes for known problems, some of which don't get ported back to stable-
series kernels.  If you're running 3.8, that means you're missing the 
fixes in 3.9-3.12, four full release kernel series!

There are reasons one may wish to run an older kernel, but in general 
they're not compatible with the reasons one might have for running an 
experimental filesystem such as btrfs.  Therefore, if you're going to 
test btrfs, please try to run a current release kernel, now 3.12, if not 
the development kernel, now 3.13. (FWIW, while I personally do run 
development kernels, I prefer not to switch to them until rc2 or so, at 
which point hopefully the worst data-risk bugs will be addressed.)  If 
you prefer to be more conservative and run older, more tested kernels, 
it's quite likely that the still experimental btrfs doesn't fit your use-
case very well either, and you should probably be using something 
considered more stable.

The same applies, tho to a bit lessor degree, to btrfs-progs. 0.19 is 
OLD.  Even 0.20-rc1, the latest rc, is about a year old!  Btrfs-progs 
development happens in branches that are only integrated to master once 
they're considered stable enough for release.  As a result and due to 
continued development, a build from a recent btrfs-progs git-master pull 
is always going to be the most stable and ideal testing version you can 
run.

FWIW, here's the version string from my btrfs-progs, updated a couple 
days ago (tho there's one known bug in it, related to doing a mkfs.btrfs 
on a sub-GiB filesystem, patch posted to list but as I've not updated in 
a couple days I don't know whether it's in master yet).

Btrfs v0.20-rc1-591-gc652e4e

[1] https://btrfs.wiki.kernel.org

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

