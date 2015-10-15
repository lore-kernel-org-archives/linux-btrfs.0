Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43735 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbbJOB4D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 21:56:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZmXlw-0002e2-15
	for linux-btrfs@vger.kernel.org; Thu, 15 Oct 2015 03:56:00 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 03:56:00 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 03:56:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID6 stable enough for production?
Date: Thu, 15 Oct 2015 01:55:52 +0000 (UTC)
Message-ID: <pan$16580$b6f33d5b$f0553eee$33a96c4f@cox.net>
References: <2402569.dCkKzGyGNU@hoefnix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sjoerd posted on Wed, 14 Oct 2015 22:19:50 +0200 as excerpted:

> Is RAID6 still considered unstable so I shouldn't use it in production?
> The latest I could find about a test scenario is more than a year ago
> (http://marc.merlins.org/perso/btrfs/post_2014-03-23_Btrfs-Raid5-
Status.html)
> 
> I want to build a new NAS (6 disks of 4TB) on RAID6 and prefer to use
> btrfs over zfs, but the latter is proven stable and I am unsure about
> btrfs...

My general recommendation for new btrfs features is to let them stabilize 
for a year -- five kernel series -- after they are nominally complete, 
before you consider them roughly as stable as btrfs itself.  Given that 
btrfs itself is definitely stabilizing, but not yet fully stable and 
mature (a status that it's likely to maintain for... probably another 
year at least, IMO, I'll skip the supporting detail arguments here), that 
would be the "stable" target for new features, as well.

Since btrfs raid56 mode was nominally complete in 3.19, that would place 
"stable as btrfs in general" at 4.4, and raid56 mode does indeed seem to 
be healthy and maturing, with no new show-stopping bugs since 4.1, such 
that I'm reasonably confident in that 4.4 prediction.

Throwing in another variable, that of LTS-stable kernels, which are very 
likely to be the ones of interest to folks looking at production usage, 
the current two latest LTS series are 3.18, which was pre-raid56-
completion, and 4.1, which was just after the last known-to-date raid56 
show-stopping bug.

Given that situation and the above 4.4 prediction, the absolute earliest 
LTS-series "production" recommendation I could comfortably make would be 
4.1 series, after it has time to integrate any 4.4 series back-patches, 
so say around kernels 4.5 or possibly 4.6, but deploying (after site 
testing of course) the 4.1 LTS series as stable at that point.

An arguably more conservative position would be to declare the 4.1 LTS 
series still too early as it didn't originate after the year 
stabilization period, and wait for the next LTS series /after/ 4.4 
(possibly including 4.4 if it is picked up as such).  Once that series, 
whatever it may be, is declared LTS, start site-testing it, and deploy it 
after you're comfortable with the results of those tests, presumably at 
least a couple kernel cycles later, so if for example 4.4 itself is 
declared LTS, again, possibly around 4.6 or so, but deploying the LTS 
series not the just released kernel.

That of course is using my general btrfs feature stability rules as 
developed after some time as a regular on this list, not after any raid56 
specific experience as Donald Pearson and others in-thread are reporting, 
since my own use-case is btrfs raid1 mode (deployed as multiple small 
pair-device btrfs raid1 filesystems on partitioned SSDs, without use of 
the subvolume/snapshot or btrfs send/receive features).

Tho it can be noted that my recommendations and theirs dovetail at this 
point, that btrfs raid56 isn't ready /yet/ for production usage.  I'm 
just predicting based on general btrfs experience that given general 
experience, it should be "as ready as btrfs itself is" come 4.4 or the 
next LTS kernel series thereafter, whereas I don't read them as making 
such predictions at this point... which of course they couldn't, since a 
feature-specific experience-based recommendation obviously rests on 
current experience, and everyone appears to agree that it simply isn't 
there at this point.  I'm simply predicting that it well /could/ be, by 
LTS-after-4.4 time, even if it isn't, now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

