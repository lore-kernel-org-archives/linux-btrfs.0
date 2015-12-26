Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40858 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbbLZEEv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 23:04:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aCg62-0004fb-G0
	for linux-btrfs@vger.kernel.org; Sat, 26 Dec 2015 05:04:46 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 05:04:46 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 05:04:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Deadlock after upgrade to 4.1
Date: Sat, 26 Dec 2015 04:04:40 +0000 (UTC)
Message-ID: <pan$aa512$87027746$2cff5c31$dbf2412c@cox.net>
References: <20151226070004.461eebaf@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Sat, 26 Dec 2015 07:00:04 +0500 as excerpted:

> On the first or second night after upgrade from a 3.18.21 kernel to
> 4.1.15,
> during concurrent heavy file operations (pruning old backups), I got
> into this deadlock(?).
> 
> After these messages any attempt to write to the affected filesystem
> would hang indefinitely, system load went to ~37, and there seemed to be
> no HDD activity.
> 
> It did not clear up in about 40 minutes, I ended up forcibly rebooting
> the machine.
> 
> Dunno how useful this is as a "new" bugreport, but maybe this looks
> familiar to someone, and perhaps this is something that is already fixed
> in 4.2/4.3?

I'm not a dev and the traces don't mean a lot to me, but as a list 
regular... 4.1 is the current latest LTS (tho 4.4 is soon to take the LTS 
"latest" label) and is thus well within the supported range.

(So is/was 3.18 as the second latest LTS, but it's about to lose that to 
4.1 when 4.4 becomes the latest, and the two latest LTS, as well as the 
two latest current kernels, are where the focus is, so 3.18 is already 
losing some focus as 4.4 nears.)

So this report would certainly seem to be a concern, the more so since 
others are no doubt working on upgrades from 3.18 as well.  Even if it's 
not happening in 4.3/4.4, that simply means LTS is still missing a 
patch.  Tho last I knew Greg was working his way out from a post-vacation 
patch backlog, so it's possible it's already in the queue.

Thanks for the report, particularly because as I said, others are likely 
to be upgrading ATM as well due to the status changes when 4.4 releases.  
I'm sure the devs will be looking at it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

