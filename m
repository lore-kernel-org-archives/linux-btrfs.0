Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38407 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbbJDCKH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Oct 2015 22:10:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZiYkD-0008SI-TJ
	for linux-btrfs@vger.kernel.org; Sun, 04 Oct 2015 04:09:46 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 04:09:45 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 04:09:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS as image store for KVM?
Date: Sun, 4 Oct 2015 02:09:39 +0000 (UTC)
Message-ID: <pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net>
References: <55F88ECC.1040604@menke.ac>
	<201510021421.09558.russell@coker.com.au> <560E737C.7050206@gmail.com>
	<201510031832.17802.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sat, 03 Oct 2015 18:32:17 +1000 as excerpted:

> Last time I checked a BTRFS RAID-1 filesystem would assign each process
> to read from one disk based on it's PID.  Every RAID-1 implementation
> that has any sort of performance optimisation will allow a single
> process that's reading to use both disks to some extent.
> 
> When the BTRFS developers spend some serious effort optimising for
> performance it will be useful to compare BTRFS and ZFS.

This is the example I use as to why btrfs isn't really stable, as well.  
Devs tend to be very aware of the dangers of premature optimization, 
because done too early, it either means throwing that work away when a 
rewrite comes, or it severely limits options as to what can be rewritten, 
if necessary, in ordered to avoid throwing all that work that went into 
optimization away.

So at least for devs that have been around awhile, that don't have some 
boss that's paying the bills saying optimize now, an actually really good 
mark of when the /devs/ consider something stable, is when they start 
focusing on that optimization.

Since this rather obvious low hanging fruit bit of optimization hasn't 
yet been done, then, there's really no question, btrfs doesn't pass the 
optimized stability test yet, and thus is self-evidently not stable, in 
the opinion of the very devs working on it.  Were they to really consider 
it stable, this optimization would already be done.

So once we see this optimization done, /then/ we can debate whether btrfs 
is stable yet, or not.  Until then, settled question, it's obviously 
not.  It may indeed be some distance into the process of stabilization, 
"stabiliz_ing_", and I'd characterize it as exactly that, but not yet, 
"stable".

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

