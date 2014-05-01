Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44300 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaEAQ6u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 May 2014 12:58:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WfuJq-0004AG-NC
	for linux-btrfs@vger.kernel.org; Thu, 01 May 2014 18:58:46 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 May 2014 18:58:46 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 May 2014 18:58:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Negative qgroup sizes
Date: Thu, 1 May 2014 16:58:34 +0000 (UTC)
Message-ID: <pan$cea24$895c4bc2$f096e7bb$50b7a75d@cox.net>
References: <53624D07.2000602@elastichosts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alin Dobre posted on Thu, 01 May 2014 14:32:55 +0100 as excerpted:

> I am having trouble with one of the btrfs subvolumes, as it shows
> negative quota accounting values

> Running a "btrfs quota rescan -w /tmp/test" seems to fix it, but it
> seems to come back pretty often (happened twice in the last couple of
> days).

> The kernel we are using is 3.14.1 (stable) and the btrfs-progs version
> is 3.12.

I'm not a qgroups user myself, but I know there were quite some 
complaints about negative numbers some months ago.  I hadn't seen any in 
awhile and had hoped the problems were all fixed, but now you're 
reporting them again, so I guess not.

Tho you are slightly outdated on your btrfs-progs version, 3.14.1 being 
current.  But I think the code in question is kernel code and the progs 
simply report it, so I don't think that can be the problem in this case.

The earlier recommendation, back when the problem reports were common, 
was not to use qgroups on btrfs as the code obviously wasn't accounting 
for something correctly.  Either use btrfs without qgroups, or if you 
really need quotas, use some other filesystem where the quota code works 
reliably.

As for the problems themselves, I saw some patches go by that fixed 
qgroups issues related to snapshot maintenance, and it's possible there's 
more work to do in that area.  The problem there is apparently due to the 
difficulty in properly accounting quotas for shared data, such that 
deleting old snapshots could turn things negative as the code subtracted 
the quota numbers repeatedly, once for each snapshot deleted, instead of 
properly figuring out what was shared and only subtracting for the data 
unique to that snapshot when it was deleted.

So if you are doing snapshots, you can try not doing them (switching to 
conventional backup if necessary) and see if that stabilizes your 
numbers.  If so, you know there's still more problems in that area.

Of course if the subvolumes involved aren't snapshotted, then the problem 
must be elsewhere, but I do know the snapshotting case /is/ reasonably 
difficult to get right... while staying within a reasonable performance 
envelope at least.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

