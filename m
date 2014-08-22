Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54151 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaHVSSD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 14:18:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XKtPR-0000Ws-UH
	for linux-btrfs@vger.kernel.org; Fri, 22 Aug 2014 20:17:57 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 20:17:57 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 20:17:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted
 in various ways
Date: Fri, 22 Aug 2014 18:17:38 +0000 (UTC)
Message-ID: <pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
References: <20140822155040.GU3875@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 22 Aug 2014 08:50:40 -0700 as excerpted:

> Fairly often (over 20 times for me so far with various kernel versions),
> when I reboot after a crash, my google-chrome profile is damaged in one
> of 2 ways:
> 1) open tabs don't reopen 2) google-chrome says that my profile is
> corrupted.
> 
> In both cases rsyncing ~/.config/google-chrome from the last hourly
> snapshot has fixed the problem every time.

I've had a similar issue with firefox, tho I've narrowed it down to a 
single file, IIRC preferences.js, which firefox keeps plenty of backups 
of (I see seven, going back quite some way), and recovering it from the 
last firefox backup or from my own backups has worked the three-ish times 
it happened here.  But it was a bit disconcerting to see firefox pop up 
its new profile wizard the first time it happened, and it took me awhile 
to figure out which file I needed to restore to get my skins and 
extensions back to normal.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

