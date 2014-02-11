Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40684 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaBKV2V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 16:28:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WDKsO-0003fl-Ey
	for linux-btrfs@vger.kernel.org; Tue, 11 Feb 2014 22:28:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 22:28:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 22:28:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot
 when removing drive)
Date: Tue, 11 Feb 2014 21:27:56 +0000 (UTC)
Message-ID: <pan$c681a$3ae21a4d$ec4516c9$9237ffcf@cox.net>
References: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com>
	<E588F10F-919E-405C-8120-7375A2A6885B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 11 Feb 2014 11:15:56 -0700 as excerpted:

> The distros should be pressured to move to grub 2.02, currently in beta,
> upon release. And I think it would be good for Btrfs testers to build
> grub 2.02 beta, and try to break it with various Btrfs configurations so
> that it can be better tested grub release.

On the topic of grub minor update releases (and betas too), do you know 
where I can get a good grub-script-level sysadmin view of what has 
actually changed?

I'm running the betas, but a bit blind as the only update info I've been 
able to find is per-commit granularity, many commits per day, and I can't 
see the forest for all the trees!  I'd be far more comfortable with 
something rather more fuzzy than individual commits, but not so fuzzy and 
opaque as simply version number bumps.

This is of concern to me in part because I directly edit grub.cfg and 
includes, because the meta-level config "helpers" that are supposedly 
intended for "mere mortals" were far more fog than help to me, and I both 
couldn't get done what I wanted to do, and I needed to use the direct 
grub-script level commands anyway, and once I understood them, all the 
extra noise from the meta-level stuff was simply noisy cruft that 
obscured the real operation.  

Since I'm working at the direct grub-script level, I really need that 
level of detail on changes in updates as well.  Not the high-level-meta-
config stuff, not the per-commit stuff, something in between, analogous 
to the grub-script level but in a changelog.

And I need it for the betas as well as the full releases, since I'm 
running the betas.  Which means a changelog with the betas included so I 
could see what changed between betas as well as between general releases 
would be best.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

