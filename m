Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37854 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbCODfw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Mar 2015 23:35:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YWzLB-0002jD-GV
	for linux-btrfs@vger.kernel.org; Sun, 15 Mar 2015 04:35:49 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Mar 2015 04:35:49 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Mar 2015 04:35:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid10 performance issues during copy and balance, only half
 the spindles used for reading data
Date: Sun, 15 Mar 2015 03:35:34 +0000 (UTC)
Message-ID: <pan$eb9d8$64fc2106$58d9b21f$dfb3c40f@cox.net>
References: <5504E0A3.3040908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sven Witterstein posted on Sun, 15 Mar 2015 02:30:11 +0100 as excerpted:

> Probably an option-parameter in analogy to (single-spindle pre-ssd ideas
> for the I/O scheduler) like
> 
> elevator=cfq (for btrfs="try to balance reads [...]
> 
> elevator=noop (assign by even/odd, current behavior (testing)
> 
> elevator=jumpy (every rand x secs switch stripeset [...]
> 
> would bring room to experiment in the years till 2020 as you outlined
> and to review,

The problem is, btrfs is what I've seen referred to as a target-rich 
environment, way more stuff to do than time to do it... at least 
reasonably correctly, anyway.

This in fact might be what eventually happens, and OK, 2020 is very 
possibly pessimistic, but if there's no time to code it as other things 
are taking priority or it'd simply complex enough it'll take several 
hundreds of manhours to get it coded, and predictably a good portion of 
that again to review it, commit it, chase down all the immediate bugs, 
and get them fixed, then there's no time to code it.

Which is exactly the problem with your proposal.  It's on the list, but 
so are several hundred other things... .  Well, that, and the 
programmer's adage about premature optimization.  But it's true, why 
spend several hundred hours optimizing this, and then have to throw the 
work away because when you go to add N-way-mirroring you discover some 
unforeseen angle makes your optimization a pessimisation now, or worse, 
discover you've cut off an avenue of better optimization that now won't 
be done because it's not worth spending that several hundred hours of 
development again.

Which is the beauty of the simplicity of the even/odd scheme.  It's so 
dead simple it's both easily demonstrated workable and hard to get wrong 
in terms of bugs, even if it's clearly not production-suitable.

Meanwhile, as I've said, other than raw breakage bugs this is one of the 
clearest demonstrations that btrfs really is /not/ a mature filesystem, 
despite the removal of all the dire warnings about it potentially eating 
your baby (data, that is) possibly leading some to the conclusion it's 
mature/stable/ready-for-production-use, because as you said this is 
clearly not production-suitable; it's clearly test-suitable.

> Interesting enough, all my other btrfses are single-SSD for operating
> system with auto-snap to be able to revert...
> and one is a 2-disk raid 0 for throw away data, so I never had a setup
> that would expose this behaviour...

I do hope you're reasonably thinning down those snapshots over time.  
Btrfs has a scalability issue when it comes to too many snapshots, and 
while they're instant to create as it's simply saving a bit of extra 
metadata, they're **NOT** instant to delete or to otherwise work with, 
once you get several hundred of them going.

Fortunately, it's easy enough to cut back a bit on the creation if 
necessary, so there's time to delete them too, and then to thin down to 
under say 300 or less per subvolume (and that's with original 
snapshotting at say half-hour intervals or more frequently!).  Say keep 
six hours of half-hour, then thin to hourly.  Keep the remainder of 24 
hours (18 hours) at hourly, and thin to say six-hourly... and so on.  It 
really is reasonably easy to keep it well under three-hundred snapshots 
per subvolume, even with half-hourly snapshotting, originally.

Also fortunately, should you really have to go back a full year, in 
practice, you're not normally going to care much about the individual 
hour and often not even the individual day.  Often, simply getting a 
snapshot from the correct week, or correct quarter, is enough, and it's a 
LOT easier to pick out when you've been doing proper thinning.

And if you're snapshotting multiple subvolumes per filesystem, try to 
keep total snapshots to a couple thousand or so if at all possible, and 
if you can get away with under a thousand total, do it. Because once you 
get into the thousands of snapshots, there's reports and reports of 
people complaining about how poorly btrfs scales when trying to do any 
filesystem maintenance at all, even on SSD.

Which is actually one of the things the devs have been spending major 
time on.  Scaling isn't good yet, but it's MUCH better than it was... 
basically unworkable at times.  Of course that's why snapshot-aware-
defrag is disabled ATM as well -- it was simply unworkable, and the 
thought was, better to let defrag work on the current copy and going 
forward, even if it breaks references and forces duplication of the 
defragged blocks, than to not have it working at all.

And FWIW, quotas are another scaling issue.  But they've always been 
bugged and not worked entirely correctly anyway, and as such, the 
recommendation has always been to disable then on btrfs unless you really 
need them, and if you really need them, better use a more mature 
filesystem where they work reliably, because you simply can't count on 
quotas actually working on btrfs.  Again, there has been major work 
invested here and it's getting better, but there's still corner-cases due 
to subvolume deletion where the quota math still simply doesn't work.  So 
while quotas are a scaling issue, it's not a major one, since quotas have 
to date never worked correctly anyway, so few actually use them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

