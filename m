Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36036 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052Ab3GOMVL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 08:21:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UyhmA-0004sk-1T
	for linux-btrfs@vger.kernel.org; Mon, 15 Jul 2013 14:21:10 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 14:21:10 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 14:21:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: filebench varmail + scrubber = btrfs_update_root bug
Date: Mon, 15 Jul 2013 12:20:48 +0000 (UTC)
Message-ID: <pan$64e5e$e7160a3d$6a139672$eccc195d@cox.net>
References: <CABF9=8i1Bd6mVOR8kNZmQJa2UJLg9tiCojWHbN1HLVWhEh7_0g@mail.gmail.
	com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Amvrosiadis posted on Mon, 15 Jul 2013 00:56:29 -0400 as excerpted:

> I'm trying to run the varmail personality in filebench, on a 50GB btrfs
> filesystem. I am also starting the scrubber at the same time. I have
> applied the latest patches for 3.8.13 (hoping to fix log tree issues).
> Every time, after the scrubber completes, however, I get the following:

Quoting the second paragraph, in BOLD at the top of the main page of the 
btrfs wiki, here:

https://btrfs.wiki.kernel.org/index.php/Main_Page

Btrfs is under heavy development, but every effort is being made to keep 
the filesystem stable and fast. Because of the speed of development, you 
should run the latest kernel you can (either the latest release kernel 
from kernel.org, or the latest -rc kernel.


Kernel 3.8 is OLD for btrfs testing and the 3.x.y stable releases don't 
pick up all the fixes.  You're running a filesystem still marked 
experimental and under HEAVY development, and at two versions behind 
current 3.10 release (with 3.11-rc1 now out, altho I can understand being 
cautious enough not to want to run that early an rc), you are behind 
indeed, and missing critical btrfs fixes that have been applied in the 
last two kernel releases.

Here, I try to switch to a new kernel series (I run Linus mainstream git) 
about rc2 or so, by rc3 at the latest so there's time to resolve any new 
kernel problems I find and report, but even for the more conservative 
btrfs testers (who by definition are reasonably leading/bleeding edge or 
they'd not be running an experimental filesystem), rc4 or 5 should be 
quite stable and I'd recommend running it, unless there's a specific 
reported regression that affects you so you can't, and you're waiting on 
a fix.

In particular, I believe there's several fixes for just that sort of bug 
in 4.10, altho I'm not technical enough to parse the stack-trace and be 
sure about your specific issue, but I'd definitely recommend trying it.  
If you're still seeing the issue with 4.10, or with the latest 4.11 
series git checkout if you're brave enough to try it at the rc1 stage, 
/then/ it's time to report it here. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

