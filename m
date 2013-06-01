Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51884 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3FADac (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 23:30:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UicWV-0003r0-0I
	for linux-btrfs@vger.kernel.org; Sat, 01 Jun 2013 05:30:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Jun 2013 05:30:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Jun 2013 05:30:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Merits of (auto)defrag on a mid-range ssd?
Date: Sat, 1 Jun 2013 03:30:14 +0000 (UTC)
Message-ID: <pan$9fb36$e8dd0021$54f93029$38e1c79f@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that I'm switching from reiserfs on rust to btrfs on ssd, I'm 
wondering about the autodefrag mount option.

The ssds are mid-range (Corsair Neutrons, NOT Neutron GTXs) so fragmented 
access shouldn't be anything like the problem it is on spinning rust, but 
I guess I should still keep fragmentation from getting /too/ far out of 
hand, as AFAIK that increases IOPS and there's obviously a limit on 
them.  Additionally, I suppose the additional metadata bookkeeping could 
eventually put further stress on btrfs in terms of concurrent ops, etc.

As I'm way overprovisioned (by about 100%, give or take depending on 
whether I decide to lay down a swap/s2d partition or not, s2r works well 
but s2d hasn't been due to video issues so I haven't been using that 
anyway, and I'm running 16 gigs RAM w/ half of it empty even of cache 
most of the time and power is quite stable here, so little real need for 
s2d /or/ swap), ssd limited write-cycles shouldn't be a big deal either 
way.

So for now I'm mounting with autodefrag, but honestly that's WAAYYY more 
because I'm still used to thinking about spinning rust that I'm almost 
afraid to turn it off, than it is about understanding the relative merits 
either way.

So I'm asking, what are other people doing on SSD, why, and are there any 
papers out there discussing the merits of defrag on mid-range SSDs, with 
btrfs or in general?

SSDs are so new to me I'm having a hard time getting my head turned 
around to think about them instead of spinning rust.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

