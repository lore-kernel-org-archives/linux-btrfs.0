Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55634 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760975AbbBJDg1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 22:36:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YL1cf-0001Jg-4y
	for linux-btrfs@vger.kernel.org; Tue, 10 Feb 2015 04:36:25 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 04:36:25 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 04:36:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Repair broken btrfs raid6?
Date: Tue, 10 Feb 2015 03:36:14 +0000 (UTC)
Message-ID: <pan$cda6d$176f5270$fba14a89$4e5f5430@cox.net>
References: <CAGwxe4gXPEOTPfNc2=0E0HAfDfTRKRcqqPjVJimbWJr5riz4DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tobias Holst posted on Mon, 09 Feb 2015 23:45:21 +0100 as excerpted:

> So a short summary:
> - btrfs raid6 on 3.19.0 with btrfs-progs 3.19-rc2
> - does not mount at boot up, "open_ctree failed" (disk 3)
> - mounts successfully after bootup
> - randomly "checksum verify failed" (disk 5)
> - balance and scrub crash after some time
> - after a while the volume gets unreadable, saying "parent transid
> verify failed" (disk 4 or 5)
> 
> And it looks like there still is no way to btrfsck a raid6.
> 
> Any ideas how to repair this filesystem?

(As a btrfs user/sysadmin and a list regular, not a dev, and not yet 
brave enough to try raid5/6 modes here...)

Btrfs raid6 should indeed be generally working in 3.19, including repair, 
yes.  Certainly, it's much closer to working than anything previous.

However, that code, while it actually exists now and is I believe in 
theory complete, is still very VERY new, and thus, it can be expected to 
be still quite buggy.  I've been telling people not to expect it to 
actually work for another kernel cycle (3.20), and even then, don't 
expect it to be as stable as the raid0/1/10 code, which after all has 
been in actual use for (well) over a year now, and thus has had a chance 
to have even many of the the not immediately obvious bugs show up and get 
worked out.  That'll take several more kernel cycles -- I've been 
suggesting that people not consider the raid56 code as stable as the 
earlier raid forms for another two cycles (3.22) at least.

HOWEVER, without claiming to speak for the devs working on it themselves, 
now that the code is actually there and it's time to start exterminating 
bugs in it, I expect they'll be very interested in your bug report, and 
if you're prepared to spend the time working thru it with them, applying 
patches, etc, you could well find your bugs fixed and be back operational 
before 3.20 or whatever. =:^)

Meanwhile, there's actually an integration branch with even newer code 
that hasn't hit release yet.  Given the still very new state of the 
btrfs56 mode code, if you're already brave enough to be running raid6 
mode and are having problems, your chances with integration are likely to 
be even better than with current release.  Of course it could break 
things worse too, but if you're already running raid56 mode I guess 
you're already prepared for that, and are either testing with throw-away 
data or data that's already well backed up, such that you're prepared to 
lose the btrfs raid6 copy of it in any case, so you might as well try 
integration...

See the wiki or other posts for the integration branch repos.  (As I said 
above I'm not brave enough to try raid56 yet, nor have I tried 
integration, so I don't have the links handy.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

