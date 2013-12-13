Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35015 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3LMJNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 04:13:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VrOoU-0000mn-Hv
	for linux-btrfs@vger.kernel.org; Fri, 13 Dec 2013 10:13:38 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 10:13:38 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 10:13:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid multiple devices IO utilisation
Date: Fri, 13 Dec 2013 09:13:14 +0000 (UTC)
Message-ID: <pan$46d7a$8ee1d67e$83395712$322d43d@cox.net>
References: <l8ce99$31i$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Thu, 12 Dec 2013 13:39:00 +0000 as excerpted:

> Some time back, I noticed that with a two HDD btrfs raid1, some tasks
> suffered ALL the IO getting choked onto just one HDD!
> 
> That turned out to be a feature of the btrfs code whereby a device is
> chosen depending on the process ID. For some cases such as in a bash
> loop, the PID increments by two for each iteration and so only one HDD
> ever gets hit...

Unfortunately, yes...

> So... Running with a 3-disk btrfs raid1 and... I still see the same
> problem for such as compile tasks where only one of the three disks is
> maxed out for periods with the other two disks left nearly idle.

It's worth noting that unfortunately, btrfs raid1 mode isn't "real" raid1 
at this point, at least not in the N-way-mirrored sense.  It's only two-
way-mirrored, regardless of the number of devices you throw at it, tho N-
way mirroring is roadmapped for introduction after raid5/6 functionality 
is fully implemented.  (The current raid5/6 implementation is missing 
some bits and is not considered production usable, as it doesn't handle 
rebuilds and scrubs well yet.)

So I'm guessing your 3-device btrfs raid1 is still stuck on the same even/
odd PID problem as before.

> Perhaps?...
> 
> Is there an easy fix in the code to allocate IO according to the
> following search order:
> 
> Last used disk with an IO queue < 2 items;
> 
> Any disk with an IO queue < 2 items;
> 
> Whichever disk with least queued items.

That does sound reasonable here.

FWIW, however, based on previous discussion here, the devs are aware of 
the alternating PID problem, and I /believe/ someone's already working on 
an alternate implementation using something else.  I think the current 
PID-based selector code was simply a first implementation to get 
something out there; not really intended to be a final working solution. 
IDR whether anything I've read discussed what algorithm they're working 
on, but given the sense your idea seems to make, at least at first glance 
at my sysadmin level of understanding, I wouldn't be surprised if the new 
solution does look something like it.  Of course that's if the queue 
length is reasonably accessible to btrfs, as you already asked in the bit 
I snipped as out of my knowledgeable reply range.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

