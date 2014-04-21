Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48060 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaDUFpI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 01:45:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wc72R-0006vV-4h
	for linux-btrfs@vger.kernel.org; Mon, 21 Apr 2014 07:45:07 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 07:45:07 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 07:45:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Do quota groups cost noticeable performance in 3.14?
Date: Mon, 21 Apr 2014 05:44:54 +0000 (UTC)
Message-ID: <pan$a2f12$b2daf6bc$70ff71c$1a6edc97@cox.net>
References: <20140420195901.GP7884@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 20 Apr 2014 12:59:01 -0700 as excerpted:

> I was looking at using qgroups for my backup server, which will be
> filled with millions of files in subvolumes with snapshots.
> 
> I read a warning that quota groups had performance issues, at least in
> the past.

Yes.  Additionally, there were serious bugs such that after subvolume 
deletes people would end up with negative quota usage!  Luckily I didn't 
need that for my use-case, but the recommendation for a couple kernels 
was definitely to avoid it for the time being, unless you were simply 
playing with it.  There were/are other filesystems with more mature quota 
solutions that actually work, if you're going to depend on it actually 
working.

> Is it still true?

Very good question.  Certainly both the qgroups bug reports and the 
patches have slowed down for 3.13/3.14 so it's gotta be better than it 
was, and while I don't use that feature and thus haven't been tracking it 
directly, I believe current status should be about where generic btrfs is 
at this point, that is, reasonably stable, but keep your backups tested 
and ready, just in case.

> If there is a performance issue, is it as simple as just turning off
> quota support and then things go back to normal?

IIRC yes, even back when the bugs were coming in right and left, that was 
basically the case -- WITH THE CAVEAT that back then anyway, a reboot was 
sometimes needed as the counts just weren't being updated correctly and 
people were getting some very weird results on deletion/disabling until 
reboot, sometimes.


Meanwhile, looking forward to your testing/reports/wiki-updates!  If you 
can do for qgroups what you've been doing for raid5/6 mode I'm sure a lot 
of folks (including me, I might not use it presently, but the better I 
understand it, the more effectively I can help others with questions) 
will be much edified. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

