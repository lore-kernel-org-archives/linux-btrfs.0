Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38864 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab3LSSH3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 13:07:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vti0N-0001nb-TH
	for linux-btrfs@vger.kernel.org; Thu, 19 Dec 2013 19:07:27 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 19:07:27 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 19:07:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
Date: Thu, 19 Dec 2013 18:07:04 +0000 (UTC)
Message-ID: <pan$a2b51$7fd8f776$b8dead2a$ea511250@cox.net>
References: <52B2BBE1.8090306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Kastorff posted on Thu, 19 Dec 2013 01:26:57 -0800 as excerpted:

> I'm using btrfs in data and metadata RAID10 on drives (not on md or any
> other fanciness.)
> 
> I was removing a drive (btrfs dev del) and during that operation, a
> different drive in the array failed. Having not had this happen before,
> I shut down the machine immediately due to the extremely loud piezo
> buzzer on the drive controller card. I attempted to do so cleanly, but
> the buzzer cut through my patience and after 4 minutes I cut the power.
> 
> Afterwards, I located and removed the failed drive from the system, and
> then got back to linux. The array no longer mounts ("failed to read the
> system array on sdc"), with nearly identical messages when attempted
> with -o recovery and -o recovery,ro.

This may be a stupid question, but you're missing a drive so the 
filesystem will be degraded, but you didn't mention that in your mount 
options, so...

Did you try mounting with -o degraded (possibly with recovery, etc, also, 
but just try -o degraded plus any normal options first)?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

