Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53886 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaJOIxU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 04:53:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XeKKc-0007Qb-Hl
	for linux-btrfs@vger.kernel.org; Wed, 15 Oct 2014 10:53:18 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 10:53:18 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 10:53:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Random file system corruption in 3.17 (not BTRFS related...?)
Date: Wed, 15 Oct 2014 08:53:07 +0000 (UTC)
Message-ID: <pan$b3546$7415e0c6$dfeab81a$2cc63289@cox.net>
References: <543D555B.50708@pobox.com>
	<eff13bd09ee6883785a4be3ab005886b@miceliux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juan Orti Alcaine posted on Wed, 15 Oct 2014 09:08:14 +0200 as excerpted:

> I've also experienced Btrfs corruptions with 3.17.0

> I do readonly snapshots every hour of all the subvolumes, so I have
> hundreds of snapshots.

That's a known issue with read-only snapshots in 3.17.0.  There's quite a 
thread on the list about it.

So I'd suggest either turning off read-only snapshots on 3.17 (which I'm 
running here without snapshots, no problem), possibly switching to 
writable snapshots as they don't seem to trigger the problem, or as you 
mentioned doing already, going back to 3.16.x (x>2 due to another bug, 
latest should be good), until the read-only snapshots issue with 3.17.0 
is traced down and fixed.

Given the approximately two kernel cycles it took for the widely 
reproduced but rather difficult to trace compression-related bug in 3.15 
to be reported in 3.15 and traced and fixed in 3.17-rc2 and 3.16.2, I'd 
guess a fix for this similarly widely reproduced read-only-snapshot-
related bug should be no later than 3.19-rc3 and 3.18.3, possibly rather 
earlier if it proves easier to trace, especially since this one seems to 
have been reported and recognized as widely occurring a bit faster than 
the compression-related bug.  But with testing, etc, it's still likely to 
be late in the 3.18-rc cycle before mainline commit, so it'll probably be 
rather late in the 3.17.x stable cycle, if it makes it at all.  Unless it 
gets picked as a long-term support kernel, the full 3.17 stable cycle 
might in fact be blacklisted for btrfs due to this bug, much like the 
full 3.15 stable cycle ended up being blacklisted due to the compression-
related bug.

So either switch your snapshots to writable if it's not going to 
interfere with your use-case, or stay on the 3.16.x, x>2, stable series 
until the problem is fixed, hopefully with 3.18.0, tho it might be 3.18.2 
or so.  I seriously doubt it'll be longer than that, because it's a well 
reproduced bug which makes it both high priority and easy to test fixes 
for.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

