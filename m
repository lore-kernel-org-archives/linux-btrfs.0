Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40051 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbcDPHiG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Apr 2016 03:38:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1arKns-0004hx-8e
	for linux-btrfs@vger.kernel.org; Sat, 16 Apr 2016 09:38:04 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Apr 2016 09:38:04 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Apr 2016 09:38:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID6, errors at missing device replacement
Date: Sat, 16 Apr 2016 07:37:48 +0000 (UTC)
Message-ID: <pan$8aea5$883c2a2a$18248a42$c1560bd9@cox.net>
References: <CAKWEGV65rRmpuRnUejCqVpdS+S5nbzrQnFAdy+y3X5EYZJgqpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yauhen Kharuzhy posted on Fri, 15 Apr 2016 12:49:36 -0700 as excerpted:

> I have discovered case when replacement of missing devices causes
> metadata corruption. Does anybody know anything about this?
> 
> I use 4.4.5 kernel with latest global spare patches.
> 
> If we have RAID6 (may be reproducible on RAID5 too) and try to replace
> one missing drive by other and after this try to remove another drive
> and replace it, plenty of errors are shown in the log:

I know you're working on testing the global spare patches, and thanks for 
that, you've already helped catch bugs that otherwise might conceivably 
have made it into the first release with the feature, such that they 
would likely have had to be fixed later, keeping the feature from 
stabilizing for some time.

Unfortunately, that seems to be what happened to the raid56 mode
recovery/repair/reshape/scrub patches, despite the long development time 
after the basic parity-writing "partial raid56 support" went in.  Unlike 
the global-spare patches, I don't recall the raid56 recover/... patches 
getting posted a kernel and userspace release cycle or more in advance 
and getting the type of independent review and testing that you're doing 
for global-spare, leading to multiple public revisions as issues were 
found and corrected.  Arguably, that only happened once (nominally) full 
functionality was in mainline, with the result being a kernel cycle and a 
half before raid56 was really working at all for recovery, and there 
still being issues over five cycles later.

And arguably, with patches for global-spare posted to the list and your 
well beyond cursory independent testing, global-spare should be far more 
mature on mainlining, with your efforts very possibly helping it avoid 
the same sort of issues.

Tho in all fairness, btrfs itself is maturing, and it may well be that 
either the raid56 experience directly led to the tougher but ultimately 
better process for global-spare, or the btrfs process itself is simply 
mature enough now that the raid56 situation wouldn't happen were it to be 
introduced now, either.

So two main points:

1) Due to raid56 mode itself still being somewhat immature, it may not be 
appropriate to use as a platform for testing further new features (like 
global spare) just yet -- global-spare testing with raid56 may either 
have to wait (i.e. skip it for now), or someone who's intimately familiar 
with the current known raid56 problems and able to recognize them on 
sight might need to do that testing, if it is to be done at this stage.

2) That's very much for your work testing global-spare, and of course to 
Anand Jain for posting the patches so you can. =:^)  Your work is 
directly contributing to it being more mature at mainline feature 
release, so that (unlike raid56) hopefully it can fast-stabilize once 
released, because of all the testing and work that is going in now, 
before mainlining and release. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

