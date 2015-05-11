Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50038 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbbEKD4A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 May 2015 23:56:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yreou-0005DK-Uo
	for linux-btrfs@vger.kernel.org; Mon, 11 May 2015 05:55:57 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 05:55:56 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 05:55:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Are there plans for full btrfs filesystem backups?
Date: Mon, 11 May 2015 03:55:51 +0000 (UTC)
Message-ID: <pan$2bd31$990b002e$ebe891e2$76d0f14f@cox.net>
References: <20150510164944.GI16535@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 10 May 2015 09:49:44 -0700 as excerpted:

> Are there any plans for a full filesystem send/receive, not just a
> subvolume send/receive?

Recent discussion suggests yes, tho it's a relatively new plan.

More specifically, the recent discussion seemed to settle around the need 
for a send/receive --recursive option, which would recurse into nested 
subvolumes.  IIRC, the systemd folks requested that for their container 
management, among other things.  And if I remember the thread correctly, 
I /believe/ one of the devs said they agreed and were taking on the 
project.

That would of course allow recursing from ID5/the-root-subvolume, thus 
filling your request, but it would be more flexible than full filesystem 
send/receive, as it could handle arbitrary subvolume subtrees, too.

Previous to that, I don't believe it was on the roadmap.  It reads like a 
bunch of people, now including you, independently becoming aware that it 
was a problem at roughly the same time.


Meanwhile, there's another potential alternative as well, for the whole 
filesystem non-incremental case.  If you're backing up everything, you 
can of course dd/netcat the individual component devices making literal 
byte for byte copies, tho you'd want to do it to a remote machine, to 
avoid the kernel detecting a local copy as part of the same filesystem, 
due to UUID duplication.  But incrementals, parallel to send/receive with 
parent, would seem to be impractical.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

