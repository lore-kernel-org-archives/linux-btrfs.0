Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40609 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbbJDC2o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Oct 2015 22:28:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZiZ2X-00055o-18
	for linux-btrfs@vger.kernel.org; Sun, 04 Oct 2015 04:28:41 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 04:28:41 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 04:28:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID5 doesn't mount on boot, but you can afterwards?
Date: Sun, 4 Oct 2015 02:28:29 +0000 (UTC)
Message-ID: <pan$3b7e2$ac9e4b37$ac602701$c91b77c@cox.net>
References: <1627746.fEEz2JqgZk@hoefnix>
	<pan$b6f45$856590$f682594c$bd5aae60@cox.net> <1787237.MVYq6GNlXh@hoefnix>
	<20151001174615.GK25907@carfax.org.uk>
	<pan$f2728$e334692e$5f76fdfc$952e182b@cox.net>
	<003401d0fe1d$999b41a0$ccd1c4e0$@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

guido_kuenne posted on Sat, 03 Oct 2015 22:53:46 +0200 as excerpted:

> Beginner here, so just if it helps: My two-device raid 1 mounts on boot
> in Fedora 22 (uuid in fstab, no further devices specified) but I mount
> the fs via uuid while Sjoerd mounted subvolumes. From what I understand
> (not much) it's either an subvolume issue or Fedora must then somehow
> perform a device scan before handling fstab.

I'm guessing fedora has btrfs device scan in its initr*.

I believe dracut is a fedora based project and what they use to generate 
their initr*s.  I too use dracut for my initr* generation, and btrfs is 
an optional module which I obviously load (in a site-specific custom 
initr* here, on gentoo), and I know it has the btrfs device scan in the 
initr* here, so presumably it's in the general purpose initr* they use as 
well.  The only way it wouldn't would be if they didn't include the btrfs 
dracut module at all in their initr*, and I think btrfs is popular enough 
that they include it, so...

... So even if Fedora doesn't include btrfs device scan in the real-root 
init (which I'd guess it does as well), it's going to be in the initr*, 
which means unless the devices for that btrfs aren't plugged in until 
after boot, it should see them due to the scan at the initr* stage, and 
"just work", mounting the btrfs without problems at any time after that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

